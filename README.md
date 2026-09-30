# Around

Spatial intelligence for your home.

Around helps you stay on top of what is happening around your home. Tell Around what you are expecting, then ask simple questions about what happened.

## Run locally

Requires Node.js 24 or newer. Tested with Node 24.12.0. One Next.js application with React, TypeScript, Tailwind and SQLite through Node's built-in `node:sqlite`. No database service or account system. Node currently prints an experimental SQLite warning.

```sh
npm ci
npm run dev
```

Open [Around](http://127.0.0.1:3000). Both modes default to explicit local fixtures; the sample demo requires no cloud credentials. For the production build, run `npm run build`, then `npm start`.

## Two-part hackathon demo

Current preparation status and verified evidence are in [submission readiness](docs/SUBMISSION-READINESS.md). Judges can follow the [credential-free sample guide](docs/JUDGE-GUIDE.md). The approved sample master is preserved; the real Ring ingestion recording remains a separate capture item.

The submission path is a real Ring Playground/Bedrock demonstration followed by a clearly labeled sample visit. Physical hardware is not required by the [official FAQ](https://amazonappdev2026.devpost.com/details/faqs). An organizer reply is optional, not a stated prerequisite. This does not turn sample events into provider evidence or guarantee an eligibility decision.

After `npm run build`, keep the configured Ring instance on port 3000 and run `npm run demo:sample` in another terminal. Open [Sample activity](http://127.0.0.1:3001). The launcher uses a fresh isolated database on each start and explicitly selects sample activity plus local demo answers, regardless of existing Ring/Bedrock environment settings. It preserves earlier databases and makes no cloud calls. Both tabs show their data source and language mode near the top.

`npm run demo:sample:bedrock` uses Bedrock with sample activity and a separate page-memory key. This incurs provider requests and is not needed for local rehearsal. The full positive sample story was verified with actual Bedrock on September 29: expectation parsing, qualified visit answer and briefing succeeded in four calls. A 29.3-second narrated review clip with main narration captions, including an animated logo opener and reverse ending, now shows saved results and source labels; it does not show the original requests or real Ring ingestion. Approved sample demo: `data/recordings/around-demo-ring-sparkle.mp4`, with an edited typing sequence and decorative microphone; voice input is not implemented. See the runbook for the recording paths and remaining footage.

See [the demo runbook](docs/DEMO-RUNBOOK.md) and [submission script](SUBMISSION-COPY.md).

## The sample visit

1. Open **Tell Around** and enter `The plumber is coming today between 10 and 1.`
2. Save. The card shows today's date and the 10:00 to 13:00 window in `America/New_York`.
3. Click **Play sample visit**. Four sample events at 10:41, 10:43, 11:25 and 11:27 become one probable visit.
4. Look for **Likely matches your plumber visit**.
5. Ask **Did the plumber come?** The answer gives estimated bounds and says identity is unconfirmed.
6. Ask **Anything I should know?** for today's stored activity and expectations.

Reloading preserves records. Replaying the same day's sample is idempotent. Add the expectation once; two similar expectations correctly make the match ambiguous. Sample playback is accelerated, so timestamps can be later than the current clock. It is labeled sample data, not live activity.

For a fresh rehearsal, stop the server and select a new `AROUND_DB_PATH` in `.env.local`, such as `data/rehearsal-2.sqlite`. Existing databases are preserved. Never commit database files or credentials.

## Ring integration

`src/lib/ring/api.ts` implements the official API adapter; `src/lib/ring/fixture.ts` supplies the local development adapter. Both normalize to `RingEvent` and use the same storage and grouping path.

| Research question | Verified contract or limit |
| --- | --- |
| Device information | `GET /v1/devices` returns directed IDs and names. Related endpoints expose status, capabilities and coarse location. |
| Event history | `GET /v1/history/devices/{id}/events`, with event filters and `links.next` pagination. History is consent-gated. |
| Event types | Motion with human/vehicle/animal subtypes, doorbell presses, and live views. Around displays live-view requests separately and excludes them from visit matching. Unsupported types are ignored. |
| Notifications | Signed HTTPS webhooks provide motion, doorbell and lifecycle events. Motion classification is in `attributes.sub_type`; timestamps are epoch milliseconds. |
| Multiple devices | Two independently discovered directed IDs represent driveway and front door at one home. Camera modules are not separate devices. |
| Simulator observations | The inspected official Playground session supplied one device and live-view history. The tested controls did not produce the classified multi-device visit events used by our sample scenario. |

Sources inspected 2026-09-28: [API reference](https://developer.amazon.com/docs/ring/api-documentation.html), [development guide](https://developer.amazon.com/docs/ring/develop.html), [getting started](https://developer.amazon.com/docs/ring/get-started.html), [official sample](https://github.com/AmazonAppDev/ring-api-helloworld). Documentation gaps are in `FRICTION-LOG.md`.

### Playground setup, no physical devices

Run with a separate database and explicit Playground configuration:

```sh
RING_MODE=ring RING_DEVICE_MODE=playground AI_MODE=fixture AROUND_DB_PATH=data/around-ring-playground.sqlite npm run dev
```

Open the [official Playground](https://developer.amazon.com/ring/console/playground), generate a temporary token, and use its Vehicle or Motion live-view control. Those controls produce `on_demand` history, not classified detections. Paste the token into Around's **Temporary Ring access token** field and click **Sync Ring activity**. The form clears immediately. Around uses it only during that request, never saves it, and does not return it to the browser. Do not put tokens into chat, screenshots, or recordings. Blank input uses an optional server-configured `RING_ACCESS_TOKEN`.

Playground mode requires exactly one discovered device. It uses the device's real directed ID, an unspecified physical zone, and the location label Ring Playground. It retrieves unfiltered history through the official API. A live-view request becomes **Live view requested**, with its timestamp and a clear statement that it proves neither motion nor a visitor nor successful playback. Ask **What did Ring record?** or **Anything I should know?** to summarize stored records. Add the plumber expectation and ask **Did the plumber come?** to see a grounded insufficient-evidence answer.

This setup uses local demo language unless `AI_MODE=bedrock` is explicitly configured. It is not Bedrock verification. The four-event plumber story remains in fixture mode and its separate database. Database metadata rejects switching between configured and Playground Ring sources under one path. A live view is never grouped into, or used to bridge, detection-based visits.

### Official API setup

Copy `.env.example` to `.env.local` and set:

```dotenv
RING_MODE=ring
RING_DEVICE_MODE=configured
AROUND_DB_PATH=data/around-ring.sqlite
RING_ACCESS_TOKEN=<authorized AVA access token>
RING_DRIVEWAY_DEVICE_ID=<directed driveway device ID>
RING_FRONT_DOOR_DEVICE_ID=<directed front-door device ID>
RING_ACCOUNT_ID=<authorized account ID>
RING_HMAC_KEY=<partner HMAC signing key>
```

Obtain credentials through official Ring onboarding and authorized account linking. Around accepts an existing token for this single-home MVP; it does not implement account linking or token refresh. Restart after configuration changes. **Sync Ring activity** calls discovery and history. Missing setup, expired tokens, malformed responses and pagination limits fail visibly without switching to fixtures. Only the two configured devices are ingested. Both must belong to the same home, an explicit setup assumption.

Generic history is supplemented by dedicated subtype filters because the reference examples do not demonstrate classified responses. Pagination stays on the official origin and is capped at 20 pages per query. Failed syncs save no partial data. No video, image or custom vision processing is used.

`POST /api/ring/webhook` verifies HMAC-SHA256 on the raw body, account binding, payload structure, configured devices and deduplication. It makes no model or network call. For webhook testing, configure an HTTPS ingress forwarding **only this route** to the local app. No ingress is provisioned here. Refresh to see new webhook activity. Lifecycle notifications are acknowledged and excluded from activities; lifecycle automation is outside this local demo.

The configured two-device adapter and webhook path are contract-tested with mocked transport; their live classified-event behavior remains unverified. The separate Playground path has successfully called official discovery/history and stored real live-view records. The demo shows that real integration alongside, and distinctly from, the sample visit.

## Amazon Bedrock

Configure the non-secret settings in `.env.local`:

```dotenv
AI_MODE=bedrock
AWS_REGION=us-east-1
BEDROCK_MODEL_ID=<Converse-compatible model or inference profile available to your account>
# AWS_PROFILE=around
```

For a temporary local demo, paste an approved temporary Bedrock API key into the password field shown when Bedrock mode is enabled. It stays in page memory across Tell/Ask requests until Clear or reload. Around sends it to SDK bearer authentication, never model input, SQLite or a credential file. Decline any browser password-save prompt. Alternatively, leave it blank to use an existing AWS SDK credential-chain identity. See [Bedrock API keys](https://docs.aws.amazon.com/bedrock/latest/userguide/api-keys.html).

The identity needs `bedrock:InvokeModel` permission and access to the chosen model. Model selection stays explicit. Inference requests can incur AWS charges. The application does not create IAM or AWS resources. Our demo setup uses the separately approved, narrow IAM identity described in the latest progress record. See the [Converse JavaScript example](https://docs.aws.amazon.com/bedrock/latest/userguide/bedrock-runtime_example_bedrock-runtime_Hello_section.html) and [API permissions](https://docs.aws.amazon.com/bedrock/latest/APIReference/API_runtime_Converse.html).

`src/lib/ai.ts` uses `BedrockRuntimeClient` and `ConverseCommand` for expectation parsing, question interpretation, and constrained answer composition. The model selects complete evidence-backed facts by ID. Unknown IDs are rejected; only approved text is rendered, preserving uncertainty and preventing invented activity. Time calculations, grouping, matching and fact construction stay deterministic.

Bedrock receives the sentence, question, minimal expectation fields and selected facts. It receives no raw Ring payloads, credentials, video or images. Calls have one attempt, a 20-second timeout, a 12,000-character data limit and a 600-token output limit. Failures remain visible. The home briefing card is local. The two explicit briefing shortcuts route deterministically and use one Bedrock fact-selection call; other natural-language questions use interpretation and fact selection (two calls).

With `AI_MODE=fixture`, the exact demo sentence, the two original demo questions, and What did Ring record? are interpreted locally. This is a development aid, not Bedrock execution. Nova Micro parsing, a dated Ring-grounded answer and the corrected daily briefing are now verified from Around with a dedicated one-day Bedrock key. Around is configured for Bedrock. Keys are page-memory only, so a reload requires re-entry. See the latest checkpoint below.

## Visual palette

Primary: `#E17342` terracotta, with peach highlights, warm ivory surfaces, espresso text and deeper rust for text accents. The primary button uses dark text for a 5.05:1 contrast ratio. Theme tokens live at the top of `src/app/globals.css`.

## Data and matching

Tables: `RingDevice`, `RingEvent`, `Activity`, `ActivityEvent`, `Expectation`, `ExpectationMatch`, webhook receipts and mode/timezone metadata. Original payloads remain local. Metadata prevents source mixing or timezone changes underneath stored expectations.

Events group within one local day and home, with at most 60 minutes of silence and a three-hour span. A probable visit requires driveway vehicle and front-door person/doorbell evidence. Later driveway vehicle activity supports a possible end, not proof of departure. A visit beginning inside an expectation window can match. Several fitting visits or expectations stay ambiguous. Confidence scores are heuristic, not calibrated probabilities. Several real visits close together can still be incorrectly grouped, a known MVP limit.

User routes reject nonlocal hosts and foreign origins. Do not publish this unauthenticated app. Scope excludes recognition, delivery confirmation, alerts, home controls and the other features excluded in the initial brief.

## Verification

```sh
npm run check        # TypeScript, lint, targeted tests
npm run build        # production build
npx playwright install chromium  # only if Chromium is not already installed
npm run test:e2e     # production server, isolated temporary DB, port 3100
```

Observed September 30: TypeScript and lint pass, 31 targeted tests pass, production build passes. Three production browser scenarios cover: the original fixture visit through the actual sample launcher, the separate Playground contract scenario, and the temporary Bedrock key lifecycle. The Playground scenario covers live-view rendering, insufficient-evidence answers, token-field clearing on failure, and mobile layout using synthetic records. The exact desktop browser demo passes, including no-evidence answers, expectation saving, visit grouping/matching, both questions, reload persistence, idempotent replay, foreign-origin rejection and a 390px mobile overflow check. Desktop and mobile screenshots were visually inspected. Adapter tests use official-shaped synthetic payloads and mocked fetch. They do not prove live provider availability. New diagnostic tests check safe Ring failure categories, interrupted responses and rollback. Two September 30 syncs succeeded and added no duplicates. The earlier failure's cause remains unresolved. A later saved-result recording yielded a clear 19-second Ring review excerpt. Combined video assembly remains blocked by a failed render; see submission readiness.

## Hackathon records

- `FRICTION-LOG.md`: contemporaneous problems and workarounds.
- `PRODUCT-FEEDBACK.md`: observed experience and provider limits.
- `SUBMISSION-COPY.md`: source of Devpost wording and submission evidence.

The [overview](https://amazonappdev2026.devpost.com/), [resources](https://amazonappdev2026.devpost.com/resources), and [rules](https://amazonappdev2026.devpost.com/rules) require runtime Ring integration and a simulator/device demo. AWS Builder requires documented AWS use, including its role in product feedback. Runnable source, judge access and a public English video under three minutes are also required. No submission, licensing choice or publication has been made. The owner approved the dedicated, narrowly scoped IAM identity and one-day Bedrock key used for integration verification.

## Historical progress record

These dated checkpoints preserve the decisions and evidence at the time. The current demo/submission guidance above supersedes earlier claims that organizer confirmation was required or provider setup remained entirely blocked.

Lead owns all files. A separate read-only Progress Steward reviewed research and implementation transitions. Research was bounded to the official contract; missing simulator access was preserved. The target remained one expectation, four events, one visit, one likely match and a grounded answer. No broader feature work started.

The first executable test run passed 14/18 tests and exposed incorrect SQL placeholder counts in expectation/event inserts. Explicit column lists and corrected counts repaired the failures. The same tests now pass, with two added Ring cases. Initial UI lint findings were fixed without suppressions. The tsx CLI hit an IPC restriction; the same tests run through Node's TypeScript loader. These checks do not close provider gates.

First executable browser failure: a valid local POST returned 403 because Next normalized request.url differently from the browser Host. The origin check now compares against the validated local Host, with a regression test retaining foreign-origin, foreign-host and wrong-port rejection. The unchanged browser flow passed after repair. Final briefing-copy and fixed-sidebar adjustments also passed typecheck, lint, all 21 targeted tests, the production build and the complete browser flow.

Final steward checkpoint: local demo acceptance is satisfied. The provider-backed slice remains open until an official Ring simulator/device session and Amazon Bedrock inference run succeed. Next owner action is local provider configuration; no secret should be pasted into chat.

Provider setup resumed 2026-09-28. Outcome sought: one official Ring event stored by Around, then one Bedrock-backed version of the existing demo. Lead owns changes. Next observable result: establish portal/account access and identify the official test path, with a 15-minute discovery budget and no repeated unchanged attempts. Evidence will be provider responses or console state, with secrets excluded. A read-only Progress Steward checks the transition to provider testing or any external blocker.

Provider setup checkpoint: the official Ring console redirected to Amazon Developer Sign-In in Chrome. Owner must sign into the intended developer account before app/test controls can be inspected. No Ring or AWS credentials/configuration are present locally. Progress Steward recommends stopping at this login gate and avoiding ingress or further adapter work until an official event source is available. Bedrock also needs a selected AWS identity, region and model. No account or cloud-resource changes have been made.

Ring setup checkpoint: owner sign-in succeeded. The console shows the Praxais Studios workspace with no registered apps and an official Playground at https://developer.amazon.com/ring/console/playground. It describes a sandbox, temporary OAuth test tokens, API invocation and simulated live-view events, with instructions to use its token in a test app. Lead's next observable result is the available test device/event controls or the precise authorization boundary, within 10 minutes. No app creation or public ingress is needed before this feasibility check.

Playground gate: automatic approval review rejected Generate token before execution because specific credential-generation approval was missing. Owner approval has been requested for this temporary test token. Its exact scope/expiry is not shown on the initial page. Do not retry generation through another route while approval is pending.

2026-09-28 Playground runtime checkpoint: owner approved token generation; the token lasts 30 minutes. Device List succeeded with one device. Vehicle opened a WHEP session (HTTP 201), but playback failed and Event History reported on_demand. These are console observations, not successful Around ingestion or vehicle-motion evidence. Local token-file storage was separately rejected by automatic approval review, and no file was written. Progress Steward confirmed that a live-view event and a single device cannot satisfy the two-device visit demo. Lead will make one Motion/history check and stop if the same limitation remains.

Final Playground check: Motion likewise produced on_demand. Both stream dialogs were closed. No provider token was saved, no app configuration was changed, and no Ring activity was ingested into Around. The available Playground controls have not demonstrated the two-device typed-event source this demo needs. Owner device availability is the next decision; broader app/account linking is not yet authorized or implemented.

## Simulator-only setup decision, 2026-09-28

Owner confirmed no physical Ring devices are available. Hardware acquisition and real-account device linking are not the planned path. The [hackathon FAQ](https://amazonappdev2026.devpost.com/details/faqs) explicitly accepts Ring Developer Playground demonstrations. However, the [hackathon discussion response from Emerson Sklar](https://amazonappdev2026.devpost.com/forum_topics/45309-ring-playground-chime-sub_type-and-sensor-coverage-what-s-the-intended-path-for-non-us-entrants) explains that Playground controls simulate live-view sessions, not motion webhooks. This matches our observed on_demand history entries.

The original two-device provider-backed visit remains unverified and blocked by the available event source. Do not reinterpret live views as detections or map one synthetic device to two physical zones. A combined demonstration of actual Playground API execution plus a separately labeled fixture visit may be a practical proposal, but organizer acceptance has not been established and this does not satisfy the original integration acceptance yet.

Progress checkpoint: lead completed a bounded FAQ/discussion check and a read-only Progress Steward reviewed the conclusion. Stop further unchanged simulator attempts. Next observable result is organizer guidance on typed multi-device simulation or explicit acceptance of the proposed split demonstration. An unsent question is in FRICTION-LOG.md. Bedrock verification remains a separate task requiring selected AWS configuration. No application code or runtime defaults changed.

Implementation checkpoint: owner approved the genuine simulator-to-answer flow. Lead owns all code. Next observable result is tested on_demand ingestion, separate live-view activity, and answers that never turn it into a visit. Budget: 25 minutes for implementation and checks, then a read-only steward review before provider testing. The temporary token will be supplied per sync, held for that request only, and never saved by Around. Token file storage remains excluded. Fixture and Ring databases remain separate.

## Verified Playground execution, 2026-09-28

Around itself successfully called official device discovery and event history with the approved temporary token. One Playground Device and two on_demand records were ingested into the separate local Ring database. The UI showed two Live view requested cards at 2:54 PM and 2:56 PM Eastern. What did Ring record? summarized those records. After adding the plumber expectation, Did the plumber come? returned insufficient evidence, citing the latest live-view request without claiming a visitor. SQLite readback confirmed two source=ring live_view events, two live_view activities, zero matches, and an expected plumber status.

The token was supplied only in the local sync request. Chrome offered to save it; that prompt was declined. Around saved no token. Local .env.local contains only source/AI mode, timezone and database path. AI_MODE remains fixture, so these answers do not prove Bedrock execution. No classified motion, two-device visit, or organizer acceptance is claimed. The four-event fixture demo remains a separate test and rehearsal.

Final checkpoint: all 24 targeted tests, TypeScript, lint, production build, and both browser scenarios pass. Contract screenshots were inspected at desktop and 390px mobile widths. Actual Ring records survived the final server restart, verified through the state API. The visible Chrome reload and organizer discussion were blocked when the Mac locked; the clarification remains unsent. Around is running at http://127.0.0.1:3000 in Playground mode with local demo language. Next external dependency is AWS account/model setup for Bedrock.

Bedrock setup checkpoint: lead owns setup and code. No AWS environment credentials, shared profile/config files or selected model were found (presence-only check). AWS CLI is not installed. Owner account selection requested. Next observable result: signed-in AWS account and an available Converse model, within a 10-minute setup check. No IAM resources, model subscriptions or billable inference calls are authorized by an inferred account choice. Prepare a bounded test and resolve the specific account/access/cost boundary before execution. Browser is available again; Ring data remains unchanged.

Bedrock handoff: official console is open in Chrome at AWS IAM sign-in. Owner must select/sign into the intended AWS account. No AWS request or credential creation occurred. Short-term Bedrock API keys and Nova Micro in us-east-1 are documented candidates, not yet selected account configuration. Ring remains runnable with local demo language.

Bedrock access checkpoint: owner signed into a new AWS free account. Lead will inspect the signed-in Bedrock model/API-key pages before changing credentials or invoking models. Next evidence: available model and account-plan limits, with a 10-minute inspection budget. Keep Around's verified Ring data and local language mode unchanged until the Bedrock test is ready.

Bedrock preparation checkpoint: lead owns code; next result is a checked, memory-only temporary-key path for Tell and Ask. Budget: 15 minutes plus normal build time. The key goes only to the SDK bearer-auth configuration, never to model prompts or SQLite. Local checks use synthetic keys and mocked responses. Provider execution remains gated on the short-term credential and model-terms decision; no account upgrade is planned.

Bedrock preparation result: TypeScript, lint, 25 targeted tests, production build and all three browser scenarios pass. A synthetic-key test exercised actual SDK serialization and bearer-auth middleware with an intercepted transport, confirming the Authorization header and absence of the key from the Converse body. Browser tests confirm Tell/Ask forwarding, manual clear, reload clearing and no browser-storage persistence. No AWS network request was made by these tests. Progress Steward reviewed the boundary and recommended expectation parsing as the first live call. Nova Micro terms and short-term credential generation await owner approval. The proposed test allowance is at most eight small calls with a $0.10 authorized budget, not an AWS-enforced cap. Stop on the first provider failure for diagnosis; do not upgrade the account.

Live Bedrock checkpoint: owner approved short-term key generation, model terms and up to eight tiny Nova Micro requests within a $0.10 authorized budget. Lead owns execution. Next result is one parsed demo expectation from actual Bedrock, with a 10-minute first-call budget. The browser key extraction did not recognize the generated key format before its dialog closed; no inference was attempted and no credential was saved. One fresh generation will use the displayed field structure instead of assuming a prefix.


## Bedrock account-verification blocker, 2026-09-28

Three authorized requests were attempted: two Around expectation-parsing calls and one tiny diagnostic call in the AWS console, all with Nova Micro in us-east-1. All were denied; zero successful model executions. The console states the account is currently being verified, normally taking less than two hours, and directs users still blocked after that time to aws-verification@amazon.com. This is provider guidance, not a guaranteed completion time or evidence that an upgrade is needed.

Lead stopped inference. The temporary key was cleared from Around and agent memory; issued keys were not revoked and expire with their sessions. No credentials were written to disk. AI_MODE was explicitly restored to fixture to keep the labeled local demo usable. Ring Playground data and non-secret region/model settings are preserved. No email was sent, no account upgrade or IAM change made, and no retry scheduled. Three of eight authorized attempts have been used. Next result, after account verification changes: one successful Around parsing request, followed by the grounded-question demo within the remaining allowance.

Safe error diagnostics now distinguish allowlisted AWS error codes/status, timeout and invalid model JSON without exposing provider messages or credentials. TypeScript, lint, all 26 tests and the production build pass. The three browser scenarios passed before the isolated error-diagnostic change. Progress Steward reviewed the final evidence and recommended stopping at this external dependency.

Retry checkpoint, 2026-09-29: owner requested another attempt after the overnight wait. Lead owns setup and evidence. Next observable result is one actual Nova Micro expectation parse, within a 10-minute access check and the five remaining approved requests. Renew only the same temporary memory-only credential access if needed. Stop if account verification is still pending; no upgrade, expanded permissions or automatic retries.


## Bedrock retry outcome, 2026-09-29

After owner sign-in and equivalent temporary-key renewal, Around's parse request was denied (attempt 4). The same model/region returned a successful response in the AWS console (attempt 5). One safe instrumented app retry was also denied (attempt 6). This supersedes the claim that account verification is still blocking all model use. Actual evidence: one successful console inference, zero successful Around Bedrock calls, five denied attempts overall. No further inference attempts were made.

The denied request's exact cause remains unknown. The key showed no whitespace, truncation, quote wrapper or duplicate Bearer prefix. Safe diagnostics gained fixed reason labels, with no raw provider message disclosure. TypeScript, lint, all 27 tests and production build pass. The temporary key was cleared from page and agent memory, not revoked. Local language mode was restored explicitly, with Ring records preserved.

Next proposed step, not executed: create a dedicated IAM user named around-bedrock-demo, no console password or general AWS access keys, attach the narrow policy in docs/bedrock-demo-policy.json, and issue a Bedrock-specific key expiring in one day. The key would remain memory-only. This is an alternative authentication test, not a proven fix. It requires owner approval before creating the identity/key. Do not use the broad default AmazonBedrockLimitedAccess policy. Proposed test allowance: five additional small calls within the same total $0.10 budget. No account upgrade is proposed.

Dedicated-key checkpoint, 2026-09-29: owner approved the narrow IAM identity, one-day Bedrock key and five new test calls, eleven total, within the original $0.10 budget. Lead owns setup and documentation. Next observable result: permissions readback and one successful Around parse, within a 15-minute setup budget plus provider response time. No broad managed policy, console password, general AWS access key, paid-plan upgrade or secret-file storage is authorized. Stop on the first new access denial. Read-only Progress Steward reviews the identity-to-runtime transition.

Dedicated IAM setup evidence: around-bedrock-demo was created with no console password and no inherited policies. AroundNovaMicroDemo inline policy was attached; console JSON readback confirms CallWithBearerToken scoped to us-east-1 and InvokeModel on arn:aws:bedrock:us-east-1::foundation-model/amazon.nova-micro-v1:0. The IAM user API-key dialog supports Amazon Bedrock with a one-day expiry, selected before generation. No broad managed policy was attached.


## Verified app-side Bedrock execution, 2026-09-29

Owner-approved IAM user around-bedrock-demo has only inline policy AroundNovaMicroDemo, no console password, no general AWS access keys, and one Bedrock-specific key expiring September 30 at 10:39 AM America/New_York. Permissions readback after generation still showed only the approved policy. No credentials were saved to disk or browser storage.

Actual Nova Micro results through Around: the original plumber sentence parsed and persisted for Sep29 10:00–13:00; Did the plumber come yesterday? selected the Sep28 expectation and cited the real Ring live-view request at 2:56 PM, with insufficient evidence to confirm a visit. SQLite readback confirms both dated expectations, two original live views and zero matches. This validates parsing, natural-language intent and constrained grounded answer composition through the app. It does not validate classified motion, visitor identity or a provider-backed positive visit match.

The briefing test used calls 10–11 and returned a grounded visit answer instead of a briefing. That failure is preserved in FRICTION-LOG. Explicit briefing commands now route deterministically and make exactly one Bedrock fact-selection call. TypeScript, lint, all 28 tests, production build and all 3 browser scenarios pass. The corrected briefing needs one additional live call, beyond the exhausted eleven-call approval. No more requests will be sent without that extension. The one-day key remains only in page memory for the pending check; the IAM user persists after key expiry.


## Final Bedrock briefing verification, 2026-09-29

Owner approved call 12, one additional Converse request. The corrected Anything I should know? shortcut succeeded through Around. It reported no activity stored today, the plumber expected between 10:00 and 13:00, and no matching probable visit. It preserved the absence-of-evidence qualification and did not move Sep28 Ring events into Sep29. The UI displayed Amazon Bedrock and one saved expectation as evidence.

All three Bedrock roles have actual app-side execution evidence: expectation parsing, interpretation of a dated freeform question, and grounded answer/briefing composition. Twelve provider calls were attempted overall: five access denials, one console success, six app-side responses. One earlier app briefing response had incorrect intent; its corrected replacement now passes. No further requests were sent. Final code verification remains TypeScript, lint, 28 targeted tests, production build and three browser scenarios, all passing before this no-code provider check.

Around remains running with AI_MODE=bedrock. The approved key is held in the current page only and expires September 30 at 10:39 AM Eastern; reloading clears page memory. The IAM user remains for future demos. Actual Ring evidence is still limited to the two stored Playground live views. The positive, two-device plumber visit is a labeled fixture demonstration; organizer acceptance of the combined submission remains unconfirmed. No publishing, outreach, account upgrade or submission occurred.

Submission-preparation checkpoint, 2026-09-29: owner approved proceeding with the transparent two-part MVP demo. Organizer confirmation is optional, not a stated prerequisite. Lead owns files. Next observable result: a clearly labeled sample launcher with isolated data, current submission copy, and a rehearsable under-three-minute script. Budget: 25 minutes including normal build/browser checks. No cloud inference beyond the exhausted twelve-call allowance, credential generation, outreach, publication or submission in this step. A read-only Progress Steward reviews the evidence before handoff.

Submission-preparation result: the isolated sample launcher, visible event-source/language labels, current submission draft and 2:45 recording script are ready. TypeScript, lint, all 28 targeted tests, production build and all three browser scenarios pass. The browser suite executes the actual sample launcher with inherited Ring/Bedrock settings and confirms that it selects sample activity and local language. Desktop and 390px mobile screenshots were inspected. A fresh rehearsal is running on port 3001; real Ring records remain separate. No additional provider requests were used. Video recording, repository publication and Devpost submission remain undone.

Recording checkpoint, 2026-09-29: owner requested proceeding with rehearsal and recording. Lead owns local recording artifacts and narration. Next observable result is a playable sample-segment rehearsal and a timed narration draft, within ten minutes. Use an isolated sample database, preserve source labels, and make no new provider requests under the exhausted test allowance. A read-only Steward will review the source claims and remaining recording dependency before handoff. Upload and final submission are outside this local recording step.

Recording result: a 54.8-second silent sample rehearsal is saved under data/recordings, with approximate scene timings. The complete sample UI flow passed its recording assertions. Browser video decoding and five representative frames were checked. SUBMISSION-COPY includes a read-aloud narration draft. The real-provider segment, voice track, final captions and upload remain unrecorded or undone. No new provider calls were made; see docs/DEMO-RUNBOOK.md for the proposed bounded recording pass.

Provider recording checkpoint, 2026-09-29: owner approved one temporary Ring token refresh, equivalent renewal of the same limited Bedrock credential if needed, and up to six additional Converse calls, eighteen total, within an additional $0.10 authorized spend. Existing IAM permissions remain unchanged. Lead owns provider recording and evidence. Next observable result: actual Ring sync and dated grounded answer captured, then a separately labeled sample visit using Bedrock. Budget: twenty minutes for access and first recording; stop on access failure. Secrets remain memory-only and off camera. No upload or publication. Read-only Steward at access-to-recording transition.

Provider recording stopped during credential setup: the original Bedrock key appeared in browser tool output, and an equivalent replacement key could not be retained before its one-time dialog closed. Two demo keys now exist under the unchanged IAM identity. A synthetic password-field transfer failed without any provider request. Lead accepted Steward's recommendation to stop reuse and prepare scoped cleanup. See docs/CREDENTIAL-RECOVERY.md. Zero of the six additional calls were used; no new provider footage was captured. Owner approval is needed before deleting these two keys and handing off replacement-key entry.

Credential cleanup result: owner approved removal, and AWS now confirms both old demo keys are deleted. The single inline IAM policy and exact regional/model limits were read back unchanged. Replacement setup is prepared for Amazon Bedrock with a one-day expiry. Owner will click Generate and copy directly into the prepared Ring and sample pages, with recording off; replacement creation remains pending owner confirmation. This avoids inspecting the one-time secret through tools. All six additional recording calls remain unused.

Results-clip editing checkpoint: owner supplied the Desktop location for the corrected take. Lead owns the local media edit; original stays untouched. Next observable result is a short silent clip showing only saved sample/Bedrock results, excluding pauses and credential controls. Budget: ten minutes including frame review and exported-file verification. No new provider calls, upload or publication. Runtime count remains sixteen total, two approved calls unused.

Results-clip outcome: exported and verified data/recordings/around-bedrock-results-cut.mp4, 38 seconds at 952 by 886, with no audio track. Eleven representative frames including the edit boundary were inspected. The clip preserves source labels and shows saved briefing/evidence and the matched cards. Original Desktop recording is unchanged. Credential-controls footage and long pauses are excluded. No new cloud calls; real Ring footage and final assembly remain unfinished.
