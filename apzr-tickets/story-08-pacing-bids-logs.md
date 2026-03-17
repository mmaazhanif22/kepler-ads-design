# Pacing Management, Bid Optimization & Logs

## User Story

As a seller, I want dedicated views for budget pacing control, bid optimization monitoring, and a comprehensive change log, so that I can ensure campaigns stay within budget, track how bids are being optimized, and audit all configuration changes.

## Problem / Context

- Sellers need visibility into whether campaigns are pacing correctly against their daily budgets — overspending wastes money, underspending misses opportunities
- Bid optimization is an automated system, but sellers need transparency into what changes are being made and why
- Configuration changes (bid updates, keyword harvesting, negative keyword additions, budget changes) happen frequently and sellers need an audit trail
- Without a change log, sellers cannot determine when a change was made, what was changed, and what the impact was

## Solution Outline

**Pacing Management:**
- Pacing dashboard showing all campaigns with their daily budget, current spend, pacing percentage, and status
- Status indicators: On Track (green), Warning (amber — approaching budget), Paused (gray), Maxed (red — budget exhausted)
- Auto Pacing controls: enable/disable automatic campaign pause and resume based on daily targets
- "Disable Pacing" button with descriptive tooltip
- "Generate Simulation Report" button (enabled after 14+ days of pacing data) with tooltip explaining the requirement

**Bid Optimization:**
- Bid optimization dashboard showing keyword-level bid changes
- Columns: Keyword, ASIN, Campaign, Previous Bid, Current Bid, Bid Delta, ACOS, Target ACOS, Optimization Reason
- Sellers can review what the optimization system has done and override if needed
- Filter by optimization date range, campaign, bid direction (increase/decrease)

**Config Change Log:**
- Aggregated human-readable event log (not raw database mutations)
- Event types: Bid Increased, Bid Decreased, Keyword Harvested, Negative KW Added, Budget Updated, Status Changed, Target ACOS Updated
- Each event shows: timestamp, event type, ASIN, campaign, old value, new value, source (manual/automated)
- Filterable by event type, ASIN, campaign, date range
- Pagination for large change histories

**Analytics Views:**
- ASIN-level performance analytics: deep dive into individual ASIN performance
- Targeting dashboard: performance by targeting type (keyword vs. auto vs. product targeting)
- Search term dashboard: aggregated search term performance metrics
- Date range presets (7D, 14D, 30D, 60D, 90D) with custom range picker

**UI Requirements:**
- Mockup: [Prototype](http://localhost:8765/Advertising%20Portal%20UI%20Design.html) — Pacing Management and Bid Optimization in sidebar
- Change Log uses aggregated event format, not raw data
- Pacing status uses color-coded indicators matching the dashboard pacing card
- Analytics views share the same date picker and filter patterns

## Connected Work Items

**Blocks:** None
**Is Blocked By:** Story 1 (Wizard) — campaigns must exist for pacing/bids/logs to have data
**Relates To:** Story 4 (Dashboards) — dashboard pacing card is a summary of this full pacing view; Story 5 (KW Settings) — bid changes reflect in keyword settings

✅ Pacing, Bids, and Logs depend on having active campaigns with performance data.

## Implementation Notes

- Pacing data requires near-real-time campaign spend data from Amazon Advertising API
- Config Change Log must aggregate related mutations into single events (e.g., multiple bid changes in a batch → one "Bid Optimization" event)
- Change Log should NOT show raw database column changes — always human-readable event descriptions
- Simulation Report requires 14+ days of historical pacing data for meaningful projections
- Analytics views use the same charting library and theme system as dashboards

## Out of Scope

- Automatic bid optimization logic (backend algorithm)
- Real-time Amazon Advertising API integration (backend concern)
- Budget allocation across portfolios or accounts
- Custom report builder or scheduled report delivery

## Test Cases

- Seller opens Pacing Management — sees all campaigns with spend progress bars and status labels
- Campaign at 85% of daily budget shows "Warning" status — campaign at 100% shows "Maxed"
- Seller clicks "Disable Pacing" — auto-pacing turns off for all campaigns with confirmation
- Seller opens Bid Optimization — sees recent bid changes with old/new values and reasons
- Seller filters bid changes by "Increased" — only bid increases shown
- Seller opens Config Change Log — sees aggregated events like "Bid Increased: $0.75 → $0.82 for keyword 'lavender oil'"
- Change Log does NOT show raw data like "Updated column bid_amount in table keywords"
- Seller opens Analytics — ASIN deep dive shows per-ASIN performance breakdown
- Seller changes date range to 60D — all analytics data refreshes

## Acceptance Criteria

- [ ] Pacing Management shows all campaigns with budget, spend, pacing percentage, and status indicators
- [ ] Auto Pacing controls allow enabling/disabling automatic pause/resume
- [ ] Bid Optimization view shows keyword-level bid changes with old/new values and reasons
- [ ] Config Change Log displays aggregated human-readable events (not raw database changes)
- [ ] Change Log supports filtering by event type, ASIN, campaign, and date range
- [ ] Analytics views provide ASIN-level, targeting, and search term performance breakdowns
- [ ] All views support date range presets (7D, 14D, 30D, 60D, 90D)
- [ ] "Generate Simulation Report" is disabled with tooltip when less than 14 days of data exists
- [ ] Tests passed (unit + integration)
- [ ] UI matches approved mockup
