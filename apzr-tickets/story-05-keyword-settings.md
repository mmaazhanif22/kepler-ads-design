# Keyword Settings: Full Portal Parity with Enhancements

## User Story

As a seller, I want a comprehensive Keyword Settings view with all data columns from the portal organized in logical groups, including time-series performance data, so that I can manage keyword bids, analyze performance across time periods, and make informed optimization decisions.

## Problem / Context

- The current portal has 72 columns in the Keyword Settings table organized across 10 groups. Any new UI must preserve full data access.
- Sellers need bid configuration data (current bid, previous bid, bid changes, sync status) alongside time-series performance data (Ad Cost, Sales, ACOS, Clicks across 1d/3d/7d/15d/30d/90d/180d periods).
- Without column grouping, 72+ columns become unmanageable. Sellers need logical groups with visual separation.
- Sellers need to toggle column visibility to focus on the data most relevant to their workflow.
- Bulk import/export of keyword settings is essential for sellers managing thousands of keywords.

## Existing vs. Net-New

| Area | Status | Notes |
|------|--------|-------|
| 72 data columns | EXISTS (rebuild) | All 72 columns exist in the current portal's KWs Config page (Product Walkthrough Section 11). Rebuild with grouped headers, sticky columns, and column visibility toggles. |
| Column grouping UI | NEW | Current portal has flat column headers. New grouped header row with collapsible sections. |
| Editable bid cells | EXISTS (rebuild) | Bid editing exists. Rebuild with pencil icon on hover and inline editing pattern. |
| Bulk import/export | EXISTS (rebuild) | Import via `POST /amazon-ads/upload-file` type=k-config. Export via `GET /amazon-ads/keywords-config/export/`. Rebuild with template vs. filtered report modes. |

**Reference:** Currently on KWs Config page (Product Walkthrough Section 11).

## Solution Outline

**Column Groups (10 groups matching portal):**

1. **Identity**: Keyword, ASIN, Campaign, Ad Group, Match Type, Branding Scope, Relationship
2. **Market Intelligence**: Search Volume, Organic Rank (Avg/Median), Sponsored Rank, Keyword Clicks
3. **Competitive Data**: Bid Suggestion (Min/Median/Max), Competitors on KW
4. **Bid Configuration**: Current Bid, Previous Bid, Bid Change (delta), Amazon Previous Bid, Amazon Current Bid, Amazon Bid Delta, Bid Analysis, Applied Target ACOS, Applied ACOS, Applied CVR, Last Bid Sent Date, Bid Sync Status, Bid Sync Last Update, Amazon Status, Applied ACOS Date Range, Applied TOS%, Applied Ad Spend, Applied Ad Sales, Applied Clicks
5. **Ad Cost**: 7 columns (1d, 3d, 7d, 15d, 30d, 90d, 180d)
6. **Ad Sales**: 7 columns (1d, 3d, 7d, 15d, 30d, 90d, 180d)
7. **ACOS**: 7 columns (1d, 3d, 7d, 15d, 30d, 90d, 180d)
8. **TOS%**: 7 columns (1d, 3d, 7d, 15d, 30d, 90d, 180d)
9. **Ad Clicks**: 7 columns (1d, 3d, 7d, 15d, 30d, 90d, 180d)
10. **Additional Metrics**: Ad CTR (7 periods), Ad Orders (7 periods), Ad CVR (7 periods) + System Remarks, User Remarks, Harvested Date

**Group Header Row:**
- Visual group headers with colored backgrounds spanning each column group.
- Groups are collapsible to reduce horizontal scrolling.

**Column Visibility Toggle:**
- "Columns" button opens a dropdown checklist.
- Sellers can show/hide any column or entire column groups.
- Visibility preferences persist per user.

**Table Features:**
- Sortable columns (click header to sort ascending/descending).
- Column filtering per column.
- Sticky first 2 columns (Keyword + ASIN) for horizontal scrolling.
- Pagination with configurable page size (25/50/100 rows).
- Editable cells for bid values (pencil icon on hover).
- Reset filters button.

**Bulk Import/Export:**
- Export: Download template (15 columns matching portal import format) or Filtered Report (all visible columns).
- Import: Upload CSV with bid changes, match type updates, or status changes.
- Import history accessible via "History" link.
- All exports include UTF-8 BOM for Excel compatibility.

**UI Requirements:**
- Mockup: [Prototype: Keyword Settings](https://mmaazhanif22.github.io/kepler-ads-design/ads-only.html) (navigate to Manage Ads > Keyword Settings)
- Group headers use alternating light-colored backgrounds for visual separation.
- Horizontal scrolling is smooth with frozen first 2 columns.
- Editable cells show pencil icon on hover, inline editing on click.

## Sub-Tasks

| # | Sub-Task | Exists / New | Backend Reference |
|---|----------|-------------|-------------------|
| 1 | **72-column table with 10 grouped headers**, sticky first 2 columns, collapsible groups | EXISTS (rebuild) | `GET /amazon-ads/keywords-config/` returns all 72 columns. Column groups are UI-only organization. |
| 2 | **Column visibility toggle** with per-column and per-group show/hide, persisted preferences | NEW | No backend dependency. Preferences stored client-side (localStorage). |
| 3 | **Inline bid editing** with pencil icon on hover, validation, and save confirmation | EXISTS (rebuild) | `PUT /amazon-ads/keywords-config/` for single keyword update. `AdvertisingCampaignConfigService.bulk_update()` for batch. |
| 4 | **Bulk import/export** with template download, filtered report export, import validation, and history | EXISTS (rebuild) | Import: `POST /amazon-ads/upload-file` type=k-config. Export: `GET /amazon-ads/keywords-config/export/`. History: import records from upload-file responses. |

## Backend References

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/amazon-ads/keywords-config/` | GET | Retrieve all keywords with 72+ columns of data |
| `/amazon-ads/keywords-config/` | PUT | Update keyword config (bid, status, match type) |
| `/amazon-ads/keywords-config/export/` | GET/POST | Export keyword config as CSV |
| `/amazon-ads/upload-file` (type=k-config) | POST | Import keyword config CSV |
| `/amazon-ads/keyword-bid-status/{id}/` | GET | Bid recommendations and sync status per keyword |
| `AdvertisingCampaignConfigService.bulk_update()` | Service | Bulk keyword config updates |

**Data Sources:**
- Time-series data (Ad Cost, Sales, ACOS, TOS%, Clicks, CTR, Orders, CVR) aggregated from Amazon Advertising API over 7 periods.
- Bid Sync Status reflects whether the last bid change has been pushed to Amazon.
- Applied metrics show actual values used in the last bid optimization cycle.

## Connected Work Items

**Blocks:** None.
**Is Blocked By:** Story 1 (Wizard), keywords are created during wizard setup. Story 9 (UX Infrastructure), table component patterns.
**Relates To:** Story 6 (Search Term Settings), similar table structure. Story 1 (Wizard), wizard Step 5 links to Keyword Settings post-setup.

Keyword Settings depends on the table infrastructure from Story 9 and keyword data created by the wizard.

## Implementation Notes

- Time-series data comes from Amazon Advertising API aggregated over the specified periods.
- Bid Sync Status reflects whether the last bid change has been pushed to Amazon.
- Applied metrics show the actual values used in the last bid optimization cycle.
- Column groups should use a two-row header: group name (top), individual column names (bottom).
- All 72+ columns must be present even if some are hidden by default.
- Export must respect current column visibility and filter state.

## Out of Scope

- Search term management (covered by Story 6)
- Bid optimization logic or automatic bid changes (covered by Story 8B)
- Keyword research and discovery (covered by Story 7B)
- Real-time bid change propagation to Amazon (backend concern)

## Test Cases

- Seller opens Keyword Settings. Table loads with all column groups visible, group headers displayed.
- Seller toggles "Ad CTR" group off. All 7 Ad CTR columns hide, other groups unaffected.
- Seller sorts by "ACOS 7d". Rows reorder by 7-day ACOS value.
- Seller edits a bid value. Inline edit activates, new value saved on confirm.
- Seller scrolls horizontally. Keyword and ASIN columns remain frozen/sticky.
- Seller exports "Filtered Report". CSV includes only visible columns with current filter applied.
- Seller imports a CSV with bid changes. System validates format and applies changes.
- Table shows 1,000+ keywords. Pagination works with 25/50/100 page size options.
- Seller resets filters. All filters cleared, full dataset visible.

## Acceptance Criteria

- [ ] 72+ columns organized in 10 named groups with visual group headers
- [ ] Time-series columns (Ad Cost, Sales, ACOS, TOS%, Clicks, CTR, Orders, CVR) available for 7 time periods each
- [ ] Column visibility toggle allows showing/hiding individual columns or entire groups
- [ ] First 2 columns (Keyword + ASIN) remain frozen during horizontal scroll
- [ ] Bid values are editable inline with pencil icon on hover
- [ ] Export supports both template download and filtered report with UTF-8 BOM
- [ ] Import accepts CSV with validation and shows import history
- [ ] Table supports sorting, filtering, pagination (25/50/100 rows), and reset filters
- [ ] Tests passed (unit + integration)
- [ ] UI matches approved mockup
