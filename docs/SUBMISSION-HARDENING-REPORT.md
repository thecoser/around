# Submission hardening report

Completed locally September 30, 2026. All ten requested documents are present. No application source, test assertions, dependency versions or approved media were changed. No provider request, upload, push, account change or Devpost write was performed.

## Files created

| File | Purpose |
| --- | --- |
| [EXECUTIVE-SUMMARY](../EXECUTIVE-SUMMARY.md) | Approximately two pages of problem, consumer use case, positioning, technical approach and future limits |
| [TECHNICAL-ARCHITECTURE](../TECHNICAL-ARCHITECTURE.md) | Component/data flow, Mermaid diagram, Ring/AWS call sites, storage, heuristics and production gaps |
| [SUBMISSION-EVIDENCE](../SUBMISSION-EVIDENCE.md) | Claim-to-code/video/criterion matrix and unsupported-claim corrections |
| [DEMO-STORYBOARD](../DEMO-STORYBOARD.md) | Final v13 timing and visible evidence, without a proposed redesign |
| [FEATURE-REQUESTS](../FEATURE-REQUESTS.md) | Five requests supported by actual development experience |
| [SUBMISSION-CHECKLIST](../SUBMISSION-CHECKLIST.md) | Requirements, validation results and unresolved owner/delivery decisions |
| `docs/images/around-sample-desktop.png`, `around-sample-mobile.png` | Fresh fixture screenshots from the passing browser suite; visually inspected |
| [History index](history/README.md) and six snapshots | Preserved original documentation, failures, scripts and revision history |

## Files updated

README now leads with the product, public demo, sample walkthrough and evidence limits. PRODUCT-FEEDBACK covers actual Amazon roles and supporting tools, with qualified observations and actionable suggestions. FRICTION-LOG consolidates 26 issue groups into task/steps, expected/actual, severity, workaround, suggestion and current outcome. SUBMISSION-COPY is the final field-ready source, including feedback, feature requests and selected friction entries.

The demo runbook and submission-readiness document now point to current published assets and the final storyboard. Their original chronology is preserved. Earlier ignored Devpost drafts point to the root source of truth instead of maintaining competing copy.

## Current verification

- TypeScript, ESLint and all 31 targeted tests: pass through `npm run check`.
- Production build: pass through `npm run build`.
- Three production browser scenarios: pass in 5.3 seconds. The first restricted attempt failed before assertions with localhost `listen EPERM`; unchanged host-permitted execution passed. Both logs are retained.
- Current document link, table-column, code-fence and writing-rule checks: pass. Historical snapshots are unedited and retain original paths/wording; they are excluded from current-copy wording checks.
- Git whitespace check: pass. Application/source/test/dependency diff: empty.
- Approved sample and final v13 SHA-256 values match before/after. No media was regenerated.

Local logs, hashes, manifest and QA results are under `data/submission/hardening/`. Those operational receipts are ignored by Git. Published source remains `7feeee7c263955220df05c3aec25050a379aa3bc`; current documentation changes have not been published.

## Unsupported claims corrected or excluded

The package does not claim delivery tracking, confirmed identity, implemented voice input, live classified multi-device matching, live webhook delivery, unrestricted generated answers or production readiness. The Home briefing is local; Bedrock Ask uses validated fact selection. Model input excludes credentials, while SDK authentication uses them. Potential impact is a hypothesis, not measured adoption or savings.

The video is described as separate recorded takes and labeled stills, with saved Bedrock answers. Actual Ring evidence is one device and three live views, with zero matches. The complete positive visit is sample-only.

One earlier assistant rules statement was corrected: official quality-of-idea guidance does favor richer Ring/AWS approaches over basic examples. The package distinguishes that preference from eligibility and does not claim a multi-service AWS pipeline or guaranteed competitiveness.

## Missing requirements and manual decisions

Devpost sign-in, actual field limits, any required image and owner/team declarations remain to inspect. Ring and AWS Builder are intended choices, not selections already saved in Devpost. The owner must confirm eligibility, representative authority, rights and prior-project answers.

The public repository/video and free local sample support evaluation. Full live Ring/Bedrock access is not arranged without separate credentials and possible provider charges. Resolve that access question before marking unrestricted full-product judging complete. The prototype remains local; no hosted service or owner key has been promised.

Updated documents and screenshots require approval before publication. Final Devpost submission is a separate approval, after the complete form preview. No additional provider test is required to verify this local documentation work.

## Three owner review priorities

1. Read [the executive summary](../EXECUTIVE-SUMMARY.md) alongside the public video. Confirm the positioning and the visible sample-versus-real distinction.
2. Review [the checklist](../SUBMISSION-CHECKLIST.md), especially live-provider judge access and owner declarations.
3. Review [submission copy](../SUBMISSION-COPY.md) before approving the exact updated package for GitHub and completing the Devpost form.

A separate read-only Progress Steward reviewed source limits and the final ten-document package. It found no blocking unsupported claim; its two precision suggestions were applied. This review does not replace owner acceptance or the remaining submission decisions.

## Devpost draft continuation

After content approval, the owner registered as thecoser and created the draft. Around is now saved with four of five steps complete. The story, exact 196-character pitch, repository, video, technology tags, Ring and AWS Builder choices are saved. Product feedback was mapped to five actual form questions, independently reviewed for source fidelity and read back without truncation. The owner confirmed Praxais LLC, United States, New and all three eligibility declarations. The final rules/terms checkbox remains unchecked; no final submission, GitHub push or new file upload occurred. Earlier sign-in/form-inspection statements above describe the prior hardening checkpoint.
