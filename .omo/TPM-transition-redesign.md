# Plan: Redesign Phase 1 for TPM-Focused Architecture & AI Literacy

## Problem
Current Phase 1 (weeks 1-8) teaches Python programming (calculator, FizzBuzz, CSV parser, todo list CLI). The Captain is an operations professional transitioning to TPM — he doesn't need to code deeply. He needs to understand architecture, read code, and use agentic AI as his tool.

## Solution
Rewrite Phase 1 from scratch. 8 weeks focused on:
1. **Architecture & Infrastructure understanding** (how systems are built)
2. **AI-as-TPM-tool** (using agents to do TPM work, not just learning about them)
3. **TPM artifacts** (specs, diagrams, risk registers, post-mortems)

## Redesigned Weeks

| Week | Topic | AI Component |
|---|---|---|
| 1 | How the Web Works (DNS, HTTP, APIs, client-server) | AI explains concepts, traces request flow |
| 2 | Reading Code (PR diffs, patterns, reviewing) | AI generates PR summaries, explains code |
| 3 | Architecture Building Blocks (APIs, DBs, caching, queues) | AI creates architecture diagrams, compares options |
| 4 | Cloud & Infrastructure (containers, CI/CD, deployment) | AI explains pipelines, generates config snippets |
| 5 | AI/Agent Systems for TPMs (tokens, agents, MCP, risks) | Use agents as TPM assistant, design agent specs |
| 6 | Data & Analytics (SQL reading, pipelines, dashboards) | AI explains queries, creates dashboard designs |
| 7 | Security, Reliability & Risk (auth, SLOs, post-mortems) | AI drafts risk assessments, post-mortems |
| 8 | Capstone - Spec a Complete System | AI as architecture partner throughout |

## Execution
1. Write brief.md for crewmate with full content specs
2. Dispatch crewmate via fm-spawn.sh to rebuild week/01-08/
3. Verify quality and merge

## Approval
Captain already said "pivot phase 1" — proceed direct.
