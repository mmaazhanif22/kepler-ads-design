# Pacing Management (Story 8A)

## User Story

As a seller, I want a dedicated pacing management view showing all campaigns with their daily budget, current spend, pacing percentage, and status, so that I can ensure campaigns stay within budget and take action on overspending or underspending campaigns.

## Problem / Context

- Sellers need visibility into whether campaigns are pacing correctly against their daily budgets. Overspending wastes money, underspending misses opportunities.
- Auto Pacing controls (automatic pause/resume based on daily targets) need a dedicated management interface.
- Simulation reports help sellers project future pacing behavior but require sufficient historical data.

## Existing vs. Net-New

| Area | Status | Notes |
|------|--------|-------|
| Campaign spend data | EXISTS | Amazon Advertising API provides campaign spend data. Currently displayed in basic form. |
| Pacing dashboard UI | NEW | No dedicated pacing dashboard exists. Basic spend data shown in campaign list only. |
| Auto Pacing controls | NEW | No auto pause/resume UI exists. |
| Simulation Report | NEW | `POST /amazon-ads/generate-simulation-report/` endpoint exists but no UI. |

## Solution Outline

**Pacing Dashboard:**
- All campaigns displayed with: campaign name, daily budget, current spend, pacing percentage, and status.
- Status indicators: On Track (green), Warning (amber, approaching budget), Paused (gray), Maxed (red, budget exhausted).
- Auto Pacing controls: enable/disable automatic campaign pause and resume based on daily targets.
- "Disable Pacing" button with descriptive tooltip.
- "Generate Simulation Report" button (enabled after 14+ days of pacing data) with tooltip explaining the requirement.

**UI Requirements:**
- Mockup: [Prototype](https://mmaazhanif22.github.io/kepler-ads-design/ads-only.html) | Pacing Management in sidebar
- Pacing status uses color-coded indicators matching the dashboard pacing card (Story 4).
- Date range presets (7D, 14D, 30D, 60D, 90D) for historical pacing review.

## Sub-Tasks

| # | Sub-Task | Exists / New | Backend Reference |
|---|----------|-------------|-------------------|
| 1 | **Pacing dashboard table** with campaign name, daily budget, current spend, pacing %, status indicators | NEW (UI) / EXISTS (data) | Campaign data from `GET /amazon-ads/ad-campaign/`. Spend data from Amazon Advertising API. Pacing % calculated client-side. |
| 2 | **Auto Pacing controls** with enable/disable toggle and confirmation dialog | NEW | `PUT /amazon-ads/asin-config/` for Auto Pacing toggle. Campaign pause/resume via `AdvertisingCampaignConfigService.bulk_update()`. |
| 3 | **Simulation Report button** with 14-day data requirement check and tooltip | NEW (UI) / EXISTS (endpoint) | `POST /amazon-ads/generate-simulation-report/` for report generation. |

## Backend References

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/amazon-ads/ad-campaign/` | GET | Campaign list with budget data |
| `/amazon-ads/ad-campaign-config/` | GET/PUT | Campaign config for budget and status |
| `/amazon-ads/generate-simulation-report/` | POST | Generate pacing simulation report (requires 14+ days data) |
| `/amazon-ads/asin-config/` | PUT | Toggle Auto Pacing per ASIN |
| `AdvertisingCampaignConfigService.bulk_update()` | Service | Bulk campaign pause/resume |
| `/amazon-ads/bidding/analytics/dashboard/summary/` | GET | Dashboard summary with pacing data |

## Connected Work Items

**Blocks:** None.
**Is Blocked By:** Story 1 (Wizard), campaigns must exist for pacing data.
**Relates To:** Story 4 (Dashboards), dashboard pacing card is a summary of this full pacing view. Story 8B (Bid Optimization), related campaign management. Story 8C (Config Change Log), pacing changes appear in log.

## Implementation Notes

- Pacing data requires near-real-time campaign spend data from Amazon Advertising API.
- Simulation Report requires 14+ days of historical pacing data for meaningful projections.
- Pacing percentage = (Current Spend / Daily Budget) x 100.
- Status thresholds: On Track (<80%), Warning (80-99%), Maxed (100%+), Paused (campaign paused).

## Out of Scope

- Bid optimization monitoring (covered by Story 8B)
- Config change log (covered by Story 8C)
- Automatic bid optimization logic (backend algorithm)
- Budget allocation across portfolios or accounts

## Test Cases

- Seller opens Pacing Management. Sees all campaigns with spend progress bars and status labels.
- Campaign at 85% of daily budget shows "Warning" status. Campaign at 100% shows "Maxed".
- Seller clicks "Disable Pacing". Auto-pacing turns off for all campaigns with confirmation.
- Seller clicks "Generate Simulation Report" with 14+ days of data. Report generates.
- Seller clicks "Generate Simulation Report" with <14 days of data. Button disabled with tooltip.

## Acceptance Criteria

- [ ] Pacing Management shows all campaigns with budget, spend, pacing percentage, and status indicators
- [ ] Auto Pacing controls allow enabling/disabling automatic pause/resume
- [ ] Status indicators are color-coded: On Track (green), Warning (amber), Paused (gray), Maxed (red)
- [ ] "Generate Simulation Report" is disabled with tooltip when less than 14 days of data exists
- [ ] Date range presets available for historical pacing review
- [ ] Tests passed (unit + integration)
- [ ] UI matches approved mockup
