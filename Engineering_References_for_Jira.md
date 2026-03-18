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

---

## Round 3 Feature References (Added 2026-03-18)

## Auto Budget Toggle (R3-3.17)
- **Location:** Wizard Step 4 ASIN-Level Defaults section, IBO Stage 2 Campaign Skeleton
- **Backend:** `AdvertisingAsinConfig.auto_budget` (BooleanField, default=False) at `models/config.py:64`
- **Global fallback:** `AdvertisingGlobalConfig.auto_budget` at `models/config.py:284`
- **API:** PUT `/api/amazon-ads/config/asin-config/{id}/` — updates `auto_budget` field
- **Task:** `daily_recalc_auto_budget()` at `tasks.py:239` — Celery task recalculates budgets daily
- **Consumer:** `applications/budget/consumers/auto_budget/consumer.py` — queue: `advertising_auto_budget`
- **Logic:** Filters campaigns where `campaign_config__asin_config__auto_budget=True`, uses `AutoBudgetCalculation().calculate()` with 30-day spend aggregates

## ASIN-Level Target ACOS (R3-3.18)
- **Location:** Wizard Step 4 ASIN-Level Defaults section, IBO Stage 1/2
- **Backend:** `AdvertisingAsinConfig.target_acos` (FloatField, null=True, validators 1-100) at `models/config.py:61`
- **API:** PUT `/api/amazon-ads/config/asin-config/{id}/`

## ASIN-Level Daily Budget (R3-3.18)
- **Location:** Wizard Step 4 ASIN-Level Defaults section
- **Backend:** `AdvertisingAsinConfig.daily_budget` (FloatField, null=True, min=5.01) at `models/config.py:59`
- **API:** PUT `/api/amazon-ads/config/asin-config/{id}/`

## Target ACOS Inheritance Cascade (R3-3.19)
- **Location:** Campaign table inheritance indicators (inherited/custom labels)
- **Backend:** `BidCalculationDataService.calculate_target_acos()` at `bidding/services/bid_calculation.py:139-195`
- **Priority (highest → lowest):**
  1. `AdvertisingKeyword.target_acos` (per-keyword override)
  2. `AdvertisingCampaignConfig.target_acos` (per-campaign)
  3. `AdvertisingAsinConfig.target_acos` (per-ASIN)
  4. `AdvertisingGlobalConfig.target_acos` (seller-wide default)
- **Code:** `df["target_acos"].fillna(campaign_config.target_acos).fillna(asin_config.target_acos).fillna(global_target_acos)`

## Pacing Engine & Visual Distinction (R3-3.20)
- **Location:** Campaign table Pacing badges, Auto Pacing toggle
- **Backend:**
  - Toggle: `AdvertisingAsinConfig.auto_pacing_enabled` (BooleanField) at `models/config.py:82`
  - System state: `AdvertisingCampaignConfig.pacing_last_applied_state` (CharField) at `models/config.py:190`
  - User lock: `AdvertisingCampaignConfig.user_locked_state` (CharField) at `models/config.py:203`
  - Last run: `AdvertisingAsinConfig.last_pacing_run` (DateTimeField) at `models/config.py:86`
- **Service:** `PacingEngineService` at `applications/projections/services/pacing_engine.py:110`
- **Flow:** Lock Detection → Budget Reservation → ACOS Filter → Knapsack Optimization → Campaign Application
- **Applicator:** `campaign_applicator.py` — Selected campaigns → ENABLED, Non-selected → PAUSED (except user-locked)
- **Tasks:** `run_pacing_for_asin()`, `run_pacing_scheduled()`, `run_pacing_manual()` at `projections/tasks/run_pacing.py`

## Competitor Research (R3-3.1, R3-3.2)
- **Location:** Wizard Step 2 "Automated Competitor Research"
- **Backend:** `AdvertisingAsinConfig.competitor_asins` (SafeJSONField) at `models/config.py:62`
- **API:** PUT `/api/amazon-ads/config/asin-config/{id}/` — updates competitor_asins array
- **Analytics endpoints (competitor analysis):**
  - GET `/analytics/search_terms/competitor_asins` — clickShare, conversionShare, searchFrequencyRank
  - GET `/analytics/search_terms/competitor_brands`
  - GET `/analytics/search_terms/competitor_terms`
  - GET `/analytics/search_terms/competitor_best_sellers` — price_waterfall

## KW Research Phases (R3-3.7, R3-3.9)
- **Location:** Wizard Step 3 Phase 1 (Fetching) + Phase 2 (Analysis & Grouping)
- **Backend:**
  - Model: `KeywordResearchAutomationBatch` (table: `amazon_ads.kw_rs_batch`)
  - Status: PENDING(0), IN_QUEUE(1), RECEIVED(2), APPROVED(3), FAILED(4)
  - Phase 1 = keyword fetch via Jungle Scout API
  - Phase 2 = AI processing: prompt_type=1 (Branding Scope), prompt_type=2 (Attributes Ranking), prompt_type=3 (Grouping Ranking)
- **Approval:** POST `/amazon-ads/approve-kw-stage {asin_id, prompt_type}`
- **Reset:** POST `/amazon-ads/reset-kw-stage {asin_id, check_only, confirm_external}`
- **AI Engine:** GPT-4-mini via RabbitMQ queue `keyword_research_automation`

## Campaign Naming Convention (R3B-2.3 — removed from UI)
- **Location:** Removed from IBO Configuration page (not user-configurable)
- **Backend:** `get_campaign_name()` at `managers/utils.py:116-167`
- **Pattern:** `{relevancy_tag_id}-{ad_type}-{brand_code}-XX-S-{ASIN}-{match}-{suffix}`
- **Brand codes:** Auto-generated from brand name via `BrandCode` model (e.g., "AM01", "PB01")
- **Not user-configurable** — system-generated, naming convention is internal engineering concern

## IBO Bulk Import on Configuration Page (R3B-2.2)
- **Location:** IBO Stage 2 Configuration — Bulk Import drop zone
- **API:** POST `/amazon-ads/upload-file` with `file_type='ad-campaign-config'`
- **CSV fields:** ASIN, Relevancy, Match Type, Target Spec, Target Brand, Target ACOS, Daily Budget, Ad Status, Custom Negative Keywords
- **Template:** GET `/amazon-ads/download-campaign-config-file`

## Bulk Import Auto Pacing Status (R3B-1.1)
- **Location:** IBO Stage 1 Bulk Import template
- **Backend:** `AdvertisingAsinConfig.auto_pacing_enabled` (BooleanField) — field EXISTS in model
- **BACKEND TICKET NEEDED:** `auto_pacing_enabled` is NOT YET in `config_file_upload()` CSV mapping at `managers/file_upload.py:422-429`. Currently the mapping includes: ASIN, TargetACOS, CompetitorASINs, DailyBudget, AutoBudgetStatus, AdStatus. Need to add: `'AutoPacingStatus': 'auto_pacing_enabled'` to `cols_mapping` dict. This is a 1-line backend change.

## Bulk Campaign Selection & Actions
- **Location:** Wizard Step 4 Campaign table — checkbox column, bulk action bar
- **API:** POST `/api/amazon-ads/config/ad-campaign-config/` — bulk updates status, target_acos, daily_budget
- **Backend:** `AdvertisingCampaignConfigService.bulk_update()` — handles validation, dedup, atomic transactions
