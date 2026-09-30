// Original, locally synthesized instrumental preview. No external recordings or samples.
import Foundation
import AVFoundation
let directory=URL(fileURLWithPath:FileManager.default.currentDirectoryPath).appendingPathComponent("data/recordings")
let duration=27.8,rate=48000.0
let stem="around-demo-with-soundtrack"
let musicURL=directory.appendingPathComponent("around-original-light-soundtrack.wav")
let output=directory.appendingPathComponent("\(stem).mp4")
func time(_ t:Double)->CMTime {CMTime(seconds:t,preferredTimescale:60000)}
func frequency(_ midi:Double)->Double {440*pow(2,(midi-69)/12)}
func smooth(_ x:Double)->Double {let p=min(1,max(0,x));return p*p*(3-2*p)}
func osc(_ hz:Double,_ t:Double)->Double {sin(2*Double.pi*hz*t)}
func envelope(_ t:Double)->Double {
 // A gentle opening, low narration bed, extra room for the quieter closing disclosure.
 let points:[(Double,Double)]=[(0,0),(0.65,1.5),(1.1,0.8),(21.65,0.8),(22.3,1.1),(22.85,1.1),(23.15,0.25),(25.65,0.25),(26.0,0.6),(27.65,0),(27.8,0)]
 for i in 1..<points.count where t<=points[i].0 {
  let a=points[i-1],b=points[i];return a.1+(b.1-a.1)*smooth((t-a.0)/(b.0-a.0))
 }
 return 0
}
struct Chord {let start:Double;let end:Double;let notes:[Double]}
let chords=[Chord(start:0,end:6.0,notes:[48,55,59,64,74]),Chord(start:5.0,end:11.0,notes:[45,55,60,64,71]),Chord(start:10.0,end:16.0,notes:[41,53,57,64,67]),Chord(start:15.0,end:22.65,notes:[43,55,57,62,67]),Chord(start:21.65,end:27.8,notes:[48,55,59,64,74])]
let melody:[(Double,Double)]=[(0.35,76),(0.90,79),(3.8,74),(7.9,76),(11.7,72),(14.4,76),(18.1,74),(21.8,79),(22.35,76),(26.0,72)]
Task {
 do {
  guard !FileManager.default.fileExists(atPath:output.path), !FileManager.default.fileExists(atPath:musicURL.path) else {fatalError("Preserving existing media")}
  let format=AVAudioFormat(standardFormatWithSampleRate:rate,channels:2)!
  let n=Int(duration*rate),buffer=AVAudioPCMBuffer(pcmFormat:format,frameCapacity:AVAudioFrameCount(n))!;buffer.frameLength=AVAudioFrameCount(n)
  let left=buffer.floatChannelData![0],right=buffer.floatChannelData![1]
  var sum=0.0
  for i in 0..<n {
   let t=Double(i)/rate
   var l=0.0,r=0.0
   for chord in chords where t>=chord.start && t<chord.end {
    let age=t-chord.start
    let env=smooth(age/1.2)*smooth((chord.end-t)/1.25)
    for (j,note) in chord.notes.enumerated() {
     let hz=frequency(note), weight=j==0 ? 0.18 : 0.12
     let tone=osc(hz,t)+0.17*osc(hz*2,t)+0.035*osc(hz*3,t)
     let soft=osc(hz*1.0013,t)*0.14
     let pan=Double(j%3-1)*0.25
     l += env*weight*(tone+soft)*(0.75-pan)
     r += env*weight*(tone+osc(hz*0.9987,t)*0.14)*(0.75+pan)
    }
   }
   for (index,note) in melody.enumerated() {
    let age=t-note.0
    if age>=0 && age<3.2 {
     let hz=frequency(note.1)
     let env=smooth(age/0.025)*exp(-age/0.60)*smooth((3.2-age)/0.3)
     let tone=(osc(hz,age)+0.23*exp(-age/0.25)*osc(hz*2,age)+0.06*osc(hz*3,age))*env*0.21
     l += tone*(index%2==0 ? 0.85 : 0.55);r += tone*(index%2==0 ? 0.55 : 0.85)
    }
   }
   left[i]=Float(l);right[i]=Float(r)
   if t>2 && t<21 {sum += (l*l+r*r)/2}
  }
  let referenceRMS=sqrt(sum/(19*rate))
  // Before envelope: -36 dBFS RMS. Main bed multiplier0.8 yields about -38 dBFS.
  let gain=pow(10,-36/20)/referenceRMS
  var peak=0.0
  for i in 0..<n {let g=Float(gain*envelope(Double(i)/rate));left[i] *= g;right[i] *= g;peak=max(peak,Double(max(abs(left[i]),abs(right[i]))))}
  var audioFile:AVAudioFile?=try AVAudioFile(forWriting:musicURL,settings:format.settings)
  try audioFile!.write(from:buffer)
  audioFile=nil // Finalize the WAV header before loading it as an AVAsset.
  let source=AVURLAsset(url:directory.appendingPathComponent("around-demo-narrated-final.mp4")),music=AVURLAsset(url:musicURL)
  let videoSource=try await source.loadTracks(withMediaType:.video)[0],voiceSource=try await source.loadTracks(withMediaType:.audio)[0],musicSource=try await music.loadTracks(withMediaType:.audio)[0]
  let composition=AVMutableComposition()
  let video=composition.addMutableTrack(withMediaType:.video,preferredTrackID:kCMPersistentTrackID_Invalid)!,voice=composition.addMutableTrack(withMediaType:.audio,preferredTrackID:kCMPersistentTrackID_Invalid)!,bed=composition.addMutableTrack(withMediaType:.audio,preferredTrackID:kCMPersistentTrackID_Invalid)!
  try video.insertTimeRange(CMTimeRange(start:.zero,duration:time(duration)),of:videoSource,at:.zero)
  let voiceRange=try await voiceSource.load(.timeRange)
  try voice.insertTimeRange(voiceRange,of:voiceSource,at:voiceRange.start)
  try bed.insertTimeRange(CMTimeRange(start:.zero,duration:time(duration)),of:musicSource,at:.zero)
  let mix=AVMutableAudioMix();let voiceLevel=AVMutableAudioMixInputParameters(track:voice),bedLevel=AVMutableAudioMixInputParameters(track:bed)
  voiceLevel.setVolume(1,at:.zero);bedLevel.setVolume(1,at:.zero);mix.inputParameters=[voiceLevel,bedLevel]
  let exporter=AVAssetExportSession(asset:composition,presetName:AVAssetExportPresetHighestQuality)!
  exporter.audioMix=mix;exporter.shouldOptimizeForNetworkUse=true;try await exporter.export(to:output,as:.mp4)
  let result=AVURLAsset(url:output),track=try await result.loadTracks(withMediaType:.video)[0]
  let formats=try await track.load(.formatDescriptions),size=try await track.load(.naturalSize)
  guard formats.count==1 else {fatalError("Multiple video formats")}
  let manifest:[String:Any]=["output":output.lastPathComponent,"sourceVideo":source.url.lastPathComponent,"music":musicURL.lastPathComponent,"musicOrigin":"Original synthesized chords and sparse notes, generated locally by scripts/media/add-demo-soundtrack.swift; no third-party recordings, samples or artist imitation.","status":"Soundtrack preview for owner listening approval","duration":try await result.load(.duration).seconds,"width":size.width,"height":size.height,"videoFormats":formats.count,"audioTracks":try await result.loadTracks(withMediaType:.audio).count,"musicPeakDBFS":20*log10(peak),"mainBedTargetRMSDBFS":-38,"disclaimerBedTargetRMSDBFS":-48,"voice":"Approved cleaned narration at unchanged volume, speed and timing.","reviewLimit":"Objective audio and playback checks only; subjective musical quality and voice balance require owner listening."]
  try JSONSerialization.data(withJSONObject:manifest,options:[.sortedKeys,.prettyPrinted]).write(to:directory.appendingPathComponent("\(stem).json"))
  print("Exported soundtrack preview: \(duration)s, one video format. Music peak \(20*log10(peak)) dBFS.");exit(0)
 }catch {print("Soundtrack render failed: \(error)");exit(1)}
}
dispatchMain()
