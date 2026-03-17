# Search Term Settings — Full Portal Parity with Enhancements

## User Story

As a seller, I want a comprehensive Search Term Settings view with multiple sub-tabs for active terms, harvest queue, negative keywords, and high performers, so that I can manage the full search term lifecycle from discovery through optimization.

## Problem / Context

- The portal's Search Term Settings has 105 columns across 10 groups — any new UI must provide full data access
- Search term management involves multiple workflows: reviewing active terms, harvesting promising terms into campaigns, managing negative keywords, and identifying high performers
- Without sub-tabs, sellers must mentally filter between these different workflows in a single table
- Time-series performance data (same 8 metrics across 7 periods as Keyword Settings) is needed to evaluate search term trends
- Sellers managing thousands of search terms need efficient bulk operations

## Solution Outline

**4 Sub-Tabs:**

1. **Active Search Terms** — Primary view with full portal column set
2. **Harvest Queue** — Search terms flagged for promotion to keyword campaigns
3. **Negative Keywords** — Terms identified for negative keyword addition
4. **High Performers** — Top-converting search terms for spotlight analysis

**Active Search Terms Table (matching portal 105 columns):**
- Column groups mirror Keyword Settings structure:
  - Identity (Search Term, ASIN, Campaign, Ad Group, Match Type)
  - Market Intelligence (Search Volume, Organic Rank Avg, Organic Rank Median, Sponsored Rank, KW Clicks)
  - Amazon Recommendations (Avg Amazon Recommended Rank, Median Amazon Recommended Rank)
  - Bid Data (Suggested Bid Min, Suggested Bid Median, Suggested Bid Max, Current Bid, Bid actions)
  - 8 time-series groups (Ad Cost, Ad Sales, ACOS, TOS%, Ad Clicks, Ad CTR, Ad Orders, Ad CVR) each with 7 periods (1d, 3d, 7d, 15d, 30d, 90d, 180d)
- Group headers with colored backgrounds matching Keyword Settings
- Organic Rank and Bid Suggestion shown as separate columns (not combined)

**Harvest Queue Tab:**
- Search terms that meet harvesting criteria (e.g., 3+ conversions, ACOS below target)
- Seller can select terms and promote them to keyword campaigns
- Bulk harvest action for multiple terms

**Negative Keywords Tab:**
- Search terms generating spend with zero or very low conversions
- Seller can add terms as negative keywords to campaigns
- Scope selector: apply to all campaigns, manual only, auto only, or PT only

**High Performers Tab:**
- Search terms with the best conversion rates and ACOS
- Seller can quickly identify winning search terms for keyword expansion
- Data includes conversion count, ACOS, revenue attribution

**Table Features (same as Keyword Settings):**
- Column visibility toggle with group-level show/hide
- Sortable, filterable, paginated (25/50/100 rows)
- Sticky first 2 columns (Search Term + ASIN)
- Editable cells where applicable
- Reset filters button
- Bulk import/export with UTF-8 BOM and import history

**UI Requirements:**
- Mockup: [Prototype — Search Term Settings](http://localhost:8765/Advertising%20Portal%20UI%20Design.html) (navigate to Ads Management > Search Term Settings)
- Sub-tab navigation at the top of the view
- Same group header and column styling as Keyword Settings for visual consistency
- Active tab shows count of items (e.g., "Harvest Queue (12)")

## Connected Work Items

**Blocks:** None
**Is Blocked By:** Story 1 (Wizard) — search terms are generated from campaign activity; Story 9 (UX Infrastructure) — table patterns
**Relates To:** Story 5 (Keyword Settings) — same table structure and column patterns; Story 1 (Wizard) — wizard Step 6 links to Search Term Settings post-setup

✅ Search Term Settings follows the same table patterns as Keyword Settings. Development of both can be parallelized.

## Implementation Notes

- Time-series data sourced from the same advertising data pipeline as Keyword Settings
- Harvest Queue criteria should be configurable (e.g., minimum conversions, maximum ACOS)
- Negative Keywords tab should show which campaigns the negative applies to
- High Performers criteria: ACOS below average, conversion count above threshold
- Column groups must match Keyword Settings visual pattern for consistency
- Organic Rank split: "Avg. Organic Rank" and "Median Organic Rank" as separate columns

## Out of Scope

- Keyword-level bid management (covered by Story 5)
- Automated harvesting rules (backend automation)
- Search term data collection from Amazon (backend data pipeline)
- Cross-marketplace search term comparison

## Test Cases

- Seller opens Search Term Settings — Active Search Terms tab loads as default with all column groups
- Seller switches to Harvest Queue — sees search terms meeting harvest criteria
- Seller selects 5 search terms and clicks "Harvest" — terms promoted to keywords
- Seller switches to Negative Keywords — sees underperforming terms with scope selector
- Seller adds 3 negative keywords with scope "Auto only" — negatives apply to auto campaigns only
- Seller switches to High Performers — sees top-converting terms sorted by conversion rate
- Column groups show separately: Avg Organic Rank and Median Organic Rank as individual columns
- Seller toggles off "TOS%" column group — all 7 TOS% period columns hide
- Export includes all visible columns for the current tab

## Acceptance Criteria

- [ ] 4 sub-tabs: Active Search Terms, Harvest Queue, Negative Keywords, High Performers
- [ ] Active Search Terms table has 105+ columns organized in 10+ named groups
- [ ] Time-series columns (8 metrics x 7 periods) match the Keyword Settings pattern
- [ ] Organic Rank and Bid Suggestion data shown as separate columns (not combined)
- [ ] Harvest Queue allows selecting and promoting search terms to keyword campaigns
- [ ] Negative Keywords tab supports scope selector (All/Manual/Auto/PT)
- [ ] High Performers tab highlights top-converting search terms
- [ ] Column visibility, sorting, filtering, pagination, and export work consistently across all tabs
- [ ] Tests passed (unit + integration)
- [ ] UI matches approved mockup
