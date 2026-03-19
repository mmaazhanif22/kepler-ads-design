# ASIN Advertising Setup Wizard

# User Story

As a seller, I want a guided 5-step wizard for setting up ASIN advertising so that I can launch campaigns without navigating disconnected configuration pages.

# Problem / Context

- Setting up advertising for a new ASIN requires configuring multiple interdependent settings across separate pages: product selection, competitor research, keyword research, campaign structure, and launch parameters.
- Sellers navigate to ASIN Config, then a sub-tab for competitors, then trigger KW research manually, then configure campaigns on yet another page. There is no enforced order or completion tracking.
- Automated Keyword Research takes approximately 20 minutes. There is no notification when it finishes, so sellers must manually poll the page.
- New sellers do not know which settings matter or in what order to configure them. Support requests are frequent.
- There is no way to resume a partially completed setup. Closing the page loses all progress.

# Solution Outline

**5-step modal wizard overlay:**
- Wizard opens over the main portal content. Not a routed page. State stored in an Angular service with localStorage backup for resume.
- Progress indicator at the top showing current step and completion state.

**Step 1 - Product Selection:**
- Seller selects ASIN from product catalog. Sets Target ACOS (required, no default). Optional: Auto Pacing toggle, Bid Ceiling field.
- Data: `GET /api/amazon-ads/config/asin-config/` for ASIN list. `PUT /api/amazon-ads/config/asin-config/` to save.

**Step 2 - Automated Competitor Research:**
- Seller enters competitor ASINs. System validates they exist on the marketplace. Multiple competitors supported.
- Data: `GET /analytics/search_terms/competitor_asins` for existing competitor data. Competitors saved to `AdvertisingAsinConfig.competitor_asins` (SafeJSONField).

**Step 3 - Automated Keyword Research:**
- Phase 1 (Fetching) triggers via `POST /api/amazon-ads/approve-kw-stage` with `prompt_type=1`. Phase 2 (Analysis) auto-triggers with `prompt_type=2`, then `prompt_type=3`.
- Frontend polls `kw_research_status` on the ASIN config endpoint. Status values: 1=Insufficient Data, 2=Ready, 3=In Progress, 4=Pending Review, 5=Submitted.
- On completion, auto-advances to Step 4. If seller navigated away, Notification Bell fires an alert so they can return.

**Step 4 - Campaign Config:**
- System displays dynamically generated campaigns in 3 sections: SPKW (1 per keyword group per match type), SPAU (4 auto-targeting campaigns), SPAS (1 per competitor brand).
- Campaign count varies per ASIN. Generation logic: `CampaignService.create_campaigns()` using `KwResearchGroupRank` groups and `AdvertisingCampaignConfig` match type settings.
- Auto Budget toggle, ASIN-Level Defaults, bulk select/enable, per-campaign negative keywords, Pacing badges.
- Campaign names follow Kepler convention (`NBH1-SPKW-PB01-{Country}-S-{ASIN}-{Match}-KW`), system-generated and read-only.
- Listing Quality Score panel shows quality gauge from `GET /api/amazon-ads/attribute-ranking?asin=<id>`.

**Step 5 - Activate:**
- Non-technical Bid Optimization explanation. Ads toggle note. Pre-launch checklist with green/amber indicators for completed/skipped items.
- "Complete Setup" button activates campaigns via `AdvertisingCampaignConfigService.bulk_update()`.
- 3 navigation cards after completion: Manage Ads, Keyword Settings, Search Term Settings.

**Wizard Edit Mode:**
- Launched ASINs show "Edit" button in ASIN Config table. Edit menu offers direct navigation to Steps 2-5.
- "Edit Mode" indicator shown. All previously saved settings pre-populated.

**Behavior flow:**
1. Seller clicks "ASIN Launch" in sidebar > wizard modal opens at Step 1.
2. Seller selects ASIN, sets Target ACOS > clicks Next > Step 2 loads.
3. Seller enters competitor ASINs > clicks Next > Step 3 auto-triggers research.
4. Research completes (~20 min) > wizard auto-advances to Step 4. If seller left, Notification Bell alerts them.
5. Seller reviews generated campaigns, adjusts budgets > clicks Next > Step 5 shows checklist.
6. Seller clicks "Complete Setup" > campaigns activate on Amazon.

# Connected Work Items

**Blocks:** [PROD-4124](https://keplercommerce.atlassian.net/browse/PROD-4124), [PROD-4125](https://keplercommerce.atlassian.net/browse/PROD-4125) (wizard creates config these views manage)
**Relates To:** [PROD-4121](https://keplercommerce.atlassian.net/browse/PROD-4121) (IBO, the bulk equivalent), [PROD-4122](https://keplercommerce.atlassian.net/browse/PROD-4122) (Manage Ads, alternative entry point)

# Implementation Notes

- Current component: `ProductSelectionComponent` at `client/src/app/features/amazon-ads/add-product/select/`. Currently a standalone page. Wrap inside new `WizardDialogComponent` modal overlay.
- Competitor storage: `AdvertisingAsinConfig.competitor_asins` (SafeJSONField) at `apps/amazon_ads/models/config.py:62`. Save via PUT `/api/amazon-ads/config/asin-config/{id}/`.
- KW Research trigger: `KwResearchApprovedApiViewV` at `apps/amazon_ads/api/views/entity_views.py:1532`. POST `/api/amazon-ads/approve-kw-stage` with `{asin_id, prompt_type}`.
- Campaign creation: `CampaignCreationOrchestrator` at `apps/amazon_ads/applications/campaigns/services/campaign_creation/orchestrator.py`. Triggered via RabbitMQ consumer `advertising_create_campaign`.
- Campaign naming: `get_campaign_name()` at `apps/amazon_ads/managers/utils.py:116`. Pattern: `{relevancy_tag_id}-{ad_type}-{brand_code}-XX-S-{ASIN}-{match}-{suffix}`.
- Wizard state: store in Angular service, persist draft to localStorage on each step transition. Clear on "Complete Setup".
- Stage Status Enum: PENDING(0), IN_QUEUE(1), RECEIVED(2), APPROVED(3), FAILED(4). Prompt Types: BRANDING_SCOPE=1, ATTRIBUTES_RANKING=2, GROUPING_RANKING=3.
- KW Research async: frontend polls every 10s via `GET /api/amazon-ads/config/asin-config/{id}/` checking `kw_research_status`. When status=4, Phase 1 complete. Auto-trigger Phase 2.
- Campaign Config API response (GET /api/amazon-ads/config/ad-campaign-config/?asin_id=X): id, asin, relevancy_tag, match_type, target_acos, daily_budget, ad_status, campaign_name (computed), campaign_strategy, custom_negative_keywords, target_spec, brand_group_name, nested asin_config object. Paginated: {count, next, results[]}.

# Out of Scope

- Bulk ASIN setup (PROD-4121: IBO)
- Post-launch keyword bid adjustments (PROD-4124)
- Post-launch search term management (PROD-4125)

# Test Cases

1. Seller opens wizard, selects ASIN, completes all 5 steps. Campaigns created on Amazon.
2. Seller sets Target ACOS to 35%, enables Auto Pacing, sets Bid Ceiling to $3.00. All values saved correctly.
3. Step 3 auto-triggers research. Progress shows Phase 1 then Phase 2. Auto-advances to Step 4.
4. Seller navigates away during Step 3. Notification bell fires "KW Research complete". Seller clicks notification, returns to Step 4.
5. Step 4 shows campaigns in SPKW/SPAU/SPAS sections. Seller toggles Auto Budget. Budgets populate.
6. Seller closes wizard with unsaved changes. Discard confirmation appears.
7. Seller clicks "Edit" on launched ASIN. Wizard opens in edit mode with pre-populated data.
8. Step 5 shows 3 navigation cards after completion.

# Acceptance Criteria

- [ ] 5-step wizard guides seller through complete ASIN advertising setup
- [ ] Step 1 requires explicit Target ACOS with optional Auto Pacing and Bid Ceiling
- [ ] Step 3 auto-triggers keyword research with Phase 1 + Phase 2 progress
- [ ] Step 3 fires Notification Bell alert on completion
- [ ] Step 4 displays generated campaigns in 3 sections with Auto Budget, bulk select, per-campaign neg KWs
- [ ] Step 5 shows activate summary with non-technical Bid Opt text and 3 navigation cards
- [ ] Wizard supports edit mode for launched ASINs
- [ ] Campaign names follow Kepler convention and are not editable
- [ ] Discard confirmation on close with unsaved changes
- [ ] Tests passed (unit + integration)
- [ ] UI matches prototype

Prototype: https://mmaazhanif22.github.io/kepler-ads-design/ads-only.html
