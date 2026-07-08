---
name: session-knowledge
description: "Use for session knowledge mining, harvesting past OpenCode sessions into a searchable memory, extracting patterns (decisions, bugs, workflows, tool preferences), storing in OpenMemory, and running the weekly synthesis report. Triggers: 'mine sessions', 'harvest sessions', 'extract patterns', 'session knowledge', 'knowledge mining', 'weekly synthesis', 'synthesize week', '/mine-sessions', '/synthesize-week'."
---

# Session Knowledge Mining Pipeline

A multi-phase pipeline that mines your OpenCode session transcripts, extracts structured patterns, stores them in OpenMemory, and injects relevant past context into future sessions.

## Architecture

```
Sessions ──► Harvester ──► Extractor ──► Indexer ──► OpenMemory
                 ▲                                      │
                 │                                      ▼
            State File                           Retriever
           (harvest-state.json)                       │
                                                      ▼
                                              Context Injection
                                              (future sessions)
                                                      │
                                                      ▼
                                              Weekly Synthesis
```

## Pipeline Workflow

### Phase 1: Manual Harvest (`/mine-sessions`)

1. **Read harvest state** from `~/.opencode-memory/harvest-state.json`
   ```json
   {
     "lastHarvestedTimestamp": "2026-07-06T00:00:00Z",
     "lastHarvestedId": "ses_abc123",
     "harvestedCount": 42,
     "totalPatterns": 156
   }
   ```

2. **Enumerate sessions** using `session_list()` — filter to sessions AFTER `lastHarvestedTimestamp`

3. **For each unharvested session:**
   a. Read transcript via `session_read(id, include_transcript=true)`
   b. Skip if empty or too short (< 5 messages)
   c. Delegate extraction to the **pattern-extractor** subagent (`.opencode/agents/pattern-extractor.md`)
   d. Store each extracted pattern in OpenMemory via `openmemory_store()`

4. **Update harvest state** with the latest processed session timestamp/id

5. **Report**: "Harvested N sessions, extracted M patterns. Patterns stored in OpenMemory."

### Phase 2: Weekly Synthesis (`/synthesize-week`)

1. Query OpenMemory for all patterns from the past 7 days
2. Use an `artistry` agent to generate a synthesis report
3. Present as markdown with sections:
   - **Theme of the week**
   - **Key decisions made**
   - **Recurring issues**
   - **Knowledge gaps**
   - **Action items**
4. Optionally deliver via Lavish for visual review

### Phase 3: Context Injection (automatic on every session)

When starting any new OpenCode task:
1. Take the task description
2. Query OpenMemory for semantically similar past patterns
3. Inject top 5 most relevant patterns into context as "Past Knowledge:"

## Storage Schema (OpenMemory)

### Contextual Memory (HSG)
Store each pattern as a memory entry with:
- **content**: Full pattern description + detail
- **tags**: Pattern type + topic tags
- **metadata**: `{ source_session: "ses_abc", captured_at: "2026-07-06" }`

### Temporal Facts
For every pattern, also store facts:
- `(session_<id>, "has_pattern", pattern_<summary>)`
- `(pattern_<summary>, "type", "<pattern_type>")`
- `(pattern_<summary>, "tag", "<tag>")` — one fact per tag
- `(pattern_<summary>, "captured_at", "<iso_timestamp>")`

## Pattern Extraction Schema

Every extracted pattern has these fields:

| Field | Type | Description |
|---|---|---|
| `type` | enum | One of: `architectural_decision`, `bug_pattern`, `workflow`, `tool_preference`, `recurring_problem`, `knowledge_gap` |
| `summary` | string | One-line title (10 words max) |
| `detail` | string | Full context (3-5 sentences) |
| `tags` | string[] | 3-5 keywords for search |
| `confidence` | float | 0.0-1.0 — how confident the extractor is |
| `action_item` | string | (optional) One concrete next step |

### Pattern Types

- **architectural_decision**: "Chose X over Y because Z." Explicit tradeoffs, tech choices.
- **bug_pattern**: Root cause analysis, recurring failure modes, debugging breakthroughs.
- **workflow**: Multi-step processes, deploy flows, build pipelines, git workflows.
- **tool_preference**: Which tools/configs are preferred and why.
- **recurring_problem**: Issues that surface repeatedly across sessions.
- **knowledge_gap**: Topics where more research/learning is needed.

## Querying Past Knowledge

To retrieve relevant context for a new task:
1. Use `openmemory_query(query="<task description>", type="contextual", k=5)`
2. The results are semantically similar past patterns
3. Present them as:

```
📚 Past context relevant to this task:
• [type] Summary of pattern
  Detail: context
  Source: ses_abc (2026-07-06)
  Tags: tag1, tag2
```

## State File Location

Path: `~/.opencode-memory/harvest-state.json`

```json
{
  "lastHarvestedTimestamp": "2026-07-06T00:00:00Z",
  "lastHarvestedId": "ses_abc123",
  "harvestedCount": 42,
  "totalPatterns": 156,
  "weeklySynthesisLast": "2026-07-06T00:00:00Z"
}
```

## Usage

```markdown
# Manual harvest (Phase 1):
/mine-sessions

# Weekly synthesis (Phase 2):
/synthesize-week

# Query past context (any session):
Run `openmemory_query` with your task description
Use tags to filter: type:architectural_decision, tag:auth

# Auto-harvest (Phase 2):
Installed via cron — runs every 6 hours
Triggers notification on next opencode launch
```
