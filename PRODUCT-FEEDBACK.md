# Product feedback

Current assessment through 2026-09-30. Actual Ring ingestion and all three Bedrock language roles have been exercised in Around. The complete classified plumber visit uses clearly labeled sample events. Dated onboarding checkpoints below preserve earlier failures and decisions; they are not current blockers.

September 30 follow-up: the previous recorded Ring sync returned an unclassified application error and preserved the existing records. Its cause is unresolved. Safe diagnostic categories are now locally verified, with 31 tests and three browser scenarios passing. One fresh-token diagnostic sync and one recorded sync through the restarted app succeeded and reported no duplicate moments added. Both token and server state changed, so this recovery does not identify the original cause or establish a Ring service defect. The two original live-view records remain distinct from sample visit evidence.

## Ring developer documentation and Partner API

- Used for: device discovery, historical event ingestion, signed motion/doorbell notifications, and mapping two devices to a probable home visit.
- Worked well: public JSON:API examples, explicit raw-body HMAC instructions, opaque device IDs, and documented history pagination. The official sample makes a Next.js integration approachable.
- Unclear: where to launch the official simulator and create multiple virtual devices; how classified history events appear in responses. General onboarding asks for hardware while hackathon instructions permit simulation.
- Onboarding: official Playground credentials worked from Around's adapter. One device and two on_demand history records were stored and shown in grounded answers. Classified multi-device visit behavior is covered with samples and contract tests.
- Documentation quality: detailed endpoint reference, but the simulator-first path was not discoverable through the inspected links. The development overview describes fewer notifications than the full reference.
- Friction: Playground video controls produced live-view history rather than classified detections, and video playback failed despite successful session creation. Device discovery and history ingestion succeeded. Details were recorded contemporaneously in FRICTION-LOG.md.
- Suggested improvements: link a simulator quickstart from hackathon resources; include two-device event playback and exact human/vehicle history examples.
- Would use again: yes for device and activity metadata. The available Playground is useful for API verification, but did not exercise the classified multi-device workflow. The FAQ permits hardware-free Playground demos; organizer clarification is optional, and the sample visit remains disclosed.

## Amazon Bedrock and AWS SDK for JavaScript v3

- Used for: actual expectation parsing, natural-language question interpretation and constrained answer composition using Converse with Nova Micro in us-east-1.
- Worked well: the dedicated, narrowly scoped IAM user's one-day Bedrock key works from the existing SDK. The plumber expectation was parsed and saved correctly, and a dated answer selected yesterday's expectation and cited its actual Ring live-view record without claiming a visitor.
- Unclear: the earlier root-session short-term key returned 403 even after console invocation worked. Its exact rejection cause remains unknown.
- Onboarding: new-account verification initially blocked inference. A dedicated IAM user with only bearer authentication and Nova Micro invocation recovered app access. No general AWS access keys or console password were needed.
- Documentation quality: official key docs distinguish key lifetimes and underlying IAM users. The default LimitedAccess policy includes more actions than this MVP needs; a small exact-model example would help.
- Friction: the model misclassified Anything I should know? as a visit question. The response remained grounded but failed the briefing intent. Explicit UI commands now route deterministically; the corrected daily briefing subsequently passed its live recheck.
- Suggested improvements: surface verification state before testing, make access-denial reasons actionable, and provide least-privilege local-demo credential examples.
- Would use again: yes for bounded structured tasks with validation and deterministic treatment of explicit commands. This small run does not establish broad reliability, measured cost or latency benchmarks.

September 29 positive-sample follow-up: with the replacement credential entered directly by the owner, the original plumber sentence, positive visit answer and explicit briefing all succeeded through Bedrock in four calls. The answer preserved the 10:41 AM and 11:27 AM estimates and uncertainty about identity. These inputs were visibly labeled sample activity. This extends the earlier real-Ring insufficient-evidence verification; it does not establish classified Ring detections.

## Next.js, React, TypeScript and Tailwind CSS

- Used for: one local application with server routes and responsive Home, Tell Around, Activity and Ask Around interactions. No UI framework beyond Tailwind and Lucide icons was necessary.
- Worked well: a single codebase covers UI and ingestion. Type generation, lint and production compilation are quick. Local system fonts avoid build-time font downloads.
- Unclear: the lint rule for state updates in effects initially flagged a helper with an awaited request. An explicit asynchronous request callback resolved it without disabling the rule.
- Onboarding/documentation quality: straightforward setup; exact installed versions and lockfile are pinned.
- Friction: local npm sandbox network/cache restrictions required approved execution. ESLint 9 emitted an upstream support warning; the installed Next.js lint preset and project lint pass. No critical audit findings were reported by npm.
- Suggested improvement: make safe restricted-environment setup and version compatibility more visible in starter templates.
- Would use again: yes for a compact local demo.

## Node SQLite, Zod, date-fns-tz and Lucide

- Used for: local persistence, structured input validation, timezone conversion, and UI icons respectively.
- Worked well: Node SQLite avoids another native addon or database service; transactions and uniqueness rules make replay safe. Zod rejects malformed provider output. Timezone tests cover winter offsets and nonexistent local times. Lucide is sufficient for the small interface.
- Unclear: Node SQLite is still marked experimental in Node 24.12.0. Confidence scores are application heuristics, not a database or SDK feature.
- Onboarding/documentation quality: bundled Node API and typed packages were sufficient for this bounded slice.
- Friction: first tests found two application SQL placeholder-count mistakes, then passed after correction. This was an app bug, not a SQLite failure.
- Suggested improvement: explicit column lists in app inserts prevent positional mistakes; retain the Node version requirement.
- Would use again: yes for a local hackathon MVP.

## Node test runner, tsx and Playwright

- Used for: targeted grouping/matching/storage/adapter checks and the exact production browser flow on desktop and mobile dimensions.
- Worked well: 28 targeted tests run quickly; mocked transport can validate official URL and payload handling without credentials. Browser checks cover the visit flow, Playground semantics and temporary-key handling.
- Unclear: browser revision compatibility is separate from the Playwright npm package.
- Onboarding/documentation quality: straightforward once the matching browser is installed.
- Friction: tsx CLI IPC was blocked by the sandbox. Node with the tsx loader runs the same tests. The first browser launch found a missing Chromium revision and is logged. After installation and one app origin-check repair, the complete desktop flow and mobile overflow check pass.
- Suggested improvement: document no-IPC TypeScript test invocation and matching browser installation up front.
- Would use again: yes. Passing mocks are kept separate from actual provider validation.

## Historical onboarding checkpoints

These dated observations preserve the setup experience. Earlier pending-provider statements were superseded by successful Ring and Bedrock execution. Earlier wording requiring organizer clarification was an overly restrictive interpretation, corrected on 2026-09-29. The current approach is an explicitly labeled sample story alongside actual provider evidence.

### Provider onboarding follow-up, 2026-09-28

The official Ring console was opened in Chrome and redirected to Amazon Developer Sign-In. Existing app access and simulator controls cannot be assessed until the owner signs in. This is an expected authentication prerequisite, not a provider outage. No account enrollment or credentials were created. Local AWS profile and shared-credentials files are also absent, so Bedrock account selection remains open. Browser connection/launch friction is recorded separately from Ring/AWS product behavior.

## Official Ring Playground runtime, 2026-09-28

- Used for: temporary test-token generation, device discovery, Vehicle/Motion live-view sessions and event-history inspection.
- Worked well: token generation and console API discovery/history succeeded without registering an app. The UI states a 30-minute token lifetime.
- Unclear: Vehicle/Motion labels select live video, but observed history records were on_demand. No control for producing motion.vehicle, motion.human, or two simulated devices was found in this bounded check.
- Onboarding/documentation: the authenticated Playground is accessible and the [official sample](https://github.com/AmazonAppDev/ring-api-helloworld) documents using its token from code. Public setup docs were less direct about the simulator entry point and typed-event generation.
- Friction: both WHEP sessions returned HTTP 201 but their player displayed "Unable to play media." One device was discovered. Local token-file storage was blocked by tool approval review, independently of Ring.
- Suggested improvements: document the distinction between video simulation and motion-event creation; expose multiple synthetic devices and typed-event controls; show token scopes before generation; provide actionable playback diagnostics.
- Would use again: yes for API exploration. Suitability for Around's two-device activity demo remains unproven. These console checks do not count as Around API execution.

### Simulator coverage clarification

Owner has no hardware. The [hackathon FAQ](https://amazonappdev2026.devpost.com/details/faqs) expressly permits Playground demos, but the [discussion response](https://amazonappdev2026.devpost.com/forum_topics/45309-ring-playground-chime-sub_type-and-sensor-coverage-what-s-the-intended-path-for-non-us-entrants) confirms that the video controls do not emit classified motion webhooks. This explains the runtime observations and limits Playground suitability for our two-device visit workflow. Suggested improvement: a documented event generator with independent synthetic device IDs and motion subtypes. A fixture-based story combined with genuine API proof remains a proposal requiring organizer clarification, not validated provider behavior.

### Actual Around runtime follow-up

The official Playground token worked from Around's own Next.js adapter: one device and two on_demand history records were received and persisted. Their timestamps appeared in the UI and in grounded answers. Authentication and JSON:API parsing worked with the documented endpoints. The token can be supplied per request without disk storage. Chrome offered password saving, which was declined. The adapter now offers a meaningful simulator-to-answer demonstration, while the original classified multi-device visit remains unsupported by the available Playground controls. Bedrock execution remains pending.

### Bedrock onboarding checkpoint

AWS console access is separate from the authenticated Ring Developer portal. The Bedrock console is open at AWS sign-in; no runtime call has been attempted. Official [API key documentation](https://docs.aws.amazon.com/bedrock/latest/userguide/api-keys.html) clearly distinguishes session-limited short-term keys from long-term keys that create IAM users. The installed JavaScript SDK supports bearer authentication. Account access, model availability, latency, cost and output reliability are still unverified.

Bedrock signed-in follow-up: the owner selected a new free AWS account. In us-east-1 the console exposes Nova Micro (amazon.nova-micro-v1:0), its Playground and short-term API-key controls. The model card links usage terms. These controls are discoverable; account-plan inference entitlement is not established by viewing them. The SDK's existing bearer-auth support works in a transport-intercepted synthetic test without installing an AWS CLI or token-generator package. Runtime provider experience and whether we would use it again remain pending an actual call.

### Bedrock live setup result

- Tool/API: Nova Micro through Bedrock Converse and the Bedrock console Playground, us-east-1.
- Used for: structured demo expectation parsing and a tiny access diagnostic.
- Worked well: short-term key generation was available; the console ultimately explained the account-verification gate.
- Unclear/friction: model selection and Run controls were available before the account could invoke models. Two app calls returned access denial; the console supplied the actionable reason.
- Onboarding/documentation: the retired Model access page clearly describes automatic first-invocation enablement, but it does not explain this account's verification state. Console guidance says verification normally takes less than two hours, with an email path if still blocked afterward.
- Suggested improvement: show verification status before key generation and model testing, and distinguish account verification from IAM denial in a structured error field.
- Would use again: still provisional. Three attempts were denied, so runtime model quality, parsing and answer composition have not been assessed.

### Bedrock retry, 2026-09-29

The same Nova Micro model now responds in the AWS console. Around's short-term-key calls still return 403; exact cause is unknown. Console success does not verify SDK integration. Two app calls and one console call today bring the total to six attempted requests, one console success and five denials. Fixed diagnostic labels preserve useful categories without leaking provider details. A dedicated, narrowly permitted IAM identity and one-day Bedrock key are proposed for a distinct authentication test, pending owner approval. The default AmazonBedrockLimitedAccess policy includes substantially more actions than this MVP needs.


### Corrected briefing verified live

The explicit Anything I should know? command now uses deterministic briefing routing followed by one Bedrock fact-selection request. Its live result correctly distinguished today's expected plumber from yesterday's actual Ring live views, reporting no stored activity today without claiming nothing happened. This confirms the repaired path for the observed case. The initial intent error remains a reason to keep exact UI commands deterministic and freeform responses constrained by saved evidence.
