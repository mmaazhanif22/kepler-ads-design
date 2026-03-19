# Advertising Dashboards and Performance Intelligence

# User Story

As a seller, I want dashboards with KPI cards, trend visualizations, AI recommendations, and budget pacing indicators so that I can monitor advertising performance and act on optimization opportunities without manually analyzing raw data.

# Problem / Context

- The portal has 6 existing analytics components (ASIN Dashboard, Targeting Dashboard, Search Terms Dashboard, Targeting Records, Search Term Records, ASIN Deep Dive) but they display data in basic tables without trend visualization or actionable insights.
- Trend data exists in the backend but is not visualized. Sellers cannot spot upward or downward performance trends at a glance.
- There is no proactive recommendation system. Sellers miss optimization opportunities (e.g., high-converting keywords with low bids, search terms wasting spend).
- Budget pacing information (whether campaigns are on track, overspending, or underspending) is not surfaced anywhere outside raw spend numbers.
- There is no notification system to alert sellers to important changes.

# Solution Outline

**Dashboard KPI Cards (5x2 grid):**
- 10 KPI cards: Spend, Sales, ACOS, Impressions, Clicks, CTR, Orders, CVR, ROAS, and a selectable metric. Each shows current value, trend arrow, percentage change, 7-day sparkline.
- Date range presets: 7D, 14D, 30D, 60D, 90D with custom range picker.
- Data: `POST /amazon-ads/dashboard/target-chart/` for chart data.

**AI Recommendation Cards (3 cards):**
- Bid Opportunity: keywords with high conversion but low bids. Negative KW Suggestion: terms wasting spend with zero conversions. Budget Reallocation: move budget from underperforming to high-performing campaigns.
- Each card has "Apply" and "Dismiss" buttons. Data: `GET /amazon-ads/bidding/analytics/dashboard/summary/`.

**Budget Pacing Card:**
- 3 representative campaigns with pacing status: name, daily budget, spend progress bar, pacing label (On Track, Warning, Maxed).

**Skeleton Loading:**
- Animated skeleton placeholders while data loads. Respects reduced-motion preferences.

**Behavior flow:**
1. Seller opens ADS Performance > KPI cards load with sparklines and trend arrows.
2. Seller changes date range to 30D > all cards, sparklines, and AI recommendations refresh.
3. AI card shows "Bid Opportunity" > seller clicks Apply > bid changes applied.
4. Seller dismisses a recommendation > card removed from view.

# Connected Work Items

**Relates To:** [PROD-4127](https://keplercommerce.atlassian.net/browse/PROD-4127) (Pacing, full pacing view), [PROD-4124](https://keplercommerce.atlassian.net/browse/PROD-4124), [PROD-4125](https://keplercommerce.atlassian.net/browse/PROD-4125) (dashboards may link to keyword/ST detail views)

# Implementation Notes

- Current components: `AsinDashboardComponent` at `/analytics/asin`, `TargetDashboardComponent` at `/analytics/targeting`, `SearchTermDashboardComponent` at `/analytics/search-term`, `TargetListComponent` at `/analytics/targeting-records`, `SearchTermListComponent` at `/analytics/search-term-records`. All exist and need rebuild with KPI cards, sparklines, and AI recommendations layered on top.
- Sparkline data derived from same time-series advertising data used in tables.
- AI Recommendations require a backend service analyzing campaign performance. Endpoint: `GET /amazon-ads/bidding/analytics/dashboard/summary/`. May need new recommendation-specific endpoint.
- Budget pacing requires near-real-time spend data from Amazon Advertising API.
- All chart colors must use theme-aware CSS custom properties for dark/light mode.

# Test Cases

1. Seller views dashboard. 10 KPI cards display with values, trend arrows, and sparklines.
2. Seller changes date range to 30D. All data refreshes.
3. AI Recommendation "Bid Opportunity" shown. Seller clicks Apply. Bids update.
4. Budget Pacing shows one campaign at "Warning" (80-99% budget).
5. Dashboard loads with skeleton placeholders. Content replaces skeletons when data arrives.
6. Seller with reduced-motion preference. Skeleton animation disabled.

# Acceptance Criteria

- [ ] 10 KPI cards display in 5x2 grid with values, trend indicators, and sparklines
- [ ] Date range presets (7D, 14D, 30D, 60D, 90D) update all dashboard data
- [ ] 3 AI Recommendation cards surface actionable insights with Apply and Dismiss
- [ ] Budget Pacing card shows On Track / Warning / Maxed indicators
- [ ] Skeleton loading with reduced-motion support
- [ ] Charts adapt to dark/light theme
- [ ] Tests passed (unit + integration)
- [ ] UI matches prototype

Prototype: https://mmaazhanif22.github.io/kepler-ads-design/ads-only.html
