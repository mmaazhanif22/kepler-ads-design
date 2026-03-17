# Ads Management — ASIN Overview & Navigation Restructure

## User Story

As a seller, I want a unified ASIN Overview as my default landing page in the advertising section, so that I can see every product's advertising status at a glance and quickly access any configuration action without navigating through multiple tabs.

## Problem / Context

- The current advertising section uses a 7-tab layout (Campaigns, ASIN Config, KW Research, KW Automation, Campaign Config, Keyword Settings, Search Term Settings) which fragments the user experience
- Sellers cannot see a holistic view of all their ASINs and their advertising state in one place
- Enabling or disabling ads for a specific ASIN requires opening the setup wizard, which is unnecessarily heavy for a simple on/off action
- There is no single place to check which ASINs have completed setup, which are partially configured, and which haven't started

## Solution Outline

Replace the current "Campaign Management" section with a restructured "Ads Management" section. The default landing page becomes **ASIN Overview** — a unified table of all ASINs.

**Sidebar Navigation Restructure:**
- Rename "Campaign Management" to "Ads Management"
- Reduce 7 sub-items to 4:
  - **ASIN Overview** (new, default landing page)
  - **Campaign Config** (retained)
  - **Keyword Settings** (retained)
  - **Search Term Settings** (retained)
- Other views (Campaigns, ASIN Config, KW Research, KW Automation) are accessible from the ASIN Overview actions menu

**ASIN Overview Table:**
- One row per ASIN showing:
  - ASIN identifier
  - Product name
  - Setup Status badge (Complete, In Progress with step count, Not Started)
  - Ads On/Off toggle — enables or disables advertising for any launched ASIN directly without opening the wizard
  - Campaign count
  - Budget
  - Target ACOS
- Table supports sorting, filtering, pagination, and column visibility controls

**Setup Status Checklist:**
- Clicking the setup status badge opens a checklist panel
- Shows all 6 wizard steps with completion state (complete/incomplete)
- Progress bar showing percentage complete
- Incomplete steps have a "Resume" button that opens the wizard directly at that step

**Actions Dropdown:**
- Per-ASIN dropdown menu with quick navigation to:
  - Competitors (wizard Step 2)
  - KW Research (wizard Step 3/4)
  - Campaign Config
  - Launch Settings (wizard Step 6)
  - Keyword Settings (filtered to this ASIN)
  - Search Term Settings (filtered to this ASIN)

**UI Requirements:**
- Mockup: [Prototype — ASIN Overview](http://localhost:8765/Advertising%20Portal%20UI%20Design.html) (navigate to Ads Management > ASIN Overview)
- Ads toggle works instantly without page reload
- Setup status badges are color-coded: green (Complete), amber (In Progress), gray (Not Started)
- Actions dropdown is positioned near the ASIN row, not a separate page

## Connected Work Items

**Blocks:** None directly
**Is Blocked By:** Story 1 (Wizard) — the setup status and resume buttons depend on the wizard being available
**Relates To:** Story 1 (Wizard) — provides alternative entry points to wizard steps; Story 2 (IBO) — sidebar houses both single and bulk launch

✅ The ASIN Overview is the new default landing page for the advertising section. It depends on the wizard for setup status and resume functionality.

## Implementation Notes

- The Ads On/Off toggle should send an immediate API call to enable/disable advertising for that ASIN
- Setup status must reflect real-time wizard completion data per ASIN
- The original Campaign Management sub-sections (Campaigns, ASIN Config, KW Research, KW Automation) remain accessible but are not primary sidebar items
- The checklist panel can be a slide-out panel or an inline expansion
- All table features (sort, filter, export, pagination) should follow the same patterns as other advertising tables

## Out of Scope

- Campaign-level management (covered by Story 7: Campaign Management)
- Keyword-level management (covered by Story 5 and 6)
- Performance dashboards and KPI views (covered by Story 4)
- New ASIN onboarding or product catalog management

## Test Cases

- Seller lands on Ads Management — ASIN Overview loads as default page
- Seller sees all their ASINs in a single table with status, toggle, campaign count, budget, and ACOS
- Seller clicks setup status "In Progress (3/6)" — checklist panel shows 3 completed and 3 incomplete steps with Resume buttons
- Seller clicks Resume on Step 4 — wizard opens directly at Step 4 with previous data loaded
- Seller toggles Ads Off for a launched ASIN — advertising is disabled without opening the wizard
- Seller opens Actions dropdown for an ASIN — sees links to Competitors, KW Research, Campaign Config, etc.
- Seller clicks "Keyword Settings" in Actions — navigates to Keyword Settings filtered to that ASIN
- Sidebar shows "Ads Management" with 4 sub-items, not 7

## Acceptance Criteria

- [ ] ASIN Overview is the default landing page for the Ads Management section
- [ ] Every ASIN shows in a unified table with setup status, ads toggle, campaign count, budget, and Target ACOS
- [ ] Setup status badge is clickable and opens a checklist panel with all 6 wizard steps
- [ ] Incomplete steps have Resume buttons that open the wizard at that specific step
- [ ] Ads On/Off toggle enables or disables advertising for a launched ASIN immediately
- [ ] Actions dropdown provides quick navigation to wizard steps and config views filtered to that ASIN
- [ ] Sidebar is restructured from 7 items to 4 under "Ads Management"
- [ ] Table supports sorting, filtering, pagination, and column visibility
- [ ] Tests passed (unit + integration)
- [ ] UI matches approved mockup
