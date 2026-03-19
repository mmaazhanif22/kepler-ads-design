# Campaign List and Config

# User Story

As a seller, I want a campaign list with performance context and a config table with inline editing so that I can assess campaign health and make configuration changes efficiently.

# Problem / Context

- The portal has a campaign list with 13 columns but no performance context. Sellers cannot see pacing, spend, sales, or ACOS alongside campaign details without switching views.
- Campaign configuration (budgets, bid strategies, status) exists on a separate page with no inline editing. Sellers must open individual campaign records to make changes.
- There is no bulk enable/pause capability for campaigns. Sellers must toggle status one at a time.
- Campaign config bulk import exists (`POST /amazon-ads/upload-file` type=ad-campaign-config) but the UI needs a clearer template download and validation flow.

# Solution Outline

**Campaign List Table (13 portal + 7 enhancement columns = 20 total):**
- Portal columns: Campaign Name, ASIN, Type, Match Type, Status, Daily Budget, Target ACOS, Bid Strategy, Start Date, End Date, Keywords Count, Ad Group Count, Portfolio.
- Enhancement columns: Pacing Status, Spend (period), Sales (period), ACOS (period), Impressions, Clicks, Match Type filter.
- Data: `GET /amazon-ads/ad-campaign/` for base data. Performance metrics joined from `GET /amazon-ads/bidding/analytics/campaigns/top/`.
- Bulk status toggle for enable/pause via `AdvertisingCampaignConfigService.bulk_update()`.

**Campaign Config Table (10 columns):**
- Campaign, ASIN, Budget, Target ACOS, Bid Strategy, Placement Adjustments, Negative Keywords, Status, Created Date, Modified Date.
- Inline editable for budget, ACOS, and bid strategy. Data: `GET /amazon-ads/ad-campaign-config/`, `PUT /amazon-ads/ad-campaign-config/`.
- Bulk import/export: template download via `GET /amazon-ads/download-campaign-config-file` (9 columns). Import via `POST /amazon-ads/upload-file` type=ad-campaign-config.

**Behavior flow:**
1. Seller opens Campaign List > sees 20 columns including pacing and spend context.
2. Seller filters by Match Type "Exact" > only exact match campaigns shown.
3. Seller bulk-selects 5 campaigns > toggles status to Paused > all 5 pause.
4. Seller opens Campaign Config > inline edits budget from $20 to $30 > saves.

# Connected Work Items

**Blocked By:** [PROD-4120](https://keplercommerce.atlassian.net/browse/PROD-4120) (campaigns created via wizard), [PROD-4122](https://keplercommerce.atlassian.net/browse/PROD-4122) (navigation entry point)
**Relates To:** [PROD-4409](https://keplercommerce.atlassian.net/browse/PROD-4409) (KW Research), [PROD-4410](https://keplercommerce.atlassian.net/browse/PROD-4410) (Branding Scope)

# Implementation Notes

- Campaign list enhancement columns (Pacing, Spend, Sales, ACOS, Impressions, Clicks) require joining campaign data with performance metrics from `GET /amazon-ads/bidding/analytics/campaigns/top/`.
- Campaign Config bulk import template must match the portal's 9-column format exactly. Template: `GET /amazon-ads/download-campaign-config-file`. Export: `GET /amazon-ads/ad-campaign/export/`.
- Bulk status toggle: `AdvertisingCampaignConfigService.bulk_update()` with validation and duplicate detection.
- Campaign API response (GET /api/amazon-ads/ad-campaign/): id, name, state, targeting_type, budget, budget_type, bidding_strategy, default_bid_manual, target_acos_threshold, match_type, optimize_bid, last_sync_on, last_sync_off, currency, modified. Paginated: {count, next, results[]}.

# Test Cases

1. Campaign List shows 20 columns including Pacing, Spend, Sales, ACOS enhancements.
2. Seller filters by Match Type "Exact". Only exact match campaigns shown.
3. Seller inline edits budget in Campaign Config. Change saves.
4. Seller imports Campaign Config CSV. System validates 9 columns, applies changes.
5. Seller bulk-selects 5 campaigns, toggles to Paused. All 5 pause with confirmation.

# Acceptance Criteria

- [ ] Campaign List displays 20 columns (13 portal + 7 enhancement)
- [ ] Campaign Config supports inline editing of budget, ACOS, bid strategy
- [ ] Campaign Config bulk import/export matches portal 9-column template
- [ ] Bulk status toggle for enable/pause multiple campaigns
- [ ] All tables support sorting, filtering, pagination, export
- [ ] Tests passed (unit + integration)
- [ ] UI matches prototype

Prototype: https://mmaazhanif22.github.io/kepler-ads-design/ads-only.html
