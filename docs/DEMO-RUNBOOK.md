# Around demo runbook

Use two tabs running the same application with separate data. Keep the source label visible. The Ring tab proves the integration. The sample tab demonstrates the full visit story.

## Current handoff, September 30

Preserve the approved 29.3-second `data/recordings/around-demo-ring-sparkle.mp4` and its sidecars. Current verification, hash and remaining delivery work are in [SUBMISSION-READINESS](SUBMISSION-READINESS.md). Historical media entries below are receipts, not current instructions to renew keys, repeat inference or replace the master. Ask before any additional paid provider calls. No upload, publication or submission is authorized.

New local review: `data/recordings/around-submission-review-v9.mp4`, 83.3 seconds. Three numbered purpose cards orient hackathon judges. The opening uses the established Around logo and owner-requested tagline; captions omit redundant editing notes. It shows a recorded Playground control frame, actual simulator video playback, the successful fresh-sync result from a separate take, a labeled saved-record still, and the full approved sample once at seconds 49–78.3. Visual, audio-payload and uninterrupted browser-playback checks passed. Owner approved the section wording; review of the rendered v9 is pending. The owner-approved v6 is preserved unchanged.

The September 30 sync received one new live-view request at 10:54:33 AM Eastern. One device and three Ring live-view records are stored, with zero matches. The Motion control label does not turn the returned record into a classified detection. No Bedrock query occurred during this capture; its configuration label is not inference evidence.

The video is an edited sequence, not a continuous control-to-sync take. The password popup prevents a clean uninterrupted sync-action shot. The edit shows the recorded successful result, and labels the later saved-record still. No further token entry or provider request is needed to review or edit this material. Earlier takes, failures and their source hashes remain recorded in SUBMISSION-READINESS and FRICTION-LOG.

## Start the two tabs

Build once:

```sh
npm ci
npm run build
```

For the Ring tab, use the documented Playground configuration in `.env.local`:

```dotenv
RING_MODE=ring
RING_DEVICE_MODE=playground
AI_MODE=bedrock
AROUND_TIME_ZONE=America/New_York
AROUND_DB_PATH=data/around-ring-playground.sqlite
AWS_REGION=us-east-1
BEDROCK_MODEL_ID=amazon.nova-micro-v1:0
```

Start it with `npm start` and open http://127.0.0.1:3000. Existing Ring records are preserved. A fresh authorized Bedrock key can be entered in the temporary key field. It remains in page memory until cleared or reloaded. No key is distributed with the project.

In a second terminal:

```sh
npm run demo:sample
```

Open http://127.0.0.1:3001. This command explicitly selects sample events and local demo language, even if `.env.local` or the terminal selects Ring/Bedrock. Every launch uses a fresh database and preserves all earlier databases. It never calls Ring or Bedrock. Stop that terminal and rerun the command for a new rehearsal. Reloading the page within a running rehearsal preserves its records.

Optional, for a separately authorized recording using Bedrock with sample activity:

```sh
npm run demo:sample:bedrock
```

This still isolates sample events in a new database. Enter an authorized key in that tab; it is not shared with the Ring tab. The original sentence, plumber question and briefing use four Converse calls total: one parse, two for the visit question, and one for the explicit briefing. Do not start both sample commands on the same port. Set AROUND_DEMO_PORT to choose another port if needed.

## Part 1: real Ring and Bedrock

Steps 1 through 3 cover the current Ring capture. Steps 4 and 5 are the optional fresh Bedrock extension and require owner approval before paid calls. The current assembly plan in SUBMISSION-COPY uses the preserved sample master instead of repeating its requests.

1. Before recording, prepare valid credentials in the private setup fields. Keep token generation, credentials and account details off camera.
2. Open the official [Ring Developer Playground](https://developer.amazon.com/ring/console/playground). Its video controls generate live-view records, not classified motion. Record the interaction and Around syncing official history. A playback error does not prove video playback worked; a stored live-view request is still only a request.
3. Show the Ring Playground activity label and at least one actual dated activity card. Capture Sync Ring activity with credentials already prepared off camera, or crop the secret field. Never edit sample events into the Ring database.
4. Use an expectation on the same date as the records. For a same-day demo, enter the plumber sentence once, then ask Did the plumber come? If using older records, ask a dated question such as Did the plumber come on September 28, 2026? A daily briefing always covers today.
5. Show the answer's Amazon Bedrock label and expand its saved evidence. With only live views, it must not confirm a visit.

Our verified Ring records are from September 28 and September 30, 2026. There is also a September 29 plumber expectation parsed by Bedrock. Do not call old activity today's activity or create duplicate expectations in the same window. Fresh provider ingestion for a new recording requires a valid Ring token and actual provider access; this preparation step does not claim that a new sync occurred.

## Part 2: sample plumber visit

1. Use the fresh sample tab and leave Sample activity visible.
2. Enter The plumber is coming today between 10 and 1. once.
3. Click Play sample visit. Four moments become one probable visit and one likely expectation match.
4. Ask Did the plumber come? Show the 10:41 AM and 11:27 AM estimates and the qualification about identity.
5. Ask Anything I should know? Show the short briefing.
6. Expand the activity's four related moments. This segment demonstrates the implemented grouping and matching logic; the source remains sample data.

The default sample mode uses local demo answers. Label this in the recording and demonstrate actual Bedrock in Part 1. If the optional Bedrock sample mode is used, verify its actual responses before describing that segment as Bedrock-powered.

## Recording and delivery

Review the current 83.3-second edited cut described in SUBMISSION-COPY.md, or the optional 2:45 full-flow script only after its additional provider calls are approved. Trim pauses, not evidence or source labels. Use English narration or subtitles. The rules require a public YouTube or Vimeo video under three minutes and a GitHub repository with judge access. The source can run locally; do not expose this unauthenticated app publicly.

Repository visibility, any public license, upload destination, and final publication still need owner decisions. Organizer clarification is optional. The official FAQ permits Playground demos; the sample segment must remain disclosed. No hardware purchase is required for this preparation path.

## Local rehearsal recorded, September 29

The silent sample rehearsal is saved at `data/recordings/around-sample-rehearsal-2026-09-29T19-56-41-150Z.webm`. It is 54.8 seconds at 1280 by 900. Browser decoding and five representative frames were checked. The companion JSON identifies source mode, language mode and approximate scene timings; container timing differs slightly from the wall-clock action log.

The clip shows a fresh expectation, four grouped sample moments, a likely match, the qualified 10:41 to 11:27 answer and a briefing. It uses local answers and contains no audio or final captions. It is rehearsal material, not the complete submission video. Record your own narration using the read-aloud draft in SUBMISSION-COPY.md, then add matching captions during editing.

No fresh real Ring/Bedrock footage was recorded in this step. The twelve-call provider allowance is exhausted. Proposed next recording pass, subject to owner approval: refresh temporary Ring access, sync actual history, make one dated Ring question (two Bedrock calls), and record a fresh sample scenario using Bedrock (four calls). Maximum six additional Nova Micro calls within an additional $0.10 budget, using the existing narrowly scoped identity without expanding permissions. Stop on an access error rather than repeating calls. Any credential renewal must be explicitly covered by that approval and kept off camera.

### Current recording handoff

Owner approved the six-call extension and completed replacement-key entry after the scoped cleanup in CREDENTIAL-RECOVERY.md. The Chrome sample page at port 3003 completed the actual Bedrock flow in calls 13–16: expectation parse, qualified visit answer and briefing. Two additional calls remain for the real Ring segment. Do not repeat inference to repair camera framing.

The owner-started MOV is 224.9 seconds at 340 by 430 pixels, with one audio track. Thirteen inspected frames show a static crop of the empty credential section in the Codex browser, not the Chrome demo interaction. This footage is not usable for submission. Preserve it as failed capture evidence; do not publish it. Audio has not been reviewed.

Chrome's actual sample window has been raised to the foreground. For the corrected capture, verify that the frame contains the Around Home page and Sample activity/Amazon Bedrock labels, with credentials outside the frame. Show existing saved expectations, the likely visit match and the current Bedrock briefing without another provider request. A full recorded replay of parsing and the prior answer is not currently available. The real Ring segment still requires valid Ring access and a separate recording. Check the saved video before claiming a usable segment.

### Corrected results clip, verified

The second Desktop take, Screen Recording 2026-09-29 at 5.02.51 PM.mov, shows the correct Chrome page. The original is preserved and a copy is saved as `data/recordings/around-bedrock-results-2026-09-29.mov` (143.803 seconds, 952 by 886, one audio track). The unedited take briefly includes masked credential controls. Do not use that section in the submission.

Previous pacing edit, `data/recordings/around-bedrock-results-tight.mp4`: a 15-second silent edit using source intervals 23.3–28.8, 36.3–43.8 and 80–82 seconds. This pacing revision follows owner feedback that the opening and pauses between actions were too long. The previous 38-second edit is preserved. It shows source labels, the previously generated Bedrock briefing, expanded saved evidence, and matched visit/expectation cards. Long pauses, original audio and the credential-controls section are omitted. The edit manifest is alongside the MP4. Decoding, duration, dimensions, zero audio tracks and ten representative frames including both cut boundaries were verified for the tighter edit.

This is usable saved-results footage. It does not replay expectation parsing, the original visit-question request, or actual Ring ingestion. Narration must describe those limits accurately. No additional provider calls were used for this corrected take or editing; sixteen calls overall, two approved calls remain. Real Ring footage, narration/captions, final assembly and publication remain unfinished.

### Readability revision

Superseded close-crop review copy: `data/recordings/around-bedrock-results-readable-v2.mp4`. This 15-second silent edit uses close crops of the saved answer and matched visit cards, rendered at 1280 by 800. Source intervals are 23.3–28.8, 38–45.5 and 80–82 seconds. A persistent disclosure identifies sample activity, Amazon Bedrock and saved results, and states that these demonstration events were not received from Ring. Original source pixels are enlarged, so this improves framing but cannot recover recording sharpness. A future take should use a larger browser zoom and focused views.

Verified duration, dimensions, no audio, and eight exact-time frames including both cut boundaries. The first close-crop export omitted CATextLayer overlays; it remains an intermediate artifact and is not the delivery copy. Rendering the labels as bitmap layer contents corrected the omission in v2. Earlier videos and originals remain preserved. No app changes or provider calls were made.

### Larger browser zoom, full app frame

Approved app-only review copy: `data/recordings/around-app-view-final.mp4`, 22 seconds, 970 by 920, silent. The owner recorded a fresh take at 150% browser zoom. Source: Desktop Screen Recording 2026-09-29 at 5.37.29 PM.mov, preserved locally as `data/recordings/around-app-view-2026-09-29.mov` (83.227 seconds, one audio track). Original audio is preserved in the source but omitted from this review edit.

Retained source intervals: 32.5–37, 40–49, and 60–68.5 seconds. The full captured app frame is preserved with no cropping, added margins or overlays. Sidebar remains visible throughout; opening and closing include the header/date, sample disclosure and orange Ask section. Scrolling shows the saved Bedrock answer and evidence, probable visit and plumber expectation. Ten exact-time frames, including both cut boundaries, were inspected. Duration, original dimensions and zero audio tracks verified. No credentials appear in the reviewed frames.

This supersedes the close-crop versions after owner feedback that those lost the app appearance and added unnecessary blank space. No provider calls or app changes. This remains saved-results footage, not a recording of request submission or actual Ring ingestion.

### Animated logo opener

Superseded export: `data/recordings/around-demo-with-logo.mp4`, 24.6 seconds, 970 by 920, silent. Standalone opener: `data/recordings/around-logo-intro.mp4` (2.6 seconds, 60 fps). The app-only 22-second source remains preserved and is appended with its framing and timing intact.

The orange mark fades in, its inner Radio symbol turns clockwise, and the wordmark spins out to the right. The smaller dark tagline reads “Spatial intelligence for your home.” The final logo holds briefly before the app view. Colors follow app CSS: orange #E17342, wordmark/tagline #352B26, mark lines #2D201B, background #FFFAF5. Arial and the Lucide Radio arc/circle design follow the existing app logo.

Reproducible local renderer: `scripts/media/render-logo-intro.swift` (macOS Swift with AVFoundation, Core Graphics and Core Text). It refuses to overwrite existing outputs. Manifest: `data/recordings/around-demo-with-logo.json`. Verified combined duration, dimensions, no audio and twelve decoded frames covering animation, settled tagline, transition and app footage. This branding addition makes no new integration claims and used no provider calls. Real Ring footage, narration and final submission assembly remain pending.

### Joined-video playback repair

Approved opener-and-demo copy: `data/recordings/around-demo-with-logo-compatible.mp4`. The owner reported that the animated opener played but subsequent footage was white. Earlier AVFoundation frame extraction showed the app correctly, so frame extraction alone had not established normal playback compatibility. Preserve the earlier export as the failure artifact.

The earlier combined track contains two AVC format descriptions; both input clips have one. This is a likely compatibility cause, not a conclusively reproduced failure in the original player. `scripts/media/normalize-demo-video.swift` fully decodes and re-encodes the combined file with one H.264 configuration. No crop or content edits. Original source clips and approved opener are preserved. This normalization step is required after running the logo renderer.

Repaired output: 970 by 920, one AVC format description, no audio, 24.6167 seconds by AVFoundation (24.6 in browser). Do not claim constant frame rate: the nominal measured rate is about 50.64 despite a 60 fps composition target. The video played continuously in the Codex in-app browser from load without seeking: app answer visible after the opener, visit and expectation cards visible at 21.575 seconds, then final Home frame at ended=true, currentTime=24.6, error=null. This checks actual browser playback, not only extracted frames. User acceptance in their exact file-preview surface remains pending. No provider calls.

### Reverse-logo ending

Approved silent copy: `data/recordings/around-demo-complete.mp4`, 27.7167 seconds, 970 by 920, silent, one AVC format description. The approved opener/demo is followed by the same 2.6-second logo animation played in reverse, then a half-second hold on blank cream. Standalone ending: `data/recordings/around-logo-outro.mp4`. Earlier approved videos remain preserved.

Render with `swift scripts/media/render-logo-intro.swift --outro`, then normalize `around-demo-with-outro-joined.mp4` to `around-demo-complete.mp4` using `scripts/media/normalize-demo-video.swift` with those two filenames as arguments. Do not deliver the intermediate joined export. Eleven decoded frames cover both joins and the reverse animation, including blank frames at 27.3 and 27.7 seconds. Continuous in-app browser playback showed app cards at 17.57 seconds and ended on cream at 27.7167 seconds with ended=true and error=null. No provider calls or product behavior changes. This is still a saved-results demo segment; the filename does not imply complete hackathon submission evidence.

### Voiceover and captions prepared

The current short narration lives in SUBMISSION-COPY.md under “Narration for the approved 27.7-second visual cut.” Plain read-aloud text and draft SRT/VTT captions are in `data/recordings/around-demo-voiceover.txt` and `around-demo-captions-draft.*`. Six cues fit within the approved clip and identify sample activity, the saved Bedrock briefing, likely timing match and unconfirmed identity. Awaiting the owner's audio recording; retime captions to actual speech before muxing. The silent visual cut is preserved.

Voiceover revision: the owner rejected the first short script for insufficient product introduction, clinical phrasing and an early disclosure. A dedicated copywriter provided the new consumer-focused draft now saved in SUBMISSION-COPY.md and the voiceover/caption files. It follows the visible answer and expectation cards, keeps “likely visit,” and closes with the sample/Bedrock disclosure. Eight caption cues cover six narration beats. Audio recording and final speech alignment remain pending.

Approved voiceover wording updated after owner revisions: consumer purpose first, “Yeah, it looks like the plumber came around 10:41 and left around 11:27,” then the connection between expectations and recorded activity, and sample/Bedrock disclosure last. Source of truth is SUBMISSION-COPY.md. The read-aloud file and provisional captions now match that wording. Plan roughly 35 seconds of natural speech; extend answer and card holds after audio is available. The existing 27.7167-second silent video is unchanged. Draft caption timestamps target the future narration edit and must not be treated as synced to the current video.

### Owner narration and captions, review cut

Previous narrated review copy: `data/recordings/around-demo-narrated-captioned.mp4`, 26.6833 seconds, 970 by 920, one video format and one audio track. Owner supplied New Recording 8.m4a and explicitly confirmed the approved script was read word for word. Original audio is preserved as `around-owner-voice-original.m4a`. No external transcription or provider calls.

The original 26.068-second narration is placed at time zero without speech edits or speed changes, with 4.5 dB gain. Exported audio decodes to 26.0667 seconds and peaks at -5.334 dBFS, with no sample clipping. Caption wording matches the confirmed script. Timing follows measured speech pauses, not a machine transcript; exact spoken alignment and audible quality still require owner listening review. Sidecar SRT/VTT: `around-demo-narrated-captioned.*`.

Video keeps the opener and answer sequence, brings the visit/expectation cards forward to 13.1 seconds, starts the reverse logo at 22.15 seconds for the closing disclosure, and ends blank. Original assets and earlier approved cuts remain preserved. `scripts/media/assemble-narrated-demo.swift` renders the composition and captions locally. Twelve decoded frames verify caption placement and both animation transitions. Actual in-app browser playback showed captioned app footage with muted=false and ended at 26.6833 seconds with error=null and cream visible. This verifies playback and technical audio presence, not subjective listening quality.

### Closing disclaimer refinement

Current review copy: `data/recordings/around-demo-narrated-refined.mp4`, 27.8 seconds. Owner requested a quieter, faster closing disclaimer after a longer pause on the logo, with no caption for that line. Main narration and its seven caption cues are unchanged.

Closing logo appears at 22.15 seconds. The disclaimer segment is inserted at 23.2 seconds from original audio 22.0–24.88, at 1.2x speed with spectral pitch preservation. Source gain is -1.5 dB versus +4.5 dB for main narration, a 6 dB reduction relative to the previous line treatment. Measured disclaimer RMS changed from -27.57 to -33.84 dBFS; the 22.15–23.2 pause measures about -111.9 dBFS. The logo remains settled through the disclaimer, then reverses and ends blank. Caption sidecars `around-demo-narrated-refined.srt` and `.vtt` omit the line as requested. Original exports are preserved. Six decoded frames verify the uncaptained logo hold, reversal and blank ending. Subjective listening approval remains with the owner.

### Question field visual revision

Current review copy: `data/recordings/around-demo-narrated-typed.mp4`, 27.8 seconds, 970 by 920, one video format and one audio track. Run `swift scripts/media/assemble-narrated-demo.swift --typed-input` to reproduce into a new output location after preserving existing exports. The renderer refuses to overwrite existing output.

The field begins empty, types exact lowercase `did the plumber come` from 5.22 to 5.94 seconds, and retains the text afterward. A decorative microphone is drawn beside the existing arrow. The patch follows the input through the recorded scroll, beneath the unchanged caption layers. This is a video reconstruction, not a newly recorded submission, provider response or working voice input. App source is unchanged; no provider calls were made.

Twelve decoded frames verify progressive typing, scroll alignment, source labels, the uncaptioned closing logo and blank ending. The render preserves the existing narration segments, seven captions, delayed quieter 1.2x disclaimer, duration and frame size. Timing remains based on owner-confirmed wording and measured speech pauses; final audible alignment is for owner review. Earlier versions and original voice remain preserved.

Continuous in-app browser playback showed the edited input and microphone at 7.06 seconds, then ended at 27.8 seconds with error=null and blank cream visible. Temporary server and preview tab were closed.

### Owner question retake

Current review copy: `data/recordings/around-demo-narrated-retake.mp4`, 27.8 seconds. New Recording 10.m4a is preserved as `around-owner-question-retake.m4a`. Local energy analysis places speech around 0.60–1.40 and 2.00–2.70 seconds. Source 0.50–2.86 is inserted at 5.18, with natural speed and +7.5 dB gain. Original audio 5.08–7.60 is removed, so no old phrase remains underneath. Ten-millisecond fades sit in quiet splice boundaries. The remainder of the original narration retains its timing.

Typing now spans 5.26–6.06. The Ask Around caption spans 6.60–7.55; all other cues remain unchanged. New SRT/VTT sidecars reflect the revised cues. Export has one video format, one audio track, 970 by 920 dimensions and decoded peak -5.334 dBFS with no sample clipping. Eight frames verify typing, captions and closing visuals. Timing is inferred from supplied wording and audio energy, not a machine transcript. Audible splice/tonal quality and final synchronization require owner listening. Reproduce with `swift scripts/media/assemble-narrated-demo.swift --question-retake`; output preservation guards remain.

Browser playback visibly showed typing at 5.56 seconds and reached 27.8 seconds with ended=true and error=null. Temporary preview and local server were closed.

### Breath cleanup

Current review: `data/recordings/around-demo-narrated-final.mp4`. Owner requested removal of the inhalation after “and connects it to what happened.” The pause is muted from 16.86 to 17.58 seconds, with 40 ms ramps from 16.82 and back to full level at 17.62. Adjacent speech ends around 16.80 and resumes around 17.68. No video, caption, wording or timeline changes. Reproduce with `swift scripts/media/assemble-narrated-demo.swift --clean-breath`. Earlier exports remain preserved.

Decoded audio checks confirm the pause is below -90 dBFS and neighboring phrases, replacement take and closing disclaimer differ by less than 0.5 dB RMS from the approved retake export. Overall peak remains -5.334 dBFS. Export remains 27.8 seconds with one video format and one audio track. Audible quality remains for owner review.

### Optional soundtrack preview

`data/recordings/around-demo-with-soundtrack.mp4` adds a locally synthesized original instrumental bed to the approved `around-demo-narrated-final.mp4`. No third-party recording, musical sample, external upload or provider call was used. Source composition and synthesis are in `scripts/media/add-demo-soundtrack.swift`; the stereo WAV stem is `around-original-light-soundtrack.wav`.

The bed uses slow chords and sparse plucked notes, with no vocals or percussion. Nominal main bed is about -38 dBFS RMS, reduced further toward -48 under the softer closing disclosure. Opening and ending fades are built into the stem. The narration retains its approved gain, speed and timing, including the new question take and removed breath. Video and caption timing are unchanged. Export duration 27.8 seconds, one video format, one audio track. Objective peak and playback checks support technical delivery; musical character and balance require owner listening approval. The no-music version remains preserved and approved.

Soundtrack preview decoded mix peak: -5.247 dBFS across both channels, with no sample clipping. Browser playback reached 27.8 seconds, ended=true and error=null. Temporary preview and local server were closed.

### Peppier soundtrack directions, awaiting selection

Owner found the first soundtrack too subdued and requested standalone choices before mixing. Three original locally synthesized sketches are in `data/recordings/soundtrack-options/`: `01-bright-and-breezy.wav` (112 BPM, 9.97 seconds), `02-curious-and-clever.wav` (104 BPM, 10.63 seconds), and `03-a-little-momentum.wav` (120 BPM, 9.4 seconds). Arrangements use plucked keys, mallet-like notes, bass and light synthesized percussion. These are musical direction samples, not third-party recordings.

Reproduce with `scripts/media/render-soundtrack-options.swift`. Every saved file was decoded and checked for finite samples, duration, nonzero audio and absence of sample clipping. All three measure -20 dBFS RMS, with peaks from -4.70 to -3.32 dBFS. Short fades are included. Comparable measured levels do not establish equal perceived loudness or subjective quality. No track was added to the video; owner selection is required before the next mix. The approved no-music video and prior preview remain preserved.

### Brighter variations on direction 2

Owner selected Curious & Clever as closest and requested brighter, happier variations before mixing. New standalone files in `data/recordings/soundtrack-variations/`: 2A Sunny (108 BPM, 10.29s), 2B Extra Bounce (114 BPM, 9.82s), 2C Sparkle (118 BPM, 9.54s). All retain mallet-like notes and syncopation. Major chord progressions replace the original minor second chord; melodies rise and the mallet harmonics are brighter. 2B adds rhythmic accents; 2C uses a higher register and longer bright note decay.

Created by `scripts/media/render-soundtrack-variations.swift`. Saved WAV files were decoded and verified: RMS -20.36 to -20.00 dBFS, peaks -3.67 to -3.00 dBFS, finite samples and no clipping. These are objective checks, not an audible quality assessment. Earlier samples and the approved video remain unchanged. Await owner selection before mixing.

### Ring line on opening card

`data/recordings/around-demo-ring-card.mp4` adds “Works with Ring” beneath the opening tagline, fading in at 1.18 seconds and ending with the card at 2.6 seconds. Existing audio and captions remain unchanged. The owner approved new wording, “It works with Ring to help you manage what’s happening at home.” That replacement recording is pending; this intermediate visual export still contains the previous spoken sentence. `SUBMISSION-COPY.md` and the read-aloud script reflect the new approved wording.

Owner selected 2C Sparkle as the soundtrack direction. Keep its final video mix pending the new narration and retiming. Reproduce the visual intermediate with `swift scripts/media/assemble-narrated-demo.swift --ring-card`. Decoded frames at 2.3 and 2.8 seconds verify the line on the logo and its absence on the app frame. Export duration remains 27.8 seconds with one video format and one audio track.

### Confirmed Ring opening and selected Sparkle mix

Current review copy: `data/recordings/around-demo-ring-sparkle.mp4` (29.3 seconds). The owner clarified that New Recording 13.m4a starts “This is Around,” followed by “It works with Ring to help you manage what’s happening at home.” Original preserved as `around-owner-ring-intro-retake.m4a`. Source0.90–6.25 plays at the same timeline positions at natural speed and +4.5dB; the original opening is removed. Energy indicates speech at1.1–2.5 and3.2–6.2, with the quiet tail retained through6.25.

The opening logo is held an extra0.5s and the initial app view an extra1.0s. Every later segment shifts1.5s: question take at6.68, typing6.76–7.56, closing logo23.65, disclosure24.7–27.1. Caption sidecars are regenerated, including the approved Ring/manage-home line. The breath mute moves to18.36–19.08 with40ms ramps. Nine decoded frames verify new captions, typing, Ring label and blank ending.

Selected 2C Sparkle is extended using the same chord/melody/percussion arrangement. The stem measures -20dBFS RMS; it is mixed at -16dB gain during main narration, and -24dB during the quieter disclosure. Music rises modestly on logo sections and fades before the blank ending. Narration gains are unchanged. Decoded combined peak is -3.982dBFS with no sample clipping. Measured downstream narration levels match the prior approved version within0.5dB after compensating for the1.5s shift. The cleaned breath gap remains below -90dBFS before music.

Reproduce in order: `assemble-narrated-demo.swift --ring-voice`, `render-sparkle-final.swift`, `mix-sparkle-demo.swift`. Output preservation guards remain. Local-only composition, no provider calls or uploads. Current files are technical review artifacts, with audible balance and exact spoken timing awaiting owner listening. Prior recordings, edits and no-music export remain preserved.

Continuous browser playback displayed the updated app caption at5.75s and ended at29.3s with error=null and audio unmuted. Temporary server and preview tab were closed.

### Owner approval

Owner approved `data/recordings/around-demo-ring-sparkle.mp4` in conversation: “I'm happy with this version.” Treat this 29.3-second file as the approved sample demo master, with matching `.srt`, `.vtt` and `.json` sidecars. This resolves owner listening review for this version. Keep it unchanged unless further edits are requested. Remaining full-submission evidence and publication steps are separate.


## September 30 fresh Ring review

`data/recordings/around-submission-review-v7.mp4` is a separate 59.3-second review. It combines a recorded Playground control still, cropped simulator playback, the recorded successful fresh-sync result, a labeled current saved-record still, and the full approved sample once. Preserve the approved sample and v6. The new event is September 30 at 10:54:33 AM Eastern, `live_view`, source Ring; one device, three events, zero matches.

This edit does not include an unobscured sync click or represent a continuous take. The native password prompt and credential controls are excluded. Audio from the raw takes is omitted; the sample's original compressed audio is retained. Technical checks and owner approval status belong in SUBMISSION-READINESS.md. Do not re-enter a token or repeat provider execution to repair this edit. Publication, upload and submission remain approval gates.
