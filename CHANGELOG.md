# Changelog

## [0.1.0] - 2026-06-30

### Added
- 4 L1 (global) files: IDENTITY.md / PRINCIPLES.md / STACK.md / STYLE.md
- 6 skills: brainstorm, feature, debug, review, refactor, ship (+ SKILL_FORMAT.md)
- 3 L2 (project) templates: PROJECT.md / ARCHITECTURE.md / CONVENTIONS.md
- 1 L3 (session) template: SESSION_BRIEF_TEMPLATE.md
- 4 scripts: setup.sh, new-session.sh, land-the-plane.sh, pick-skill.sh
- 2 examples: example-PROJECT.md, example-SESSION_BRIEF.md
- README with architecture overview
- ARCHITECTURE.md with detailed design rationale
- MIT license

### Design principles
- Vendor-neutral (works in Antigravity, Claude Code, Cursor)
- 3-level hierarchy: global / project / session
- Skills = enforced procedures, not soft rules
- Each L1 file 30-80 lines (not 500-line monster)
- Total L1 ≤ 5KB
- Skills have ОБЯЗАТЕЛЬНО / ЗАПРЕЩЕНО / Когда прерваться sections