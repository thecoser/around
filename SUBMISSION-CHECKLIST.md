# Around submission checklist

Checked September 30, 2026. Primary track: **Ring**. Intended mini challenge: **AWS Builder**. The approved documentation and two labeled sample screenshots are published at commit `8328cca`. The initial source publication was commit `7feeee7c263955220df05c3aec25050a379aa3bc`. Devpost is not submitted.

This checklist separates prepared materials from external form completion and unresolved decisions. References: [official rules](https://amazonappdev2026.devpost.com/rules), [FAQ](https://amazonappdev2026.devpost.com/details/faqs). Rule descriptions are summaries; the live official text controls. Deadline shown: October 23, 2026, noon Pacific / 3 PM Eastern. Judging ends November 20, 2026.

## Required materials and access

| Item | Current evidence | Status / remaining action |
| --- | --- | --- |
| Project description | [SUBMISSION-COPY](SUBMISSION-COPY.md), [executive summary](EXECUTIVE-SUMMARY.md) | Owner-approved copy saved in Devpost; exact pitch fits 200 characters |
| GitHub URL | https://github.com/thecoser/around | Public; reviewed documentation published at `8328cca` |
| Necessary app source/assets | Source, lockfile, `.env.example`, scripts and MIT license | App build and sample verified; optional media tools depend on private recordings and are not needed to run app |
| Setup and testing instructions | [README](README.md), [judge guide](docs/JUDGE-GUIDE.md) | Prepared and sample launcher exercised by browser suite |
| Ring runtime integration | Official discovery/history call sites and actual stored-record observations | Verified within [evidence limits](SUBMISSION-EVIDENCE.md); not live classified visit validation |
| Simulator/device demonstration | Official Playground playback and recorded Around result in published video | Demonstrated with separate takes/still; no unobscured sync click |
| Public demo | https://youtu.be/3w68n80gRA8, Praxais Studios | Published; full 118.341-second playback completed without error |
| Duration and language | 118.3-second approved v13, English narration/cards | Below three minutes; English copy prepared |
| Music/footage and other notices | Original owner narration/Sparkle; Playground CC BY 4.0 credit; Lucide/Feather notices | Attribution and modifications included. Original Vimeo item URL not recovered; official Playground source and named creator/title/license recorded. Owner rights declarations remain part of submission |
| Product feedback for used tools | [PRODUCT-FEEDBACK](PRODUCT-FEEDBACK.md), paste-ready copy | Includes Ring, Playground, Bedrock/Nova/SDK, IAM setup and development tooling |
| Ring primary track | Intended in all materials | Selected and saved in Devpost |
| AWS Builder mini challenge | Bedrock roles documented in architecture and product feedback | Selected and saved in Devpost; no multi-service or award claim |
| Prior-project explanation | Git history dates implementation to September 28–30 | Owner confirmed New after August 31, 2026; saved in Devpost |
| Free evaluation | Public code/video, no app fee, credential-free sample | Sample is available. Full live Ring/Bedrock evaluation requires authorized provider access; no current owner key or cost-free arrangement promised. Resolve before declaring unrestricted full-product access complete |
| Repository access | Public MIT repository | No collaborator invitations needed for this public plan |
| Availability during judging | Public source/video currently available | Owner maintains access through judging; no automated monitor was created |
| Eligibility and representative | Individual/team/organization options in rules | Owner confirmed Praxais LLC, United States and three eligibility declarations; final rules/terms acceptance remains |
| Devpost account/form | Signed in as thecoser; Around draft 1207712 | Four of five steps complete; draft preview checked, optional images not uploaded |
| Final submission | No project submission receipt | Requires separate owner approval after complete preview |

## Optional materials

| Item | Evidence | Status |
| --- | --- | --- |
| Feature requests | [FEATURE-REQUESTS](FEATURE-REQUESTS.md), paste-ready copy | Five experience-based requests with priority and suggested behavior |
| Friction log | [FRICTION-LOG](FRICTION-LOG.md), original chronology preserved | Structured observations, severity, workarounds and suggestions; no bonus guaranteed |
| Open Source mini challenge | Public MIT source exists | Not selected; no separate qualifying contribution claimed |
| Images | `docs/images/around-sample-desktop.png`, `around-sample-mobile.png` | Synthetic fixture screenshots, labeled local answers; published in GitHub. Devpost upload approved, waiting for file selection |

## Verification performed for this documentation pass

Node 24.12.0, npm 11.6.2. Source/application behavior unchanged. Local evidence logs are under ignored `data/submission/hardening/`.

| Check | Result |
| --- | --- |
| `npm run check` | PASS: TypeScript, ESLint and all 31 targeted tests |
| `npm run build` | PASS: production compilation and route generation |
| First `npm run test:e2e` attempt | BLOCKED before assertions by sandbox `listen EPERM` on 127.0.0.1:3100; retained in `e2e.log` |
| Same `npm run test:e2e` with local-server permission | PASS: all three scenarios, unchanged tests, 5.3 seconds |
| Provider calls during this pass | None; tests use fixtures/mocks/interception |
| Approved media | Hash checks and storyboard reconciliation; no media edits |
| Documentation integrity | Final link, claim and wording checks recorded in hardening report |

SQLite's experimental warning and `NO_COLOR`/`FORCE_COLOR` warnings were non-failing. Browser tests prove behavior under their synthetic conditions, not live-provider availability. No new test was added for documentation alone.

## Claims review and judging fit

The four criteria are Tech Implementation, Design, Potential Impact and Quality of the Idea. [SUBMISSION-EVIDENCE](SUBMISSION-EVIDENCE.md) maps claims to each. Current consumer impact is a hypothesis supported by a demonstrated interaction, not measured adoption or savings.

The official quality guidance includes creative Ring examples and distinguishes richer AWS approaches from a single generated response. Around documents its actual integrated language roles without claiming agent orchestration or a multi-service AWS pipeline. Meeting basic requirements does not establish competitive strength or acceptance.

Current claims distinguish planned delivery confirmation and voice input from implemented behavior, and exclude live positive multi-device validation, unrestricted model-generated answers, all-local data, Bedrock on every briefing, continuous capture and completed live-provider judge access. Historical wording remains only in explicitly labeled archive material.

## Owner review before submission

1. **Evidence and positioning:** the positive visit is sample-only; actual Ring evidence is three live views. Positioning approved by owner; saved draft preserves the real/sample distinction.
2. **Judge access and declarations:** decide how authorized live-provider evaluation will be available without a judge charge; entrant, country, prior-work and three eligibility answers are confirmed. Final rights/rules/terms acceptance remains.
3. **The exact public package:** documentation publication and the two screenshot uploads are approved. The documentation is published; Devpost image selection remains pending. The actual fields are saved and the preview is checked. Final submission still requires approval.

No feature addition, visibility change, invitation, new upload, paid call or Devpost write occurred during this pass.

## Saved Devpost draft

[Review Around](https://devpost.com/software/around-217ygo). The editor reports Draft, 4/5 steps done. Story, pitch, code/video links, 15 technology tags, Ring, AWS Builder, feature requests, feedback and eligibility answers are saved. The five feedback values were read back exactly. The final rules/terms checkbox remains unchecked. Screenshots and receipts are retained locally under `data/submission/`.
