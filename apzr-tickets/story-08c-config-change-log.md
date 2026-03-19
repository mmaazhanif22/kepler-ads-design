# Config Change Log (Story 8C)

## User Story

As a seller, I want a comprehensive, human-readable change log of all advertising configuration changes, so that I can audit what was changed, when, and whether it was manual or automated.

## Problem / Context

- Configuration changes (bid updates, keyword harvesting, negative keyword additions, budget changes) happen frequently and sellers need an audit trail.
- Without a change log, sellers cannot determine when a change was made, what was changed, and what the impact was.
- The log must show aggregated, human-readable events, not raw database mutations.

## Existing vs. Net-New

| Area | Status | Notes |
|------|--------|-------|
| Bid strategy logs | EXISTS | `GET /amazon-ads/bid-strategy-logs/` provides bid change history. |
| Aggregated event log UI | NEW | No human-readable aggregated event log exists. Raw data changes are logged internally but not surfaced. |
| Event type filtering | NEW | No filtering by event type, ASIN, campaign, or date range on a unified log. |

## Solution Outline

**Config Change Log:**
- Aggregated human-readable event log (not raw database mutations).
- Event types: Bid Increased, Bid Decreased, Keyword Harvested, Negative KW Added, Budget Updated, Status Changed, Target ACOS Updated.
- Each event shows: timestamp, event type, ASIN, campaign, old value, new value, source (manual/automated).
- Filterable by event type, ASIN, campaign, date range.
- Pagination for large change histories.

**Analytics Views (within Change Log section):**
- ASIN-level performance analytics: deep dive into individual ASIN performance.
- Targeting dashboard: performance by targeting type (keyword vs. auto vs. product targeting).
- Search term dashboard: aggregated search term performance metrics.
- Date range presets (7D, 14D, 30D, 60D, 90D) with custom range picker.

**UI Requirements:**
- Mockup: [Prototype](https://mmaazhanif22.github.io/kepler-ads-design/ads-only.html) | Change Log in sidebar
- Change Log uses aggregated event format, not raw data.
- Analytics views share the same date picker and filter patterns.

## Sub-Tasks

| # | Sub-Task | Exists / New | Backend Reference |
|---|----------|-------------|-------------------|
| 1 | **Aggregated event log table** with timestamp, event type, ASIN, campaign, old/new values, source | NEW (UI) / PARTIAL (data) | Bid changes from `GET /amazon-ads/bid-strategy-logs/`. Other events aggregated from various update endpoints. |
| 2 | **Event type filters** for Bid Increased/Decreased, Keyword Harvested, Negative KW Added, Budget Updated, Status Changed, Target ACOS Updated | NEW | Client-side filtering on aggregated event data. |
| 3 | **ASIN/Campaign/Date range filters** for narrowing the log | NEW | Date params passed to GET endpoints. ASIN/campaign filtering client-side. |
| 4 | **Analytics sub-views** for ASIN-level, targeting, and search term performance | NEW | `GET /amazon-ads/bidding/analytics/dashboard/summary/` for overview. `GET /amazon-ads/bidding/analytics/campaigns/top/` for campaign analytics. `GET /amazon-ads/top-down-performance-analysis/` for top-down view. |

## Backend References

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/amazon-ads/bid-strategy-logs/` | GET | Bid strategy change history |
| `/amazon-ads/bid-strategy-logs/export/` | GET | Export bid strategy logs as CSV |
| `/amazon-ads/bidding/analytics/dashboard/summary/` | GET | Dashboard analytics summary |
| `/amazon-ads/bidding/analytics/rules/effectiveness/` | GET | Bid rule effectiveness data |
| `/amazon-ads/bidding/analytics/campaigns/top/` | GET | Top campaigns performance analytics |
| `/amazon-ads/top-down-performance-analysis/` | GET | Top-down performance analysis |
| `/analytics/metrics/*` | GET | KPI metrics endpoints |

**Note:** A unified change log endpoint that aggregates bid changes, keyword harvests, negative keyword additions, budget updates, and status changes into a single feed does not exist today. This may require a new backend endpoint or client-side aggregation from multiple sources.

## Connected Work Items

**Blocks:** None.
**Is Blocked By:** Story 1 (Wizard), campaigns must exist for change log data.
**Relates To:** Story 8A (Pacing Management), pacing changes appear in log. Story 8B (Bid Optimization), bid changes appear in log. Story 5 (KW Settings), keyword changes appear in log.

## Implementation Notes

- Config Change Log must aggregate related mutations into single events (e.g., multiple bid changes in a batch become one "Bid Optimization" event).
- Change Log should NOT show raw database column changes. Always human-readable event descriptions.
- Analytics views use the same charting library and theme system as dashboards (Story 4).
- Event source should distinguish between "Manual" (seller action) and "Automated" (system optimization).

## Out of Scope

- Pacing management (covered by Story 8A)
- Bid optimization monitoring (covered by Story 8B)
- Automatic bid optimization logic (backend algorithm)
- Real-time Amazon Advertising API integration (backend concern)
- Budget allocation across portfolios or accounts
- Custom report builder or scheduled report delivery

## Test Cases

- Seller opens Config Change Log. Sees aggregated events like "Bid Increased: $0.75 to $0.82 for keyword 'lavender oil'".
- Change Log does NOT show raw data like "Updated column bid_amount in table keywords".
- Seller filters by event type "Keyword Harvested". Only harvest events shown.
- Seller filters by ASIN "B09L4KWX6Q". Only events for that ASIN shown.
- Seller changes date range to 60D. Log updates to show last 60 days of events.
- Each event shows source: "Manual" or "Automated".
- Seller opens ASIN-level analytics. Sees per-ASIN performance breakdown.
- Seller opens Targeting dashboard. Sees performance by targeting type.
- Seller exports change log. CSV includes all visible events.

## Acceptance Criteria

- [ ] Config Change Log displays aggregated human-readable events (not raw database changes)
- [ ] Event types include: Bid Increased/Decreased, Keyword Harvested, Negative KW Added, Budget Updated, Status Changed, Target ACOS Updated
- [ ] Each event shows timestamp, event type, ASIN, campaign, old/new values, and source (manual/automated)
- [ ] Change Log supports filtering by event type, ASIN, campaign, and date range
- [ ] Pagination handles large change histories
- [ ] Analytics views provide ASIN-level, targeting, and search term performance breakdowns
- [ ] All views support date range presets (7D, 14D, 30D, 60D, 90D)
- [ ] Export available for change log data
- [ ] Tests passed (unit + integration)
- [ ] UI matches approved mockup
