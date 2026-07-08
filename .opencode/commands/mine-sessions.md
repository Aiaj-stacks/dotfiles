---
description: "Harvest unprocessed OpenCode sessions, extract knowledge patterns, and store them in OpenMemory. Runs the Phase 1 session knowledge mining pipeline."
agent: build
---

# Session Knowledge Mining — Harvest

Execute the Phase 1 session mining pipeline. Follow these steps exactly:

## Step 1: Load the skill

Load the **session-knowledge** skill for full context on the extraction schema and storage format.

## Step 2: Read harvest state

Check state file at `~/.opencode-memory/harvest-state.json`. If it doesn't exist, create it with:
```json
{
  "lastHarvestedTimestamp": null,
  "lastHarvestedId": null,
  "harvestedCount": 0,
  "totalPatterns": 0
}
```

## Step 3: Enumerate sessions

Use `session_list(limit=20)` to get recent sessions. Filter to only those after `lastHarvestedTimestamp`. Sort oldest-first.

If `lastHarvestedTimestamp` is null, start from the oldest available session.

## Step 4: Process each session

For each unharvested session:
1. Read the transcript: `session_read(id, include_transcript=true, include_todos=true)`
2. Skip if fewer than 5 messages — too short for meaningful extraction
3. Spawn an **ultrabrain** subagent to extract patterns:
   ```
   task(category="ultrabrain", prompt="You are the Pattern Extractor.
   Read this session transcript and extract structured patterns.

   Session ID: {id}
   Session Date: {date}

   Transcript:
   {full_transcript}

   Extract patterns with this JSON schema:
   { type, summary, detail, tags, confidence, action_item }

   Types: architectural_decision, bug_pattern, workflow, tool_preference, recurring_problem, knowledge_gap
   - Max 8 patterns per session, confidence > 0.7 only
   - Summaries ≤ 10 words, details 3-5 sentences
   - Return ONLY valid JSON: {\"patterns\": [...]}
   - If no patterns found, return {\"patterns\": []}")
   ```
4. Parse the JSON result

## Step 5: Store patterns in OpenMemory

For each extracted pattern:
1. Store as contextual memory: `openmemory_store(content="[type] summary: detail", tags=tags, metadata={"source_session": session_id, "captured_at": session_date, "type": type})`
2. Store temporal facts:
   - `openmemory_store(type="factual", facts=[{subject: session_id, predicate: "has_pattern", object: "summary"}])`
   - `openmemory_store(type="factual", facts=[{subject: "pattern:<summary>", predicate: "type", object: type}])`
   - For each tag: `openmemory_store(type="factual", facts=[{subject: "pattern:<summary>", predicate: "tag", object: tag}])`
   - `openmemory_store(type="factual", facts=[{subject: "pattern:<summary>", predicate: "captured_at", object: session_date}])`

## Step 6: Update harvest state

After all sessions are processed, update `harvest-state.json`:
- `lastHarvestedTimestamp` → the timestamp of the most recently processed session
- `lastHarvestedId` → ID of the most recently processed session
- `harvestedCount` → previous count + number of sessions processed
- `totalPatterns` → previous total + number of patterns extracted

## Step 7: Report

Generate a concise report:
```
📊 Session Harvest Complete
   Sessions processed: N
   Patterns extracted: M
   New memory entries: M
   Types found: [list of types with counts]
```

If $ARGUMENTS contains `--auto`, skip the report and just update state silently.
