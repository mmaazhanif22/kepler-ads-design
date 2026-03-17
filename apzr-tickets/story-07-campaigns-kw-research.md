# Campaign Management, Keyword Research & Branding Scope

## User Story

As a seller, I want to view and manage my campaigns, research new keywords, and classify keyword brand relationships, so that I can maintain full control over campaign structure, discover growth opportunities, and ensure proper brand targeting.

## Problem / Context

- Sellers need a campaign list view that goes beyond basic portal columns to include performance context (pacing, spend, sales, ACOS) so they can assess campaign health at a glance
- Keyword research tools need to surface competitive intelligence data (from sources like Jungle Scout) alongside Amazon's native data
- The Branding Scope feature (NB/OB/CB classification) is essential for the Kepler campaign naming convention but lacks a dedicated management interface
- Campaign configuration (budgets, bid strategies, status) needs a clear table view with bulk editing capabilities

## Solution Outline

**Campaign List Table (20 columns — 13 portal + 7 enhancements):**
- Portal columns: Campaign Name, ASIN, Type, Match Type, Status, Daily Budget, Target ACOS, Bid Strategy, Start Date, End Date, Keywords Count, Ad Group Count, Portfolio
- Enhancement columns: Pacing Status, Spend (period), Sales (period), ACOS (period), Impressions, Clicks, Match Type filter
- Sortable, filterable, paginated
- Bulk status toggle (enable/pause campaigns)

**Campaign Config Table (10 columns matching portal):**
- Campaign, ASIN, Budget, Target ACOS, Bid Strategy, Placement Adjustments, Negative Keywords, Status, Created Date, Modified Date
- Inline editable for budget, ACOS, and bid strategy
- Bulk import/export with template matching portal format (9 columns)

**Keyword Research (16 visible + 10 hidden columns):**
- Visible: Keyword, Search Volume (Exact), Organic Rank, Sponsored Rank, Competition Level, CPR, Bid Suggestion, Relevancy, Word Count, Title Density, plus 6 more
- Hidden (toggle-able): JS Search Volume (Broad), JS Organic ASIN Count, JS Sponsored ASIN Count, JS Ease of Ranking, JS Relevancy Score, JS PPC Bid (Exact/Broad), JS SP Brand Ad Bid, JS Recommended Promotions, JS Last Updated
- "Columns" toggle button to show/hide the Jungle Scout data columns
- Bulk import (3-column template: ASIN, Keyword, Source) and export
- "Run KW Research" requires completed ASIN setup (prerequisites shown if not met)

**Branding Scope:**
- Table columns: Keyword, Branding Scope (NB/OB/CB), Relationship (N/R/S/C), Logs, Actions
- Branding Scope dropdown values: NB (Non-Branded), OB (Own Brand), CB (Competitor Branded)
- Relationship dropdown values: N (Neutral), R (Related), S (Substitute), C (Complementary)
- Inline editable dropdowns
- Branding classification drives which campaign type (NB/OBH/CB) a keyword belongs to

**UI Requirements:**
- Mockup: [Prototype](http://localhost:8765/Advertising%20Portal%20UI%20Design.html) — Campaign views accessible from Ads Management
- KW Research hidden columns toggle is a button similar to Keyword Settings column visibility
- Branding Scope dropdowns match portal values exactly
- Campaign list enhancements (pacing, spend, sales, ACOS) visible alongside standard columns

## Connected Work Items

**Blocks:** None
**Is Blocked By:** Story 1 (Wizard) — campaigns and keywords are created via wizard; Story 3 (ASIN Overview) — provides navigation entry point
**Relates To:** Story 5 (KW Settings) — manages keywords post-research; Story 2 (IBO) — creates campaigns in bulk

✅ Campaign Management and Keyword Research depend on campaign/keyword data existing from the wizard or IBO setup flows.

## Implementation Notes

- Campaign list enhancement columns (Pacing, Spend, Sales, ACOS, Impressions, Clicks) require joining campaign data with performance metrics
- Jungle Scout (JS) columns in Keyword Research come from a third-party data integration
- Branding Scope classifications feed into the campaign naming convention (NB/OBH/CB prefix)
- Campaign Config bulk import template must match the portal's 9-column format exactly
- "Run KW Research" button should be disabled with a prerequisite message if ASIN setup is incomplete

## Out of Scope

- Keyword bid management (covered by Story 5)
- Search term analysis (covered by Story 6)
- Campaign creation flow (covered by Stories 1 and 2)
- Third-party data provider integration setup (backend concern)

## Test Cases

- Seller views Campaign List — sees 20 columns including Pacing, Spend, Sales, ACOS enhancements
- Seller filters by Match Type "Exact" — only exact match campaigns shown
- Seller opens Campaign Config — inline edits budget from $20 to $30 — change saves
- Seller imports Campaign Config CSV — system validates 9 columns and applies changes
- Seller opens Keyword Research — sees 16 visible columns, clicks "Columns" to reveal 10 JS columns
- Seller clicks "Run KW Research" without ASIN setup — sees prerequisite message, button disabled
- Seller opens Branding Scope — sets keyword "lavender oil" to NB, Relationship N — saves
- Seller exports Keyword Research — CSV includes visible columns only

## Acceptance Criteria

- [ ] Campaign List displays 20 columns (13 portal + 7 enhancement columns)
- [ ] Campaign Config supports inline editing of budget, ACOS, and bid strategy
- [ ] Campaign Config bulk import/export matches portal 9-column template format
- [ ] Keyword Research shows 16 visible columns with toggle to reveal 10 additional Jungle Scout columns
- [ ] "Run KW Research" disabled with prerequisite message when ASIN setup is incomplete
- [ ] Branding Scope table supports NB/OB/CB and N/R/S/C dropdown values matching portal
- [ ] Branding classifications feed into campaign naming convention
- [ ] All tables support sorting, filtering, pagination, and export
- [ ] Tests passed (unit + integration)
- [ ] UI matches approved mockup
