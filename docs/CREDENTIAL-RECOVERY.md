# Demo credential recovery, September 29

Historical recovery record. Later README and runbook checkpoints confirm cleanup and owner replacement-key entry, followed by calls 13 through 16. The pending statements and allowances below describe the earlier recovery stage and do not authorize new credential changes or paid calls. Current status is in [SUBMISSION-READINESS](SUBMISSION-READINESS.md).

Recording is paused before provider invocation. Zero of the six newly authorized Converse calls have been used. The original twelve calls remain the total attempted.

## Observed issue

The browser tool output included the original Bedrock key while inspecting a one-time AWS retrieval dialog. This is a credential-handling failure. There is no evidence of third-party access. The key was not saved in a project file or included in recording footage.

One equivalent one-day key was subsequently generated on the existing `around-bedrock-demo` IAM user. Its retrieval dialog closed before safe capture; the cause is unknown. AWS now shows two Bedrock API keys. No IAM policy was changed.

One dummy transfer test was performed in the local sample page. Copying a synthetic password-field value did not populate the browser clipboard. Paste reported no data. The field was cleared, and no request was submitted. Do not repeat that method using an actual credential.

## Approved cleanup

Owner approved this cleanup on September 29. Lead owns deletion and replacement setup; owner owns copying the replacement into Around. Next observable result: zero old demo keys, then one replacement with a one-day expiry and the unchanged policy. Budget: fifteen minutes for setup, with no inference requests or recording during credential handling. Stop for owner entry before inspecting a retrieval dialog containing the replacement. Steward checks the cleanup evidence before recording resumes.

1. In the existing `around-bedrock-demo` user's Security credentials section, delete only its two Amazon Bedrock API keys: the original one-day key and the uncaptured replacement from this recording attempt. Both keys will stop working. Preserve the IAM user and its `AroundNovaMicroDemo` policy.
2. Generate one replacement Amazon Bedrock API key with a one-day lifetime on that same user. Do not attach any managed policy or change permissions.
3. Owner copies the new key directly from AWS into Around's temporary key field, with recording off. Do not print a browser state containing the retrieval dialog or copy the value into tool arguments, project files, chat, or browser storage. Keep key setup in an owner-controlled window.
4. Verify only non-secret presence and existing policy details. Use the already approved six-call, additional-$0.10 recording allowance. Stop on the first access failure.

The earlier Ring token refresh succeeded, but no app sync was made. Agent-held references were cleared. If that 30-minute token expires before recording, another equivalent refresh will be needed. No recording, upload, publication or final submission occurred during this failed setup step.

## Cleanup evidence

- AWS confirmed the original key's deactivation. After the owner yielded Chrome, AWS showed its successful deletion and one remaining key, created at 16:05 Eastern.
- That remaining uncaptured key was deactivated and deleted through the key-specific dialog. AWS then showed API keys (0) and No API keys.
- Policy readback still showed exactly one customer inline policy, AroundNovaMicroDemo. Its JSON retains CallWithBearerToken limited to us-east-1 and InvokeModel limited to amazon.nova-micro-v1:0 in us-east-1.
- Replacement setup selects Amazon Bedrock and a one-day expiry. The retrieval screen will not be read or captured by the agent. Owner will copy directly into the prepared Ring page on port 3000 and sample page on port 3003.
- The two local servers are running with separate databases. Both prepared key fields were empty at handoff preparation. Six approved additional calls remain unused.
- Steward recommended owner activation of the prepared Generate button as well as direct copying, to avoid any tool response exposing the one-time key. Lead accepted this smaller handoff. Replacement creation is still pending, not claimed complete. No tool should inspect the retrieval dialog. After copying into both fields, owner should close that dialog and confirm completion without sharing the key in chat.
