# Friction log

Observed issues from September 28–30, 2026, consolidated for judges. No new provider experience was manufactured for this document. The [complete original chronology](docs/history/FRICTION-LOG-original-2026-09-30.md) preserves exact failures, follow-ups, call counts and prior decisions. Related observations are grouped below; successful checkpoints are outcomes, not extra defects.

Severity describes impact on this project. Where the original narrative had no rating, the rating below is an editorial assessment of the recorded impact. Suggestions are proposed improvements, not claims that the provider promised them. Application bugs, local restrictions and recording failures are explicitly separated from Amazon behavior.

Recommended Devpost examples: F2, F3, F4, F7, F8 and F9. The remaining entries explain the full development experience and preserve known failures.

## F1. Ring simulator discovery

Observed: September 28.

**Task and steps:** Find a hardware-free event source. Reviewed hackathon resources, public Ring guides and the official sample.

**Expected:** A linked simulator with typed events and multiple test devices. **Actual:** The entry point was not obvious in inspected public docs; sign-in later exposed the official Playground.

**Severity:** Important. **Workaround:** Used the authenticated Playground and a separately labeled sample for unsupported scenarios.

**Actionable suggestion:** Link a simulator-first quickstart from Ring and hackathon resources. **Current outcome:** Entry point found; typed multi-device scenario remains unverified.

## F2. Classified history representation

Observed: September 28.

**Task and steps:** Normalize human/vehicle history correctly. Compared history examples, event-type table and webhook subtype contract.

**Expected:** Complete human and vehicle response examples. **Actual:** Generic motion examples and classified filters did not fully illustrate returned subtype representation.

**Severity:** Important. **Workaround:** Preserve generic motion; use dedicated documented event_types filters in configured mode; contract-test both forms.

**Actionable suggestion:** Publish exact history payload examples for each supported classification. **Current outcome:** Implemented/contract-tested; live classification unverified.

## F3. Playground control and event mismatch

Observed: September 28–30.

**Task and steps:** Exercise a two-device visit without hardware. Used Vehicle, then one bounded Motion control/history check.

**Expected:** Classified vehicle/person observations for visit validation. **Actual:** One device and on_demand history were returned; control labels described live-view media, not detected motion.

**Severity:** Important. **Workaround:** Stopped unchanged attempts; display actual live views separately; positive visit uses labeled samples.

**Actionable suggestion:** Provide independent simulated devices and typed history/webhook scenarios. **Current outcome:** Coverage limit persists; actual ingestion succeeds.

## F4. Playground playback failure

Observed: September 28; follow-up September 30.

**Task and steps:** Play simulator footage. Created WHEP sessions through Vehicle/Motion controls.

**Expected:** Playable video after successful session creation. **Actual:** HTTP 201 sessions showed Unable to play media; later September 30 capture played successfully.

**Severity:** Moderate. **Workaround:** Preserved failure and stopped repeated attempts; used the later observed working playback.

**Actionable suggestion:** Report safe negotiation/player diagnostics separately from session creation. **Current outcome:** Later playback works; original cause unresolved.

## F5. Token scope and local storage approval

Observed: September 28.

**Task and steps:** Use a temporary Playground credential safely. Reached Generate token; after approval inspected stated lifetime and attempted bounded local setup.

**Expected:** Clear scope/lifetime and safe transfer. **Actual:** Automation approval blocked generation until specific consent, then separately blocked a token file; UI stated 30-minute lifetime but no scope list.

**Severity:** Moderate, setup process. **Workaround:** Obtained specific consent and used request-only UI entry without a credential file.

**Actionable suggestion:** Show scope and expiry before generation; document direct app token use. **Current outcome:** Request-only entry works; this was not a Ring outage.

## F6. Account and credential prerequisites

Observed: September 28–29.

**Task and steps:** Reach first live Ring and Bedrock calls. Inspected presence of local configuration and opened provider consoles.

**Expected:** An authenticated provider context. **Actual:** Ring and AWS separately required owner sign-in; local configuration was initially absent; later sessions expired.

**Severity:** Expected prerequisite. **Workaround:** Owner signed into intended accounts and entered credentials privately.

**Actionable suggestion:** List separate account prerequisites in simulator and SDK quickstarts. **Current outcome:** Historical setup gate resolved; current key validity not assumed.

## F7. Bedrock account verification

Observed: September 28.

**Task and steps:** Run Nova Micro from Around. Submitted expectation, added safe diagnostics, compared one console invocation.

**Expected:** Parsed expectation or actionable setup error. **Actual:** Early requests failed; console finally reported account verification pending.

**Severity:** Blocking at the time. **Workaround:** Stopped unchanged calls and resumed only after new evidence and authorization.

**Actionable suggestion:** Surface verification status before model testing and key generation. **Current outcome:** Console later succeeded; original denials retained.

## F8. Bedrock bearer access denial

Observed: September 29.

**Task and steps:** Match console success from the app. Used same model/region and valid-shaped temporary key; inspected fixed error categories.

**Expected:** SDK Converse success. **Actual:** Console succeeded while app calls returned AccessDeniedException HTTP 403; exact rejection cause remained unknown.

**Severity:** Blocking at the time. **Workaround:** Stopped same-key retries; separately approved narrow IAM identity and one-day Bedrock key enabled parsing.

**Actionable suggestion:** Provide minimal bearer-auth policy/example and precise safe authorization reasons. **Current outcome:** Alternate credential worked; cause of prior denial unresolved.

## F9. Explicit briefing intent error

Observed: September 29.

**Task and steps:** Answer Anything I should know? as a daily briefing. Ran the exact UI shortcut through model intent interpretation.

**Expected:** Today’s stored activity and expectations. **Actual:** Grounded response answered only a visit question.

**Severity:** Important, application/model interaction. **Workaround:** Route exact briefing shortcuts deterministically, retain Bedrock fact selection; regression and one authorized live recheck passed.

**Actionable suggestion:** Document deterministic command routing alongside natural-language intent examples. **Current outcome:** Resolved for observed command; no universal model-reliability claim.

## F10. Credential retrieval and coordination

Observed: September 29.

**Task and steps:** Renew the limited Bedrock demo credential. Inspected retrieval dialog; attempted transfer; later performed authorized cleanup.

**Expected:** Private retained credential and controlled local entry. **Actual:** A credential appeared in automation output; another retrieval dialog closed before capture; synthetic clipboard transfer also failed.

**Severity:** High, handling failure. **Workaround:** Stopped reuse, obtained cleanup approval, verified keys removed and used owner-only retrieval/direct entry; no secret values retained in this log.

**Actionable suggestion:** Keep credential dialogs outside automation output and validate transfer using synthetic text first. **Current outcome:** Cleanup completed at the time; no provider defect established.

## F11. Generic Ring sync error

Observed: September 29–30.

**Task and steps:** Capture a successful Ring sync. Submitted sync after private token entry; inspected stored counts and token-free diagnostics.

**Expected:** Visible success or useful safe error. **Actual:** Generic HTTP 500; original two records preserved. Separate TLS probe succeeded but did not explain the request.

**Severity:** Important. **Workaround:** Added fixed stage/category diagnostics and rollback tests; fresh-token/restarted-server syncs succeeded without duplicates, later sync added one record.

**Actionable suggestion:** Separate discovery/history/response/storage categories without raw messages or secrets. **Current outcome:** Recovered execution; original cause unresolved because token and server both changed.

## F12. Incompatible Git executable

Observed: September 28.

**Task and steps:** Inspect/init repository. Ran git status with default PATH.

**Expected:** Working Git. **Actual:** /usr/local/bin/git: Bad CPU type in executable.

**Severity:** Low, local environment. **Workaround:** Used /usr/bin/git.

**Actionable suggestion:** Install a host-compatible Git or correct PATH. **Current outcome:** Resolved by system Git.

## F13. npm restricted network/cache

Observed: September 28.

**Task and steps:** Discover/install dependencies. Ran npm view and installation in restricted environment.

**Expected:** Registry response and writable cache. **Actual:** ENOTFOUND for registry.npmjs.org and cache permission restrictions.

**Severity:** Low, local environment. **Workaround:** Approved network/cache execution; preserved lockfile.

**Actionable suggestion:** Explain sandbox network/cache needs separately from package defects. **Current outcome:** Installation completed.

## F14. tsx IPC restriction

Observed: September 28.

**Task and steps:** Run targeted TypeScript tests. Invoked tsx CLI test runner.

**Expected:** Tests execute. **Actual:** EPERM opening temporary IPC socket before tests.

**Severity:** Low, local environment. **Workaround:** Ran identical suite with node --import tsx --test.

**Actionable suggestion:** Document no-IPC invocation. **Current outcome:** Resolved without weakening tests.

## F15. Application SQL mistakes

Observed: September 28.

**Task and steps:** Persist expectations and events. Ran first executable test suite.

**Expected:** Correct inserts and grouping. **Actual:** SQL placeholder-count mistakes caused test failures.

**Severity:** Important, application defect. **Workaround:** Used explicit insert columns and corrected counts.

**Actionable suggestion:** Keep insert columns explicit and transactional tests. **Current outcome:** Resolved; later checks passed.

## F16. Local origin validation

Observed: September 28.

**Task and steps:** Submit local UI requests safely. Ran production browser flow at 127.0.0.1.

**Expected:** Local POST accepted; foreign origin rejected. **Actual:** Next canonicalized request URL to localhost, causing valid POST to receive 403.

**Severity:** Important, application defect. **Workaround:** Compare browser Origin to separately validated Host; retain foreign-origin/host/port tests.

**Actionable suggestion:** Document canonicalized server URL behavior. **Current outcome:** Resolved with regression coverage.

## F17. Playwright installation and server permission

Observed: September 28–30.

**Task and steps:** Run production browser checks. Launched existing suite.

**Expected:** Matching Chromium and localhost test servers. **Actual:** Initial missing Chromium revision prevented launch; sandbox listen EPERM later blocked ports before assertions.

**Severity:** Low, local environment. **Workaround:** Installed matching browser earlier; unchanged suite ran with approved local-server permissions.

**Actionable suggestion:** Document browser revision and localhost requirements independently. **Current outcome:** Current pass: first restricted run failed before tests, host run passed all three.

## F18. Browser selector and stale answer

Observed: September 28.

**Task and steps:** Verify error UI and updated expectations. Ran Playground browser flow and manually added an expectation.

**Expected:** App alert selected and old answer cleared. **Actual:** Generic alert matched Next route announcer; saved expectation left stale answer visible.

**Severity:** Moderate, test/application defects. **Workaround:** Scoped application alert selector; clear old answer on save and assert it.

**Actionable suggestion:** Use app-specific alert hooks and verify derived UI invalidation. **Current outcome:** Resolved with browser assertions.

## F19. Recorder and browser-surface coordination

Observed: September 28–30.

**Task and steps:** Capture the actual Around interaction. Opened recording apps, switched tabs, started owner capture.

**Expected:** Responsive recorder and correct visible app surface. **Actual:** Long tool responses, Mac lock, unavailable controls and wrong-browser checks. One 224.9-second take captured empty setup fields instead of the successful Chrome sample.

**Severity:** Important, local capture process. **Workaround:** Stopped repeated recorder launches; owner started capture; verified native active tab; recorded saved results without more inference.

**Actionable suggestion:** Preflight the visible recording area before consuming provider calls. **Current outcome:** Usable later footage recovered; original failed take preserved.

## F20. Password prompt obscures sync

Observed: September 30.

**Task and steps:** Record Ring sync action/result. Recorded a successful sync after form token entry.

**Expected:** Readable uninterrupted result. **Actual:** Native Save password prompt obscured result in 311.138-second take; browser screenshot did not show native popup.

**Severity:** Important, capture limitation. **Workaround:** Owner dismissed prompt; separate saved-result continuation; final cut discloses separate takes/still.

**Actionable suggestion:** Check native overlays and exclude credential setup from capture. **Current outcome:** Final video lacks an unobscured sync click; runtime success separately verified.

## F21. Player crop and trace visibility

Observed: September 30.

**Task and steps:** Capture safe Playground playback. Activated Motion and attempted player-only framing.

**Expected:** Only simulator video visible. **Actual:** Trace/credential UI entered the capture region; a DOM-bounded screenshot returned the wrong region. Later native inspection identified a literal token placeholder, not established token exposure.

**Severity:** High caution, capture process. **Workaround:** Stopped unchanged capture; kept raw take private; used reviewed cropped footage.

**Actionable suggestion:** Inspect native framing and treat raw source as private until reviewed. **Current outcome:** Safe approved excerpt published; raw take not cleared.

## F22. Media tooling permissions and capabilities

Observed: September 29.

**Task and steps:** Inspect local recordings and narration. Tried FFmpeg decode-to-null and macOS decoder/audio analysis.

**Expected:** Local decode/level checks. **Actual:** Bundled FFmpeg lacked null muxer; sandbox AVFoundation -11821/-12911 and AVFAudio 1718449215 prevented analysis; local speech recognition was unavailable.

**Severity:** Moderate, local tooling. **Workaround:** Used browser playback/frames and approved host decoder access; owner confirmed script for captions.

**Actionable suggestion:** Distinguish decoder permission/capability failure from corrupt media; do not infer transcription from amplitude. **Current outcome:** Analysis completed where supported; no external transcription used.

## F23. Contact-sheet drawing lifetime

Observed: September 29.

**Task and steps:** Generate review frames. Decoded frames and used AppKit drawing around async work.

**Expected:** Stable contact sheet. **Actual:** Helper crashed when drawing state crossed asynchronous suspension.

**Severity:** Low, media helper defect. **Workaround:** Decode first, then draw synchronously.

**Actionable suggestion:** Keep drawing state out of async suspension. **Current outcome:** Resolved.

## F24. Joined video incompatibility and timeline gaps

Observed: September 29–30.

**Task and steps:** Assemble readable combined demo. Joined source clips, validated and reviewed playback.

**Expected:** Visible sample throughout joins. **Actual:** One cut played white; multiple AVC configurations were present. Later AVFoundation -11841/-17390 exposed a one-tick timeline gap; another completed export still had white sample frames.

**Severity:** Important, media assembly. **Workaround:** Preserved failures; exact CMTime arithmetic; decoded/re-encoded into one video configuration; removed a one-frame flash; verified continuous playback.

**Actionable suggestion:** Validate timeline continuity, decoded frames and actual playback across joins. **Current outcome:** Approved v13 completed published playback; sources unchanged.

## F25. Soundtrack writer lifetime

Observed: September 29.

**Task and steps:** Export original synthesized soundtrack mix. Wrote WAV then loaded it into AVAsset.

**Expected:** Readable finished stem. **Actual:** AVFoundation -11800/-12842 on first mix; writer likely remained open.

**Severity:** Low, media helper defect. **Workaround:** Close WAV writer before asset load; one bounded retry succeeded.

**Actionable suggestion:** Make writer lifetime explicit before downstream reads. **Current outcome:** Resolved; cause remains a supported hypothesis.

## F26. Accumulated stale submission notes

Observed: September 29–30.

**Task and steps:** Prepare clear current submission materials. Compared current evidence with README and historical notes.

**Expected:** One current account of readiness. **Actual:** Old provider-pending statements, earlier scripts and an overly restrictive organizer-approval interpretation mixed with current guidance.

**Severity:** Moderate, documentation process. **Workaround:** Preserved history and separated current judge-facing documentation; Playground FAQ does not require an individual organizer reply.

**Actionable suggestion:** Maintain a dated evidence matrix and current status separate from history. **Current outcome:** Corrected locally; updated package awaits publication approval.
