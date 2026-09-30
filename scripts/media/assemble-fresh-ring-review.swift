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
// Established Around wordmark and Radio geometry, reused from render-logo-intro.swift.
func logo(_ c:CGContext) {
 let orange=CGColor(red:225/255,green:115/255,blue:66/255,alpha:1)
 let ink=CGColor(red:53/255,green:43/255,blue:38/255,alpha:1)
 func line(_ value:String,_ size:CGFloat,_ color:CGColor,_ bold:Bool=false,_ kern:CGFloat=0)->CTLine {
  CTLineCreateWithAttributedString(NSAttributedString(string:value,attributes:[NSAttributedString.Key(kCTFontAttributeName as String):CTFontCreateWithName((bold ? "Arial-BoldMT" : "ArialMT") as CFString,size,nil),NSAttributedString.Key(kCTForegroundColorAttributeName as String):color,NSAttributedString.Key(kCTKernAttributeName as String):kern]))
 }
 let word=line("around",99,ink,true,-5.7),dot=line(".",99,orange,true,-5.7)
 let ww=CTLineGetTypographicBounds(word,nil,nil,nil),dw=CTLineGetTypographicBounds(dot,nil,nil,nil)
 let mx=(970-(108+27+ww+dw-3))/2+54,cy=775.0
 c.textPosition=CGPoint(x:mx+81,y:cy-32);CTLineDraw(word,c)
 c.textPosition=CGPoint(x:mx+81+ww-3,y:cy-32);CTLineDraw(dot,c)
 c.saveGState();c.translateBy(x:mx,y:cy)
 c.setFillColor(orange);c.fillEllipse(in:CGRect(x:-54,y:-54,width:108,height:108))
 c.scaleBy(x:75/24,y:75/24);c.setStrokeColor(CGColor(red:45/255,green:32/255,blue:27/255,alpha:1));c.setLineWidth(2);c.setLineCap(.round)
 for r in [6.0,10.0] {
  c.beginPath();c.addArc(center:.zero,radius:r,startAngle:-.pi/4,endAngle:.pi/4,clockwise:false);c.strokePath()
  c.beginPath();c.addArc(center:.zero,radius:r,startAngle:3 * .pi/4,endAngle:5 * .pi/4,clockwise:false);c.strokePath()
 }
 c.strokeEllipse(in:CGRect(x:-2,y:-2,width:4,height:4));c.restoreGState()
 let tagline=line("Spatial Intelligence for your home",26,ink)
 c.textPosition=CGPoint(x:(970-CTLineGetTypographicBounds(tagline,nil,nil,nil))/2,y:660);CTLineDraw(tagline,c)
}
func still(_ path:String)->CGImage {CGImageSourceCreateImageAtIndex(CGImageSourceCreateWithURL(dir.appendingPathComponent(path) as CFURL,nil)!,0,nil)!}
func buffer(_ img:CGImage?,crop:CGRect?,title:String,subtitle:String,footer:String,branded:Bool=false)->CVPixelBuffer {
 var b:CVPixelBuffer?;CVPixelBufferCreate(nil,W,H,kCVPixelFormatType_32BGRA,[kCVPixelBufferCGImageCompatibilityKey:true,kCVPixelBufferCGBitmapContextCompatibilityKey:true] as CFDictionary,&b)
 CVPixelBufferLockBaseAddress(b!,[]);defer{CVPixelBufferUnlockBaseAddress(b!,[])}
 let c=CGContext(data:CVPixelBufferGetBaseAddress(b!),width:W,height:H,bitsPerComponent:8,bytesPerRow:CVPixelBufferGetBytesPerRow(b!),space:CGColorSpaceCreateDeviceRGB(),bitmapInfo:CGImageAlphaInfo.premultipliedFirst.rawValue|CGBitmapInfo.byteOrder32Little.rawValue)!
 c.setFillColor(CGColor(red:1,green:0.98,blue:0.96,alpha:1));c.fill(CGRect(x:0,y:0,width:W,height:H))
 c.setFillColor(CGColor(red:0.88,green:0.45,blue:0.26,alpha:1));c.fill(CGRect(x:44,y:CGFloat(H)-32,width:64,height:5))
 if img == nil {
  if branded {logo(c)} else {text(c,title,90,44,150)}
  text(c,subtitle,branded ? 330 : 300,32,340)
 } else {
  text(c,title,55,38,105);text(c,subtitle,165,25,125)
 }
 if let im=img {let im=crop == nil ? im : im.cropping(to:crop!)!;let scale=min(882/CGFloat(im.width),460/CGFloat(im.height));let dw=CGFloat(im.width)*scale,dh=CGFloat(im.height)*scale;c.interpolationQuality = .high;c.draw(im,in:CGRect(x:(970-dw)/2,y:CGFloat(H)-320-dh,width:dw,height:dh))}
 text(c,footer,800,21,100)
 return b!
}
Task {do {
 let out=dir.appendingPathComponent("around-submission-review-v11-video.mp4"),final=dir.appendingPathComponent("around-submission-review-v11.mp4")
 guard !FileManager.default.fileExists(atPath:out.path),!FileManager.default.fileExists(atPath:final.path) else {fatalError("Preserving existing outputs")}
 let writer=try AVAssetWriter(outputURL:out,fileType:.mp4)
 let input=AVAssetWriterInput(mediaType:.video,outputSettings:[AVVideoCodecKey:AVVideoCodecType.h264,AVVideoWidthKey:W,AVVideoHeightKey:H,AVVideoCompressionPropertiesKey:[AVVideoAverageBitRateKey:10_000_000,AVVideoExpectedSourceFrameRateKey:60,AVVideoMaxKeyFrameIntervalKey:60]])
 writer.add(input);let adaptor=AVAssetWriterInputPixelBufferAdaptor(assetWriterInput:input,sourcePixelBufferAttributes:[kCVPixelBufferPixelFormatTypeKey as String:kCVPixelFormatType_32BGRA,kCVPixelBufferWidthKey as String:W,kCVPixelBufferHeightKey as String:H]);writer.startWriting();writer.startSession(atSourceTime:.zero)
 var frameIndex:Int64=0
 func append(_ b:CVPixelBuffer) async throws {while !input.isReadyForMoreMediaData {try await Task.sleep(nanoseconds:1_000_000)};guard adaptor.append(b,withPresentationTime:CMTime(value:frameIndex,timescale:60)) else {throw writer.error!};frameIndex+=1}
 func hold(_ b:CVPixelBuffer,_ seconds:Int) async throws {for _ in 0..<(seconds*60) {try await append(b)}}
 try await hold(buffer(nil,crop:nil,title:"Around",subtitle:"Around helps homeowners connect expected activities with recorded activity.\n\nFirst, we demonstrate the visit experience using labeled sample activity. Then, we show the Ring integration.",footer:"",branded:true),8)
 try await hold(buffer(nil,crop:nil,title:"1. Product demo\nWas the expected visit likely?",subtitle:"Next, see how Around answers ‘Did the plumber come?’\n\nThis example uses sample activity, with answers generated earlier by Amazon Bedrock. The visit shown was not recorded by Ring.",footer:"This section shows the value to a homeowner."),10)
 let sampleStart=Double(frameIndex)/60
 let master=AVURLAsset(url:dir.appendingPathComponent("around-demo-ring-sparkle.mp4"));let track=try await master.loadTracks(withMediaType:.video)[0]
 let reader=try AVAssetReader(asset:master);let output=AVAssetReaderTrackOutput(track:track,outputSettings:[kCVPixelBufferPixelFormatTypeKey as String:kCVPixelFormatType_32BGRA]);reader.add(output);reader.startReading();var sampleFrames=0
 while let s=output.copyNextSampleBuffer() {guard let b=CMSampleBufferGetImageBuffer(s) else {continue};try await append(b);sampleFrames+=1}
 guard reader.status == .completed,sampleFrames==1758 else {fatalError("Sample frame count changed")}
 try await hold(buffer(nil,crop:nil,title:"2. Ring integration\nThe official Playground",subtitle:"We use Ring’s simulator to exercise the integration without physical hardware.",footer:"This section establishes where the activity comes from."),8)
 try await hold(buffer(still("private/control-crop-review/player-22.png"),crop:nil,title:"2. Ring integration",subtitle:"Motion live-view control\nRecorded control frame",footer:""),10)
 func clip(_ path:String,_ start:Double,_ seconds:Int,_ crop:CGRect,_ title:String,_ subtitle:String,_ footer:String,_ tailHold:Int=0) async throws {
 let a=AVURLAsset(url:dir.appendingPathComponent(path));let g=AVAssetImageGenerator(asset:a);g.appliesPreferredTrackTransform=true;g.requestedTimeToleranceBefore = .zero;g.requestedTimeToleranceAfter = .zero
 var last:CVPixelBuffer?
 for f in 0..<(seconds*60) {let im=try await g.image(at:tm(start+Double(f)/60));let frame=buffer(im.image,crop:crop,title:title,subtitle:subtitle,footer:footer);try await append(frame);last=frame}
 if tailHold>0,let last {try await hold(last,tailHold)}
 }
 try await clip("private/around-playground-trace-2026-09-30.mov",30,6,CGRect(x:160,y:520,width:1040,height:465),"2. Ring integration","Recorded simulator playback","“Birds on Feeders” by Michael Black on Vimeo, CC BY 4.0. Cropped excerpt.",2)
 print("Playground scenes rendered")
 try await hold(buffer(nil,crop:nil,title:"3. Integration proof\nRing activity in Around",subtitle:"Around receives a new live-view record through the official Ring API and shows what that record can establish.",footer:"This section verifies the connection and how Around treats the evidence."),10)
 try await clip("private/around-fresh-sync-2026-09-30.mov",60,5,CGRect(x:650,y:390,width:1710,height:670),"3. Integration proof","Official device discovery and event history\nSuccessful sync, recorded in a separate take","",5)
 try await hold(buffer(still("ring-evidence/fresh-record-still.png"),crop:CGRect(x:215,y:180,width:585,height:270),title:"3. Integration proof",subtitle:"New Ring record: September 30 at 10:54 AM\nSaved record, shown in a still image",footer:""),14)
 try await hold(buffer(nil,crop:nil,title:"Around",subtitle:"Spatial intelligence for your home.\nA single-home prototype.",footer:"Timing does not confirm identity. The sample typing and microphone are edited visuals; voice input is not implemented."),5)
 let duration=Double(frameIndex)/60;writer.endSession(atSourceTime:CMTime(value:frameIndex,timescale:60));input.markAsFinished();await writer.finishWriting();guard writer.status == .completed else {throw writer.error!}
 let c=AVMutableComposition();let v=c.addMutableTrack(withMediaType:.video,preferredTrackID:kCMPersistentTrackID_Invalid)!,a=c.addMutableTrack(withMediaType:.audio,preferredTrackID:kCMPersistentTrackID_Invalid)!
 let rendered=AVURLAsset(url:out);try v.insertTimeRange(CMTimeRange(start:.zero,duration:tm(duration)),of:try await rendered.loadTracks(withMediaType:.video)[0],at:.zero)
 try a.insertTimeRange(CMTimeRange(start:.zero,duration:tm(29.3)),of:try await master.loadTracks(withMediaType:.audio)[0],at:tm(sampleStart))
 let ex=AVAssetExportSession(asset:c,presetName:AVAssetExportPresetPassthrough)!;ex.outputURL=final;ex.outputFileType = .mp4;ex.shouldOptimizeForNetworkUse=true;await ex.export();guard ex.status == .completed else {throw ex.error!}
 let manifest:[String:Any]=["output":final.lastPathComponent,"duration":duration,"sampleStart":sampleStart,"sampleFrames":sampleFrames,"sampleDuration":29.3,"audio":"Original compressed sample audio only; no gain or speed change; raw recording audio omitted.","segments":["0-8: audience orientation","8-18: section1 product demo and sample explanation","18-47.3: complete approved sample once","47.3-55.3: section2 Ring Playground purpose card","55.3-65.3: recorded Motion control frame at source22s","65.3-73.3: Playground player source30-36s, cropped; final frame held 2s for reading","73.3-83.3: section3 integration proof purpose card","83.3-93.3: Around successful result source60-65s, cropped; final frame held 5s for reading","93.3-107.3: saved dated record still captured after recording","107.3-112.3: closing limits"],"scope":"Edited separate recordings and disclosed still, not a continuous Playground-to-Around take. Official live-view ingestion, not classified motion or visitor validation.","review":"Render complete; visual, privacy and continuous playback checks pending. Owner approval pending."]
 try JSONSerialization.data(withJSONObject:manifest,options:[.prettyPrinted,.sortedKeys]).write(to:final.deletingPathExtension().appendingPathExtension("json"));print("Rendered",duration,"sampleStart",sampleStart,"frames",sampleFrames);exit(0)
} catch {print("Failed:",error);exit(1)}}
dispatchMain()
