# Around submission readiness

Checked September 30, 2026, America/New_York. Local preparation is in progress. Nothing has been published, uploaded or submitted.

Lead owns repository and media edits. The read-only Progress Steward reviews phase transitions. Current outcome: a reviewable source package and a real Ring capture, preserving the approved sample master. Next observable capture result: official Playground interaction followed by successful Around sync and dated Ring cards. Budget: one capture pass after private token entry, stop on the first access failure; up to 15 minutes for capture and review. No additional paid provider calls without fresh owner approval.

## Verified now

| Check | Evidence |
| --- | --- |
| TypeScript, lint, unit/contract tests | `npm run check` passes; 31 tests after Ring diagnostic repair |
| Production build | `npm run build` passes |
| Browser scenarios | `npm run test:e2e` passes; 3 scenarios |
| Ring data preserved | Read-only SQLite check: one device, two `source=ring` / `live_view` records, two live-view activities, zero matches |
| Ring event dates | September 28, 2026 at 2:54:58 PM and 2:56:29 PM Eastern |
| Approved sample master | 9,589,336 bytes; SHA-256 below; no edits |
| Source exclusions | `.env.local`, `data/`, recordings, databases, build and test output ignored |
| Credential-pattern scan | Initial 51 non-ignored source candidates: no AWS access-key, Bedrock bearer-key, JWT-shaped value or private-key matches; this is a bounded check, not a security audit |
| Git | Local source baseline `e7452a6`, 53 files; no remote or publication. Initial inspection found no commits. |

Approved file: `data/recordings/around-demo-ring-sparkle.mp4`

```text
8e3fb58fadeeb1fd8d694886a235a96732f8592721f32a65c4c1a9cec5141e4f
```

The first browser-suite attempt could not bind port 3100 in the sandbox (`listen EPERM`). The unchanged suite passed with local-server permission. No app repair or weakened assertion was needed.

## Evidence boundaries

| Segment | What it establishes | What it does not establish |
| --- | --- | --- |
| Actual Ring records | Official discovery/history previously succeeded and records remain stored | Classified detections, visitor identity, successful video playback, or new-event ingestion on September 30 |
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

## Delivery decisions and pending actions

The [official rules](https://amazonappdev2026.devpost.com/rules), checked September 29, require GitHub source with run instructions, runtime Ring use, a simulator/device demonstration, and a public YouTube or Vimeo video. Keep the video below three minutes. Include product feedback and identify Ring plus AWS Builder. Deadline shown: October 23, 2026 at noon Pacific, 3 PM Eastern.

The [FAQ](https://amazonappdev2026.devpost.com/details/faqs) permits the Ring Playground. It permits either a public repository with an open-source license or a private repository shared with the reviewers. For private access, it names `testing@devpost.com`, `chris-trag`, `knmeiss`, `giolaq`, `anishamalde`, `mosesroth`, and `emersonsklar`; invitations need acceptance and expire after seven days. Recheck access near submission. No invitation has been sent.

Pending: owner visibility/license choice, GitHub destination, real Ring recording, combined video review, upload destination, Devpost entry and final submission approval. The judge guide provides free local sample evaluation; live-provider judging access remains to be arranged without distributing owner credentials. Do not describe this as completed judge access.

Prepared materials: [submission copy](../SUBMISSION-COPY.md), [judge guide](JUDGE-GUIDE.md), [runbook](DEMO-RUNBOOK.md), [product feedback](../PRODUCT-FEEDBACK.md), and [friction log](../FRICTION-LOG.md). Licensing, collaborator invitations, publishing, uploading and submitting remain separate owner actions or approval gates.

Local source baseline: `data/submission/around-source-e7452a6.zip`, with per-file hashes in `around-source-e7452a6-manifest.json`. All 53 archived files matched the committed blobs and passed ZIP CRC checks. The exact archived bytes passed the same bounded credential-pattern scan with no matches. The archive preserves the earlier preparation checkpoint; subsequent capture notes do not change its contents. It contains no credentials, databases or recordings.
