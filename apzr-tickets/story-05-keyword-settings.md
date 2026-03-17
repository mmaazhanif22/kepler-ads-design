# Keyword Settings — Full Portal Parity with Enhancements

## User Story

As a seller, I want a comprehensive Keyword Settings view with all data columns from the portal organized in logical groups, including time-series performance data, so that I can manage keyword bids, analyze performance across time periods, and make informed optimization decisions.

## Problem / Context

- The current portal has 72 columns in the Keyword Settings table organized across 10 groups — any new UI must preserve full data access
- Sellers need bid configuration data (current bid, previous bid, bid changes, sync status) alongside time-series performance data (Ad Cost, Sales, ACOS, Clicks across 1d/3d/7d/15d/30d/90d/180d periods)
- Without column grouping, 72+ columns become unmanageable — sellers need logical groups with visual separation
- Sellers need to toggle column visibility to focus on the data most relevant to their workflow
- Bulk import/export of keyword settings is essential for sellers managing thousands of keywords

## Solution Outline

**Column Groups (10 groups matching portal):**

1. **Identity** — Keyword, ASIN, Campaign, Ad Group, Match Type, Branding Scope, Relationship
2. **Market Intelligence** — Search Volume, Organic Rank (Avg/Median), Sponsored Rank, Keyword Clicks
3. **Competitive Data** — Bid Suggestion (Min/Median/Max), Competitors on KW
4. **Bid Configuration** — Current Bid, Previous Bid, Bid Change (delta), Amazon Previous Bid, Amazon Current Bid, Amazon Bid Delta, Bid Analysis, Applied Target ACOS, Applied ACOS, Applied CVR, Last Bid Sent Date, Bid Sync Status, Bid Sync Last Update, Amazon Status, Applied ACOS Date Range, Applied TOS%, Applied Ad Spend, Applied Ad Sales, Applied Clicks
5. **Ad Cost** — 7 columns: Ad Cost for 1d, 3d, 7d, 15d, 30d, 90d, 180d
6. **Ad Sales** — 7 columns: Ad Sales for 1d, 3d, 7d, 15d, 30d, 90d, 180d
7. **ACOS** — 7 columns: ACOS for 1d, 3d, 7d, 15d, 30d, 90d, 180d
8. **TOS%** — 7 columns: Top of Search percentage for 1d, 3d, 7d, 15d, 30d, 90d, 180d
9. **Ad Clicks** — 7 columns: Ad Clicks for 1d, 3d, 7d, 15d, 30d, 90d, 180d
10. **Additional Metrics** — Ad CTR (7 periods), Ad Orders (7 periods), Ad CVR (7 periods) + System Remarks, User Remarks, Harvested Date

**Group Header Row:**
- Visual group headers with colored backgrounds spanning each column group
- Groups are collapsible to reduce horizontal scrolling

**Column Visibility Toggle:**
- "Columns" button opens a dropdown checklist
- Sellers can show/hide any column or entire column groups
- Visibility preferences persist per user

**Table Features:**
- Sortable columns (click header to sort ascending/descending)
- Column filtering per column
- Sticky first 2 columns (Keyword + ASIN) for horizontal scrolling
- Pagination with configurable page size (25/50/100 rows)
- Editable cells for bid values (pencil icon on hover)
- Reset filters button

**Bulk Import/Export:**
- Export: Download template (15 columns matching portal import format) or Filtered Report (all visible columns)
- Import: Upload CSV with bid changes, match type updates, or status changes
- Import history accessible via "History" link
- All exports include UTF-8 BOM for Excel compatibility

**UI Requirements:**
- Mockup: [Prototype — Keyword Settings](http://localhost:8765/Advertising%20Portal%20UI%20Design.html) (navigate to Ads Management > Keyword Settings)
- Group headers use alternating light-colored backgrounds for visual separation
- Horizontal scrolling is smooth with frozen first 2 columns
- Editable cells show pencil icon on hover, inline editing on click

## Connected Work Items

**Blocks:** None
**Is Blocked By:** Story 1 (Wizard) — keywords are created during wizard setup; Story 9 (UX Infrastructure) — table component patterns
**Relates To:** Story 6 (Search Term Settings) — similar table structure; Story 1 (Wizard) — wizard Step 6 links to Keyword Settings post-setup

✅ Keyword Settings depends on the table infrastructure from Story 9 and keyword data created by the wizard.

## Implementation Notes

- Time-series data comes from Amazon Advertising API aggregated over the specified periods
- Bid Sync Status reflects whether the last bid change has been pushed to Amazon
- Applied metrics show the actual values used in the last bid optimization cycle
- Column groups should use a two-row header: group name (top), individual column names (bottom)
- All 72+ columns must be present even if some are hidden by default
- Export must respect current column visibility and filter state

## Out of Scope

- Search term management (covered by Story 6)
- Bid optimization logic or automatic bid changes (covered by Story 8)
- Keyword research and discovery (covered by Story 7)
- Real-time bid change propagation to Amazon (backend concern)

## Test Cases

- Seller opens Keyword Settings — table loads with all column groups visible, group headers displayed
- Seller toggles "Ad CTR" group off — all 7 Ad CTR columns hide, other groups unaffected
- Seller sorts by "ACOS 7d" — rows reorder by 7-day ACOS value
- Seller edits a bid value — inline edit activates, new value saved on confirm
- Seller scrolls horizontally — Keyword and ASIN columns remain frozen/sticky
- Seller exports "Filtered Report" — CSV includes only visible columns with current filter applied
- Seller imports a CSV with bid changes — system validates format and applies changes
- Table shows 1,000+ keywords — pagination works with 25/50/100 page size options
- Seller resets filters — all filters cleared, full dataset visible

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
