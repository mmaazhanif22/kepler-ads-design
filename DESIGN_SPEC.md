# Kepler Commerce — Advertising Portal Revamp
## Design Specification v1.0

**Date:** 2026-02-26
**Status:** Draft — For Review
**Prototype:** `kepler-ads-design/index.html`
**Author:** Product Design (Kepler Commerce)
**Reviewers:** PM, Engineering Lead, UX

---

## Table of Contents

1. [Overview & Design Goals](#1-overview--design-goals)
2. [Visual Language](#2-visual-language)
3. [Layout & Navigation Shell](#3-layout--navigation-shell)
4. [Dashboard](#4-dashboard)
5. [Campaign Management](#5-campaign-management)
6. [Advertising Setup Wizard](#6-advertising-setup-wizard)
7. [Component Reference](#7-component-reference)
8. [Interaction Patterns](#8-interaction-patterns)
9. [Empty States & Error States](#9-empty-states--error-states)
10. [Open Questions](#10-open-questions)

---

## 1. Overview & Design Goals

### 1.1 What We Are Building

A full revamp of the Kepler Commerce advertising portal. The revamp covers three areas:

1. **Performance Dashboard** — A seller-level overview of advertising health with actionable insights.
2. **Campaign Management** — A unified control center for all campaigns, keywords, and configuration across all ASINs.
3. **Advertising Setup Wizard** — A guided 5-step flow that takes a seller from product selection to live campaigns in one session.

### 1.2 Problems This Design Solves

| Problem | Solution |
|---|---|
| New sellers cannot find where to start | "Launch New ASIN" is prominent in the sidebar and on the dashboard |
| Sellers skip competitor/KW steps and get weak campaigns | Wizard enforces step order. Steps are locked until prerequisites are met |
| Sellers do not know their competitors' ASINs | AI Discover finds competitors automatically |
| KW research is opaque — sellers do not know what they are approving | Three review sub-tabs (Branding Scope, Listing Attributes, KW Grouping) make it explicit |
| Dashboard does not surface what needs attention | Action Items panel + Performance Alerts drive next actions |
| Campaign table has too many separate pages | 7-tab Campaign Management puts everything in one place |

### 1.3 Design Principles

- **Dark by default.** The portal is a power-user tool. Dark theme reduces eye strain during long sessions.
- **Orange = action.** The primary color (`#F97316`) is used exclusively for primary buttons, active states, and CTAs. No decorative use.
- **Data first, chrome last.** Tables, metrics, and data fill the viewport. Navigation chrome is minimal.
- **Inline editing.** Budget, bid, ceiling, and floor values are editable directly in the table — no modal required for simple changes.
- **Progressive disclosure.** Advanced settings (Global Config, ASIN Config detail) are collapsed by default.

---

## 2. Visual Language

### 2.1 Color Tokens

| Token | Hex | Use |
|---|---|---|
| `primary` | `#F97316` | Primary buttons, active nav, step indicators, links |
| `dark` | `#0F172A` | Page background, input backgrounds |
| `surface` | `#1E293B` | Card backgrounds, table row hover, form headers |
| `border` | `#334155` | All borders, dividers, step lines |
| `muted` | `#64748B` | Secondary text, labels, placeholders |
| `text-primary` | `#F1F5F9` | Primary body text, headings |
| `text-secondary` | `#94A3B8` | Subdued body text, chip labels |

**ACOS color coding** (semantic — not decorative):
- Good (≤20%): `#34D399` (green)
- Warning (20–25%): `#FBBF24` (amber)
- Bad (>25%): `#F87171` (red)

### 2.2 Badge Colors

| Badge | Background | Text | Use |
|---|---|---|---|
| Green | `#064E3B` | `#34D399` | Active, Eligible, Converting |
| Orange | `#431407` | `#FB923C` | Paused, Warning, Incomplete |
| Blue | `#1E3A5F` | `#60A5FA` | Info, Match type Exact, counts |
| Gray | `#1E293B` border `#334155` | `#64748B` | Neutral labels, ASIN chips |
| Red | `#450A0A` | `#F87171` | Error, No Orders, Ineligible |

### 2.3 Typography

| Use | Size | Weight | Color |
|---|---|---|---|
| Page title / H1 | 20px | 700 | `#F1F5F9` |
| Card heading / H2 | 16px | 600 | `#F1F5F9` |
| Body text | 14px | 400 | `#CBD5E1` |
| Table header | 12px | 500 | `#64748B` — uppercase, 0.05em tracking |
| Caption / label | 12px | 400–500 | `#64748B` |
| Section label | 12px | 600 | `#64748B` — uppercase, 0.05em tracking |

Font stack: `Inter, system-ui, sans-serif`

### 2.4 Spacing & Radius

- Base unit: `4px`
- Card radius: `12px`
- Button radius: `8px`
- Badge radius: `100px` (pill)
- Input radius: `8px`
- Page padding: `24px` (6 units)
- Card padding: `20px–24px`

### 2.5 Elevation / Depth

There is no shadow system. Depth is communicated via background color difference:
- `#0F172A` (page) → `#1E293B` (card / input focus frame) → `#334155` (borders)

---

## 3. Layout & Navigation Shell

### 3.1 Overall Layout

```
┌──────────────────────────────────────────────────────┐
│ SIDEBAR (220px fixed)   │  HEADER (sticky, 48px)     │
│                         │                            │
│  K KEPLER               │  [Page Title]  [Period]    │
│                         ├────────────────────────────┤
│  ● Dashboard            │                            │
│  ○ Campaigns            │                            │
│  ○ Launch New ASIN      │   Page content area        │
│  ○ KW Research          │   (scrollable)             │
│  ○ Logs                 │                            │
│                         │                            │
│  [User avatar]          │                            │
└─────────────────────────┴────────────────────────────┘
```

### 3.2 Sidebar

**Width:** 220px, fixed left, full viewport height.

**Logo area:** 24px top padding. `K` wordmark in orange square (28×28px, radius 8px) + "KEPLER" in white 14px semibold.

**Navigation items:**
- Height: 38px per item
- Padding: 10px 16px
- Gap: 10px (icon + label)
- Icon: 18×18px, stroke style
- Margin: 2px 8px (creates 8px side gutter within sidebar)
- Radius: 8px
- **Default state:** text `#94A3B8`, background transparent
- **Hover state:** background `#334155`, text `#F1F5F9`
- **Active state:** background `#F97316`, text white

**Navigation items (in order):**
1. Dashboard (home icon)
2. Campaigns (bar chart icon)
3. Launch New ASIN (plus icon)
4. KW Research (search/magnifier icon)
5. Logs (clipboard icon)

**User footer:** pinned to bottom, 16px padding, 1px top border `#334155`. Shows avatar (orange circle, 32×32px, user initial) + display name + org name.

### 3.3 Top Header Bar

**Height:** 48px, sticky, z-index 10. Background `#0F172A` with 1px bottom border.

**Left side:** Current page title (14px semibold white).

**Right side (dashboard and campaign pages only):**
- Period selector pill: `30d | 7d | 60d | 90d | Custom`
- Active period: orange background, white text
- Inactive: muted text, transparent background
- "vs Previous Period" label in muted text

The period selector is hidden on the wizard page.

### 3.4 Page Transitions

Clicking a nav item:
1. Nav item updates to active state (orange)
2. Current page fades out (display:none)
3. Target page becomes visible (display:flex or display:block)
4. Header title updates to match page

---

## 4. Dashboard

**Route:** `/` (default landing page)

### 4.1 Layout Overview

```
[5 Metric Cards — full width grid]
[ACOS Trend Chart (2/3)]  [Action Items (1/3)]
[Campaign Types (1/3)]    [Top Products by Sales (2/3)]
[Performance Alerts — full width, 3 columns]
[CTA Banner — Launch New ASIN]
```

### 4.2 Metric Cards

Five cards in a 5-column grid. Each card:
- Background: `#1E293B`, radius 12px, 1px border
- Padding: 20px
- Label: 12px muted uppercase (`SPEND`, `SALES`, `ACOS`, `ROAS`, `ORDERS`)
- Value: 24px bold white (green for ACOS when below target)
- Trend: 12px colored text with arrow (`↑ 12% vs prev` / `↓ 2.3pp vs prev`)

**ACOS card:** highlighted with orange border (`#F97316`) to draw attention to the primary health metric.

**Metrics shown:**
| Card | Value Type | Trend |
|---|---|---|
| Spend | Dollar amount | % change vs prev period |
| Sales | Dollar amount | % change vs prev period |
| ACOS | Percentage | pp change vs prev period |
| ROAS | Multiplier (e.g. 5.4×) | Absolute change |
| Orders | Integer | % change vs prev period |

### 4.3 ACOS Trend Chart

**Panel:** 2/3 width, card style.

**Header:**
- Left: "ACOS Trend" (semibold white) + "vs 25% target" (12px muted)
- Right: Legend — orange line = ACOS, dashed gray line = Target

**Chart:** SVG line chart.
- Orange filled area under ACOS line (gradient, 30% opacity to 0%)
- Orange stroke 2.5px
- Dashed gray line at target %
- X axis: Day 1, Day 15, Day 30
- Y axis labels: 30% (top), 15% (bottom)
- No grid lines — clean

### 4.4 Action Items Panel

**Panel:** 1/3 width, card style.

**Header:** "Action Items" title + orange badge with count (e.g., `3`).

**Each item:**
- Dark background (`#0F172A`), 1px border, radius 10px
- Padding: 14px 16px
- Left: action title (14px white semibold) + impact line (12px green or red)
- Right: button (primary or outline)

**Action types and buttons:**
| Action | Button |
|---|---|
| Bid increase recommendation | `Apply` (primary) |
| Add negative keyword | `Add` (primary) |
| Review underperformers | `Review` (outline) |

### 4.5 Campaign Types Breakdown

**Panel:** 1/3 width, card style.

Three campaign type rows, each showing:
- Campaign type name (muted)
- ACOS value (color-coded)
- Horizontal progress bar (100% = worst-performing baseline)

Below: "Active campaigns" label + count (e.g., `24 / 32 total`).

### 4.6 Top Products Table

**Panel:** 2/3 width, card style.

Header: "Top Products by Sales" + "View All →" link (orange).

4-column grid: Product (name + ASIN) | Sales | ACOS | Trend

Up to 5 rows shown. ACOS is color-coded. Trend shows `↑ 12%` / `↓ 5%` / `→ 0%`.

### 4.7 Performance Alerts

Full-width card with 3-column grid of alert cards.

**Alert types:**
| Style | Icon | Use |
|---|---|---|
| Green (bg `#052e16`, border `#14532d`) | Check circle | Positive improvement |
| Yellow (bg `#422006`, border `#713f12`) | Warning triangle | Budget or pacing warning |
| Blue (bg `#0c1a2e`, border `#1e3a5f`) | Info circle | Opportunity or insight |

Each alert: icon + title (14px colored semibold) + subtitle (12px colored, lower opacity).

### 4.8 Launch New ASIN CTA Banner

Full-width card with dashed 2px border (`#334155`).

- Left: heading + subtitle explaining the wizard
- Right: "Launch New ASIN" primary button (larger — 24px padding, 16px text)

This CTA is the primary entry point for new sellers landing on the dashboard.

---

## 5. Campaign Management

**Route:** `/campaigns`

### 5.1 Page Header

**Breadcrumb:** `Amazon Ads › Campaign Management`
**Title:** Campaign Management (H1)
**Right actions:** Export (outline), Import (outline), Launch New ASIN (primary → opens wizard)

### 5.2 Incomplete Setup Banner

A yellow warning banner appears below the header when any ASIN has an unfinished wizard setup.

- Background: `#422006`, border: `#92400e`
- Left: warning icon + text identifying the ASIN and pending step
- Right: "Complete Setup →" primary button (opens wizard at the incomplete step)

This banner is dismissed when the wizard is completed or the draft is discarded.

### 5.3 Stats Row

Four inline stat tiles in a 4-column grid, each showing:
- Label (12px muted)
- Value (18px bold white)
- Inline badge or subdued note (e.g., `+2 this week`)

Stats: Total Campaigns | Active | Total Spend (MTD) | Avg ACOS

### 5.4 Tabs

Seven tabs on a horizontal tab bar with a 1px bottom border. Active tab: orange text + orange 2px bottom border. Inactive: muted text. On hover: white text.

| Tab | Badge | Content |
|---|---|---|
| Campaigns | Count (24) | Campaign table with inline editing |
| ASIN Config | Count (6) | Per-ASIN configuration table |
| KW Research List | — | Placeholder (future) |
| KW Automation | — | Placeholder (future) |
| Campaign Config | — | Placeholder (future) |
| KW Config | Count (156) | Keyword bid control table |
| SearchTerm Config | Count (1.2k) | Search term harvest/negate table |

### 5.5 Campaigns Tab

**Global Config (collapsible panel):**
- Collapsed by default. Toggle expands inline below the toggle button.
- When expanded: 4-column grid with Target ACOS input, Default Daily Budget input, Bid Optimization select, Save button.

**Filters row:**
- Search input (filter by campaign name)
- Status select (All Status / Active / Paused)
- Campaign type select (All Types / SP-KW / SP-Product / SB / SD)
- ASIN select (All ASINs / individual ASINs)

**Campaign table:**
8 columns: Campaign name | ASIN badge | Status badge | Optimize Bid toggle | Budget/day input | Spend | ACOS | `···` menu

- Campaign name: 14px white medium
- ASIN: gray badge
- Status: green badge (Active) / orange badge (Paused)
- Optimize Bid: toggle switch (orange when on)
- Budget/day: inline text input (`$XX`) — editable inline
- ACOS: color-coded percentage
- `···`: opens a context menu (not shown in prototype — TBD)

**Footer:** "Submit Changes" primary button (left) + record count text (right).

### 5.6 ASIN Config Tab

**Table:** 6 columns: Product | Target ACOS | Daily Budget | Auto Budget | Status | Action

- Target ACOS and Daily Budget are inline editable inputs
- Auto Budget: toggle switch
- Status badge: green (Active) or orange (Setup Incomplete)
- Action: "Edit" link (normal) or "Complete →" orange link (when setup is incomplete)

### 5.7 KW Config Tab

**Filters:** Search input | Match type select | ASIN select

**Table:** 7 columns: Keyword | Match type badge | Current Bid input | Ceiling input | Floor input | ACOS (30d) | "Bid Status" link

All bid/ceiling/floor values are inline editable inputs.

Match type badges: Exact (blue) / Broad (orange) / Phrase (gray).

ACOS is color-coded.

**Footer:** "Save Bid Changes" primary button + record count.

### 5.8 SearchTerm Config Tab

**Filters:** Search input | Type select (All / Converting / Non-Converting) | record count (right-aligned)

**Table:** 7 columns: Search Term | Clicks | Orders | Spend | ACOS | Status badge | Action button

Status badges:
- Converting (green)
- No Orders (red)
- Candidate (blue)

Action buttons:
- Converting / Candidate → "Harvest" (primary, small)
- No Orders → "Negate" (outline, small)

### 5.9 Placeholder Tabs

KW Research List, KW Automation, and Campaign Config tabs show a centered empty state card with an emoji, a title, and a one-line description. These are planned for a future phase.

---

## 6. Advertising Setup Wizard

**Route:** `/wizard` (also accessible via "Launch New ASIN" sidebar item)

### 6.1 Wizard Shell

**Header area:**
- Back to Campaigns link (← Back to Campaigns)
- Title: "Launch New ASIN" (H1 18px bold)
- Subtitle: "Set up advertising campaigns in 5 guided steps"
- Right: "Save Draft" outline button (always visible)

**Step Progress Bar:** (below header, above content)

Five step indicators in a horizontal row with connecting lines.

```
●──────●──────●──────●──────●
1      2      3      4      5
Step   Step   Step   Step   Step
label  label  label  label  label
```

**Step indicator states:**

| State | Circle | Line |
|---|---|---|
| Done | Green bg `#065F46`, green checkmark `#34D399`, 36px | Solid green `#065F46` |
| Active | Orange bg `#F97316`, white number, 36px | Green-to-gray gradient (left half done, right half pending) |
| Locked | Dark bg `#1E293B`, gray border, gray number, 36px | Gray `#334155` |

**Step labels** (shown below each circle):
1. Select Product
2. Competitors
3. KW Research
4. Campaign Config
5. Review & Launch

**Content area:** `max-width: 672px`, centered, `24px` padding on sides.

**Navigation buttons:** Back (outline, left) + Next (primary, right) at the bottom of each step card.

### 6.2 Step 1 — Select Product

**Goal:** Seller chooses which ASIN to advertise.

**Step card contents:**
- Step number badge (orange square, number white)
- Heading: "Select Product to Advertise"
- Subtitle: "Choose which ASIN you want to set up advertising for"
- Search input: full width, placeholder "Search by ASIN or product name..."
- "Show ineligible" checkbox (right of search input)
- Product list (scrollable if long)
- "Next: Add Competitors →" primary button (disabled until a product is selected)

**Product list item (radio-style card):**
```
┌────────────────────────────────────────────────────┐
│  ○  [Product image 48×48px]  Product Name          │
│                              ASIN: B08XXXXXXXX     │
│                              [ELIGIBLE badge]      │
└────────────────────────────────────────────────────┘
```

- Default state: `#334155` border, `#1E293B` background
- Hover: border `#64748B`
- Selected: orange border `#F97316`, dark orange background `#1C0A00`
- Ineligible product: grayed out, radio disabled, cursor default, shows red INELIGIBLE badge
- "Show ineligible" checkbox hides/shows ineligible products (hidden by default)

**Next button activation:** Enabled when exactly one eligible product is selected.

**Eligibility badges:**
- ELIGIBLE: green badge
- INELIGIBLE: red badge + tooltip on hover explaining why (e.g., "Not enrolled in Brand Registry", "Missing category approval")

**Empty state:** If the seller has zero eligible products, show a centered message: "No eligible products found. Check your Amazon Seller Central account for product eligibility requirements."

### 6.3 Step 2 — Identify Competitors

**Goal:** Seller adds 5–9 competitor ASINs. These feed keyword research.

**Step card contents:**
- Heading: "Identify Competitors"
- Subtitle: "Add 5–9 competitor ASINs. They power your keyword research."
- Input row: ASIN text input + "Add" primary button + "✨ AI Discover" outline button
- Progress indicator
- Competitor list (selected competitors)
- AI Discover panel (hidden by default, shown after button click)
- Back / Next navigation

**ASIN input field:**
- Placeholder: "Enter competitor ASIN (e.g. B0XXXXXXXX)"
- On "Add" click: validate ASIN format → call API → if valid, add to list → if error, show inline message below input

**Inline errors** (appear below input, red text, 12px):
- Invalid format: "ASINs start with 'B' and are 10 characters long."
- Own ASIN: "You cannot add your own product as a competitor."
- Duplicate: "This ASIN is already in your list."
- Not found: "ASIN not found on Amazon. Check the ASIN and try again."
- Max limit: "You have reached the maximum of 9 competitors."

**Progress indicator:**
- Label left: "Selected competitors"
- Label right: "X / 5–9 required" (e.g., "3 / 5–9 required")
- Horizontal progress bar (orange fill, transitions at 5/9 milestones)
- Progress bar turns fully filled and stays orange once 5+ are selected

**Competitor list:**
Each selected competitor appears as a chip:
```
[Product image 32×32px]  Product Name  ASIN: B0XXXXX  [× remove]
```
- Chip style: dark background, 1px border, radius 6px
- Remove button (×): muted color, hover red — removes chip from list and updates count

If no competitors added yet: "No competitors added yet" in italic muted text.

**AI Discover Panel** (shown after clicking "✨ AI Discover"):
- Appears inline below the competitor list
- Title: "✨ AI-Suggested Competitors"
- **Loading state:** spinner + "Analyzing your product..." message (up to 30 seconds)
- **Results:** 2-column grid of suggestion cards

Each suggestion card:
```
┌──────────────────────────────────────────┐
│ [Product image]  Product Name            │
│                  ASIN: B0XXXXX          │
│                  Relevance: ●●●●○ High  │
│                  [Add] or [✓ Added]      │
└──────────────────────────────────────────┘
```
- Already-added ASINs: show "✓ Added" state (green badge, not clickable)
- Selectable ASINs: "Add" button — clicking adds to competitor list
- Max 15 suggestions shown, sorted by relevance score (highest first)

**AI discovery failure:** If the API call fails or times out, show: "Unable to discover competitors at this time. Please add competitors manually or try again."

**Next button activation:** Enabled when the selected competitor count is ≥5.

### 6.4 Step 3 — Keyword Research & Review

**Goal:** Seller triggers AI keyword research, then reviews and approves the output.

**Step card contents:**
- Heading: "Keyword Research & Review"
- Subtitle: "Choose how to build your keyword list"
- Method selector (2 options)
- AI path or Manual path content
- Back / Next navigation

**Method Selector (radio cards, 2 columns):**

Option 1 — AI Automation (default/recommended):
- Label: "⚡ AI Automation"
- Description: "AI discovers keywords, classifies branding scope, groups by relevancy"
- Badge: "Recommended" (green)

Option 2 — Manual Research List:
- Label: "📋 Manual Research List"
- Description: "Full control. Import from CSV or enter keywords directly."
- Badge: "For experienced users" (gray)

**Selected state:** orange border, dark orange background on the card.

---

**AI Path — Ready State:**
Shown when AI Automation is selected and research has not started.

- Info box (surface background, border):
  - "✨ Ready to Start Keyword Research"
  - "AI will analyze your selected product and X competitors to discover:"
  - Bullet list: High-volume keywords relevant to your product / Branding scope classification / KW-product relationship classification / Relevancy ranking and keyword grouping
  - "Estimated time: 2–3 minutes" (12px muted)
- "▶ Start Keyword Research" primary button, full width

---

**AI Path — Loading State:**
Shown while research is running.

- Centered layout:
  - Orange spinner (48×48px, `border-t-transparent` spin animation)
  - Status message (18px white) — cycles through:
    1. "Analyzing competitors..."
    2. "Extracting product data from competitor listings"
    3. "Discovering keyword opportunities..."
    4. "Classifying branding scope..."
    5. "Grouping keywords by relevancy..."
  - Sub-label (14px muted) — pairs with each status message
  - Progress bar (64px wide, centered) + percentage label

---

**AI Path — Results State:**
Shown when research is complete.

- Success banner: green bg, checkmark icon, "Keyword research complete" + count (e.g., "18 keywords discovered and classified") + "Re-run" outline button (right)

- Three review sub-tabs: **Branding Scope | Listing Attributes | KW Grouping**

**Sub-tab: Branding Scope**

Purpose: Review and correct AI-assigned classifications for each keyword.

Table: 5 columns

| Column | Type | Notes |
|---|---|---|
| Keyword | Text | Read-only |
| Branding Scope | Select dropdown | Non-Branded / Own Brand / Competitor / Complement |
| KW-Product Relationship | Select dropdown | Direct / Related / Substitute / Complement |
| Relevancy | Badge | High (green) / Medium (blue) / Low (gray) |
| Edit | Icon button | ✏ opens inline edit for the row |

Above table (right): Import + Export outline buttons.

**Sub-tab: Listing Attributes**

Purpose: Seller prioritizes which product listing sections the keyword engine should weight most.

Drag-and-drop ordered list. Each row:
- Drag handle (⠿)
- Rank number (orange badge for #1, gray border for rest)
- Attribute name (e.g., Title, Bullet 1, Description)
- Attribute type badge (Primary / Feature / Body)

"+ Add Attribute" outline button below the list.

**Sub-tab: KW Grouping**

Purpose: Review how keywords are grouped by relevancy rank for campaign assignment.

Three ranked groups:
- **Rank 1 — Primary Keywords** (orange badge, count): Highest-relevancy keywords. These get highest budgets.
- **Rank 2 — Secondary Keywords** (blue badge, count): Supporting keywords.
- **Rank 3 — Long Tail** (gray badge, count): Specific but lower-volume terms.

Each group shows keyword chips. Overflow shown as `+ N more`.

---

**Manual Path:**
_(Placeholder in this version)_ Shows a "Coming soon" or "Import from CSV / Enter keywords directly" flow. Not fully designed in v1 prototype. Flagged as a future design task.

---

**Next button activation:** Enabled once KW research has completed (results state is shown). If seller chooses Manual path, enabled when at least 1 keyword is in the list.

### 6.5 Step 4 — Campaign Configuration

**Goal:** Seller selects which campaign types to create and sets performance targets.

**Step card contents:**
- Heading: "Campaign Configuration"
- Subtitle: "Set parameters that apply to all generated campaigns"
- Campaign selection (checkboxes)
- Global settings section
- Auto Budget toggle
- Back / Next navigation

**Campaign Selection:**

Campaigns are grouped by type, shown as a 2-column checkbox grid.

**Non-Branded (NB)** (orange group label — "High volume reach"):
- NB-R1-SP-KW-E (Exact Match) ✓
- NB-R1-SP-KW-B (Broad Match) ✓
- NB-R1-SP-KW-P (Phrase Match) ✓
- NB-R1-SP-Product (Product Targeting) ✓

**Own Brand (OB)** (blue group label — "Brand protection"):
- OB-R1-SP-KW-E (Brand Exact) ✓
- OB-R1-SB-Category (Sponsored Brands) ☐

**Auto (Discovery)** (red group label):
- Auto-R1-SP (Auto Targeting) ✓

Pre-checked campaigns are based on the keyword research output. Sellers can uncheck any campaign they do not want.

Each checkbox row: `[checkbox] Campaign code  [right] Match type label (muted, xs)` on a surface-background card.

**Global Campaign Settings (2×2 grid):**

| Field | Type | Default | Helper text |
|---|---|---|---|
| Target ACOS (%) | Number input | 25 | "20–35% = Balanced growth" |
| Daily Budget (all campaigns) | Number input with $ prefix | 150 | "Minimum $5/day per campaign" |
| Campaign Status | Select | Active — Go live immediately | Also: Paused — Create but do not run |
| Custom Negative Keywords | Text input | (empty) | Placeholder: "e.g. cheap, free, diy" |

**Auto Budget toggle:**
- Full-width row: label "Enable Auto Budget" + description "System adjusts daily budgets based on ACOS performance"
- Toggle on right (orange when active)

**Next button:** Always enabled on Step 4 (no minimum requirement beyond what was set in previous steps).

### 6.6 Step 5 — Review & Launch

**Goal:** Seller reviews everything before campaigns are created.

**Summary cards (2×2 grid):**

Each card:
- Header: section label (muted, uppercase) + "Edit" link (orange, navigates back to that step)
- Content: summary of the selection

| Card | Content |
|---|---|
| Product | Product name + ASIN |
| Competitors | Count + first 2 ASIN badges + "+N more" |
| Keywords | Count + method name + Approved badge |
| Campaign Settings | Target ACOS / Daily Budget / Status (as key-value pairs) |

**Campaigns to be created:**
- "Campaigns to be created (N)" section label
- Chips showing each campaign code that will be created

**Validation Checklist:**
- Green banner ("✓ Ready to Launch") when all checks pass
- Checklist items (each with green checkmark):
  - Product selected and eligible
  - X competitors identified
  - X keywords discovered and approved
  - Campaign settings configured (ACOS% + budget)

If any check fails, the checklist item shows a red × and the Launch button is disabled with an explanation.

**Footer buttons:**
- Left: "← Back" outline button
- Right: "Save as Draft" outline button + "🚀 Launch Campaigns" primary button (large — 24px horizontal padding)

### 6.7 Success State

Shown immediately after clicking "Launch Campaigns" (replaces step content without navigating away).

```
        ✓ (green circle, 64×64px, checkmark icon)

   Campaigns Launched! 🎉

  7 campaigns created for [Product Name].
  Campaigns are now live and bids will optimize
  within 24 hours.

  [View in Campaign Management]   [Launch Another ASIN]
```

- "View in Campaign Management" → outline button → navigates to Campaigns tab
- "Launch Another ASIN" → primary button → resets wizard to Step 1

### 6.8 Save Draft Behavior

Available on every step via the "Save Draft" button in the wizard header.

On click:
- System saves current state (selected ASIN, step number, competitor list, KW method, campaign settings)
- Toast notification: "Draft saved successfully" (bottom right, green, auto-dismisses after 3 seconds)
- Wizard state persists on page refresh

Draft appears in Campaign Management with an "Incomplete Setup" status badge.
Seller can discard a draft from Campaign Management (not from within the wizard).

---

## 7. Component Reference

### 7.1 Buttons

**Primary:**
- Background: `#F97316`
- Text: white, 14px medium
- Padding: 8px 16px, radius 8px
- Disabled: 40% opacity, cursor not-allowed
- Hover: 90% opacity

**Outline:**
- Background: transparent
- Border: 1px solid `#334155`
- Text: `#94A3B8`, 14px medium
- Hover: border `#64748B`, text `#F1F5F9`

**Icon+text buttons:** Icon is 16×16px (or 18×18px for header). Gap: 6px.

**Sizes:**
- Default: 8px 16px padding
- Small (table actions): 4px 8px padding, 12px text
- Large (hero CTA, wizard launch): 12px 24px padding, 16px text

### 7.2 Inputs

All text inputs share the same base style:
- Background: `#0F172A`
- Border: 1px solid `#334155`
- Focus border: `#F97316`
- Radius: 8px
- Padding: 8px 12px
- Placeholder: `#475569`

**Select:** Same style + custom dropdown arrow SVG in right gutter.

**Inline table input:** Narrower (e.g., `w-20`), centered text, no label.

### 7.3 Toggle Switch

- Width: 40px, Height: 22px
- Off: background `#334155`
- On: background `#F97316`
- Thumb: white circle, 18×18px
- Transition: 150ms

### 7.4 Badge

All badges are inline-flex pill shapes (radius 100px, padding 2px 8px, 12px font).
See Section 2.2 for color variants.

### 7.5 Step Circle (Wizard)

- Size: 36×36px, circle (radius 50%)
- Done state: green bg `#065F46`, checkmark icon `#34D399`
- Active state: orange bg `#F97316`, white number
- Locked state: surface bg `#1E293B`, 2px border `#334155`, gray number `#475569`

### 7.6 Progress Bar

- Height: 4px
- Background: `#334155`
- Fill: `#F97316`
- Radius: 100px
- Fill transition: 300ms ease

### 7.7 Card

- Background: `#1E293B`
- Border: 1px solid `#334155`
- Radius: 12px
- Padding: varies by context (20px standard, 24px wizard)

### 7.8 Collapsible Panel

- Toggle button: full-width, flex row, muted text, chevron-down icon right
- Expanded: content below toggle, separated by 1px top border
- Collapsed: content hidden (display:none)
- No animation in v1 (can add slide-down in implementation)

---

## 8. Interaction Patterns

### 8.1 Real-Time Search Filter

Used in: Product search (Step 1), Campaign search (Campaigns tab), KW search (KW Config tab).

Behavior:
- Filters list on each keypress (no debounce needed for client-side data)
- For server-side search: 300ms debounce, show a small spinner in the input right side
- No results: show inline "No results for '[query]'" message

### 8.2 Inline Table Editing

Used in: Campaign budget, KW bids, ASIN config.

Behavior:
- Input is always visible and focusable
- Changes are staged (not auto-submitted)
- "Submit Changes" / "Save Bid Changes" button applies all staged changes at once
- On submit: button shows loading state → success toast → revert to normal

### 8.3 Wizard Step Navigation

- **Forward:** "Next" button validates the current step's minimum requirement, then advances
- **Backward:** "Back" button always works — no validation on going back
- **Step bar click:** Clicking a completed (green) step circle navigates back to that step. Locked steps are not clickable.
- **Locked steps:** cursor: not-allowed, no onclick handler

### 8.4 Toasts / Notifications

Position: bottom-right, 16px from edges.
Duration: 3 seconds, then auto-dismiss.
Variants:
- Success: green left border, checkmark icon
- Error: red left border, X icon
- Info: blue left border, info icon

### 8.5 Loading States

| Context | Pattern |
|---|---|
| AI Discover (competitors) | Full panel spinner + status message |
| KW Research running | Full card spinner + status message + progress bar |
| API call (ASIN validation) | Inline spinner on "Add" button, button disabled during |
| Campaign launch | Button spinner, button text changes to "Launching..." |

### 8.6 Error Inline Feedback

All validation errors appear inline — below the input that caused the error. Red text, 12px. Error clears when the user corrects the input.

---

## 9. Empty States & Error States

### 9.1 Empty States

| Screen | Empty State Message |
|---|---|
| Product list (Step 1) — 0 eligible products | "No eligible products found. Verify your product eligibility in Amazon Seller Central." |
| Product list (Step 1) — search no results | "No products match '[query]'. Try a different search." |
| Competitor list (Step 2) — before any added | "No competitors added yet." (italic muted) |
| AI Discover — failure | "Unable to discover competitors at this time. Add manually or try again." |
| Campaigns tab — no campaigns | "No campaigns found. Launch a new ASIN to get started." + Launch New ASIN CTA button |
| KW Config — no keywords | "No keywords configured. Keywords are created when you complete the setup wizard." |

### 9.2 Validation Errors (Wizard)

| Step | Condition | Message |
|---|---|---|
| Step 1 | No product selected | "Next" button is disabled (no toast needed) |
| Step 2 | ASIN format invalid | "ASINs start with 'B' and are 10 characters long." |
| Step 2 | Own ASIN added | "You cannot add your own product as a competitor." |
| Step 2 | Duplicate ASIN | "This ASIN is already in your list." |
| Step 2 | ASIN not found | "ASIN not found on Amazon. Check the ASIN and try again." |
| Step 2 | Max limit (9) reached | "You have reached the maximum of 9 competitors." |
| Step 2 | Fewer than 5 selected | "Next" button disabled with label "Select at least 5 competitors to continue" |
| Step 3 | Research not run | "Next" button disabled until research completes |
| Step 5 | Any validation fails | Checklist shows red × item + "Launch Campaigns" disabled |

---

## 10. Open Questions

The following items require team input before engineering starts.

| # | Question | Options | Owner |
|---|---|---|---|
| 1 | Should the Wizard be a full-page overlay (modal) or a separate page route? | A: Separate page (current design) B: Full-screen overlay modal | PM / Engineering |
| 2 | Should competitor chip show product name or only ASIN? | A: ASIN + product name (requires API call per chip) B: ASIN only (simpler) | PM / UX |
| 3 | Can a seller have multiple in-progress wizard drafts (one per ASIN), or only one draft at a time? | A: One draft per ASIN (multiple allowed) B: One draft total (simplest) | PM |
| 4 | Step 3 Manual Path — is it in scope for this release? | A: Yes (needs full design) B: No — show "Coming soon" | PM |
| 5 | KW Research loading time: up to 2–3 minutes is long for a wizard step. Should the seller be able to leave and come back when done? | A: Yes — email/notification when complete B: No — must wait in wizard | PM / Engineering |
| 6 | Does "Save Draft" also save after each Next button click automatically, or only on explicit button click? | A: Explicit only (current design) B: Auto-save on every step advance | Engineering |
| 7 | Campaign Management: Should the incomplete setup banner stack if multiple ASINs have incomplete setups? | A: Show one at a time (most recent) B: Show all (stack or show count) | PM |
| 8 | KW Research List tab, KW Automation tab, Campaign Config tab — are these in scope for this release? | A: Yes (needs design) B: No — placeholder for now | PM |
| 9 | Tooltip content for INELIGIBLE products — does the system know the reason from SP-API, or is this always a generic message? | A: SP-API returns reason (use it) B: Generic message only | Engineering |
| 10 | Top header Period Selector — does changing the period update only the dashboard metrics, or also the Campaign Management tables? | A: Dashboard only B: Both (all data pages) | PM |

---

*End of Design Specification v1.0*

*Next step: Team review of this spec + prototype → Incorporate feedback → Write APZR Jira stories*
