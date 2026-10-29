---
name: plan
description: Grill the user, then write a reviewed implementation plan to a gitignored file at the repo root.
disable-model-invocation: true
---

# Plan

Produce an implementation plan that a fresh agent could build from without asking anything.

## 1. Grill

Call the Skill tool with "llm-conf:grilling" and run the session until the frontier is empty and the user confirms a shared understanding. Facts come from the repo, decisions come from the user. If a GitHub issue is referenced, read it with all its comments first.

## 2. Write the plan file

Write `<NAME>_PLAN.md` at the repo root, where `<NAME>` is a short slug of the work (prefix the issue number when there is one). Then make sure the repo's `.gitignore` has a `*_PLAN.md` line, adding it if missing, so plans stay out of commits unless the user asks otherwise.

The file holds these sections, in order:

1. **Title** and **Problem summary**: what is wrong or missing, in a few sentences.
2. **Design decisions**: each key choice with the alternatives considered, their pros and cons, and why this one won. Flag any existing repo pattern that looks wrong or fragile here instead of planning to copy it.
3. **Changes**: per file, whether it is new, modified or deleted, and the exact change, naming the functions, types and sections touched.
   ```
   <path>  (new | modify | delete)
     - <exact change, e.g. "add parse_window(rows) -> Window">
   ```
4. **Tests**: the seams under test (see the `tdd` skill), what each catches, and which tests are added or changed. Prefer real dependencies over mocks. For a refactor, sequence the tests first and confirm they pass before any code changes.
5. **Steps**: ordered, each with its check.
   ```
   1. <step> → check: <command or observation>
   ```

The plan is complete: every step needed to finish is in it, and nothing is deferred to follow-up work. Code follows the `simple-code` and `correct-by-design` skills.

## 3. Review loop

1. Spawn two `reviewer` agents in parallel, one on the agent's default model and one with the model set to `sonnet`, so the two miss different things. Give each the plan path, the problem summary and the code it touches, and ask for actionable improvements against the rules above.
2. Apply every actionable finding to the plan.
3. Spawn two fresh `reviewer` agents on the updated plan, with the same model mix.
4. Repeat until a round returns only nits. A nit is anything a competent implementer would do or know unprompted; fold it in when cheap, but it never triggers another round. If round 3 still has real findings, stop and put them to the user.

When a finding is one instance of a class of mistake, fix every instance of the class, then report the class.

## 4. Hand over

Show the user the design decisions and the path to the plan file. The plan is done when the user approves it. End with: "Type `/implement` to build it."
