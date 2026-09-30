// Local-only assembly. Captions use the owner-confirmed script and measured speech pauses.
import Foundation
import AVFoundation
import AppKit
let directory=URL(fileURLWithPath:FileManager.default.currentDirectoryPath).appendingPathComponent("data/recordings")
let ringVoice=CommandLine.arguments.contains("--ring-voice")
let lateShift=ringVoice ? 1.5 : 0.0
let ringCard=ringVoice || CommandLine.arguments.contains("--ring-card")
let cleanBreath=ringCard || CommandLine.arguments.contains("--clean-breath")
let questionRetake=cleanBreath || CommandLine.arguments.contains("--question-retake")
let typedInput=questionRetake || CommandLine.arguments.contains("--typed-input")
let typingStart=(questionRetake ? 5.26 : 5.22)+lateShift
let typingDuration=questionRetake ? 0.80 : 0.72
let outputStem=ringVoice ? "around-demo-ring-voice" : ringCard ? "around-demo-ring-card" : cleanBreath ? "around-demo-narrated-final" : questionRetake ? "around-demo-narrated-retake" : typedInput ? "around-demo-narrated-typed" : "around-demo-narrated-refined"
let cues:[(Double,Double,String)] = [
 (ringVoice ? 1.02 : 1.20,ringVoice ? 2.58 : 2.22,"This is Around."),
 (ringVoice ? 3.12 : 2.60,ringVoice ? 6.35 : 4.98,ringVoice ? "It works with Ring to help you manage\nwhat’s happening at home." : "It helps you make sense of\nwhat’s happening at home."),
 (5.20+lateShift,6.20+lateShift,"Did the plumber come?"),
 ((questionRetake ? 6.60 : 6.40)+lateShift,(questionRetake ? 7.55 : 7.30)+lateShift,"Ask Around."),
 (7.75+lateShift,12.45+lateShift,"Yeah, it looks like the plumber came\naround 10:41 and left around 11:27."),
 (13.02+lateShift,17.08+lateShift,"Around remembers what you’re expecting\nand connects it to what happened."),
 (17.58+lateShift,21.65+lateShift,"Your home’s activity becomes something\nyou can ask about, in your own words.")
]
func captionImage(_ text:String)->CGImage {
 let size=NSSize(width:850,height:100)
 let image=NSImage(size:size);image.lockFocus()
 NSColor(calibratedRed:0.12,green:0.10,blue:0.09,alpha:0.92).setFill()
 NSBezierPath(roundedRect:NSRect(origin:.zero,size:size),xRadius:12,yRadius:12).fill()
 let style=NSMutableParagraphStyle();style.alignment = .center;style.lineSpacing=5
 let attributes:[NSAttributedString.Key:Any]=[.font:NSFont(name:"ArialMT",size:27)!, .foregroundColor:NSColor.white,.paragraphStyle:style]
 let lines=text.components(separatedBy:"\n").count
 let rect=NSRect(x:16,y:lines==1 ? 32 : 14,width:818,height:lines==1 ? 36 : 72)
 (text as NSString).draw(in:rect,withAttributes:attributes)
 image.unlockFocus();return NSBitmapImageRep(data:image.tiffRepresentation!)!.cgImage!
}
// Video-only reconstruction. The microphone is decorative, not implemented voice input.
func inputImage(_ text:String,caret:Bool)->CGImage {
 let image=NSImage(size:NSSize(width:463,height:48));image.lockFocus()
 NSColor(srgbRed:1,green:253/255,blue:250/255,alpha:1).setFill()
 NSBezierPath(rect:NSRect(x:0,y:0,width:463,height:48)).fill()
 let attributes:[NSAttributedString.Key:Any]=[.font:NSFont(name:"ArialMT",size:19.5)!, .foregroundColor:NSColor(srgbRed:53/255,green:43/255,blue:38/255,alpha:1)]
 (text as NSString).draw(at:NSPoint(x:12,y:12),withAttributes:attributes)
 if caret {
  NSColor(srgbRed:53/255,green:43/255,blue:38/255,alpha:1).setFill()
  let x=12+(text as NSString).size(withAttributes:attributes).width+2
  NSBezierPath(rect:NSRect(x:x,y:12,width:1.5,height:23)).fill()
 }
 // Lucide-style microphone, centered at frame x819, comfortably clear of the arrow.
 NSColor(srgbRed:125/255,green:107/255,blue:94/255,alpha:1).setStroke()
 let capsule=NSBezierPath(roundedRect:NSRect(x:437,y:23,width:8,height:14),xRadius:4,yRadius:4);capsule.lineWidth=2;capsule.stroke()
 let stand=NSBezierPath();stand.lineWidth=2;stand.lineCapStyle = .round
 stand.move(to:NSPoint(x:433,y:27));stand.line(to:NSPoint(x:433,y:23))
 stand.curve(to:NSPoint(x:449,y:23),controlPoint1:NSPoint(x:433,y:12),controlPoint2:NSPoint(x:449,y:12))
 stand.line(to:NSPoint(x:449,y:27));stand.move(to:NSPoint(x:441,y:15));stand.line(to:NSPoint(x:441,y:9))
 stand.move(to:NSPoint(x:437,y:9));stand.line(to:NSPoint(x:445,y:9));stand.stroke()
 image.unlockFocus();return NSBitmapImageRep(data:image.tiffRepresentation!)!.cgImage!
}
func addTrackedInput(_ asset:AVAsset,_ video:AVCompositionTrack,_ vc:AVVideoComposition,_ parent:CALayer,_ duration:Double)throws {
 let reader=try AVAssetReader(asset:asset)
 let out=AVAssetReaderVideoCompositionOutput(videoTracks:[video],videoSettings:[kCVPixelBufferPixelFormatTypeKey as String:kCVPixelFormatType_32BGRA]);out.videoComposition=vc
 reader.add(out);guard reader.startReading() else {throw reader.error!}
 var keys:[NSNumber]=[], positions:[NSValue]=[], visible:[NSNumber]=[], measurements:[[String:Double]]=[]
 while let sample=out.copyNextSampleBuffer() {
  let t=CMSampleBufferGetPresentationTimeStamp(sample).seconds
  let b=CMSampleBufferGetImageBuffer(sample)!;CVPixelBufferLockBaseAddress(b,.readOnly)
  let bytes=CVPixelBufferGetBaseAddress(b)!.assumingMemoryBound(to:UInt8.self),stride=CVPixelBufferGetBytesPerRow(b)
  var runStart:Int?,best:(Int,Int)?
  for y in 0...920 {
   var matches=false
   if y<920 {
    let p=y*stride+800*4,q=y*stride+940*4
    matches=bytes[p+2]>245 && bytes[p+1]>242 && bytes[p]>235 && bytes[q+2]>205 && bytes[q+1]>80 && bytes[q+1]<160 && bytes[q]<110
   }
   if matches {if runStart==nil {runStart=y}}
   else if let start=runStart { if y-start>=8 && (best==nil || y-start>best!.1-best!.0) {best=(start,y)};runStart=nil }
  }
  CVPixelBufferUnlockBaseAddress(b,.readOnly)
  var center=0.0,show=false
  if let (start,end)=best, end-start>=30 || end==920 || start==0 {
   center=start==0 ? Double(end)-38 : Double(start)+38
   show=t>=(ringVoice ? 3.1 : 2.6) && t<22.15+lateShift
  }
  keys.append(NSNumber(value:t/duration));positions.append(NSValue(point:NSPoint(x:378+463.0/2,y:920-center)));visible.append(NSNumber(value:show ? 1 : 0))
  if show {measurements.append(["time":t,"centerY":center])}
 }
 guard reader.status == .completed else {throw reader.error!}
 keys.append(1);positions.append(positions.last!);visible.append(0)
 let patch=CALayer();patch.bounds=CGRect(x:0,y:0,width:463,height:48);patch.opacity=0;patch.contents=inputImage("",caret:false)
 for (name,values) in [("position",positions as [Any]),("opacity",visible as [Any])] {
  let animation=CAKeyframeAnimation(keyPath:name);animation.values=values;animation.keyTimes=keys;animation.calculationMode = .discrete
  animation.beginTime=AVCoreAnimationBeginTimeAtZero;animation.duration=duration;animation.isRemovedOnCompletion=false;animation.fillMode = .both;patch.add(animation,forKey:name)
 }
 let phrase="did the plumber come"
 var images:[CGImage]=[inputImage("",caret:false)],textKeys:[NSNumber]=[0]
 for count in 0...phrase.count {images.append(inputImage(String(phrase.prefix(count)),caret:true));textKeys.append(NSNumber(value:(typingStart+typingDuration*Double(count)/Double(phrase.count))/duration))}
 images.append(inputImage(phrase,caret:false));textKeys.append(NSNumber(value:(6.25+lateShift)/duration));images.append(images.last!);textKeys.append(1)
 let typing=CAKeyframeAnimation(keyPath:"contents");typing.values=images;typing.keyTimes=textKeys;typing.calculationMode = .discrete;typing.beginTime=AVCoreAnimationBeginTimeAtZero;typing.duration=duration;typing.isRemovedOnCompletion=false;typing.fillMode = .both;patch.add(typing,forKey:"typing")
 parent.addSublayer(patch)
 try JSONSerialization.data(withJSONObject:measurements,options:[.sortedKeys]).write(to:directory.appendingPathComponent("around-input-tracking.json"))
 print("Tracked input in \(measurements.count) frames; typing \(typingStart)–\(typingStart+typingDuration) seconds.")
}
func time(_ seconds:Double)->CMTime { CMTime(seconds:seconds,preferredTimescale:60000) }
Task {
 do {
  let source=AVURLAsset(url:directory.appendingPathComponent("around-demo-complete.mp4"))
  let originalVoice=AVURLAsset(url:directory.appendingPathComponent("around-owner-voice-original.m4a"))
  let output=directory.appendingPathComponent("\(outputStem).mp4")
  guard !FileManager.default.fileExists(atPath:output.path) else { fatalError("Preserving existing output") }
  let videoSource=try await source.loadTracks(withMediaType:.video)[0]
  let audioSource=try await originalVoice.loadTracks(withMediaType:.audio)[0]
  let sourceDuration=try await source.load(.duration).seconds
  let composition=AVMutableComposition()
  let video=composition.addMutableTrack(withMediaType:.video,preferredTrackID:kCMPersistentTrackID_Invalid)!
  let audio=composition.addMutableTrack(withMediaType:.audio,preferredTrackID:kCMPersistentTrackID_Invalid)!
  let disclaimer=composition.addMutableTrack(withMediaType:.audio,preferredTrackID:kCMPersistentTrackID_Invalid)!
  // Keep the opener/answer, bring cards forward for the narration, hold Home briefly,
  // then reverse the approved logo and finish on blank cream.
  let openingSegments:[(Double,Double,Double)]=ringVoice ? [(0,2.55,2.55),(2.55,0.05,0.55),(2.6,2.0,3.0),(4.6,8.5,8.5)] : [(0,13.1,13.1)]
  let segments:[(Double,Double,Double)] = openingSegments + [(16.1,8.5,8.5),(24.5,0.10,0.55),(24.6166666667,0.05,2.2),(24.6166666667,3.1,3.1),(sourceDuration-0.05,0.05,0.35)]
  var cursor=CMTime.zero
  var mapped:[[String:Double]]=[]
  for (start,length,targetLength) in segments {
   try video.insertTimeRange(CMTimeRange(start:time(start),duration:time(length)),of:videoSource,at:cursor)
   if abs(length-targetLength)>0.0001 { video.scaleTimeRange(CMTimeRange(start:cursor,duration:time(length)),toDuration:time(targetLength)) }
   mapped.append(["sourceStart":start,"sourceDuration":length,"outputStart":cursor.seconds,"outputDuration":targetLength])
   cursor=CMTimeAdd(cursor,time(targetLength))
  }
  var replacement:AVMutableCompositionTrack?
  var introReplacement:AVMutableCompositionTrack?
  if questionRetake {
   let retakeAsset=AVURLAsset(url:directory.appendingPathComponent("around-owner-question-retake.m4a"))
   let retakeSource=try await retakeAsset.loadTracks(withMediaType:.audio)[0]
   let retake=composition.addMutableTrack(withMediaType:.audio,preferredTrackID:kCMPersistentTrackID_Invalid)!
   // Quiet boundaries preserve the new take's natural phrase spacing and the rest of the timeline.
   if ringVoice {
    let newIntro=AVURLAsset(url:directory.appendingPathComponent("around-owner-ring-intro-retake.m4a"))
    let introSource=try await newIntro.loadTracks(withMediaType:.audio)[0]
    let intro=composition.addMutableTrack(withMediaType:.audio,preferredTrackID:kCMPersistentTrackID_Invalid)!
    try intro.insertTimeRange(CMTimeRange(start:time(0.90),duration:time(5.35)),of:introSource,at:time(0.90))
    introReplacement=intro
   } else {
    try audio.insertTimeRange(CMTimeRange(start:.zero,duration:time(5.08)),of:audioSource,at:.zero)
   }
   try audio.insertTimeRange(CMTimeRange(start:time(7.60),duration:time(21.8-7.60)),of:audioSource,at:time(7.60+lateShift))
   try retake.insertTimeRange(CMTimeRange(start:time(0.50),duration:time(2.36)),of:retakeSource,at:time(5.18+lateShift))
   replacement=retake
  } else {
   try audio.insertTimeRange(CMTimeRange(start:.zero,duration:time(21.8)),of:audioSource,at:.zero)
  }
  // Source line is isolated at quiet boundaries. 1.2x faster with original pitch.
  let disclaimerSourceStart=22.0, disclaimerSourceLength=2.88, disclaimerStart=23.2+lateShift, disclaimerSpeed=1.2
  try disclaimer.insertTimeRange(CMTimeRange(start:time(disclaimerSourceStart),duration:time(disclaimerSourceLength)),of:audioSource,at:time(disclaimerStart))
  disclaimer.scaleTimeRange(CMTimeRange(start:time(disclaimerStart),duration:time(disclaimerSourceLength)),toDuration:time(disclaimerSourceLength/disclaimerSpeed))
  let vc=AVMutableVideoComposition();vc.renderSize=CGSize(width:970,height:920);vc.frameDuration=CMTime(value:1,timescale:60)
  let instruction=AVMutableVideoCompositionInstruction();instruction.timeRange=CMTimeRange(start:.zero,duration:cursor)
  let layer=AVMutableVideoCompositionLayerInstruction(assetTrack:video);layer.setTransform(.identity,at:.zero)
  instruction.layerInstructions=[layer];vc.instructions=[instruction]
  let parent=CALayer();parent.frame=CGRect(x:0,y:0,width:970,height:920)
  let picture=CALayer();picture.frame=parent.bounds;parent.addSublayer(picture)
  if ringCard {
   let badgeImage=NSImage(size:NSSize(width:400,height:40));badgeImage.lockFocus()
   let style=NSMutableParagraphStyle();style.alignment = .center
   ("Works with Ring" as NSString).draw(in:NSRect(x:0,y:6,width:400,height:30),withAttributes:[.font:NSFont(name:"ArialMT",size:22)!, .foregroundColor:NSColor(srgbRed:125/255,green:107/255,blue:94/255,alpha:1),.paragraphStyle:style])
   badgeImage.unlockFocus()
   let badge=CALayer();badge.frame=CGRect(x:285,y:329,width:400,height:40);badge.contents=NSBitmapImageRep(data:badgeImage.tiffRepresentation!)!.cgImage!;badge.opacity=0
   let appearance=CAKeyframeAnimation(keyPath:"opacity");appearance.values=[0,1,1,0];appearance.keyTimes=[0,0.14,0.995,1];appearance.beginTime=AVCoreAnimationBeginTimeAtZero+1.18;appearance.duration=ringVoice ? 1.92 : 1.42;appearance.isRemovedOnCompletion=false;appearance.fillMode = .both
   badge.add(appearance,forKey:"ringCompatibility");parent.addSublayer(badge)
  }
  if typedInput {try addTrackedInput(composition,video,vc,parent,cursor.seconds)}
  for (start,end,text) in cues {
   let caption=CALayer();caption.frame=CGRect(x:60,y:18,width:850,height:100)
   caption.contents=captionImage(text);caption.opacity=0
   let animation=CAKeyframeAnimation(keyPath:"opacity")
   animation.values=[0,1,1,0];animation.keyTimes=[0,0.015,0.985,1]
   animation.beginTime=AVCoreAnimationBeginTimeAtZero+start;animation.duration=end-start
   animation.isRemovedOnCompletion=false;animation.fillMode = .both
   caption.add(animation,forKey:"caption");parent.addSublayer(caption)
  }
  vc.animationTool=AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer:picture,in:parent)
  let mix=AVMutableAudioMix();let levels=AVMutableAudioMixInputParameters(track:audio)
  levels.setVolume(pow(10,4.5/20),at:.zero)
  let disclaimerLevels=AVMutableAudioMixInputParameters(track:disclaimer)
  disclaimerLevels.audioTimePitchAlgorithm = .spectral
  disclaimerLevels.setVolume(pow(10,-1.5/20),at:.zero)
  mix.inputParameters=[levels,disclaimerLevels]
  if let replacement {
   let retakeLevels=AVMutableAudioMixInputParameters(track:replacement)
   let gain:Float=pow(10,7.5/20)
   retakeLevels.setVolumeRamp(fromStartVolume:0,toEndVolume:gain,timeRange:CMTimeRange(start:time(5.18+lateShift),duration:time(0.01)))
   retakeLevels.setVolumeRamp(fromStartVolume:gain,toEndVolume:0,timeRange:CMTimeRange(start:time(7.53+lateShift),duration:time(0.01)))
   // Edge fades occur in quiet gaps, outside spoken syllables.
   let mainGain:Float=pow(10,4.5/20)
   levels.setVolumeRamp(fromStartVolume:mainGain,toEndVolume:0,timeRange:CMTimeRange(start:time(5.07+lateShift),duration:time(0.01)))
   levels.setVolumeRamp(fromStartVolume:0,toEndVolume:mainGain,timeRange:CMTimeRange(start:time(7.60+lateShift),duration:time(0.01)))
   mix.inputParameters.append(retakeLevels)
  }
  if let introReplacement {
   let introLevel=AVMutableAudioMixInputParameters(track:introReplacement)
   let gain:Float=pow(10,4.5/20)
   introLevel.setVolumeRamp(fromStartVolume:0,toEndVolume:gain,timeRange:CMTimeRange(start:time(0.90),duration:time(0.02)))
   introLevel.setVolumeRamp(fromStartVolume:gain,toEndVolume:0,timeRange:CMTimeRange(start:time(6.23),duration:time(0.02)))
   mix.inputParameters.append(introLevel)
  }
  if cleanBreath {
   // Suppress the inhalation in the quiet gap, preserving both neighboring phrases.
   let mainGain:Float=pow(10,4.5/20)
   levels.setVolumeRamp(fromStartVolume:mainGain,toEndVolume:0,timeRange:CMTimeRange(start:time(16.82+lateShift),duration:time(0.04)))
   levels.setVolume(0,at:time(16.86+lateShift))
   levels.setVolumeRamp(fromStartVolume:0,toEndVolume:mainGain,timeRange:CMTimeRange(start:time(17.58+lateShift),duration:time(0.04)))
  }
  let exporter=AVAssetExportSession(asset:composition,presetName:AVAssetExportPresetHighestQuality)!
  exporter.videoComposition=vc;exporter.audioMix=mix;exporter.shouldOptimizeForNetworkUse=true
  try await exporter.export(to:output,as:.mp4)
  let result=AVURLAsset(url:output);let resultVideo=try await result.loadTracks(withMediaType:.video)[0]
  let descriptions=try await resultVideo.load(.formatDescriptions)
  guard descriptions.count==1 else { fatalError("Expected single video encoding configuration") }
  let manifest:[String:Any]=["ringVoice":ringVoice ? "Owner confirmed This is Around plus approved Ring/manage-home sentence. Source0.90–6.25 at0.90, +4.5dB, natural speed." : "none","lateShift":lateShift,"ringCard":ringCard ? "Opening logo card adds Works with Ring." : "none","breathCleanup":cleanBreath ? "Mute pause 16.86–17.58 with 40ms ramps from 16.82 and to 17.62. No timeline changes." : "none","questionRetake":questionRetake ? "around-owner-question-retake.m4a source 0.50–2.86 placed at 5.18, gain +7.5 dB, speed unchanged; original 5.08–7.60 removed." : "none","typingStart":typingStart,"typingEnd":typingStart+typingDuration,"inputVisualEdit":typedInput ? "Composited lowercase did the plumber come typing aligned to the spoken question. Microphone is visual only. No app voice input or new provider request." : "none","output":output.lastPathComponent,"sourceVideo":"around-demo-complete.mp4","sourceAudio":"around-owner-voice-original.m4a","duration":try await result.load(.duration).seconds,"videoFormats":descriptions.count,"audioTracks":try await result.loadTracks(withMediaType:.audio).count,"gainDB":4.5,"questionRetakeStart":5.18+lateShift,"breathMuteStart":16.86+lateShift,"breathMuteEnd":17.58+lateShift,"disclaimerGainDB":-1.5,"disclaimerSpeed":disclaimerSpeed,"disclaimerStart":disclaimerStart,"disclaimerEnd":disclaimerStart+disclaimerSourceLength/disclaimerSpeed,"closingLogoAppears":22.15+lateShift,"disclaimerCaption":false,"segments":mapped,"captions":cues.map{["start":$0.0,"end":$0.1,"text":$0.2]},"captionBasis":"Owner confirmed approved script word for word. Timings inferred from local audio energy and pauses; not machine transcription.","reviewLimit":"Audible review and exact word timing require owner review; assistant cannot consume audio input." ]
  let json=try JSONSerialization.data(withJSONObject:manifest,options:[.prettyPrinted,.sortedKeys])
  try json.write(to:directory.appendingPathComponent("\(outputStem).json"))
  print("Exported narrated video: \(cursor.seconds)s, one video format, audio included.");exit(0)
 } catch { print("Assembly failed: \(error)");exit(1) }
}
dispatchMain()
