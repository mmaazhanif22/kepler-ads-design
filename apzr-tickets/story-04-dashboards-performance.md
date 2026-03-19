# Advertising Dashboards & Performance Intelligence

## User Story

As a seller, I want intelligent dashboards with KPI cards, trend visualizations, AI recommendations, and budget pacing indicators, so that I can monitor advertising performance and take action on optimization opportunities without manually analyzing data.

## Problem / Context

- Sellers need to monitor advertising performance across multiple dimensions (spend, sales, ACOS, clicks, impressions) but lack a consolidated view.
- Trend data is available in tables but not visualized. Sellers cannot quickly spot upward or downward performance trends.
- Sellers miss optimization opportunities because the portal does not proactively surface them.
- Budget pacing information (whether campaigns are on track, overspending, or underspending) is not visible.
- There is no notification system to alert sellers to important changes or required actions.

## Solution Outline

**Dashboard KPI Cards (5x2 Grid):**
- 10 KPI cards in a cohesive grid layout showing key metrics: Spend, Sales, ACOS, Impressions, Clicks, CTR, Orders, CVR, ROAS, and a selectable metric.
- Each card shows: current value, trend direction (up/down arrow), percentage change.
- Inline sparkline chart on each card showing 7-day trend data.
- Date range presets: 7D, 14D, 30D, 60D, 90D with a custom range picker.

**AI Recommendation Cards (3 Cards):**
- Bid Opportunity: surfaces keywords with high conversion but low bids.
- Negative Keyword Suggestion: surfaces search terms wasting spend with no conversions.
- Budget Reallocation: suggests moving budget from underperforming to high-performing campaigns.
- Each card has "Apply" and "Dismiss" action buttons.
- Recommendations refresh based on selected date range.

**Budget Pacing Card:**
- Shows 3 representative campaigns with pacing status.
- Each campaign shows: name, daily budget, spend progress bar, pacing label (On Track, Warning, Maxed).
- Warning indicators for campaigns approaching or exceeding daily budget.

**Listing Quality Score Panel:**
- Displayed in the wizard (Step 4) and optionally on dashboards.
- Circular gauge showing overall listing quality score (0-100).
- Per-dimension progress bars: Title, Bullets, Images, Description, Backend Keywords.
- Score informs sellers about listing optimization impact on ad performance.

**Notification Bell:**
- Bell icon in the top navigation bar with unread count badge.
- Dropdown shows recent notifications: budget alerts, new keyword suggestions, campaign status changes.
- Accessible via keyboard.

**Skeleton Loading:**
- While dashboard data loads, show animated skeleton placeholders (shimmer effect).
- Respects user's reduced-motion accessibility preferences.

**UI Requirements:**
- Mockup: [Prototype: ADS Performance](https://mmaazhanif22.github.io/kepler-ads-design/ads-only.html) (navigate to ADS Performance)
- KPI cards grid is responsive: 5 columns on desktop, 2-3 on tablet, 1 on mobile.
- Sparklines use theme-aware colors (adapt to dark/light mode).
- AI cards are dismissible and refreshable.
- Loading states use skeleton animation, not spinners.

## Connected Work Items

**Blocks:** None.
**Is Blocked By:** None. Dashboards can be built with data from existing advertising data sources.
**Relates To:** PROD-4124 (KW Settings), PROD-4125 (ST Settings). Dashboards may link to detailed keyword/search term views. PROD-4127 (Pacing). Pacing card is a summary of the full Pacing Management view.

Dashboards can be developed independently and integrated once data sources are available.

## Implementation Notes

- Sparkline data is derived from the same time-series advertising data used in tables.
- AI Recommendations require a backend service that analyzes campaign performance data.
- Budget pacing requires real-time or near-real-time spend data from Amazon Advertising API.
- Notification system needs a backend event queue and user-specific notification state.
- Skeleton loading should match the exact layout of the loaded content.
- All chart colors should use theme-aware color tokens that adapt to dark/light mode.

## Out of Scope

- Detailed campaign-level analytics (covered by PROD-4412: Config Change Log)
- Keyword-level bid optimization (covered by PROD-4124: Keyword Settings)
- Full pacing management controls (covered by PROD-4127: Pacing Management)
- Custom dashboard builder or widget configuration
- Email or SMS notification delivery

## Test Cases

- Seller views dashboard. 10 KPI cards display with current values, trend arrows, and sparklines.
- Seller changes date range to 30D. All KPI values, sparklines, and AI recommendations refresh.
- AI Recommendation shows "Bid Opportunity". Seller clicks Apply. Bid changes are applied.
- AI Recommendation shows "Negative KW". Seller clicks Dismiss. Card is removed.
- Budget Pacing shows one campaign at "Warning" status. Seller sees the progress bar and label.
- Notification bell shows "3" unread. Seller clicks to see notification list.
- Dashboard loads with skeleton placeholders. Content replaces skeletons when data arrives.
- Seller with reduced-motion preference. Skeleton animation is disabled.

## Acceptance Criteria

- [ ] 10 KPI cards display in a 5x2 grid with current values, trend indicators, and sparkline charts
- [ ] Date range presets (7D, 14D, 30D, 60D, 90D) update all dashboard data
- [ ] 3 AI Recommendation cards surface actionable insights with Apply and Dismiss buttons
- [ ] Budget Pacing card shows campaign spend progress with On Track / Warning / Maxed indicators
- [ ] Notification bell in top bar shows unread count and notification dropdown
- [ ] Skeleton loading placeholders display while data loads, with reduced-motion support
- [ ] Sparklines and charts adapt to dark/light theme
- [ ] Tests passed (unit + integration)
- [ ] UI matches approved mockup
