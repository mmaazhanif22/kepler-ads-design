# Search Term Settings: Active Search Terms Table

# User Story

As a seller, I want an Active Search Terms table with all 105 portal columns organized in logical groups so that I can review search term performance across time periods and identify terms needing action.

# Problem / Context

- The portal Search Term Settings page has 105 columns across 10+ groups. Any new UI must provide full data access.
- Columns are displayed with flat headers. With 105 columns, the table is unusable without grouped headers and column visibility controls.
- Organic Rank and Bid Suggestion data are currently combined into single columns. They need to be separate for proper analysis.
- The page needs to serve as a shell for 3 additional workflow tabs (PROD-4408) alongside the default Active Search Terms tab.

# Solution Outline

**105-column table with 10+ grouped headers:**
- Identity: Search Term, ASIN, Campaign, Ad Group, Match Type.
- Market Intelligence: Search Volume, Organic Rank Avg, Organic Rank Median, Sponsored Rank, KW Clicks.
- Amazon Recommendations: Avg Amazon Recommended Rank, Median Amazon Recommended Rank.
- Bid Data: Suggested Bid Min, Suggested Bid Median, Suggested Bid Max, Current Bid, Bid actions.
- 8 time-series groups (7 cols each): Ad Cost, Ad Sales, ACOS, TOS%, Ad Clicks, Ad CTR, Ad Orders, Ad CVR across 1d/3d/7d/15d/30d/90d/180d.

**Table features:** Same as Keyword Settings. Column visibility toggle, sticky first 2 columns (Search Term + ASIN), sortable, filterable, paginated, reset filters, bulk export.

**Sub-tab shell:** Active Search Terms is the default tab. Shell supports 3 additional tabs from PROD-4408 (Harvest Queue, Negative Keywords, High Performers).

**Behavior flow:**
1. Seller opens Search Term Settings > Active Search Terms tab loads by default with all column groups.
2. Seller toggles off "TOS%" group > 7 columns hide.
3. Seller sorts by "Ad Cost 30d" > rows reorder.

# Connected Work Items

**Blocked By:** [PROD-4120](https://keplercommerce.atlassian.net/browse/PROD-4120) (search terms generated from campaign activity), [PROD-4128](https://keplercommerce.atlassian.net/browse/PROD-4128) (table patterns)
**Relates To:** [PROD-4408](https://keplercommerce.atlassian.net/browse/PROD-4408) (adds Harvest Queue, Negative Keywords, High Performers tabs), [PROD-4124](https://keplercommerce.atlassian.net/browse/PROD-4124) (same table structure)

# Implementation Notes

- Current data: `GET /amazon-ads/search-terms/` returns all search term data. Column groups are UI-only.
- Export: `POST /amazon-ads/search-terms/aggregated/export/`. Import: `POST /amazon-ads/upload-file` type=search-term-config.
- Organic Rank split: "Avg Organic Rank" and "Median Organic Rank" as separate columns (not combined).
- Sub-tab shell must render tab slots for PROD-4408 tabs even before that ticket ships.
- Time-series data from same pipeline as Keyword Settings.

# Test Cases

1. Active Search Terms loads as default with all column groups visible.
2. Avg Organic Rank and Median Organic Rank shown as separate columns.
3. Seller toggles off "TOS%" group. All 7 period columns hide.
4. Seller scrolls horizontally. Search Term and ASIN columns stay frozen.
5. Table handles 2,000+ search terms with pagination at 25/50/100.

# Acceptance Criteria

- [ ] 105+ columns organized in 10+ named groups
- [ ] Time-series columns (8 metrics x 7 periods) match Keyword Settings pattern
- [ ] Organic Rank and Bid Suggestion shown as separate columns
- [ ] Column visibility, sorting, filtering, pagination, export work correctly
- [ ] Sticky first 2 columns during horizontal scroll
- [ ] Sub-tab shell supports additional tabs from PROD-4408
- [ ] Tests passed (unit + integration)
- [ ] UI matches prototype

Prototype: https://mmaazhanif22.github.io/kepler-ads-design/ads-only.html
