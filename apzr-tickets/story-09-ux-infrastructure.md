# UX Infrastructure & Accessibility

## User Story

As a seller, I want the advertising portal to have consistent, accessible, and performant UI patterns across all views — including sortable/filterable/paginated tables, CSV exports/imports, date pickers, confirmation dialogs, and theme support — so that I can work efficiently regardless of which section I'm in.

## Problem / Context

- The advertising section has 17+ data tables — they all need consistent sorting, filtering, pagination, empty states, and export capabilities
- Sellers work in both light and dark mode — all UI elements must adapt correctly to the active theme
- CSV exports must be compatible with Excel (UTF-8 BOM) and include proper data sanitization
- Destructive actions (delete, discard, overwrite) need confirmation dialogs to prevent accidental data loss
- Accessibility requirements (WCAG) mandate keyboard navigation, screen reader support, and focus management
- Date range selection is used across dashboards, analytics, and table filters — a unified date picker with presets is needed

## Solution Outline

**Table Infrastructure (17+ tables):**
- Universal `sortTable()` supporting 267+ sortable columns across all tables
- Pagination with configurable page size (25/50/100 rows) and prev/next controls
- Empty state messages when no data matches filters
- Column visibility toggle per table (Columns dropdown with checkbox list)
- Sticky table headers that remain visible during vertical scrolling
- Frozen first 2 columns for wide tables during horizontal scrolling
- Reset Filters button on every table (22 instances)
- Editable cells with pencil icon on hover for applicable tables

**CSV Export/Import System:**
- Export to CSV with UTF-8 BOM for Excel compatibility
- Data sanitization to prevent formula injection
- Export respects current filter and column visibility state
- Import with format validation and error reporting
- Import History link on all 7 import sections
- Template downloads matching portal format for each table
- Keyword Settings export dropdown: Template vs. Filtered Report

**Confirmation Modals:**
- Custom styled confirmation dialog (not browser native)
- Supports danger variant for destructive actions (red styling)
- Discard guard on forms with unsaved changes (5 touchpoints)
- Used for campaign launch, keyword deletion, settings changes, etc.

**Date Picker with Presets:**
- Unified range picker component used across 4+ views
- Preset buttons: 7D, 14D, 30D, 60D, 90D
- Custom date range selection
- Min/max date boundaries

**Toast Notification System:**
- 4 variants: success (green), error (red), warning (amber), info (blue)
- Auto-dismisses after timeout
- Used for save confirmations, error alerts, action feedback

**Theme Support:**
- Dark mode and 5+ light themes
- All UI elements adapt to active theme via CSS custom properties
- Chart colors, badge colors, and gradient colors are theme-aware
- Sidebar badges show white text on ALL themes

**Accessibility:**
- All interactive elements keyboard-navigable
- Screen reader announcements for dynamic content changes (wizard steps, tab switches, modal open/close)
- `role="dialog"` and `aria-modal` on all modal overlays
- `role="switch"` and `aria-checked` on all toggle controls
- `aria-hidden="true"` on decorative elements
- Global search supports keyboard navigation (arrow keys, Enter)
- Reduced-motion support for skeleton animations
- Focus management: save and restore focus when modals open/close

**URL Hash Routing:**
- Direct navigation to any view via URL hash (e.g., `#keyword-settings`, `#asin-overview`)
- Browser back/forward navigation works between views
- Hash updates when navigating between sections

**UI Requirements:**
- Mockup: [Prototype](http://localhost:8765/Advertising%20Portal%20UI%20Design.html) — all views demonstrate these patterns
- Consistency: same button styles, spacing, typography, and color usage across all views
- Loading states use skeleton animation (shimmer), not spinning loaders
- Error states show descriptive messages with retry options

## Connected Work Items

**Blocks:** Story 5 (KW Settings), Story 6 (ST Settings), Story 7 (Campaigns & KW Research) — all depend on table infrastructure
**Is Blocked By:** None — this is foundational infrastructure
**Relates To:** All stories — every view uses these shared patterns

✅ UX Infrastructure is foundational and should be built first or in parallel with feature stories.

## Implementation Notes

- Table component should be reusable across all 17+ tables with configuration for columns, sorting, pagination, and export
- CSV sanitization must escape values starting with `=`, `+`, `-`, `@` to prevent formula injection
- Theme system uses CSS custom properties (`--primary`, `--error`, `--success`, `--muted`, etc.)
- Confirmation modal should return a Promise for async/await usage patterns
- Toast system should support stacking multiple toasts
- Hash routing should support deep linking to specific tabs within views
- Loading directive should accept size options (small/medium/large) and opacity toggle

## Out of Scope

- Backend API design or data layer architecture
- Mobile-responsive layouts (desktop-first for this phase)
- Internationalization (i18n) beyond English
- Automated end-to-end testing framework setup

## Test Cases

- Seller sorts a table by clicking column header — rows reorder, click again reverses direction
- Seller on page 2 of a 500-row table — prev/next pagination works, page size change resets to page 1
- Table with no matching filter results — empty state message displays
- Seller exports CSV — file opens correctly in Excel with special characters intact (no encoding issues)
- Seller imports malformed CSV — validation error message appears with specific row/column details
- Seller starts closing a form with unsaved changes — discard confirmation modal appears with danger styling
- Seller navigates the portal using keyboard only — all buttons, toggles, and menus accessible
- Screen reader user opens a modal — focus moves to modal, "dialog" role announced
- Seller switches to dark mode — all tables, charts, badges, and buttons adapt correctly
- Seller navigates to `#keyword-settings` URL directly — Keyword Settings view loads
- Seller with reduced motion preference — skeleton animations show static placeholders instead

## Acceptance Criteria

- [ ] All 17+ tables support sorting, filtering, pagination, empty states, and column visibility
- [ ] Sticky headers and frozen columns work for horizontal/vertical scrolling
- [ ] CSV exports include UTF-8 BOM and sanitize formula injection characters
- [ ] Import validates format and shows error details for malformed files
- [ ] Custom confirmation modals replace all native browser confirm dialogs
- [ ] Discard guard prevents accidental data loss on forms with unsaved changes
- [ ] Date picker with 5 presets (7D-90D) is used consistently across all date range controls
- [ ] Toast notifications appear for all user actions (save, error, warning, info)
- [ ] Dark mode and all light themes render all UI elements correctly
- [ ] All interactive elements are keyboard accessible with proper ARIA roles
- [ ] Screen reader users receive announcements for dynamic content changes
- [ ] URL hash routing enables direct navigation and browser back/forward support
- [ ] Tests passed (unit + integration)
- [ ] UI matches approved mockup
