# Pacing Management

# User Story

As a seller, I want a dedicated pacing management view showing campaign budgets, current spend, and pacing status so that I can ensure campaigns stay within budget and act on overspending or underspending.

# Problem / Context

- Campaign spend data exists via Amazon Advertising API and is shown in basic form on the campaign list, but there is no dedicated pacing view showing budget vs. spend with status indicators.
- Auto Pacing controls (automatic pause/resume based on daily targets) exist as a toggle on `AdvertisingAsinConfig` but have no management interface. Sellers cannot see which campaigns are being auto-paced or disable it.
- The simulation report endpoint (`POST /amazon-ads/generate-simulation-report/`) exists but has no UI. It requires 14+ days of historical data to produce meaningful projections.

# Solution Outline

**Pacing Dashboard:**
- All campaigns with: campaign name, daily budget, current spend, pacing percentage (`Current Spend / Daily Budget x 100`), status indicator.
- Status thresholds: On Track (<80%, green), Warning (80-99%, amber), Maxed (100%+, red), Paused (gray).
- Auto Pacing controls: enable/disable toggle per ASIN via `PUT /amazon-ads/asin-config/`. Campaign pause/resume via `AdvertisingCampaignConfigService.bulk_update()`.
- "Disable Pacing" button with descriptive tooltip.
- "Generate Simulation Report" button: enabled after 14+ days of pacing data. Disabled with tooltip when insufficient data. Calls `POST /amazon-ads/generate-simulation-report/`.
- Date range presets (7D, 14D, 30D, 60D, 90D) for historical pacing review.

**Behavior flow:**
1. Seller opens Pacing Management > sees all campaigns with spend progress bars and status.
2. Campaign at 85% shows "Warning". Campaign at 100%+ shows "Maxed".
3. Seller clicks "Disable Pacing" > auto-pacing turns off with confirmation.
4. Seller clicks "Generate Simulation Report" with 14+ days data > report generates.

# Connected Work Items

**Blocked By:** [PROD-4120](https://keplercommerce.atlassian.net/browse/PROD-4120) (campaigns must exist)
**Relates To:** [PROD-4123](https://keplercommerce.atlassian.net/browse/PROD-4123) (dashboard pacing card is a summary of this view), [PROD-4411](https://keplercommerce.atlassian.net/browse/PROD-4411) (Bid Optimization), [PROD-4412](https://keplercommerce.atlassian.net/browse/PROD-4412) (pacing changes in log)

# Implementation Notes

- Campaign data: `GET /amazon-ads/ad-campaign/` and `GET /amazon-ads/ad-campaign-config/` for budget data. Spend from Amazon Advertising API (near-real-time).
- Auto Pacing toggle: `PUT /amazon-ads/asin-config/` to set Auto Pacing per ASIN. Campaign pause/resume: `AdvertisingCampaignConfigService.bulk_update()`.
- Simulation report: `POST /amazon-ads/generate-simulation-report/`. Requires 14+ days of historical pacing data.
- Dashboard summary: `GET /amazon-ads/bidding/analytics/dashboard/summary/` for overview data.

# Test Cases

1. Pacing Management shows all campaigns with spend progress bars and status labels.
2. Campaign at 85% shows "Warning". Campaign at 100% shows "Maxed".
3. Seller disables pacing. Auto-pacing turns off with confirmation.
4. Seller generates simulation report with 14+ days data. Report generates.
5. Seller clicks "Generate Simulation Report" with <14 days. Button disabled with tooltip.

# Acceptance Criteria

- [ ] All campaigns shown with budget, spend, pacing percentage, status indicators
- [ ] Status color-coded: On Track (green), Warning (amber), Paused (gray), Maxed (red)
- [ ] Auto Pacing controls for enable/disable
- [ ] "Generate Simulation Report" disabled with tooltip when <14 days data
- [ ] Date range presets for historical review
- [ ] Tests passed (unit + integration)
- [ ] UI matches prototype

Prototype: https://mmaazhanif22.github.io/kepler-ads-design/ads-only.html
