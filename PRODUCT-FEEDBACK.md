# Product feedback

Based on Around development and observed runs from September 28–30, 2026. This is a small local prototype, not a reliability, performance or cost benchmark. Original dated observations are preserved in [the feedback history](docs/history/PRODUCT-FEEDBACK-pre-hardening-2026-09-30.md) and [friction chronology](docs/history/FRICTION-LOG-original-2026-09-30.md).

## Ring developer documentation and official Partner APIs

**Use.** Around calls official discovery and history APIs, validates provider IDs and timestamps, and stores normalized activity. Its signed webhook handler and configured two-device pipeline are implemented and contract-tested; they have not been validated through live webhook delivery or two real devices.

**Worked well.** JSON:API examples, explicit raw-body HMAC guidance, directed device IDs and pagination rules gave us a useful integration contract. The official sample clarified how a Next.js app could use Playground credentials. Actual Around calls retrieved one device and three live-view records across the observed runs.

**Onboarding and documentation.** Public documentation did not initially expose an obvious simulator-first path. We located the authenticated Playground after owner sign-in. History examples left uncertainty about classified human/vehicle representation, so the adapter preserves generic motion and uses documented subtype filters in configured mode. Those classification paths remain mocked in tests.

**Needs work and testing experience.** We need complete classified-history examples and a linked simulator quickstart. A failed Around sync initially surfaced as a generic error. Later fresh-token/server runs succeeded; the original cause is unresolved and cannot be attributed to Ring. Safe local diagnostics now distinguish discovery, history, validation and storage failures.

**Would use again.** Yes for authorized device/activity metadata. We would validate real classified-event behavior before relying on the multi-device workflow. Suggested changes are FR-1 and FR-2 in the [feature requests](FEATURE-REQUESTS.md).

## Ring Developer Playground

**Use.** Hardware-free token setup, device/history exploration and official simulator playback, followed by Around's own API ingestion.

**Worked well.** The Playground provided a temporary token and one test device without app registration. The UI stated a 30-minute token lifetime. September 30 recording shows media playback working, and Around received a new live-view history record.

**Onboarding, documentation and limitations.** The Motion and Vehicle controls selected live-view media. Observed history returned `on_demand`, not classified motion. One simulated device cannot stand in for distinct driveway/front-door devices. The positive visit therefore remains a separately labeled sample. This is a coverage limitation, not a claim that the API fabricated detections.

**Needs work.** September 28 WHEP requests returned HTTP 201 while the player showed “Unable to play media.” Later playback success does not explain that first failure. Separate the video controls from event generation, offer typed scenarios across multiple device IDs, and give safe player diagnostics. Surface token scope before generation.

**Would use again.** Yes for API exploration and the observed ingestion path. It did not validate the richer classified-visit workflow. No broad uptime or latency claim follows from these few sessions.

## Amazon Bedrock, Amazon Nova Micro and AWS SDK for JavaScript v3

**Use and AWS Builder role.** Around uses Amazon Bedrock Converse with Nova Micro in `us-east-1` through `@aws-sdk/client-bedrock-runtime`. It parses Tell Around sentences, interprets freeform Ask questions and selects complete evidence facts for answers. Explicit Ask briefing shortcuts route locally and use one fact-selection request. The Home briefing makes no model call. No AgentCore, Strands, SageMaker, S3 or AWS hosting is used.

**Worked well.** The SDK supported bearer authentication without installing an AWS CLI. Actual app-side checks parsed the original plumber sentence into the correct same-day window. A dated answer referenced real Ring live-view activity and declined to confirm a visitor. A separate four-call sample run completed parsing, a qualified positive answer and the daily briefing.

**Onboarding from zero to first result.** New-account verification initially blocked inference. A later console call succeeded while app-side short-term-key requests still returned HTTP 403. A separately approved, narrowly scoped IAM identity and one-day Bedrock key then enabled app-side parsing. That recovery proves the alternate credential worked at the time, not the cause of the earlier rejection or current key validity.

**Documentation and needed improvements.** Official documentation explained key lifetimes and IAM backing. The default LimitedAccess policy was broader than this single-model prototype needed. A minimal regional/model policy and SDK example would help. Show verification state before a model test, and distinguish account, model and bearer-permission failures in actionable diagnostics.

**Testing and reliability observations.** One response misread “Anything I should know?” as a visit question. The answer stayed grounded but did not serve the requested intent. Deterministic routing for the explicit shortcuts fixed the observed case; a subsequent actual Bedrock briefing passed. Model selections are validated and unknown IDs are rejected. A visit answer currently contains one mandatory whole fact; this is constrained selection rather than open-ended generation.

**Would use again.** Yes for bounded structured language tasks with application validation. These observations do not establish broad model accuracy, latency, cost or production reliability. Safe-error and authentication behavior are also tested with mocked transport, clearly separate from provider execution.

## AWS IAM and temporary credentials

**Use.** IAM supported development-time authorization for the dedicated Bedrock demo identity. The app itself does not create IAM resources. A one-day key was used through SDK bearer authentication; no general AWS access keys or console password were needed by Around.

**Worked well.** Narrow model/region permissions supported the tested app flow. The owner's direct entry into temporary local password fields avoided application credential storage.

**Onboarding and friction.** One-time retrieval and browser coordination complicated safe transfer. A credential appeared in an automation output during setup; the exposed/uncaptured keys were subsequently deleted with explicit owner approval before replacement. That was our handling failure, not a demonstrated AWS defect. We stopped raw dialog inspection and used owner-only retrieval. Details without secret values remain in the original log.

**Would use again.** Yes with limited lifetime and least privilege. Better single-model examples would reduce the temptation to accept broad defaults. Expiry and revocation still require deliberate owner management.

## Application framework and supporting tools

These tools also contributed to the finished project. Feedback is grouped where the experience was shared; no independent benchmark is claimed.

| Tool or library | Use and what worked | Onboarding, testing or limitation | Would use again and improvement |
| --- | --- | --- | --- |
| Next.js, React | One application for local UI and server routes; production build and browser flow work | Next normalized a local request URL differently from the Host header; our first origin check rejected valid requests | Yes; document canonicalized URL behavior alongside local origin examples. Our app check was repaired without allowing foreign origins |
| TypeScript, Tailwind CSS | Typed domain objects and consistent responsive styling | Installed versions and lockfile provided repeatable setup; no separate tool-specific failure established | Yes; retain pinned versions and desktop/mobile review |
| Node.js, SQLite | Local persistence without a separate service or native database addon; transactions and uniqueness make replay safe | SQLite remains experimental in Node 24.12.0. First tests exposed two application SQL placeholder errors, then passed after explicit-column fixes | Yes for this prototype; document Node requirements and use explicit insert columns |
| Zod | Validates request, provider and model output | Unknown or malformed data is rejected; no independent Zod defect observed | Yes; keep schemas adjacent to boundaries and retain negative tests |
| date-fns-tz and Intl | Convert local expectation windows and format stored timestamps | Date/DST-gap tests provide relevant coverage; no library-specific failure observed | Yes; keep timezone explicit and bound to the database |
| Lucide/Feather | Interface icons and the Radio geometry in the Around mark | Adequate for the compact UI; notices preserved in `LICENSES/lucide-react.txt` | Yes; preserve attribution and avoid implying an original icon geometry |
| Node test runner and tsx | Fast TypeScript unit/contract tests | tsx CLI IPC was sandbox-blocked; `node --import tsx --test` ran the same tests | Yes; expose a no-IPC invocation in restricted-environment guidance |
| Playwright and Chromium | Production browser flow, mobile overflow, persistence and key-lifecycle checks | Missing browser revision and local-server permission failures occurred before assertions; matching installation and approved host execution resolved them | Yes; document browser revision and localhost permissions separately from test failures |
| ESLint and Next ESLint config | Static checks without disabled rules | An effect-state warning was resolved with an asynchronous callback; upstream ESLint support warning was observed during setup | Yes; follow compatible versions, retain lint as a check rather than suppressing it |
| npm and Git | Dependency lockfile, source history and reproducible repository | Sandbox registry/cache access and an incompatible `/usr/local/bin/git` were local environment issues; system Git worked | Yes; report environment permission errors clearly and use the host-compatible binary |
| Codex/browser automation | Implementation, bounded review, tests and documentation; owner-directed screen capture | Wrong browser/capture surface and credential-dialog inspection caused avoidable coordination failures | Yes with source labels, visible capture preflight and private owner credential entry; do not treat automation success as video evidence |
| macOS AVFoundation, AppKit, AVFAudio, QuickTime/Screenshot | Local composition, recording review, narration/audio work and approved video assembly | Decoder permissions, drawing across an async suspension, timeline gaps and mixed video configurations caused tooling failures | Yes for local media work; close writers before reading, inspect decoded frames and verify continuous playback |

No performance benchmark or customer study was performed. Provider feedback stays separate from application defects, operating-system restrictions and recording mistakes.
