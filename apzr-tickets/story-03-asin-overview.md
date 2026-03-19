# Manage Ads: Navigation Restructure

# User Story

As a seller, I want one page showing all my ASINs with their advertising status so I can manage everything from a single view instead of navigating through 7 separate tabs.

# Problem / Context

- The portal currently organizes advertising management under "Campaign Management" with 7 sub-tabs: Campaigns, ASIN Config, KW Research List, KW Automation, Campaign Config, Keyword Settings, Search Term Settings.
- Sellers must visit multiple tabs to check basic information like which ASINs have active ads and what stage of setup each ASIN is at.
- There is no single view showing all ASINs with their advertising status.
- There is no way to toggle ads on/off for an ASIN without entering the full configuration flow.

# Solution Outline

**ASIN table (default landing page):**
- Table showing all ASINs: product name, launch status badge, ads ON/OFF toggle, campaign count.
- Data source: `GET /api/amazon-ads/config/asin-config/`.
- Ads toggle: sets `AdvertisingAsinConfig.ad_status` (ENABLED=1, PAUSED=2) via PUT. This syncs to Amazon SP-API, pausing all campaigns under the ASIN. No confirmation dialog. Re-activation may take up to 1 hour.
- Launch status: computed from `kw_research_status`, `competitor_asins` presence, and campaign count.

**Actions dropdown per ASIN row:**
- Wizard Steps: Competitor Research (opens wizard Step 2), KW Research (Step 3), Campaign Config (Step 4), Activate (Step 5).
- Post-Launch Settings: Keyword Research List, KW Config, SearchTerm Config.
- All wizard links call `openWizardForAsin(asin, stepNumber)`.

**Sidebar restructure:**
- Replace 7-tab Campaign Management section with single flat "Manage Ads" item.
- No sub-navigation, no sub-tabs.
- Breadcrumb hidden on default ASIN table, shown when navigating to sub-views (e.g., "Manage Ads > Campaigns").

**Behavior flow:**
1. Seller clicks "Manage Ads" in sidebar > ASIN table loads showing all products.
2. Seller toggles Ads OFF for an ASIN > campaigns sync to PAUSED on Amazon. Toggle reflects new state.
3. Seller clicks "Actions" on an ASIN > dropdown shows wizard steps + post-launch settings.
4. Seller clicks "Campaign Config (Step 4)" > wizard opens at Step 4 with that ASIN pre-selected.

# Connected Work Items

**Blocked By:** [PROD-4120](https://keplercommerce.atlassian.net/browse/PROD-4120) (Wizard provides the steps that Actions dropdown links to)
**Relates To:** [PROD-4121](https://keplercommerce.atlassian.net/browse/PROD-4121) (IBO provides an alternative entry point)

# Implementation Notes

- Current component: `CampaignManagementComponent` at `client/src/app/features/amazon-ads/campaign-management/`. Has 7 child routes. Restructure routing to make ASIN table the default view.
- Ad status field: `AdvertisingAsinConfig.ad_status` at `apps/amazon_ads/models/config.py`. Values: ENABLED=1, PAUSED=2, MANUAL_EDIT=4. Update triggers campaign sync via `AdvertisingCampaignConfigService.bulk_update()`.
- Setup status computation: no existing endpoint. Add a computed property to the `AdvertisingAsinConfig` serializer combining `kw_research_status`, `competitor_asins` (empty or populated), and campaign count.
- Sidebar navigation: defined in `client/src/app/core/layout/pages-menu.ts`. Change Campaign Management entry to flat "Manage Ads" with no children.

# Test Cases

1. Seller navigates to Manage Ads. ASIN table loads as default with all ASINs visible.
2. Seller toggles Ads OFF. Campaigns sync to PAUSED on Amazon. Toggle state updates.
3. Seller toggles Ads ON. Campaigns resume (may take up to 1 hour for Amazon sync).
4. Seller clicks Actions > Campaign Config. Wizard opens at Step 4 for that ASIN.
5. Seller navigates to KW Config from Actions dropdown. KW Config tab loads with that ASIN's data.

# Acceptance Criteria

- [ ] ASIN table is the default landing page for Manage Ads
- [ ] Ads toggle syncs to Amazon (PAUSED/ENABLED via SP-API)
- [ ] Actions dropdown routes to correct wizard step or post-launch setting
- [ ] Sidebar shows flat "Manage Ads" item with no sub-navigation
- [ ] Setup status badge accurately reflects wizard completion state
- [ ] Tests passed (unit + integration)
- [ ] UI matches prototype

Prototype: https://mmaazhanif22.github.io/kepler-ads-design/ads-only.html
