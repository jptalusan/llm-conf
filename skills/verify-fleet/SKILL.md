---
name: verify-fleet
description: Spawn independent testers and reviewers for a coding, PR, or issue fix, then synthesize their verdicts. Use after implementing a change when you want high-assurance verification from fresh, non-colluding contexts. Manual — invoke explicitly with /verify-fleet.
---

# Verify-fleet

Fan out independent verification of the current change, then synthesize. Default fleet: **2 testers + 2 reviewers**. Scale up for risky/large changes, down to 1+1 for trivial ones.

## Steps
1. **Summarize the change** under review (diff, intent, risk areas) in a few lines. This summary is the brief each agent receives — they do not see each other's work or the main conversation.
2. **Spawn all four agents in a single message** so they run in parallel and stay independent:
   - 2 × `tester` subagents — each independently writes/runs tests and tries to break the change. Assign different angles: e.g. one on happy-path + integration, one on edge cases + failure modes.
   - 2 × `reviewer` subagents — each independently reviews for correctness, security, and design. Assign different lenses: e.g. one correctness/edge-cases, one security/design.
3. **Synthesize.** Collect verdicts. A finding raised by ≥2 agents is high-confidence. Dedupe overlapping findings. Resolve disagreements by reasoning, not vote count alone.
4. **Report**: confirmed issues (severity-ordered), test results (real output), and a clear ship / don't-ship recommendation with confidence.

## Model routing
`tester` (Sonnet) and `reviewer` (Opus) have models pinned, so cost is controlled by design. In **conserve mode** (see the `model-routing` skill): drop testers to Haiku and reviewers to Sonnet, and/or reduce the fleet to 1+1. Announce when you do this.
