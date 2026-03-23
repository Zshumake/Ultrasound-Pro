---
date: 2026-03-23
topic: video-timestamp-deeplinks
---

# Video Timestamp Deep Links per Procedure Step

## Problem Frame

Residents have a full YouTube demo video embedded per procedure, but a 5-10 minute video is unusable at the bedside and inefficient during study. When a resident needs to see how to position the probe or where to insert the needle, they must scrub through the video manually to find the relevant 15-second segment. This friction means the video gets skipped entirely in the clinical moment where it would be most valuable.

## Requirements

- R1. Each procedure section (Patient Positioning, Probe Placement, Find the View, Correct US Image, Injection Steps, Avoid) can have one or more associated video timestamps
- R2. Tapping a timestamp link on any section scrolls the page to the video player, seeks the video to that timestamp, and auto-plays
- R3. A chaptered timeline bar appears below the video showing labeled segments that can be tapped directly
- R4. Timestamp links appear as small, unobtrusive "play" buttons or badges next to section headers — not disruptive to reading flow
- R5. Timestamp links work in both Study Mode and Procedure Mode
- R6. Data model adds a `videoTimestamps` field: a list of `{label, section, seconds}` objects per procedure
- R7. When no timestamps have been added for a procedure yet, the video section works exactly as it does today (no broken UI, no empty chapter bar)

## Success Criteria

- A resident can tap a landmarking step and see the corresponding video segment within 2 seconds (scroll + seek + play)
- The chapter bar makes it obvious at a glance which parts of the video cover which procedure phases
- Adding timestamps to a new procedure requires only editing JSON — no code changes

## Scope Boundaries

- **Not** building a custom video player — we use the YouTube IFrame Player API via JS interop to control the existing embed
- **Not** adding video-within-video PIP or floating players — the video stays in its current position, page scrolls to it
- **Not** auto-generating timestamps — these are manually curated by watching each video and noting times
- **Not** adding timestamps for all 22 procedures in this phase — start with a few to validate, expand later

## Key Decisions

- **All sections get timestamp links, not just steps/landmarking:** Residents benefit from seeing positioning and probe placement demonstrated, not just the injection itself
- **Scroll-to + auto-seek + auto-play:** Most seamless UX. The video is already on the page; scrolling to it and starting playback is the fastest path to the content
- **Both modes:** Procedure Mode is the bedside moment where a 15-second video clip is most valuable. Excluding it would undermine the primary use case
- **YouTube IFrame API via postMessage:** The current embed is a raw iframe. The YouTube IFrame API can be loaded alongside it and controlled via `postMessage` from Dart, avoiding the need for a third-party Flutter package

## Dependencies / Assumptions

- YouTube IFrame Player API supports `seekTo()` and `playVideo()` via JS interop from Dart web
- Video URLs remain valid YouTube links with extractable video IDs (already true)
- Timestamps are accurate enough that +/- 2 seconds is acceptable

## Outstanding Questions

### Deferred to Planning
- [Affects R2][Technical] Best approach for JS interop with YouTube IFrame API from Flutter web — `dart:js_interop`, `postMessage`, or `dart:html` direct DOM access
- [Affects R3][Needs research] Whether YouTube IFrame API allows reading video duration for proportional chapter bar rendering
- [Affects R6][Technical] Whether `videoTimestamps` should live in the existing JSON files or a separate timestamps JSON file

## Next Steps

-> /ce:plan for structured implementation planning
