# Harness engineering for coding agent users

> 来源：https://martinfowler.com/articles/harness-engineering.html
> 抓取日期：2026-04-26
> 作者：Birgitta Böckeler
> 发布日期：02 April 2026

## 核心定义

The term harness has emerged as a shorthand to mean everything in an AI agent except the model itself - **Agent = Model + Harness**. That is a very wide definition, and therefore worth narrowing down for common categories of agents.

In coding agents, part of the harness is already built in (e.g. via the system prompt, or the chosen code retrieval mechanism, or even a sophisticated orchestration system). But coding agents also provide us, their users, with many features to build an outer harness specifically for our use case and system.

A well-built outer harness serves two goals:
1. it increases the probability that the agent gets it right in the first place
2. it provides a feedback loop that self-corrects as many issues as possible before they even reach human eyes

## Feedforward and Feedback

To harness a coding agent we both anticipate unwanted outputs and try to prevent them, and we put sensors in place to allow the agent to self-correct:

- **Guides (feedforward controls)** - anticipate the agent's behaviour and aim to steer it before it acts. Guides increase the probability that the agent creates good results in the first attempt
- **Sensors (feedback controls)** - observe after the agent acts and help it self-correct. Particularly powerful when they produce signals that are optimised for LLM consumption, e.g. custom linter messages that include instructions for the self-correction - a positive kind of prompt injection.

Separately, you get either an agent that keeps repeating the same mistakes (feedback-only) or an agent that encodes rules but never finds out whether they worked (feed-forward-only).

## Computational vs Inferential

There are two execution types of guides and sensors:

| Direction | Computational / Inferential | Example implementations |
|-----------|----------------------------|-------------------------|
| Coding conventions | feedforward | Inferential | AGENTS.md, Skills |
| Instructions how to bootstrap a new project | feedforward | Both | Skill with instructions and a bootstrap script |
| Code mods | feedforward | Computational | A tool with access to OpenRewrite recipes |
| Structural tests | feedback | Computational | A pre-commit hook running ArchUnit tests |

**Computational** - deterministic and fast, run by the CPU. Tests, linters, type checkers, structural analysis. Run in milliseconds to seconds; results are reliable.

**Inferential** - Semantic analysis, AI code review, "LLM as judge". Typically run by a GPU or NPU. Slower and more expensive; results are more non-deterministic.

## The steering loop

The human's job in this is to steer the agent by iterating on the harness. Whenever an issue happens multiple times, the feedforward and feedback controls should be improved to make the issue less probable to occur in the future, or even prevent it.

## Timing: Keep quality left

Teams who are continuously integrating have always faced the challenge of spreading tests, checks and human reviews across the development timeline according to their cost, speed and criticality. When you aspire to continuously deliver, you ideally even want every commit state to be deployable. You want to have checks as far left in the path to production as possible, since the earlier you find issues, the cheaper they are to fix.

### Continuous drift and health sensors

What type of drift accumulates gradually and should be monitored by sensors running continuously against the codebase, outside the change lifecycle? (e.g. dead code detection, analysis of the quality of the test coverage, dependency scanners)

## Regulation categories

The agent harness acts like a cybernetic governor, combining feed-forward and feedback to regulate the codebase towards its desired state. Three categories:

### Maintainability harness

More or less all of the examples are about regulating internal code quality and maintainability. This is at the moment the easiest type of harness, as we have a lot of pre-existing tooling.

Computational sensors catch the structural stuff reliably: duplicate code, cyclomatic complexity, missing test coverage, architectural drift, style violations. These are cheap, proven, and deterministic.

LLMs can partially address problems that require semantic judgment - semantically duplicate code, redundant tests, brute-force fixes, over-engineered solutions - but expensively and probabilistically. Not on every commit.

Neither catches reliably some of the higher-impact problems: Misdiagnosis of issues, overengineering and unnecessary features, misunderstood instructions.

### Architecture fitness harness

This groups guides and sensors that define and check the architecture characteristics of the application. Basically: Fitness Functions.

Examples:
- Skills that feed forward our performance requirements, and performance tests that feed back to the agent
- Skills that describe coding conventions for better observability (like logging standards)

### Behaviour harness

This is the elephant in the room - how do we guide and sense if the application functionally behaves the way we need it to?

At the moment, I see most people who give high autonomy to their coding agents do this:
- Feed-forward: A functional specification (of varying levels of detail)
- Feed-back: Check if the AI-generated test suite is green, has reasonably high coverage

This approach puts a lot of faith into the AI-generated tests, **that's not good enough yet**.

## Harnessability

Not every codebase is equally amenable to harnessing. A codebase written in a strongly typed language naturally has type-checking as a sensor; clearly definable module boundaries afford architectural constraint rules; frameworks like Spring abstract away details the agent doesn't even have to worry about.

### Ambient affordances

My colleague Ned Letcher uses the term "ambient affordances" for the properties of the agent environment that make it more harnessable: "structural properties of the environment itself that make it legible, navigable, and tractable to agents operating within it."

This plays out differently for greenfield versus legacy:
- **Greenfield teams** can bake harnessability in from day one - technology decisions and architecture choices determine how governable the codebase will be
- **Legacy teams**, especially with applications that have accrued a lot of technical debt, face the harder problem: the harness is most needed where it is hardest to build

## Harness templates

Most enterprises have a few common topologies of services that cover 80% of what they need. In many mature engineering organizations these topologies are already codified in service templates. These might evolve into harness templates in the future: a bundle of guides and sensors that leash a coding agent to the structure, conventions and tech stack of a topology.

### Ashby's Law

Ashby's Law of Requisite Variety is another interesting argument for these pre-defined topologies. The law says that a regulator must have at least as much variety as the system it governs, and it can only regulate what it has a model of. An LLM-based coding agent can produce almost anything, but committing to a topology narrows that space, making a comprehensive harness more achievable. Defining topologies is a variety-reduction move.

## The role of the human

As human developers we bring our skills and experience as an implicit harness to every codebase. We absorbed conventions and good practices, we have felt the cognitive pain of complexity, and we know that our name is on the commit. We also carry organisational alignment.

A coding agent has none of this: no social accountability, no aesthetic disgust at a 300-line function, no intuition that "we don't do it that way here," and no organisational memory.

Harnesses are an attempt to externalise and make explicit what human developer experience brings to the table, but it can only go so far. A good harness should not necessarily aim to fully eliminate human input, but to direct it to where our input is most important.

## Open questions

- How do we keep a harness coherent as it grows, with guides and sensors in sync, not contradicting each other?
- How far can we trust agents to make sensible trade-offs when instructions and feedback signals point in different directions?
- If sensors never fire, is that a sign of high quality or inadequate detection mechanisms?
- We need a way to evaluate harness coverage and quality similar to what code coverage and mutation testing do for tests.

## 实战案例引用

- OpenAI team: layered architecture enforced by custom linters and structural tests, recurring "garbage collection" that scans for drift
- Stripe's minions: pre-push hooks that run relevant linters, "shift feedback left", blueprints integrating feedback sensors
- Mutation and structural testing: computational feedback sensors having a resurgence
- LSPs and code intelligence: computational feedforward guides
- Thoughtworks teams: "janitor army" for architecture drift

## 作者

Birgitta Böckeler is a Distinguished Engineer and AI-assisted delivery expert at Thoughtworks. She has over 20 years of experience as a software developer, architect and technical leader.