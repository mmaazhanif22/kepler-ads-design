# UX Infrastructure and Accessibility

# User Story

As a seller, I want the advertising portal to have consistent, accessible UI patterns across all views so that I can work efficiently regardless of which section I am in.

# Problem / Context

- The advertising section has 17+ data tables. Each currently implements its own sorting, filtering, and pagination logic with inconsistent behavior. There is no shared table component.
- CSV exports use different formatting. Some include UTF-8 BOM, some do not. No formula injection protection exists (cells starting with `=`, `+`, `-`, `@` are not escaped).
- Destructive actions use browser-native `confirm()` dialogs. No custom confirmation modals exist.
- There is no unified date range picker component. Each view implements its own date controls.
- No toast notification system exists. Users get no feedback after save/error actions.
- The portal has a single light theme. No dark mode or theme switching capability.
- Minimal ARIA support. Modals lack `role="dialog"`, toggles lack `role="switch"`, no focus management on modal open/close.
- No client-side hash routing. Direct URL navigation to specific views is not possible.

# Solution Outline

**1. Table Component:** Reusable `KeplerTableComponent` used by 17+ views. Sortable columns (click header), pagination (25/50/100), empty state messages, column visibility toggle, sticky headers, frozen first 2 columns for wide tables, reset filters button, editable cells with pencil icon on hover.

**2. CSV Export/Import:** UTF-8 BOM for Excel. Formula injection escaping (`=`, `+`, `-`, `@` prefixed with single quote). Export respects current filter and column visibility. Import with validation and row-level error reporting. Import History link on all 7 import sections. Template vs. Filtered Report export modes. Upload endpoint: `POST /amazon-ads/upload-file` with 7 strategies (asin-config, ad-campaign-config, k-research, k-config, search-term-config, listing-attributes-ranking, kw-branding-scope).

**3. Confirmation Modals:** Custom styled dialog replacing browser `confirm()`. Danger variant (red) for destructive actions. Discard guard on forms with unsaved changes (5 touchpoints). Returns Promise for async/await.

**4. Date Range Picker:** Unified component across 4+ views. Presets: 7D, 14D, 30D, 60D, 90D. Custom date range. Min/max boundaries.

**5. Toast Notifications:** 4 variants: success (green), error (red), warning (amber), info (blue). Auto-dismiss after timeout. Stacks multiple toasts.

**6. Theme System:** Dark mode + 5 light themes (6 total). CSS custom properties (`--primary`, `--bg`, `--card`, `--border`, `--text`, `--muted`, `--success`, `--error`, `--warning`). Theme switching via `data-theme` attribute on `<body>`, persisted to localStorage. Sidebar badges white text on all themes.

**7. Accessibility (ARIA):** All modals: `role="dialog"`, `aria-modal="true"`, focus trap, restore focus on close. Toggles: `role="switch"`, `aria-checked`. Tabs: `role="tablist/tab/tabpanel"`, `aria-selected`. Sort headers: `aria-sort`. Loading: `aria-busy`. Decorative icons: `aria-hidden="true"`. Reduced-motion support for skeleton animations.

**8. URL Hash Routing:** Direct navigation via hash (e.g., `#keyword-settings`). Browser back/forward support. Deep linking to tabs (e.g., `#campaigns/kw-config`).

**Behavior flow:**
1. Seller sorts table by clicking header > rows reorder > clicks again > reverses.
2. Seller exports CSV > opens in Excel > special characters intact, no formula injection.
3. Seller closes form with unsaved changes > custom discard confirmation appears.
4. Seller navigates to `#keyword-settings` URL > Keyword Settings loads directly.

# Connected Work Items

**Blocks:** [PROD-4124](https://keplercommerce.atlassian.net/browse/PROD-4124), [PROD-4125](https://keplercommerce.atlassian.net/browse/PROD-4125), [PROD-4126](https://keplercommerce.atlassian.net/browse/PROD-4126) (all depend on table infrastructure)
**Relates To:** All stories. Every view uses these shared patterns.

# Implementation Notes

- Existing table implementations in `client/src/app/features/amazon-ads/campaign-management/` serve as reference for the shared component.
- Existing date picker: `sp-rangepicker` component in portal. Rebuild with presets.
- CSV export pattern: standardize existing `downloadCampaignFile()`, `downloadSearchTermsAggregatedFile()` into shared `exportTableToCSV()` utility.
- File upload: `apps/amazon_ads/api/views/file_views.py` handles all 7 strategies server-side. Frontend needs drag-and-drop UI + validation feedback.
- Export endpoints: `GET /amazon-ads/ad-campaign/export/`, `GET /amazon-ads/keywords-config/export/`, `POST /amazon-ads/search-terms/aggregated/export/`, `GET /amazon-ads/keyword-branding-scope/export/`, `GET /amazon-ads/bid-strategy-logs/export/`, and others.
- Theme variables already defined in prototype CSS. Port directly.
- Hash routing: listen for `hashchange`, map hash to view IDs, update on `navigate()`.
- **Sequencing: this ticket must ship before PROD-4124, PROD-4125, and PROD-4126.** Those stories depend on the shared table, export, and modal patterns built here.

**Related enhancement stories:** [PROD-4449](https://keplercommerce.atlassian.net/browse/PROD-4449) (Advanced Table Features), [PROD-4450](https://keplercommerce.atlassian.net/browse/PROD-4450) (Advanced Import/Export).

# Out of Scope

- Backend API design or data layer architecture
- Mobile-responsive layouts (desktop-first this phase)
- Internationalization beyond English

# Test Cases

1. Seller sorts table by column. Rows reorder. Click again reverses.
2. Table with no matching filters. Empty state message displays.
3. Seller exports CSV. Opens in Excel with special characters intact.
4. Seller imports malformed CSV. Validation error with row/column details.
5. Seller closes form with unsaved changes. Discard confirmation appears.
6. Keyboard-only user navigates portal. All buttons, toggles, menus accessible.
7. Screen reader user opens modal. Focus moves to modal, "dialog" role announced.
8. Seller switches to dark mode. All elements adapt.
9. Seller navigates to `#keyword-settings` URL. View loads directly.

# Acceptance Criteria

- [ ] All 17+ tables support sorting, filtering, pagination, empty states, column visibility
- [ ] Sticky headers and frozen columns work for scrolling
- [ ] CSV exports include UTF-8 BOM and sanitize formula injection
- [ ] Import validates format with row-level error details
- [ ] Custom confirmation modals replace browser confirm() dialogs
- [ ] Discard guard on forms with unsaved changes
- [ ] Date picker with 5 presets used across all date range controls
- [ ] Toast notifications for all user actions
- [ ] Dark mode and all light themes render correctly
- [ ] All interactive elements keyboard accessible with ARIA roles
- [ ] URL hash routing with browser back/forward and deep linking
- [ ] Tests passed (unit + integration)
- [ ] UI matches prototype

Prototype: https://mmaazhanif22.github.io/kepler-ads-design/ads-only.html
