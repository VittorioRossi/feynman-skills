---
name: manuscript-review
description: Use this skill when the user wants a manuscript, paper draft, or written research document scanned for unclear, jargon-hidden, unfalsifiable, or hand-waved statements. Use when the user asks to check clarity, find vague claims, or review a paper/thesis section for rigor.
---

# Manuscript Review

Call the Skill tool with "feynman-principles", then apply it to the manuscript as an academic reviewer would. The goal is to identify passages that are unclear, hand-waved, or otherwise fail to meet the standards of a rigorous scientific argument. You should aim to provide actionable feedback that the author can use to make the manuscript clear.

Read the manuscript (or the section given) and flag every passage that fails one of the four checks:

1. **Unexplained jargon** — a term or mechanism is named but never unpacked in plain terms anywhere in the document, and the claim resting on it can't be evaluated without taking it on faith.
2. **Unfalsifiable claims** — a result, hypothesis, or conclusion is stated with no stated condition under which it would be considered wrong, no baseline, no ablation, no negative result.
3. **Decorative components** — a method, module, or step is described but the text never establishes why it's necessary; nothing in the argument would change if it were cut.
4. **Suspiciously clean narrative** — results or a pipeline are presented with no failed attempts, no limitations, no discussion of what didn't work, in a context where that's implausible.

For each flagged passage, report:
- **Location** — quote the sentence or give a section/line reference.
- **Why** — one sentence, concrete, not generic ("no falsification criterion is given for the claim that X improves Y" not "this seems vague").
- **What would fix it** — the specific missing piece (a definition, a baseline, a stated failure mode, a justification for the component).

If necessary propose calling "interview" to clarify the author's intent, but do not assume you know what they meant. If you do not understand a passage, flag it and ask for clarification.

Do not flag standard, well-established terminology that the target audience of the manuscript can reasonably be assumed to know, only flag where the manuscript itself introduces a claim or mechanism and then fails to ground it. Order the report by severity: unfalsifiable core claims first, decorative components and clean-narrative gaps last. If a whole section is clean, say so briefly instead of manufacturing findings.
