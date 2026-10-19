---
name: implement
description: "Implement a piece of work based on a plan, spec or set of tickets."
disable-model-invocation: true
---

Implement the work described by the user in the plan, spec or tickets. A plan is usually a `*_PLAN.md` file at the repo root written by `/llm-conf:plan`.

If the user passes a ticket reference, fetch it from the issue tracker and state its title before starting. If the reference is ambiguous, ask.

Read the plan thoroughly before writing any code, then implement every step in order. Do not skip steps, defer work as follow-ups, or stop partway. If a step is blocked, resolve the blocker or ask the user. Code follows the `simple-code` and `correct-by-design` skills.

Call the Skill tool with "llm-conf:tdd" where possible, at pre-agreed seams.

Run typechecking regularly, single test files regularly, and the full test suite once at the end.

Once done, find every formatter, linter, type checker and test suite the repo uses and run them all. Everything passes before review.

Then loop on review:

1. Call the Skill tool with "llm-conf:code-review", using the commit the work started from as the fixed point and the plan as the spec.
2. Fix every actionable finding. Fix by class: when a finding is one instance of a kind of mistake, fix every instance.
3. Re-run all the checks above.
4. Run a fresh review. Stop when a round returns only nits (wording, naming or ordering that changes no behaviour). If round 3 still has real findings, stop and put them to the user.

Call the Skill tool with "llm-conf:report" to summarise the work, including any deviations from the plan.

Commit your work to the current branch.
