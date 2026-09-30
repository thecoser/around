// Decode and re-encode every frame to one H.264 configuration for browser playback.
// AVAssetExportPresetHighestQuality can retain multiple AVC sample descriptions when joining clips.
import Foundation
import AVFoundation
let directory=URL(fileURLWithPath:FileManager.default.currentDirectoryPath).appendingPathComponent("data/recordings")
Task {
 do {
  let source=directory.appendingPathComponent(CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : "around-demo-with-logo.mp4")
  let destination=directory.appendingPathComponent(CommandLine.arguments.count > 2 ? CommandLine.arguments[2] : "around-demo-with-logo-compatible.mp4")
  guard !FileManager.default.fileExists(atPath:destination.path) else { fatalError("Preserving existing output") }
  let asset=AVURLAsset(url:source)
  let tracks=try await asset.loadTracks(withMediaType:.video)
  let duration=try await asset.load(.duration)
  let reader=try AVAssetReader(asset:asset)
  let output=AVAssetReaderVideoCompositionOutput(videoTracks:tracks,videoSettings:[kCVPixelBufferPixelFormatTypeKey as String:kCVPixelFormatType_32BGRA])
  let vc=AVMutableVideoComposition(); vc.renderSize=CGSize(width:970,height:920); vc.frameDuration=CMTime(value:1,timescale:60)
  let instruction=AVMutableVideoCompositionInstruction(); instruction.timeRange=CMTimeRange(start:.zero,duration:duration)
  let layer=AVMutableVideoCompositionLayerInstruction(assetTrack:tracks[0]); layer.setTransform(.identity,at:.zero)
  instruction.layerInstructions=[layer]; vc.instructions=[instruction]; output.videoComposition=vc
  reader.add(output)
  let writer=try AVAssetWriter(outputURL:destination,fileType:.mp4)
  writer.shouldOptimizeForNetworkUse=true
  let input=AVAssetWriterInput(mediaType:.video,outputSettings:[
   AVVideoCodecKey:AVVideoCodecType.h264,AVVideoWidthKey:970,AVVideoHeightKey:920,
   AVVideoColorPropertiesKey:[AVVideoColorPrimariesKey:AVVideoColorPrimaries_ITU_R_709_2,AVVideoTransferFunctionKey:AVVideoTransferFunction_ITU_R_709_2,AVVideoYCbCrMatrixKey:AVVideoYCbCrMatrix_ITU_R_709_2],
   AVVideoCompressionPropertiesKey:[AVVideoAverageBitRateKey:8_000_000,AVVideoExpectedSourceFrameRateKey:60,AVVideoMaxKeyFrameIntervalKey:60,AVVideoProfileLevelKey:AVVideoProfileLevelH264HighAutoLevel]])
  input.expectsMediaDataInRealTime=false; writer.add(input)
  guard reader.startReading(),writer.startWriting() else { throw reader.error ?? writer.error! }
  writer.startSession(atSourceTime:.zero)
  var frames=0
  while let sample=output.copyNextSampleBuffer() {
   while !input.isReadyForMoreMediaData { try await Task.sleep(nanoseconds:1_000_000) }
   guard input.append(sample) else { throw writer.error! }; frames += 1
  }
  guard reader.status == .completed else { throw reader.error! }
  input.markAsFinished(); await writer.finishWriting()
  guard writer.status == .completed else { throw writer.error! }
  let result=AVURLAsset(url:destination)
  let resultTrack=try await result.loadTracks(withMediaType:.video)[0]
  let formats=try await resultTrack.load(.formatDescriptions)
  guard formats.count == 1 else { fatalError("Expected one AVC format description") }
  let manifest:[String:Any]=["source":source.lastPathComponent,"output":destination.lastPathComponent,"frames":frames,"duration":try await result.load(.duration).seconds,"fps":try await resultTrack.load(.nominalFrameRate),"formatDescriptions":formats.count,"audioTracks":try await result.loadTracks(withMediaType:.audio).count,"repair":"Full decode and uniform H.264 re-encode. Original sources and earlier export preserved. No content, crop or timing changes."]
  let json=try JSONSerialization.data(withJSONObject:manifest,options:[.prettyPrinted,.sortedKeys])
  try json.write(to:destination.deletingPathExtension().appendingPathExtension("json"))
  print(String(data:json,encoding:.utf8)!); exit(0)
 } catch { print("Normalize failed: \(error)"); exit(1) }
}
dispatchMain()
