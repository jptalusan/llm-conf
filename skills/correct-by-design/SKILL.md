---
name: correct-by-design
description: A way of writing code where invalid data cannot exist past the point it enters, every change goes back through the checks, and every failure is loud, early and names its cause. Use when designing or writing any non-trivial code in any language, such as a new module, a data loader, an adapter, a writer, config handling, or a pipeline. Pairs with ponytail, which decides how little to write. Trigger on "correct by design", "correct by construction", "make it robust", "validate the inputs", "make invalid states impossible", or when starting a new repo.
---

# Correct by design

Most bugs are data that was never checked, data that was checked and then changed, or an error that was swallowed and surfaced three steps later. Each principle below removes one of those at its root, so the code inside a boundary can stop worrying.

## Principles

1. **Parse, don't validate.** Turn unchecked input into a type that can only be built by passing the checks, and pass that type onward instead of the raw data. A function that receives it needs no checks of its own. A boolean `is_valid` throws that knowledge away the moment it returns.

2. **Make invalid states unrepresentable.** Shape the types so a wrong combination cannot be written down. Use a sum type or enum in place of two flags that must not both be true, a required field in place of an optional one that is "always set", and one field in place of two that must agree.

3. **Change is deliberate and goes back through the checks.** A check holds for the value it saw. If code can change that value afterwards, the guarantee silently stops holding while everything downstream still trusts it. So values that carry a guarantee are immutable by default. Change produces a new value built through the same checks, or happens only through operations that re-check. Mutation is visible where it happens and never done to someone else's value behind their back, which is the discipline Rust's `mut` and borrowing enforce.

4. **One source of truth.** A value derived from another is computed from it, never stored next to it where the two can drift apart.

5. **Check at trust boundaries and trust inside them.** User input, files, network answers, environment, other processes and external tools are all boundaries. All checking happens there. Re-checking inside is noise that hides which check matters.

6. **Fail early, loud and specific.** Validate everything before the first side effect, such as a write, a network call or a started process. An error says what was wrong and where, naming the parameter, file, line or record. A wrong type and a wrong value are different errors. Assertions guard only invariants that no input can break, because they can be compiled or optimised away.

7. **Never lose data silently.** Duplicates, collisions, truncation, overflow and two writers for one key are errors that name both parties. Expected misses, such as records that match nothing, are counted and reported, never dropped quietly.

8. **The outside world answers to the same rules.** Output from an external system is input. Read back what you wrote and compare it. When a tool reports counts (accepted, updated, rejected), compare them with what you sent.

9. **Change atomically.** Never edit inputs in place. Build the new state beside the old and swap it in with one atomic step, such as a rename or a transaction, so a failure halfway leaves the old state whole and a running reader never sees a half-written file.

10. **Reruns must be honest.** Anything cached or skipped is keyed by everything it depends on, including input contents, settings, tool versions and upstream results. A step records success only after its own checks pass, so a failed step reruns.

11. **Every check is proven to fire.** Each check has a test that feeds it the bad input and expects its specific error. The end-to-end test includes a negative case, such as tampered data that must fail verification.

12. **Let the tools prove what they can.** The strictest type checking the language offers and a linter run with the tests. Whatever a type can express, do not leave to a runtime check or a comment.

13. **Leave a trail, at a level you can turn.** Logging defaults to DEBUG, and the level can always be raised to INFO, WARNING or ERROR from outside the code, by a flag or an environment variable, without editing anything. Logs go to files in `./log/` at the root of the current repo, one file per run named by program and start time, with `log/` in `.gitignore`. Successes are logged as well as failures, so the log answers both "what worked" and "what broke". Small values built in bulk are summarised in one line, never logged one by one.

| Level | Logs |
|---|---|
| DEBUG | What was made, from what and how big, such as a value built from input, a file written, or a check passed with its counts |
| INFO | A step finished and what it produced, a step skipped and why, a run's settings at start |
| WARNING | Something unexpected that was handled, such as unmatched records, a fallback taken, or a check skipped because its data was missing |
| ERROR | A failure, logged once at the boundary that handles it, with the same context its message carries |

## Mechanisms

The principles are the point. These are how they look in a few languages.

| Principle | Python | TypeScript | Rust | C++ |
|---|---|---|---|---|
| Parse, don't validate | frozen dataclass checking in `__post_init__` | class with private constructor and a static `parse` | newtype with `fn new(..) -> Result<Self, E>` | class whose constructor enforces the invariant or throws |
| Unrepresentable states | `Enum`, `Literal`, a separate type per case | discriminated union | `enum` with data | `std::variant`, `enum class` |
| Change goes back through the checks | `frozen=True`, `dataclasses.replace` re-runs `__post_init__` | `readonly`, return a new object from a checked constructor | immutable unless `mut`, borrow checker | `const`, value semantics, setters that enforce invariants |
| Tools prove it | `mypy --strict`, ruff | `strict: true`, eslint | the compiler, clippy | `-Wall -Werror`, clang-tidy |
| Leave a trail | `logging` with level from `--log-level` or `LOG_LEVEL` | `pino` or `winston` with `LOG_LEVEL` | `tracing` with `RUST_LOG` | `spdlog` with a level flag |

## Ponytail

Ponytail picks the least code. This skill picks where the checks go. Ponytail never removes a check at a trust boundary, a read-back, a count comparison, or the log line that records a result. In return this skill adds nothing ponytail would cut, such as re-checks of values that already carry their guarantee, handling for states the types make impossible, or an interface with one implementation and no second one planned.

## Review

- Can an invalid instance of any core type be built, or a valid one be changed into an invalid one?
- Is any check repeated inside a boundary, or missing at one?
- Does every error say what was wrong and where?
- Can any step lose data without saying so?
- Does every check have a test that makes it fire?
- Run it at DEBUG and at WARNING. Does DEBUG show what was made and from what, and does WARNING still show everything that went wrong?
