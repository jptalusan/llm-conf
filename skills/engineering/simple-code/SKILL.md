---
name: simple-code
description: Write the simplest code that solves the problem, and optimize only after a measurement says so. Use when writing, changing, fixing or refactoring code, choosing a library or dependency, or when the user asks for simpler, shorter or less over-engineered code.
---

# Simple code

The best code is the code never written. Simple means less to read, less to break and less to change later. It never means skipping the work of understanding the problem: read the task and every file the change touches first, trace the real flow end to end, then pick the smallest change that is correct.

## The ladder

Climb it in order and stop at the first rung that holds.

1. **Does this need to exist?** A need nobody stated is skipped, and you say so in one line.
2. **Does the repo already have it?** Reuse the helper, type or pattern that lives a few files over. Search before you write.
3. **Does the standard library do it?** Use it.
4. **Does the platform do it?** A native input, a CSS rule or a database constraint beats new code.
5. **Does an installed dependency do it?** Use it. A new dependency for what a few lines can do is not worth its weight.
6. **Only then** write the minimum code that works.

A package the user names always wins over this ladder.

## Rules

- **Fix the root cause.** A bug report names a symptom. Before editing a function, find every caller. A guard in the shared function that every caller goes through is a smaller and more complete fix than a guard in each caller.
- **Build only what is asked.** No interface with one implementation, no factory for one product, no setting for a value that never changes, no scaffolding for later.
- **One meaning, one place.** When two pieces of code mean the same thing, merge them. Code that only looks alike but means different things stays separate.
- **No backward compatibility unless asked.** Change the callers instead of keeping the old path alive.
- **Follow the repo's patterns.** When an existing pattern looks wrong or fragile, flag it to the user instead of copying it.
- **Boring beats clever.** Write the version someone can read in a hurry.
- **Mark a known ceiling.** When a shortcut has a limit, such as a global lock or an O(n²) scan, leave a one-line comment naming the limit and the upgrade path.

## Optimization

"We should forget about small efficiencies, say about 97% of the time: premature optimization is the root of all evil. Yet we should not pass up our opportunities in that critical 3%." (Donald Knuth)

Write the clear version first. Optimize only when a measurement (a profiler, a timing harness, a query plan) shows a real hot path, and keep the measurement next to the change so the gain can be checked. The 3% is choosing a sensible algorithm and data structure up front, such as a dict lookup over a scan of a large list. That choice costs nothing in clarity.

## Limits

Simplicity never removes these: a check at a trust boundary, error handling that prevents data loss, security measures, accessibility basics, or anything the user asked for. The `correct-by-design` skill decides where checks go. Physical hardware also needs a calibration setting, since a real clock drifts and a real sensor reads off.
