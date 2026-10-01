# Around judge and demo runbook

The approved final video is already public: https://youtu.be/3w68n80gRA8. Preserve the 29.3-second sample master and 118.3-second v13 unchanged. This runbook reproduces the existing local product; it does not request a new recording or provider run.

## Free local walkthrough

Use Node.js 24 or newer:

```sh
npm ci
npm run build
npm run demo:sample
```

Open http://127.0.0.1:3001 and verify **Sample activity** plus **Local demo answers**. The launcher forces these modes and creates a new local database, preserving prior files.

Save “The plumber is coming today between 10 and 1.” once. Choose **Play sample visit**, then ask **Did the plumber come?** and **Anything I should know?**. Expect one probable visit, a likely match and qualified estimates of 10:41 AM and 11:27 AM. Expand evidence. Reload and replay to confirm persistence and deduplication. Do not add duplicate expectations unless testing ambiguity.

This exercise tests synthetic events and local language. It is not a replay of Bedrock or Ring requests. [Judge guide](JUDGE-GUIDE.md) includes the verification commands and integration setup boundaries.

## Read the published video

The [final storyboard](../DEMO-STORYBOARD.md) is authoritative for timestamps. The sample starts at 18 seconds, official Playground section at 47.3 seconds, and Around integration proof at 73.3 seconds. The video combines separate takes and a labeled saved-record still. It does not show an unobscured sync click.

The positive visit uses sample events and earlier Bedrock answers. Official history returned live-view requests, not classified visitor detections. The new September 30 live-view record is highlighted; three stored real records are documented separately. The microphone and typing in the sample are edited visuals. Voice input is not implemented.

## Optional actual provider evaluation

Follow the [README](../README.md) for separate Ring and Bedrock configurations. Use an authorized Playground token directly in the local app, in a separate database, and keep credential setup off recording. Bedrock requires authorized access and may incur charges. No current token, owner key or paid allowance is supplied by this runbook.

The existing live records and provider checks already support the documented submission claims. No additional paid call is authorized by opening this file. Full live-provider judge access remains a delivery decision in [SUBMISSION-CHECKLIST](../SUBMISSION-CHECKLIST.md).

## Historical recordings

The [original runbook](history/DEMO-RUNBOOK-pre-hardening-2026-09-30.md) preserves earlier scripts, footage sources and recording decisions. Those entries describe prior checkpoints, not current instructions to repeat inference or overwrite approved media. Raw recordings, databases and credentials remain private. Current hashes and publication receipts are summarized in [submission readiness](SUBMISSION-READINESS.md).
