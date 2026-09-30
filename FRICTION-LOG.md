# Friction log

Record problems when observed. No reconstructed provider experiences.

## 2026-09-30: Ring sync diagnostic repair

The prior recording's generic HTTP 500 remains unexplained. A token-free host TLS handshake to api.amazonvision.com verified successfully in 81 ms. This rules out a TLS failure in that separate probe only; no provider HTTP request was sent.

The Ring adapter now returns fixed failure stages and allowlisted categories for fetch and response-body exceptions. The sync route distinguishes response validation from local storage failures. Invalid header characters are rejected before fetch. Raw provider errors, payloads and credentials stay out of responses and logs. Existing explicit HTTP errors remain intact; no retries or fixture fallback were added.

TypeScript, lint, all 31 tests, production build and all three browser scenarios passed. Synthetic cases cover interrupted bodies, late-page failure without ingestion, redaction, and a real SQLite rollback after an insert. A synthetic malformed-header POST to the restarted production route returned HTTP 400 before any Ring transport.

Owner entered a fresh token in the actual Codex app page. Two presence-only selector reads timed out; a screenshot showed the populated masked field. One keyboard activation submitted the diagnostic sync successfully. Around reported “Already up to date. No duplicate moments were added.” One device, two original Ring live views and zero matches remain stored. This establishes current API connectivity and deduplication, not a new event or the cause of the prior failure. Both token and server state changed. No paid inference was used. Owner was asked to prepare one new recorded sync; successful diagnostic footage does not exist because recording was off.

## 2026-09-29: submission readiness recheck

`npm run check` passed TypeScript, lint and all 28 targeted tests. Production build passed. The first browser-suite run stopped before assertions because sandbox networking rejected binding 127.0.0.1:3100 with `listen EPERM`. The unchanged suite then passed all three scenarios with approved local-server execution. This was an execution restriction, not a new app failure or provider result.

Fresh read-only data verification found the original two September 28 Ring live views, one device and zero matches. Approved sample master SHA-256 is recorded in docs/SUBMISSION-READINESS.md. A fresh signed-in Ring Playground tab needs private temporary-token entry before actual ingestion can be recorded. No paid provider call was made during this recheck. Earlier unused-call allowances are superseded by the owner's instruction to ask before additional paid calls.

Capture setup then hit a host blocker. A read-only inspection of the already-running QuickTime app took about 19 minutes 50 seconds and returned that the Mac was locked and could not be unlocked automatically. No recording was verified as started. Stopped UI attempts and requested owner unlock. No new sync, inference or video was produced. Continue only after the host state changes; do not retry recorder launch unchanged.

### Capture resumed after unlock

The Mac became accessible, but the native recording command did not expose usable controls. Owner-started recording was selected. Lead checked three Chrome Ring tabs and found empty token fields, but the owner had entered the token in the Codex in-app browser. Presence-only inspection of that correct tab confirmed the token and an empty Bedrock field. The unnecessary repeated entry requests were caused by checking the wrong browser. No token was read, moved or printed.

Owner confirmed recording. The pointer action on Sync Ring activity produced no status and did not clear the token. The input was valid and browser error logs were empty. One keyboard activation cleared the field and submitted the request. Around returned the generic “The request could not be completed. Check local configuration and try again.” Its generic error handler maps this to HTTP 500; the underlying exception was not exposed. No retry followed, and the owner was asked to stop recording.

Read-only database verification still found one device, the original two September 28 Ring live views and zero matches. One host DNS-only lookup resolved api.amazonvision.com without a credential or provider HTTP request. DNS success does not identify the sync failure or establish current API availability. The server console had no further diagnostic category. Steward recommended stopping after the token-free diagnostic. No new Bedrock call, feature, upload, publication or submission occurred.

Owner confirmed the take saved to Desktop. Preserved the original and verified an identical project copy at data/recordings/around-ring-sync-failed-2026-09-29.mov. Technical inspection: 194.788 seconds, 602 by 734, one audio track. Eight inspected frames show the correct app, masked token field, cleared field and later generic error. No unmasked credential was visible in those frames; audio was not reviewed. Keep it as failure evidence. It does not show successful ingestion and is not a submission cut. The approved sample master remains byte-for-byte unchanged.

## 2026-09-28: Local Git executable incompatible with host

- Tool/task: Git, inspect empty workspace before implementation.
- Steps: ran `git status --short`.
- Expected: repository status or a not-a-repository message.
- Actual: `/usr/local/bin/git: Bad CPU type in executable`.
- Severity: low, local developer tooling.
- Workaround: check Apple's `/usr/bin/git` directly before initializing.
- Suggestion: remove the incompatible executable from PATH or install a host-compatible Git.
- Status: resolved by `/usr/bin/git`; repository initialized after sandbox approval.

## 2026-09-28: Public simulator contract not discoverable in linked entry points

- Tool/task: official Ring docs and hackathon resources, find simulator event production and multiple virtual devices.
- Steps: inspected hackathon resources, Ring getting-started/development/API reference, and canonical AmazonAppDev/ring-api-helloworld README; searched official pages for simulator instructions.
- Expected: simulator URL, event creation controls or API, supported events and device provisioning.
- Actual: hackathon permits simulators; general docs mention synthetic sandbox data, but inspected references do not expose an actionable event-generation contract.
- Severity: high for submission integration validation.
- Workaround: implement the verified device/history/webhook contract and a separately labeled local fixture adapter. Never describe fixtures as the official simulator.
- Suggestion: link a simulator quickstart with event payload examples from the hackathon Ring resource section.
- Status: unresolved. Need an official simulator entry point or authorized Ring API account to run provider checks.

## 2026-09-28: Provider configuration not present in the development shell

- Tool/task: Ring and AWS setup for runtime validation.
- Steps: checked only presence of Ring token and AWS profile/region/credential environment variables, without reading or printing secrets.
- Expected: usable explicit project configuration.
- Actual: no project files or selected provider configuration in this new workspace; checked variables absent. No provider request attempted.
- Severity: high for live integration verification, low for local demo.
- Workaround: explicit fixture modes and documented environment settings. Provider modes must fail visibly when unconfigured.
- Suggestion: provide a simulator credential/setup checklist alongside example apps.
- Status: external setup pending. No account, payment, access or credential changes made.

## 2026-09-28: npm network access in sandbox

- Tool/task: npm package discovery.
- Steps: `npm view next version` under restricted execution.
- Expected: current package version.
- Actual: first attempt failed with ENOTFOUND for registry.npmjs.org. A bounded probe and approved network execution returned 16.3.6.
- Severity: low, local environment.
- Workaround: approved network execution for dependency installation.
- Suggestion: expose sandbox network requirements before starting dependency setup.
- Status: installed successfully. Lockfile refresh also required approved execution because the default npm cache is outside writable roots. No cache permissions were changed.

## 2026-09-28: TypeScript test-runner IPC blocked by sandbox

- Tool/task: tsx CLI, run the targeted domain tests after typecheck and lint passed.
- Steps: ran `tsx --test tests/*.test.ts`.
- Expected: test execution.
- Actual: EPERM opening the tsx temporary IPC socket, before any tests ran.
- Severity: low, local tooling.
- Workaround: use `node --import tsx --test tests/*.test.ts`, preserving the same tests and TypeScript loader without the CLI IPC server.
- Suggestion: document a no-IPC test invocation for restricted environments.
- Status: resolved. All 20 targeted tests passed using the alternative invocation.

## 2026-09-28: Ring history subtype representation is unclear

- Tool/task: event classification through the official history API.
- Steps: compared example history response with the event-type table and webhook reference.
- Expected: an example showing a human or vehicle history event.
- Actual: examples show generic `motion`; the table lists `motion.human` and `motion.vehicle`, and subtype filters are documented. Webhooks explicitly expose `attributes.sub_type`.
- Severity: medium for historical visit classification.
- Workaround: preserve generic motion without inventing a classification; use explicit subtype filters to obtain classified history and webhook subtypes when supplied.
- Suggestion: add human and vehicle response examples documenting how subtype is represented.
- Status: both representations implemented and contract-tested; live response verification pending.

## 2026-09-28: Playwright browser version missing

- Tool/task: production browser demo verification.
- Steps: ran `npm run test:e2e` after a successful production build.
- Expected: Chromium runs the exact plumber flow.
- Actual: installed Playwright 1.63.0 expects Chromium headless shell 1243; the machine has revision 1228. Browser launch failed before app assertions ran.
- Severity: low, local tooling.
- Workaround: install the matching Chromium headless shell, then rerun the unchanged browser scenario.
- Suggestion: show required browser installation clearly in fresh-project setup.
- Status: resolved after installing matching Chromium headless shell. The original launch failure is preserved here; a later full browser run passed.

## 2026-09-28: Next.js URL normalization exposed an origin-check bug

- Tool/task: browser POST to Ask Around during the exact production demo.
- Steps: used Chromium at http://127.0.0.1:3100, then clicked the plumber question.
- Expected: a no-evidence answer in a new database.
- Actual: the request returned 403. Browser trace showed a matching local Host and Origin; Next's internal request URL used a different loopback representation.
- Severity: high for the local demo until repaired. This was an application integration mistake, not a Ring/AWS error.
- Workaround: compare Origin against the validated incoming loopback Host, retaining strict protocol and port equality and rejecting foreign hosts/origins.
- Suggestion: include framework-normalized URL behavior in local-only API test examples.
- Status: resolved. Regression test passes, and the exact production browser flow passes without weakening its assertions.

## 2026-09-28: Ring console requires owner sign-in

- Tool/task: establish an official Ring event source for the first provider-backed demo.
- Steps: rechecked official onboarding/configuration docs; checked project environment and AWS configuration presence without reading secrets; opened https://developer.amazon.com/ring/console/apps in Chrome.
- Expected: inspect existing app access and simulator/test controls.
- Actual: redirected to Amazon Developer Sign-In with an empty email/mobile field. No authenticated developer account is available in this session. Local Ring variables, AWS variables, AWS config/shared-credentials files and project .env.local are absent.
- Severity: blocking for live integration verification; expected account setup requirement, not an API failure.
- Workaround: owner signs into the intended Amazon developer account in the browser. No credentials should be pasted into chat. Continue console inspection after sign-in.
- Suggestion: make simulator access and account prerequisites explicit in hackathon resources.
- Status: waiting for owner sign-in. No app registration, access grant, credential creation, subscription, AWS resource or inference request performed.

## 2026-09-28: Browser connection unavailable during setup

- Tool/task: open Ring developer console.
- Steps: attempted the in-app browser, then inspected available browser/app surfaces.
- Expected: reuse the earlier connected in-app preview browser.
- Actual: in-app browser was unavailable; browser inventory was empty. Native Chrome launch eventually succeeded after an unusually long tool response.
- Severity: moderate setup delay, local tooling.
- Workaround: use native Chrome controls. Console is now open at Amazon sign-in.
- Suggestion: browser tooling should return a bounded launch status instead of keeping a launch request pending for an extended period.
- Status: navigation recovered; account login is the remaining gate.

## 2026-09-28: Official Playground discovered after sign-in

- Follow-up to missing simulator entry point: the authenticated Ring console exposes a Playground sidebar item at https://developer.amazon.com/ring/console/playground.
- Observed: temporary OAuth token generation, API exploration, simulated live-view events, and instructions to use the token in a test app.
- Earlier public-documentation discovery failure remains valid, but the entry point is now located.
- Status: inspecting test controls and authorization; no successful API/event receipt yet. No token values are recorded here.

## 2026-09-28: Temporary Playground token requires specific approval

- Tool/task: obtain the official Ring Playground OAuth test token for Around.
- Steps: reached the authenticated Playground and attempted its Generate token control.
- Expected: inspect token-generation/authorization flow, keeping any token out of output.
- Actual: automatic approval review rejected the action before execution. It classified token generation as security-sensitive access and found that general setup authorization did not specifically cover generation, scope or lifetime.
- Severity: owner approval required; not a Ring API failure.
- Workaround: request explicit approval for the shown Generate token action. Do not retry indirectly or change tools to bypass the rejection.
- Suggestion: display token scope and lifetime before generation in the Playground.
- Status: approval requested. Token generation has not executed; no provider request from Around has run.

## 2026-09-28: Playground token generated, local credential storage blocked

- Owner explicitly approved temporary token generation. Playground generated it and displayed a 30-minute lifetime; closing the tab clears it. No scope list was displayed.
- Automatic approval review separately rejected writing the token to a restricted temporary file because generation/use approval did not clearly authorize a credential artifact on disk.
- No credential file was written and no alternative persistence route was attempted. Token values are excluded from logs and documentation.
- Read-only device discovery and history were tested through the official Playground UI. Around code has not called the provider yet.

## 2026-09-28: Playground Vehicle control produces a live-view history entry

- Tool/API: official Ring Playground, Device List, Vehicle live-view control and Event History.
- Observed: discovery returned one device. Vehicle created a WHEP session with HTTP 201. The player displayed "Unable to play media." After closing it, history returned one history-events resource with event_type on_demand and start/end timestamps.
- Impact: this proves console API access and media-session creation, but not a vehicle-motion detection. Around must exclude on_demand from visit evidence. One device cannot be represented as two distinct physical zones.
- Next bounded check: inspect the Motion control and read history once; stop if it also produces on_demand. Do not add video recognition, invent a second device, or relabel live-view history.
- Suggested improvement: distinguish simulated video selection from motion-event generation and document how to generate typed events across several synthetic devices.

- Final bounded check: Motion also created a WHEP HTTP 201 session, displayed "Unable to play media," and added an on_demand history entry. History now showed two entries. No motion/person/vehicle event was observed. Simulator retries stopped per steward recommendation. Need a documented typed-event simulator path or authorized distinct real devices.

## 2026-09-28: Simulator limitation confirmed in hackathon discussion

- Owner constraint: no physical Ring devices. Continue simulator-only; do not route setup through hardware.
- Evidence: [FAQ](https://amazonappdev2026.devpost.com/details/faqs) accepts Playground demonstrations. [Hackathon discussion](https://amazonappdev2026.devpost.com/forum_topics/45309-ring-playground-chime-sub_type-and-sensor-coverage-what-s-the-intended-path-for-non-us-entrants) explains that Playground Package/Vehicle/Motion controls create live views, not motion webhooks; event-history attributes do not include webhook sub_type. The documented history filter is event_types (plural), which Around already uses.
- Impact: our observed on_demand results are expected behavior, not a token or adapter repair problem. Current Playground evidence does not provide the requested two-device classified-motion visit.
- Decision: stop unchanged simulator retries. Preserve the original acceptance criterion. Obtain organizer guidance before treating separate API and fixture demonstrations as sufficient.
- Owner: lead prepares question; user authorizes any external outreach. Progress Steward concurs. No outreach sent.

### Unsent organizer question

Title: Ring Playground: supported simulator-only path for a multi-device visit demo

We are building Around, a home-activity assistant, for the Ring track and have no physical Ring devices. Our demo groups driveway vehicle activity and front-door person activity into a probable visit, then matches it to an expected service visit.

The Playground returns one device. Its Vehicle and Motion controls create on_demand history entries, matching the explanation in the existing discussion. We understand those are live views, not detected motion.

1. Is there an official sandbox or supported test mechanism that emits classified motion for two distinct simulated device IDs?
2. If unavailable, is a Ring submission acceptable if it demonstrates actual Playground API calls from our application and separately shows the visit workflow with clearly labeled fixture data? We would explicitly disclose that the visit events are fixtures and would not claim that the Playground generated them.

Please point us to the supported simulator path or clarify whether that separated demonstration meets the Ring track requirements.

## 2026-09-28: Genuine Playground-to-answer implementation checks

- First check passed TypeScript/lint and 20 of 21 tests; the old normalization test expected live views to be discarded. Updated that assertion for the approved live-view display behavior and added regressions proving live views cannot create, bridge, or extend visits. The next 23-test run passed.
- Production browser check passed the sample visit and reached the new grounded answers, then failed because a generic alert selector also matched Next.js's route announcer. Scoped the selector to the application error, retaining the same error assertion.
- Local server initially could not bind port 3000 due to sandbox EPERM. Approved local server execution succeeded.
- Steward review prompted request-only wording and database binding to Ring device setup. These preserve evidence boundaries. No token file was created and no provider result is claimed from contract tests.

## 2026-09-28: Actual Playground-to-answer path verified

- Per-request token input avoided disk credential storage. No alternate persistence path was used. Chrome's Save password prompt was declined; note that browsers may offer credential saving even when the app requests autocomplete off.
- Around received one device and two on_demand records from the official API. Storage, UI and grounded local answers succeeded. Live views stayed separate from visit matching; no probable visit or identity claim was produced.
- A subsequent automated browser run hit sandbox EPERM on its test server before executing tests. Retain the same test flow and use approved local-server permissions.
- Manual UI verification exposed a stale answer after adding an expectation. The save action now clears the old answer, with a browser assertion added.

- Final verification: the approved local-server run passed both browser scenarios. TypeScript, lint, all 24 targeted tests, and production build pass. Actual stored Ring records survived the final restart.
- Native browser follow-up stopped when the Mac locked and automatic unlock failed. No attempt was made to bypass the lock. The organizer clarification is still unsent.

## 2026-09-28: Bedrock setup reaches AWS sign-in

- Task: verify real Bedrock parsing and grounded answers.
- Presence-only inspection found no local AWS credential/profile configuration, selected region/model, or AWS CLI. The application still uses local demo language.
- Official Bedrock console redirected to an empty IAM sign-in screen. Ring Developer sign-in did not supply an AWS console session.
- Owner account selection is pending. No account creation, IAM change, credential generation, model subscription, inference request, or AWS charge was initiated.
- Documented practical path: short-term Bedrock API key inherits the existing IAM identity and expires with its console session (up to 12 hours). Long-term key creation creates an IAM user and is not the selected path. Installed AWS SDK already supports bearer-token identity.
- Candidate model: Amazon Nova Micro supports Converse and in-region invocation in us-east-1. This is documentation evidence, not availability or permission evidence for the owner's account.
- Next step: owner signs into the intended AWS account; inspect actual model access before configuring or testing. Do not repeat unauthenticated requests.

Bedrock setup follow-up: signed-in console inspection reached Nova Micro and session-limited key controls. No inference or credential creation has occurred. Free-account entitlement remains unverified. This is an approval boundary for credential creation and model terms, not an observed AWS denial. Prepared and checked page-memory key entry as the practical alternative to local credential-file setup.

First live Bedrock request failed: electrician expectation parsing returned the app's generic 502 error, with no local fallback or saved expectation. Provider error details were deliberately hidden, but the message did not distinguish access, model availability or JSON parsing. Preserve this first failure. Next materially different test: add an allowlisted AWS error code and HTTP status to the safe application error, validate locally, then make one diagnostic retry. Do not log raw provider errors, prompt content or credentials. One of eight authorized inference attempts has been used.

Diagnostic Bedrock attempt 2: the identical expectation request returned AccessDeniedException, HTTP 403. No expectation was stored and no local fallback ran. This establishes an AWS access rejection, not successful inference; it does not by itself distinguish IAM, model entitlement or free-account restrictions. Stop further inference attempts. Two of eight authorized attempts used. Investigate the selected account/model access with read-only evidence before another call or any account change. Safe diagnostics passed TypeScript, lint, all 26 tests and a production build.

Final bounded access diagnostic: the current console says the Model access page is retired and serverless models enable on first invocation. No manual enablement or free-plan upgrade control was identified as a remedy. Attempt 3 uses the same Nova Micro model in us-east-1 through the AWS console with the tiny prompt Reply with OK, to distinguish console-account access from bearer-key access. No account, IAM, model or region change was made. Stop after its result if access remains denied.

Console attempt 3 outcome: AccessDeniedException with explicit account-verification message. AWS says verification normally takes less than two hours; if the message remains after more than two hours, write to aws-verification@amazon.com. This isolates a new-account verification dependency; no free-plan upgrade requirement is established. All three attempts were denied, zero successful Bedrock requests. Stop unchanged retries. Clear page/agent credential memory and explicitly restore local language mode. Issued session keys remain subject to expiry; they were not revoked. No email or scheduled retry was initiated.

2026-09-29 retry: the existing Bedrock tab redirected to AWS Sign-In with an empty email field after the prior session expired. No new key was generated or inference attempted. The owner must sign into the same account before verification status can be rechecked. Five approved requests remain. Around configuration and stored Ring activity are unchanged.

2026-09-29 signed-in retry: refreshed the same short-term Bedrock access in memory and invoked Nova Micro from Around with the original plumber sentence. Attempt 4 of 8 returned AccessDeniedException, HTTP 403. No expectation was stored and no fallback ran. One console check will determine whether the provider still reports account verification; no app-code or IAM changes are warranted by this result.

Attempt 5 diagnostic changed the evidence: the same Nova Micro model answered the tiny prompt successfully in the AWS console. Account/model invocation is now available through the console. Around's attempt 4 still failed with its temporary bearer key, so investigate authentication differences rather than continuing to claim a verification blocker. Three approved calls remain. No successful Around-to-Bedrock request yet.

Bearer-path diagnosis: the captured key has no whitespace, truncation marker, quote wrapper or extra Bearer prefix. Same region/model is configured as the successful console call. Added fixed, allowlisted reason categories to safe error handling, without exposing raw provider text. One instrumented app request is authorized as attempt 6; stop if unresolved. If it succeeds, two calls remain for one grounded Ask operation. Progress Steward reviewed this bounded diagnostic and the distinction between console success and app integration.

Attempt 6: instrumented Around parsing still returned AccessDeniedException 403 with no recognized safe reason category. Stop further requests on the same key. Console inference succeeded once; Around has zero successful Bedrock executions. Exact bearer rejection cause remains unconfirmed. Six of eight calls used. Inspecting the official dedicated-key setup is read-only; creating its IAM identity or expanding test allowance requires owner approval.

Dedicated-key recovery: the narrow IAM user and one-day Bedrock-specific key succeeded on the first Around parsing request (attempt 7). The original plumber sentence was saved for 2026-09-29, 10:00–13:00, Home. This is actual app-side Bedrock execution. It establishes that the alternate credential works; it does not establish why the prior short-term key was denied. Testing a dated question about Sep28 preserves the date of actual Ring records.

Grounded question succeeded in Around (attempts 8–9): Did the plumber come yesterday? selected the Sep28 expectation and cited the 2:56PM live-view request without claiming a visitor. The briefing test (attempts 10–11) exposed a real intent failure: Anything I should know? was treated as a visit question and returned only today's unmatched plumber status. The text was grounded but not the requested briefing. Preserve this failure. Fix the explicit UI briefing commands with deterministic routing before Bedrock fact selection; other natural-language intent still uses Bedrock. The eleven-call ceiling is reached, so verify locally and request one additional live briefing call before declaring that flow validated.

Final briefing check: owner approved exactly one additional Converse request, call 12 overall, within the existing $0.10 budget. Invoked the corrected Anything I should know? shortcut with the already approved key. No IAM, credential, model or permission changes were made for this check.


Call 12 passed: the daily briefing reported today's missing stored activity and expected plumber window, preserved uncertainty and excluded yesterday's activity. The exact briefing command used one fact-selection call, as covered by the regression test. Twelve requests overall: five denials, one console success, six app-side responses including the preserved earlier intent failure. No additional requests or permission changes were made. The application remains in Bedrock mode with the approved one-day key held only in the current page.

## 2026-09-29: transparent submission preparation

- Process correction: earlier guidance made an organizer reply a prerequisite for continuing with a hardware-free demo. That was an overly restrictive interpretation, not an explicit rule. The FAQ permits Playground demos. Owner approved proceeding with separate actual-provider and clearly labeled sample segments; this does not guarantee eligibility or establish classified Ring event coverage.
- Documentation friction: accumulated onboarding notes left superseded provider-pending and approval-gate statements mixed with current guidance. Rewrote SUBMISSION-COPY as current submission language and labeled historical checkpoints in README and PRODUCT-FEEDBACK. Preserved original failures here.
- Practical workaround: the sample launcher explicitly overrides inherited source, language and database settings. Each launch creates a separate database. Home shows the event source and language mode, so the full sample visit can be rehearsed without overwriting Ring records or consuming cloud inference.
- The existing Git binary at /usr/local/bin/git still fails with Bad CPU type in executable. The system /usr/bin/git works. No repository metadata or publication changes were made.
- No new Ring sync, AWS invocation, account change, credential generation or organizer outreach occurred during this preparation.

## 2026-09-29: local rehearsal recording

- Captured the isolated sample flow with Playwright video recording, with source labels and local language mode intact. No provider calls or credentials were involved.
- The bundled Playwright FFmpeg reads the resulting WebM metadata but lacks the null output muxer, so an attempted full decode-to-null check fails with Requested output format null is not known. This is a tooling capability limit, not evidence of corrupt footage. Use browser video decoding and representative frame inspection as the materially different playback check.
- Playback check passed in Chromium: 54.8 seconds, 1280 by 900, no media error. Five decoded frames at 2, 20, 31, 40 and 48 seconds were inspected. Footage shows local sample activity, with no credential fields or provider execution claims. No application code changes were needed.

## 2026-09-29: approved provider recording setup

- Owner approved one Ring token refresh, equivalent limited Bedrock credential renewal, six additional Converse calls (eighteen overall), and an additional $0.10 authorized spend. No broader IAM access or publication is authorized.
- Ring token refresh succeeded with the stated 30-minute lifetime. No additional Bedrock requests have been made at this checkpoint.
- The original Bedrock retrieval dialog was still present when first visiting IAM; a browser-state output inadvertently included the credential. Subsequent state handling was restricted to selected non-secret fields. No key was saved to disk or included in recording footage.
- One equivalent one-day Bedrock key was generated on the existing around-bedrock-demo identity. The one-time retrieval dialog closed before the key could be retained in agent memory; a later read shows two API keys. Cause of the dialog closure is unknown. Do not generate a third key or delete credentials to bypass the service limit. The original Around page still holds its key. Next bounded test: direct UI transfer between the two local password fields, with presence/length checks only; no provider call until that succeeds.
- Steward redirected this test to synthetic text because the original key had appeared in tool output. Lead accepted the redirect, notified the owner, and stopped real-credential reuse. One local dummy copy/paste attempt failed because the browser clipboard had no data. The dummy input was cleared; no inference was submitted. Do not retry that method with a real key.
- Concurrent user activity in Chrome changed the active page during setup. The later dummy test used a separate Codex browser tab. This observation does not prove why AWS's retrieval dialog closed.
- Prepared docs/CREDENTIAL-RECOVERY.md with exact scoped cleanup and owner-assisted credential entry. Deletion of the two demo keys and replacement awaits approval. Zero of the six newly authorized calls were used. No IAM policy changes or recording occurred in this setup phase.

### Approved cleanup attempt

Owner approved deleting both demo keys and creating one equivalent one-day replacement. The original key was successfully deactivated, confirmed by AWS success status and Inactive. Its deletion dialog requires typing confirm. Two input attempts were stopped by browser user-control changes before confirmation was entered. Do not repeat these unchanged attempts. Requested that the owner leave Chrome untouched briefly; prepare the local handoff while waiting. The second key is not yet deleted or deactivated, no replacement has been generated, and no additional Converse calls have been made.

Cleanup resumed after owner yielded Chrome. AWS showed the original key's successful deletion and the uncaptured 16:05 replacement as the sole remaining key. Deactivated and deleted that key; API keys (0) and No API keys confirmed removal. Read back the unchanged single inline policy and exact regional/model limits. Replacement generation is configured for one day, with owner-only retrieval and direct entry into two prepared empty Around fields. No additional inference or recording has occurred.

### Owner key entry and native recording blocker

Owner reported entering the replacement key. Presence-only checks found keys in Chrome rather than the separate Codex tabs. Both initial Chrome Around tabs were on port 3000; opened the actual sample page on port 3003 and owner pasted there. Its Clear Bedrock key button is enabled. No key value was read or displayed. Owner completion is evidence of entry, not successful inference or verification of the new AWS key's expiry.

Native recording setup failed before any additional provider call. Opening Screenshot timed out; the recording keyboard shortcut did not expose usable controls. Opening QuickTime by its observed bundle ID then timed out after about 224 seconds. No recording was verified as started. Stop automated recorder launch attempts and use an owner-started selected-area capture. Do not treat this delay as successful video evidence or consume the provider allowance without a capture plan. All six additional Converse calls remain unused.

Owner confirmed recording is running. Began the sample flow in the existing Chrome tab on port 3003, without reading credentials or reloading. Submitted the original plumber expectation once. This is call 13 overall, the first of the six additionally authorized Converse calls; result pending. Stop on provider failure. Source remains sample events with Bedrock language, not live Ring detections.

Call 13 succeeded: plumber expectation saved for 2026-09-29, 10:00–13:00. Played the four local sample events once, producing one probable visit and likely match. Calls 14–15 succeeded: Did the plumber come? returned qualified 10:41 AM and 11:27 AM estimates and explicitly declined to confirm identity. Expanded evidence showed the saved expectation and four-event activity. UI source label says Sample activity · Amazon Bedrock. Submitted the explicit briefing once as call 16; result pending. This is the first actual Bedrock-positive sample flow, not classified Ring detections.

Call 16 succeeded: the briefing reported one probable visit, its 10:41 AM–11:27 AM bounds, likely plumber match and unconfirmed identity. Four additional calls used, sixteen total; two remain within the recording extension. Asked owner to stop capture. Found the new Desktop screen-recording file and copied it into data/recordings for review. Its existence alone does not verify usable framing or complete footage.

The first local AVFoundation frame-extraction check failed in the sandbox with Cannot Decode (-11821), underlying -12911, after a denied kernel capability query. This does not establish that the recording is damaged. Next bounded test: the same local read-only media inspection with approved host execution so macOS decoder services are available. No re-recording or paid inference retry is warranted by this result.

Host decoding succeeded, but the temporary contact-sheet helper crashed because AppKit drawing state crossed an asynchronous suspension. Fixed by decoding all frames before synchronous drawing. The corrected helper passed. This was review tooling, not an application or provider failure.

Media review found an unusable capture: 224.9 seconds, 340 by 430 pixels, one audio track. Thirteen frames across the file show a static crop of empty Ring/Bedrock setup fields in the Codex browser, not the Chrome sample flow. Audio was not reviewed. Lead should have verified the recording area before spending the four calls. Notified owner, preserved the MOV, declined a Chrome save-password prompt, and raised the actual Chrome demo window. Corrected capture can show the existing saved results without more inference. Runtime success remains verified; usable new demo footage does not.

Owner reframed the recording and confirmed a new take. Raised the actual Chrome port-3003 window, expanded the saved Bedrock briefing's two evidence records, scrolled to center the probable visit and plumber expectation, then returned to the source labels and briefing. No Tell, Ask, sync or provider request was made. Asked owner to stop capture; saved-file review is pending. Total Converse requests remain sixteen, with two approved calls unused.

Corrected-take review passed: the second Desktop MOV is 143.803 seconds at 952 by 886 and shows the actual Chrome sample results. It contains one audio track and a brief view of masked credential controls. Preserved the original, then exported a 38-second silent MP4 from source intervals 20–53 and 80–85, excluding that section and long pauses. Verified export decoding, zero audio tracks and eleven frames including the cut boundary. This is saved-results footage, not a replay of provider requests. No new recording infrastructure or inference calls were needed for the edit.

### 2026-09-29: joined video plays opener, then white in owner preview

The owner reported white footage after the new logo opener. Previous extracted-frame checks passed and did not catch playback incompatibility. The AVFoundation combined export retained two AVC format descriptions. Kept the failure artifact and source clips; fully decoded and re-encoded to a fresh MP4 with one H.264 configuration. Continuous in-app browser playback showed the answer, visit/expectation cards and ending Home frame without a reported video error. Mixed encoding configuration is the likely cause; the exact original preview failure was not independently reproduced. Future edits require actual playback verification across joins.

### 2026-09-29: owner narration, local transcription unavailable

Owner supplied New Recording 8.m4a (26.068 seconds). No callable audio transcription connector or installed Whisper runtime was available. macOS Speech reported authorization denied and no on-device en-US recognition asset; no recognition request or external audio transmission was attempted. The assistant's audio-input surface could not consume the file. Asked the owner whether the approved script was read verbatim before finalizing captions.

Audio level analysis initially failed in the sandbox with AVFAudio CheckClientFormatSet error 1718449215. Running the same local analysis with approved host decoder access succeeded: mono 48 kHz, peak -9.83 dBFS. The original recording was copied to ignored data/recordings/around-owner-voice-original.m4a and remains unchanged. Speech-pause analysis can guide timing, but it is not a transcript or an audible quality review.

### 2026-09-29: Local soundtrack export

First original soundtrack mix failed with AVFoundation -11800 / underlying -12842 after writing its WAV stem. Hypothesis: the AVAudioFile writer remained open when the WAV was loaded as an AVAsset, leaving its header unfinished. Preserved first-attempt files, changed the writer lifetime to close before asset loading, and made one bounded retry. No external services or provider requests.

The bounded retry succeeded after explicitly closing the WAV writer. Final soundtrack preview is 27.8 seconds with one video format and one mixed audio track.


### 2026-09-30: successful Ring sync obscured in recording

The diagnostic sync and subsequent recorded sync both returned Already up to date, with no duplicate moments. Existing one-device/two-live-view/zero-match counts remained unchanged. This does not isolate the earlier failure cause, since token and server state changed.

Preserved `around-ring-sync-2026-09-30.mov` and its Desktop original. The 311.138-second, 510 by 740 take contains one unreviewed audio track. Eight broad and six early frames were inspected. A browser-native Save password popup obscures the result after submission, despite being absent from browser screenshots. No unmasked token appeared in the inspected frames; full-file clearance is not claimed. No submission-ready sync clip has been produced.

Read-only Steward recommended bounded salvage, then a clearly labeled saved-result continuation with no new requests. Native Codex control is prohibited by the tool, so owner dismissal and recorder start are required. No password saving, provider retry, or Bedrock call is planned. Official Playground footage remains separate pending work.


### 2026-09-30: saved-result footage recovered, combined export blocked


September 30 continuation reviewed: owner dismissed the native password popup and recorded existing results without a new provider call. Original Desktop MOV and identical copy `data/recordings/around-ring-saved-result-2026-09-30.mov` are preserved, SHA-256 `b93d0293265842fa745a1f949351c76b4302ffe8e812db7dc011518f22b2549f`. It is 243.443 seconds, 510 by 740, with one unreviewed audio track. Ten sampled frames showed clear status, source labels and dated cards. Exported a separate silent 19-second review excerpt, `data/recordings/around-ring-saved-results-review.mp4`, from source intervals 40–48, 30–37 and 48–52 seconds. Its visible caption says edited saved results, recorded September 30, and identifies the September 28 live views. The reordered excerpt is not a continuous sync recording. Browser playback reached the end with no video error; decoded frames cover both cuts. The raw take is not cleared for publication.

Combined assembly remains blocked. Two exports failed with AVFoundation -11841 / underlying -17390. Validation exposed a one-tick timeline gap from floating-point subtraction; exact CMTime subtraction repaired that defect and validation passed. The third export completed but its sample segment was white in decoded frames. That file is failed review evidence, not a deliverable. Stopped combined-render retries at the Steward checkpoint. The valid Ring section was exported separately with zero audio tracks. The approved sample remains byte-for-byte unchanged. Local review presents the two files separately; this does not satisfy completed assembly or replace official Playground and unobscured sync footage. No paid calls or external publication occurred.


### 2026-09-30: combined review recovered


September 30 assembly recovery: owner approved a separate media repair. `scripts/media/assemble-submission-review.swift` decodes the valid rendered opening and closing separately from the original approved sample, then writes all frames through one H.264 encoder. It retains the original compressed sample audio with a 24-second empty edit before playback, without gain or speed changes. The first recovered cut exposed a one-frame closing flash; the final cut omits that frame. No source was overwritten.

Current local review: `data/recordings/around-submission-review-v5.mp4`, 59.2 seconds, 970 by 920, one video configuration. The complete 29.3-second sample occupies seconds 24–53.3, with all 1,758 frames retained. Compressed audio payload hashes match across 56 blocks; the MP4 edit list verifies the 24-second offset and 29.3-second duration. Decoded frames confirm the sample is visible and the closing flash is removed. Continuous browser playback reached ended=true at 59.2 seconds, error=null, unmuted. This is technical playback verification, not a new audible quality review. The approved master hash is unchanged.

The render blocker is resolved. This remains an edited saved-results review, not a complete official Playground-to-sync capture. That footage and owner review remain open. No provider calls, feature additions, uploads or publication occurred. The original failures and prior files remain preserved.


### 2026-09-30: Playground recording interrupted by authorization trace

One authorized Motion control was used. The player briefly reported readyState 4, paused=false and no video error. These are browser state observations, not a reviewed playback claim or classified-motion evidence. The result expanded API trace blocks containing authorization markers into view. Lead switched to Around and asked the owner to stop. Around sync was not submitted.

The owner saved the take to Desktop. An identical private copy is `data/recordings/private/around-playground-trace-2026-09-30.mov`, SHA-256 `dbf605be7bedfce8b59f37ec4ba4edcf9eaaa60c8d15125a25e09062460ec42d`. Duration 163.364 seconds, 2440 by 1568, one unreviewed audio track. Treat the raw file as credential-bearing and do not publish it. No raw frames or OCR transcript were emitted from this recording.

The existing player later ended and offered Reconnect. A DOM-bounded browser screenshot intended to show only the player returned the wrong page region, including part of the credential UI. This invalidated the crop preflight. Stopped Playground capture attempts without reconnecting or invoking another simulation. No secret values are reproduced in this log. The separate prepared Around sync and safe Playground footage remain pending. No Bedrock calls or uploads occurred.


Native-window follow-up refined the warning: the visible stream request trace displayed a literal token placeholder rather than the credential. The raw take is still private pending review, but token exposure in that trace is not established. The native window also showed that browser automation changed Around in the background without activating its Chrome tab. Lead explicitly selected the observed Around tab using native controls and verified the visible window with Sync focused and token masked. Future recorded tab switches require native verification. One Around-only sync take is prepared; no additional simulation was started.


September 30 Around-only take: one sync succeeded with “1 moments received and grouped.” A native Save password prompt appeared and was gone on the next observation after owner/browser interaction interrupted dismissal; agent dismissal or password-storage state is not established. Native Chrome then confirmed the new dated live-view card and expanded detail unobscured. Read-only storage verifies three Ring live views, including `2026-09-30T14:54:33.078Z`, and zero matches. Owner asked to stop and save; take review remains pending. No repeat sync or Bedrock request was made.


Latest Around recording located on Desktop after owner reported it stopped unexpectedly: `Screen Recording 2026-09-30 at 11.04.18 AM.mov` (filename uses a narrow space before AM). Preserved identical private copy `data/recordings/private/around-fresh-sync-2026-09-30.mov`, SHA-256 `147dd453a70c3dc002b867f7282fe7d19a1b5a5fed3bcc28908801916ec3981a`. It decodes, duration 332.59 seconds, 2440 by 1568, one unreviewed audio track. Twelve sampled frames include initial masked credential controls and a native password prompt, then an unobscured “1 moments received and grouped” result with Ring source labeling. Tail remains on the success view; the new dated card was not found in these samples. Stop cause is unknown. The take is preserved, with usable result imagery identified, but it is not fully privacy-cleared or a completed edited walkthrough. No additional provider request or recording was started.


September 30 local edit recovered usable evidence: retained Playground source30–36s visibly plays the bird simulation, cropped below the identifier watermark and left of the trace. Around source60–65s shows the successful fresh-sync result. A separately captured saved-record still supplies the new dated card and is labeled as a still. v7 is an edited review, not an uninterrupted control-to-sync take. No repeat provider call was needed. Both approved videos remain byte-identical. All retained Ring seconds and cut boundaries were visually checked; sample audio payloads match. No claim of full raw-take privacy clearance is made.


September 30 editorial follow-up: owner found v7's three parts difficult to follow for a first-time viewer. The prior titles described actions before explaining the audience and purpose. Owner approved judge-oriented sections and the simpler “Did the plumber come?” sample explanation. v8 uses three numbered purpose cards and opening orientation. Existing raw takes, approved videos and v7 are preserved. This is a presentation revision, with no new provider execution or changed evidence claims.

September 30 presentation cleanup: owner identified editorial notes that distracted from the judge-facing story, a nonworking extra play button, repeated evidence caveats and a three-record caption beside one displayed record. v9 uses the established Around logo and requested tagline, changes the opening to “expected activities,” labels the displayed new Ring record, removes redundant notes and shortens the footage modification credit to “Cropped excerpt.” The local review page displays “83 seconds.” and uses native video controls. Detailed capture provenance stays in the submission documents and media manifest. No feature or provider execution changed.

September 30 pacing feedback: owner found the Motion control page and all section 2 cards too brief for first-time reading. v10 adds 22 seconds across these holds, with the detailed saved record receiving 14 seconds. Review-page duration changed from 83 to 105 seconds. Existing sample speed, audio and source boundaries are preserved.

September 30 sequence feedback: owner requested leading with the product demo, then integration evidence, to show homeowner value earlier. v11 puts the labeled sample after the opening and sample explanation, renumbers the later sections, and adds seven seconds across the Playground introduction, control and playback pages. Existing source crops and evidence boundaries remain intact. No provider calls or application changes.
