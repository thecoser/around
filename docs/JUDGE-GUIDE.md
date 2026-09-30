# Run and evaluate Around

Around is a local, single-home prototype. Its sample story requires no credentials or paid service. The real Ring and Bedrock paths require separately authorized provider access. No credentials or household databases are distributed.

## Start the sample

Use Node.js 24 or newer. From the repository root:

```sh
npm ci
npm run build
npm run demo:sample
```

Open http://127.0.0.1:3001. The page must say **Sample activity** and **Local demo answers**. This launcher overrides inherited provider modes and gives each launch a fresh local database. Stop and restart it for another clean demonstration.

1. Select **Tell Around**, enter `The plumber is coming today between 10 and 1.`, and save once.
2. Select **Play sample visit**. Expect four events, one probable visit, and a likely match.
3. Ask **Did the plumber come?** Expect estimated bounds of 10:41 AM and 11:27 AM, with identity unconfirmed.
4. Ask **Anything I should know?** and expand the evidence.
5. Reload. Saved records remain. Replaying that day's sample does not duplicate its events.

Sample playback is accelerated. Event times can be later than the current clock. Adding a duplicate expectation can make the match ambiguous.

## Verify the implementation

```sh
npm run check
npm run build
npx playwright install chromium
npm run test:e2e
```

The Chromium install is needed only when the matching browser is absent. Tests use isolated databases, synthetic events and mocked provider transport. They do not prove current provider access. The checked September 30 baseline has 31 targeted tests and three browser scenarios.

## Exercise the actual integrations

Follow the separate Ring Playground and Bedrock configuration sections in [README](../README.md). Keep Ring in its own database and use an authorized temporary token in the local form. **Sync Ring activity** invokes official discovery and history through `src/lib/ring/api.ts`. The app clears the token field and does not store the token.

The observed Playground history contains live-view requests. Around displays those as live views and excludes them from probable visits. A sync may legitimately add zero records when previously received history is unchanged. Never relabel sample events as provider evidence.

To exercise Bedrock, explicitly select `AI_MODE=bedrock`, a supported model and region, and an authorized credential. Calls can incur charges. Parsing one expectation takes one Converse request; a freeform visit question normally takes two; the explicit briefing shortcut takes one. Errors remain visible without a fixture fallback. No owner key is bundled or promised for judging.

## Evidence and limits

Actual September 28 Ring ingestion received one device and two live views. A September 30 sync added one new live-view record at 10:54 AM Eastern, for three stored Ring records and zero expectation matches. September 29 app-side Bedrock checks covered parsing, a dated insufficient-evidence answer from those Ring records, and a corrected briefing. The positive multi-device visit uses sample events. Live classified Ring events and live webhook delivery remain unverified.

The approved sample video shows saved results. Its typing and microphone graphic were added in editing; voice input is not implemented. See [submission copy](../SUBMISSION-COPY.md) and [current readiness](SUBMISSION-READINESS.md) for capture and publication status.

Keep the app bound to loopback. It has no public authentication or production deployment setup. Media-editing helpers under `scripts/media` are optional macOS tools and depend on private source recordings excluded from Git. They are not required to build or run Around.
