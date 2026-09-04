---
name: flat-prose
description: Write straight, succinct prose with no contrasts, no header sentences, no colons/semicolons/em-dashes, no jargon, plain noun headers, and one line per paragraph in files. Use for ALL user-facing text - chat replies, reports, summaries, docs, READMEs, commit messages, PR descriptions, code comments. Load before writing any prose of more than a sentence or two.
---

# Flat prose

Eleven rules. CLAUDE.md section 7 points here for the full standard. These override the
`write-in-prose` memory wherever the two conflict.

## 1. No contrasts

Never write "X, not Y" or "X rather than Y" or "X, while Y". State the positive and stop. This
holds even when the contrast seems informative. A contrast wraps a simple fact in a comparison the
reader did not ask for, and it often hides an inaccuracy in the half you did not check.

| Instead of | Write |
|---|---|
| It records bookings, not trips delivered. | It stores bookings. |
| It holds observed times, while the schedule lives in GTFS. | Each row pairs the observed arrival with the scheduled time. |
| This is not GTFS `stop_times.txt`. It records what buses did. | It records what buses did. |

When flattening, check the fact you are left with. The GTFS example above was flattened and the
flat version turned out to be the accurate one, because the file did carry scheduled times after
all.

If the reader genuinely needs the other half, give it its own sentence somewhere it does work.

## 2. No colons, semicolons, or em-dashes

Split into two sentences, or join with "so", "and", "which", "because".

| Instead of | Write |
|---|---|
| 52% are cancels, but most of that is booking mechanics: `Trip correction` (2,563) and `Modified` (1,085) void a row. | 52% of rows have status `cancel`. Most of those come from `Trip correction` (2,563) and `Modified` (1,085), which void a row. |
| `ArriveVariance` is seconds, positive = late; I checked it against the timestamps. | `ArriveVariance` is in seconds and positive values mean late. I checked it against the timestamps. |

Colons introducing a bulleted list are fine. Colons inside a sentence are not.

## 3. No header sentences

Cut any sentence whose only job is to announce the next one. Open with the substance.

| Instead of | Write |
|---|---|
| The two files do not join. Vehicle and run IDs are disjoint... | Vehicle and run IDs are disjoint... |
| Three things worth knowing before you use either: | (nothing, go straight to the first one) |
| Six problems in the current schema motivated the work. | (nothing, go straight to the first problem) |
| Four patterns to cut. | (nothing, go straight to the first pattern) |
| Both files need filtering. Lift has 44 empty columns... | Lift has 44 empty columns... |

A summary sentence that lands *after* the evidence is fine. "Both need filtering" at the end of the
paragraph earns its place. The same words at the front do not.

## 4. No setup and no closers

Skip the opening sentence that restates the request or frames the answer. Skip the closing offer to
help, the "say the word and I'll...", and the "let me know if you want...". If there is a real
decision for the user, state it as a fact about what you left undone.

> I left `.gitignore` alone since where this data should live is your call.

## 5. Full sentences with verbs

Comma-spliced fragments read as notes, not prose.

| Instead of | Write |
|---|---|
| 483 riders, median age 63, 78.6% physical disability. | The file covers 483 riders with a median age of 63. 78.6% carry a physical disability flag. |
| Flat $2 fare. | The fare is a flat $2. |

Bullets are exempt. A bulleted line can be a fragment when the bullet is doing the grammar.

## 6. Every clause carries information

Cut hedges next to a number ("roughly 1,259" when you computed 1,259), intensifiers, and
value-framing like "the value is", "worth knowing", "importantly", "notably", "it's worth flagging".
If a number is there, it makes the point on its own.

## 7. Flat headers

A header is a label, usually one word. It names the section the way a filing cabinet tab names a
folder. It does not summarize the section, sell it, ask a question, or carry a clause.

Each of these is a phrase pretending to be a label.

**Question words.** No header starts with Why, What, Who, How, When or Where. The section answers
the question, so the header only has to name the topic.

**Verb phrases.** "What each layer does" is a sentence with the subject moved. Name the thing.

**Leading articles.** "The shape", "A worked example", "The ten rules". Drop the article and
usually the header improves on its own.

**"and" clauses.** Two nouns joined means two sections, or one section whose name you have not
found yet.

| Instead of | Write |
|---|---|
| Why change it | Motivation |
| The shape | Structure |
| A worked example | Example |
| The ten rules | Principles |
| What each layer does | Layers |
| History and results | History |
| Who sees what | Access |
| What goes away | Removed |
| Limits, and what happens when you hit them | Limits |
| Scope caveat: filtered by order date, not trip date | Scope |
| What you get back | Output |
| What it will not do | Constraints |
| A friendlier client | Client |
| Joining the two | Joins |

A header that is slightly under-informative is correct. The section body carries the information.

This applies to chat replies as much as to files. A reply with headers reading "What I found" and
"What to do next" should read "Findings" and "Next".

## 8. No hard wrapping in files

In any file you write, a paragraph is one line. No wrapping at 80 columns, no wrapping at any
column. This covers Markdown, LaTeX, reStructuredText, plain text, and prose inside code comments
that already spans multiple lines.

Hard wrapping buys nothing. Both Markdown and LaTeX join wrapped lines back into a paragraph when
they render, so the width was never visible to a reader. It costs something real. Edit one word mid-paragraph and every line after it reflows, so a
one-word change shows up in `git diff` as a rewritten paragraph.

These are not prose, so leave them alone:

* Fenced and indented code, including ASCII diagrams
* Table rows
* Headings and list markers
* YAML frontmatter

A list item is one line too, marker and continuation joined.

If a file already uses semantic linefeeds (one sentence per line), match it. That convention keeps
diffs down to the changed sentence and is a deliberate choice worth preserving where somebody made
it.

## 9. Lead with the claim

When a sentence pairs a mechanism with its consequence, the consequence goes first. The reader
wants to know what is true before they want to know why.

| Instead of | Write |
|---|---|
| Depots hang off zones, so a zoneset cannot be reused with a different fleet. | A zoneset cannot be reused with a different fleet, because depots hang off zones. |
| Because `stop_id` is only unique per feed, the key has to be composite. | The key is composite, since `stop_id` is only unique within a feed. |

Then check whether the mechanism half survives the move. Often it was scaffolding you needed to
work out the claim and the reader does not. Cut it, or give it its own sentence where it does
real work.

The same test applies to a pointer at another document. "All six are described with line
references in `other.md`" is worth a sentence only if the reader could not have guessed it, and a
doc that already names `other.md` in its opening has said it once.

## 10. No rhetorical patterning

Repetition and symmetry are decoration. A sentence built for cadence is carrying weight that is not information.

**Tricolons and anaphora.** "Two files, two services, two systems" repeats a structure for rhythm. The second and third beats say nothing the first did not.

**Teaser clauses.** "...and what the arrival times show" promises a fact instead of stating one. Say what they show, or cut the clause.

**What/why and where/how pairings.** "What happens to a request, and why the rate misleads" is two half-sentences wearing one sentence.

| Instead of | Write |
|---|---|
| Two files, two services, two systems. Neither shares a key with the other. | The two files come from different systems and share no key. |
| 113,923 boardings across 19 routes, and what the arrival times show. | 113,923 boardings across 19 routes, running 29 seconds late at the median. |
| Where the anchors sit, and how far riders travel to reach them. | Grocery stores and transit hubs, and how often Lift trips end at each. |
| Four source files behind every number in this deck. | The four source files and where each came from. |

Read the draft flat, with no cadence. Anything that only worked with cadence goes.

## 11. No jargon

Name the thing in words the reader already has. A term is jargon when it compresses a decision, a filter or a column into a label the reader has to look up before the sentence means anything.

**Borrowed shorthand.** "Gated on", "load-controlled", "endogenous", "the masked variant". Each one names a choice without saying what the choice was.

**Identifiers used as prose.** A sentence built around `interior_gaps = 0` or `apc_plausible` makes the reader read code to read English. Say what the condition means, then name it so they can find it.

**Invented compounds.** "The load-controlled variant" and "the trip-layer estimator" read as established terms that do not exist outside your own draft.

| Instead of | Write |
|---|---|
| Trips are gated on a single driver. | Only trips with one driver for the whole trip are kept. |
| Requires zero interior gaps. | Every stop in the middle of the trip needs both an arrival and a departure time. The count of missing ones is `interior_gaps`. |
| The load-controlled variant. | Holding passengers fixed. |
| Leader ordering is endogenous. | A driver who runs fast overtakes, which changes who their own leader is. |
| Masked mode keeps the grain. | Every row is kept and the APC columns are emptied where the agency rejected them. |

The test is whether the reader could act on the sentence without looking anything up.

A term that earns its place gets defined in the same sentence it first appears in, then used freely after that. Keep the identifier alongside the plain wording, since the reader still has to find the column in the code.

Field-standard words are not jargon. "Dwell", "headway" and "adherence" are what the domain calls those things, and replacing them with a description loses precision.

## Check

Grep your own draft for `;`, `—`, `, not `, ` rather than `, ` while `. Each hit is a rule 1 or 2
violation until proven otherwise. Then reread every header on its own and cut it back to a noun.

Reread the draft for every term a reader outside the work would stop on. Each one is a rule 11 violation until you have either replaced it or defined it in place.

Subtitles, captions and section framings need the same pass as body text. They are short and read
like labels, which is exactly where a contrast or a tricolon survives unnoticed.

For a file, check rule 8 as well. No paragraph should span two lines, so `awk 'length > 200'`
finding hits is the healthy result.
