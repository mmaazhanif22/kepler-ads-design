# Competitive UX Research: Amazon Seller Advertising Tools
## Actionable Insights for Kepler Commerce Advertising Portal

**Date:** 2026-03-02
**Scope:** UI/UX patterns from Helium 10, Jungle Scout, Perpetua, Pacvue, Quartile, Sellics/Perpetua, DataHawk
**Purpose:** Extract implementable patterns to enhance the Kepler Commerce advertising portal prototype

---

## Table of Contents

1. [A. Dashboard & Analytics Patterns](#a-dashboard--analytics-patterns)
2. [B. Table/Grid UX Patterns](#b-tablegrid-ux-patterns)
3. [C. Campaign Management UX](#c-campaign-management-ux)
4. [D. Filter & Search UX](#d-filter--search-ux)
5. [E. Navigation Patterns](#e-navigation-patterns)
6. [F. Data Visualization Best Practices](#f-data-visualization-best-practices)
7. [G. Automation & AI Features](#g-automation--ai-features)
8. [H. Notification & Alert Systems](#h-notification--alert-systems)
9. [Priority Implementation Matrix](#priority-implementation-matrix)

---

## A. Dashboard & Analytics Patterns

### A1. KPI Card Design (High Priority)

**Pattern observed across: Helium 10, Jungle Scout, Pacvue, DataHawk**

Every major tool uses a horizontal row of 4-6 KPI cards at the top of the dashboard as the first thing the user sees. The universal pattern is:

| Component | Implementation Detail |
|-----------|----------------------|
| **Primary metric value** | Large font (24-32px), bold weight, left-aligned within the card |
| **Metric label** | Smaller muted text above or below the value |
| **Period-over-period delta** | Smaller number next to the primary value showing change vs. previous period |
| **Trend indicator** | Green up-arrow for positive changes, red down-arrow for negative (shape + color for accessibility) |
| **Sparkline** | Inline mini line chart (no axes, no labels) showing 7-30 day trend |
| **Date context** | Subtitle showing the comparison period (e.g., "vs. prior 7 days") |

**Helium 10 specific:** The Ads Dashboard displays smaller numbers next to larger numbers representing a comparison of the previous period of the selected lookback window (e.g., if "Latest 7 Days" is selected, the comparison is the 7 days prior).

**Jungle Scout specific:** Allows customizing the dashboard to show up to 8 metrics simultaneously, with interactive elements.

**Kepler Action Items:**
1. Implement a 4-6 card KPI row at the top of every advertising view (Dashboard, Campaigns, Keywords)
2. Each card must include: metric value, delta percentage, directional arrow, sparkline micro-chart
3. Core metrics for the KPI row: **Ad Spend, Ad Sales, ACOS, ROAS, Total Sales, TACoS**
4. Use green/red color coding WITH arrow icons (accessibility: color + shape)
5. Include period context label ("vs. prior 7 days") beneath each delta

### A2. Chart Types and Layout

**Pattern observed across: Helium 10, Pacvue, DataHawk, Perpetua**

| Tool | Primary Chart | Secondary Charts |
|------|---------------|------------------|
| **Helium 10** | Line graph by day/hour with multi-metric overlay | Top campaigns by spend, highest ACoS campaigns |
| **Pacvue** | Customizable chart canvas (line, bar, doughnut, scorecard, table) | Drag-and-drop widget layout |
| **DataHawk** | Historical trend charts (impressions, clicks, CPC, CTR, ROAS, ACoS) | Keyword grids, PowerBI/Looker integration |
| **Jungle Scout** | Interactive charts with flip views (Top Campaigns, Product Ads, Ad Groups) | Customizable metric selectors |

**Common chart patterns:**
- **Primary chart:** Always a multi-series line chart showing 2-3 metrics over time (e.g., Spend + Sales + ACOS)
- **Time axis:** Always daily granularity as default, with hourly drill-down available
- **Multi-metric overlay:** Users can toggle which metrics appear on the same chart (dual Y-axis for different scales)
- **Combination charts:** Line + bar combinations where bar = spend/volume, line = efficiency (ACOS/ROAS)

**Kepler Action Items:**
1. Primary dashboard chart: Multi-series line chart with selectable metrics and dual Y-axis
2. Support metric overlay toggles (checkboxes to show/hide each metric on the chart)
3. Below the primary chart: 2-column layout with "Top Campaigns by Spend" and "Highest ACOS Campaigns" quick-glance widgets
4. Chart format options: Line, Bar, Area, Combination (for advanced users)

### A3. Time Range Selectors

**Universal pattern across all tools:**

```
[Last 7 Days ▾] [vs. Previous Period ▾] [Daily ▾]
     ^                  ^                    ^
  Lookback           Comparison           Granularity
```

| Preset | Present in |
|--------|-----------|
| Last 7 days | All tools |
| Last 14 days | Helium 10, Pacvue |
| Last 30 days | All tools |
| Last 60 days | Helium 10, Pacvue |
| Last 90 days | Pacvue, Quartile |
| Last month | Helium 10, Jungle Scout |
| Custom date range | All tools |

**Comparison periods:**
- Previous period (automatic: if 7 days selected, compares to prior 7 days)
- Same period last year
- Custom comparison range

**Granularity toggles:**
- Hourly (for dayparting analysis)
- Daily (default)
- Weekly
- Monthly

**Kepler Action Items:**
1. Implement dropdown with presets: Last 7/14/30/60/90 days, Last Month, Custom Range
2. Auto-calculate comparison period (previous equivalent window)
3. Add granularity toggle: Daily (default) / Weekly / Monthly
4. Persist selected date range across tab navigation within the same session
5. Add "Compare to" toggle that enables period-over-period overlay on charts

---

## B. Table/Grid UX Patterns

### B1. Handling 20+ Column Tables

**Pattern observed across: Helium 10, Pacvue, Jungle Scout**

All enterprise advertising tools face the challenge of presenting 20+ metrics in a single campaign/keyword table. The consistent solutions are:

**Column Customization (Critical Pattern):**
- **Helium 10:** Gear icon in the top-right of the table opens a column selector. Users can add, remove, or rearrange metric columns on the current view.
- **Jungle Scout:** Updated table UI in Opportunity Finder allows users to customize visible columns and download to CSV. Column customization persists across sessions.
- **Pacvue:** Drag-and-drop table configuration. Users can save column presets as named views.

**Kepler Action Items:**
1. Add a gear/settings icon at top-right of every data table
2. Column selector panel: checkboxes for each available column, drag handles for reorder
3. Group columns logically: "Performance" (Impressions, Clicks, CTR), "Cost" (Spend, CPC, ACOS), "Revenue" (Sales, Orders, ROAS), "Budget" (Daily Budget, Remaining)
4. Default column preset: Show 8-10 most critical columns
5. Allow users to save named column presets (e.g., "My Performance View", "Budget Analysis View")
6. "Reset to Default" option always available

### B2. Column Pinning/Freezing

**Industry best practice (confirmed by enterprise table UX research):**

- **Left pin:** Campaign/keyword name column is ALWAYS frozen on horizontal scroll (equivalent to header freeze on vertical scroll)
- **Right pin:** Action columns (edit, status toggle, automation dial) pinned to right
- **Status column:** Often pinned as second column (after name)
- Shadow indicator on pinned column edge to signal that content is scrollable behind it

**Kepler Action Items:**
1. Pin the "Name" column to the left by default
2. Pin the "Actions" column to the right by default
3. Allow users to pin/unpin any column via right-click context menu
4. Add subtle shadow/border on pinned column edges to indicate scroll capability

### B3. Virtual Scrolling for Large Datasets

**Industry standard approach:**

- **Render only visible rows** (windowing): Only render rows visible in the viewport; keep smooth 60fps scrolling even with 10,000+ rows
- **Hybrid pagination + scroll:** Paginate at 50-100 rows per page with the option for "infinite scroll" mode
- **Progressive loading:** Load first 50 rows instantly, lazy-load additional rows as user scrolls
- Libraries referenced: **TanStack Virtual**, **AG Grid** (enterprise), react-window

**Kepler Action Items:**
1. Implement virtual scrolling using TanStack Virtual or AG Grid for campaign/keyword tables
2. Default page size: 50 rows with pagination controls
3. Add "Show All" option that switches to virtual scroll mode
4. Maintain scroll position when returning to a table after drill-down

### B4. Inline Editing

**Pattern observed across: Pacvue, Helium 10**

- **Bid editing:** Click on bid value to get inline edit field; press Enter to save, Escape to cancel
- **Budget editing:** Same inline click-to-edit pattern for daily budgets
- **Status toggle:** In-row toggle switch for enabled/paused/archived
- **Bulk inline edit:** Select multiple rows via checkboxes, then a floating toolbar appears with bulk edit options

**Kepler Action Items:**
1. Implement click-to-edit for: Bid, Budget, Status fields in all tables
2. Show pencil icon on hover to indicate editable cells
3. Validate inline edits immediately (min/max bid, budget floor)
4. Provide undo capability (toast notification with "Undo" button for 10 seconds)

### B5. Row Grouping/Nesting

**Helium 10 pattern:** Tables support hierarchical views switching between Portfolio > Campaign > Ad Group > Keyword > Search Term levels via tabs. Each level is a separate table view.

**Pacvue pattern:** Groupable by "placement" at campaign level. Can group by brand, tag level.

**Amazon console pattern:** Portfolio > Campaign > Ad Group hierarchy with expandable rows.

**Kepler Action Items:**
1. Support expandable/collapsible row groups: Campaign > Ad Group > Keyword
2. Provide tab-based level switching (like Helium 10): Campaigns | Ad Groups | Keywords | Search Terms | Products
3. Clicking a campaign name drills into its ad groups; clicking an ad group drills into its keywords
4. Breadcrumb trail showing drill-down path: All Campaigns > [Campaign Name] > [Ad Group Name]

### B6. Column Resize and Saved Views

**Universal patterns:**
- Drag handles on column headers for resize
- Double-click column separator to auto-fit to content width
- Named saved views (Pacvue explicitly supports this)
- Export to CSV/Excel from any table view

**Kepler Action Items:**
1. Implement column resize handles on all table headers
2. Double-click to auto-fit column width
3. Save view feature: name, column selection, column order, column widths, sort state, filters
4. Provide 3 built-in saved views: "Performance Overview", "Budget Analysis", "Keyword Deep Dive"
5. Export button (CSV, Excel) that respects current column selection and filters

---

## C. Campaign Management UX

### C1. Campaign Creation Flows

**Three distinct approaches observed:**

| Tool | Approach | Detail |
|------|----------|--------|
| **Helium 10** | Multi-mode wizard (SP Super Wizard) | Three modes: Standard, Advanced, Customize. Within each, bid strategy options: Max Impressions (launch), Target ACoS (performance), Max Orders (liquidate), Custom |
| **Perpetua** | Goal-based creation | Set strategic objective (growth, profitability, defense, awareness) + target ACoS + daily budget. AI handles keywords and bids automatically |
| **Pacvue** | Template-based wizard (DSP Super Wizard) | Pre-built campaign templates, AI-recommended creatives, launch dozens of campaigns in minutes |
| **Adbrew** | Multi-campaign creator | Guided wizard for creating multiple SP, SB, SD campaigns simultaneously |

**Helium 10 SP Super Wizard details:**
- Mode selection: Standard / Advanced / Customize
- Custom Scheme mode: Define your own campaign structure and naming convention, supporting up to 6 keyword types (brand, competitor, category, other)
- Configuration page: ad group names, bids, budget, targeting, negative targeting
- Bid strategy selection within the wizard

**Perpetua's approach (simplest):**
1. Select products/ASINs
2. Choose objective (growth/profitability/defense/awareness)
3. Set target ACoS
4. Set daily budget
5. Press "Launch" — AI generates keywords from historical data

**Kepler Action Items:**
1. Implement a 2-track campaign creation flow:
   - **Quick Launch (Perpetua-inspired):** Select products > Choose goal > Set target ACoS + budget > Launch (AI handles the rest)
   - **Advanced Builder (Helium 10-inspired):** Step-by-step wizard with full control over campaign structure, ad groups, keywords, bids, negative targets, bid strategy
2. Campaign naming convention builder (like Helium 10's Custom Scheme)
3. Template library for common campaign types (Brand Defense, Product Launch, Competitor Conquest, Category Domination)
4. Progress indicator showing which step the user is on (Step 2 of 5)
5. Allow saving draft campaigns before launch

### C2. Bulk Editing Interfaces

**Pattern observed across: Pacvue, Helium 10, Adbrew**

- **Pacvue:** Make changes across multiple campaigns or ASINs in a single click with the bulk editor. Bulk change bids, add keywords, move keywords, add negative keywords.
- **Helium 10:** Multi-select campaigns in table, then apply actions (pause, enable, change bid strategy)
- **Adbrew:** Dedicated pages for managing targets, campaigns, search terms, negatives, and products with bulk changes

**Bulk action toolbar pattern (industry standard):**
```
┌─────────────────────────────────────────────────────┐
│ ☑ 12 items selected   [Edit Bids] [Change Status]  │
│                        [Add Negatives] [Export] [⋮] │
└─────────────────────────────────────────────────────┘
```

**Kepler Action Items:**
1. Checkbox column on all tables for multi-select
2. "Select all on page" / "Select all matching filter" options
3. Floating bulk action toolbar that appears when 1+ rows are selected
4. Bulk actions: Change Bid (absolute or percentage), Change Budget, Change Status, Add Negative Keywords, Apply Automation Rule, Export Selected
5. Confirmation dialog showing summary of changes before applying
6. Bulk edit preview: "This will change bids for 47 keywords. 12 will increase, 35 will decrease."

### C3. Status Change Workflows

**Common status states:** Enabled, Paused, Archived

**Pattern:**
- In-row toggle switch for Enabled/Paused (most common action)
- Dropdown or right-click menu for full status change including Archive
- Bulk status change via selection + toolbar action
- Color-coded status badges: Green dot = Enabled, Yellow/Orange dot = Paused, Gray dot = Archived

**Kepler Action Items:**
1. In-row toggle switch for quick Enabled/Paused switching
2. Color-coded status badges in the status column
3. Confirm prompt for archiving (destructive action)
4. Bulk status change from the floating toolbar

### C4. Budget Management UI

**Patterns observed:**

- **Pacvue:** Automate monthly and daily budget pacing with min/max thresholds. Budget Manager notifications for over/under delivery. "Stop Overspend" feature.
- **Helium 10:** Budget rules as part of the automation system. Visual budget pacing indicators.
- **Scale Insights:** Automatic budget adjustment based on dayparting and performance windows.

**Kepler Action Items:**
1. Budget pacing bar on each campaign card/row showing % of daily/monthly budget spent
2. Budget pacing projection: "At current rate, this campaign will exhaust its budget by 2:00 PM"
3. Budget floor/ceiling controls with visual slider
4. Monthly budget allocation view: horizontal bar chart showing planned vs. actual spend per campaign
5. "Budget Alerts" configuration: notify when spend reaches 50%, 80%, 100% of budget

### C5. Bid Optimization Controls

**Patterns observed:**

- **Helium 10:** Target ACoS slider (default 30%). Bid suggestions applied manually or automatically (24-hour cycle). Custom bid rules with conditions (clicks > X, ACoS > Y).
- **Pacvue:** Dayparting bid multipliers (positive/negative). Bid placement modifiers based on ROAS targets. Rules combinable with AND/OR logic.
- **Perpetua:** Fully automated bidding toward target ACoS. Bids optimized daily.
- **Scale Insights:** 11+ automation algorithms. Preview all upcoming automation changes in advance.

**Kepler Action Items:**
1. Target ACoS input with slider + numeric field (default 30%)
2. Bid suggestion cards: "Suggested bid: $1.25 (current: $0.95) — Expected +15% impressions"
3. Accept/Reject/Modify suggested bid in one click
4. Dayparting grid: 24h x 7d heatmap for bid multiplier configuration
5. Bid change preview: Before applying, show projected impact

---

## D. Filter & Search UX

### D1. Global Search Behavior

**Helium 10 pattern:** Search bar within Ad Manager filters campaigns based on searched words. Search works across campaign names and other text fields.

**Kepler Action Items:**
1. Global search bar at the top of the advertising portal (Cmd/Ctrl + K shortcut)
2. Search scope: campaign names, ad group names, keyword text, ASIN, SKU
3. Search results grouped by type: "Campaigns (3)", "Keywords (12)", "ASINs (2)"
4. Click any result to navigate directly to that entity
5. Recent searches remembered

### D2. Saved Filters/Views

**Jungle Scout pattern:** Preset filters that can be saved and quickly reloaded. Filters persist across sessions. Users can save custom filter configurations for repeat use.

**Perpetua pattern:** Applied filters persist even after refreshing the window or logging out.

**Kepler Action Items:**
1. "Save Current Filters" button that creates a named filter preset
2. Filter presets dropdown in the filter bar: "My Saved Filters" section
3. Built-in smart filters: "Underperforming (ACoS > 50%)", "High Spend Low Sales", "No Impressions Last 7 Days"
4. Filters persist across page navigation and session refresh

### D3. Filter Chips/Tags

**Industry standard pattern:**

```
Active Filters: [Status: Enabled ×] [ACoS: > 30% ×] [Spend: > $50 ×] [Clear All]
```

**Perpetua specific:** "Add Filter" button beside the search box. Multiple filters stackable, with Type and Performance filter categories.

**Filter categories (from Perpetua):**
- **Type filters:** Match type, User-added, Negative matches, Campaign type
- **Performance filters:** ACoS > X%, Impressions below Y, Spend above Z, CPC range

**Kepler Action Items:**
1. Filter chips bar below the search bar showing all active filters
2. Each chip has an "x" to remove that individual filter
3. "Clear All Filters" action
4. "Add Filter" button that opens a structured filter builder
5. Filter builder categories: Type (Campaign Type, Status, Match Type) and Performance (any metric with operator + value)
6. Support compound conditions: "ACoS > 30% AND Clicks > 100 AND Spend > $50"

### D4. Advanced Filter Builder

**Pacvue pattern:** Rules combinable with AND/OR logic for bid modifications based on campaign ROAS, profile ROAS, custom target ROAS, fixed amounts, or combinations.

**Kepler Action Items:**
1. Advanced filter modal with condition rows: [Metric] [Operator] [Value]
2. Operators: equals, not equals, greater than, less than, between, contains, not contains
3. AND/OR connectors between condition rows
4. Group conditions with parentheses for complex logic
5. Preview result count as conditions are added: "142 campaigns match"

### D5. Cross-Table Filter Persistence

**Perpetua pattern:** Filters persist even after refreshing or logging out.

**Kepler Action Items:**
1. Store filter state in URL parameters (shareable filtered views)
2. Persist filters in localStorage for session continuity
3. When drilling from Campaigns into Ad Groups, inherit the parent filter context
4. Provide "Apply these filters to all views" option

---

## E. Navigation Patterns

### E1. Advertising Sub-Section Organization

**Helium 10 navigation structure:**
```
Helium 10 Ads
├── Dashboard (high-level overview)
├── Ad Manager (campaigns table)
│   ├── Tabs: Portfolio | Campaign | Ad Group | Keyword | Search Terms | Product
├── Analytics
│   ├── Tabs: same entity-level tabs
├── Rules & Automation
│   ├── Tabs: Bid | Keyword Harvest | Negative Targeting | Budget
├── Suggestions
├── Dayparting Schedules
└── Reporting
```

**Pacvue navigation structure:**
```
Pacvue
├── Home Dashboard (with notifications)
├── Advertising
│   ├── Campaign Manager
│   ├── Bid Management
│   ├── Budget Manager
│   ├── Dayparting
│   └── Rules & Automation
├── Analytics & Reporting
│   ├── Custom Dashboards
│   ├── Report Builder
│   └── Share of Voice
├── Product Center
└── Settings
```

**Perpetua navigation structure:**
```
Perpetua
├── Executive Dashboard
├── Goals (campaign management)
│   ├── Sponsored Products
│   ├── Sponsored Brands
│   ├── Sponsored Display
│   └── DSP
├── Search Insights (SOV)
├── Campaign Breakdown
└── Reports
```

**Kepler Action Items:**
1. Primary sidebar navigation:
   ```
   Advertising
   ├── Dashboard
   ├── Campaigns
   │   └── (with tab-based entity drill-down)
   ├── Keywords & Targets
   ├── Search Terms
   ├── Automation Rules
   ├── Analytics
   ├── Budget Manager
   └── Reports
   ```
2. Use collapsible sidebar (icon-only mode for more workspace)
3. Highlight current section in sidebar with accent color
4. Sub-level navigation via tabs within each section (not nested sidebar items)

### E2. Breadcrumb Implementation

**Best practice from research:**

```
Advertising > Campaigns > Summer Sale SP > Ad Group: Main Keywords > Keyword: running shoes
```

**Types to implement:**
- **Hierarchy-based:** Reflects the information architecture (Campaign > Ad Group > Keyword)
- **Attribute-based:** Shows applied filters as breadcrumb segments

**Kepler Action Items:**
1. Implement hierarchy-based breadcrumbs at the top of every page
2. Each breadcrumb segment is clickable to navigate back to that level
3. Use chevron (>) separator
4. Keep breadcrumbs secondary in visual weight (smaller font, muted color)
5. Truncate long names with ellipsis, full name shown on hover

### E3. Quick-Jump/Search Navigation

**Helium 10 Chrome extension pattern:** Access tools without navigating to the dashboard. Show contextual data inline.

**Kepler Action Items:**
1. Cmd/Ctrl + K command palette (like Spotlight/Alfred)
2. Supports: "Go to [Campaign Name]", "Show keywords for [ASIN]", "Open Budget Manager"
3. Recent items section in the command palette
4. Frequently accessed items pinned at the top

### E4. Contextual Navigation

**Helium 10 Cerebro pattern:** ASIN-based reverse lookup shows all keywords ranking for that ASIN. Child ASIN variant tracking drills from parent to individual variations.

**Pacvue pattern:** Click placement to drill into campaign-level, brand-level, or tag-level performance.

**Kepler Action Items:**
1. ASIN is a clickable link everywhere it appears — clicking navigates to an ASIN detail page showing all campaigns, keywords, and search terms for that product
2. Campaign name click drills into campaign detail (ad groups, keywords)
3. Keyword click shows search term report for that keyword
4. "View all campaigns for this product" link on every ASIN mention
5. Contextual sidebar: click any entity to show a quick-info panel without leaving the current page

---

## F. Data Visualization Best Practices

### F1. Performance Trend Charts

**Universal pattern:**
- Multi-series line chart as the primary visualization
- 2-3 metrics displayed simultaneously with dual Y-axes
- Tooltips on hover showing exact values for all series at that data point
- Zoom/pan capability for exploring specific date ranges
- Click-to-highlight: click a campaign in the table, its line is highlighted in the chart

**Helium 10 specific:** Line graph shows selected campaigns by day and by hour. Users can choose which metrics appear on the graph. Dayparting view shows hourly performance breakdown.

**Kepler Action Items:**
1. Primary trend chart with selectable metrics (checkboxes for each metric series)
2. Dual Y-axis: left for volume metrics (spend, sales), right for ratio metrics (ACoS, ROAS)
3. Hover tooltips with all metric values at that time point
4. Crosshair cursor that aligns across all chart series
5. Click on table row to highlight that entity's trend line in the chart above

### F2. Period-over-Period Comparison

**Helium 10 pattern:** Automatic comparison to the previous equivalent period. Visual display of delta values on KPI cards.

**Kepler Action Items:**
1. "Compare" toggle that overlays the comparison period as a dashed/lighter line on the chart
2. Delta badges on KPI cards showing percentage and absolute change
3. Comparison table view: Current Period | Previous Period | Change | % Change
4. Color-coded cells: green for improvements, red for declines (context-aware: lower ACoS = green)

### F3. Heatmaps for Bid/Dayparting Visualization

**Pacvue pattern:** Dayparting feature with bid multipliers across hours of the day.

**Scale Insights pattern:** 24 ad groups to analyze hourly performance, discover prime-selling windows.

**Kepler Action Items:**
1. Dayparting heatmap: 24 columns (hours) x 7 rows (days of week)
2. Color intensity = performance metric (e.g., conversion rate or ROAS)
3. Click cell to set bid multiplier for that hour/day
4. Pre-built templates: "Weekday Business Hours", "Evening Prime Time", "Weekend Boost"
5. Toggle between metrics: Show heatmap by Conversions, by ROAS, by CPC, by Clicks

### F4. Share of Voice Visualization

**Perpetua pattern:** Stacked bar chart showing SOV breakdown by brand for any search term. Hover to reveal brand name and percentages. Table of search terms with SOV column.

**Kepler Action Items:**
1. SOV stacked bar chart per keyword/search term
2. Color-coded by brand: your brand in primary color, competitors in grays/secondary colors
3. Your brand's bar segment always in the same position (first) for easy scanning
4. SOV trend over time: line chart showing your SOV % changing over weeks
5. "Top Competitors" summary widget showing the top 5 competitors by SOV

### F5. Funnel Visualization

**Pacvue pattern:** Path to Purchase Analysis and Ad Overlap Reports for full-funnel attribution.

**Kepler Action Items:**
1. Advertising funnel chart: Impressions > Clicks > Add to Cart > Purchases
2. Conversion rates displayed between each stage
3. Drop-off percentages highlighted in red
4. Compare funnel across campaigns or time periods side-by-side

### F6. ACOS/ROAS Gauge Displays

**Industry pattern:**

```
    ╭────────╮
   /   30%    \    Target: 25%
  │   ACoS    │    ● On Track / ● Warning / ● Critical
   \__________/
```

**Kepler Action Items:**
1. Gauge/donut charts for ACoS and ROAS on campaign detail pages
2. Color zones: Green (on target), Yellow (warning threshold), Red (above target)
3. Target line/marker on the gauge showing the user's target ACoS
4. Use these sparingly (1-2 per page) — KPI cards with sparklines are more space-efficient for overview pages

---

## G. Automation & AI Features

### G1. AI Recommendation Presentation

**Helium 10 pattern:**
- "Suggestions" as a dedicated section in the navigation
- New Keyword & Negative Keyword Suggestions appear within 7-10 days of campaign creation
- Bid suggestions based on target ACoS (default 30%)
- Two automation modes: manual review of suggestions OR auto-apply within 24 hours
- Automation activation via a "dial" icon in the Automate column of the campaign table

**Quartile pattern:**
- AI Data Assistant: conversational AI that transforms performance data into actionable insights
- Provides easy-to-understand answers, new data visualizations, and exportable files
- MarketIQ: centralized view of category performance, competitor analysis, keyword opportunities

**Kepler Action Items:**
1. **Suggestions Hub:** Dedicated page showing all pending AI recommendations
2. Card-based recommendation layout:
   ```
   ┌──────────────────────────────────────────────────────┐
   │ 💡 Add "wireless earbuds case" as exact match        │
   │                                                      │
   │ Reason: 47 conversions from search terms in last 30d │
   │ Expected impact: +12% sales for Campaign X           │
   │                                                      │
   │ [Accept] [Reject] [Modify] [Snooze 7 Days]          │
   └──────────────────────────────────────────────────────┘
   ```
3. Batch accept/reject: checkboxes on suggestion cards, bulk action toolbar
4. Suggestion categories: Keyword Additions, Negative Keywords, Bid Changes, Budget Adjustments
5. Confidence score on each suggestion (High/Medium/Low)
6. "Auto-apply" toggle per campaign (like Helium 10's automation dial)
7. Suggestion history log: track what was accepted, rejected, and the resulting impact

### G2. Rule Builder Interface

**Helium 10 pattern:**
- Dedicated "Rules & Automation" section
- Rule types: Bid Rules, Keyword Harvest Rules, Negative Targeting Rules, Budget Rules
- Each rule has: Lookback Period, Frequency, Automated (yes/no) status
- Condition format: IF [metric] [operator] [value] THEN [action]
- Example: "If ACoS > 60% for 60 days, pause the target"
- Example: "If keyword gets 25+ clicks with no conversions, lower bid or remove"
- Frequency: daily or weekly application

**Pacvue pattern:**
- Five levels of automation
- AND/OR condition combinations
- Bid placement modifier rules based on ROAS targets
- Conditions can reference: campaign ROAS, profile ROAS, custom target ROAS, fixed dollar amounts

**Kepler Action Items:**
1. Visual rule builder with drag-and-drop condition blocks
2. Rule structure:
   ```
   WHEN [Lookback: 30 days]
   IF [ACoS] [is greater than] [40%]
   AND [Clicks] [is greater than] [50]
   THEN [Decrease Bid] [by 15%]
   FREQUENCY: [Weekly]
   MODE: [Suggest] or [Auto-apply]
   ```
3. Pre-built rule templates: "Conservative Bid Down", "Aggressive Growth", "Wasted Spend Cleanup", "Keyword Harvest"
4. Rule preview: "This rule would affect 23 keywords right now"
5. Rule status dashboard: show how many times each rule fired, what changes it made
6. Kill switch: one-click to pause all automation rules

### G3. Automation Status Indicators

**Helium 10 pattern:** Dial icon in the "Automate" column of campaign tables. When active, keyword bid suggestions are auto-applied within 24 hours.

**Kepler Action Items:**
1. Status indicator per campaign: 🤖 Auto | 👁 Suggest | ⏸ Manual
2. Color-coded: Blue = automated, Yellow = suggest mode, Gray = manual
3. Quick toggle between modes from the table row
4. Dashboard widget: "Automation Activity" showing recent auto-applied changes
5. "Automation Log" page: timestamped list of all automated actions with before/after values

### G4. What-If Scenario Tools

**Adspert pattern:** Scenario analysis and forecasting. AI simulates data-driven scenarios showing how changes in ACoS impact conversions.

**Amazon native:** Bid simulator estimating impact of bid changes. Sponsored Brands forecasting for impressions based on budget/targeting/bid.

**Kepler Action Items:**
1. Bid simulator: input a proposed bid change, see estimated impact on impressions, clicks, spend, ACoS
2. Budget simulator: "If I increase budget by 20%, projected additional sales = $X"
3. ACoS target slider: slide target ACoS and see projected impact on volume vs. efficiency
4. Visual comparison: current state vs. simulated state side-by-side
5. Save scenarios for comparison: "Aggressive Q4 Push" vs. "Conservative Maintenance"

---

## H. Notification & Alert Systems

### H1. Alert Types and Presentation

**Pacvue pattern:**
- Performance Change Notifications: alerts for major changes in ACoS, Sales, or Clicks
- Budget Manager Notifications: over/under delivery alerts, "Stop Overspend" triggers
- Email notifications for rules confirmation
- Notifications configurable to be sent to colleagues

**DataHawk pattern:**
- Automated alerts for Buy Box changes, ranking shifts, listing modifications, review activity
- Customizable alert thresholds
- Daily performance alerts with actionable insights

**SellerApp/SellerPulse pattern:**
- Product alerts for critical metric changes
- Search-suppressed listing alerts
- Account health monitoring

**Kepler Action Items:**
1. **In-app notification center** (bell icon in top nav) with categories:
   - Performance Alerts: ACoS spike, sales drop, CTR decline
   - Budget Alerts: 50%/80%/100% budget thresholds
   - Automation Alerts: rule execution confirmations
   - Listing Alerts: Buy Box loss, listing suppression
   - System Alerts: sync errors, API issues
2. **Alert priority levels:** Critical (red), Warning (yellow), Info (blue)
3. **Notification preferences page:** toggle on/off per alert type, set thresholds
4. **Email digest option:** Daily summary or real-time per-alert emails
5. **Dashboard alert banner:** critical alerts shown as a persistent banner at the top of the dashboard

### H2. Budget Pacing Warnings

**Pacvue pattern:** Monthly and daily budget pacing with min/max thresholds. Notifications for over/under delivery.

**Kepler Action Items:**
1. Budget pacing indicator on each campaign row: progress bar showing % spent
2. Color states: Green (on pace), Yellow (ahead of pace), Red (overspending or budget exhausted)
3. Daily pacing projection: "Budget will run out at 3:42 PM today"
4. Monthly pacing chart: cumulative spend line vs. ideal pace line
5. Alert trigger when campaign is 20% ahead or behind pacing target

### H3. Performance Anomaly Detection

**Kepler Action Items:**
1. Automatic anomaly detection: flag metrics that deviate >2 standard deviations from 30-day average
2. Anomaly cards: "ACoS for [Campaign X] spiked 45% above average yesterday"
3. Quick investigation link: "View details" navigates to the campaign with the relevant time period pre-selected
4. Anomaly types: sudden spend increase, conversion drop, CPC spike, impression cliff

### H4. Action Required Indicators

**Kepler Action Items:**
1. Badge count on navigation items: "Suggestions (12)" indicating pending actions
2. "Action Required" tag on campaigns needing attention (budget exhausted, high ACoS, no impressions)
3. Priority inbox: "Top 5 Things to Review Today" widget on the dashboard
4. Red dot indicators on sidebar navigation items when unread alerts exist

---

## Priority Implementation Matrix

### Phase 1: Foundation (Weeks 1-4) — Must Have

| Feature | Source Inspiration | Effort | Impact |
|---------|-------------------|--------|--------|
| KPI cards with sparklines and deltas | Helium 10, Jungle Scout | Medium | High |
| Time range selector with presets and comparison | All tools | Low | High |
| Column customization (add/remove/reorder) | Helium 10, Jungle Scout | Medium | High |
| Column pinning (name left, actions right) | Enterprise UX best practice | Low | High |
| Filter chips with "Add Filter" builder | Perpetua, Jungle Scout | Medium | High |
| Breadcrumb navigation | All tools | Low | Medium |
| Multi-series trend chart with dual Y-axis | All tools | Medium | High |
| Status toggle (enabled/paused) in table row | All tools | Low | High |
| Bulk select with floating action toolbar | Pacvue, enterprise UX standard | Medium | High |

### Phase 2: Enhancement (Weeks 5-8) — Should Have

| Feature | Source Inspiration | Effort | Impact |
|---------|-------------------|--------|--------|
| Saved views (column + filter presets) | Pacvue, Jungle Scout | Medium | Medium |
| Inline bid/budget editing | Pacvue, Helium 10 | Medium | High |
| Campaign creation wizard (Quick + Advanced) | Helium 10, Perpetua | High | High |
| Rule builder for automation | Helium 10, Pacvue | High | High |
| AI suggestion cards (accept/reject) | Helium 10, Quartile | Medium | High |
| Budget pacing indicators | Pacvue | Medium | Medium |
| Period-over-period comparison overlay | Helium 10 | Medium | Medium |
| Notification center (bell icon) | Pacvue, DataHawk | Medium | Medium |

### Phase 3: Advanced (Weeks 9-12) — Nice to Have

| Feature | Source Inspiration | Effort | Impact |
|---------|-------------------|--------|--------|
| Dayparting heatmap | Pacvue, Scale Insights | High | Medium |
| Virtual scrolling for large tables | Enterprise UX standard | Medium | Medium |
| Share of Voice visualization | Perpetua | High | Medium |
| What-if bid/budget simulator | Adspert, Amazon native | High | Medium |
| Anomaly detection alerts | DataHawk, SellerPulse | High | Medium |
| Cmd+K command palette | Modern SaaS standard | Medium | Low |
| Funnel visualization | Pacvue | Medium | Low |
| Conversational AI assistant | Quartile Pro Suite | Very High | Medium |

### Phase 4: Differentiation (Weeks 13+) — Competitive Edge

| Feature | Source Inspiration | Effort | Impact |
|---------|-------------------|--------|--------|
| ASIN-centric view (all data around a product) | Helium 10 Cerebro | High | High |
| Automation activity log with impact tracking | Helium 10 | Medium | Medium |
| Multi-marketplace unified view | Pacvue, DataHawk | Very High | High |
| BI tool export (PowerBI, Looker Studio) | DataHawk | High | Medium |
| Scenario comparison (save and compare) | Adspert | High | Medium |

---

## Key Design Principles Extracted

### 1. Progressive Disclosure
All successful tools use progressive disclosure — show summary KPIs first, let users drill into detail on demand. Never overwhelm with data on the first screen.

### 2. Context Preservation
Perpetua's filter persistence, Helium 10's drill-down with breadcrumbs — users should never "lose their place" when exploring data.

### 3. Two-Track User Paths
Perpetua (goal-based simplicity) and Helium 10 (advanced control) represent two valid approaches that serve different users. Offer both: a "just tell me what to do" mode and a "give me full control" mode.

### 4. Inline Everything
The fewer modal dialogs, the better. Bid changes, status changes, quick filters — all should be inline. Only use modals for complex, multi-step operations (campaign creation, rule builder).

### 5. Table as Operating System
The data table is the primary workspace for PPC managers. It must be fully customizable, sortable, filterable, and actionable. Invest heavily in table UX.

### 6. Smart Defaults with Override
Every tool provides sensible defaults (30% target ACoS, 7-day lookback, standard column set) but allows full customization. This lowers the barrier for new users without limiting experienced ones.

### 7. Automation Transparency
Helium 10's "manual first, automate when confident" approach and Scale Insights' "preview upcoming changes" pattern show that users need to trust automation before enabling it. Always show what automation will do before it does it.

---

## Sources

- [Helium 10 Ads Dashboard](https://kb.helium10.com/hc/en-us/articles/11331720950939-Helium-10-Ads-Dashboard)
- [Helium 10 Ads Analytics](https://kb.helium10.com/hc/en-us/articles/11338518823835-Helium-10-Ads-Analytics)
- [Helium 10 Ads Rules & Automation](https://kb.helium10.com/hc/en-us/articles/18076439623963-Helium-10-Ads-Rules-Automation)
- [Helium 10 Ads Suggestions](https://kb.helium10.com/hc/en-us/articles/12125578841883-Adtomic-Suggestions)
- [Helium 10 Campaign Creation](https://kb.helium10.com/hc/en-us/articles/360046281853-Creating-Amazon-Ads-Campaigns-within-Helium-10-Ads)
- [Helium 10 Adtomic Review (RevenueGeeks)](https://revenuegeeks.com/helium10-adtomic/)
- [Helium 10 Adtomic Review (GoFBAHub)](https://www.gofbahub.com/helium10/adtomic-ppc-toolkit/)
- [Jungle Scout Ads Analytics Help Center](https://support.junglescout.com/hc/en-us/articles/5471703345687-Ads-Analytics)
- [Jungle Scout Keyword Scout Columns](https://support.junglescout.com/hc/en-us/articles/360048778674-Keyword-Scout-columns)
- [Jungle Scout Saved Filters](https://support.junglescout.com/hc/en-us/articles/360008616594-Saving-and-Using-Preset-Filters-in-Product-Research-Tools)
- [Jungle Scout Custom Dashboards](https://www.junglescout.com/resources/feature/custom-dashboards/)
- [Perpetua Amazon PPC Software](https://perpetua.io/amazon-ppc-software-sponsored-ads-management-tool/)
- [Perpetua Executive Dashboard](https://help.perpetua.io/en/articles/5914912-executive-dashboard)
- [Perpetua Search Insights](https://help.perpetua.io/en/articles/6079765-search-insights)
- [Perpetua Filter Documentation](https://help.perpetua.io/en/articles/5203874-filter-your-targets-and-search-term-tables)
- [Perpetua Campaign Breakdown](https://help.perpetua.io/en/articles/5117230-what-is-the-campaign-breakdown-tool)
- [Pacvue for Amazon Ads](https://pacvue.com/marketplaces/pacvue-for-amazon/)
- [Pacvue DSP Super Wizard](https://pacvue.com/blog/save-countless-hours-with-pacvues-super-wizard/)
- [Pacvue Automation Solutions](https://pacvue.com/platform/need/advertising-automation/)
- [Pacvue Bid Placement Modifier Rules](https://pacvue.com/blog/using-bid-placement-modifier-rules-to-succeed-on-amazon/)
- [Pacvue G2 Reviews](https://www.g2.com/products/pacvue/reviews)
- [Quartile Product Platform](https://www.quartile.com/product)
- [Quartile Amazon PPC](https://www.quartile.com/amazon-ppc)
- [Quartile Pro Suite Launch](https://martechvibe.com/article/quartile-unveils-quartile-pro-suite/)
- [Quartile G2 Reviews](https://www.g2.com/products/quartile-quartile/reviews)
- [DataHawk Amazon Analytics](https://datahawk.co/marketplaces/amazon-analytics/)
- [DataHawk Amazon Seller Dashboard](https://datahawk.co/amazon-seller-dashboard)
- [DataHawk Enterprise Seller Analytics](https://datahawk.co/use-cases/enterprise-seller-analytics/)
- [DataHawk Looker Studio Integration](https://datahawk.co/integrations/looker-studio/)
- [Scale Insights Features](https://scaleinsights.com/features)
- [Adbrew PPC Software](https://adbrew.io/)
- [Amazon Ads Dashboard Guide (Improvado)](https://improvado.io/blog/amazon-ads-dashboard)
- [Best Amazon PPC Tools 2026 (AdLabs)](https://adlabs.app/the-10-best-amazon-ppc-software-tools-2026/)
- [Enterprise Data Table UX (Pencil & Paper)](https://www.pencilandpaper.io/articles/ux-pattern-analysis-enterprise-data-tables)
- [Table Design UX Guide (Eleken)](https://www.eleken.co/blog-posts/table-design-ux)
- [Bulk Actions UX Guidelines (Eleken)](https://www.eleken.co/blog-posts/bulk-actions-ux)
- [Breadcrumbs UX Patterns (Eleken)](https://www.eleken.co/blog-posts/breadcrumbs-ux)
- [SaaS Navigation Types Guide](https://www.merveilleux.design/en/blog/article/comprehensive-guide-for-saas-products-on-ux-navigation-types)
- [KPI Card Anatomy (Nastengraph)](https://nastengraph.substack.com/p/anatomy-of-the-kpi-card)
- [SaaS Dashboard Design Guide (F1Studioz)](https://f1studioz.com/blog/smart-saas-dashboard-design/)
