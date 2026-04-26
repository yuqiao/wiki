---
title: Encoding Team Standards
source: https://martinfowler.com/articles/reduce-friction-ai/encoding-team-standards.html
author: Rahul Garg (Thoughtworks Principal Engineer)
date: 2026-03-31
series: Patterns for Reducing Friction in AI-Assisted Development
---

# Encoding Team Standards

> AI coding assistants respond to whoever is prompting, and the quality of what they produce depends on how well the prompter articulates team standards. I propose treating the instructions that govern AI interactions (generation, refactoring, security, review) as infrastructure: versioned, reviewed, and shared artifacts that encode tacit team knowledge into executable instructions, making quality consistent regardless of who is at the keyboard.

## Overview

When a team has worked together long enough, certain practices become invisible. The senior engineer who rejects a pull request does not consult a checklist; she recognizes, almost instantly, that the error handling is incomplete, that the abstraction is premature, that the naming does not follow the team's conventions.

This tacit knowledge (what to generate, what to check, what to flag, what to reject) is the team's most valuable and most fragile asset. It lives in people's heads, transfers slowly through pairing and code review, and walks out the door when someone leaves.

## The Consistency Problem

When AI-assisted development depends on who is prompting, seniors become bottlenecks, not because they write the code, but because they are the only ones who know what to ask for.

**Example**: A senior engineer, when asking the AI to generate a new service, instinctively specifies:
- follow our functional style
- use the existing error-handling middleware
- place it in `lib/services/`
- make types explicit
- use our logging utility rather than `console.log`

A less experienced developer, faced with the same tasks, asks the AI to "create a notification service" or "clean up this code" or "check if this is secure."

**Same codebase. Same AI. Completely different quality gates.**

This is not the junior developer's fault; they have not yet developed the instincts. But the inconsistency is expensive:
- AI-generated code drifts from team conventions when one developer prompts and aligns when another does
- Refactoring quality varies by who requests it
- Security checks catch different things depending on who frames the question
- Technical debt accumulates unevenly

**This is a systems problem, not a skills problem. And it requires a systems solution.**

## Executable Governance

Teams have always tried to codify their standards. The challenge has always been the gap between documentation and practice. A checklist on a wiki depends on someone reading it, remembering it, and applying it consistently under time pressure.

AI instructions change this dynamic. A team standard encoded as an AI instruction does not depend on someone remembering to apply it. **The instruction is the application.**

> The governance is the workflow.

### Two Moves

| Move | Description |
|------|-------------|
| From tacit to explicit | Taking what the senior knows instinctively and writing it down. The target format is not a wiki page or a checklist, but a structured instruction set that an AI can execute. |
| From documentation to execution | Linting rules are versioned config files, not personal preferences. CI/CD pipelines are executable definitions, not wiki pages. AI instructions belong in the same category. |

When these instructions live in the repository, reviewed through pull requests, shared by default, they have the same status as any other piece of team infrastructure.

## What This Looks Like

A well-structured executable instruction has four elements:

### Instruction Anatomy

| Element | Purpose |
|---------|---------|
| Role definition | Sets the expertise level and perspective. "Role: senior engineer implementing a new service following the team's architectural patterns" |
| Context requirements | What the instruction needs before it can operate: the relevant code, access to architectural context, constraints |
| Categorized standards | The categories matter more than items. For generation: architectural compliance (must follow), convention adherence (should follow), style preferences (nice to have) |
| Output format | Structured response with summary, categorized findings, clear next steps. Ensures comparability across runs and developers |

### Application Examples

| Interaction | What It Encodes |
|-------------|-----------------|
| Generation | How the team builds new code (architecture patterns, naming, error-handling, testing expectations) |
| Refactoring | How the team improves existing code (preserve contracts, avoid premature abstraction, propose incremental change) |
| Security | The team's threat model (what to check and how to grade severity) |
| Review | What the team checks in review (architecture alignment, error handling, type safety, conventions) |

**Principle**: Keep instructions small and single-purpose. Smaller instructions maintain focus, are easier to maintain, and compose flexibly.

## Surfacing the Tacit Knowledge

The extraction process amounts to an interview with the team's senior engineers, structured around pointed questions:

| Question | Maps To |
|----------|---------|
| What architectural decisions should never be left to individual judgment? | Generation constraints |
| Which conventions are corrected most often in generated code? | Convention checks |
| Which security checks are applied instinctively? | Threat-model items |
| What triggers an immediate rejection in review? | Critical checks |
| What separates a clean refactoring from an over-engineered one? | Refactoring philosophy |

The interviews essentially write the instructions; the act of creation is the act of organizing tacit knowledge into explicit, prioritized checks.

**Discovery Example**: On one project, the extraction conversation revealed that two senior engineers had quietly different thresholds for what counted as a "critical" security concern versus an "important" one—a disagreement that had never surfaced because each reviewed different pull requests.

## Where Standards Meet the Workflow

| Point | Value |
|-------|-------|
| Generation-time | Prevent misalignment rather than catching it after the fact. Most leverage. |
| During development | Refactoring and security instructions apply throughout, not bolted on at the end. |
| Review-time | Last opportunity to catch misalignment. Earlier application means fewer issues reach it. |
| Optionally in CI | Automated consistency check. Must be fast, predictable, maintained like any other CI gate. |

## Standards as Shared Infrastructure

A prompt on an individual machine is a personal productivity hack. The same prompt in the team's repository is infrastructure.

When it lives in the repository, it inherits the properties of any versioned artifact:
- Changes tracked
- Standards owned collectively
- Every developer working from the same version

**Comparison to context management**:
- Priming document tells the AI how the project works
- Executable instruction tells the AI how the team works

### Maintenance

Repository placement and pull request review mitigate the "documentation graveyard" risk. An instruction that lives in the repo:
- Appears in diffs
- Can be referenced in pull request templates
- Drift is visible when encountered in normal course of work

> The closer the artifact is to the workflow, the more likely it is to be maintained.

## Calibration

| Team Size | Need |
|-----------|------|
| Teams of 5 | May not need this |
| Teams of 15 | Almost certainly do |

**Signal**: If AI-assisted output visibly varies in quality depending on who is prompting, or if generation and review work is routing through a handful of people because they are the only ones who know how to prompt effectively.

### Costs

| Cost | Description |
|------|-------------|
| Creation effort | Extraction interviews, drafting, iteration |
| Over-prescription | Becomes brittle, produces false positives on edge cases |
| Maintenance burden | Standards evolve |
| Over-engineering | Not every interaction needs a dedicated instruction |

**Starting point**: One instruction. A generation or review instruction is usually highest-value choice. Additional instructions should follow adoption, not precede it.

## Conclusion

This is a shift from judgment that lives in people's heads to judgment that executes as shared infrastructure.

**What changes with AI**: The scope of what can be encoded. Linting catches syntax and style. Executable team standards can encode:
- Architectural judgment
- Security awareness
- Refactoring philosophy
- Review rigor

The kind of knowledge that previously transferred only through pairing, mentorship, and years of shared experience.

**Team-owned property**: They live in the repository. They evolve through pull requests. They improve when practice reveals gaps.

> The standards are not just the output of team knowledge; they are the mechanism through which team knowledge gets codified, shared, and refined.