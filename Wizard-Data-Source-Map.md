# ASIN Setup Wizard — Data Source Map

**Purpose:** Maps every wizard field to its backend source (model, API, service) to address Abdul's 7 Jira content gaps.
**Prototype:** `Advertising Portal UI Design.html`
**Codebase:** `kepler-portal-sync/`
**Last updated:** 2026-03-11

---

## Content Gap #1: Campaign Count is DYNAMIC

**Current ticket says:** "16 campaigns"
**Reality:** Campaign count is driven by a formula:

```
Total = (Match Types per Strategy) x (Relevancy Tags) x (ASINs)
      + HP campaigns (if enabled)
      + SPAS campaigns (per competitor brand group)
```

**What drives the count:**

| Factor | Source | Model/Field |
|--------|--------|-------------|
| Relevancy Tags | KW Automation AI output | `KwResearchGroupRank` |
| Match Types | `AdvertisingCampaignConfig.match_type` | EXACT, PHRASE, BROAD (SPKW); CLOSE/LOOSE/SUBS/COMP (SPAU); TARGETING_EXPRESSION (SPAS) |
| Campaign Strategy | `AdvertisingCampaignConfig.campaign_strategy` | MANUAL=1, HP=2, AUTO=3, ASIN_TARGETING=4 |
| Competitor Brands | `AdvertisingAsinConfig.competitor_asins` (JSON) | Each brand group = 1 SPAS campaign |

**Backend logic:**
- File: `apps/amazon_ads/applications/campaigns/services/campaign_creation/config_fetcher.py` (lines 43-57)
- Queries `AdvertisingCampaignConfig` for enabled configs per ASIN
- Each unique (asin_config + relevancy_tag + match_type + strategy) = 1 campaign

**Typical breakdown for single ASIN:**
- 3 MANUAL (E/P/B) per relevancy tag × N tags
- 4 AUTO (C/L/S/M) — always 4
- N SPAS — 1 per competitor brand group
- 0-1 HP — optional high-performer campaigns

**Prototype note:** Wizard Step 4 shows 16 campaigns as example data. In production, this is dynamic.

---

## Content Gap #2: Optimize Bid Scope = PER-CAMPAIGN

**Current ticket implies:** Could be ASIN-level
**Reality:** Optimize Bid is **per-campaign only**

| Level | Field | Model | File |
|-------|-------|-------|------|
| Campaign | `optimize_bid` | `AdvertisingCampaign` | `models/campaigns.py:69` |

- Type: `BooleanField(default=False)` — disabled by default
- Added: Migration `0019_advertisingcampaign_optimize_bid.py` (June 2025)
- API: Bulk update via `POST /api/amazon-ads/campaigns/` with `optimize_bid` field
- UI: Bulk action dialog at `client/src/app/features/amazon-ads/components/campaigns/campaigns-list/bulk-actions/action-dialogs/optimize-bid/`
- Serializer read: Returns "ENABLED" or "DISABLED" string (`serializers.py:284-285`)

**Prototype note:** Wizard Step 4 has per-campaign Opt toggle (correct). Step 5 has master toggle that sets all campaigns (convenience shortcut, not a real ASIN-level field).

---

## Content Gap #3: Global Target ACOS — EXISTS but acts as FALLBACK

**Current ticket references:** Global Target ACOS field
**Reality:** Target ACOS exists at **4 levels** with inheritance:

| Level | Model | Field | File | Validator |
|-------|-------|-------|------|-----------|
| Global (seller-wide) | `AdvertisingGlobalConfig` | `target_acos` | `models/config.py:283` | 1-100 |
| ASIN | `AdvertisingAsinConfig` | `target_acos` | `models/config.py:61` | 1-100 |
| Campaign | `AdvertisingCampaignConfig` | `target_acos` | `models/config.py:163` | 1-100 |
| Keyword | `AdvertisingKeyword` | `target_acos` / `applied_target_acos` | `models/keywords.py:42-43` | — |

**Inheritance chain:** Global → ASIN → Campaign → Keyword
- If campaign has no target_acos, falls back to ASIN's
- If ASIN has none, falls back to Global
- `applied_target_acos` on keyword = the effective value used in bid calc

**API endpoints:**
- Global: `PATCH /api/amazon-ads/config/global/{seller_country_id}/`
- ASIN: `PATCH /api/amazon-ads/config/asin/{id}/`
- Campaign: `PATCH /api/amazon-ads/config/campaign/{id}/`

**Bid formula:** `optimal_bid = price × target_acos × cvr`

**Prototype note:** Global ACOS hidden input exists (`id="globalAcos"`) with comment "REMOVED per Abdul feedback (being deprecated, ticket to Andrew)". Per-campaign ACOS inputs in Step 4 are correct. "Apply to All" bulk action is a UI convenience, not a Global ACOS field.

---

## Content Gap #4: Negative KW Scope Selector = NET-NEW

**Current ticket treats as:** Existing functionality
**Reality:** Negative keywords are **per-campaign only** — NO scope selector exists

| What Exists | What's New (Wizard) |
|-------------|---------------------|
| `AdvertisingCampaignConfig.custom_negative_keywords` (JSON field per campaign) | Scope selector: All / Manual / Auto / PT |
| `AdvertisingNegativeKeyword` model with FK to `campaign` and `ad_group` | Bulk-apply across campaign types |
| `CustomNegativeKeywordsManager.create_custom_negative_keywords()` | — |
| RabbitMQ queue: `advertising_create_negative_keywords` | — |
| Match types: NEGATIVE_EXACT (hardcoded) | — |

**Current backend flow:**
1. User adds keywords to `AdvertisingCampaignConfig.custom_negative_keywords` (JSON)
2. `CustomNegativeKeywordsManager` compares against Amazon Ads API current negatives
3. New negatives sent to RabbitMQ queue → consumer calls Amazon API
4. Results stored in `AdvertisingNegativeKeyword` table

**What the wizard scope selector requires (NEW backend work):**
- New endpoint to accept scope (ALL/MANUAL/AUTO/PT) + keyword list
- Logic to resolve scope → campaign IDs (filter by campaign_strategy)
- Bulk-create negative keywords across multiple campaign configs
- This is NOT a UI-only change — requires new service logic

**Files:**
- Model: `models/keywords.py:156-129`
- Manager: `applications/keywords/managers/custom_negative_keywords.py`
- Consumer: `applications/keywords/consumers/create_negative_keywords/consumer.py:13-66`
- API: `managers/api_mng/negative_keywords.py:14-64`

**Prototype note:** Wizard Step 4 has `<select id="negKwScope">` with All/Manual/Auto/PT options. This is net-new and must be flagged as requiring backend work.

---

## Content Gap #5: Error Scenarios

### Existing Error Handling in Codebase:

**A. KW Research Failure**
- Endpoint: `POST /api/amazon-ads/config/asin-config/{id}/trigger-kw-research/`
- File: `applications/config/api/views.py:153-281`
- Errors:
  - Status check: "Cannot trigger keyword research. Current status: {status}" (must be `READY_TO_GENERATE`)
  - Batch creation failure: "Failed to create research batches"
  - Validation: `KwResearchActivityLogger.log_validation_failed()`
- Batch statuses: PENDING → IN_QUEUE → RECEIVED → APPROVED / FAILED

**B. Amazon API Rejection**
- Campaign creation consumer: `applications/campaigns/consumers/create_campaign/consumer.py:24-276`
- Services: `CampaignService`, `AdGroupService`, `KeywordService`, `NegativeKeywordService`
- Each service wraps Amazon Ads API calls with error handling
- Failed campaigns logged but don't block other campaigns

**C. Budget Below Minimum**
- ASIN level: `MinValueValidator(5.01)` — models/config.py:34
- Campaign level: `MinValueValidator(5)` — models/config.py:164
- Migration: `0082_alter_advertisingasinconfig_daily_budget_and_more.py` (Dec 2025)

**D. ASIN Ineligibility**
- Product selection serializer: `product_selection_serializers.py:101-109`
- Checks: INELIGIBLE → "This product is not eligible for advertising"
- Checks: SUPPRESSED → "This product is suppressed and cannot be used for advertising"

**E. State Machine Transitions**
- File: `services/kw_research_automation/asin_config_state_machine.py`
- Insufficient data: no competitors, keywords not ready, ASIN data missing
- Returns: `KwResearchStatus.INSUFFICIENT_DATA` with reason

**F. AI Processing Errors**
- Validator classes: `KeywordBrandingScopeValidator`, `AttributesRankingValidator`, `GroupingRankingValidator`
- Returns: `ValidationResult(parsed_output, overall_errors, key_errors)`
- Feedback loop: users can correct AI results, system re-prompts

### Error Scenarios NOT Handled (gaps for wizard):
- Mid-wizard ASIN ineligibility (ASIN suppressed between Step 1 and Step 5)
- Partial campaign creation failure (some campaigns created, some fail)
- Network timeout during research (no retry/resume mechanism in wizard)
- Concurrent wizard sessions for same ASIN

---

## Content Gap #6: Data Source Clarity — Full Field Map

### Step 1: Product Selection

| Field | Source | Model | API Endpoint |
|-------|--------|-------|-------------|
| Product list | SP-API inventory sync | `AdvertisingProduct` | `GET /api/amazon-ads/config/product-selection/` |
| ASIN | Amazon catalog | `AdvertisingProduct.asin` | Same |
| Product title | SP-API | `AdvertisingProduct` → `Asin.title` | Same |
| SP Status (Eligible/Ineligible) | SP-API | `AdvertisingProduct.sp_overall_status` | Same |
| Product image | Amazon catalog | Asin data | Same |
| Competitor ASINs | AI discovery OR manual entry | `AdvertisingAsinConfig.competitor_asins` (JSON) | `POST /api/amazon-ads/products/discover-competitors/` |

### Step 2: KW Research

| Field | Source | Model | API Endpoint |
|-------|--------|-------|-------------|
| Keywords | Jungle Scout via Keepa | `AsinKeyword` → `SellerAsinKeyword` | `POST /trigger-kw-research/` |
| Search Volume (Exact) | Jungle Scout | `AsinKeyword.js_monthly_search_volume_exact` | Fetched during research |
| Search Volume (Broad) | Jungle Scout | `AsinKeyword.js_monthly_search_volume_broad` | Same |
| Organic Rank | Jungle Scout | `AsinKeyword.js_organic_rank` | Same |
| Sponsored Rank | Jungle Scout | `AsinKeyword.js_sponsored_rank` | Same |
| CPR | Jungle Scout | `AsinKeyword.js_cpr` | Same |
| Ease of Ranking | Jungle Scout | `AsinKeyword.js_ease_of_ranking_score` | Same |
| Research Status | Backend state machine | `AdvertisingAsinConfig.kw_research_status` | Polled via config endpoint |

### Step 3: KW Automation

| Field | Source | Model | API Endpoint |
|-------|--------|-------|-------------|
| Branding Scope (NB/OB/CB) | AI (gpt-4-mini) | `KeywordBrandingScope` | RabbitMQ: `keyword_research_automation` |
| Relationship (R/C/S/N) | AI (gpt-4-mini) | `KeywordBrandingScope.relationship` | Same |
| Listing Attributes | AI (gpt-4-mini) | `AttributeRanking` | Same |
| Attribute Types | AI output | Product Type, Variant, Use Case, Audience | Same |
| Group Rankings | AI (gpt-4-mini) | `KwResearchGroupRank` | Same |
| Relevancy Tags | AI grouping output | Generated from branding + attributes | Same |

### Step 4: Campaign Config

| Field | Source | Model | API Endpoint |
|-------|--------|-------|-------------|
| Campaign Name | Generated by system | `utils.py:116-167` — `{PREFIX}-{AD_TYPE}-{BRAND}-{SERIES}-{TYPE}-{ASIN}-{MATCH}-{SUFFIX}` | N/A (computed) |
| Campaign Type (SPKW/SPAU/SPAS) | Strategy selection | `AdvertisingCampaignConfig.campaign_strategy` | `GET /api/amazon-ads/config/ad-campaign-config/` |
| Match Type | Config | `AdvertisingCampaignConfig.match_type` | Same |
| Targeting Spec / Group Name | Relevancy tag + strategy | `AdvertisingCampaignConfig.relevancy_tag` | Same |
| Brand Name (SPAS) | Competitor discovery | `SpasCampaignService` → brand groups | Same |
| Keyword Count | Aggregated from research | Count of `SellerAsinKeyword` per group | Computed |
| Total Search Volume | Aggregated from research | Sum of `AsinKeyword.js_monthly_search_volume_exact` per group | Computed client-side |
| Median Search Volume | Aggregated from research | Median of search volumes per group | Computed client-side |
| Target ACOS | User input / inheritance | `AdvertisingCampaignConfig.target_acos` → fallback `AdvertisingAsinConfig.target_acos` → `AdvertisingGlobalConfig.target_acos` | `POST /api/amazon-ads/config/ad-campaign-config/` |
| Daily Budget | User input / inheritance | `AdvertisingCampaignConfig.daily_budget` → fallback `AdvertisingAsinConfig.daily_budget` | Same |
| Status (ENABLED/PAUSED) | User selection | `AdvertisingCampaignConfig.ad_status` | Same |
| Optimize Bid toggle | User selection | `AdvertisingCampaign.optimize_bid` (Boolean) | `POST /api/amazon-ads/campaigns/` |
| Negative Keywords | User input | `AdvertisingCampaignConfig.custom_negative_keywords` (JSON) | Same |
| Auto Pacing | User toggle | `AdvertisingAsinConfig.auto_pacing_enabled` | `PATCH /api/amazon-ads/config/asin/{id}/` |
| Bid Ceiling | User input | `AdvertisingKeyword.ceiling_bid` (per-keyword, not per-campaign) | Keyword update API |
| Bid Floor | User input | `AdvertisingKeyword.floor_bid` (per-keyword, not per-campaign) | Keyword update API |

### Step 5: Activate

| Field | Source | Model | API Endpoint |
|-------|--------|-------|-------------|
| Campaign count | Computed | Count of enabled `AdvertisingCampaignConfig` rows | Computed |
| Total daily budget | Computed | Sum of campaign daily_budgets | Computed client-side |
| Keyword count | Computed | Count of `SellerAsinKeyword` in scope | Computed |
| Kepler Optimization | Master toggle (UI only) | Sets all `AdvertisingCampaign.optimize_bid` | Bulk update |
| Auto Budget | ASIN config | `AdvertisingAsinConfig.auto_budget` | Config endpoint |
| Complete Setup action | Triggers campaign creation | `trigger_auto_campaign_creation.delay()` | RabbitMQ: `advertising_create_campaign` |

---

## Content Gap #7: Delta (What Changes) vs Destination (What It Looks Like)

### What EXISTS Today (Current System):

| Feature | Current Location | Status |
|---------|-----------------|--------|
| Product Selection | `GET /product-selection/` + 2-step component | EXISTS — select product + discover competitors |
| Competitor Discovery | `POST /discover-competitors/` with AI streaming | EXISTS — AI-powered, 40-70 sec processing |
| KW Research trigger | `POST /trigger-kw-research/` | EXISTS — async via RabbitMQ |
| KW Automation (Branding/Attributes/Grouping) | AI pipeline via RabbitMQ | EXISTS — 3-stage AI processing |
| Campaign Config CRUD | `GET/POST /ad-campaign-config/` | EXISTS — full CRUD with validation |
| Campaign Creation | `advertising_create_campaign` queue → orchestrator | EXISTS — async campaign creation |
| Negative Keywords | Per-campaign JSON + manager | EXISTS — per-campaign only |
| Auto Pacing | `PacingEngineService` | EXISTS — full engine with audit trail |
| Bid Calculation | `BidCalculationService` | EXISTS — price × ACOS × CVR with constraints |

### What's NEW in the Wizard (Delta):

| Feature | What's New | Backend Work Required |
|---------|-----------|----------------------|
| **Unified 5-step wizard UI** | Single flow wrapping existing steps | Frontend only — backend endpoints exist |
| **Negative KW scope selector** | All/Manual/Auto/PT bulk-apply | NEW backend logic — resolve scope to campaign IDs |
| **Match Type Strategy UI** | Check/uncheck to ENABLE/PAUSE by match type | Frontend only — maps to existing ad_status field |
| **Bulk Apply ACOS/Budget** | Apply to all campaigns at once | Frontend convenience — calls existing per-campaign API in loop |
| **ASIN-Level Settings panel** | Auto Pacing + Bid Ceiling in wizard | Frontend only — existing endpoints |
| **Launch Summary** | Aggregated stats before activation | Frontend computation — no new API |
| **Bid Ceiling/Floor at campaign level** | Wizard shows per-campaign | SCOPE MISMATCH — backend is per-keyword, wizard implies per-campaign. Needs clarification. |
| **Notification on KW Research complete** | Bell notification when async research finishes | NEW — needs WebSocket or polling mechanism |
| **User-provided KWs before research** | Manual keyword entry in wizard | PARTIAL — manual add exists in KW Research UI, needs wizard integration |

### Scope Mismatches — ALL RESOLVED (2026-03-11):

1. **Bid Ceiling/Floor**: RESOLVED — Removed from wizard. Note added pointing users to Keyword Settings (per-keyword, post-setup). Matches portal: `keyword-config.component.ts` columns `ceiling_bid`, `floor_bid`.
2. **Optimize Bid Master Toggle**: OK — Per-campaign in backend, master toggle in Step 5 = bulk-update convenience. No change needed.
3. **Negative KW Scope**: RESOLVED — Removed scope selector (All/Manual/Auto/PT). Wizard now matches portal: simple textarea applied as `custom_negative_keywords` to all non-ASIN_TARGETING campaigns. Per-campaign granularity available in Campaign Config post-setup.

---

## Key Backend Files Reference

### Models
| Model | File | Key Fields |
|-------|------|------------|
| `AdvertisingAsinConfig` | `models/config.py:40-115` | daily_budget, target_acos, competitor_asins, auto_pacing_enabled, kw_research_status |
| `AdvertisingCampaignConfig` | `models/config.py:125-270` | match_type, target_acos, daily_budget, campaign_strategy, custom_negative_keywords, relevancy_tag |
| `AdvertisingGlobalConfig` | `models/config.py:283` | target_acos (seller-wide fallback) |
| `AdvertisingCampaign` | `models/campaigns.py` | budget, optimize_bid, state |
| `AdvertisingKeyword` | `models/keywords.py` | target_acos, applied_target_acos, ceiling_bid, floor_bid, fixed_bid |
| `AdvertisingNegativeKeyword` | `models/keywords.py:156+` | FK to campaign + ad_group, match_type, state |
| `KeywordBrandingScope` | `models/keyword_research_automation.py` | branding_scope (NB/OB/CB), relationship (R/C/S/N) |
| `AttributeRanking` | `models/keyword_research_automation.py` | attribute_text, attribute, rank |
| `KwResearchGroupRank` | `models/keyword_research_automation.py` | product_type, dimension, group_rank |

### Services
| Service | File | Purpose |
|---------|------|---------|
| `CampaignCreationOrchestrator` | `services/campaign_creation/orchestrator.py:34-206` | Main campaign creation flow |
| `CampaignConfigFetcher` | `services/campaign_creation/config_fetcher.py:43-57` | Fetches enabled configs |
| `AdvertisingConfigService` | `services/advertising_config_service.py` | ASIN config CRUD |
| `AdvertisingCampaignConfigService` | `services/advertising_campaign_config_service.py:97+` | Campaign config CRUD |
| `CustomNegativeKeywordsManager` | `managers/custom_negative_keywords.py` | Negative KW CRUD |
| `PacingEngineService` | `services/pacing_engine.py:1-80` | Auto pacing orchestration |
| `BidCalculationService` | `services/bid_calculation.py` | Bid calc: price × ACOS × CVR |
| `SpasCampaignService` | `services/asin_research/spas_campaign_service.py:37-150+` | SPAS campaign creation after brand discovery |

### API Endpoints
| Endpoint | Method | File | Purpose |
|----------|--------|------|---------|
| `/api/amazon-ads/config/product-selection/` | GET | `product_selection_views.py:39-136` | List available products |
| `/api/amazon-ads/config/product-selection/validate-next/` | POST | `product_selection_views.py:138-197` | Validate product before next step |
| `/api/amazon-ads/products/discover-competitors/` | POST | `product_selection_views.py:243-443` | AI competitor discovery (SSE) |
| `/api/amazon-ads/products/save-selection/` | POST | `product_selection_views.py:513-633` | Save product + competitors → triggers campaigns |
| `/api/amazon-ads/config/asin-config/{id}/trigger-kw-research/` | POST | `views.py:153-281` | Trigger KW research |
| `/api/amazon-ads/config/asin-config/` | PUT | `views.py:130-146` | Bulk update ASIN configs |
| `/api/amazon-ads/config/ad-campaign-config/` | GET/POST | `views.py:360-491` | Campaign config CRUD |
| `/api/amazon-ads/config/global/{id}/` | PATCH | `views.py` | Update global config |
| `/api/amazon-ads/campaigns/` | POST | `entity_views.py` | Bulk update campaigns (optimize_bid) |

### RabbitMQ Queues
| Queue | Exchange | Purpose |
|-------|----------|---------|
| `keyword_research_automation` | `amazon_ads` | KW research AI processing |
| `advertising_create_campaign` | `amazon_ads` | Campaign creation on Amazon |
| `advertising_create_negative_keywords` | `amazon_ads` | Negative KW creation |
| `advertising_update_negative_keywords` | `amazon_ads` | Negative KW updates |

### Campaign Naming Convention
```
{RELEVANCY_TAG_ID}-{AD_TYPE}-{BRAND_CODE}-{PRODUCT_SERIES}-{CAMPAIGN_TYPE}-{ASIN}-{MATCH_TYPE}-{SUFFIX}

Examples:
  NBH1-SPKW-PB01-XX-S-B09L4KWX6Q-E-KW     (NB Highly Relevant, Exact, Manual KW)
  XXXXXX-SPAU-PB01-XX-S-B09L4KWX6Q-C-KW    (Auto, Close Match)
  XXXXXX-SPAS-PB01-XX-S-B09L4KWX6Q-X-YankeeCandle  (Product Targeting, brand)
  HPXXXX-SPKW-PB01-XX-S-B09L4KWX6Q-E-HV    (High Performer, Harvesting)

Components:
  PREFIX:    Relevancy Tag ID (e.g., NBH1, OBH1, CBH1) or XXXXXX/HPXXXX
  AD_TYPE:   SPKW (Manual KW), SPAU (Auto), SPAS (Product Targeting)
  BRAND:     get_brand_code() from brand name (e.g., PB01)
  SERIES:    XX (default)
  TYPE:      S (single ASIN)
  MATCH:     E(xact), P(hrase), B(road), C(lose), L(oose), S(ubs), M(comp), X(expression)
  SUFFIX:    KW (keyword), brand name (SPAS), HV (harvesting)
```

File: `apps/amazon_ads/managers/utils.py:116-167`
