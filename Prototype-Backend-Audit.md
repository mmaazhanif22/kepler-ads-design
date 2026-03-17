# Prototype Advertising Section — Full Backend Audit

**Purpose:** Maps every prototype ad feature to its Kepler backend counterpart (model, API, Angular component, service).
**Prototype:** `Advertising Portal UI Design.html`
**Codebase:** `kepler-portal-sync/`
**Last updated:** 2026-03-12

---

## AUDIT LEGEND

| Status | Meaning |
|--------|---------|
| LINKED | Feature exists in portal AND correctly linked in prototype |
| EXISTS | Feature exists in portal but NOT yet annotated/linked in prototype |
| ENHANCEMENT | New feature in prototype — needs backend work or is frontend-only |
| MISMATCH | Prototype behavior differs from portal — needs correction |

---

## 1. ASIN OVERVIEW (pane-asin-overview) — ENHANCEMENT

**Status:** ENHANCEMENT — This is a **new unified view** (per Abdul's feedback). Portal has `AsinConfigListComponent` but with different columns.

| Prototype Feature | Backend Source | Status |
|---|---|---|
| ASIN column | `AdvertisingAsinConfig.asin` → `Asin.asin` | EXISTS |
| Product name | `Asin.title` (from SP-API sync) | EXISTS |
| Launch Status badge | **No direct field** — derived from `kw_research_status` + campaign existence | ENHANCEMENT |
| Ads ON/OFF toggle | `AdvertisingAsinConfig.ad_status` (ENABLED=1, PAUSED=2) | EXISTS |
| Actions dropdown (Edit, Resume Wizard, View Campaigns, etc.) | No single endpoint — combines multiple actions | ENHANCEMENT |
| Setup Checklist modal | **No direct field** — must derive from wizard step completion flags | ENHANCEMENT |
| Search/Filter by status | Client-side filtering; backend supports `?ad_status=` filter | EXISTS |

**Portal Component:** `AsinConfigListComponent` at `client/src/app/features/amazon-ads/components/products/asin-config/asin-config-list.component.ts`
**API:** `GET /api/amazon-ads/config/asin-config/` | `PUT /api/amazon-ads/config/asin-config/`
**Model:** `AdvertisingAsinConfig` at `apps/amazon_ads/models/config.py:40-115`

**Enhancement Notes:**
- "Launch Status" needs a computed field or view that checks: product selected → competitors selected → KW research done → KW automation done → campaigns created → activated
- Portal currently tracks `kw_research_status` (5 states) but not a full wizard-step status
- **Proposed:** Add `setup_status` computed property to `AdvertisingAsinConfig` serializer, or new field

---

## 2. CAMPAIGNS LIST (pane-campaigns)

**Status:** EXISTS — Directly mirrors portal's `CampaignsListComponent`

| Prototype Feature | Backend Source | Status |
|---|---|---|
| Campaign ID | `AdvertisingCampaign.id` | LINKED |
| Campaign Name | `AdvertisingCampaign.name` (max 1024 chars) | LINKED |
| State (Enabled/Paused/Archived) | `AdvertisingCampaign.state` | LINKED |
| Targeting Type (AUTO/MANUAL) | `AdvertisingCampaign.targeting_type` | LINKED |
| Budget | `AdvertisingCampaign.budget` | LINKED |
| Budget Type | `AdvertisingCampaign.budget_type` | LINKED |
| Bidding Strategy | `AdvertisingCampaign.bidding_strategy` | LINKED |
| Default Bid Manual | `AdvertisingCampaign.default_bid` | LINKED |
| Target ACOS Threshold | `AdvertisingCampaignConfig.target_acos` (via join) | LINKED |
| Match Type | `AdvertisingCampaignConfig.match_type` | LINKED |
| Optimize Bid toggle | `AdvertisingCampaign.optimize_bid` (Boolean) | LINKED |
| Pacing | Derived from `PacingEngineService` status | LINKED |
| Spend/Sales/ACOS/Impressions/Clicks | Reporting models: `cost`, `sales`, `acos`, `impressions`, `clicks` (1d-180d aggregates) | LINKED |
| Last Sync On/Off | `AdvertisingCampaign.sync_with_amazon` / derived | EXISTS |
| Global Target ACOS input | `AdvertisingGlobalConfig.target_acos` | LINKED |
| Global Max Bid Limit | `AdvertisingGlobalConfig.max_bid_limit` | LINKED |
| Export CSV | Client-side export; portal uses `GET /ad-campaign/export/` | EXISTS |
| Push to Amazon Ads | `POST /api/amazon-ads/ad-campaign/` (bulk update) | EXISTS |
| Column visibility toggles | Client-side only (portal uses `app-table` with saved column prefs) | EXISTS |
| Campaign type filter (SP/SB/SD) | Client-side filter on `campaign_type` field | EXISTS |
| Bulk Enable/Pause | `POST /api/amazon-ads/ad-campaign/` with state change | EXISTS |
| Bulk Optimize Bid | `POST /api/amazon-ads/campaigns/bulk-update` with `optimize_bid` | EXISTS |

**Portal Component:** `CampaignsListComponent` at `client/src/app/features/amazon-ads/components/campaigns/campaigns-list/campaigns-list.component.ts`
**Table Columns:** `table-columns.ts` (143 available columns in portal vs ~18 shown in prototype)
**API:** `GET /api/amazon-ads/ad-campaign/` | `POST /api/amazon-ads/ad-campaign/`
**Model:** `AdvertisingCampaign` at `apps/amazon_ads/models/campaigns.py`

---

## 3. CAMPAIGN CONFIG (pane-camp-config)

**Status:** EXISTS — Maps to portal's `CampaignConfigComponent`

| Prototype Feature | Backend Source | Status |
|---|---|---|
| Campaign config rows | `AdvertisingCampaignConfig` per (asin_config, relevancy_tag, match_type) | LINKED |
| Match Type column | `AdvertisingCampaignConfig.match_type` | LINKED |
| Strategy (MANUAL/AUTO/HP/ASIN_TARGETING) | `AdvertisingCampaignConfig.campaign_strategy` | LINKED |
| Daily Budget | `AdvertisingCampaignConfig.daily_budget` (min $5) | LINKED |
| Target ACOS | `AdvertisingCampaignConfig.target_acos` (1-100) | LINKED |
| Ad Status (ENABLED/PAUSED) | `AdvertisingCampaignConfig.ad_status` | LINKED |
| Custom Negative Keywords | `AdvertisingCampaignConfig.custom_negative_keywords` (JSON) | LINKED |
| Relevancy Tag / Group | `AdvertisingCampaignConfig.relevancy_tag` → `AdvertisingRelevancyTag` | LINKED |
| SPAS Brand Group | `AdvertisingCampaignConfig.spas_brand_group` → `AsinResearchBrandGroup` | LINKED |
| Download Template | `GET /api/amazon-ads/download-campaign-config-file` | EXISTS |
| Unique constraint | `(asin_config, relevancy_tag, match_type)` | LINKED |

**Portal Component:** `CampaignConfigComponent` at `client/src/app/features/amazon-ads/components/campaigns/campaign-config/campaign-config.component.ts`
**API:** `GET/POST /api/amazon-ads/config/ad-campaign-config/`
**Model:** `AdvertisingCampaignConfig` at `apps/amazon_ads/models/config.py:125-270`

---

## 4. KEYWORD SETTINGS (pane-kw-config)

**Status:** EXISTS — Maps to portal's `KeywordConfigComponent`

| Prototype Feature | Backend Source | Status |
|---|---|---|
| Keyword text | `AdvertisingKeyword.keyword` (max 128 chars) | LINKED |
| Match Type | `AdvertisingKeyword.match_type` | LINKED |
| Campaign assignment | `AdvertisingKeyword.campaign` → `AdvertisingCampaign` | LINKED |
| Current Bid | `AdvertisingKeyword.bid` | LINKED |
| Fixed Bid | `AdvertisingKeyword.fixed_bid` + `fixed_bid_expiry` | EXISTS |
| Ceiling Bid | `AdvertisingKeyword.ceiling_bid` + `ceiling_bid_expiry` | LINKED |
| Floor Bid | `AdvertisingKeyword.floor_bid` + `floor_bid_expiry` | LINKED |
| Target ACOS | `AdvertisingKeyword.target_acos` | LINKED |
| Applied Target ACOS | `AdvertisingKeyword.applied_target_acos` (computed effective value) | EXISTS |
| Status (ENABLED/PAUSED/ARCHIVED) | `AdvertisingKeyword.status` (1/2/3) | LINKED |
| Impressions/Clicks/Spend/Sales/CVR/ACOS | Reporting fields: `impressions1d-180d`, `clicks1d-180d`, etc. | LINKED |
| is_harvested flag | `AdvertisingKeyword.is_harvested` (Boolean) | EXISTS |
| Bulk update | `PUT /api/amazon-ads/keywords-config/` | EXISTS |
| Export | `GET /api/amazon-ads/keywords-config/export/` | EXISTS |

**Portal Component:** `KeywordConfigComponent` at `client/src/app/features/amazon-ads/components/keywords/keyword-config/keyword-config.component.ts`
**Table Columns:** `table-columns.ts` (143 columns available in portal)
**API:** `GET /api/amazon-ads/keywords-config/` | `PUT /api/amazon-ads/keywords-config/`
**Model:** `AdvertisingKeyword` at `apps/amazon_ads/models/keywords.py`

---

## 5. SEARCH TERM SETTINGS (pane-st-config) — 4 Sub-tabs

**Status:** EXISTS — Maps to portal's `SearchTermConfigComponent`

| Prototype Feature | Backend Source | Status |
|---|---|---|
| Search Term text | `SearchTerm.search_term` (max 250 chars) | LINKED |
| Keyword link | `SearchTerm.keyword` → `AdvertisingKeyword` | LINKED |
| Negative status (mark as negative) | `SearchTerm.negative_status_manual` (1=Mark, 2=Remove) | EXISTS |
| Negative applied status | `SearchTerm.negative_status` (Boolean) | EXISTS |
| is_harvested | `SearchTerm.is_harvested` (Boolean) | EXISTS |
| System remarks | `SearchTerm.system_remarks` | EXISTS |
| User remarks | `SearchTerm.user_remarks` | EXISTS |
| Impressions/Clicks/Spend/Sales/ACOS | Via reporting joins (Redshift aggregation) | EXISTS |
| Active tab | Filtered by `negative_status=False`, active keywords | EXISTS |
| Harvest Queue tab | Filtered by harvest candidates (high-performing search terms) | EXISTS |
| Negatives tab | Filtered by `negative_status_manual=1` or `negative_status=True` | EXISTS |
| High Performers tab | Filtered by performance thresholds (ACOS, conversions) | EXISTS |

**Portal Component:** `SearchTermConfigComponent` at `client/src/app/features/amazon-ads/components/keywords/search-term-config/search-term-config.component.ts`
**API:** `GET /api/amazon-ads/config/search-term-config/` | `PUT /api/amazon-ads/config/search-term-config/`
**Model:** `SearchTerm` at `apps/amazon_ads/models/keywords.py`

---

## 6. KEYWORD RESEARCH (pane-kw-research)

**Status:** EXISTS — Maps to portal's keyword research components

| Prototype Feature | Backend Source | Status |
|---|---|---|
| Keyword list | `AsinKeyword` → `SellerAsinKeyword` | LINKED |
| Search Volume (Exact) | `AsinKeyword.js_monthly_search_volume_exact` (Jungle Scout) | LINKED |
| Search Volume (Broad) | `AsinKeyword.js_monthly_search_volume_broad` | LINKED |
| Organic Rank | `AsinKeyword.js_organic_rank` | LINKED |
| Sponsored Rank | `AsinKeyword.js_sponsored_rank` | LINKED |
| Ease of Ranking Score | `AsinKeyword.js_ease_of_ranking_score` | LINKED |
| CPR | `AsinKeyword.js_cpr` | LINKED |
| Research Status | `AdvertisingAsinConfig.kw_research_status` (5 states) | LINKED |
| Trigger research | `POST /config/asin-config/{id}/trigger-kw-research/` | LINKED |
| Batch tracking | `KeywordResearchAutomationBatch` — PENDING/IN_QUEUE/RECEIVED/APPROVED/FAILED | EXISTS |
| Export results | `GET /api/amazon-ads/keywords-research/export/` | EXISTS |
| Approve/Reset stage | `POST /api/amazon-ads/approve-kw-stage/` / `POST /reset-kw-stage/` | EXISTS |

**Portal Component:** `KeywordResearchComponent`
**API:** `GET /api/amazon-ads/keywords-research/`
**Models:** `AsinKeyword`, `SellerAsinKeyword`, `KeywordResearchAutomationBatch`

---

## 7. KEYWORD AUTOMATION (pane-kw-automation) — 3 Tabs

**Status:** EXISTS — Maps to portal's KW Automation tab components

### Tab 1: Branding Scope & KW-Product Relationship
| Prototype Feature | Backend Source | Status |
|---|---|---|
| Branding scope (NB/OB/CB) | `KeywordBrandingScope.branding_scope` | LINKED |
| Relationship (R/C/S/N) | `KeywordBrandingScope.relationship` | LINKED |
| AI-generated results | RabbitMQ: `keyword_research_automation` → GPT-4-mini | LINKED |
| User approval | `POST /api/amazon-ads/approve-kw-stage/` with stage=BRANDING | EXISTS |
| User feedback | `POST /api/amazon-ads/keyword-user-feedback` | EXISTS |

### Tab 2: Listing Attributes Ranking
| Prototype Feature | Backend Source | Status |
|---|---|---|
| Attribute text | `AttributeRanking.attribute_text` | LINKED |
| Attribute type (ProductType/Variant/UseCase/Audience) | `AttributeRanking.attribute` | LINKED |
| Rank | `AttributeRanking.rank` | LINKED |
| CRUD operations | `GET/PUT/POST/DELETE /api/amazon-ads/attribute-ranking` | EXISTS |

### Tab 3: KWs Grouping & Ranking
| Prototype Feature | Backend Source | Status |
|---|---|---|
| Group name | `KwResearchGroupRank` | LINKED |
| Product type dimension | `KwResearchGroupRank.product_type` | LINKED |
| Group rank | `KwResearchGroupRank.group_rank` | LINKED |
| CRUD | `GET/PUT /api/amazon-ads/group-ranking` | EXISTS |

**Portal Components:**
- `BrandingScopeKwProductTabComponent`
- `ListingAttributesRankingTabComponent`
- `KwsGroupingRankingTabComponent`
**API:** See individual endpoints above
**Models:** `KeywordBrandingScope`, `AttributeRanking`, `KwResearchGroupRank` at `models/keyword_research_automation.py`

---

## 8. DASHBOARD (dashboard-view)

**Status:** EXISTS — Maps to portal's `AdvChartDashboardComponent`

| Prototype Feature | Backend Source | Status |
|---|---|---|
| Total Spend KPI | `SpSearchTermReportAsinAggregate.cost` aggregation | EXISTS |
| Ad Revenue KPI | `SpSearchTermReportAsinAggregate.sales` aggregation | EXISTS |
| ACOS KPI | Computed: spend / revenue × 100 | EXISTS |
| TACOS KPI | Computed: ad spend / total revenue × 100 | EXISTS |
| Orders KPI | `SpSearchTermReportAsinAggregate.orders` | EXISTS |
| Clicks / Impressions / CTR / CVR / CPC | Reporting aggregations | EXISTS |
| Date range selector | API parameter: `date_from`, `date_to` | EXISTS |
| Performance trend chart | `POST /api/amazon-ads/dashboard/target-chart/` | EXISTS |
| Smart Recommendations cards | **ENHANCEMENT** — no backend equivalent currently | ENHANCEMENT |
| Compare to previous period | Client-side comparison; API supports date range params | EXISTS |
| Metrics selector (toggle KPIs) | Client-side visibility; portal has similar in dashboard component | EXISTS |
| Budget Pacing card | `PacingEngineService` status data | EXISTS |
| Action Items / Alerts | **ENHANCEMENT** — high ACOS alerts, budget exhaustion alerts | ENHANCEMENT |

**Portal Component:** `AdvChartDashboardComponent` at `client/src/app/features/amazon-ads/components/shared/dashboard/dashboard.component.ts`
**API:** `POST /api/amazon-ads/dashboard/target-chart/` | Various reporting endpoints
**Data Source:** Redshift aggregations via `SpSearchTermReportAsinAggregate`

**Enhancement Notes:**
- Smart Recommendations: Would need a new backend service analyzing campaign/keyword performance and generating actionable insights
- Action Items: Would need alert rules engine (e.g., ACOS > threshold → alert)

---

## 9. ASIN SETUP WIZARD (5 Steps)

**Status:** LINKED — Already fully mapped in `Wizard-Data-Source-Map.md`

See `Wizard-Data-Source-Map.md` for complete field-to-backend mapping of all 5 wizard steps. Key points:
- Step 1: `GET /product-selection/` + `POST /discover-competitors/`
- Step 2: `POST /trigger-kw-research/` → RabbitMQ → Jungle Scout
- Step 3: RabbitMQ `keyword_research_automation` → GPT-4-mini (3 stages)
- Step 4: `GET/POST /ad-campaign-config/` — dynamic campaign generation
- Step 5: `trigger_auto_campaign_creation.delay()` → RabbitMQ `advertising_create_campaign`

---

## 10. IBO — BULK ASIN LAUNCH (6 Stages)

**Status:** ENHANCEMENT — No direct portal equivalent. IBO is entirely new.

| Prototype Feature | Nearest Backend Source | Status |
|---|---|---|
| Stage 1: Mission Setup | No model — new concept | ENHANCEMENT |
| ASIN batch input | `AdvertisingAsinConfig` bulk create | EXISTS (partial) |
| AI Grouping | No backend — new feature | ENHANCEMENT |
| Target Marketplace | `AmazonSellerCountry` selector | EXISTS |
| Bid Ceiling default | `AdvertisingGlobalConfig.max_bid_limit` | EXISTS |
| Match Type defaults (E/P/B) | `AdvertisingCampaignConfig.match_type` — applied per config | EXISTS |
| Campaign Types (NB/OBH/CB) | `AdvertisingCampaignConfig.campaign_strategy` filtering | EXISTS |
| Bid Strategy | `AdvertisingCampaign.bidding_strategy` | EXISTS |
| Daily Budget default | `AdvertisingAsinConfig.daily_budget` | EXISTS |
| Stage 2: Per-Group Config | Bulk `AdvertisingAsinConfig` + `AdvertisingCampaignConfig` creation | EXISTS (partial) |
| Stage 3: Processing | `POST /trigger-kw-research/` for each ASIN (batch) | EXISTS |
| Stage 4: Review Hub | KW research results review per ASIN | EXISTS |
| Stage 5: Campaign Config | Bulk `AdvertisingCampaignConfig` setup | EXISTS |
| Stage 6: Launch | Bulk `trigger_auto_campaign_creation.delay()` per ASIN | EXISTS |
| Batch History | `localStorage` in prototype — needs `IBOBatch` model in production | ENHANCEMENT |
| Batch Draft Save/Resume | No backend — new feature | ENHANCEMENT |

**Backend Work Required for IBO:**
1. **New Model: `IBOBatch`** — tracks batch missions (name, marketplace, ASINs, status, created_by, timestamps)
2. **New Model: `IBOBatchAsin`** — tracks per-ASIN progress within a batch (FK to batch + asin_config + stage + status)
3. **New API: `POST /api/amazon-ads/ibo/create-batch/`** — create batch with ASIN list + defaults
4. **New API: `GET /api/amazon-ads/ibo/batch/{id}/status/`** — poll batch progress
5. **New API: `POST /api/amazon-ads/ibo/batch/{id}/trigger-research/`** — trigger research for all ASINs in batch
6. **AI Grouping Service** — group ASINs by similarity (product type, category, attributes) — new service
7. **Batch Campaign Creation** — extend `CampaignCreationOrchestrator` to handle batch mode

---

## 11. NOTIFICATION SYSTEM

**Status:** ENHANCEMENT — Portal has no notification bell/dropdown

| Prototype Feature | Nearest Backend Source | Status |
|---|---|---|
| Notification bell + badge | No equivalent | ENHANCEMENT |
| Notification dropdown | No equivalent | ENHANCEMENT |
| KW Research complete notification | `AdvertisingAsinConfig.kw_research_status` change event | ENHANCEMENT |
| Budget cap alert | `PacingEngineService` → daily spend tracking | ENHANCEMENT |
| Bid auto-adjust alert | `BidCalculationService` execution log | ENHANCEMENT |
| Mark all read | No equivalent | ENHANCEMENT |

**Backend Work Required:**
1. **New Model: `UserNotification`** — (user, message, type, read_status, created_at, link)
2. **New API: `GET /api/notifications/`** — list user notifications
3. **New API: `PATCH /api/notifications/mark-read/`** — mark as read
4. **Trigger Points:** After KW research completes, after campaign creation, after pacing events, after bid adjustments
5. **Delivery:** WebSocket (real-time) or polling (simple)

---

## 12. GLOBAL CONFIG / SETTINGS

**Status:** EXISTS — Maps to portal's global config

| Prototype Feature | Backend Source | Status |
|---|---|---|
| Global Target ACOS | `AdvertisingGlobalConfig.target_acos` | LINKED |
| Global Max Bid Limit | `AdvertisingGlobalConfig.max_bid_limit` | LINKED |
| Auto Budget toggle | `AdvertisingGlobalConfig.auto_budget` | EXISTS |

**Portal Service:** `GlobalConfigService`
**API:** `GET/PUT /api/amazon-ads/config/config/0`
**Model:** `AdvertisingGlobalConfig` at `apps/amazon_ads/models/config.py:283`

---

## 13. ADS PERFORMANCE DASHBOARDS (6 sub-pages)

**Status:** EXISTS — Maps to portal's performance dashboard components

| Prototype Feature | Backend Source | Status |
|---|---|---|
| ASIN Dashboard | `GET /api/amazon-ads/products-report` | EXISTS |
| Targeting Dashboard | `GET /api/amazon-ads/targeting/asin-aggregated/` | EXISTS |
| Search Terms | `GET /api/amazon-ads/search-terms/aggregated/` | EXISTS |
| Targeting Records | `GET /api/amazon-ads/targeting/` detail records | EXISTS |
| Search Term Records | `GET /api/amazon-ads/search-terms/` detail records | EXISTS |
| ASIN Deep Dive | `GET /api/amazon-ads/sp-deep-dive-report` | EXISTS |
| Date range filtering | API params: `date_from`, `date_to`, period presets | EXISTS |
| Period comparison | Client-side comparison with previous period data | EXISTS |

**Portal Components:** `PerformanceDashboardsComponent` with sub-components per dashboard
**API:** Various reporting endpoints above
**Data Source:** Redshift via `SpSearchTermReportAsinAggregate` and related models

---

## 14. LOGS SECTION (5 sub-pages)

**Status:** EXISTS — Maps to portal's logging components

| Prototype Feature | Backend Source | Status |
|---|---|---|
| Config Change Log | `AdvertisingConfigChangeLog` model | EXISTS |
| Negative KW Log | `AdvertisingNegativeKeyword` creation/deletion audit | EXISTS |
| Keywords Log | Keyword change tracking | EXISTS |
| Bid Strategy Logs | `BidCalculationService` execution logs | EXISTS |
| Performance Analysis | Reporting aggregation | EXISTS |

---

## 15. BID TOOLS (4 sub-pages)

**Status:** EXISTS — Maps to portal's bidding components

| Prototype Feature | Backend Source | Status |
|---|---|---|
| Bid Optimization | `BidCalculationService` at `services/bid_calculation.py` | EXISTS |
| Keyword Bid Status | `AdvertisingKeyword.bid`, `applied_bid`, ceiling/floor | EXISTS |
| Upload History | File upload tracking for bulk imports | EXISTS |
| Pacing Management | `PacingEngineService` at `services/pacing_engine.py` | EXISTS |

**Pacing API Endpoints:**
- `GET /api/amazon-ads/projections/asins/{id}/pacing/status/` — status
- `POST /projections/asins/{id}/pacing/enable/` — enable
- `POST /projections/asins/{id}/pacing/disable/` — disable
- `POST /projections/asins/{id}/pacing/run/` — manual trigger
- `GET /projections/asins/{id}/pacing/campaigns/` — campaign pacing states
- `GET /projections/asins/{id}/pacing/history/` — execution history
- `POST /projections/campaigns/{id}/lock/` — lock campaign state
- `POST /projections/campaigns/{id}/unlock/` — unlock

---

## SUMMARY: GAPS & ACTION ITEMS

### Features Fully Linked (No Action Needed)
1. Wizard Steps 1-5 (already annotated in prototype + Wizard-Data-Source-Map.md)
2. Campaign Config tab fields
3. Global Config fields

### Codebase Alignment Fixes Applied (2026-03-12)
3 mismatches identified and corrected to match actual codebase:
1. **Target ACOS defaults** — Was: 35%/60%/45% per strategy. Fixed: empty (null) — `target_acos = FloatField(null=True)` has no default. User must set via "Apply to All."
2. **Daily Budget defaults** — Was: $10/$8 per strategy. Fixed: $5.00 universally — `base.py:104` fallback: `config.daily_budget or asin_config.daily_budget or 5.0`.
3. **Optimize Bid default** — Was: ON (True). Fixed: OFF (False) — `AdvertisingCampaign.optimize_bid = BooleanField(default=False)`.
4. IBO Stage 5 static campaign tables also corrected: all SPAU/SPAS rows now show $5 budget and no preset ACOS.

### Wizard Timing Corrections (2026-03-12)
Verified against live portal at `portal.keplercommerce.com/amazon-ads/campaign-wizard/` via Playwright:

| Step | Old Prototype | Live Portal Estimate | Actual Observed | Corrected Prototype |
|------|--------------|---------------------|----------------|-------------------|
| **Step 2: KW Research** | 20-30 min | "1-5 minutes" | ~8 min | **5-10 min** |
| **Step 3: KW Automation** | 3-10 min | "3-10 minutes" | Still running after 4 min (user reports 25-30 min) | **25-30 min** |

Changes applied:
1. Step 2 banner: "20–30 minutes" → "5–10 minutes"
2. Step 2 ETA: "~25 minutes" → "~8 minutes"
3. Step 2 `_kwResearchPhases`: Reduced from 10 to 7 phases, ETAs 8→1 min
4. Step 2 completion message: "156 keywords" → "1,437 keywords" (matches live portal count)
5. Step 3 banner: Added new "25–30 minutes" time estimate callout
6. Step 3 option card: "3-10 minutes" → "25-30 minutes"
7. Step 3 ETA: "~8 minutes" → "~25 minutes"
8. Step 3 `startKwAutomation()` phases: Expanded from 8 to 12 phases, ETAs 25→1 min

### Features That Exist in Portal — All Annotated (COMPLETE)
All prototype views now have DATA SOURCE HTML comment annotations:
1. **Campaigns List** (pane-campaigns) — LINKED
2. **Campaign Config tab** (pane-camp-config) — LINKED
3. **Keyword Settings tab** (pane-kw-config) — LINKED
4. **Search Term Settings** (pane-st-config, 4 sub-tabs) — LINKED
5. **KW Research page** (pane-kw-research) — LINKED
6. **KW Automation page** (pane-kw-automation) — LINKED
7. **Dashboard** (dashboard-view) — LINKED
8. **Ads Performance dashboards** (ads-perf-view) — LINKED
9. **Logs section** (logs-view) — LINKED (ENHANCEMENT)
10. **Bid Tools section** (bid-opt-view, kw-bid-view) — LINKED (ENHANCEMENT)
11. **Pacing Management** (pacing-view) — LINKED
12. **Settings / Global Config** (settings-view) — LINKED
13. **Analytics** (analytics-view) — LINKED (ENHANCEMENT)
14. **Benchmark Scorecard** (bsc-view) — LINKED (ENHANCEMENT)
15. **APDC Diagnostics** (apdc-view) — LINKED (ENHANCEMENT)
16. **Reports** (reports-view) — LINKED
17. **Upload History** (upload-hist-view) — LINKED (ENHANCEMENT)
18. **IBO** (asin-ibo-view) — LINKED (ENHANCEMENT)
19. **Automated Listings** (listings-view) — LINKED (ACG module, not ad API)
20. **Ads Management parent** (campaigns-view) — LINKED

### Portal Enhancements (New Features Needing Backend Work)
1. **ASIN Overview "Launch Status"** — needs computed status field or new `setup_wizard_step` field on `AdvertisingAsinConfig`
2. **IBO Batch System** — needs new models (`IBOBatch`, `IBOBatchAsin`), APIs, and services
3. **AI Grouping for IBO** — new service to cluster ASINs by similarity
4. **Notification System** — needs new model, API, WebSocket/polling, trigger points
5. **Smart Recommendations** — needs new analytics service generating actionable insights
6. **Action Item Alerts** — needs alert rules engine (ACOS threshold, budget exhaustion)
7. **IBO Batch History/Draft** — needs persistence model instead of localStorage

### How Enhancements Connect to Existing Codebase

| Enhancement | Connects To | How |
|---|---|---|
| Launch Status | `AdvertisingAsinConfig.kw_research_status` + `AdvertisingCampaign` existence | Add `@property setup_step` on model or computed serializer field |
| IBO Batch | `AdvertisingAsinConfig` bulk create + `trigger_kw_research` per ASIN | New models + orchestrator extending existing per-ASIN flow |
| Notifications | All async consumers (campaign creation, KW research, pacing) | Add `UserNotification.create()` call at completion points in consumers |
| Smart Recommendations | `BidCalculationService` + `SpSearchTermReportAsinAggregate` analytics | New service analyzing performance data, similar to bid calculation logic |
| Action Alerts | `PacingEngineService` events + daily budget tracking | Hook into existing pacing audit trail + add threshold checks |
