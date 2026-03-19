# Campaign List & Config (PROD-4126)

## User Story

As a seller, I want a campaign list view with performance context and a campaign config table with inline editing and bulk operations, so that I can assess campaign health at a glance and make configuration changes efficiently.

## Problem / Context

- Sellers need a campaign list view that goes beyond basic portal columns to include performance context (pacing, spend, sales, ACOS) so they can assess campaign health at a glance.
- Campaign configuration (budgets, bid strategies, status) needs a clear table view with bulk editing capabilities.
- The current portal has separate campaign list and config views. Both need enhancement with additional columns and inline editing.

## Existing vs. Net-New

| Area | Status | Notes |
|------|--------|-------|
| Campaign List (13 portal columns) | EXISTS (rebuild) | Current portal has 13 campaign columns. Rebuild with 7 enhancement columns (Pacing, Spend, Sales, ACOS, Impressions, Clicks, Match Type filter). |
| Campaign Config (10 columns) | EXISTS (rebuild) | Current portal has campaign config table. Rebuild with inline editing and bulk import/export. |
| Enhancement columns (7 new) | NEW | Pacing Status, Spend (period), Sales (period), ACOS (period), Impressions, Clicks, Match Type filter are new additions. |
| Bulk status toggle | NEW | No bulk enable/pause for campaigns today. |

## Solution Outline

**Campaign List Table (20 columns: 13 portal + 7 enhancements):**
- Portal columns: Campaign Name, ASIN, Type, Match Type, Status, Daily Budget, Target ACOS, Bid Strategy, Start Date, End Date, Keywords Count, Ad Group Count, Portfolio.
- Enhancement columns: Pacing Status, Spend (period), Sales (period), ACOS (period), Impressions, Clicks, Match Type filter.
- Sortable, filterable, paginated.
- Bulk status toggle (enable/pause campaigns).

**Campaign Config Table (10 columns matching portal):**
- Campaign, ASIN, Budget, Target ACOS, Bid Strategy, Placement Adjustments, Negative Keywords, Status, Created Date, Modified Date.
- Inline editable for budget, ACOS, and bid strategy.
- Bulk import/export with template matching portal format (9 columns).

**UI Requirements:**
- Mockup: [Prototype](https://mmaazhanif22.github.io/kepler-ads-design/ads-only.html) | Campaign views accessible from Manage Ads
- Campaign list enhancements (pacing, spend, sales, ACOS) visible alongside standard columns.

## Sub-Tasks

| # | Sub-Task | Exists / New | Backend Reference |
|---|----------|-------------|-------------------|
| 1 | **Campaign List table** with 13 portal columns + 7 enhancement columns, sortable/filterable/paginated | EXISTS (rebuild) | `GET /amazon-ads/ad-campaign/` for campaign list. Performance data joined from metrics endpoints. |
| 2 | **Campaign Config table** with 10 columns, inline editing for budget/ACOS/bid strategy | EXISTS (rebuild) | `GET /amazon-ads/ad-campaign-config/` for config data. `PUT /amazon-ads/ad-campaign-config/` for updates. |
| 3 | **Bulk status toggle** for enable/pause multiple campaigns at once | NEW | `AdvertisingCampaignConfigService.bulk_update()` for batch status changes. |
| 4 | **Campaign Config bulk import/export** with 9-column template matching portal format | EXISTS (rebuild) | Import: `POST /amazon-ads/upload-file` type=ad-campaign-config. Export: `GET /amazon-ads/ad-campaign/export/`. Template: `GET /amazon-ads/download-campaign-config-file`. |

## Backend References

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/amazon-ads/ad-campaign/` | GET | Campaign list with base 13 columns |
| `/amazon-ads/ad-campaign/export/` | GET | Campaign list CSV export |
| `/amazon-ads/ad-campaign-config/` | GET | Campaign config data (10 columns) |
| `/amazon-ads/ad-campaign-config/` | PUT | Update campaign config (budget, ACOS, bid strategy) |
| `/amazon-ads/upload-file` (type=ad-campaign-config) | POST | Import campaign config CSV |
| `/amazon-ads/download-campaign-config-file` | GET | Campaign config template download |
| `AdvertisingCampaignConfigService.bulk_update()` | Service | Bulk campaign updates with validation and duplicate detection |
| `/amazon-ads/bidding/analytics/campaigns/top/` | GET | Campaign performance metrics for enhancement columns |

## Connected Work Items

**Blocks:** None.
**Is Blocked By:** PROD-4120 (Wizard), campaigns are created via wizard. PROD-4122 (Manage Ads), provides navigation entry point.
**Relates To:** PROD-4409 (Keyword Research), PROD-4410 (Branding Scope). PROD-4124 (KW Settings), manages keywords post-research. PROD-4121 (IBO), creates campaigns in bulk.

## Implementation Notes

- Campaign list enhancement columns (Pacing, Spend, Sales, ACOS, Impressions, Clicks) require joining campaign data with performance metrics.
- Campaign Config bulk import template must match the portal's 9-column format exactly.

## Out of Scope

- Keyword research and discovery (covered by PROD-4409)
- Branding Scope management (covered by PROD-4410)
- Keyword bid management (covered by PROD-4124)
- Search term analysis (covered by PROD-4125)
- Campaign creation flow (covered by PROD-4120 and PROD-4121)

## Test Cases

- Seller views Campaign List. Sees 20 columns including Pacing, Spend, Sales, ACOS enhancements.
- Seller filters by Match Type "Exact". Only exact match campaigns shown.
- Seller opens Campaign Config. Inline edits budget from $20 to $30. Change saves.
- Seller imports Campaign Config CSV. System validates 9 columns and applies changes.
- Seller bulk-selects 5 campaigns and toggles status to Paused. All 5 pause with confirmation.
- Seller exports Campaign List. CSV includes all visible columns.

## Acceptance Criteria

- [ ] Campaign List displays 20 columns (13 portal + 7 enhancement columns)
- [ ] Campaign Config supports inline editing of budget, ACOS, and bid strategy
- [ ] Campaign Config bulk import/export matches portal 9-column template format
- [ ] Bulk status toggle allows enabling/pausing multiple campaigns at once
- [ ] All tables support sorting, filtering, pagination, and export
- [ ] Tests passed (unit + integration)
- [ ] UI matches approved mockup
