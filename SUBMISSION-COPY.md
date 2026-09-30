# Around

Spatial intelligence for your home.

Around helps you stay on top of what is happening around your home. Tell Around what you are expecting, then ask simple questions about what happened.

## Submission status

This is the source of truth for Devpost wording. The text is a prepared draft, not a published submission. The MVP covers expected home visits and activity summaries. Delivery tracking, identity recognition and home automation are not implemented.

Current readiness: [verification and delivery checklist](docs/SUBMISSION-READINESS.md). Judge instructions: [JUDGE-GUIDE](docs/JUDGE-GUIDE.md). The approved sample video is `data/recordings/around-demo-ring-sparkle.mp4`, 29.3 seconds. Preserve it unchanged. Earlier media versions below are historical. Additional paid provider calls require fresh owner approval; older unused-call allowances are not current authorization.

We are proceeding with a transparent two-part demonstration. The official [FAQ](https://amazonappdev2026.devpost.com/details/faqs) permits the Ring Developer Playground and does not require physical hardware. Organizer clarification is optional, not a stated submission prerequisite. We have not received an individual eligibility decision and do not claim one.

## What it does

Around connects what you expect with the activity recorded around your home.

Tell Around, “The plumber is coming today between 10 and 1.” In the sample visit scenario, related driveway and front-door events become one probable visit. Around compares its timing with the expected window. Ask “Did the plumber come?” and it gives estimated arrival and departure times while explaining that timing cannot confirm the visitor's identity.

The real Ring integration reads device information and event history from the official Playground. These records currently describe requests to open a live view. Around shows them accurately and can explain that they are insufficient to confirm a visitor. “Anything I should know?” gives a short briefing based on stored activity and expectations.

## How we built it

Around is one Next.js application using React, TypeScript, Tailwind CSS and SQLite. Deterministic code groups nearby events and matches visits to expectation windows. The Ring adapter calls official device discovery and event-history endpoints. It also implements signed webhook ingestion, which is tested against the documented contract but has not received a live webhook.

Amazon Bedrock's Converse API, using Amazon Nova Micro, parses expectations, interprets natural-language questions and selects complete, evidence-backed statements for answers. The explicit briefing shortcuts route deterministically. Dates, grouping, matching and uncertainty stay outside the model. Unsupported model selections are rejected, and provider failures remain visible.

The sample adapter uses the same storage, grouping and matching code as the Ring adapter. It runs in a separate database and is visibly labeled. We do not present sample detections as events produced by Ring.

## What we verified

- Around called the official Ring APIs, received one Playground device and two live-view records, stored them, and displayed their timestamps.
- Around used Bedrock to parse the original plumber sentence into the correct date and 10:00–13:00 window.
- A dated question about the stored Ring records selected the correct expectation and cited the live-view request while declining to confirm a visit.
- The corrected daily briefing used Bedrock and kept yesterday's Ring activity separate from today's expectations.
- The labeled four-event sample produced one probable visit, a likely plumber match and estimated bounds of 10:41 AM to 11:27 AM.
- TypeScript, lint, 31 targeted tests, a production build and three browser scenarios pass. Mocked API tests and actual provider results are identified separately. Two September 30 syncs succeeded and added no duplicates. The initial recorded take has a native password-save popup over its result. A later saved-result continuation yielded a clear 19-second review excerpt, and a repaired combined review is available; the latest edit removes the repeated Home walkthrough. The official Playground and unobscured sync footage remain pending. The earlier sync failure's cause remains unresolved.

The positive two-device visit is verified with sample events only. Classified motion and a positive visit match have not been exercised using live Ring detections. Bedrock has been verified with actual Ring records and, on September 29, with the full positive sample story: expectation parsing, the qualified visit answer and the daily briefing all succeeded in four additional Converse calls. The approved 29.3-second narrated sample video shows saved results. It does not show the original requests or real Ring ingestion. Its typing sequence and decorative microphone are edited visuals; voice input is not implemented. The real Ring recording remains unfinished.

## Available local review media

Current combined review: `data/recordings/around-submission-review-v6.mp4`, 46.1 seconds. It includes a six-second saved Ring evidence card, a 4.9-second sample transition, the full approved 29.3-second sample once with original audio, and a 5.9-second closing disclosure. The repeated Ring Home walkthrough is removed. The sample source file is unchanged. Frame, compressed-audio and continuous-playback checks passed. Official Playground interaction, unobscured sync footage and owner review remain open.

The separate silent Ring excerpt and approved sample master remain available. Earlier combined exports failed and are preserved as diagnostic evidence, not submission media.

## Current assembly plan, approximately 75 to 100 seconds

Record a separate real Ring walkthrough, then append the approved sample master without changing that source file. Keep the combined export local for owner review.

| Segment | Picture and English caption or narration |
| --- | --- |
| Real Ring, 30 to 45 seconds | Official Playground live-view control, then Around's actual Sync Ring activity action and returned result. “Around connects to the official Ring Playground through device discovery and event history.” Keep credentials and identifiers out of the frame. |
| Evidence, 10 to 15 seconds | Ring source label and dated live-view card, with related moment expanded. “These records are requests to open a live view. They do not confirm motion, a visitor or successful playback.” Use only the dates and result actually captured. |
| Transition, 5 seconds | “Next: sample activity with previously generated Amazon Bedrock results. The visit events were not received from Ring.” |
| Approved sample, 29.3 seconds | Append `around-demo-ring-sparkle.mp4`. Preserve its narration, music and visuals. |
| Closing note, 5 seconds | “Single-home prototype. Timing does not confirm identity. The sample typing and microphone are edited visuals; voice input is not implemented.” |

No fresh Bedrock calls are needed for this plan. The Ring segment must be captured and reviewed before assembly can be called complete. Its Bedrock configuration label is not evidence of inference during the new capture.

## Optional earlier full-flow script, approximately 2 minutes 45 seconds

This alternative requires new provider execution and fresh approval before paid calls. It is not the current capture plan and does not replace the approved sample master.

| Time | Show | Say |
| --- | --- | --- |
| 0:00–0:15 | Around Home, orange Ask card | “This is Around. Spatial intelligence for your home. Tell it what you expect, then ask what happened.” |
| 0:15–0:45 | Official Ring Playground, then Around's Ring Playground activity label and actual records | “Around reads device information and history through the official Ring APIs. These Playground records are live-view requests. They do not identify a visitor.” |
| 0:45–1:10 | An expectation and a question dated to those Ring records; expand the answer evidence | “Around uses Amazon Bedrock to understand the question and answer from saved evidence. Here, it correctly says there isn't enough evidence to confirm the plumber came.” |
| 1:10–1:20 | Switch to the separately labeled Sample activity tab | “The Playground controls we tested did not produce the classified, multi-device events for our visit scenario. This next segment uses clearly labeled sample events.” |
| 1:20–1:40 | Tell Around, original plumber sentence, saved 10 AM–1 PM card | “I'm expecting a plumber today between ten and one.” |
| 1:40–2:00 | Play sample visit; show one probable visit and likely match | “Four related moments across the driveway and front door become one probable visit that fits my expectation.” |
| 2:00–2:25 | Did the plumber come? and Anything I should know? | “The answer estimates the visit's timing and keeps its uncertainty. The briefing gives me the short version.” |
| 2:25–2:45 | Answer evidence and the two source labels | “Around connects expectations with recorded activity. It distinguishes a likely match from confirmed identity, and sample data from real Ring records.” |

If the sample segment uses local demo answers, add a visible caption: “Sample activity and local demo answers.” Explain that Bedrock was demonstrated in the real Ring segment. If it actually uses Bedrock, leave the Amazon Bedrock label visible instead. Do not splice a response from one source into a segment claiming another.

The real Ring clip must show the application functioning with the official simulator, including API ingestion. Stored records are useful for rehearsal but do not replace recording that interaction. Use their actual dates. The sample 10:41 and 11:27 times are not provider observations.

See [docs/DEMO-RUNBOOK.md](docs/DEMO-RUNBOOK.md) for the two-tab setup and recording steps. Keep credentials and account identifiers out of the recording.

### Read-aloud narration draft

Use your own voice, at a conversational pace, with brief pauses for the screen actions. This draft describes the verified Bedrock sample run. The earlier silent rehearsal uses local answers and must retain its separate label if included.

**Opening and actual Ring records**

“This is Around. Spatial intelligence for your home. Tell it what you're expecting, then ask what happened.

Around connects to the official Ring APIs. These are actual records received from the Ring Developer Playground. They show requests to open a live view. That doesn't tell us who was there.

Amazon Bedrock helps Around understand our questions and answer from saved evidence. When I ask about the plumber on the date of these records, Around says there isn't enough evidence to confirm a visit. It doesn't turn a camera interaction into an invented arrival.”

**Transition and sample visit**

“To show the full visit experience, this next part uses clearly labeled sample activity, with Amazon Bedrock handling the language.

I tell Around: The plumber is coming today between ten and one. Around saves the expected visit and its time window.

Now we play four sample moments across the driveway and front door. Around brings them together into one probable visit that fits my expectation.

Did the plumber come? It looks likely. Activity began around ten forty-one and may have ended around eleven twenty-seven. The answer keeps an important distinction: timing cannot confirm who visited.

Anything I should know? Around gives me a short briefing based on what it has saved.”

**Close**

“Around helps connect what you expected with what was recorded. A likely visit stays a likely visit. Missing evidence stays missing evidence. And sample activity stays clearly labeled.”

Record the real Ring and Bedrock segment before using its narration in a finished video. The sample rehearsal alone is not a complete submission video.

### Approved narration wording for the sample demo

The owner refined and approved this wording in conversation. It describes the saved-results sample segment only. The disclosure stays at the end. “Looks like” and “around” preserve the uncertainty of the inferred visit and estimated times.

This is Around.

It works with Ring to help you manage what’s happening at home.

Did the plumber come? Ask Around.

Yeah, it looks like the plumber came around 10:41 and left around 11:27.

Around remembers what you’re expecting and connects it to what happened. Your home’s activity becomes something you can ask about, in your own words.

This demo uses sample activity and Amazon Bedrock.

Read-aloud copy: `data/recordings/around-demo-voiceover.txt`. The owner supplied the original 26.068-second recording and a replacement question take. The Ring/manage-home opening was rerecorded in New Recording 13.m4a; the owner confirmed it begins “This is Around.” The latest export includes both new opening lines.

Current narrated sample review cut: `data/recordings/around-demo-ring-sparkle.mp4` (29.3 seconds). The original voice is included with a modest level increase; the visit-card timing follows the speech and the disclosure plays over the closing animation. Captions use the owner-confirmed text and measured pause timing. Owner approved the latest combined video, narration and soundtrack in conversation. This remains a saved-results sample demonstration, not the full Ring submission video.

## Challenges and what we learned

The Ring Playground's Vehicle and Motion controls produced live-view history rather than classified motion events. We preserved that distinction instead of turning a live view into an invented visit. This led to the separate, labeled sample scenario and a meaningful real-data insufficient-evidence answer.

Bedrock onboarding first hit account verification, then a short-term-key access denial. A dedicated IAM identity limited to Nova Micro and a one-day Bedrock key enabled the app integration. One model response misread the explicit briefing command as a visit question. Deterministic routing for the two briefing shortcuts fixed that observed problem, and the live recheck passed. Details were recorded as they occurred in FRICTION-LOG.md.

## Product feedback field

Use [PRODUCT-FEEDBACK.md](PRODUCT-FEEDBACK.md) for the observed Ring, simulator, SDK and AWS experience. It covers use, strengths, unclear behavior, onboarding, documentation, friction, improvements and whether we would use each tool again. The first failures remain in [FRICTION-LOG.md](FRICTION-LOG.md).

## Remaining submission work

| Item | Status |
| --- | --- |
| Ring and Bedrock runtime evidence | Verified within the limits above |
| Source labels and sample rehearsal | Prepared; separate modes and databases |
| Public English video under three minutes | 29.3-second narrated sample cut approved; real Ring segment, full submission assembly and upload pending |
| GitHub repository and judge access | Local repository only; visibility and publication pending |
| Public-repository license, if applicable | Owner decision pending |
| Devpost project URL and submission | Not created or submitted |
| Optional organizer clarification | Draft retained in FRICTION-LOG.md; not sent; not a submission prerequisite |

The [official rules](https://amazonappdev2026.devpost.com/rules) govern submission. Intended track: Ring. Intended mini challenge: AWS Builder. Documented AWS use is demonstrated, but awards, eligibility decisions and final acceptance remain with the organizers.

## Known limitations

Visit grouping is a heuristic and can merge separate visits close together. Timing cannot identify a person. Missing activity does not establish absence, and activity bounds do not prove continuous presence. The MVP is local and single-home, with no public authentication, automated token refresh or production deployment. The one-day demo credential needs renewal when it expires; it is not included in the repository.

## Historical media revisions

The entries below preserve the review sequence. Their uses of “current,” “latest,” or “pending” describe that earlier checkpoint. Only `around-demo-ring-sparkle.mp4` is the selected approved sample master.

Video review artifact: `data/recordings/around-demo-with-logo-compatible.mp4` supersedes the initial logo export after a reported white-playback issue. The opener and saved-results content are unchanged; the repaired encoding was verified by continuous in-app browser playback.

Current video review artifact: `data/recordings/around-demo-complete.mp4` adds the approved logo animation in reverse at the end and finishes on blank cream. Duration is 27.7167 seconds. Earlier evidence limitations remain unchanged.

Current narrated review artifact: `data/recordings/around-demo-narrated-captioned.mp4`. Owner audio and captions added; pending owner listening/timing approval.

Latest video revision: `data/recordings/around-demo-narrated-refined.mp4`. Closing sample/Bedrock disclosure remains in the audio, delayed until after the closing logo appears, at 1.2x speed and 6 dB below its previous level. Its caption is omitted at the owner’s request. Main narration captions remain.

Latest visual revision: `data/recordings/around-demo-narrated-typed.mp4` (27.8 seconds). The question field is composited to type `did the plumber come` at 5.22–5.94 seconds, aligned to the owner's spoken question. A decorative microphone appears to the left of the arrow. This is an edited visual, not a new live query or implemented voice input. Existing response, source labels, captions and closing audio treatment are preserved.

Current voice revision: `data/recordings/around-demo-narrated-retake.mp4`. Uses the owner's New Recording 10.m4a for “Did the plumber come? Ask Around.” Wording remains approved. The new take plays at natural speed, with a matched level and adjusted typing/caption timing. Remaining narration and closing disclaimer treatment are preserved.

Latest audio cleanup: `data/recordings/around-demo-narrated-final.mp4`. Removed the breath in the pause after “and connects it to what happened,” preserving narration, captions, timing and closing treatment.

Optional soundtrack review: `data/recordings/around-demo-with-soundtrack.mp4`, an original locally synthesized instrumental bed beneath the approved narration. Awaiting owner listening approval; `around-demo-narrated-final.mp4` remains the approved no-music cut. No submission wording or product claims changed.

Music status: the first subdued bed was rejected. Three peppier standalone directions are available under `data/recordings/soundtrack-options/`; awaiting owner selection before any new video mix. Approved no-music cut remains unchanged.

Music direction update: owner prefers sample 2, Curious & Clever. Three brighter variations (2A Sunny, 2B Extra Bounce, 2C Sparkle) are ready under `data/recordings/soundtrack-variations/`. No new mix has been made; selection pending.

Owner selected soundtrack 2C Sparkle. The opening logo card now says “Works with Ring.” New approved narration sentence: “It works with Ring to help you manage what’s happening at home.” Awaiting that recording before the final music mix and narration/caption retiming.

Latest assembled sample review: `data/recordings/around-demo-ring-sparkle.mp4`. Includes the confirmed new opening (“This is Around” and the Ring/manage-home sentence), “Works with Ring” on the opening card, selected 2C Sparkle music, updated captions and typing, and preserved breath cleanup and quiet closing disclosure. The longer opening adds 1.5 seconds; overall duration is 29.3 seconds. Owner approved the combined mix in conversation: “I'm happy with this version.”

### Approved sample demo

The owner approved `data/recordings/around-demo-ring-sparkle.mp4` with “I'm happy with this version.” This is the selected 29.3-second sample demo, including the revised Ring opening, logo label, captions, typing, cleaned voiceover and Sparkle soundtrack. Approval applies to this media version. No upload or hackathon submission has been performed or authorized by this approval.
