# Manage Ads: ASIN Overview & Navigation Restructure

## User Story

As a seller, I want a unified ASIN Overview as my default landing page in the advertising section, so that I can see every product's advertising status at a glance and quickly access any configuration action without navigating through multiple tabs.

## Problem / Context

- The current advertising section uses a 7-tab layout (Campaigns, ASIN Config, KW Research, KW Automation, Campaign Config, Keyword Settings, Search Term Settings) which fragments the user experience.
- Sellers cannot see a holistic view of all their ASINs and their advertising state in one place.
- Enabling or disabling ads for a specific ASIN requires opening the setup wizard, which is unnecessarily heavy for a simple on/off action.
- There is no single place to check which ASINs have completed setup, which are partially configured, and which have not started.
- There is no "Campaign Management" dropdown in the redesigned sidebar. All post-launch actions route through the wizard or Manage Ads.

## Existing vs. Net-New

| Area | Status | Notes |
|------|--------|-------|
| ASIN table listing | EXISTS (rebuild) | Current ASIN Config page lists ASINs. Rebuild as unified overview with status, toggle, and actions. |
| Ads On/Off toggle | NEW | No per-ASIN advertising toggle exists today. |
| Setup Status checklist | NEW | No wizard step completion tracking UI exists. |
| Actions dropdown (per-ASIN) | NEW | No per-ASIN quick-navigation menu exists. |
| Post-Launch Settings panel | NEW | Settings management for launched ASINs outside the wizard. |

## Solution Outline

Replace the current fragmented navigation with a restructured "Manage Ads" section. The default landing page becomes **ASIN Overview**, a unified table of all ASINs.

**Sidebar Navigation Restructure:**
- Section name: "Manage Ads" (not "Campaign Management" or "Ads Management").
- Reduce 7 sub-items to 4:
  - **ASIN Overview** (new, default landing page)
  - **Campaign Config** (retained)
  - **Keyword Settings** (retained)
  - **Search Term Settings** (retained)
- No "Campaign Management" dropdown in the redesigned sidebar.
- Other views (Campaigns, ASIN Config, KW Research) are accessible from the ASIN Overview actions menu or wizard-only routing.

**ASIN Overview Table:**
- One row per ASIN showing:
  - ASIN identifier
  - Product name
  - Setup Status badge (Complete, In Progress with step count, Not Started)
  - Ads On/Off toggle: enables or disables advertising for any launched ASIN directly without opening the wizard
  - Campaign count
  - Budget
  - Target ACOS
- Table supports sorting, filtering, pagination, and column visibility controls.

**Setup Status Checklist:**
- Clicking the setup status badge opens a checklist panel.
- Shows all 5 wizard steps with completion state (complete/incomplete).
- Progress bar showing percentage complete.
- Incomplete steps have a "Resume" button that opens the wizard directly at that step.

**Post-Launch Settings:**
- Launched ASINs can access post-launch configuration without re-entering the full wizard.
- Settings accessible from the ASIN Overview actions menu.

**Actions Dropdown:**
- Per-ASIN dropdown menu with quick navigation to:
  - Competitors (wizard Step 2)
  - Automated Keyword Research (wizard Step 3)
  - Campaign Config (wizard Step 4)
  - Activate Settings (wizard Step 5)
  - Keyword Settings (filtered to this ASIN)
  - Search Term Settings (filtered to this ASIN)

**UI Requirements:**
- Mockup: [Prototype: Manage Ads](https://mmaazhanif22.github.io/kepler-ads-design/ads-only.html) (navigate to Manage Ads > ASIN Overview)
- Ads toggle works instantly without page reload.
- Setup status badges are color-coded: green (Complete), amber (In Progress), gray (Not Started).
- Actions dropdown is positioned near the ASIN row, not a separate page.

## Sub-Tasks

| # | Sub-Task | Exists / New | Backend Reference |
|---|----------|-------------|-------------------|
| 1 | **ASIN Overview table** with status badges, ads toggle, campaign count, budget, Target ACOS | EXISTS (rebuild) | `GET /amazon-ads/asin-config/` for ASIN list. Campaign count from `GET /amazon-ads/ad-campaign/`. |
| 2 | **Ads On/Off toggle** with immediate API call per ASIN | NEW | `PUT /amazon-ads/asin-config/` to update ads enabled state. Campaign status toggle via `AdvertisingCampaignConfigService.bulk_update()`. |
| 3 | **Setup Status checklist panel** showing 5 wizard steps with completion state and Resume buttons | NEW | Stage status from `KeywordResearchAutomationBatch` model (PENDING/IN_QUEUE/RECEIVED/APPROVED/FAILED). Wizard step completion tracked per ASIN. |
| 4 | **Actions dropdown** with per-ASIN quick navigation to wizard steps and filtered config views | NEW | No backend dependency. Client-side routing to wizard steps and filtered table views. |

## Backend References

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/amazon-ads/asin-config/` | GET | Retrieve all ASINs with config state |
| `/amazon-ads/asin-config/` | PUT | Update ASIN config (ads enabled, Target ACOS, etc.) |
| `/amazon-ads/ad-campaign/` | GET | Campaign list for campaign count per ASIN |
| `/amazon-ads/ad-campaign-config/` | GET | Campaign config data for budget/ACOS display |
| `KeywordResearchAutomationBatch` | Model | Stage status per ASIN for wizard step tracking |
| `AdvertisingCampaignConfigService.bulk_update()` | Service | Bulk campaign enable/disable when ads toggle is switched |

## Connected Work Items

**Blocks:** None directly.
**Is Blocked By:** PROD-4120 (Wizard). The setup status and resume buttons depend on the wizard being available.
**Relates To:** PROD-4120 (Wizard), which provides alternative entry points to wizard steps. PROD-4121 (IBO), which the sidebar houses alongside single launch.

The ASIN Overview is the new default landing page for the advertising section. It depends on the wizard for setup status and resume functionality.

## Implementation Notes

- The Ads On/Off toggle should send an immediate API call to enable/disable advertising for that ASIN.
- Setup status must reflect real-time wizard completion data per ASIN.
- The original views (Campaigns, ASIN Config, KW Research) remain accessible but are not primary sidebar items.
- The checklist panel can be a slide-out panel or an inline expansion.
- All table features (sort, filter, export, pagination) should follow the same patterns as other advertising tables.

## Out of Scope

- Campaign-level management (covered by PROD-4126: Campaign List & Config)
- Keyword-level management (covered by PROD-4124 and PROD-4125)
- Performance dashboards and KPI views (covered by PROD-4123)
- New ASIN onboarding or product catalog management

## Test Cases

- Seller lands on Manage Ads. ASIN Overview loads as default page.
- Seller sees all their ASINs in a single table with status, toggle, campaign count, budget, and ACOS.
- Seller clicks setup status "In Progress (3/5)". Checklist panel shows 3 completed and 2 incomplete steps with Resume buttons.
- Seller clicks Resume on Step 3. Wizard opens directly at Step 3 with previous data loaded.
- Seller toggles Ads Off for a launched ASIN. Advertising is disabled without opening the wizard.
- Seller opens Actions dropdown for an ASIN. Sees links to Competitors, Automated Keyword Research, Campaign Config, etc.
- Seller clicks "Keyword Settings" in Actions. Navigates to Keyword Settings filtered to that ASIN.
- Sidebar shows "Manage Ads" with 4 sub-items, not 7.

## Acceptance Criteria

- [ ] ASIN Overview is the default landing page for the Manage Ads section
- [ ] Every ASIN shows in a unified table with setup status, ads toggle, campaign count, budget, and Target ACOS
- [ ] Setup status badge is clickable and opens a checklist panel with all 5 wizard steps
- [ ] Incomplete steps have Resume buttons that open the wizard at that specific step
- [ ] Ads On/Off toggle enables or disables advertising for a launched ASIN immediately
- [ ] Actions dropdown provides quick navigation to wizard steps and config views filtered to that ASIN
- [ ] Sidebar is restructured from 7 items to 4 under "Manage Ads"
- [ ] No "Campaign Management" dropdown in the redesigned sidebar
- [ ] Table supports sorting, filtering, pagination, and column visibility
- [ ] Tests passed (unit + integration)
- [ ] UI matches approved mockup
