# Search Term Settings (Story A): Active Search Terms Table

## User Story

As a seller, I want a comprehensive Active Search Terms table with all 105 data columns from the portal organized in logical groups, including time-series performance data, so that I can review search term performance across time periods and identify terms that need action.

## Problem / Context

- The portal's Search Term Settings has 105 columns across 10 groups. Any new UI must provide full data access.
- Search term management involves reviewing active terms with performance data to identify trends and outliers.
- Time-series performance data (same 8 metrics across 7 periods as Keyword Settings) is needed to evaluate search term trends.
- Without column grouping, 105+ columns become unmanageable. Sellers need the same grouped header pattern as Keyword Settings.

## Existing vs. Net-New

| Area | Status | Notes |
|------|--------|-------|
| 105 data columns | EXISTS (rebuild) | All 105 columns exist in the current portal's Search Term Settings page. Rebuild with grouped headers, sticky columns, and column visibility toggles. |
| Column grouping UI | NEW | Current portal has flat column headers. New grouped header row with collapsible sections. |
| Bid data columns | EXISTS (rebuild) | Suggested bid data exists. Rebuild as separate columns (not combined). |
| Bulk import/export | EXISTS (rebuild) | Export via `POST /amazon-ads/search-terms/aggregated/export/`. Rebuild with template vs. filtered report modes. |

## Solution Outline

**Active Search Terms Table (matching portal 105 columns):**
- Column groups mirror Keyword Settings structure:
  - Identity (Search Term, ASIN, Campaign, Ad Group, Match Type)
  - Market Intelligence (Search Volume, Organic Rank Avg, Organic Rank Median, Sponsored Rank, KW Clicks)
  - Amazon Recommendations (Avg Amazon Recommended Rank, Median Amazon Recommended Rank)
  - Bid Data (Suggested Bid Min, Suggested Bid Median, Suggested Bid Max, Current Bid, Bid actions)
  - 8 time-series groups (Ad Cost, Ad Sales, ACOS, TOS%, Ad Clicks, Ad CTR, Ad Orders, Ad CVR) each with 7 periods (1d, 3d, 7d, 15d, 30d, 90d, 180d)
- Group headers with colored backgrounds matching Keyword Settings.
- Organic Rank and Bid Suggestion shown as separate columns (not combined).

**Table Features (same as Keyword Settings):**
- Column visibility toggle with group-level show/hide.
- Sortable, filterable, paginated (25/50/100 rows).
- Sticky first 2 columns (Search Term + ASIN).
- Editable cells where applicable.
- Reset filters button.
- Bulk import/export with UTF-8 BOM and import history.

**UI Requirements:**
- Mockup: [Prototype: Search Term Settings](https://mmaazhanif22.github.io/kepler-ads-design/ads-only.html) (navigate to Manage Ads > Search Term Settings)
- Sub-tab navigation at the top of the view. Active Search Terms is the default tab.
- Same group header and column styling as Keyword Settings for visual consistency.

## Sub-Tasks

| # | Sub-Task | Exists / New | Backend Reference |
|---|----------|-------------|-------------------|
| 1 | **105-column table with 10+ grouped headers**, sticky first 2 columns, collapsible groups | EXISTS (rebuild) | `GET /amazon-ads/search-terms/` returns all search term data. Column groups are UI-only. |
| 2 | **Column visibility toggle** with per-column and per-group show/hide | NEW | No backend dependency. Client-side (localStorage). |
| 3 | **Bulk export** with template and filtered report modes | EXISTS (rebuild) | `POST /amazon-ads/search-terms/aggregated/export/` for CSV export. |
| 4 | **Sub-tab shell** rendering Active Search Terms as default tab, with tab slots for Story 6B tabs | NEW | No backend dependency. Client-side tab routing. |

## Backend References

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/amazon-ads/search-terms/` | GET | Retrieve all search terms with 105+ columns |
| `/amazon-ads/search-terms/aggregated/export/` | POST | Export search term data as CSV |
| `/amazon-ads/upload-file` (type=search-term-config) | POST | Import search term config CSV |
| `/analytics/search_terms/asin_terms` | GET | ASIN-level search term data |
| `/analytics/search_terms/asin_autocomplete` | GET | Search term autocomplete |

## Connected Work Items

**Blocks:** None.
**Is Blocked By:** Story 1 (Wizard), search terms are generated from campaign activity. Story 9 (UX Infrastructure), table patterns.
**Relates To:** Story 6B (Search Term Workflow Tabs), which adds Harvest Queue, Negative Keywords, and High Performers tabs. Story 5 (Keyword Settings), same table structure and column patterns.

Search Term Settings follows the same table patterns as Keyword Settings. Development of both can be parallelized.

## Implementation Notes

- Time-series data sourced from the same advertising data pipeline as Keyword Settings.
- Column groups must match Keyword Settings visual pattern for consistency.
- Organic Rank split: "Avg. Organic Rank" and "Median Organic Rank" as separate columns.
- The sub-tab shell must support the 3 additional tabs from Story 6B (Harvest Queue, Negative Keywords, High Performers).

## Out of Scope

- Harvest Queue, Negative Keywords, and High Performers tabs (covered by Story 6B)
- Keyword-level bid management (covered by Story 5)
- Automated harvesting rules (backend automation)
- Search term data collection from Amazon (backend data pipeline)

## Test Cases

- Seller opens Search Term Settings. Active Search Terms tab loads as default with all column groups.
- Column groups show separately: Avg Organic Rank and Median Organic Rank as individual columns.
- Seller toggles off "TOS%" column group. All 7 TOS% period columns hide.
- Seller sorts by "Ad Cost 30d". Rows reorder correctly.
- Seller scrolls horizontally. Search Term and ASIN columns remain frozen.
- Export includes all visible columns for the current tab.
- Table shows 2,000+ search terms. Pagination works with 25/50/100 page size options.

## Acceptance Criteria

- [ ] Active Search Terms table has 105+ columns organized in 10+ named groups
- [ ] Time-series columns (8 metrics x 7 periods) match the Keyword Settings pattern
- [ ] Organic Rank and Bid Suggestion data shown as separate columns (not combined)
- [ ] Column visibility, sorting, filtering, pagination, and export work consistently
- [ ] Sticky first 2 columns (Search Term + ASIN) during horizontal scroll
- [ ] Sub-tab shell supports additional tabs from Story 6B
- [ ] Tests passed (unit + integration)
- [ ] UI matches approved mockup
