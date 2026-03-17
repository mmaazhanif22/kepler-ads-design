# Kepler Commerce Advertising Portal — UX Enhancement Plan

**Date:** 2026-03-02
**Scope:** Advertising section only (18 tabs across 3 sections)
**Sources:** UX Audit, Code Pattern Audit, Competitive Research (Helium 10, Jungle Scout, Perpetua, Pacvue, Quartile, DataHawk)

---

## Priority Legend
- **P0 CRITICAL** — Broken promises, trust/data-safety risks
- **P1 HIGH** — Major workflow friction, competitive gap
- **P2 MEDIUM** — Consistency issues, polish
- **P3 LOW** — Nice-to-have refinements

---

## P0 CRITICAL (7 items) — Must fix before any user testing

### 1. Implement Table Sorting
**Problem:** Every table header shows `cursor:pointer` + `.sort-arrow` indicators but clicking does nothing. The visual contract is broken — users expect sorting on a data-heavy PPC tool.
**Inspiration:** Helium 10 and Pacvue both support multi-column sorting with persistent sort state.
**Fix:** Implement `sortTable(tableId, colIndex, dataType)` supporting string/numeric/currency/percent/date types. Wire to all `<th>` click events. Update `.sort-arrow` to show active direction. Store sort state in data-attributes.
**Scope:** Global function + wire to all 18+ tables.

### 2. Show Empty State When Filters Return Zero Results
**Problem:** Filtering any table to zero results shows a blank tbody — no message, no guidance. Users can't distinguish "no results" from "still loading" from "broken."
**Fix:** At the end of `filterTable()` and `filterTableByCol()`, count visible rows. If zero, show `.empty-state-row`. Add empty state rows to the ~10 tables currently missing them.
**Scope:** 2 JS functions + ~10 HTML additions.

### 3. Replace `confirm()` with Custom Confirmation Modal
**Problem:** `confirm()` is used for submitting live Amazon bid changes and discarding edits. It's synchronous, unthemeable, shows "localhost" in dev, and can't display change details. For a tool handling real ad spend, this is a trust failure.
**Inspiration:** Perpetua/Pacvue use detailed confirmation panels showing exactly what will change before submission.
**Fix:** Create `<div id="confirm-modal" role="dialog" aria-modal="true">` singleton. Support title, detail list (changed rows), confirm/cancel buttons, danger variant. Replace all 4 `confirm()` call sites.
**Scope:** New modal component + 4 call sites.

### 4. Add Discard Confirmation Guard
**Problem:** Clicking "Discard" on any submit bar immediately throws away all pending edits with only a toast. One misclick = all work lost.
**Fix:** Route "Discard" through the new confirm modal: "Discard N unsaved changes? This cannot be undone." Also restyle Discard from `.btn-ghost` to `.btn-danger` (red tint) to signal destructiveness.
**Scope:** 5 submit bars.

### 5. Make Table Headers Vertically Sticky
**Problem:** Scrolling down any data table loses column headers. With 20-31 columns, users must scroll back to the top to read headers — unacceptable for dense tables.
**Fix:** Add `thead th { position:sticky; top:0; z-index:2; background:var(--table-head-bg); }` globally. Wrap tables in `tbl-wrap` with `max-height: calc(100vh - 220px); overflow-y:auto`.
**Scope:** Global CSS change.

### 6. Freeze 2 Columns on Wide Tables (KW Config, ST Config)
**Problem:** KW Config (31 cols) and ST Config (32 cols) only freeze column 1 (ASIN). Scrolling right to bid columns (cols 18+) loses keyword/target context — real risk of editing wrong row = wrong live bids.
**Inspiration:** Helium 10 always pins Name + Status columns. Pacvue pins Name + Actions.
**Fix:** Extend `.sticky-table` to support `data-freeze-cols="2"`. Freeze ASIN + Target/Keyword on KW Config, ST Config, and Targeting Records.
**Scope:** CSS/JS enhancement + 3 table updates.

### 7. Add ARIA Dialog Attributes to Wizard Modal
**Problem:** The ASIN Launch wizard overlay has no `role="dialog"`, `aria-modal`, or `aria-labelledby`. Screen readers can't announce or navigate it.
**Fix:** Add `role="dialog" aria-modal="true" aria-labelledby="wiz-dialog-title"` to `.wiz-overlay`. Return focus to trigger element on close.
**Scope:** 1 element + close function update.

---

## P1 HIGH (14 items) — Major UX improvements

### 8. Unify Date Picker Pattern Across All Tabs
**Problem:** 5 different date selection patterns across 18 tabs. Some have presets, some have Apply buttons, some have neither.
**Inspiration:** All competitors use: `[7D] [14D] [30D] [60D] [90D] [Custom]` — one consistent pattern everywhere.
**Fix:** Create a standard `DateRangeFilter` component: preset buttons that update immediately + Custom option with date inputs and Apply. Apply to all 18 tabs.
**Scope:** New component + 18 tab updates.

### 9. Unify Filter Reset Behavior
**Problem:** 6+ different reset implementations. Some reset dropdowns only, some also re-show rows, some clear search inputs. Users build muscle memory in one tab and it breaks in another.
**Fix:** Create `resetAllFilters(tableId)` that: (1) resets all selects to index 0, (2) clears search inputs, (3) removes row-level display:none, (4) shows/hides empty state. Wire to all Reset buttons.
**Scope:** 1 function + ~18 button rewires.

### 10. Apply `sticky-table` Class to All Data Tables
**Problem:** Only 5 of 24 tables have `sticky-table`. Tables like `asinConfigTable` (10 cols), `trecTable` (22 cols), `deepDiveTable` have no first-column freeze.
**Fix:** Add `sticky-table` to all tables with 6+ columns.
**Scope:** ~15 table class additions.

### 11. Implement Table Pagination
**Problem:** All tables render all rows at once. No pagination, no virtual scrolling, no "show more."
**Inspiration:** All competitors paginate at 25-100 rows per page with rows-per-page selector.
**Fix:** Implement shared pagination component (10/25/50/100 rows-per-page selector + prev/next). Apply to tables expected to exceed 50 rows in production (Targeting Records, ST Records, KW Config, ST Config, Logs, Bid Strategy Logs).
**Scope:** New pagination component + ~8 table integrations.

### 12. Add Column Visibility to All Tables With 8+ Columns
**Problem:** Column toggles exist on only 4 of 24 tables. Dense tables like Targeting Records (22 cols), Logs, ASIN Config lack column management.
**Fix:** Wire `colToggle` buttons to all tables with 8+ columns using the existing `toggleCampCol` pattern generalized.
**Scope:** ~12 table additions.

### 13. Wire All Export Buttons to Real `exportTableToCSV()`
**Problem:** ~half of Export buttons just call `showToast('Exporting...')` instead of actually exporting. Users see identical buttons with different behaviors.
**Fix:** Replace all toast-only Export stubs with `exportTableToCSV(tableId, filename)`.
**Scope:** ~8 button rewires.

### 14. Add KPI Sparklines and Period-over-Period Deltas
**Problem:** KPI cards show just a value — no trend context. Users can't tell if ACOS is improving or worsening.
**Inspiration:** Helium 10, Jungle Scout, Pacvue all show: value + delta% + trend arrow + sparkline on every KPI card.
**Fix:** Add to each KPI card: (1) delta percentage with green/red arrow, (2) "vs. prior 7 days" context label, (3) inline SVG sparkline showing 30-day trend.
**Scope:** Dashboard KPI cards + ASIN Dashboard KPI cards.

### 15. Add URL Hash Routing for Deep Linking
**Problem:** Refreshing the page always returns to Dashboard. Users can't bookmark or share links to specific views. Browser back/forward don't work.
**Inspiration:** All competitors support URL-based navigation.
**Fix:** `navigate()` sets `window.location.hash`. Add `hashchange` listener to restore state on load. Format: `#campaigns/kw-config`.
**Scope:** `navigate()` function + new hashchange listener.

### 16. Standardize Navigation Labels
**Problem:** Inconsistent abbreviations: "KW", "KWs", "Keywords", "ST" all appear in the sidebar. "Deep Dive" and "All Configurations" are vague.
**Fix:** Rename:
- "KW Research List" → "Keyword Research"
- "KWs Automation" → "Keyword Automation"
- "KWs Config" → already renamed to "Keyword Settings"
- "ST Dashboard" → "Search Terms"
- "ST Records" → "Search Term Records"
- "All Configurations" → "Config Change Log"
- "Deep Dive" → "ASIN Deep Dive"
**Scope:** Sidebar text + breadcrumb labels.

### 17. Replace `<select multiple>` with Checkbox Dropdown
**Problem:** ASIN Dashboard Sources filter uses native multi-select requiring Ctrl+click. Most users don't know this interaction.
**Fix:** Replace with a dropdown that shows checkboxes for each option (SP, SD, SB) with "All" toggle.
**Scope:** 1 component replacement.

### 18. KW Config Column Grouping
**Problem:** 31 columns with no visual grouping. Users can't distinguish informational columns from editable bid columns.
**Inspiration:** Pacvue groups columns under shared headers: "Performance", "Cost", "Budget", "Actions."
**Fix:** Add `<colgroup>` visual separators and sub-headers grouping: Identity (frozen) | Market Intel | Competitive Data | Bid Configuration (editable, tinted background).
**Scope:** KW Config table restructure.

### 19. Theme Persistence in localStorage
**Problem:** Theme resets to dark on every page load despite 6 themes being available.
**Fix:** Save theme choice to `localStorage` in `setTheme()`. Read on `DOMContentLoaded`.
**Scope:** 2 lines of JS.

### 20. Native Date Inputs → Custom Date Picker
**Problem:** `<input type="date">` at 10px font in table cells opens a browser-native calendar that ignores the dark theme and is nearly unusable at that size.
**Fix:** Replace with text inputs with date format mask (`YYYY-MM-DD`) or a lightweight custom date picker that inherits the portal theme.
**Scope:** ~6 date input columns in KW Config.

### 21. Consolidate Duplicate Filter Functions
**Problem:** 15+ bespoke filter functions repeat the same row-iteration logic with hardcoded column indices.
**Fix:** Create `filterTableByColumnValue(tableId, colIdx, value, exactMatch)` and refactor all bespoke functions to use it.
**Scope:** ~15 function consolidations.

---

## P2 MEDIUM (12 items) — Consistency & polish

### 22. Add Inline Edit Visual Cue (Pencil Icon on Hover)
**Inspiration:** Pacvue shows a pencil icon on hoverable editable cells. Users know at a glance which cells are editable.
**Fix:** Add `.editable-cell:hover::after { content:'✎'; }` indicator on all editable table cells.

### 23. Add Toast Type Support (Success/Error/Warning)
**Fix:** Extend `showToast(msg, type='info')` with color-coding: success (green), error (red), warning (amber), info (blue).

### 24. Consolidate Two Toggle Switch Implementations
**Problem:** `.toggle` (accessible, with ARIA) and `.tog-switch` (no ARIA) coexist.
**Fix:** Migrate all `.tog-switch` instances to `.toggle` pattern with proper `role="switch"` and `aria-checked`.

### 25. Add Button Press Feedback (`:active` State)
**Fix:** Add `.btn:active:not(:disabled) { transform:scale(0.98); }` for tactile press feedback.

### 26. Add Breadcrumbs to All Tabbed Views
**Problem:** Only 3 of 17 views have breadcrumbs.
**Fix:** Add `.section-breadcrumb` to Analytics, APDC Diagnostics, Reports, Settings, Internal Tools views.

### 27. Standardize Input Size Variants
**Problem:** Input heights vary between 26px, 32px, 34px, 40px via inline styles.
**Fix:** Create `.input-sm` (28px), `.input-md` (32px), `.input-lg` (40px) classes. Replace inline size overrides.

### 28. Replace Hardcoded Inline Colors With CSS Variables
**Problem:** 282 inline `color:#hex` values break theme switching.
**Fix:** Replace `#F97316` → `var(--primary)`, `#10B981` → `var(--success)`, `#ef4444` → `var(--error)`, etc.

### 29. Remove Duplicate `exportTableToCSV` Definition
**Problem:** Function defined identically twice at lines 13069 and 13091.
**Fix:** Delete the second copy.

### 30. Add `cancelResearch()` to Wizard Close
**Problem:** If user closes wizard during keyword research progress animation, `setInterval` is never cleared.
**Fix:** Call `cancelResearch()` inside `closeWizard()`.

### 31. Fix `.b-blue` Badge Contrast
**Problem:** `.b-blue` text `#93C5FD` on dark card background = ~2.8:1 ratio — fails WCAG AA.
**Fix:** Increase to `#BFDBFE` or darken the badge background.

### 32. Remove Misplaced CSS Rule Inside `:root` Block
**Problem:** `.perf-preset-btn.active` rule is accidentally placed inside `:root` variable block.
**Fix:** Move to the BUTTONS CSS section.

### 33. Discard Button → Danger Style
**Problem:** "Discard" uses `.btn-ghost` which looks harmless. It's a destructive action.
**Fix:** Change to `.btn-danger` (red tint) across all 5 submit bars.

---

## P3 LOW (8 items) — Professional finish

### 34. Add `aria-hidden="true"` to Empty State Emojis
### 35. Fix Breadcrumb Separator Color (use `--muted` not `--border`)
### 36. Add `null` Check in `navigate()` for Missing View IDs
### 37. Remove `tabindex="0"` from Non-Interactive `.nav-subs` Containers
### 38. Consolidate 9 `DOMContentLoaded` Listeners into 1
### 39. Remove Duplicate `.text-sm` / `.text-xs` CSS Declarations
### 40. Fix Chart Tooltip Theme (inherit portal theme instead of hardcoded dark)
### 41. Add Keyboard Handlers (Enter/Space) to Collapsible Sidebar Sections

---

## Competitive Feature Opportunities (Future Enhancements)

These are features from competitors that would differentiate the Kepler prototype but are larger engineering efforts:

| Feature | Source | Description |
|---------|--------|-------------|
| **Saved Table Views** | Pacvue, H10 | Name and save column + filter + sort combinations. "My Performance View", "Budget Analysis" |
| **Period-over-Period Comparison** | All competitors | Dashed overlay line on charts showing previous period. Toggle: "Compare to prior period" |
| **Dayparting Heatmap** | Perpetua, H10 | 24h × 7d grid showing performance by hour/day. Color intensity = spend/ACOS |
| **AI Suggestion Cards** | Perpetua, Quartile | "Increase bid on [keyword] by 15% — predicted +23% impressions" with Accept/Reject/Modify |
| **Visual Rule Builder** | Pacvue, Scale Insights | IF ACOS > 35% AND Impressions > 1000 THEN reduce bid by 10%. Drag-and-drop conditions |
| **Budget Pacing Bars** | Perpetua, Pacvue | Progress bar showing % of daily/monthly budget consumed, projected end-of-day spend |
| **Notification Center** | Pacvue, DataHawk | Bell icon in topbar → dropdown with categorized alerts (Budget, Performance, Anomaly) |
| **What-If Simulator** | Quartile | "If I increase bid to $X, predicted ACOS = Y%, spend = $Z" |
| **Advertising Funnel** | Perpetua | Impressions → Clicks → Orders → Revenue funnel visualization |
| **ACOS/ROAS Gauge** | DataHawk | Circular gauge showing current ACOS vs target with green/amber/red zones |

---

## Implementation Sequence

**Sprint 1 (P0 Critical):** Items 1-7 — Sort, empty states, confirm modal, sticky headers, column freeze, ARIA
**Sprint 2 (P1 High - Core):** Items 8-13 — Unified date picker, filter reset, sticky-table expansion, pagination, column visibility, export wiring
**Sprint 3 (P1 High - Enhancement):** Items 14-21 — KPI sparklines, URL routing, label standardization, checkbox dropdown, column grouping, theme persistence, date picker, filter consolidation
**Sprint 4 (P2 Medium):** Items 22-33 — Edit cues, toast types, toggle consolidation, button feedback, breadcrumbs, input variants, color variables, code cleanup
**Sprint 5 (P3 Low + Future):** Items 34-41 + competitive feature opportunities as capacity allows
