// Mix approved 2C Sparkle with the retimed Ring narration. No video/content changes.
import Foundation
import AVFoundation
let folder=URL(fileURLWithPath:FileManager.default.currentDirectoryPath).appendingPathComponent("data/recordings")
func t(_ x:Double)->CMTime {CMTime(seconds:x,preferredTimescale:60000)}
func gain(_ db:Double)->Float {Float(pow(10,db/20))}
Task {
 do {
  let source=AVURLAsset(url:folder.appendingPathComponent("around-demo-ring-voice.mp4")),music=AVURLAsset(url:folder.appendingPathComponent("sparkle-final-stem/2c-sparkle.wav"))
  let output=folder.appendingPathComponent("around-demo-ring-sparkle.mp4")
  guard !FileManager.default.fileExists(atPath:output.path) else {fatalError("Preserving existing output")}
  var manifest=try JSONSerialization.jsonObject(with:Data(contentsOf:folder.appendingPathComponent("around-demo-ring-voice.json"))) as! [String:Any]
  let duration=try await source.load(.duration),disclaimerStart=manifest["disclaimerStart"] as! Double,disclaimerEnd=manifest["disclaimerEnd"] as! Double,closing=manifest["closingLogoAppears"] as! Double
  let composition=AVMutableComposition()
  for kind in [AVMediaType.video,.audio] {
   let sourceTrack=try await source.loadTracks(withMediaType:kind)[0],track=composition.addMutableTrack(withMediaType:kind,preferredTrackID:kCMPersistentTrackID_Invalid)!
   let range=try await sourceTrack.load(.timeRange);try track.insertTimeRange(range,of:sourceTrack,at:range.start)
  }
  let bed=composition.addMutableTrack(withMediaType:.audio,preferredTrackID:kCMPersistentTrackID_Invalid)!,musicTrack=try await music.loadTracks(withMediaType:.audio)[0]
  try bed.insertTimeRange(CMTimeRange(start:.zero,duration:duration),of:musicTrack,at:.zero)
  let levels=AVMutableAudioMixInputParameters(track:bed)
  // Source stem is ~-20dBFS RMS. Keep it below the voice and lower again for the disclosure.
  levels.setVolumeRamp(fromStartVolume:0,toEndVolume:gain(-7),timeRange:CMTimeRange(start:.zero,duration:t(0.20)))
  levels.setVolumeRamp(fromStartVolume:gain(-7),toEndVolume:gain(-16),timeRange:CMTimeRange(start:t(0.72),duration:t(0.22)))
  levels.setVolumeRamp(fromStartVolume:gain(-16),toEndVolume:gain(-10),timeRange:CMTimeRange(start:t(closing-0.20),duration:t(0.30)))
  levels.setVolumeRamp(fromStartVolume:gain(-10),toEndVolume:gain(-24),timeRange:CMTimeRange(start:t(disclaimerStart-0.35),duration:t(0.25)))
  levels.setVolumeRamp(fromStartVolume:gain(-24),toEndVolume:gain(-12),timeRange:CMTimeRange(start:t(disclaimerEnd+0.15),duration:t(0.35)))
  levels.setVolumeRamp(fromStartVolume:gain(-12),toEndVolume:0,timeRange:CMTimeRange(start:t(duration.seconds-0.75),duration:t(0.65)))
  let mix=AVMutableAudioMix();mix.inputParameters=[levels]
  let exporter=AVAssetExportSession(asset:composition,presetName:AVAssetExportPresetHighestQuality)!
  exporter.audioMix=mix;exporter.shouldOptimizeForNetworkUse=true
  try await exporter.export(to:output,as:.mp4)
  let final=AVURLAsset(url:output),video=try await final.loadTracks(withMediaType:.video)[0],formats=try await video.load(.formatDescriptions)
  guard formats.count==1 else {fatalError("Expected one video format")}
  manifest["output"]=output.lastPathComponent;manifest["duration"]=try await final.load(.duration).seconds
  manifest["music"]="Selected 2C Sparkle, original local composition extended with the same repeating arrangement. No third-party recordings."
  manifest["musicStem"]="sparkle-final-stem/2c-sparkle.wav";manifest["musicGainDuringMainVoiceDB"] = -16;manifest["musicGainDuringDisclaimerDB"] = -24
  manifest["status"]="Full mix for owner listening review"
  manifest["questionRetake"]="Source0.50–2.86 at6.68, +7.5dB, unchanged speed."
  manifest["breathCleanup"]="Mute18.36–19.08 with 40ms boundary ramps."
  try JSONSerialization.data(withJSONObject:manifest,options:[.sortedKeys,.prettyPrinted]).write(to:folder.appendingPathComponent("around-demo-ring-sparkle.json"))
  print("Final Sparkle mix: \(duration.seconds)s, \(formats.count) video format, disclosure \(disclaimerStart)–\(disclaimerEnd).");exit(0)
 }catch {print("Mix failed: \(error)");exit(1)}
}
dispatchMain()
