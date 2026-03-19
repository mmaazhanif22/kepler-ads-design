# Bid Optimization

# User Story

As a seller, I want a bid optimization monitoring view showing keyword-level bid changes with before/after values and reasons so that I can understand what the automated system is doing and override when needed.

# Problem / Context

- Bid optimization runs automatically in the backend. Bid change data exists (`GET /amazon-ads/keyword-bid-status/{id}/` for recommendations, `GET /amazon-ads/bid-strategy-logs/` for history) but is not surfaced in a dedicated view.
- Sellers cannot see what bid changes the system made, when, or why. Without transparency, they cannot validate whether the algorithm is performing correctly for their products.
- Bid editing exists in Keyword Settings, but there is no way to review automated decisions in context (previous bid, new bid, ACOS at time of change, optimization reason) and override from that context.

# Solution Outline

**Bid Optimization Table:**
- Columns: Keyword, ASIN, Campaign, Previous Bid, Current Bid, Bid Delta, ACOS, Target ACOS, Optimization Reason.
- Optimization Reason in human-readable text (e.g., "ACOS above target, bid reduced 10%").
- Filter by: date range (7D/14D/30D/60D/90D), campaign, bid direction (increase/decrease).
- Seller can override bids directly from this view via `PUT /amazon-ads/keywords-config/`.
- Export bid optimization data as CSV.

**Behavior flow:**
1. Seller opens Bid Optimization > sees recent bid changes with old/new values and reasons.
2. Seller filters by "Increased" > only bid increases shown.
3. Seller overrides a bid > new value saved, reflected in Keyword Settings.

# Connected Work Items

**Blocked By:** [PROD-4120](https://keplercommerce.atlassian.net/browse/PROD-4120) (campaigns and keywords must exist), [PROD-4124](https://keplercommerce.atlassian.net/browse/PROD-4124) (bid data flows from KW Settings)
**Relates To:** [PROD-4127](https://keplercommerce.atlassian.net/browse/PROD-4127) (Pacing), [PROD-4412](https://keplercommerce.atlassian.net/browse/PROD-4412) (bid changes in log)

# Implementation Notes

- Bid recommendations: `GET /amazon-ads/keyword-bid-status/{id}/`. Bid history: `GET /amazon-ads/bid-strategy-logs/`. Export: `GET /amazon-ads/bid-strategy-logs/export/`.
- Bid override: `PUT /amazon-ads/keywords-config/`. Same endpoint as Keyword Settings bid editing.
- Bid rule effectiveness: `GET /amazon-ads/bidding/analytics/rules/effectiveness/`. Dashboard summary: `GET /amazon-ads/bidding/analytics/dashboard/summary/`.
- Optimization Reason should be derived from the bid strategy log, translated to human-readable format.

# Test Cases

1. Seller opens Bid Optimization. Recent bid changes shown with old/new values and reasons.
2. Seller filters by "Increased". Only bid increases shown.
3. Seller filters by specific campaign. Only that campaign's changes shown.
4. Seller overrides a bid. New value saved, reflected in Keyword Settings.
5. Seller exports bid data. CSV includes all visible columns.

# Acceptance Criteria

- [ ] Bid changes shown with old/new values and human-readable reasons
- [ ] Filters for date range, campaign, bid direction (increase/decrease)
- [ ] Seller can override automated bids from this view
- [ ] Export available for bid optimization data
- [ ] Date range presets (7D-90D)
- [ ] Tests passed (unit + integration)
- [ ] UI matches prototype

Prototype: https://mmaazhanif22.github.io/kepler-ads-design/ads-only.html
