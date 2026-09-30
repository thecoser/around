// Local media edit only. Preserves approved sources and refuses output overwrites.
import Foundation
import AVFoundation
import CoreGraphics
import CoreText
import CoreImage
import ImageIO
let root=URL(fileURLWithPath:FileManager.default.currentDirectoryPath)
let dir=root.appendingPathComponent("data/recordings")
let W=970,H=920
func tm(_ seconds:Double)->CMTime {CMTime(value:Int64((seconds*600).rounded()),timescale:600)}
func text(_ c:CGContext,_ value:String,_ y:CGFloat,_ size:CGFloat,_ height:CGFloat,color:CGColor=CGColor(red:0.21,green:0.17,blue:0.15,alpha:1)) {
 let font=CTFontCreateWithName("Arial" as CFString,size,nil)
 let a=NSAttributedString(string:value,attributes:[NSAttributedString.Key(kCTFontAttributeName as String):font,NSAttributedString.Key(kCTForegroundColorAttributeName as String):color])
 let fs=CTFramesetterCreateWithAttributedString(a);let path=CGPath(rect:CGRect(x:44,y:CGFloat(H)-y-height,width:882,height:height),transform:nil)
 CTFrameDraw(CTFramesetterCreateFrame(fs,CFRange(location:0,length:0),path,nil),c)
}
func still(_ path:String)->CGImage {CGImageSourceCreateImageAtIndex(CGImageSourceCreateWithURL(dir.appendingPathComponent(path) as CFURL,nil)!,0,nil)!}
func buffer(_ img:CGImage?,crop:CGRect?,title:String,subtitle:String,footer:String)->CVPixelBuffer {
 var b:CVPixelBuffer?;CVPixelBufferCreate(nil,W,H,kCVPixelFormatType_32BGRA,[kCVPixelBufferCGImageCompatibilityKey:true,kCVPixelBufferCGBitmapContextCompatibilityKey:true] as CFDictionary,&b)
 CVPixelBufferLockBaseAddress(b!,[]);defer{CVPixelBufferUnlockBaseAddress(b!,[])}
 let c=CGContext(data:CVPixelBufferGetBaseAddress(b!),width:W,height:H,bitsPerComponent:8,bytesPerRow:CVPixelBufferGetBytesPerRow(b!),space:CGColorSpaceCreateDeviceRGB(),bitmapInfo:CGImageAlphaInfo.premultipliedFirst.rawValue|CGBitmapInfo.byteOrder32Little.rawValue)!
 c.setFillColor(CGColor(red:1,green:0.98,blue:0.96,alpha:1));c.fill(CGRect(x:0,y:0,width:W,height:H))
 c.setFillColor(CGColor(red:0.88,green:0.45,blue:0.26,alpha:1));c.fill(CGRect(x:44,y:CGFloat(H)-32,width:64,height:5))
 text(c,title,55,38,105);text(c,subtitle,165,25,125)
 if let im=img {let im=crop == nil ? im : im.cropping(to:crop!)!;let scale=min(882/CGFloat(im.width),460/CGFloat(im.height));let dw=CGFloat(im.width)*scale,dh=CGFloat(im.height)*scale;c.interpolationQuality = .high;c.draw(im,in:CGRect(x:(970-dw)/2,y:CGFloat(H)-320-dh,width:dw,height:dh))}
 text(c,footer,800,21,100)
 return b!
}
Task {do {
 let out=dir.appendingPathComponent("around-submission-review-v7-video.mp4"),final=dir.appendingPathComponent("around-submission-review-v7.mp4")
 guard !FileManager.default.fileExists(atPath:out.path),!FileManager.default.fileExists(atPath:final.path) else {fatalError("Preserving existing outputs")}
 let writer=try AVAssetWriter(outputURL:out,fileType:.mp4)
 let input=AVAssetWriterInput(mediaType:.video,outputSettings:[AVVideoCodecKey:AVVideoCodecType.h264,AVVideoWidthKey:W,AVVideoHeightKey:H,AVVideoCompressionPropertiesKey:[AVVideoAverageBitRateKey:10_000_000,AVVideoExpectedSourceFrameRateKey:60,AVVideoMaxKeyFrameIntervalKey:60]])
 writer.add(input);let adaptor=AVAssetWriterInputPixelBufferAdaptor(assetWriterInput:input,sourcePixelBufferAttributes:[kCVPixelBufferPixelFormatTypeKey as String:kCVPixelFormatType_32BGRA,kCVPixelBufferWidthKey as String:W,kCVPixelBufferHeightKey as String:H]);writer.startWriting();writer.startSession(atSourceTime:.zero)
 var frameIndex:Int64=0
 func append(_ b:CVPixelBuffer) async throws {while !input.isReadyForMoreMediaData {try await Task.sleep(nanoseconds:1_000_000)};guard adaptor.append(b,withPresentationTime:CMTime(value:frameIndex,timescale:60)) else {throw writer.error!};frameIndex+=1}
 func hold(_ b:CVPixelBuffer,_ seconds:Int) async throws {for _ in 0..<(seconds*60) {try await append(b)}}
 try await hold(buffer(still("private/control-crop-review/player-22.png"),crop:nil,title:"Official Ring Playground",subtitle:"Motion live-view control\nRecorded September 30, 2026",footer:"Control frame from the recording. This simulator control opens a live view; it does not emit a classified motion event."),3)
 func clip(_ path:String,_ start:Double,_ seconds:Int,_ crop:CGRect,_ title:String,_ subtitle:String,_ footer:String) async throws {
 let a=AVURLAsset(url:dir.appendingPathComponent(path));let g=AVAssetImageGenerator(asset:a);g.appliesPreferredTrackTransform=true;g.requestedTimeToleranceBefore = .zero;g.requestedTimeToleranceAfter = .zero
 for f in 0..<(seconds*60) {let im=try await g.image(at:tm(start+Double(f)/60));try await append(buffer(im.image,crop:crop,title:title,subtitle:subtitle,footer:footer))}
 }
 try await clip("private/around-playground-trace-2026-09-30.mov",30,6,CGRect(x:160,y:520,width:1040,height:465),"Playground video plays","Recorded simulator playback\nAPI trace and identifiers cropped out","“Birds on Feeders” by Michael Black on Vimeo, CC BY 4.0. Clipped by the Playground; this edit crops the picture.")
 print("Playground scenes rendered")
 try await clip("private/around-fresh-sync-2026-09-30.mov",60,5,CGRect(x:650,y:390,width:1710,height:670),"Around receives a new moment","Official device discovery and event history\nSuccessful sync, recorded in a separate take","Pauses and the browser password prompt are omitted. No Bedrock request was made during this capture.")
 try await hold(buffer(still("ring-evidence/fresh-record-still.png"),crop:CGRect(x:215,y:180,width:585,height:270),title:"A live-view request, accurately labeled",subtitle:"September 30 at 10:54 AM\nSaved record still captured after the recording",footer:"Three actual Ring records are stored. The new record does not establish detected motion, a visitor or an expectation match."),6)
 try await hold(buffer(nil,crop:nil,title:"Next: the sample visit",subtitle:"Sample activity with previously generated\nAmazon Bedrock results",footer:"The visit events in the following 29.3-second demo were not received from Ring. The approved sample appears once."),5)
 let sampleStart=Double(frameIndex)/60
 let master=AVURLAsset(url:dir.appendingPathComponent("around-demo-ring-sparkle.mp4"));let track=try await master.loadTracks(withMediaType:.video)[0]
 let reader=try AVAssetReader(asset:master);let output=AVAssetReaderTrackOutput(track:track,outputSettings:[kCVPixelBufferPixelFormatTypeKey as String:kCVPixelFormatType_32BGRA]);reader.add(output);reader.startReading();var sampleFrames=0
 while let s=output.copyNextSampleBuffer() {guard let b=CMSampleBufferGetImageBuffer(s) else {continue};try await append(b);sampleFrames+=1}
 guard reader.status == .completed,sampleFrames==1758 else {fatalError("Sample frame count changed")}
 try await hold(buffer(nil,crop:nil,title:"Around",subtitle:"Spatial intelligence for your home.\nA single-home prototype.",footer:"Timing does not confirm identity. The sample typing and microphone are edited visuals; voice input is not implemented."),5)
 let duration=Double(frameIndex)/60;writer.endSession(atSourceTime:CMTime(value:frameIndex,timescale:60));input.markAsFinished();await writer.finishWriting();guard writer.status == .completed else {throw writer.error!}
 let c=AVMutableComposition();let v=c.addMutableTrack(withMediaType:.video,preferredTrackID:kCMPersistentTrackID_Invalid)!,a=c.addMutableTrack(withMediaType:.audio,preferredTrackID:kCMPersistentTrackID_Invalid)!
 let rendered=AVURLAsset(url:out);try v.insertTimeRange(CMTimeRange(start:.zero,duration:tm(duration)),of:try await rendered.loadTracks(withMediaType:.video)[0],at:.zero)
 try a.insertTimeRange(CMTimeRange(start:.zero,duration:tm(29.3)),of:try await master.loadTracks(withMediaType:.audio)[0],at:tm(sampleStart))
 let ex=AVAssetExportSession(asset:c,presetName:AVAssetExportPresetPassthrough)!;ex.outputURL=final;ex.outputFileType = .mp4;ex.shouldOptimizeForNetworkUse=true;await ex.export();guard ex.status == .completed else {throw ex.error!}
 let manifest:[String:Any]=["output":final.lastPathComponent,"duration":duration,"sampleStart":sampleStart,"sampleFrames":sampleFrames,"sampleDuration":29.3,"audio":"Original compressed sample audio only; no gain or speed change; raw recording audio omitted.","segments":["0-3: recorded Motion control frame at source22s","3-9: Playground player source30-36s, cropped","9-14: Around successful result source60-65s, cropped","14-20: saved dated record still captured after recording","20-25: explicit sample transition","25-54.3: complete approved sample once","54.3-59.3: closing limits"],"scope":"Edited separate recordings and disclosed still, not a continuous Playground-to-Around take. Official live-view ingestion, not classified motion or visitor validation.","review":"Render complete; visual, privacy and continuous playback checks pending. Owner approval pending."]
 try JSONSerialization.data(withJSONObject:manifest,options:[.prettyPrinted,.sortedKeys]).write(to:final.deletingPathExtension().appendingPathExtension("json"));print("Rendered",duration,"sampleStart",sampleStart,"frames",sampleFrames);exit(0)
} catch {print("Failed:",error);exit(1)}}
dispatchMain()
