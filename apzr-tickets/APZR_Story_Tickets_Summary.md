# APZR Story Tickets — Advertising UI/UX Revamp

**Epic:** PROD-2180 (UI/UX Modernization & Redesign)
**Task:** PROD-3983 (Write APZR Requirement Tickets)
**Date:** March 6, 2026

---

## PROD-4120 — ASIN Advertising Setup Wizard — 6-Step Guided Flow

**User Story:** As a seller, I want a guided step-by-step wizard that walks me through the complete ASIN advertising setup, so that I can configure and launch ad campaigns for any product without needing to understand the full advertising system upfront.

**Solution Summary:**
- 6-step modal wizard: Product & Global Settings, Competitor Research, Auto Keyword Research, Keyword Review, Campaign Configuration, Launch Summary
- Step 1: ASIN selection, Target ACOS (required), optional Auto Pacing and Bid Ceiling
- Step 3: Auto-triggers keyword research with progress indicator, auto-advances to Step 4
- Step 5: 16 pre-built campaigns in 3 sections (8 SPKW, 4 SPAU, 4 SPAS)
- Negative Keywords section with scope selector (All/Manual/Auto/PT)
- Listing Quality Score panel with gauge and per-dimension bars
- Step 6: Launch summary with pre-launch checklist, amber indicators for skipped items
- Wizard Edit Mode for previously launched ASINs with pre-populated data
- Campaign names follow Kepler naming convention (system-generated, not editable)
- Accessible: screen reader announces step changes, focus management on open/close
- Discard confirmation when closing wizard with unsaved changes

**Connected Work Items:**
- Blocks: Story 5 (KW Settings), Story 6 (ST Settings)
- Is Blocked By: None (foundational entry point)
- Relates To: Story 2 (IBO), Story 3 (ASIN Overview)

---

## PROD-4121 — Intelligent Batch Orchestrator (IBO) — Bulk ASIN Launch

**User Story:** As a seller with a large catalog, I want to launch advertising campaigns for multiple ASINs simultaneously with AI-powered grouping and unified campaign activation, so that I can scale my advertising setup from one ASIN at a time to dozens in a single workflow.

**Solution Summary:**
- 6-stage progressive workflow for bulk ASIN launch
- Stage 1 — Mission Setup & AI Grouping: paste or import ASINs, system auto-groups by product type, brand, price band. AI handles bundles, singletons, price outliers, size splits. Each group card shows plain-language grouping reason
- Stage 2 — Per-Group Configuration: tab selector per group, Tier 1 (category) and Tier 2 (per-ASIN) competitors, KW Research Approval Mode toggle (Auto-Approve skips Stage 4)
- Stage 3 — Async Parallel Processing: real-time per-ASIN progress cards, activity log stream
- Stage 4 — Review Hub: KW review and approval, bulk actions toolbar (export/import spreadsheet, bulk approve)
- Stage 5 — Campaign Configuration: NB/OBH/CB color-coded rows, Kepler naming convention (locked), negative keywords with scope selector, outlier flagging
- Stage 6 — Launch Confirmation: single Launch All button, pre-launch checklist, launch date picker
- Batch History: auto-save after each stage, resume any saved batch, delete old ones
- Bulk CSV import supports 20+ ASINs with template download

**Connected Work Items:**
- Blocks: None
- Is Blocked By: None (independent of wizard)
- Relates To: Story 1 (Wizard), Story 3 (ASIN Overview), Story 5 (KW Settings), Story 6 (ST Settings)

---

## PROD-4122 — Ads Management — ASIN Overview & Navigation Restructure

**User Story:** As a seller, I want a unified ASIN Overview as my default landing page in the advertising section, so that I can see every product's advertising status at a glance and quickly access any configuration action without navigating through multiple tabs.

**Solution Summary:**
- Sidebar restructure: rename "Campaign Management" to "Ads Management", reduce 7 sub-items to 4 (ASIN Overview, Campaign Config, Keyword Settings, Search Term Settings)
- ASIN Overview table: ASIN, product name, setup status badge, ads on/off toggle, campaign count, budget, Target ACOS
- Setup Status Checklist: click badge to see 6 wizard steps with completion state, Resume buttons for incomplete steps
- Actions Dropdown per ASIN: quick navigation to Competitors, KW Research, Campaign Config, Launch Settings, Keyword Settings (filtered), Search Term Settings (filtered)
- Ads toggle works instantly without page reload
- Color-coded status badges: green (Complete), amber (In Progress), gray (Not Started)
- Original 7 Campaign Management views accessible from ASIN Overview actions menu

**Connected Work Items:**
- Blocks: None
- Is Blocked By: Story 1 (Wizard)
- Relates To: Story 1 (Wizard), Story 2 (IBO)

---

## PROD-4123 — Advertising Dashboards & Performance Intelligence

**User Story:** As a seller, I want intelligent dashboards with KPI cards, trend visualizations, AI recommendations, and budget pacing indicators, so that I can monitor advertising performance and take action on optimization opportunities without manually analyzing data.

**Solution Summary:**
- 10 KPI cards in 5x2 grid: Spend, Sales, ACOS, Impressions, Clicks, CTR, Orders, CVR, ROAS, and selectable metric. Each with current value, trend arrow, percentage change, and 7-day sparkline
- Date range presets: 7D, 14D, 30D, 60D, 90D with custom range picker
- 3 AI Recommendation cards: Bid Opportunity, Negative Keyword Suggestion, Budget Reallocation. Each with Apply and Dismiss buttons
- Budget Pacing card: 3 campaigns with spend progress bars and status labels (On Track, Warning, Maxed)
- Listing Quality Score panel: circular gauge (0-100) with per-dimension bars (Title, Bullets, Images, Description, Backend Keywords)
- Notification Bell: unread count badge, dropdown with recent notifications (budget alerts, KW suggestions, status changes)
- Skeleton loading with shimmer effect, respects reduced-motion preference
- Sparklines and charts adapt to dark/light theme

**Connected Work Items:**
- Blocks: None
- Is Blocked By: None
- Relates To: Story 5 (KW Settings), Story 6 (ST Settings), Story 8 (Pacing)

---

## PROD-4124 — Keyword Settings — Full Portal Parity with Enhancements

**User Story:** As a seller, I want a comprehensive Keyword Settings view with all data columns from the portal organized in logical groups, including time-series performance data, so that I can manage keyword bids, analyze performance across time periods, and make informed optimization decisions.

**Solution Summary:**
- 72+ columns in 10 named groups with colored visual group headers:
  1. Identity (7 cols): Keyword, ASIN, Campaign, Ad Group, Match Type, Branding Scope, Relationship
  2. Market Intelligence (5 cols): Search Volume, Organic Rank Avg/Median, Sponsored Rank, KW Clicks
  3. Competitive Data (4 cols): Bid Suggestion Min/Median/Max, Competitors on KW
  4. Bid Configuration (19 cols): Current/Previous Bid, Bid Delta, Amazon bids, Bid Analysis, Applied metrics, Sync Status, Amazon Status
  5. Ad Cost (7 cols): 1d, 3d, 7d, 15d, 30d, 90d, 180d
  6. Ad Sales (7 cols): 1d, 3d, 7d, 15d, 30d, 90d, 180d
  7. ACOS (7 cols): 1d, 3d, 7d, 15d, 30d, 90d, 180d
  8. TOS% (7 cols): 1d, 3d, 7d, 15d, 30d, 90d, 180d
  9. Ad Clicks (7 cols): 1d, 3d, 7d, 15d, 30d, 90d, 180d
  10. Additional Metrics: Ad CTR, Ad Orders, Ad CVR (7 periods each) + System Remarks, User Remarks, Harvested Date
- Column visibility toggle: show/hide individual columns or entire groups
- Frozen first 2 columns (Keyword + ASIN) during horizontal scroll
- Inline bid editing with pencil icon on hover
- Bulk export: Template (15 cols) or Filtered Report (visible cols) with UTF-8 BOM
- Bulk import with validation and import history
- Pagination: 25/50/100 rows with reset filters button

**Connected Work Items:**
- Blocks: None
- Is Blocked By: Story 1 (Wizard), Story 9 (UX Infrastructure)
- Relates To: Story 6 (ST Settings), Story 1 (Wizard)

---

## PROD-4125 — Search Term Settings — Full Portal Parity with Enhancements

**User Story:** As a seller, I want a comprehensive Search Term Settings view with multiple sub-tabs for active terms, harvest queue, negative keywords, and high performers, so that I can manage the full search term lifecycle from discovery through optimization.

**Solution Summary:**
- 4 Sub-Tabs: Active Search Terms, Harvest Queue, Negative Keywords, High Performers
- Active Search Terms: 105+ columns in 10+ groups mirroring Keyword Settings structure
  - Identity, Market Intelligence, Amazon Recommendations, Bid Data
  - 8 time-series groups (Ad Cost, Sales, ACOS, TOS%, Clicks, CTR, Orders, CVR) x 7 periods (1d-180d)
  - Organic Rank and Bid Suggestion as separate columns (not combined)
- Harvest Queue: search terms meeting harvest criteria (3+ conversions, ACOS below target), bulk harvest action
- Negative Keywords: underperforming terms with scope selector (All/Manual/Auto/PT)
- High Performers: top-converting terms with conversion count, ACOS, revenue attribution
- Same table features as Keyword Settings: column visibility, sorting, filtering, pagination, frozen columns, bulk import/export
- Active tab shows item count (e.g., "Harvest Queue (12)")

**Connected Work Items:**
- Blocks: None
- Is Blocked By: Story 1 (Wizard), Story 9 (UX Infrastructure)
- Relates To: Story 5 (KW Settings), Story 1 (Wizard)

---

## PROD-4126 — Campaign Management, Keyword Research & Branding Scope

**User Story:** As a seller, I want to view and manage my campaigns, research new keywords, and classify keyword brand relationships, so that I can maintain full control over campaign structure, discover growth opportunities, and ensure proper brand targeting.

**Solution Summary:**
- Campaign List Table (20 columns): 13 portal columns (Campaign Name, ASIN, Type, Match Type, Status, Daily Budget, Target ACOS, Bid Strategy, Start/End Date, Keywords Count, Ad Group Count, Portfolio) + 7 enhancements (Pacing Status, Spend, Sales, ACOS, Impressions, Clicks, Match Type filter). Bulk status toggle
- Campaign Config Table (10 columns): Campaign, ASIN, Budget, Target ACOS, Bid Strategy, Placement Adjustments, Negative Keywords, Status, Created/Modified Date. Inline editable. Bulk import/export with 9-column portal template
- Keyword Research (16 visible + 10 hidden columns): visible columns include Keyword, Search Volume, Organic Rank, Sponsored Rank, Competition Level, CPR, Bid Suggestion, Relevancy, Word Count, Title Density. Hidden Jungle Scout columns: JS Search Volume (Broad), JS Organic/Sponsored ASIN Count, JS Ease of Ranking, JS Relevancy Score, JS PPC Bids, JS SP Brand Ad Bid, JS Recommended Promotions, JS Last Updated. "Columns" toggle button. "Run KW Research" disabled without ASIN setup
- Branding Scope: Keyword, Branding Scope (NB/OB/CB), Relationship (N/R/S/C), Logs, Actions. Inline editable dropdowns. Classifications drive campaign naming convention

**Connected Work Items:**
- Blocks: None
- Is Blocked By: Story 1 (Wizard), Story 3 (ASIN Overview)
- Relates To: Story 5 (KW Settings), Story 2 (IBO)

---

## PROD-4127 — Pacing Management, Bid Optimization & Config Change Log

**User Story:** As a seller, I want dedicated views for budget pacing control, bid optimization monitoring, and a comprehensive change log, so that I can ensure campaigns stay within budget, track how bids are being optimized, and audit all configuration changes.

**Solution Summary:**
- Pacing Management: all campaigns with daily budget, current spend, pacing percentage, and status (On Track green, Warning amber, Paused gray, Maxed red). Auto Pacing enable/disable controls. "Generate Simulation Report" button (enabled after 14+ days of data)
- Bid Optimization: keyword-level bid changes with Keyword, ASIN, Campaign, Previous Bid, Current Bid, Bid Delta, ACOS, Target ACOS, Optimization Reason. Filter by date range, campaign, bid direction
- Config Change Log: aggregated human-readable events (NOT raw database mutations). Event types: Bid Increased/Decreased, Keyword Harvested, Negative KW Added, Budget Updated, Status Changed, Target ACOS Updated. Each event: timestamp, type, ASIN, campaign, old/new value, source (manual/automated). Filterable by event type, ASIN, campaign, date range
- Analytics Views: ASIN-level performance, targeting dashboard, search term dashboard. Date range presets (7D-90D)

**Connected Work Items:**
- Blocks: None
- Is Blocked By: Story 1 (Wizard)
- Relates To: Story 4 (Dashboards), Story 5 (KW Settings)

---

## PROD-4128 — UX Infrastructure & Accessibility — Shared Patterns

**User Story:** As a seller, I want the advertising portal to have consistent, accessible, and performant UI patterns across all views — including sortable/filterable/paginated tables, CSV exports/imports, date pickers, confirmation dialogs, and theme support — so that I can work efficiently regardless of which section I'm in.

**Solution Summary:**
- Table Infrastructure (17+ tables): universal sorting (267+ columns), pagination (25/50/100 rows), empty states, column visibility toggle, sticky headers, frozen first 2 columns, Reset Filters on every table, editable cells with pencil icon
- CSV Export/Import: UTF-8 BOM for Excel, formula injection sanitization (escape =, +, -, @), export respects filters and column visibility, import with validation and error reporting, Import History on all 7 import sections, template downloads per table, KW Settings export dropdown (Template vs. Filtered Report)
- Confirmation Modals: custom styled (not browser native), danger variant for destructive actions, discard guard on forms with unsaved changes (5 touchpoints)
- Date Picker: unified range picker, preset buttons (7D, 14D, 30D, 60D, 90D), custom range, min/max boundaries
- Toast Notifications: 4 variants (success green, error red, warning amber, info blue), auto-dismiss, stacking support
- Theme Support: dark mode + 5 light themes, all UI adapts via CSS custom properties, theme-aware chart/badge/gradient colors
- Accessibility (WCAG): keyboard navigation for all interactive elements, screen reader announcements for dynamic changes, role="dialog" and aria-modal on modals, role="switch" and aria-checked on toggles, aria-hidden on decorative elements, reduced-motion support, focus management on modal open/close
- URL Hash Routing: direct navigation via hash, browser back/forward support, hash updates on navigation

**Connected Work Items:**
- Blocks: Story 5 (KW Settings), Story 6 (ST Settings), Story 7 (Campaigns & KW Research)
- Is Blocked By: None (foundational infrastructure)
- Relates To: All stories

---

## Dependency Map

```
Story 9 (UX Infrastructure) ──blocks──> Stories 5, 6, 7
Story 1 (Wizard) ──blocks──> Stories 5, 6, 7, 8
Story 3 (ASIN Overview) ──blocked by──> Story 1
Stories 2, 4 ──independent──> can be built in parallel
```

**Recommended Build Order:**
1. Story 9 (UX Infrastructure) — foundational, unblocks 3 stories
2. Story 1 (Wizard) — foundational, unblocks 4 stories
3. Stories 2, 3, 4 — can be parallelized
4. Stories 5, 6, 7 — depend on Stories 1 and 9
5. Story 8 — depends on Story 1
