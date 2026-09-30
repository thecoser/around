// Run from the repository root with macOS Swift. Outputs are kept in ignored data/recordings.
// Reuses the app's Arial wordmark, colors and Lucide Radio geometry; no provider calls.
import Foundation
import AVFoundation
import AppKit
import CoreText

let root = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
let directory = root.appendingPathComponent("data/recordings")
let width = 970, height = 920, fps = 60
let reverse = CommandLine.arguments.contains("--outro")
let duration = reverse ? 3.1 : 2.6
let orange = NSColor(srgbRed:225/255, green:115/255, blue:66/255, alpha:1)
let ink = NSColor(srgbRed:53/255, green:43/255, blue:38/255, alpha:1)
let markInk = NSColor(srgbRed:45/255, green:32/255, blue:27/255, alpha:1)
let paper = NSColor(srgbRed:1, green:250/255, blue:245/255, alpha:1)
func progress(_ t:Double,_ start:Double,_ end:Double)->Double { min(1,max(0,(t-start)/(end-start))) }
func ease(_ p:Double)->Double { 1-pow(1-p,3) }
func textLine(_ text:String,_ font:NSFont,_ color:NSColor,_ kern:Double=0)->CTLine {
 CTLineCreateWithAttributedString(NSAttributedString(string:text,attributes:[.font:font,.foregroundColor:color,.kern:kern]))
}
let word = textLine("around",NSFont(name:"Arial-BoldMT",size:99)!,ink,-5.7)
let dot = textLine(".",NSFont(name:"Arial-BoldMT",size:99)!,orange,-5.7)
let tagline = textLine("Spatial intelligence for your home.",NSFont(name:"ArialMT",size:26)!,ink)
let wordWidth = CTLineGetTypographicBounds(word,nil,nil,nil)
let dotWidth = CTLineGetTypographicBounds(dot,nil,nil,nil)
let textWidth = wordWidth + dotWidth - 3
let groupWidth = 108 + 27 + textWidth
let markFinalX = (Double(width)-groupWidth)/2 + 54
let baseline = 467.0
let centerY = baseline + 32
let textFinalX = markFinalX + 54 + 27

func draw(_ context:CGContext,_ t:Double) {
 context.setFillColor(paper.cgColor); context.fill(CGRect(x:0,y:0,width:width,height:height))
 let fade=progress(t,0,0.22), move=ease(progress(t,0.2,0.86))
 let markX=Double(width)/2 + (markFinalX-Double(width)/2)*move
 let textP=ease(progress(t,0.20,0.88))
 // Wordmark emerges from behind the circle, turning clockwise as it moves right.
 if t > 0.20 {
  let finalCenter=textFinalX+textWidth/2
  let x=markX+(finalCenter-markX)*textP
  context.saveGState(); context.setAlpha(progress(t,0.20,0.40))
  context.translateBy(x:x,y:centerY)
  context.rotate(by:(1-textP)*1.5 * .pi)
  let scale=0.10+0.90*textP; context.scaleBy(x:scale,y:scale)
  context.textPosition=CGPoint(x:-textWidth/2,y:-32); CTLineDraw(word,context)
  context.textPosition=CGPoint(x:-textWidth/2+wordWidth-3,y:-32); CTLineDraw(dot,context)
  context.restoreGState()
 }
 // Circle remains round and still; only the inner Radio symbol rotates.
 context.saveGState(); context.setAlpha(fade)
 context.translateBy(x:markX,y:centerY)
 let markScale=0.88+0.12*ease(fade); context.scaleBy(x:markScale,y:markScale)
 context.setFillColor(orange.cgColor); context.fillEllipse(in:CGRect(x:-54,y:-54,width:108,height:108))
 context.rotate(by:-2 * .pi * ease(progress(t,0.03,0.98)))
 context.scaleBy(x:75/24,y:75/24)
 context.setStrokeColor(markInk.cgColor); context.setLineWidth(2); context.setLineCap(.round)
 // Lucide Radio: radius 6 and 10 signal arcs, and radius 2 center circle.
 for radius in [6.0,10.0] {
  context.beginPath(); context.addArc(center:.zero,radius:radius,startAngle:-.pi/4,endAngle:.pi/4,clockwise:false); context.strokePath()
  context.beginPath(); context.addArc(center:.zero,radius:radius,startAngle:3 * .pi/4,endAngle:5 * .pi/4,clockwise:false); context.strokePath()
 }
 context.strokeEllipse(in:CGRect(x:-2,y:-2,width:4,height:4))
 context.restoreGState()
 let subtitleP=progress(t,0.88,1.16)
 context.saveGState(); context.setAlpha(subtitleP)
 let subtitleWidth=CTLineGetTypographicBounds(tagline,nil,nil,nil)
 context.textPosition=CGPoint(x:(Double(width)-subtitleWidth)/2,y:385-8*(1-ease(subtitleP)))
 CTLineDraw(tagline,context); context.restoreGState()
}

Task {
 do {
  let output=directory.appendingPathComponent(reverse ? "around-logo-outro.mp4" : "around-logo-intro.mp4")
  guard !FileManager.default.fileExists(atPath:output.path) else { throw NSError(domain:"AroundMedia",code:1,userInfo:[NSLocalizedDescriptionKey:"Preserving existing output"])}
  let writer=try AVAssetWriter(outputURL:output,fileType:.mp4)
  let input=AVAssetWriterInput(mediaType:.video,outputSettings:[AVVideoCodecKey:AVVideoCodecType.h264,AVVideoWidthKey:width,AVVideoHeightKey:height,AVVideoCompressionPropertiesKey:[AVVideoAverageBitRateKey:8_000_000]])
  let adaptor=AVAssetWriterInputPixelBufferAdaptor(assetWriterInput:input,sourcePixelBufferAttributes:[kCVPixelBufferPixelFormatTypeKey as String:kCVPixelFormatType_32ARGB,kCVPixelBufferWidthKey as String:width,kCVPixelBufferHeightKey as String:height,kCVPixelBufferCGImageCompatibilityKey as String:true,kCVPixelBufferCGBitmapContextCompatibilityKey as String:true])
  writer.add(input); writer.startWriting(); writer.startSession(atSourceTime:.zero)
  for frame in 0..<Int(duration*Double(fps)) {
   while !input.isReadyForMoreMediaData { try await Task.sleep(nanoseconds:1_000_000) }
   var buffer:CVPixelBuffer?
   guard CVPixelBufferPoolCreatePixelBuffer(nil,adaptor.pixelBufferPool!,&buffer)==kCVReturnSuccess, let buffer else { fatalError("Pixel buffer unavailable") }
   CVPixelBufferLockBaseAddress(buffer,[])
   let context=CGContext(data:CVPixelBufferGetBaseAddress(buffer),width:width,height:height,bitsPerComponent:8,bytesPerRow:CVPixelBufferGetBytesPerRow(buffer),space:CGColorSpaceCreateDeviceRGB(),bitmapInfo:CGImageAlphaInfo.noneSkipFirst.rawValue)!
   context.setAllowsAntialiasing(true); context.setShouldAntialias(true)
   let time=Double(frame)/Double(fps)
   draw(context,reverse ? max(0,2.6-time) : time)
   CVPixelBufferUnlockBaseAddress(buffer,[])
   guard adaptor.append(buffer,withPresentationTime:CMTime(value:Int64(frame),timescale:Int32(fps))) else { throw writer.error! }
  }
  input.markAsFinished(); await writer.finishWriting()
  guard writer.status == .completed else { throw writer.error! }
  let source=directory.appendingPathComponent(reverse ? "around-demo-with-logo-compatible.mp4" : "around-app-view-final.mp4")
  let combined=directory.appendingPathComponent(reverse ? "around-demo-with-outro-joined.mp4" : "around-demo-with-logo.mp4")
  guard !FileManager.default.fileExists(atPath:combined.path) else { fatalError("Preserving combined output") }
  let composition=AVMutableComposition()
  let track=composition.addMutableTrack(withMediaType:.video,preferredTrackID:kCMPersistentTrackID_Invalid)!
  var cursor=CMTime.zero
  for url in (reverse ? [source,output] : [output,source]) {
   let asset=AVURLAsset(url:url)
   let video=try await asset.loadTracks(withMediaType:.video)[0]
   let length=try await asset.load(.duration)
   try track.insertTimeRange(CMTimeRange(start:.zero,duration:length),of:video,at:cursor)
   cursor=CMTimeAdd(cursor,length)
  }
  let exporter=AVAssetExportSession(asset:composition,presetName:AVAssetExportPresetHighestQuality)!
  exporter.shouldOptimizeForNetworkUse=true
  try await exporter.export(to:combined,as:.mp4)
  let manifest:[String:Any] = ["animation":output.lastPathComponent,"reversed":reverse,"approvedDemoSource":source.lastPathComponent,"combined":combined.lastPathComponent,"animationDuration":duration,"combinedDuration":cursor.seconds,"dimensions":[width,height],"audio":"none","tagline":"Spatial intelligence for your home.","palette":["#E17342","#352B26","#2D201B","#FFFAF5"],"timing":reverse ? "Approved 2.6-second opener animation reversed, followed by 0.5 seconds of blank cream." : "Mark fade 0–0.22s; clockwise signal rotation 0.03–0.98s; wordmark spins out right 0.20–0.88s; tagline fades in 0.88–1.16s; settled hold to 2.6s.","evidence":"Brand animation only. Existing approved video preserved, no crop or timing changes. Normalize joined export before delivery." ]
  try JSONSerialization.data(withJSONObject:manifest,options:[.prettyPrinted,.sortedKeys]).write(to:directory.appendingPathComponent(reverse ? "around-demo-with-outro-joined.json" : "around-demo-with-logo.json"))
  print("Created logo animation and combined demo (\(cursor.seconds)s)."); exit(0)
 } catch { print("Render failed: \(error)"); exit(1) }
}
dispatchMain()
