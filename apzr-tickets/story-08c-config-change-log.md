# Config Change Log

# User Story

As a seller, I want a human-readable change log of all advertising configuration changes so that I can audit what was changed, when, and whether it was manual or automated.

# Problem / Context

- Configuration changes (bid updates, keyword harvesting, negative keyword additions, budget changes) happen frequently through both manual actions and automated optimization. There is no audit trail visible to sellers.
- Bid strategy logs exist (`GET /amazon-ads/bid-strategy-logs/`) but only cover bid changes. Other event types (harvesting, negatives, budget, status) are logged internally but not surfaced.
- Raw database mutations are logged, but sellers need aggregated human-readable events (e.g., "Bid Increased: $0.75 to $0.82 for keyword 'lavender oil'"), not "Updated column bid_amount in table keywords".
- There is no unified view combining all change types with filtering by event type, ASIN, campaign, or date range.

# Solution Outline

**Aggregated Event Log:**
- Event types: Bid Increased, Bid Decreased, Keyword Harvested, Negative KW Added, Budget Updated, Status Changed, Target ACOS Updated.
- Each event: timestamp, event type, ASIN, campaign, old value, new value, source (Manual/Automated).
- Filterable by event type, ASIN, campaign, date range (7D/14D/30D/60D/90D).
- Paginated for large histories. Exportable as CSV.
- Aggregated: multiple bid changes in a batch become one "Bid Optimization" event.

**Behavior flow:**
1. Seller opens Config Change Log > sees aggregated events with timestamps and sources.
2. Seller filters by "Keyword Harvested" > only harvest events shown.
3. Seller filters by ASIN "B09L4KWX6Q" > only that ASIN's events shown.

# Connected Work Items

**Blocked By:** [PROD-4120](https://keplercommerce.atlassian.net/browse/PROD-4120) (campaigns must exist for change data)
**Relates To:** [PROD-4127](https://keplercommerce.atlassian.net/browse/PROD-4127) (pacing changes in log), [PROD-4411](https://keplercommerce.atlassian.net/browse/PROD-4411) (bid changes in log), [PROD-4124](https://keplercommerce.atlassian.net/browse/PROD-4124) (keyword changes in log)

# Implementation Notes

- Bid changes: `GET /amazon-ads/bid-strategy-logs/`. Export: `GET /amazon-ads/bid-strategy-logs/export/`.
- A unified change log endpoint does not exist today. Phase 1 approach: client-side aggregation from `bid-strategy-logs` endpoint combined with bulk_update response data and frontend action tracking. Phase 2 (future backend ticket): dedicated ChangeLog model and API endpoint for server-side event aggregation.
- Events must be aggregated, not raw. Multiple bid changes in one optimization run become a single event.
- Source distinction: "Manual" (seller action) vs. "Automated" (system optimization).

# Test Cases

1. Seller opens Change Log. Sees events like "Bid Increased: $0.75 to $0.82 for keyword 'lavender oil'".
2. Log does NOT show raw data like "Updated column bid_amount in table keywords".
3. Seller filters by "Keyword Harvested". Only harvest events shown.
4. Seller filters by ASIN. Only that ASIN's events shown.
5. Each event shows source: "Manual" or "Automated".
6. Seller exports change log. CSV includes all visible events.

# Acceptance Criteria

- [ ] Aggregated human-readable events (not raw database changes)
- [ ] Event types: Bid Increased/Decreased, Keyword Harvested, Negative KW Added, Budget Updated, Status Changed, Target ACOS Updated
- [ ] Each event shows timestamp, type, ASIN, campaign, old/new values, source
- [ ] Filtering by event type, ASIN, campaign, date range
- [ ] Pagination for large histories
- [ ] Export available
- [ ] Tests passed (unit + integration)
- [ ] UI matches prototype

Prototype: https://mmaazhanif22.github.io/kepler-ads-design/ads-only.html
