---
description: "Generate a weekly synthesis report from patterns stored in OpenMemory. Analyzes the past 7 days of extracted knowledge, identifies themes, and produces action items."
agent: build
---

# Weekly Knowledge Synthesis

Generate a synthesis report from the past week's extracted patterns.

## Step 1: Load the skill

Load the **session-knowledge** skill for context.

## Step 2: Query this week's patterns

Query OpenMemory for patterns captured in the last 7 days:
```
openmemory_query(query="pattern type architectural_decision bug_pattern workflow tool_preference recurring_problem knowledge_gap", type="contextual", k=50)
```

Also query temporal facts for patterns captured since last synthesis date (check harvest-state.json `weeklySynthesisLast`).

## Step 3: Analyze with synthesis agent

Spawn an `artistry` category subagent with all gathered patterns and ask it to synthesize a report:

Prompt structure:
```
Analyze these N patterns extracted from my OpenCode sessions this week.
Generate a structured report with:

1. **Theme of the Week** — What was the dominant focus? (e.g., "Auth architecture", "Bug hunting in parser")
2. **Key Decisions Made** — List each architectural_decision with why
3. **Recurring Issues** — Bug patterns that appeared more than once
4. **Tooling Insights** — Tool preferences or workflow improvements discovered
5. **Knowledge Gaps** — Topics flagged for further research
6. **Action Items** — Concrete next steps (from pattern action_items)

Patterns:
[pattern data]
```

## Step 4: Present the report

Deliver the synthesis as a structured markdown report. If the report content is rich enough, use Lavish HTML for a visual artifact.

## Step 5: Update state

Update `weeklySynthesisLast` in `~/.opencode-memory/harvest-state.json` to the current timestamp.

## Step 6: Summary line

End with:
```
📅 Weekly synthesis complete — N patterns analyzed across M sessions.
Action items: [count] items requiring attention.
```
