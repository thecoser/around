# Around submission readiness

Checked September 29, 2026, America/New_York. Local preparation is in progress. Nothing has been published, uploaded or submitted.

Lead owns repository and media edits. The read-only Progress Steward reviews phase transitions. Current outcome: a reviewable source package and a real Ring capture, preserving the approved sample master. Next observable capture result: official Playground interaction followed by successful Around sync and dated Ring cards. Budget: one capture pass after private token entry, stop on the first access failure; up to 15 minutes for capture and review. No additional paid provider calls without fresh owner approval.

## Verified now

| Check | Evidence |
| --- | --- |
| TypeScript, lint, unit/contract tests | `npm run check` passes; 28 tests |
| Production build | `npm run build` passes |
| Browser scenarios | `npm run test:e2e` passes; 3 scenarios |
| Ring data preserved | Read-only SQLite check: one device, two `source=ring` / `live_view` records, two live-view activities, zero matches |
| Ring event dates | September 28, 2026 at 2:54:58 PM and 2:56:29 PM Eastern |
| Approved sample master | 9,589,336 bytes; SHA-256 below; no edits |
| Source exclusions | `.env.local`, `data/`, recordings, databases, build and test output ignored |
| Credential-pattern scan | Initial 51 non-ignored source candidates: no AWS access-key, Bedrock bearer-key, JWT-shaped value or private-key matches; this is a bounded check, not a security audit |
| Git | Local `main`, no initial commit or remote at first inspection |

Approved file: `data/recordings/around-demo-ring-sparkle.mp4`

```text
8e3fb58fadeeb1fd8d694886a235a96732f8592721f32a65c4c1a9cec5141e4f
```

The first browser-suite attempt could not bind port 3100 in the sandbox (`listen EPERM`). The unchanged suite passed with local-server permission. No app repair or weakened assertion was needed.

## Evidence boundaries

| Segment | What it establishes | What it does not establish |
| --- | --- | --- |
| Actual Ring records | Official discovery/history previously succeeded and records remain stored | Classified detections, visitor identity, successful video playback, or a new sync today |
| Historical Bedrock checks | Actual parsing, question interpretation and constrained answer composition were exercised | Broad reliability or a currently usable credential |
| Approved 29.3-second sample video | Owner-approved presentation of saved sample activity with previously generated Bedrock results | Recorded request submission, voice input, or real Ring ingestion |
| Contract/browser tests | Local behavior under fixtures and mocked responses | Live provider availability |

## Capture queue

The signed-in Ring Playground was reachable during preparation. Its fresh capture tab had no token. Around was started at http://127.0.0.1:3000 with the existing Ring database. Owner-only temporary token generation and direct entry are pending. Do not inspect or record the retrieval field. No fresh sync or new provider footage has occurred in this preparation pass.

Capture blocker: inspecting the already-running QuickTime recorder returned “The Mac is locked” after about 19 minutes 50 seconds inside the tool call. No recording was verified as started. Stop UI attempts until the owner unlocks the Mac; elapsed wait is not capture evidence. The recorder inspection did not invoke Ring or Bedrock. Owner unlock and private token entry were requested. On resume, inspect the current page and recording frame once before using a token; do not assume an earlier token is still valid.

Capture the simulator control and actual sync first. Keep the Ring source label and actual event dates visible. Show the returned result and expanded live-view record. A live-view request remains a request even if the simulator player fails. Keep credential setup off camera. Stop before any Tell/Ask action in Bedrock mode unless additional calls have been approved.

Then assemble a separate review file with a visible transition to the approved sample segment. Preserve the master and sidecars. Review framing, readable labels, credentials, duration, audio and continuous playback before marking the combined video ready. A shot list or an existing-record walkthrough cannot close the fresh-ingestion capture item.

## Delivery decisions and pending actions

The [official rules](https://amazonappdev2026.devpost.com/rules), checked September 29, require GitHub source with run instructions, runtime Ring use, a simulator/device demonstration, and a public YouTube or Vimeo video. Keep the video below three minutes. Include product feedback and identify Ring plus AWS Builder. Deadline shown: October 23, 2026 at noon Pacific, 3 PM Eastern.

The [FAQ](https://amazonappdev2026.devpost.com/details/faqs) permits the Ring Playground. It permits either a public repository with an open-source license or a private repository shared with the reviewers. For private access, it names `testing@devpost.com`, `chris-trag`, `knmeiss`, `giolaq`, `anishamalde`, `mosesroth`, and `emersonsklar`; invitations need acceptance and expire after seven days. Recheck access near submission. No invitation has been sent.

Pending: owner visibility/license choice, GitHub destination, real Ring recording, combined video review, upload destination, Devpost entry and final submission approval. The judge guide provides free local sample evaluation; live-provider judging access remains to be arranged without distributing owner credentials. Do not describe this as completed judge access.

Prepared materials: [submission copy](../SUBMISSION-COPY.md), [judge guide](JUDGE-GUIDE.md), [runbook](DEMO-RUNBOOK.md), [product feedback](../PRODUCT-FEEDBACK.md), and [friction log](../FRICTION-LOG.md). Licensing, collaborator invitations, publishing, uploading and submitting remain separate owner actions or approval gates.
