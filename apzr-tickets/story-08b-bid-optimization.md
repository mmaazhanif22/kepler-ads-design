# Bid Optimization (Story 8B)

## User Story

As a seller, I want a bid optimization monitoring view that shows keyword-level bid changes with before/after values and optimization reasons, so that I can understand what the automated system is doing and override when needed.

## Problem / Context

- Bid optimization is an automated system, but sellers need transparency into what changes are being made and why.
- Without visibility into bid changes, sellers cannot validate whether the optimization algorithm is working correctly for their products.
- Sellers need the ability to review and override automated bid decisions.

## Existing vs. Net-New

| Area | Status | Notes |
|------|--------|-------|
| Bid change data | EXISTS | Bid optimization data exists in backend. `GET /amazon-ads/keyword-bid-status/{id}/` provides bid recommendations. |
| Bid optimization dashboard UI | NEW | No dedicated bid optimization monitoring view exists. |
| Bid override capability | EXISTS (rebuild) | Bid editing exists in KW Settings. Add override context to bid optimization view. |

## Solution Outline

**Bid Optimization Dashboard:**
- Keyword-level bid changes displayed in a table.
- Columns: Keyword, ASIN, Campaign, Previous Bid, Current Bid, Bid Delta, ACOS, Target ACOS, Optimization Reason.
- Sellers can review what the optimization system has done and override if needed.
- Filter by optimization date range, campaign, bid direction (increase/decrease).

**UI Requirements:**
- Mockup: [Prototype](https://mmaazhanif22.github.io/kepler-ads-design/ads-only.html) | Bid Optimization in sidebar
- Date range presets (7D, 14D, 30D, 60D, 90D) for filtering optimization history.

## Sub-Tasks

| # | Sub-Task | Exists / New | Backend Reference |
|---|----------|-------------|-------------------|
| 1 | **Bid optimization table** with keyword-level bid changes, before/after values, and optimization reasons | NEW (UI) / EXISTS (data) | `GET /amazon-ads/keyword-bid-status/{id}/` for bid recommendations. Bid change history from `GET /amazon-ads/bid-strategy-logs/`. |
| 2 | **Filter controls** for date range, campaign, and bid direction (increase/decrease) | NEW | Client-side filtering on bid change data. Date params passed to GET endpoints. |
| 3 | **Bid override** allowing sellers to manually adjust bids from the optimization view | EXISTS (rebuild) | `PUT /amazon-ads/keywords-config/` for bid updates. Same endpoint as Keyword Settings. |

## Backend References

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/amazon-ads/keyword-bid-status/{id}/` | GET | Bid recommendations and status per keyword |
| `/amazon-ads/bid-strategy-logs/` | GET | Bid strategy change history |
| `/amazon-ads/bid-strategy-logs/export/` | GET | Export bid strategy logs as CSV |
| `/amazon-ads/keywords-config/` | PUT | Override bid value for a keyword |
| `/amazon-ads/bidding/analytics/rules/effectiveness/` | GET | Bid rule effectiveness analytics |
| `/amazon-ads/bidding/analytics/dashboard/summary/` | GET | Bidding analytics summary |

## Connected Work Items

**Blocks:** None.
**Is Blocked By:** Story 1 (Wizard), campaigns and keywords must exist. Story 5 (KW Settings), bid data flows from keyword settings.
**Relates To:** Story 8A (Pacing Management). Story 8C (Config Change Log), bid changes appear in log. Story 5 (KW Settings), bid changes reflect in keyword settings.

## Implementation Notes

- Bid optimization data comes from the automated bidding system's decision log.
- Override capability uses the same endpoint as Keyword Settings bid editing.
- Optimization Reason should be human-readable (e.g., "ACOS above target, bid reduced 10%").

## Out of Scope

- Pacing management (covered by Story 8A)
- Config change log (covered by Story 8C)
- Automatic bid optimization algorithm (backend concern)
- Custom report builder or scheduled report delivery

## Test Cases

- Seller opens Bid Optimization. Sees recent bid changes with old/new values and reasons.
- Seller filters bid changes by "Increased". Only bid increases shown.
- Seller filters by campaign "NBH1-SPKW-PB01-US-S-B09L4KWX6Q-E-KW". Only that campaign's bid changes shown.
- Seller overrides a bid from the optimization view. New bid saved, reflected in Keyword Settings.
- Seller changes date range to 30D. Table updates to show last 30 days of bid changes.
- Seller exports bid optimization data. CSV includes all visible columns.

## Acceptance Criteria

- [ ] Bid Optimization view shows keyword-level bid changes with old/new values and reasons
- [ ] Filters available for date range, campaign, and bid direction (increase/decrease)
- [ ] Seller can override automated bid decisions from this view
- [ ] Export available for bid optimization data
- [ ] Date range presets (7D, 14D, 30D, 60D, 90D) filter optimization history
- [ ] Tests passed (unit + integration)
- [ ] UI matches approved mockup
