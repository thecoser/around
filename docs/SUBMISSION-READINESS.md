# Around submission readiness

Checked September 30, 2026, America/New_York. The owner approved the final v13 video after the last wording correction. Submission materials are prepared locally. Nothing has been published, uploaded or submitted.

Approved submission video: `data/recordings/around-submission-review-v13.mp4`, 118.3 seconds, with the labeled sample demo first, then the Ring walkthrough and integration proof. Official Playground playback and fresh Ring ingestion are verified. The edit uses separate takes and labeled stills. An unobscured sync-click sequence is not included; do not claim continuous capture. The owner-approved sample master and v6 remain unchanged.

The capture and edit phase is complete within the evidence limits below. Lead owns local delivery preparation. Next observable result: confirmed GitHub visibility/account and video platform/account, followed by exact publishing details for owner approval. No more capture or provider calls are planned. Uploading, publishing, collaborator invitations and final submission still require explicit approval.

## Verified now

| Check | Evidence |
| --- | --- |
| TypeScript, lint, unit/contract tests | `npm run check` passes; 31 tests after Ring diagnostic repair |
| Production build | `npm run build` passes |
| Browser scenarios | `npm run test:e2e` passes; 3 scenarios |
| Ring data preserved | Read-only SQLite check after the September 30 fresh sync: one device, three `source=ring` / `live_view` records, three live-view activities, zero matches |
| Ring event dates | September 28, 2026 at 2:54:58 PM and 2:56:29 PM Eastern; September 30 at 10:54:33 AM Eastern |
| Approved sample master | 9,589,336 bytes; SHA-256 below; no edits |
| Source exclusions | `.env.local`, `data/`, recordings, databases, build and test output ignored |
| Credential-pattern scan | Initial 51 non-ignored source candidates: no AWS access-key, Bedrock bearer-key, JWT-shaped value or private-key matches; this is a bounded check, not a security audit |
| Git | Historical local source baseline `e7452a6`, 53 files; no remote or publication. Initial inspection found no commits. |

Approved file: `data/recordings/around-demo-ring-sparkle.mp4`

```text
8e3fb58fadeeb1fd8d694886a235a96732f8592721f32a65c4c1a9cec5141e4f
```

The first browser-suite attempt could not bind port 3100 in the sandbox (`listen EPERM`). The unchanged suite passed with local-server permission. No app repair or weakened assertion was needed.

## Evidence boundaries

| Segment | What it establishes | What it does not establish |
| --- | --- | --- |
| Actual Ring records | Official discovery/history succeeded, including one fresh live-view record ingested September 30 | Classified detections, visitor identity, or successful video playback |
| Historical Bedrock checks | Actual parsing, question interpretation and constrained answer composition were exercised | Broad reliability or a currently usable credential |
| Approved 29.3-second sample video | Owner-approved presentation of saved sample activity with previously generated Bedrock results | Recorded request submission, voice input, or real Ring ingestion |
| Contract/browser tests | Local behavior under fixtures and mocked responses | Live provider availability |

## Capture queue

The signed-in Ring Playground was reachable during preparation. Around was started at http://127.0.0.1:3000 with the existing Ring database. The owner entered a temporary Ring token in the Codex in-app browser. Presence-only inspection confirmed it without reading or moving the value; Bedrock was empty. Earlier checks of Chrome missed the correct browser and incorrectly reported the token as absent. That was a capture-coordination error.

Earlier capture blocker: inspecting the already-running QuickTime recorder returned “The Mac is locked” after about 19 minutes 50 seconds inside the tool call. Owner subsequently unlocked the Mac. QuickTime became accessible, but the automated recording command did not expose usable controls. Owner then started a selected-area recording of the Codex app panel.

Earlier failure: one submitted Ring sync returned “The request could not be completed. Check local configuration and try again.” The first pointer action produced no visible status and left the token field populated; valid input and no browser error were observed. One keyboard activation then cleared the token and produced the failure. The app maps that generic message to HTTP 500 for an unclassified exception. Its exact cause and whether the provider received an HTTP request are unknown. No provider retry occurred. Read-only database inspection still shows the original two events, one device and zero matches. A host DNS-only lookup resolved `api.amazonvision.com`; it did not test TLS, authorization, provider availability or the failing request. The app console provided no additional diagnostic category. No paid calls were made.

The owner stopped recording and confirmed the Desktop location. Original preserved; identical copy saved as `data/recordings/around-ring-sync-failed-2026-09-29.mov`. SHA-256: `efbac205808e0a8d45d3548033f03803b6c32699817dd22ab4f0f3f680376693`. Duration 194.788 seconds, 602 by 734 pixels, one audio track. Eight decoded frames were inspected: correct app panel and source label, populated masked token field, cleared field, then the generic error. No unmasked token appeared in those inspected frames. Audio was not reviewed. This is failure evidence, not submission-ready footage; masked credential controls and long pauses should not be published. Media inspection details are under `data/recordings/ring-failed-review/`.

The approved sample master's hash remains unchanged. A failed attempt does not complete the real Ring walkthrough.

September 30 diagnostic preparation: owner requested diagnosis and completion. Lead implemented fixed Ring error stages and allowlisted categories for discovery, history, response validation and local storage. Raw error messages, payloads, URLs and credentials are neither returned nor logged. Invalid HTTP-header characters are rejected before fetch. Existing provider HTTP statuses and deliberate application errors remain visible. No retry, fixture fallback, matching change or product feature was added.

Validation passed: TypeScript, lint, 31 tests, production build, and three browser scenarios. New tests cover secret redaction, fetch and response-body failures, no retry after rejection, no partial history ingestion, and SQLite rollback after an event insert. A synthetic invalid-header request to the restarted production route returned the intended local HTTP 400 without contacting Ring. A separate credential-free TLS handshake to the Ring API host succeeded in 81 ms. It does not establish the app's authorization or explain the original exception.

The diagnostic build is running on the same localhost:3000 address. After owner private entry of a fresh temporary Ring token in the actual Codex app page, one diagnostic sync succeeded: “Already up to date. No duplicate moments were added.” This verifies current official discovery/history execution and deduplication, not new-event ingestion. Read-only SQLite inspection still shows one device, two original September 28 live views and zero matches. Receipt: `data/recordings/ring-evidence/diagnostic-success-1790772570109.json`. No Bedrock call was made.

The prior failure's cause remains unresolved because both the token and server state changed. Diagnostic code is locally committed as `1fea8ec`. The read-only Steward reviewed it and the live result. Owner was asked to re-enter the same still-valid token privately, then start one new app-only recording. The diagnostic sync was not recorded. A subsequent single recorded sync also succeeded, with the same up-to-date result and unchanged record counts. Receipt: `data/recordings/ring-evidence/recorded-sync-1790773261755.json`. Neither sync proves fresh-event ingestion.

September 30 recorded-take review: preserved the Desktop original and copied it identically to `data/recordings/around-ring-sync-2026-09-30.mov`. SHA-256 `4407cdfd235cccccbda5dab0bab8f8c2dae96d140fb7492a0f0e068ffced2f4f`. Duration 311.138 seconds, 510 by 740 pixels, one audio track. Eight broad frames and six early frames were visually inspected. A native Save password popup appears after submission and obscures the result in the inspected post-submit views. Browser screenshots had omitted the native popup. This take is not approved sync-result footage. No plaintext token was seen in the inspected frames; this is not full-file privacy clearance. Audio is unreviewed. Review evidence is in `ring-sync-review/` and `ring-sync-early-review/` under the recordings directory.

Steward checkpoint recommended one bounded salvage pass, then saved-result capture without provider requests. Lead accepted. Native control of the Codex app is blocked by the computer-use tool, so owner was asked to dismiss the popup with No Thanks and start a short microphone-off capture. Next observable result: a readable existing success status and dated live-view detail. Lead owns the walkthrough and media edit; owner owns recorder start/stop. Budget: one continuation take, no provider calls, then media review. This continuation will be explicitly disclosed. Official Playground interaction and an unobscured actual sync sequence remain pending; do not close those gates with saved results.

Capture the simulator control and actual sync first. Keep the Ring source label and actual event dates visible. Show the returned result and expanded live-view record. A live-view request remains a request even if the simulator player fails. Keep credential setup off camera. Stop before any Tell/Ask action in Bedrock mode unless additional calls have been approved.

Then assemble a separate review file with a visible transition to the approved sample segment. Preserve the master and sidecars. Review framing, readable labels, credentials, duration, audio and continuous playback before marking the combined video ready. A shot list or an existing-record walkthrough cannot close the fresh-ingestion capture item.


September 30 continuation reviewed: owner dismissed the native password popup and recorded existing results without a new provider call. Original Desktop MOV and identical copy `data/recordings/around-ring-saved-result-2026-09-30.mov` are preserved, SHA-256 `b93d0293265842fa745a1f949351c76b4302ffe8e812db7dc011518f22b2549f`. It is 243.443 seconds, 510 by 740, with one unreviewed audio track. Ten sampled frames showed clear status, source labels and dated cards. Exported a separate silent 19-second review excerpt, `data/recordings/around-ring-saved-results-review.mp4`, from source intervals 40–48, 30–37 and 48–52 seconds. Its visible caption says edited saved results, recorded September 30, and identifies the September 28 live views. The reordered excerpt is not a continuous sync recording. Browser playback reached the end with no video error; decoded frames cover both cuts. The raw take is not cleared for publication.

Earlier combined assembly blocker, resolved below. Two exports failed with AVFoundation -11841 / underlying -17390. Validation exposed a one-tick timeline gap from floating-point subtraction; exact CMTime subtraction repaired that defect and validation passed. The third export completed but its sample segment was white in decoded frames. That file is failed review evidence, not a deliverable. Stopped combined-render retries at the Steward checkpoint. The valid Ring section was exported separately with zero audio tracks. The approved sample remains byte-for-byte unchanged. Local review presents the two files separately; this does not satisfy completed assembly or replace official Playground and unobscured sync footage. No paid calls or external publication occurred.


September 30 assembly recovery: owner approved a separate media repair. `scripts/media/assemble-submission-review.swift` decodes the valid rendered opening and closing separately from the original approved sample, then writes all frames through one H.264 encoder. It retains the original compressed sample audio with a 24-second empty edit before playback, without gain or speed changes. The first recovered cut exposed a one-frame closing flash; the final cut omits that frame. No source was overwritten.

Earlier repaired review: `data/recordings/around-submission-review-v5.mp4`, 59.2 seconds, 970 by 920, one video configuration. The complete 29.3-second sample occupies seconds 24–53.3, with all 1,758 frames retained. Compressed audio payload hashes match across 56 blocks; the MP4 edit list verifies the 24-second offset and 29.3-second duration. Decoded frames confirm the sample is visible and the closing flash is removed. Continuous browser playback reached ended=true at 59.2 seconds, error=null, unmuted. This is technical playback verification, not a new audible quality review. The approved master hash is unchanged.

The render blocker is resolved. This remains an edited saved-results review, not a complete official Playground-to-sync capture. That footage and owner review remain open. No provider calls, feature additions, uploads or publication occurred. The original failures and prior files remain preserved.

## Delivery decisions and pending actions

The [official rules](https://amazonappdev2026.devpost.com/rules), checked September 29, require GitHub source with run instructions, runtime Ring use, a simulator/device demonstration, and a public YouTube or Vimeo video. Keep the video below three minutes. Include product feedback and identify Ring plus AWS Builder. Deadline shown: October 23, 2026 at noon Pacific, 3 PM Eastern.

The [FAQ](https://amazonappdev2026.devpost.com/details/faqs) permits the Ring Playground. It permits either a public repository with an open-source license or a private repository shared with the reviewers. For private access, it names `testing@devpost.com`, `chris-trag`, `knmeiss`, `giolaq`, `anishamalde`, `mosesroth`, and `emersonsklar`; invitations need acceptance and expire after seven days. Recheck access near submission. No invitation has been sent.

Selected destinations: public GitHub under `thecoser` and YouTube under the owner-selected account. Proposed repository: `thecoser/around`. MIT license with Praxais LLC copyright is prepared. The selected YouTube account has no channel; Praxais Studios / @PraxaisStudios is prepared for approval. Pending: channel creation, repository publication, video upload/publication, Devpost entry and final submission approval. v13 includes official Playground playback and a fresh-sync result. It does not include an unobscured sync click. The judge guide provides free local sample evaluation; live-provider judging access remains to be arranged without distributing owner credentials. Do not describe this as completed judge access.

Prepared materials: [submission copy](../SUBMISSION-COPY.md), [judge guide](JUDGE-GUIDE.md), [runbook](DEMO-RUNBOOK.md), [product feedback](../PRODUCT-FEEDBACK.md), and [friction log](../FRICTION-LOG.md). License text is prepared. Publishing, uploading, channel creation and final submission remain separate approval gates. No collaborator invitations are planned for the selected public repository.

Historical local source baseline: `data/submission/around-source-e7452a6.zip`, with per-file hashes in `around-source-e7452a6-manifest.json`. All 53 archived files matched the committed blobs and passed ZIP CRC checks. The exact archived bytes passed the same bounded credential-pattern scan with no matches. The archive preserves the earlier preparation checkpoint; subsequent capture notes do not change its contents. It contains no credentials, databases or recordings.


Later source archives use the exact local commit in their filename. Each adjacent manifest records that commit, archive SHA-256, file hashes, ZIP CRC, equality to committed blobs and a bounded credential-pattern check. `data/submission/latest.json` identifies the latest prepared checkpoint. These are local review packages, not published judge access. The original archive remains preserved.


September 30 editorial correction: owner reported the combined cut felt like the demo played twice. v6 removes the repeated Ring Home walkthrough. Current review is `data/recordings/around-submission-review-v6.mp4`, 46.1 seconds: six-second dated Ring evidence card, 4.9-second sample transition, unchanged full sample once at 10.9–40.2, and 5.9-second closing disclosure. Decoded cut points are correct, and the 56 compressed audio payload blocks still match the approved source. Continuous browser playback reached ended=true at 46.1 seconds with error=null. Earlier versions remain preserved. Official Playground and unobscured sync footage remain pending.


Owner approved the 46.1-second v6 local edit on September 30: “ok looks good.” Preserve `around-submission-review-v6.mp4` and the original approved sample master. This closes review of the current edit only. The actual Playground-to-Around capture, repository visibility/access decisions, publishing, upload and final submission remain separate pending work. No new paid-call authority is implied.


### September 30 fresh ingestion verified, recording review pending

One authorized Around sync following the official Playground Motion control returned “1 moments received and grouped.” Native Chrome showed the new September 30, 10:54 AM live-view card and expanded explanation. Read-only SQLite confirmed one device, three Ring live-view events, three activities and zero matches. The new event timestamp is `2026-09-30T14:54:33.078Z`. Receipt: `data/recordings/ring-evidence/fresh-sync-20260930.json`. This closes the fresh-ingestion runtime check. The returned event is a live-view request, despite the Playground control being labeled Motion; no classified detection or visitor is established.

Owner was asked to stop and save the Around take. Saved-file framing, privacy and playback review are pending, so the complete video gate remains open. No Bedrock call was made. Preserve the approved sample and v6 review unchanged. Next observable result: reviewed clean excerpts from the separate Playground and Around recordings, within one bounded local review pass. Lead owns media and documentation; Steward reviews the phase transition. No further Ring request is planned.


Latest Around recording located on Desktop after owner reported it stopped unexpectedly: `Screen Recording 2026-09-30 at 11.04.18 AM.mov` (filename uses a narrow space before AM). Preserved identical private copy `data/recordings/private/around-fresh-sync-2026-09-30.mov`, SHA-256 `147dd453a70c3dc002b867f7282fe7d19a1b5a5fed3bcc28908801916ec3981a`. It decodes, duration 332.59 seconds, 2440 by 1568, one unreviewed audio track. Twelve sampled frames include initial masked credential controls and a native password prompt, then an unobscured “1 moments received and grouped” result with Ring source labeling. Tail remains on the success view; the new dated card was not found in these samples. Stop cause is unknown. The take is preserved, with usable result imagery identified, but it is not fully privacy-cleared or a completed edited walkthrough. No additional provider request or recording was started.


### New v7 edit prepared for owner review

`around-submission-review-v7.mp4` is 59.3 seconds, 970 by 920, one H.264 configuration. SHA-256: `9a750851cb0e6ecf8931dd662cf2c7d3b8449176ef8e97705abed639d12a5da6`. It includes a recorded-control still, six seconds of actual simulator playback, five seconds of the recorded successful fresh-sync result, a labeled saved-record still, a sample disclosure, the entire approved sample once and a closing note. Source intervals and crop geometry are in `scripts/media/assemble-fresh-ring-review.swift`; the adjacent local JSON records edit provenance.

Twenty-five decoded frames cover all cuts and each retained second of Ring footage. They show no API trace, device identifiers, credential controls or native password prompt. This is review of retained intervals, not clearance of raw takes. The sample retains all 1,758 frames and the 56 original compressed audio blocks. Audio payload SHA-256 matches `4035a0861de909736919a3f02d61e861402fccb09966496839269672ecb673a8`; the MP4 edit list confirms a 25-second offset and 29.3-second audio duration. Raw take audio is omitted. Both approved source hashes remain unchanged.

The Progress Steward confirmed the claims distinguish simulator playback, live-view ingestion and sample visits. Fresh-ingestion runtime verification is complete. An unobscured click-to-result capture remains absent and is not implied by the edited result. No application code changed and no provider requests were made during editing; the previously passed 31 tests, three browser scenarios and build remain the applicable code verification. Owner approval of v7 is pending.

Continuous browser playback of v7 reached `ended=true`, `currentTime=59.3`, `error=null`, unmuted. The earlier playback check paused at 18.857 seconds after another browser tab was inspected; a fresh uninterrupted check then completed. This is technical playback verification, not a new audible quality review.


### September 30 audience and section-card revision

Owner clarified that hackathon judges need to know why each section is included, then approved simpler wording for the sample transition. v8 adds an opening orientation and three numbered purpose cards: Ring integration through the official Playground, integration proof in Around, and the sample visit experience. It retains the same Ring intervals and disclosed stills, with the full approved sample once. The previous cut remains preserved.

File: `data/recordings/around-submission-review-v8.mp4`, 83.3 seconds, SHA-256 `ce1705f7ca91e507cf40ae0e0cd20110e9bb51a60977079c1062a43f593e5f17`. Sample placement: 49–78.3 seconds. The renderer preserves all 1,758 sample frames and the original 56 compressed audio blocks; the MP4 edit list confirms a 49-second offset and 29.3-second duration. Approved sample, v6 and v7 file hashes are unchanged. Card readability and cut frames were inspected. The read-only Steward found the three purposes and evidence boundaries clear. Owner approval covers wording; approval of the rendered v8 remains pending. No new provider call, feature, upload or publication occurred.

The uninterrupted v8 browser check reached `ended=true`, `currentTime=83.3`, `error=null`, unmuted. This is technical playback verification, not a new audible quality review.

### September 30 presentation cleanup, v9

Owner requested the established logo and “Spatial Intelligence for your home” tagline on the opening card, “expected activities” wording, a rounded 83-second duration label and removal of redundant editing notes. v9 makes these changes, uses native player controls, and keeps source labels, the sample explanation and a concise footage credit. The three stored Ring records remain documented internally; the video now identifies the single new record it shows. No new provider calls or application features.

File: `data/recordings/around-submission-review-v9.mp4`, 83.3 seconds, SHA-256 `cd3051db879e727ab08851a57b3174b45f3f3c145f6c25872e3baeccce969a91`. All 1,758 sample frames remain at seconds 49–78.3. The original 56 compressed audio blocks match, and the MP4 edit list confirms their position and duration. Sample master and v6, v7, v8 hashes are unchanged. Revised cards and cuts were visually inspected. The read-only Steward found no material evidence or scope issue in the captions. Lead verified that the review page contains no custom play button or repeated footer. Owner review of v9 is pending.

Continuous v9 browser playback, started through the native player, reached `ended=true`, `currentTime=83.3`, `error=null`, unmuted. The page was then reset to its opening logo poster for owner review. This verifies technical playback, not a new audible quality review.

### September 30 reading-time adjustment, v10

Owner found the Motion control card and section 2 too fast to read. v10 increases the Motion still from 3 to 8 seconds, section 2 introduction from 6 to 10, sync result from 5 to 10, and detailed saved-record still from 6 to 14. The sync result uses its existing five-second source interval followed by a five-second final-frame hold. No additional raw footage or changed evidence claims.

New duration: 105.3 seconds, displayed as “105 seconds.” File: `data/recordings/around-submission-review-v10.mp4`, SHA-256 `f8cddef04ca34712a684987810bc930b755187fb1e537c8fa893af0d24e1f1f3`. The complete 1,758-frame approved sample is now at 71–100.3 seconds, at natural speed. Its 56 compressed audio blocks match the master, and the audio edit list confirms the new placement. Approved master and previous v9 hashes remain unchanged. Lead checked the changed timing, decoded transition frames and unchanged captions. This limited pacing revision used a lead self-check. Owner review remains pending.

Continuous v10 browser playback reached `ended=true`, `currentTime=105.3`, `error=null`, unmuted. The review page shows “105 seconds.” and has been reset to the opening poster.

### September 30 demo-first sequence, v11

Owner requested the product demo immediately after the opening page, followed by the Ring integration pages. v11 renumbers the sections as product demo, Ring integration and integration proof. The opening description follows that order. The sample explanation remains before the complete approved sample. The former section 1 introduction gains three seconds, and its control and playback pages gain two seconds each. Playback uses the same six seconds of footage plus a two-second final-frame hold.

Duration: 112.3 seconds, displayed as “112 seconds.” File: `data/recordings/around-submission-review-v11.mp4`, SHA-256 `c06b97e6530da1bcd0e86ddea47d2e5e87377411e2a93eb2f3c7d3d5f9d97252`. The original 1,758 sample frames now occupy 18–47.3 seconds at natural speed. All 56 compressed sample audio blocks match; the edit list confirms the new offset and 29.3-second duration. The approved master and previous v10 hashes are unchanged. Lead checked the new order, section numbers, holds and sample/Ring distinctions. This bounded editorial revision used a lead self-check. Rendered v11 owner review is pending.

Continuous v11 browser playback reached `ended=true`, `currentTime=112.3`, `error=null`, unmuted. The page displays “112 seconds.” and is reset to the opening poster.

### September 30 closing-brand and pacing revision, v12

Owner requested two more seconds on every section 3 page. They now last 12, 12 and 16 seconds. The sync result uses its existing five-second source interval and a seven-second final-frame hold. The product-demo title no longer includes “Was the expected visit likely?” The closing reuses the established logo animation: the wordmark and radio symbol spin, settle, then hold above “Spatial Intelligence for your home” and a spaced “Single Home Prototype.” The unclear timing/identity sentence was removed from that card. Edited-visuals and unimplemented-voice-input statements remain. Internal evidence limitations and sample labels are unchanged.

Duration: 118.3 seconds, displayed as “118 seconds.” File: `data/recordings/around-submission-review-v12.mp4`, SHA-256 `9054fe897c332037aebaa377f207fe12375d4a3c72877808ebdfc272137d4068`. Original 1,758 sample frames and 56 compressed audio blocks remain at 18–47.3 seconds. The audio edit list confirms the placement. Approved master and previous v11 hashes are unchanged. Lead visually checked the shorter title, section 3 boundaries, moving logo frames and settled closing layout. This bounded presentation revision used a lead self-check. Owner review remains pending.

Continuous v12 browser playback reached `ended=true`, `currentTime=118.3`, `error=null`, unmuted. Closing-frame screenshot saved. The page displays “118 seconds.” and is reset to the opening poster.

### September 30 final wording correction, v13

Owner said everything looked good, with one change: “Next, see how” implied a missed step after the opening “First, we demonstrate.” v13 changes the product-demo card to “See how Around answers ‘Did the plumber come?’” No other wording, timing, source, audio or design change. The owner’s approval covers v12 with this requested correction.

File: `data/recordings/around-submission-review-v13.mp4`, SHA-256 `7f08ff9eee987b02c7ec31a0c4d11998bfe2be6f6e65d2eae6863e8bed12ec0a`. Duration remains 118.3 seconds and the page still displays 118 seconds. Lead visually verified the corrected card and unchanged transition at 18 seconds. The 1,758 sample frames and 56 original compressed audio blocks are preserved. Approved master and v12 hashes are unchanged. Full continuous playback was verified on v12 and was not repeated for this single-line correction. Publication, upload and submission remain pending separate approval.

### September 30 final video approval

Owner approved final v13 in conversation: “good. ready.” SHA-256 was rechecked as `7f08ff9eee987b02c7ec31a0c4d11998bfe2be6f6e65d2eae6863e8bed12ec0a`. Preserve this 118.3-second submission video and the original approved sample master. This approval closes media review; it does not authorize publication, uploads, collaborator invitations, submission or paid provider calls. Next decisions are repository account/visibility and video platform/account.

### September 30 publishing preparation

Current official rules rechecked: a public repository must include an open-source license, and the video must be publicly visible on YouTube or Vimeo. Owner selected GitHub `thecoser`, public if consistent with rules, YouTube, and Praxais LLC as MIT copyright holder. `thecoser/around` was not found by the authenticated read-only GitHub check. The selected YouTube account is signed in but has no channel. The proposed Praxais Studios name and @PraxaisStudios handle are entered in a creation form, with no creation or terms acceptance performed.

License, dependency/icon notices, and the judge guide's September 30 evidence are prepared. Read-only Steward found no unsupported completion and confirmed that live-provider judging remains distinct from public source access. The pre-change history scan covered 17 commits, 136 blobs and 57 paths, with no excluded-path or bounded credential-pattern matches. The final publication package and history will be checked after the preparation commit. Exact approval details and upload text are local under `data/submission/`; no public write or upload has occurred.
