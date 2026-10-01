# Around

**Spatial intelligence for your home.**

Around helps you stay on top of what is happening around your home. Tell Around what you are expecting, then ask simple questions about what happened.

[Watch the demo](https://youtu.be/3w68n80gRA8) · [Source and setup](https://github.com/thecoser/around)

## The problem and consumer insight

Home cameras record moments. A homeowner usually has a different question: did the person I expected arrive, and what happened while I was away? A timestamp and a motion label leave the homeowner to connect the pieces.

Around starts with the expectation. Someone waiting for a plumber already knows the service, day and approximate window. Saving that context gives later activity a useful question to answer. The prototype explores whether this can make a home's activity easier to understand without suggesting that a camera can confirm a visitor's identity.

## The solution

The core interaction is short. Tell Around, “The plumber is coming today between 10 and 1.” Around saves the expectation. Related driveway and front-door observations can become a probable visit that fits the expected window. Ask “Did the plumber come?” and Around reports the estimated timing, evidence and uncertainty. “Anything I should know?” gives a brief account of today's stored activity and expectations.

The completed sample scenario joins four moments into one probable visit, from about 10:41 AM to 11:27 AM. It identifies a likely match by timing. The visitor's identity remains unconfirmed, and the estimated bounds do not establish continuous presence.

The prototype currently supports expected visits and activity briefings. Future releases are planned to add delivery confirmation, visitor recognition, voice input, alerts and home controls, extending Around to more of the everyday questions homeowners care about.

## Why Ring and spatial intelligence matter

Ring is the activity source for the real integration. Around calls official device discovery and history APIs and preserves the distinction between a camera interaction and a detection. Its configured-device logic gives driveway and front-door observations different roles when forming a probable visit.

Here, “spatial intelligence” means using the relationship between configured places around one home to interpret activity. It is not a 3D map, computer vision system or calibrated tracking model. A vehicle observation at the driveway and a person observation near the door together support a different interpretation from an isolated event.

Our actual Playground runs received one device and three live-view requests. Around stored and displayed them accurately. These records do not establish a visitor. The positive two-device visit is demonstrated with labeled sample activity because the tested Playground controls did not supply that classified event sequence. This distinction is visible in both the product and the video.

## Who it could help

The initial audience is homeowners coordinating service visits while occupied or away. The first use case is checking whether activity fits an expected plumber visit. A second is reviewing the day's stored activity and upcoming expectations in one place. The intended benefit is less manual comparison of separate camera moments with a remembered schedule.

Around's experience centers on expected household activity rather than a security incident feed. Its useful outcome is a qualified answer to an everyday question. The prototype does not establish market demand, time saved, accessibility outcomes or commercial adoption. Those would need user research and broader field testing.

## Technical approach

Around is one local application with a persistent SQLite database. Deterministic code groups events, compares timing and constructs complete evidence-backed statements. Amazon Bedrock, using Nova Micro, parses expectation sentences, interprets natural-language questions and selects validated statements for answers. It does not generate unrestricted claims about a home.

Actual app-side Bedrock calls have been verified with both official Ring records and labeled sample activity. Webhook ingestion and the configured two-device adapter are implemented and contract-tested; live webhook delivery and classified multi-device behavior remain unverified. A free local sample walkthrough lets a reviewer reproduce the interaction without credentials or paid calls.

## A path toward a consumer product

The next validation step would use authorized classified events from two Ring devices and test difficult cases: overlapping visits, missing detections and nearby events that belong to different people. Product work would then need account linking, credential refresh, authenticated deployment, data-retention controls and evaluation with homeowners.

Future releases will build on this foundation with broader household activity, delivery confirmation, visitor recognition, voice input, alerts and home controls. Each capability will need reliable evidence to support useful answers and actions. The current submission demonstrates the foundation: a working single-home prototype that connects expectations with activity, backed by real API execution and a clearly labeled sample experience.
