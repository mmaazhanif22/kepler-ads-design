# Keyword Settings

# User Story

As a seller, I want a comprehensive Keyword Settings view with all 72 portal columns organized in logical groups so that I can manage keyword bids and analyze time-series performance data efficiently.

# Problem / Context

- The current portal KWs Config page (Section 11) has 72 columns across 10 groups. Any new UI must preserve full data access.
- Columns are displayed with flat headers. With 72 columns, horizontal scrolling is unmanageable without grouped headers and column visibility controls.
- Bid editing exists but lacks inline editing with visual affordances (pencil icon, confirmation).
- Bulk import/export exists (`POST /amazon-ads/upload-file` type=k-config, `GET /amazon-ads/keywords-config/export/`) but needs template vs. filtered report modes.

# Solution Outline

**72-column table with 10 grouped headers:**
- Identity (7 cols): Keyword, ASIN, Campaign, Ad Group, Match Type, Branding Scope, Relationship.
- Market Intelligence (5 cols): Search Volume, Organic Rank (Avg/Median), Sponsored Rank, Keyword Clicks.
- Competitive Data (4 cols): Bid Suggestion (Min/Median/Max), Competitors on KW.
- Bid Configuration (19 cols): Current Bid, Previous Bid, Bid Change (delta), Amazon Previous/Current Bid, Amazon Bid Delta, Bid Analysis, Applied Target ACOS, Applied ACOS, Applied CVR, Last Bid Sent Date, Bid Sync Status, Bid Sync Last Update, Amazon Status, Applied ACOS Date Range, Applied TOS%, Applied Ad Spend, Applied Ad Sales, Applied Clicks.
- 6 time-series groups (7 cols each): Ad Cost, Ad Sales, ACOS, TOS%, Ad Clicks across 1d/3d/7d/15d/30d/90d/180d.
- Additional Metrics: Ad CTR (7), Ad Orders (7), Ad CVR (7) + System Remarks, User Remarks, Harvested Date.

**Table features:**
- Group headers with colored backgrounds, collapsible. Column visibility toggle (per-column and per-group). Sticky first 2 columns (Keyword + ASIN). Sortable, filterable, paginated (25/50/100). Editable bid cells (pencil icon on hover). Reset filters button.

**Bulk import/export:**
- Export: template (15 cols matching portal import format) or filtered report (all visible columns). Import: CSV with validation and error reporting. UTF-8 BOM for Excel. Import history link.

**Behavior flow:**
1. Seller opens Keyword Settings > table loads with all 10 column groups visible.
2. Seller clicks "Columns" > toggles off "Ad CTR" group > 7 columns hide.
3. Seller hovers over bid cell > pencil icon appears > clicks > edits bid inline > saves.
4. Seller exports filtered report > CSV includes only visible columns with current filters.

# Connected Work Items

**Blocked By:** [PROD-4120](https://keplercommerce.atlassian.net/browse/PROD-4120) (keywords created during wizard), [PROD-4128](https://keplercommerce.atlassian.net/browse/PROD-4128) (table component patterns)
**Relates To:** [PROD-4125](https://keplercommerce.atlassian.net/browse/PROD-4125) (same table structure)

# Implementation Notes

- Current data: `GET /amazon-ads/keywords-config/` returns all 72 columns. Column groups are UI-only organization.
- Bid editing: `PUT /amazon-ads/keywords-config/` for single keyword. `AdvertisingCampaignConfigService.bulk_update()` for batch.
- Import: `POST /amazon-ads/upload-file` type=k-config. Export: `GET /amazon-ads/keywords-config/export/`.
- Time-series data aggregated from Amazon Advertising API over 7 periods. Bid Sync Status reflects whether last bid change pushed to Amazon. Applied metrics show values from last bid optimization cycle.
- Two-row header: group name (top), column names (bottom). All 72+ columns present even if some hidden by default.
- API response fields (GET /api/amazon-ads/keywords-config/): Returns all AdvertisingKeyword fields plus nested campaign data. Key fields: keyword, match_type, bid, final_bid, ceiling_bid, floor_bid, target_acos, state, campaign name/id. Includes time-series metrics (ad_cost_1d through ad_cost_180d, ad_sales, clicks, impressions per period). Paginated: {count, next, results[]}.

# Test Cases

1. Table loads with all column groups and group headers displayed.
2. Seller toggles "Ad CTR" group off. All 7 columns hide, others unaffected.
3. Seller sorts by "ACOS 7d". Rows reorder correctly.
4. Seller edits bid inline. New value saved on confirm.
5. Seller scrolls horizontally. Keyword and ASIN columns stay frozen.
6. Seller exports filtered report. CSV has only visible columns with current filter.
7. Table shows 1,000+ keywords. Pagination works at 25/50/100 page sizes.

# Acceptance Criteria

- [ ] 72+ columns organized in 10 named groups with visual group headers
- [ ] Time-series columns available for 7 periods each
- [ ] Column visibility toggle for individual columns and entire groups
- [ ] First 2 columns frozen during horizontal scroll
- [ ] Bid values editable inline with pencil icon
- [ ] Export supports template and filtered report with UTF-8 BOM
- [ ] Import with validation and import history
- [ ] Sorting, filtering, pagination (25/50/100), reset filters
- [ ] Tests passed (unit + integration)
- [ ] UI matches prototype

Prototype: https://mmaazhanif22.github.io/kepler-ads-design/ads-only.html
