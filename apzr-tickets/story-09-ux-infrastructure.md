# UX Infrastructure & Accessibility

> **Sequencing:** Must be completed before PROD-4124, PROD-4125, and PROD-4126, as those stories depend on shared table, export, and modal patterns built here.

## User Story

As a seller, I want the advertising portal to have consistent, accessible, and performant UI patterns across all views, including sortable/filterable/paginated tables, CSV exports/imports, date pickers, confirmation dialogs, and theme support, so that I can work efficiently regardless of which section I am in.

## Problem / Context

- The advertising section has 17+ data tables. They all need consistent sorting, filtering, pagination, empty states, and export capabilities.
- Sellers work in both light and dark mode. All UI elements must adapt correctly to the active theme.
- CSV exports must be compatible with Excel (UTF-8 BOM) and include proper data sanitization.
- Destructive actions (delete, discard, overwrite) need confirmation dialogs to prevent accidental data loss.
- Accessibility requirements (WCAG) mandate keyboard navigation, screen reader support, and focus management.
- Date range selection is used across dashboards, analytics, and table filters. A unified date picker with presets is needed.

## Existing vs. Net-New

| Area | Status | Notes |
|------|--------|-------|
| Table sorting/filtering | EXISTS (rebuild) | Current portal has basic table sorting. Rebuild with sticky headers, frozen columns, column visibility. |
| CSV export | EXISTS (rebuild) | Export endpoints exist. Rebuild frontend with UTF-8 BOM, filter-awareness, template vs. report modes. |
| CSV import | EXISTS (rebuild) | Upload endpoint exists (`POST /amazon-ads/upload-file`). Rebuild with validation UI and error reporting. |
| Confirmation modals | NEW | No custom modals today. Browser-native `confirm()` used in some places. |
| Date range picker | NEW | No unified date picker component today. |
| Toast notifications | NEW | No toast notification system today. |
| Theme system | NEW | No multi-theme support today. Single light theme only. |
| Accessibility (ARIA) | NEW | Minimal ARIA support in current portal. |
| URL hash routing | NEW | No client-side hash routing today. |

## Solution Outline

Deliver 8 shared infrastructure capabilities that all feature stories depend on.

**1. Table Component:**
- Sellers can sort any column by clicking the header. Clicking again reverses direction.
- Pagination with configurable page size (25/50/100 rows) and prev/next controls.
- Empty state messages when no data matches filters.
- Column visibility toggle per table (Columns dropdown with checkbox list).
- Sticky table headers that remain visible during vertical scrolling.
- Frozen first 2 columns for wide tables during horizontal scrolling.
- Reset Filters button on every table (22 instances).
- Editable cells with pencil icon on hover for applicable tables.

**2. CSV Export/Import System:**
- Export to CSV with UTF-8 BOM for Excel compatibility.
- Data sanitization to prevent formula injection (`=`, `+`, `-`, `@` escaped).
- Export respects current filter and column visibility state.
- Import with format validation and error reporting.
- Import History link on all 7 import sections.
- Template downloads matching portal format for each table.
- Keyword Settings export dropdown: Template vs. Filtered Report.

**3. Confirmation Modals:**
- Custom styled confirmation dialog (not browser native).
- Supports danger variant for destructive actions (red styling).
- Discard guard on forms with unsaved changes (5 touchpoints).
- Used for campaign launch, keyword deletion, settings changes, etc.

**4. Date Range Picker:**
- Unified range picker component used across 4+ views.
- Preset buttons: 7D, 14D, 30D, 60D, 90D.
- Custom date range selection.
- Min/max date boundaries.

**5. Toast Notification System:**
- 4 variants: success (green), error (red), warning (amber), info (blue).
- Auto-dismisses after timeout.
- Used for save confirmations, error alerts, action feedback.

**6. Theme System:**
- Dark mode and 5+ light themes (6 total).
- All UI elements adapt to active theme via CSS custom properties.
- Chart colors, badge colors, and gradient colors are theme-aware.
- Sidebar badges show white text on ALL themes.

**7. Accessibility (ARIA):**
- All interactive elements keyboard-navigable.
- Screen reader announcements for dynamic content changes (wizard steps, tab switches, modal open/close).
- `role="dialog"` and `aria-modal` on all modal overlays.
- `role="switch"` and `aria-checked` on all toggle controls.
- `aria-hidden="true"` on decorative elements.
- Global search supports keyboard navigation (arrow keys, Enter).
- Reduced-motion support for skeleton animations.
- Focus management: save and restore focus when modals open/close.

**8. URL Hash Routing:**
- Direct navigation to any view via URL hash (e.g., `#keyword-settings`, `#manage-ads`).
- Browser back/forward navigation works between views.
- Hash updates when navigating between sections.
- Deep linking to specific tabs within views.

**UI Requirements:**
- Mockup: [Prototype](https://mmaazhanif22.github.io/kepler-ads-design/ads-only.html) | all views demonstrate these patterns
- Consistency: same button styles, spacing, typography, and color usage across all views.
- Loading states use skeleton animation (shimmer), not spinning loaders.
- Error states show descriptive messages with retry options.

## Sub-Tasks

| # | Sub-Task | Exists / New | Backend Reference |
|---|----------|-------------|-------------------|
| 1 | **Table component**: sortable, filterable, paginated tables with sticky headers and frozen columns | EXISTS (rebuild) | All GET list endpoints return paginated data. Sorting/filtering applied client-side or via query params. |
| 2 | **CSV export**: users can export any table data as CSV with UTF-8 BOM | EXISTS (rebuild) | 10+ export endpoints: `GET /amazon-ads/ad-campaign/export/`, `GET /amazon-ads/keywords-config/export/`, `POST /amazon-ads/search-terms/aggregated/export/`, etc. |
| 3 | **CSV import**: upload validated CSV files with error reporting | EXISTS (rebuild) | `POST /amazon-ads/upload-file` with 7 upload strategies: asin-config, ad-campaign-config, k-research, k-config, search-term-config, listing-attributes-ranking, kw-branding-scope. |
| 4 | **Confirmation modals**: destructive actions require user confirmation before execution | NEW | No backend dependency. Client-side UX pattern. |
| 5 | **Date range picker**: preset ranges (7D/14D/30D/60D/90D) + custom date selection | NEW | Date params passed to existing GET endpoints as query filters. |
| 6 | **Toast notification system**: success/error/warning/info feedback for all user actions | NEW | No backend dependency. Client-side UX pattern. |
| 7 | **Theme system**: users can switch between 6 themes (dark + 5 light) | NEW | Theme preference stored client-side (localStorage). |
| 8 | **Accessibility (ARIA)**: screen reader support for modals, tabs, toggles, and dynamic content | NEW | No backend dependency. Semantic HTML + ARIA attributes. |
| 9 | **URL hash routing**: browser back/forward navigation between sections and deep-link support | NEW | No backend dependency. Client-side routing. |

## Backend References

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/amazon-ads/upload-file` | POST | Unified file upload (7 strategies: asin-config, ad-campaign-config, k-research, k-config, search-term-config, listing-attributes-ranking, kw-branding-scope) |
| `/amazon-ads/ad-campaign/export/` | GET | Campaign list CSV export |
| `/amazon-ads/keywords-research/export/` | GET/POST | Keyword research CSV export |
| `/amazon-ads/keywords-config/export/` | GET/POST | Keyword config CSV export |
| `/amazon-ads/search-terms/aggregated/export/` | POST | Search term aggregated CSV export |
| `/amazon-ads/targeting-list/export/` | POST | Targeting list CSV export |
| `/amazon-ads/products-report/export/` | POST | Products report CSV export |
| `/amazon-ads/download-config-file` | GET | ASIN config template download |
| `/amazon-ads/download-campaign-config-file` | GET | Campaign config template download |
| `/amazon-ads/keyword-branding-scope/export/` | GET | Branding scope CSV export |
| `/amazon-ads/bid-strategy-logs/export/` | GET | Bid strategy logs CSV export |

## Connected Work Items

**Blocks:** PROD-4124 (KW Settings), PROD-4125 (ST Settings), PROD-4126 (Campaigns & KW Research). All depend on table infrastructure.
**Is Blocked By:** None. This is foundational infrastructure.
**Relates To:** All stories. Every view uses these shared patterns.

This ticket is foundational and should be built first or in parallel with feature stories.

## Implementation Notes

- Table component should be reusable across all 17+ tables with configuration for columns, sorting, pagination, and export.
- CSV sanitization must escape values starting with `=`, `+`, `-`, `@` to prevent formula injection.
- Theme system uses CSS custom properties (`--primary`, `--error`, `--success`, `--muted`, etc.).
- Confirmation modal should return a Promise for async/await usage patterns.
- Toast system should support stacking multiple toasts.
- Hash routing should support deep linking to specific tabs within views.
- Loading directive should accept size options (small/medium/large) and opacity toggle.

## Related Enhancement Stories

These enhancements extend the base infrastructure. Tracked as separate stories under PROD-2180.

| PROD Key | Enhancement | Dependency |
|----------|------------|------------|
| PROD-4449 | Advanced Table Features: editable cells with pencil-on-hover, column reordering via drag-and-drop, saved filter presets per table | Blocked by PROD-4128 |
| PROD-4450 | Advanced Import/Export: import progress bar with row-level error reporting, import history timeline view, scheduled exports | Blocked by PROD-4128 |

## Out of Scope

- Backend API design or data layer architecture
- Mobile-responsive layouts (desktop-first for this phase)
- Internationalization (i18n) beyond English
- Automated end-to-end testing framework setup

## Test Cases

- Seller sorts a table by clicking column header. Rows reorder, click again reverses direction.
- Seller on page 2 of a 500-row table. Prev/next pagination works, page size change resets to page 1.
- Table with no matching filter results. Empty state message displays.
- Seller exports CSV. File opens correctly in Excel with special characters intact (no encoding issues).
- Seller imports malformed CSV. Validation error message appears with specific row/column details.
- Seller starts closing a form with unsaved changes. Discard confirmation modal appears with danger styling.
- Seller navigates the portal using keyboard only. All buttons, toggles, and menus accessible.
- Screen reader user opens a modal. Focus moves to modal, "dialog" role announced.
- Seller switches to dark mode. All tables, charts, badges, and buttons adapt correctly.
- Seller navigates to `#keyword-settings` URL directly. Keyword Settings view loads.
- Seller with reduced motion preference. Skeleton animations show static placeholders instead.

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
