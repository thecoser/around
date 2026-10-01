# Around submission copy

Current source of truth for the Devpost draft, prepared September 30, 2026. Project and runtime claims have been checked against the implementation. Public source and video exist. The Around Devpost draft is saved under thecoser with four of five steps complete; it has not been submitted. The owner confirmed Praxais LLC, United States, New, and the three eligibility declarations. The exact approved short description fits the 200-character elevator-pitch limit. Do not paste preparation notes into the public description.

## Project name

Around

## Tagline

Spatial intelligence for your home.

## Short description

Tell Around what you are expecting at home, then ask what happened. It connects recorded activity with expected visits, turning scattered camera moments into clear, useful answers about your home.

## Full project description

Around helps homeowners connect expected activities with recorded activity. Tell it who you are expecting and when, then ask what happened.

The prototype focuses on a familiar question: “Did the plumber come?” Tell Around, “The plumber is coming today between 10 and 1.” It saves the expected visit and time window. Related driveway and front-door moments can become a probable visit that fits that expectation. Ask Around gives estimated timing and explains that a likely match does not confirm who visited. “Anything I should know?” gives a short briefing based on today's stored activity and expectations.

The public demo begins with this homeowner experience using labeled sample events and answers generated earlier by Amazon Bedrock. It then shows the official Ring Playground and real Ring records received by Around. Our actual Playground runs returned one device and three live-view requests. Around displays those as live views and excludes them from visits. The positive classified two-device visit is sample-verified, not a claim about live Ring detections.

Around is a local, single-home prototype. It offers a repeatable credential-free sample, with real Ring and Bedrock paths available for separately authorized configuration. Delivery confirmation, visitor recognition, voice input, alerts and home controls are planned for future releases.

## Inspiration

A camera timestamp is rarely the homeowner's whole question. People want to know whether an expected service visit happened and what activity was recorded while they were away. Future releases will extend Around to more everyday questions, from confirming package arrivals to recognizing an expected dog walker.

We started with one expectation and one service-visit scenario. Saving what the homeowner expects makes later observations more useful, as long as the answer preserves what those observations can and cannot establish.

## What it does

Tell Around saves a person or service, date and same-day time window. Activity grouping joins compatible observations at one home. Matching compares a probable visit's start with the expected window and keeps competing candidates ambiguous.

In the sample, four moments become one probable visit with estimated bounds of 10:41 AM to 11:27 AM. The timing supports a likely plumber match. Around does not currently identify the visitor or establish continuous presence. Ask Around can also explain that the stored evidence is insufficient and provide a daily briefing.

## How we built it

Around uses Next.js, React, TypeScript, Tailwind CSS and Node SQLite. The Ring adapter normalizes official API responses into stored events. Deterministic code handles grouping, matching, dates and complete answer facts. The sample adapter uses the same domain logic in a separate source-labeled database.

Amazon Bedrock's Converse API, using Nova Micro through the AWS SDK for JavaScript v3, handles expectation parsing, freeform question interpretation and selection of validated fact IDs. Unknown selections fail visibly. The application renders the approved fact text, including its uncertainty, rather than displaying unrestricted model prose.

## Ring integration

The sync route calls official device discovery and event history at runtime, validates IDs/timestamps and persists the result transactionally. Actual Around runs retrieved one Playground device and three live-view requests, including a new September 30 record. Those records influence the answer without becoming invented visits.

The configured two-device path and signed webhook handler are implemented and contract-tested. They support the richer expected-visit workflow, whose positive demonstration currently uses samples. Around's contribution is connecting expected activities with recorded evidence, not adding another motion notification. It does not claim live classified multi-device validation.

## AWS Builder integration

Amazon Bedrock is the application's AWS runtime service. The verified model was Amazon Nova Micro in us-east-1. Tell Around uses one Converse request to parse an expectation. A normal freeform Ask uses interpretation followed by fact selection. The exact briefing shortcuts route deterministically and use one fact-selection request. The Home briefing itself is computed locally.

Actual app-side checks verified parsing, a dated insufficient-evidence answer from official Ring records, a corrected daily briefing and the positive sample flow. For visit answers, the selection step receives one mandatory whole fact; it does not infer who visited or freely compose new claims. These bounded roles are integrated with persistence and deterministic activity logic. No AgentCore, Strands, SageMaker, S3 or cloud-hosted application is implemented.

## Challenges we ran into

The tested Ring Playground Motion/Vehicle controls returned live-view history, not classified events from multiple devices. We kept that distinction visible and used a separately labeled sample for the positive visit.

Bedrock onboarding encountered account verification and unexplained short-term-key access denial. An approved narrow IAM identity and one-day key enabled app-side inference. One model response misunderstood the explicit daily-briefing command. Deterministic command routing corrected that observed case, and the subsequent live recheck passed.

Recording introduced separate problems: native password prompts obscured sync results and one take captured the wrong browser surface. We preserved the failed takes and used clearly disclosed separate recordings and stills. The video does not claim uninterrupted request execution.

## Accomplishments we are proud of

Around connects an expected visit, grouped activity and a qualified answer in one coherent interaction. The actual Ring path stores provider records and supports an insufficient-evidence answer instead of inventing an arrival. Bedrock has been exercised on both real Ring records and sample activity.

The current verification pass includes TypeScript, lint, 31 targeted tests, a production build and three browser scenarios. The source is public under MIT and the approved English demo is 118.3 seconds long. The sample can be run locally without credentials or paid inference.

## What we learned

A live-view request, a motion detection and a probable visit are different kinds of evidence. Preserving those differences is central to a useful answer. Timing can suggest a match without identifying a person.

Keeping activity logic deterministic and language tasks bounded made the system easier to verify. We also learned to separate successful provider execution from usable video evidence: a recording of saved results needs to say that it shows saved results.

## What's next for Around

First, validate classified events from two authorized Ring devices and test overlapping visits, missing observations and ambiguous expectations. Broader use would need authenticated household access, account linking, credential refresh and data-retention controls.

Future releases are planned to add delivery confirmation, visitor recognition, voice input, notifications and home controls. These capabilities will build on the current expected-visit experience, with each grounded in the evidence needed to give homeowners useful answers.

## Potential impact

The initial audience is homeowners coordinating service visits while busy or away. Around could reduce the manual comparison of a schedule with separate camera moments. The sample demonstrates that interaction for an expected plumber visit, with a daily briefing as a second use case.

This is a product hypothesis, not measured customer impact. No adoption, time-saving or market-demand claim has been validated. The next product evaluation should test whether the qualified answers are useful and understandable in actual homes.

## Track

Ring

## Mini challenge

AWS Builder

## Built with

Ring APIs, Ring Developer Playground, Amazon Bedrock, Amazon Nova Micro, AWS SDK for JavaScript v3, Next.js, React, TypeScript, Tailwind CSS, Node.js, SQLite, Zod, date-fns-tz, Lucide and Playwright.

## Links and testing instructions

Source: https://github.com/thecoser/around

Video: https://youtu.be/3w68n80gRA8

Judge guide: https://github.com/thecoser/around/blob/main/docs/JUDGE-GUIDE.md

Use Node.js 24 or newer. Run `npm ci`, `npm run build`, then `npm run demo:sample`. Open http://127.0.0.1:3001. Confirm Sample activity and Local demo answers. Save the original plumber sentence once, play the sample visit and ask the two displayed questions. A new sample database is created on each launch.

Actual Ring and Bedrock execution requires separately authorized credentials and README configuration. No key is bundled or promised. The application must stay on loopback. Full live-provider judging access remains an owner decision; the free sample does not close that gap.

## Video disclosure and credit

The video combines separate takes and labeled stills. The sample visit was not recorded by Ring and shows previously generated Bedrock answers. The real records are live-view requests, not proof of detected motion, a visitor or a matched visit. An unobscured sync click is not included. Sample typing and microphone graphics are edited visuals; voice input is planned for a future release and is not currently implemented.

The published description credits “Birds on Feeders” by Michael Black on Vimeo, provided through the official Ring Playground and identified there as CC BY 4.0. It names the original clipping, our crop, omitted audio and frame hold. Sparkle is an original local composition. Source notices retain Lucide/Feather attribution.

## Product feedback

The five answers below match the actual Devpost fields and were saved and read back without truncation. Full per-tool observations remain in [PRODUCT-FEEDBACK](PRODUCT-FEEDBACK.md).

### Feedback Question 1: Which developer tools, APIs, and SDKs did you use and for what?

Ring developer documentation and official Partner APIs
Around calls official discovery and history APIs, validates provider IDs and timestamps, and stores normalized activity. Its signed webhook handler and configured two-device pipeline are implemented and contract-tested; they have not been validated through live webhook delivery or two real devices.

Ring Developer Playground
Hardware-free token setup, device/history exploration and official simulator playback, followed by Around's own API ingestion.

Amazon Bedrock, Amazon Nova Micro and AWS SDK for JavaScript v3
Around uses Amazon Bedrock Converse with Nova Micro in `us-east-1` through `@aws-sdk/client-bedrock-runtime`. It parses Tell Around sentences, interprets freeform Ask questions and selects complete evidence facts for answers. Explicit Ask briefing shortcuts route locally and use one fact-selection request. The Home briefing makes no model call. No AgentCore, Strands, SageMaker, S3 or AWS hosting is used.

AWS IAM and temporary credentials
IAM supported development-time authorization for the dedicated Bedrock demo identity. The app itself does not create IAM resources. A one-day key was used through SDK bearer authentication; no general AWS access keys or console password were needed by Around.

Supporting tools: Next.js and React provide the local UI and server routes; TypeScript types domain objects; Tailwind CSS styles the interface. Node.js and SQLite persist activity locally. Zod validates boundaries, date-fns-tz and Intl handle local times, and Lucide/Feather supply icons. Node test runner and tsx run unit/contract tests; Playwright and Chromium exercise browser flows; ESLint and Next ESLint config provide static checks. npm and Git manage dependencies and source history. Codex/browser automation supported implementation, review and documentation. macOS AVFoundation, AppKit, AVFAudio and QuickTime/Screenshot supported local media composition and recording.

### Feedback Question 2: For each tool, API, or SDK used in your project, what worked well?

Ring developer documentation and official Partner APIs
JSON:API examples, explicit raw-body HMAC guidance, directed device IDs and pagination rules gave us a useful integration contract. The official sample clarified how a Next.js app could use Playground credentials. Actual Around calls retrieved one device and three live-view records across the observed runs.

Ring Developer Playground
The Playground provided a temporary token and one test device without app registration. The UI stated a 30-minute token lifetime. September 30 recording shows media playback working, and Around received a new live-view history record.

Amazon Bedrock, Amazon Nova Micro and AWS SDK for JavaScript v3
The SDK supported bearer authentication without installing an AWS CLI. Actual app-side checks parsed the original plumber sentence into the correct same-day window. A dated answer referenced real Ring live-view activity and declined to confirm a visitor. A separate four-call sample run completed parsing, a qualified positive answer and the daily briefing.

AWS IAM and temporary credentials
Narrow model/region permissions supported the tested app flow. The owner's direct entry into temporary local password fields avoided application credential storage.

Supporting tools: Next.js/React supported a working production build and browser flow. TypeScript/Tailwind provided typed domain objects and consistent responsive styling. Node/SQLite avoided a separate database service; transactions and uniqueness made replay safe. Zod rejected malformed input. date-fns-tz/Intl supported explicit timezone handling and DST tests. Lucide/Feather suited the compact interface. Node test runner/tsx supported fast TypeScript tests; Playwright/Chromium covered desktop/mobile behavior, persistence and key lifecycle. ESLint/Next ESLint config caught issues without disabling rules. npm's lockfile and Git history supported repeatable setup. Codex/browser automation assisted bounded implementation and review. macOS media frameworks and QuickTime/Screenshot produced the approved edited demo after local tooling fixes. No independent performance benchmark or usability study was performed.

### Feedback Question 3: For each tool, API, or SDK used in your project, what needs work?

Ring developer documentation and official Partner APIs
We need complete classified-history examples and a linked simulator quickstart. A failed Around sync initially surfaced as a generic error. Later fresh-token/server runs succeeded; the original cause is unresolved and cannot be attributed to Ring. Safe local diagnostics now distinguish discovery, history, validation and storage failures.

Ring Developer Playground
The Motion and Vehicle controls selected live-view media. Observed history returned `on_demand`, not classified motion. One simulated device cannot stand in for distinct driveway/front-door devices. The positive visit therefore remains a separately labeled sample. This is a coverage limitation, not a claim that the API fabricated detections.

September 28 WHEP requests returned HTTP 201 while the player showed “Unable to play media.” Later playback success does not explain that first failure. Separate the video controls from event generation, offer typed scenarios across multiple device IDs, and give safe player diagnostics. Surface token scope before generation.

Amazon Bedrock, Amazon Nova Micro and AWS SDK for JavaScript v3
Official documentation explained key lifetimes and IAM backing. The default LimitedAccess policy was broader than this single-model prototype needed. A minimal regional/model policy and SDK example would help. Show verification state before a model test, and distinguish account, model and bearer-permission failures in actionable diagnostics.

One response misread “Anything I should know?” as a visit question. The answer stayed grounded but did not serve the requested intent. Deterministic routing for the explicit shortcuts fixed the observed case; a subsequent actual Bedrock briefing passed. Model selections are validated and unknown IDs are rejected. A visit answer currently contains one mandatory whole fact; this is constrained selection rather than open-ended generation.

AWS IAM and temporary credentials
One-time retrieval and browser coordination complicated safe transfer. A credential appeared in an automation output during setup; the exposed/uncaptured keys were subsequently deleted with explicit owner approval before replacement. That was our handling failure, not a demonstrated AWS defect. We stopped raw dialog inspection and used owner-only retrieval. Details without secret values remain in the original log.

Supporting tools: Next.js normalized a local request URL differently from the Host header; our origin check needed repair without allowing foreign origins. Document that behavior beside local-origin examples. Node SQLite still emits an experimental warning. Two initial SQL placeholder errors were application defects, resolved with explicit columns. No independent TypeScript, Tailwind, Zod, date-fns-tz or Lucide defect was established; retain compatible pinned versions, negative/date tests and icon notices. The tsx CLI's IPC was sandbox-blocked; node --import tsx --test ran the same tests. Playwright initially lacked its matching browser revision, and sandbox restrictions blocked the local server before assertions. Installation and approved local execution resolved those environment failures. ESLint raised an effect-state warning fixed with an asynchronous callback; an upstream support warning also appeared during setup. npm registry/cache restrictions and incompatible /usr/local/bin/git were local issues; system Git worked. Codex/browser automation selected the wrong recording surface and exposed a credential during dialog inspection; those were our handling failures. Use visible capture preflight and owner-only credential entry. macOS media work encountered decoder permissions, drawing across an async suspension, timeline gaps and mixed video configurations. Close writers before reading, inspect decoded frames and verify continuous playback.

### Feedback Question 4: For each tool, API, or SDK used in your project, how was your onboarding experience?

Ring developer documentation and official Partner APIs
Public documentation did not initially expose an obvious simulator-first path. We located the authenticated Playground after owner sign-in. History examples left uncertainty about classified human/vehicle representation, so the adapter preserves generic motion and uses documented subtype filters in configured mode. Those classification paths remain mocked in tests.

Ring Developer Playground
The Motion and Vehicle controls selected live-view media. Observed history returned `on_demand`, not classified motion. One simulated device cannot stand in for distinct driveway/front-door devices. The positive visit therefore remains a separately labeled sample. This is a coverage limitation, not a claim that the API fabricated detections.

Amazon Bedrock, Amazon Nova Micro and AWS SDK for JavaScript v3
New-account verification initially blocked inference. A later console call succeeded while app-side short-term-key requests still returned HTTP 403. A separately approved, narrowly scoped IAM identity and one-day Bedrock key then enabled app-side parsing. That recovery proves the alternate credential worked at the time, not the cause of the earlier rejection or current key validity.

AWS IAM and temporary credentials
One-time retrieval and browser coordination complicated safe transfer. A credential appeared in an automation output during setup; the exposed/uncaptured keys were subsequently deleted with explicit owner approval before replacement. That was our handling failure, not a demonstrated AWS defect. We stopped raw dialog inspection and used owner-only retrieval. Details without secret values remain in the original log.

Supporting tools: Next.js/React, TypeScript, Tailwind, Node/SQLite, Zod, date-fns-tz/Intl and Lucide/Feather were integrated into one local application with pinned dependencies. Initial database tests exposed two application SQL errors, and the local-origin check needed adjustment for Next.js URL normalization. Node test runner/tsx became usable through a no-IPC invocation in the restricted environment. Playwright/Chromium required the matching browser and local-server permissions before assertions could run. ESLint/Next ESLint config provided actionable feedback, with an upstream compatibility warning noted. npm setup encountered registry/cache restrictions; Git required the host-compatible system binary. Codex/browser automation and native recording required explicit coordination of the active browser and private credential entry. AVFoundation/AppKit/AVFAudio and QuickTime/Screenshot needed local permission and timeline/decoder fixes before the final video passed review. These are observations from this project, not broad reliability measurements.

### Feedback Question 5: Would you build with these devices and services again?

Ring developer documentation and official Partner APIs
Yes for authorized device/activity metadata. We would validate real classified-event behavior before relying on the multi-device workflow. Suggested changes are the first two feature requests included in this entry.

Ring Developer Playground
Yes for API exploration and the observed ingestion path. It did not validate the richer classified-visit workflow. No broad uptime or latency claim follows from these few sessions.

Amazon Bedrock, Amazon Nova Micro and AWS SDK for JavaScript v3
Yes for bounded structured language tasks with application validation. These observations do not establish broad model accuracy, latency, cost or production reliability. Safe-error and authentication behavior are also tested with mocked transport, clearly separate from provider execution.

AWS IAM and temporary credentials
Yes with limited lifetime and least privilege. Better single-model examples would reduce the temptation to accept broad defaults. Expiry and revocation still require deliberate owner management.

Supporting tools: Yes to Next.js/React for this compact local application and TypeScript/Tailwind for a typed, consistent interface. Yes to Node/SQLite for the prototype, with explicit Node requirements and insert columns. Yes to Zod and date-fns-tz/Intl with schemas, negative tests and an explicit timezone. Yes to Lucide/Feather with attribution. Yes to Node test runner/tsx and Playwright/Chromium with documented browser revisions, localhost permissions and a no-IPC test option. Yes to ESLint/Next ESLint config with compatible versions and lint retained as a check. Yes to npm/Git with lockfiles and a host-compatible Git binary. Yes to Codex/browser automation with bounded authority, source labels and owner-only credential entry. Yes to macOS media frameworks and QuickTime/Screenshot for local media work, with decoded-frame and continuous-playback verification.
## Feature requests

1. **Important, Ring Playground:** add independent simulated devices and classified human/vehicle/doorbell scenarios. Our tested controls returned one-device live-view history, leaving the positive two-device visit sample-only. Distinguish event creation from video playback.
2. **Important, Ring documentation:** link a simulator-first quickstart and show complete classified-history responses with `event_types` examples. This would reduce setup and normalization uncertainty.
3. **Nice-to-have, Ring Playground:** distinguish safe session, negotiation and player diagnostics. We observed HTTP 201 followed by a playback error, then later successful playback without an established root cause.
4. **Important, Amazon Bedrock:** show account-verification and authorization status before inference. Distinguish account, model and bearer-permission rejections without exposing secrets.
5. **Important, Bedrock/IAM/SDK:** provide a minimal one-model, one-region bearer-auth example with expiry and revocation guidance. Our approved narrow identity worked after earlier short-term-key failures.

## Friction logs

These paste-ready examples are drawn from the full repository log. Severity describes this project's impact, not an outage rating.

### Classified history representation

Observed: September 28.

**Task and steps:** Normalize human/vehicle history correctly. Compared history examples, event-type table and webhook subtype contract.

**Expected:** Complete human and vehicle response examples. **Actual:** Generic motion examples and classified filters did not fully illustrate returned subtype representation.

**Severity:** Important. **Workaround:** Preserve generic motion; use dedicated documented event_types filters in configured mode; contract-test both forms.

**Actionable suggestion:** Publish exact history payload examples for each supported classification. **Current outcome:** Implemented/contract-tested; live classification unverified.

### Playground control and event mismatch

Observed: September 28–30.

**Task and steps:** Exercise a two-device visit without hardware. Used Vehicle, then one bounded Motion control/history check.

**Expected:** Classified vehicle/person observations for visit validation. **Actual:** One device and on_demand history were returned; control labels described live-view media, not detected motion.

**Severity:** Important. **Workaround:** Stopped unchanged attempts; display actual live views separately; positive visit uses labeled samples.

**Actionable suggestion:** Provide independent simulated devices and typed history/webhook scenarios. **Current outcome:** Coverage limit persists; actual ingestion succeeds.

### Playground playback failure

Observed: September 28; follow-up September 30.

**Task and steps:** Play simulator footage. Created WHEP sessions through Vehicle/Motion controls.

**Expected:** Playable video after successful session creation. **Actual:** HTTP 201 sessions showed Unable to play media; later September 30 capture played successfully.

**Severity:** Moderate. **Workaround:** Preserved failure and stopped repeated attempts; used the later observed working playback.

**Actionable suggestion:** Report safe negotiation/player diagnostics separately from session creation. **Current outcome:** Later playback works; original cause unresolved.

### Bedrock account verification

Observed: September 28.

**Task and steps:** Run Nova Micro from Around. Submitted expectation, added safe diagnostics, compared one console invocation.

**Expected:** Parsed expectation or actionable setup error. **Actual:** Early requests failed; console finally reported account verification pending.

**Severity:** Blocking at the time. **Workaround:** Stopped unchanged calls and resumed only after new evidence and authorization.

**Actionable suggestion:** Surface verification status before model testing and key generation. **Current outcome:** Console later succeeded; original denials retained.

### Bedrock bearer access denial

Observed: September 29.

**Task and steps:** Match console success from the app. Used same model/region and valid-shaped temporary key; inspected fixed error categories.

**Expected:** SDK Converse success. **Actual:** Console succeeded while app calls returned AccessDeniedException HTTP 403; exact rejection cause remained unknown.

**Severity:** Blocking at the time. **Workaround:** Stopped same-key retries; separately approved narrow IAM identity and one-day Bedrock key enabled parsing.

**Actionable suggestion:** Provide minimal bearer-auth policy/example and precise safe authorization reasons. **Current outcome:** Alternate credential worked; cause of prior denial unresolved.

### Explicit briefing intent error

Observed: September 29.

**Task and steps:** Answer Anything I should know? as a daily briefing. Ran the exact UI shortcut through model intent interpretation.

**Expected:** Today’s stored activity and expectations. **Actual:** Grounded response answered only a visit question.

**Severity:** Important, application/model interaction. **Workaround:** Route exact briefing shortcuts deterministically, retain Bedrock fact selection; regression and one authorized live recheck passed.

**Actionable suggestion:** Document deterministic command routing alongside natural-language intent examples. **Current outcome:** Resolved for observed command; no universal model-reliability claim.

## Owner review and form-dependent fields

Saved draft: https://devpost.com/software/around-217ygo

The owner confirmed Organization: Praxais LLC, country: United States, no Canadian residence, and New (created after August 31, 2026). The owner also confirmed the three eligibility declarations. Ring and AWS Builder are selected; Open Source is not selected. The additional-information fields contain the repository URL, AWS write-up, five feedback answers, feature requests, friction-log URL and judge-guide URL. The final rules/terms checkbox remains unchecked and Submit project has not been activated.

The form accepts a 60-character project name and 200-character elevator pitch. Optional project images may be JPG, PNG or GIF, up to 5 MB each, with 3:2 recommended. The optional file attachment limit is 35 MB. No new image or attachment was uploaded.

Updated repository publication, optional image uploads, evaluation-access arrangements and final submission remain separate decisions. This document does not authorize provider charges or final submission. Original scripts and media revision history are preserved in docs/history/SUBMISSION-COPY-pre-hardening-2026-09-30.md.
