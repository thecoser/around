// Join already-rendered sections through one encoder. Never modify the approved master.
import Foundation
import AVFoundation
let dir=URL(fileURLWithPath:FileManager.default.currentDirectoryPath).appendingPathComponent("data/recordings")
func t(_ seconds:Double)->CMTime { CMTime(seconds:seconds,preferredTimescale:60000) }
Task {
 do {
  let videoURL=dir.appendingPathComponent("around-submission-review-v5-video.mp4")
  let finalURL=dir.appendingPathComponent("around-submission-review-v5.mp4")
  guard !FileManager.default.fileExists(atPath:videoURL.path),!FileManager.default.fileExists(atPath:finalURL.path) else {fatalError("Preserving existing outputs")}
  let writer=try AVAssetWriter(outputURL:videoURL,fileType:.mp4)
  let input=AVAssetWriterInput(mediaType:.video,outputSettings:[AVVideoCodecKey:AVVideoCodecType.h264,AVVideoWidthKey:970,AVVideoHeightKey:920,AVVideoCompressionPropertiesKey:[AVVideoAverageBitRateKey:10_000_000,AVVideoExpectedSourceFrameRateKey:60,AVVideoMaxKeyFrameIntervalKey:60,AVVideoProfileLevelKey:AVVideoProfileLevelH264HighAutoLevel]])
  input.expectsMediaDataInRealTime=false;writer.add(input)
  let adaptor=AVAssetWriterInputPixelBufferAdaptor(assetWriterInput:input,sourcePixelBufferAttributes:[kCVPixelBufferPixelFormatTypeKey as String:kCVPixelFormatType_32BGRA,kCVPixelBufferWidthKey as String:970,kCVPixelBufferHeightKey as String:920])
  guard writer.startWriting() else {throw writer.error!};writer.startSession(atSourceTime:.zero)
  let segments:[(String,Double,Double,Double)]=[("around-ring-and-sample-review-v3.mp4",0,24,0),("around-demo-ring-sparkle.mp4",0,29.3,24),("around-ring-and-sample-review-v3.mp4",53.4,5.9,53.3)]
  var counts:[Int]=[]
  for (name,start,length,offset) in segments {
   let asset=AVURLAsset(url:dir.appendingPathComponent(name));let track=try await asset.loadTracks(withMediaType:.video)[0]
   let size=try await track.load(.naturalSize);guard size==CGSize(width:970,height:920) else {fatalError("Unexpected source size")}
   let reader=try AVAssetReader(asset:asset)
   reader.timeRange=CMTimeRange(start:t(start),duration:t(length))
   let output=AVAssetReaderTrackOutput(track:track,outputSettings:[kCVPixelBufferPixelFormatTypeKey as String:kCVPixelFormatType_32BGRA]);output.alwaysCopiesSampleData=false;reader.add(output)
   guard reader.startReading() else {throw reader.error!};var frames=0
   while let sample=output.copyNextSampleBuffer() {
    let pts=CMSampleBufferGetPresentationTimeStamp(sample)
    if CMTimeCompare(pts,t(start))<0 || CMTimeCompare(pts,t(start+length))>=0 {continue}
    let target=CMTimeAdd(CMTimeSubtract(pts,t(start)),t(offset))
    while !input.isReadyForMoreMediaData {try await Task.sleep(nanoseconds:1_000_000)}
    guard adaptor.append(CMSampleBufferGetImageBuffer(sample)!,withPresentationTime:target) else {throw writer.error!};frames+=1
   }
   guard reader.status == .completed else {throw reader.error!};counts.append(frames)
  }
  writer.endSession(atSourceTime:t(59.2));input.markAsFinished();await writer.finishWriting();guard writer.status == .completed else {throw writer.error!}
  let comp=AVMutableComposition();let v=comp.addMutableTrack(withMediaType:.video,preferredTrackID:kCMPersistentTrackID_Invalid)!;let a=comp.addMutableTrack(withMediaType:.audio,preferredTrackID:kCMPersistentTrackID_Invalid)!
  let rendered=AVURLAsset(url:videoURL), master=AVURLAsset(url:dir.appendingPathComponent("around-demo-ring-sparkle.mp4"))
  try v.insertTimeRange(CMTimeRange(start:.zero,duration:t(59.2)),of:try await rendered.loadTracks(withMediaType:.video)[0],at:.zero)
  try a.insertTimeRange(CMTimeRange(start:.zero,duration:t(29.3)),of:try await master.loadTracks(withMediaType:.audio)[0],at:t(24))
  let export=AVAssetExportSession(asset:comp,presetName:AVAssetExportPresetPassthrough)!;export.outputURL=finalURL;export.outputFileType = .mp4;export.shouldOptimizeForNetworkUse=true
  await export.export();guard export.status == .completed else {throw export.error!}
  let result=AVURLAsset(url:finalURL);let formats=try await result.loadTracks(withMediaType:.video)[0].load(.formatDescriptions)
  guard formats.count==1 else {fatalError("Expected one video configuration")}
  let manifest:[String:Any]=["output":finalURL.lastPathComponent,"duration":try await result.load(.duration).seconds,"segmentFrameCounts":counts,"sampleStart":24,"sampleDuration":29.3,"sampleAudio":"Original compressed audio inserted at24s, passthrough export, no mix or gain change","videoFormats":formats.count,"scope":"Edited saved real Ring results, explicit transition, complete approved sample, closing evidence limits. No new provider execution. Official Playground and unobscured sync footage remain pending.","review":"Render complete; visual and playback review pending."]
  try JSONSerialization.data(withJSONObject:manifest,options:[.prettyPrinted,.sortedKeys]).write(to:finalURL.deletingPathExtension().appendingPathExtension("json"))
  print(String(data:try JSONSerialization.data(withJSONObject:manifest,options:[.prettyPrinted,.sortedKeys]),encoding:.utf8)!);exit(0)
 } catch {print("Assembly failed: \(error)");exit(1)}
}
dispatchMain()
