# Engineering References for Jira Tickets

Extracted from prototype tooltips and UI elements. Use when writing Jira ticket descriptions.

## Optimize Bid
- **Location:** Wizard Step 4 Opt column, IBO Stage 5 Opt column, IBO Stage 5 master toggle, Wizard Step 5 campaign table Opt column
- **Backend:** AdvertisingCampaign.optimize_bid (BooleanField, default=False)
- **API:** PATCH /api/campaigns/update_bulk/ {strategy: optimize_bid_update}
- **Task:** calculate_bids_daily() syncs bids to Amazon. Tracks last_sync_on / last_sync_off timestamps.
- **Master toggle:** Bulk-updates all campaigns via PATCH /api/campaigns/update_bulk/ (strategy: optimize_bid_update)

## Auto Pacing
- **Location:** IBO Stage 5 master toggle
- **Backend:** AdvertisingAsinConfig.auto_pacing_enabled
- **Behavior:** When enabled, Kepler automatically adjusts daily budgets throughout the day to optimize spend distribution

## Dashboard Export
- **Location:** Dashboard top-right Export button
- **API:** POST /api/amazon-ads/dashboard/target-chart/ (chart data export)

## AI Recommendations Refresh
- **Location:** Dashboard AI Recommendations card Refresh button
- **API:** GET /api/amazon-ads/bidding/analytics/dashboard/summary/ + rules/effectiveness/ + campaigns/top/

## Bid Adjustment (Apply +15%)
- **Location:** Dashboard AI Recommendations card
- **API:** PUT /api/amazon-ads/keywords/{id}/ — updates bid, final_bid, ceiling_bid fields via KeywordsApiView.update()

## Add Negative Keyword (from Dashboard)
- **Location:** Dashboard AI Recommendations card
- **Backend:** SearchTerm.negative_status_manual=1 (MARK_AS_NEGATIVE)
- **Task:** Triggers create_negative_keyword() Celery task -> Amazon Ads API

## Budget Reallocation
- **Location:** Dashboard AI Recommendations card
- **API:** POST /api/amazon-ads/ad-campaign/ — updates budget via AdvertisingCampaignView.create()
- **Task:** Triggers calculate_auto_budget()

## Campaign Data Sync
- **Location:** ASIN Overview top-right Sync button
- **API:** Amazon SP-API sync

## Search Term Changes Submit
- **Location:** Search Term (Active) tab Submit ST Changes button
- **API:** POST /api/amazon-ads/config/search-term-config/
- **Backend:** Updates SearchTerm.negative_status_manual, user_remarks

## Search Term Negate Selected
- **Location:** Search Term (Active) tab Negate Selected button
- **Backend:** SearchTermService.bulk_update() sets negative_status_manual=MARK_AS_NEGATIVE
- **Task:** Triggers create_negative_keyword() Celery task

## Search Term Negate (Individual Row)
- **Location:** Search Term (Active) tab per-row Negate button (x15 rows in prototype)
- **Backend:** negative_status_manual=1
- **Task:** Triggers create_negative_keyword() Celery task

## Search Term Harvest Approve All
- **Location:** Search Term (Harvest) tab Approve All button
- **Backend:** Harvest is automatic rule-based via Celery calculate_search_terms_harvesting()
- **Rules:** SearchTermsHarvestingChecker qualifies STs where MAX(ACoS) <= Target_ACoS AND Spend >= Price

## Search Term Harvest Approve (Individual)
- **Location:** Search Term (Harvest) tab per-row Approve button (x3 rows in prototype)
- **Backend:** SearchTermsHarvestingChecker auto-qualifies search terms

## Harvest Queue Export
- **Location:** Search Term (Harvest) tab Export Queue button
- **API:** POST /api/amazon-ads/search-terms/aggregated/export/ via downloadSearchTermsAggregatedFile()

## Negative Keyword Remove (Individual)
- **Location:** Search Term (Negative KW) tab per-row Remove button (x3 rows in prototype)
- **API:** Sets state=PAUSED via AmazonAdNegativeKeywordsAPI (soft delete)

## Negative Keyword Remove Selected
- **Location:** Search Term (Negative KW) tab Remove Selected button
- **Backend:** CustomNegativeKeywordsManager.remove_custom_negative_keywords() sets state=PAUSED (soft delete)
- **Queue:** RabbitMQ: advertising_update_negative_keywords -> Amazon Ads API

## Root Cause Analysis Export
- **Location:** APDC Root Cause Analysis Export Report button
- **API:** GET /api/amazon-ads/bidding/analytics/dashboard/summary/ (APDC analytics endpoints)

## Campaign Performance Export
- **Location:** ASIN Overview Campaign Breakdown Export CSV button
- **API:** GET /api/amazon-ads/ad-campaign/export/ via downloadCampaignFile()

## Keyword Performance Export
- **Location:** ASIN Overview Keyword Breakdown Export CSV button
- **API:** GET/POST /api/amazon-ads/keywords-config/export/ via KeywordConfigExportService

## Search Term Report Export
- **Location:** ASIN Overview Search Term Breakdown Export CSV button
- **API:** GET /api/amazon-ads/search-term-report/export/

## Profit Analysis Export
- **Location:** ASIN Overview Profit Breakdown Export CSV button
- **API:** GET /api/amazon-ads/top-down-performance-analysis/export/

## Competitor Analysis Calculate
- **Location:** Competitor Search Terms tab Calculate button
- **API:** GET /analytics/search_terms/competitor_asins + competitor_brands + competitor_terms

## Competitor Analysis Export
- **Location:** Competitor Search Terms tab Download Excel button
- **API:** GET /analytics/search_terms/competitor_asins + competitor_brands + competitor_best_sellers

## Change Log Export JSON
- **Location:** Logs > All Configurations tab Export JSON button
- **API:** GET /api/amazon-ads/config/change-log/?format=json

## IBO KW Stage Approve (Individual ASIN)
- **Location:** IBO Stage 2 (KW Research) per-ASIN Approve button
- **API:** POST /api/amazon-ads/approve-kw-stage {asin_id, prompt_type}

## IBO Campaign Config Bulk Edit
- **Location:** IBO Stage 5 Bulk Edit button
- **Backend:** AdvertisingCampaignConfigService.bulk_update() — validation, dedup, atomic transactions

## IBO Campaign Plan Export
- **Location:** IBO Stage 5 Export CSV button
- **API:** GET /api/amazon-ads/download-campaign-config-file

## IBO Target ACOS Apply
- **Location:** IBO Stage 5 Apply ACOS to all campaigns
- **API:** PUT /api/amazon-ads/config/ad-campaign-config/ target_acos field
- **Backend:** AdvertisingCampaignConfig.target_acos (1-100)

## IBO Daily Budget Apply
- **Location:** IBO Stage 5 Apply Budget to all campaigns
- **API:** PUT /api/amazon-ads/config/ad-campaign-config/ daily_budget field
- **Backend:** AdvertisingCampaignConfig.daily_budget (min 5.01)
- **Task:** Triggers calculate_auto_budget()

## IBO Launch Plan Export
- **Location:** IBO Stage 6 Export Launch Plan button
- **API:** GET /api/amazon-ads/download-campaign-config-file

## IBO Launch All Campaigns
- **Location:** IBO Stage 6 Launch All Campaigns button
- **Backend:** CampaignCreationOrchestrator — batch creation
- **Queue:** RabbitMQ for batch campaign creation

## Campaign Strategy Field
- **Location:** Wizard Step 4 campaign config table Strategy column
- **Backend:** campaign_strategy field
- **Values:** MANUAL (keyword-targeted), HP (High Performers), AUTO (auto-targeted), ASIN_TARGETING (product targeting)

## Search Volume (Exact)
- **Location:** Wizard Step 4 table, IBO Stage 5 table, Wizard Step 5 table
- **Backend:** js_monthly_search_volume_exact (Jungle Scout data)

## Search Volume (Broad)
- **Location:** Wizard Step 4 table, IBO Stage 5 table, Wizard Step 5 table
- **Backend:** js_monthly_search_volume_broad (Jungle Scout data)

## Suggested Bid
- **Location:** Wizard Step 4 table, Wizard Step 5 table
- **Backend:** js_ppc_bid_exact (Jungle Scout data)

## Organic Rank
- **Location:** Wizard Step 4 table, Wizard Step 5 table
- **Backend:** js_organic_rank_average (Jungle Scout data)

## SP-API Token Refresh
- **Location:** Settings > Amazon Connection section
- **API:** Amazon Selling Partner API token refresh

## Amazon Campaign Data Sync
- **Location:** ASIN Overview header Sync button
- **API:** Amazon SP-API campaign data sync
