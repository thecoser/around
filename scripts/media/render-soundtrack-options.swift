// Three original local music sketches for owner selection. Does not edit or mix the video.
import Foundation
import AVFoundation
let folder=URL(fileURLWithPath:FileManager.default.currentDirectoryPath).appendingPathComponent("data/recordings/soundtrack-options")
try FileManager.default.createDirectory(at:folder,withIntermediateDirectories:true)
let rate=48000.0
func sine(_ f:Double,_ t:Double)->Double {sin(2*Double.pi*f*t)}
func hz(_ note:Double)->Double {440*pow(2,(note-69)/12)}
func ease(_ x:Double)->Double {let p=max(0,min(1,x));return p*p*(3-2*p)}
struct Sound {let start:Double;let note:Double;let kind:Int;let amplitude:Double;let pan:Double;let length:Double}
struct Option {let slug:String;let title:String;let bpm:Double;let style:Int;let description:String}
let options=[
 Option(slug:"01-bright-and-breezy",title:"Bright & Breezy",bpm:112,style:0,description:"Bright plucked chords, a bouncy bass line and a light pop beat."),
 Option(slug:"02-curious-and-clever",title:"Curious & Clever",bpm:104,style:1,description:"Playful mallet melody, syncopated bass and small woodblock clicks."),
 Option(slug:"03-a-little-momentum",title:"A Little Momentum",bpm:120,style:2,description:"Crisp electronic keys, a steady beat and a rising three-note motif.")]
var results:[[String:Any]]=[]
for option in options {
 let url=folder.appendingPathComponent(option.slug+".wav")
 guard !FileManager.default.fileExists(atPath:url.path) else {fatalError("Preserving existing option")}
 let beat=60/option.bpm,duration=16*beat+1.4,n=Int(duration*rate)
 var sounds:[Sound]=[]
 func add(_ b:Double,_ note:Double,_ kind:Int,_ amplitude:Double,_ pan:Double=0,_ length:Double=0.7){sounds.append(Sound(start:0.04+b*beat,note:note,kind:kind,amplitude:amplitude,pan:pan,length:length))}
 let chords:[[Double]]=option.style==1 ? [[62,66,69,76],[59,62,66,73],[55,62,66,69],[57,61,64,71]] : [[60,64,67,74],[57,60,64,71],[53,57,60,67],[55,59,62,69]]
 let roots:[Double]=option.style==1 ? [38,35,31,33] : [36,33,29,31]
 for bar in 0..<4 {
  let b=Double(bar*4),chord=chords[bar]
  let strums:[Double]=option.style==0 ? [0,1.5,2.5,3.5] : option.style==1 ? [0,1.75,3] : [0,0.75,1.5,2.5,3.25]
  for (k,offset) in strums.enumerated(){for (j,note) in chord.enumerated(){add(b+offset+Double(j)*0.018,note,option.style==1 ? 1 : 0,0.065*(k==0 ? 1.0 : 0.76),Double(j-2)*0.17,option.style==2 ? 0.38 : 0.65)}}
  for (offset,note) in [(0.0,roots[bar]),(1.5,roots[bar]+7),(2.0,roots[bar]),(3.25,roots[bar]+12)]{add(b+offset,note,2,0.15,0,0.35)}
  let kicks:[Double]=option.style==1 ? [0,2.5] : option.style==0 ? [0,2,2.75] : [0,1,2,3]
  for offset in kicks {add(b+offset,0,3,0.23,0,0.23)}
  for offset in [1.0,3.0]{add(b+offset,0,option.style==1 ? 6 : 4,option.style==1 ? 0.10 : 0.10,0.1,0.12)}
  for half in 0..<8{add(b+Double(half)*0.5+(option.style==1 && half%2==1 ? 0.07 : 0),0,5,half%2==0 ? 0.017 : 0.027,half%2==0 ? -0.4 : 0.4,0.06)}
  let motif:[(Double,Double)]
  if option.style==0 {motif=[(0.5,chord[2]+12),(1,chord[1]+12),(2.5,chord[3]),(3,chord[2]+12)]}
  else if option.style==1 {motif=[(0.0,chord[1]+12),(0.75,chord[2]+12),(1.5,chord[3]),(2.75,chord[2]+12),(3.5,chord[1]+12)]}
  else {motif=[(0.5,chord[0]+12),(1.5,chord[1]+12),(2.25,chord[2]+12),(3.5,chord[1]+12)]}
  for (k,pair) in motif.enumerated(){add(b+pair.0,pair.1,1,option.style==1 ? 0.13 : 0.095,k%2==0 ? -0.15 : 0.15,1.05)}
 }
 for (j,note) in chords[0].enumerated(){add(16,note,0,0.065,Double(j-2)*0.17,1.2)}
 add(16,roots[0],2,0.11,0,0.8)
 let format=AVAudioFormat(standardFormatWithSampleRate:rate,channels:2)!
 let buffer=AVAudioPCMBuffer(pcmFormat:format,frameCapacity:AVAudioFrameCount(n))!;buffer.frameLength=AVAudioFrameCount(n)
 let l=buffer.floatChannelData![0],r=buffer.floatChannelData![1]
 var seed:UInt64=0xA20A2026
 for sound in sounds {
  let first=Int(sound.start*rate),last=min(n,first+Int(sound.length*rate)),frequency=hz(sound.note)
  if first>=last {continue}
  for i in first..<last {
   let age=Double(i-first)/rate,tail=ease((sound.length-age)/0.04),attack=ease(age/0.005)
   seed=seed &* 6364136223846793005 &+ 1442695040888963407
   let noise=Double((seed>>32)&0xffff)/32767.5-1
   let value:Double
   switch sound.kind {
   case 0: // Rounded, bright plucked keys.
    value=(sine(frequency,age)+0.35*sine(frequency*2,age)+0.13*sine(frequency*3,age)+0.05*sine(frequency*4,age))*exp(-age/(option.style==2 ? 0.12 : 0.21))*attack
   case 1: // Wooden/mallet-like note, with a quiet delayed echo.
    let direct=(sine(frequency,age)+0.24*sine(frequency*3,age)*exp(-age/0.07))*exp(-age/0.24)*attack
    let delay=age-beat*0.75
    value=direct+(delay>0 ? sine(frequency,delay)*exp(-delay/0.20)*ease(delay/0.008)*0.14 : 0)
   case 2:
    value=(sine(frequency,age)+0.16*sine(frequency*2,age))*exp(-age/0.18)*ease(age/0.012)
   case 3:
    let phase=2*Double.pi*(49*age+48*0.025*(1-exp(-age/0.025)))
    value=sin(phase)*exp(-age/0.065)*ease(age/0.002)
   case 4:
    value=(noise*0.7+sine(185,age)*0.3)*exp(-age/0.025)*ease(age/0.001)
   case 5:
    value=(noise*0.35+sine(7800,age)*sine(11100,age)*0.65)*exp(-age/0.014)*ease(age/0.001)
   default:
    value=(sine(1250,age)+0.35*sine(1920,age))*exp(-age/0.019)*ease(age/0.001)
   }
   let x=value*sound.amplitude*tail
   l[i]+=Float(x*sqrt((1-sound.pan)/2));r[i]+=Float(x*sqrt((1+sound.pan)/2))
  }
 }
 var sum=0.0,peak=0.0
 for i in 0..<n {let t=Double(i)/rate,fade=Float(ease(t/0.018)*ease((duration-t)/0.6));l[i] *= fade;r[i] *= fade;sum += Double(l[i]*l[i]+r[i]*r[i])/2;peak=max(peak,Double(max(abs(l[i]),abs(r[i]))))}
 let rms=sqrt(sum/Double(n)),gain=min(pow(10,-20/20)/rms,pow(10,-3/20)/peak)
 for i in 0..<n {l[i] *= Float(gain);r[i] *= Float(gain)}
 let settings:[String:Any]=[AVFormatIDKey:kAudioFormatLinearPCM,AVSampleRateKey:rate,AVNumberOfChannelsKey:2,AVLinearPCMBitDepthKey:16,AVLinearPCMIsFloatKey:false,AVLinearPCMIsBigEndianKey:false,AVLinearPCMIsNonInterleaved:false]
 var file:AVAudioFile?=try AVAudioFile(forWriting:url,settings:settings);try file!.write(from:buffer);file=nil
 // Decode every sample, verify the actual saved file rather than only synthesis buffers.
 let check=try AVAudioFile(forReading:url),decoded=AVAudioPCMBuffer(pcmFormat:check.processingFormat,frameCapacity:AVAudioFrameCount(check.length))!;try check.read(into:decoded)
 var decodedPeak:Float=0,decodedSum=0.0
 for c in 0..<2 {for i in 0..<Int(decoded.frameLength){let v=decoded.floatChannelData![c][i];guard v.isFinite else {fatalError("Invalid sample")};decodedPeak=max(decodedPeak,abs(v));decodedSum += Double(v*v)}}
 let actualRMS=sqrt(decodedSum/Double(decoded.frameLength)/2)
 guard decodedPeak<0.95,actualRMS>0.01 else {fatalError("Audio level check failed")}
 results.append(["title":option.title,"file":url.lastPathComponent,"bpm":option.bpm,"description":option.description,"duration":Double(decoded.frameLength)/rate,"peakDBFS":20*log10(Double(decodedPeak)),"rmsDBFS":20*log10(actualRMS),"origin":"Original local synthesis, no third-party recordings or samples","status":"Standalone direction sample, not mixed into video; owner selection pending"])
 print("\(option.title): \(Double(decoded.frameLength)/rate)s, peak \(20*log10(Double(decodedPeak))) dBFS, RMS \(20*log10(actualRMS)) dBFS")
}
try JSONSerialization.data(withJSONObject:results,options:[.prettyPrinted,.sortedKeys]).write(to:folder.appendingPathComponent("options.json"))
