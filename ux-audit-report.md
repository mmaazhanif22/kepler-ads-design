Now I have everything I need to produce the full, professional audit report:

---

# Kepler Commerce Advertising Portal — Comprehensive UI/UX Audit Report

**Audit Date:** February 27, 2026
**Prototype:** `http://localhost:3399/index.html`
**Auditor:** Senior UX Strategist
**Product Context:** Amazon Seller Advertising Management SaaS — dark theme, data-heavy B2B portal

---

## PHASE 1: HIGH-LEVEL EVALUATION

### UX Maturity Level: Intermediate-Advanced (7.0 / 10)

This is a noticeably thoughtful prototype. The design system is coherent, the domain modeling is sophisticated, and several sections (APDC Diagnostics, Change Log, KWs Config bulk bar) demonstrate genuine product design skill. However, the portal sits at the threshold between "impressive prototype" and "production-ready product" — and there are structural deficiencies at that boundary that will create friction for paying users. The primary gap is not visual polish; it is **interaction contract clarity**: users frequently cannot tell whether their edits are saved, which navigation system to use, or what a button's click radius actually is.

### First Impression Analysis (3-5 second scan)

The Dashboard lands well. Visual weight is distributed correctly: the 6 KPI cards dominate the upper portion, the chart and Action Items panel occupy the middle third in a 2:1 ratio, and the product table anchors the bottom. The orange primary color creates clear wayfinding to primary actions ("New Setup", active nav items). Within 3 seconds a new user correctly identifies that this is a performance monitoring tool.

The immediate problems that emerge at 5 seconds: the Action Items panel places a green "performing" alert at the same visual level as a red "ACOS 38%" critical alert, diluting urgency. The sidebar section labels ("OVERVIEW", "AMAZON ADVERTISING", "DIAGNOSTICS", "TOOLS", "PLATFORM") are extremely small (10px, all-caps) and the hierarchical grouping logic is slightly inconsistent — "Advertising Wizard" being under "Tools" rather than near Campaign Management is cognitively dissonant for first-time users.

### Core Usability Strengths

1. The design token system (`--bg`, `--surface`, `--card`, `--border`, `--primary`) is well-structured and produces a visually cohesive dark theme with appropriate surface elevation.
2. The badge/chip vocabulary (`b-green`, `b-amber`, `b-red`, `acos-good`, `acos-warn`, `acos-bad`) is applied consistently across all tables and produces rapid scannable status at a glance.
3. The APDC Diagnostics view is genuinely excellent product design: layered root cause analysis with a waterfall decomposition panel and recommended actions is best-in-class for this domain.
4. The KWs Config table has a contextual bulk action bar (orange-tinted strip with Pause/Resume/Set Bid operations) that appears when rows are selected — this is the right pattern for power-user bulk operations.
5. The Advertising Setup Wizard's product selection step is clean: the `prod-row` component with radio-dot, thumbnail, ASIN, eligibility badge, and ineligible-state opacity is production-quality.

### Core UX Weaknesses

1. **No save affordance for inline table edits.** Every config table (Campaigns, KWs Config, Campaign Config, ASIN Config) contains inline `<input>` fields for bids, ACOS targets, and budgets. There is no per-row save button, no dirty state indicator, and no visual feedback that an edit has been registered. The only action is a global "Submit" button in the filter bar — with no visual line connecting edited cells to that button.
2. **Dual navigation system creates orientation debt.** The sidebar has sub-items that navigate to specific tabs. The main content area has its own tab bar for the same navigation. These two systems are partially synchronized but the user is never taught which one is authoritative.
3. **The topbar search is non-functional.** The search input at line 573 has no event handler. For a product managing thousands of campaigns, keywords, and search terms, a working global search is a tier-1 user need, not a future enhancement.
4. **23-24 column tables with no frozen columns** create an unusable data grid on any screen under 2560px wide, which is essentially every screen.
5. **Touch/click target accessibility failures** in toggle controls throughout configuration tables.

---

## PHASE 2: STRUCTURED DIMENSIONAL AUDIT

### A. Visual Design and Hierarchy

**Typography**

The type scale is functional but slightly compressed at the dense end. The body text at 14px and table cells at 12px are within acceptable range for a desktop data tool. The `kpi-label` at 11px uppercase with letter-spacing is clean. The problem is the deep nesting of font sizes: some cells reach 9-10px (`font-size:9px` on badges in KWs Config at line 1717) which falls below minimum legible thresholds at standard screen distances. WCAG 1.4.4 requires text to be resizable; 9px rendered text effectively fails this at screen reading distance.

**Spacing**

The `.content` padding of `22px 24px` is consistent across most views. The `.grid-6 mb-4` KPI row uses a 14px gap which is slightly tight for the 6-column layout at 1366px width. The `mb-4` class maps to `margin-bottom:16px` — workable. The issue is **inconsistent spacing between filter bars and tables**: some views use `mb-3` (12px), others `mb-4` (16px), and the Campaign Config tab uses `mb-3` while KWs Config uses `mb-3` plus an additional bulk bar that adds roughly 40px — the distance before table headers varies by up to 60px across tabs, creating visual stuttering when tab-switching.

**Layout**

The sidebar at 240px fixed width leaves 1400px+ content area on a 1440px screen, which is correct for a data-heavy tool. The 2:1 grid ratio on the Dashboard chart/action panel (`grid-template-columns:2fr 1fr`) is well-proportioned. The APDC Diagnostics panel uses `grid-template-columns:1fr 380px` — the fixed 380px right panel is a smart choice here because the waterfall chart needs a stable width.

One layout failure: the ADS Performance view at line 3106 has its `.tab-bar` as the direct first child of the view, with no `.content` wrapper. Every other view wraps content in `<div class="content">` which provides the 22px/24px padding. ADS Performance tabs render flush to the container edge. The tab labels and the content below them lack the consistent left-edge alignment that all other views have.

**Color**

The color system is semantically appropriate: orange for primary/brand, green for success/positive, red for error/high-severity, amber for warning, blue for informational. Contrast ratios for the main text (`#E2E8F0` on `#1A2535`) calculate to approximately 8.5:1 — well above WCAG AA (4.5:1). The muted text `--muted:#6B7E94` on `--card:#1A2535` calculates to approximately 3.4:1, which **fails WCAG AA for normal-weight body text** but passes for large text and UI components. This muted color is used for table cell sub-labels (font-size:11px, normal weight) at multiple locations — this is a contrast failure for body text.

The `acos-chip` colors: `acos-good` renders as `#6EE7B7` on `rgba(16,185,129,.12)` — the light tint background. The effective contrast of that green text on the near-black tinted card background is approximately 5.2:1, passing AA. The `acos-bad` red text on red tint is approximately 4.8:1, marginally passing AA. These are acceptable.

**CTA Prominence**

The primary orange CTA (`btn-primary`) has strong visual weight and is correctly used for the single most important action per context (Launch Campaign, New Setup, Submit for Approval). The secondary button `btn-secondary` with `--card` background and `--border` border is visually quiet — correct for secondary actions. One inconsistency: in the ASIN Config tab (line 1009), "Launch Campaign" is `btn-primary` while the outer Campaign Management toolbar also has a `btn-primary` "Launch Campaign" — two competing orange primaries in the same view creates hierarchy ambiguity.

**Visual Noise**

The KWs Config page (line 1592) adds a 4-card KPI summary row above the filter bar and bulk action bar. This means a user scrolling to the data table must pass: KPI cards, filter bar, bulk action bar, then finally reach the table headers. That is four visual zones of pre-table content on a single tab. For power users who come to this table to do work, this is friction. The KPI cards are informative but their placement above the operational table is debatable.

**Component Consistency**

Most components are consistent. One drift: the "Relevancy Tag" column in Campaign Config (line 1474) uses a bare `<input>` with value "1131" — a numeric code. It is visually identical to a bid input but semantically represents a tag code. There is no tooltip, label clarification, or visual distinction between numeric configuration fields and numeric identifier fields. The "1131" values appear throughout the tables with no explanation of what the number schema means.

### B. Navigation and Information Architecture

**The dual navigation problem is the most structurally significant IA issue in this portal.**

The sidebar has two distinct interaction models running simultaneously:

- Model 1: Top-level nav items (Dashboard, APDC Diagnostics, Advertising Wizard, Reports, etc.) navigate to a full view with no sub-tabs.
- Model 2: Section nav items (Campaign Management, ADS Performance, Logs & Analysis) toggle an accordion of sub-items in the sidebar AND the main content has its own tab bar that duplicates those same sub-items.

When a user clicks "ASIN Dashboard" in the sidebar sub-nav, the ADS Performance view opens with the ASIN Dashboard tab selected. When a user clicks the "ASIN Dashboard" tab in the main content area, it shows the same thing. These two paths lead to identical state. The result: users develop uncertainty about which navigation is authoritative, whether clicking the sidebar item "navigates away" or just "highlights", and whether the tab state persists when they click a sidebar top-level item.

**Recommendation:** Collapse the dual system. Use the sidebar sub-items as the authoritative navigation. Remove the in-page tab bars for Campaign Management and ADS Performance. This reduces cognitive load and eliminates the ambiguity. If tab bars are retained for space efficiency, the sidebar sub-items should become visual echoes (showing active state only) without being independently clickable as navigation.

**Section Label Logic**

The sidebar sections are: Overview, Amazon Advertising, Diagnostics, Tools, Platform. The placement of "Advertising Wizard" under "Tools" rather than under "Amazon Advertising" is wrong. The wizard is the entry point to the entire Campaign Management flow — it is an Amazon Advertising tool, not a generic tool. Users looking for "how do I set up a new campaign?" will scan "Amazon Advertising" and not find a starting point, then eventually find the Wizard under "Tools." This is a classification error.

**Click Depth**

Reaching "SearchTerm Config" requires: sidebar Campaign Management click (expand accordion) + click sub-item. That is 2 clicks from any state. Reaching "Deep Dive" under ADS Performance requires: clicking the collapsed ADS Performance item + clicking Deep Dive. Also 2 clicks. Acceptable.

**Search**

The global search field in the topbar is non-functional (no event handlers). For a portal with potentially thousands of campaigns, keywords, and ASINs, this is a tier-1 user need. An Amazon seller managing 400+ campaigns cannot find a specific campaign without either scrolling paginated tables or using search. The search bar's visual presence creates a false affordance — users will attempt to use it, fail, and form a negative first impression of portal quality.

### C. User Flow and Interaction Design

**Inline Edit Without Save Affordance — The Most Critical Interaction Failure**

The Campaign table, KWs Config, Campaign Config, and ASIN Config tables all render inline `<input>` fields for bid values, ACOS targets, and budgets directly in table cells. A user can click into these fields and change values. However:

- There is no visual "dirty state" indicator (no yellow highlight, no asterisk, no changed-cell styling) to show which cells have been modified
- There is no per-row "Save" or "Apply" button
- The only save mechanism is a global "Submit" button in the filter bar at the top of the page — which is easily scrolled out of view when the table is tall
- There is no confirmation or undo for submitted changes
- The "Submit" button label is the same across Campaigns, KWs Config, Campaign Config, and SearchTerm Config — it does not describe what is being submitted

This pattern violates the most basic contract of form UX: the user must always know how their action will be persisted. The current pattern creates genuine risk: a seller could accidentally type in a bid field, not realize it, scroll away, and later hit "Submit" thinking it submits something else — pushing an incorrect bid to Amazon's API.

**The Wizard — Strong Bones, Missing Handrails**

The Advertising Setup Wizard is well-structured for its domain complexity. Step 1 (product selection) uses a clean radio-selection pattern. The step indicator in the header correctly shows progress (Step 1 of 5, dots with line connectors).

Issues:
- The wizard description text in the step header says "Step 1 of 5" but the system description mentions 6 steps. If there is a KW Review step (step 4 in code: `KW Review`), it is still showing 5 total steps. This needs reconciliation.
- The "Save Draft" button in the wizard footer is present — good — but it has no visual indication of draft state after clicking. After saving a draft, the user needs feedback: "Draft saved · Feb 27, 10:24am" with a timestamp.
- The "Next →" button is correctly disabled until a product is selected. Good.
- The ineligible product row shows opacity reduction which is the right pattern, but the "Product is not eligible" tooltip text needs to be directly visible on hover rather than as a title attribute (which `aria-describedby` would handle properly for screen readers).

**Filter Bars**

The Campaign table filter bar is well-conceived: Search + [All/SP/SB/SD] type chips + 4 dropdowns. The type chips (All, SP, SB, SD) are a well-known pattern for advertising type filtering. The visual issue: "All" is shown as an active/selected chip with `border-color:var(--primary);color:var(--primary)` styling (line 871), but "SP", "SB", "SD" use the default `.btn-secondary` styling. The active state is only applied to "All" in the HTML — if the user clicks "SP", the visual state doesn't change (no JavaScript handler is wired to toggle these states). These are static buttons with no interaction logic.

**Error States and Empty States**

No custom empty states were observed. If all filters return zero results, the table would show an empty `<tbody>` with no guidance. A proper empty state with icon, message ("No campaigns match your filters"), and a "Clear filters" action is missing.

**Form UX in KW Research List**

The "Relevancy Tag" column (line 1162) renders as a free-text `<input>` in each row with placeholder `e.g. 1131`. The user is expected to know the tag schema (1131, 2132, 2231, etc.) without any documentation or dropdown. This is raw data entry with no guardrails — a significant UX risk for data quality.

### D. Accessibility (WCAG 2.1)

**Touch Target Sizes — WCAG 2.5.5 Fail**

Toggles in Campaign Config (line 925), KWs Config (line 1721), SearchTerm Config, and ASIN Config tables are styled with `transform:scale(.8)`. The base toggle is `width:34px; height:19px`. After scaling: `27px × 15px`. This is below the minimum 44×44px touch target (WCAG 2.5.5 AAA) and also below the 24×24px minimum for WCAG 2.5.5 AA in WCAG 2.2. Every toggle in every config table fails this criterion.

**Color Contrast — Partial Fail**

`--muted:#6B7E94` on `--card:#1A2535`: calculated contrast ≈ 3.4:1. Fails WCAG AA for text under 18px normal weight. This color is used for sub-labels in KPI cards, table sub-cells, and timestamp text throughout. Fix: darken muted text to approximately `#8A9CB0` minimum for a card background of `#1A2535` to reach 4.5:1.

The `--dim:#94A3B8` on `--surface:#111827`: approximately 5.1:1. Passes AA.

**Semantic HTML and ARIA**

Tab bars use `<button>` elements with active class toggling — structurally correct HTML but missing ARIA semantics: `role="tablist"` on the container, `role="tab"` on each button, `aria-selected="true/false"`, and `aria-controls` pointing to the corresponding panel. Tab panels need `role="tabpanel"` and `aria-labelledby`. Without these, screen reader users navigate a series of unlabeled buttons with no relationship to their controlled content.

Inline inputs in tables have no associated `<label>` elements. The column header (`<th>`) provides visual context, but screen readers navigating a table cell with an input need an `aria-label` attribute on the input itself. A bid input should carry `aria-label="Bid for back brace lower back pain"` at minimum.

**Keyboard Navigation**

No custom `:focus-visible` styles are defined in the CSS. The browser default focus ring (typically a blue/black outline) will appear in some cases but will be invisible on dark backgrounds in Chrome's current implementation. This makes keyboard navigation effectively non-functional for dark-surface focused elements.

**Heading Hierarchy**

Each view uses `<h2>` for the page title. Within the APDC view, section labels like "Layer 1 — ASIN-Level" use `<div>` with typography styling rather than `<h3>` — this is a heading hierarchy gap.

**Reduced Motion**

The spinner animation (`@keyframes spin`) and the sidebar collapse transitions (`transition:max-height .25s ease`) do not check `prefers-reduced-motion`. For users with vestibular disorders, persistent spinning elements can cause distress.

### E. Conversion and Behavioral Psychology

**Trust Signals**

For a B2B SaaS tool managing real ad spend, the interface currently shows no connection status verification beyond the Settings page badge ("Connected"). An always-visible sync status indicator in the topbar (e.g., "Synced 6h ago" with a dot) would increase trust and answer the implicit question: "Is the data I'm looking at current?"

**CTA Clarity**

The primary onboarding CTA "New Setup" in the topbar opens the Advertising Wizard. The label is acceptable but not ideal — "Set Up Campaign" is clearer for first-time users. "New Setup" could mean account setup, ASIN setup, or campaign setup, which creates a moment of hesitation.

The "Submit" button appears in Campaign tab, KWs Config, Campaign Config, SearchTerm Config, and KWs Research List — always labelled just "Submit" with no qualification of what is being submitted or what happens after submission. "Submit Changes to Amazon" or "Push to Amazon Ads" conveys both the action and the consequence.

**Decision Fatigue**

The KWs Config table exposes 23 columns simultaneously with no way to hide/show columns. Sellers who primarily care about Keyword, Match Type, Bid, and ACOS will have their attention spread across Scope, Campaign, Prev Bid, Bid Delta, Bid Suggest, Ceiling, Floor, Target ACOS, 7d ACOS, 30d ACOS, Spend, Bid Sync Status, System Remarks, User Remarks, Harvested, Status, and an actions column. This is Hick's Law applied to columns rather than choices — the cognitive tax of processing 23 columns reduces the probability that the user spots the 3-4 signals they actually need to act on.

---

## PHASE 3: CRITICAL ISSUES REGISTRY

### 🔴 HIGH-IMPACT (Usability, Revenue, or Accessibility)

**H1 — Inline table edits have no per-row save mechanism and no dirty state**
Location: Campaigns table (line 886), KWs Config (line 1667), Campaign Config (line 1455), ASIN Config (line 1018)
User Impact: Sellers can accidentally modify bid values and submit them to Amazon's API without realizing it, or alternatively lose valid edits because they don't know to click the distant "Submit" button. This is a data integrity risk and a real-money issue — incorrect bids go live on Amazon.
Severity: Critical for production readiness.

**H2 — Global search is non-functional (false affordance)**
Location: Topbar, line 573-574
User Impact: Users attempting to find a specific campaign, keyword, or ASIN by name will fail silently. In a portal with hundreds of campaigns and thousands of keywords, search is the primary navigation tool. Its absence forces users through paginated filtered tables.
Severity: High for user efficiency.

**H3 — Toggle controls scaled below WCAG touch target minimum**
Location: All config tables — lines 925, 944, 963, 982, 1051, 1056, 1075, 1480, 1492, etc.
User Impact: Toggle controls at 27×15px (after scale(.8)) cannot be reliably clicked or tapped on any touchscreen, and are below WCAG 2.5.5 minimum for pointer devices. "Optimize Bid" and "Auto Pacing" toggles being accidentally triggered or impossible to trigger on a laptop trackpad is a direct business risk.
Severity: High (accessibility + functional).

**H4 — ADS Performance view missing `.content` wrapper (layout break)**
Location: Line 3106-3114 — `<div class="view" id="ads-perf-view">` first child is directly `.tab-bar`
User Impact: The ADS Performance section renders its tab bar and all content flush to the container edge, without the consistent 22px/24px padding that every other view has. The page section visually "breaks" compared to all other sections, reducing professional credibility.
Severity: High (visual consistency, easily fixed).

**H5 — Muted text contrast fails WCAG AA for body text**
Location: `--muted:#6B7E94` used throughout for sub-labels, timestamps, and secondary data (lines 134, 158, 301, etc.)
User Impact: Users with low vision or in non-ideal lighting conditions cannot read secondary information. Timestamps, sub-labels on KPI cards, and table metadata are all affected.
Severity: High (accessibility compliance).

**H6 — Tab bar / tab panel ARIA semantics entirely absent**
Location: All tab bars — `.tab-bar` / `.tab-btn` / `.tab-pane` components
User Impact: Screen reader users navigating the portal cannot understand tab structure, switch between tabs, or know which panel corresponds to which tab. This affects the Campaign Management, ADS Performance, Logs & Analysis, APDC, and Settings sections equally.
Severity: High (accessibility compliance).

### 🟡 MEDIUM-PRIORITY (Experience Degradation)

**M1 — 19-24 column tables have no sticky/frozen first column**
Location: Campaigns (19 cols, line 888), KWs Config (23 cols, line 1669), SearchTerm Config (24 cols, line 1994)
User Impact: On any screen under ~2200px wide, horizontal scrolling immediately loses the ASIN/keyword identity column. Users must scroll back left to remember which row they are editing. At 1440px (the modal desktop resolution) the Campaigns table is completely unworkable without column freezing.

**M2 — No column visibility controls on wide tables**
Location: KWs Config, SearchTerm Config, Campaigns table
User Impact: Power users cannot hide irrelevant columns (e.g., hide "Last Sync Off" and "Budget Type" to focus on performance columns). This creates information overload that reduces the signal-to-noise ratio of the most important screens.

**M3 — "Submit" button label ambiguous across all config tables**
Location: Lines 883, 1015, 1127, 1450, 1651
User Impact: Users do not know what "Submit" does, to whom, or what happens after clicking. The same generic label across five different data contexts (campaigns, keywords, research list, etc.) trains users to be uncertain about the action.

**M4 — Action Items panel mixes critical alerts with positive status**
Location: Dashboard, lines 664-698
User Impact: The "B088FZ8TN9 performing (ACOS 18.2%)" success card appears visually equivalent in weight to "B088FYX5R7 ACOS 38% — Above 30% threshold." Mixing green positives with red criticals in an "Action Items" panel teaches users to scan everything, diluting urgency for the items that actually require intervention.

**M5 — Dual navigation: sidebar sub-items and in-page tab bars duplicate each other**
Location: Sidebar (lines 457-491) + Campaign Management tab bar (line 829) + ADS Performance tab bar (line 3107)
User Impact: Users develop navigation uncertainty. When they return to a sub-section they previously visited, they may use either navigation mechanism and wonder if they are in the same place or a different one.

**M6 — Advertising Wizard misclassified under "Tools" in sidebar**
Location: Sidebar section, line 509-515
User Impact: New users setting up their first campaign look under "Amazon Advertising" for an entry point. Finding "Campaign Management" with sub-items that assume existing campaign data, then eventually discovering "Advertising Wizard" under "Tools," adds unnecessary discovery friction.

**M7 — Filter type chips (All/SP/SB/SD) have no interactive state logic**
Location: Campaign filter bar, lines 871-875
User Impact: Clicking "SP", "SB", or "SD" does not visually acknowledge the click — the chip does not change to active state. Users are unsure if the filter was applied or not.

**M8 — The "Relevancy Tag" column requires knowledge of an unexplained numeric schema**
Location: KWs Research List (line 1162), Campaign Config (line 1474)
User Impact: Users see values like "1131", "2132", "3341" in input fields with no documentation, dropdown, or tooltip explaining the schema. Sellers setting up campaigns without understanding this schema will enter incorrect values, corrupting the campaign naming and targeting logic.

**M9 — KPI cards on ADS Performance use in-card combobox selectors for metric choice**
Location: Lines 3139-3173 (5 KPI cards each with a `<select>` inside)
User Impact: Placing a dropdown selector inside a KPI card to change which metric is displayed is unusual interaction design. It adds visual complexity inside each card, makes it harder to read the metric name (it is now a dropdown, not a static label), and removes the at-a-glance benefit of KPI cards. It also means the default view of 5 cards shows "Ad Spend", "Ad Sales", "ACOS", "Orders", "TACoS" — but the user's preferred view might be different and has no persistence.

**M10 — Wizard close button (X) has no visible label and extremely small click target**
Location: Line ~704 — the close button is a bare `<button>` with an SVG icon
User Impact: The wizard X button is approximately 24×24px. There is no `aria-label="Close wizard"` on it. Keyboard users navigating the wizard cannot identify this element.

### 🟢 LOW-PRIORITY (Polish and Professional Impression)

**L1 — Emoji product thumbnails in Dashboard and Wizard**
The `.thumb` cells use 🦴, 🧘, 📦 as product image placeholders. These are fine for prototyping but need a consistent image placeholder (grey box with product initials or a camera icon) for the production path where product images will be loaded.

**L2 — Pacing bar in Campaigns table is visually ambiguous**
The progress bar in the "Pacing" column (line 926) shows a red bar at 85% and a green bar at 62%. The color encoding (red = bad pacing, green = good) is not documented anywhere in the UI. A tooltip on hover explaining "Pacing shows budget consumed so far today as % of daily limit" would eliminate the guessing.

**L3 — "Save Draft" in Wizard footer has no saved state feedback**
Location: Line 749 — "Save Draft" button with a floppy-disk icon
After clicking, there is no feedback: no timestamp, no success toast, no visual state change on the button. Users cannot verify whether their draft was saved.

**L4 — Caret on `nav-item-caret` does not rotate on currently open sections**
The "Campaign Management" section is open by default and has a caret that should point upward. The `.nav-item.nav-collapsed .nav-item-caret { transform:rotate(-90deg); }` rule only rotates for collapsed items — the default open state shows a downward caret, which means open and "pointing down to open" are visually the same. This removes the caret's directional value as an affordance.

**L5 — "APDC Diagnostics" badge "3 RCs" in sidebar partially overlaps with caret**
Location: Lines 497-498 — `<span class="badge b-red" style="font-size:9px">3 RCs</span>` followed by the caret SVG
The badge and the caret compete for the same right-margin space in the nav item. The layout works at default sidebar width but is tight and could clip at any system zoom level above 100%.

**L6 — KWs Automation "Listing Attributes" drag handles are non-functional**
The Braille unicode character `⠿` is used as a drag handle on line 1320 and others. There is no drag-and-drop JavaScript implementation. The handle renders but the rows are not draggable. For a prototype, this is acceptable, but the cursor changes to `grab` via inline style, creating a false affordance.

**L7 — Inconsistent heading approach between views**
Some views use `<h2 style="font-size:16px;font-weight:700">` (Dashboard, Campaign Management, APDC). The Settings view uses `<h2 style="font-size:16px;font-weight:700">` inline. The ADS Performance view has no `<h2>` at all (tabs only). This inconsistency will accumulate as the product grows.

**L8 — The "Complete Setup" CTA for Draft ASIN in Dashboard table uses `btn-primary` orange**
The Dashboard product table (line 790) renders a bright orange "Complete Setup" button for the draft ASIN. This is correct call-to-action prominence. However the "View" and "Edit" buttons for Active ASINs are `btn-ghost` and `btn-secondary` — the contrast between active ASIN actions (near invisible) and draft ASIN actions (loud orange) is jarring visually and arguably inverts the priority: active campaigns deserve at least secondary-weight action buttons.

---

## PHASE 4: SPECIFIC IMPROVEMENT RECOMMENDATIONS

---

```
ISSUE: Inline table edits have no save mechanism or dirty state
LOCATION: Campaigns table, KWs Config, Campaign Config, ASIN Config — all config tabs
PROBLEM: The fundamental form contract (edit → confirm → persist) is broken.
  Users can modify bids and ACOS targets with no visual confirmation,
  no dirty state, and no per-row submit. The distant global "Submit" button
  has no connection to the edited cells.
SOLUTION: Implement one of two patterns:
  Pattern A (Optimistic inline with row-level save):
    When any input in a row is changed, apply a 2px left border in
    --warning color to the row, add a small "Save" chip at the row's
    right edge, and dim the row slightly. The global "Submit" button
    changes to "Submit N changes" with a count badge. Clicking per-row
    "Save" persists that row; clicking global "Submit" submits all dirty rows.
  Pattern B (Edit mode):
    Add an "Edit" button per row (or make row click-to-select). Selecting a
    row opens a flyout panel or an inline expansion where all editable fields
    are grouped with a single "Save Row" button. This is cleaner for tables
    with many editable fields.
  For prototyping priority, Pattern A requires less structural change.
IMPROVED STRUCTURE: Row with dirty input → left border amber 2px, background
  rgba(245,158,11,.04), "1 change" chip at right. Global Submit → "Submit
  3 Changes to Amazon Ads". After submit → success toast with undo link.
PRIORITY: Critical
EFFORT: Moderate (requires JS state tracking per row)
```

---

```
ISSUE: Global search is non-functional (false affordance)
LOCATION: Topbar, line 573 — <input class="input" placeholder="Search anything…">
PROBLEM: The search bar has no event handlers. Users who rely on global search
  (a fundamental pattern for data-heavy B2B tools) will attempt to search,
  fail silently, and lose trust in the portal's capability. For a tool managing
  thousands of keywords and campaigns, global search is not optional.
SOLUTION: Implement a command-palette style search overlay:
  - On focus or Cmd/Ctrl+K keypress, expand a floating modal centered on screen
  - Search across: Campaign names, ASINs, Keywords, Search Terms
  - Show results grouped by type: "2 Campaigns · 5 Keywords · 1 ASIN"
  - Each result shows a type badge and a breadcrumb (Campaign > Keyword)
  - On selection, navigate to the relevant view with the item highlighted/filtered
IMPROVED STRUCTURE: Topbar search input → on focus opens centered overlay
  (width:640px) with scoped result groups, keyboard-navigable, Esc to close.
  Topbar input shows "Search or press ⌘K" placeholder.
PRIORITY: High
EFFORT: Significant (requires index + overlay component)
```

---

```
ISSUE: Toggle controls fail WCAG 2.5.5 touch target minimum
LOCATION: All config tables — transform:scale(.8) on .toggle elements
  (lines 925, 944, 963, 982, 1051, 1056, 1075, 1480, 1721, etc.)
PROBLEM: The base toggle is 34×19px. After scale(.8): 27×15px.
  WCAG 2.5.5 AA requires 24×24px minimum. The toggle at 15px height fails.
  Table density is the reason — the cell height is ~36px and the toggle
  needs to fit. The problem is CSS scale, which shrinks the visual element
  but not its hit area in some browsers (scale does affect layout in most
  modern implementations, making the hit area smaller too).
SOLUTION: Remove transform:scale(.8) from all toggle instances.
  Instead, modify the .toggle base class to a smaller default size
  appropriate for table use: width:28px; height:16px with a ::after
  knob of width:10px;height:10px;top:3px;left:3px and translateX(12px)
  for the on state. Add a 4px invisible padding around the toggle container
  to ensure the interactive hit area meets 24×24px minimum.
IMPROVED STRUCTURE: .toggle-sm { width:28px; height:16px; } with a 
  wrapper <div style="padding:4px;display:inline-flex"> giving effective
  36×24px hit area. Remove all transform:scale() usage.
PRIORITY: High (accessibility)
EFFORT: Quick fix (CSS only)
```

---

```
ISSUE: ADS Performance view missing .content wrapper (layout break)
LOCATION: Line 3106 — <div class="view" id="ads-perf-view"> directly contains .tab-bar
PROBLEM: Every other view wraps its content in <div class="content"> which
  applies padding:22px 24px. ADS Performance renders its tab bar and all 
  content flush to the left edge — 0px left padding. This is visually
  jarring and breaks the consistent left-edge alignment of the entire portal.
SOLUTION: Wrap the inner content of ads-perf-view in a <div class="content">
  exactly as Dashboard, Campaign Management, APDC, and Settings do. The tab
  bar should sit inside that wrapper.
IMPROVED STRUCTURE:
  <div class="view" id="ads-perf-view">
    <div class="content">
      <div class="tab-bar">...</div>
      <div class="tab-pane">...</div>
    </div>
  </div>
PRIORITY: High
EFFORT: 2 lines of HTML (trivial)
```

---

```
ISSUE: Muted text contrast fails WCAG AA
LOCATION: --muted:#6B7E94 used throughout on --card:#1A2535 backgrounds
  (kpi-label, asin-code, card-sub, sidebar section-label, table timestamp cells)
PROBLEM: Calculated contrast of #6B7E94 on #1A2535 ≈ 3.4:1. WCAG AA
  requires 4.5:1 for normal text under 18px. Sub-labels on KPI cards,
  ASIN sub-labels in product cells, and timestamps all fail this.
SOLUTION: Increase --muted to #8BA3B8 (calculated contrast on #1A2535 ≈ 4.8:1).
  This still reads as "secondary/muted" against the primary text color #E2E8F0
  while meeting WCAG AA. Update the CSS variable — the change propagates
  everywhere automatically.
IMPROVED STRUCTURE: :root { --muted: #8BA3B8; }
  Test: secondary text on cards, sidebar section labels, table footnotes,
  and KPI sub-labels will all gain sufficient contrast.
PRIORITY: High (accessibility)
EFFORT: 1 line of CSS
```

---

```
ISSUE: Tab bars missing ARIA role, aria-selected, and tabpanel semantics
LOCATION: All .tab-bar / .tab-btn / .tab-pane instances throughout portal
PROBLEM: Screen reader users cannot identify tab navigation, switch between
  tabs using arrow keys (standard tab widget keyboard pattern), or know
  which panel corresponds to which tab.
SOLUTION: Apply ARIA tab widget pattern:
  - Add role="tablist" to .tab-bar
  - Add role="tab" aria-selected="true/false" aria-controls="pane-id"
    to each .tab-btn
  - Add role="tabpanel" aria-labelledby="tab-id" tabindex="0"
    to each .tab-pane
  - JavaScript should manage aria-selected on tab switch alongside
    the existing active class toggle
  - Add keyboard support: left/right arrow keys move focus between tabs,
    Enter/Space activates focused tab
IMPROVED STRUCTURE (example):
  <div class="tab-bar" role="tablist">
    <button class="tab-btn active" role="tab" aria-selected="true"
      aria-controls="pane-campaigns" id="tab-campaigns">Campaigns</button>
  </div>
  <div class="tab-pane active" id="pane-campaigns"
    role="tabpanel" aria-labelledby="tab-campaigns" tabindex="0">
PRIORITY: High (accessibility compliance)
EFFORT: Moderate (JS + HTML attribute additions)
```

---

```
ISSUE: No sticky/frozen first column on wide tables
LOCATION: Campaigns (19 cols), KWs Config (23 cols), SearchTerm Config (24 cols)
PROBLEM: On a 1440px screen, horizontal scrolling in KWs Config immediately
  hides the Keyword column (the most important identifier column). Users
  lose context of which row they are editing within 1-2 columns of scrolling.
SOLUTION: Apply CSS position:sticky to the first 1-2 columns:
  thead th:first-child, tbody td:first-child {
    position: sticky;
    left: 0;
    background: var(--surface); /* thead */
    z-index: 2;
  }
  For tables with checkbox + name column, freeze the first 2:
  thead th:nth-child(2), tbody td:nth-child(2) {
    position: sticky;
    left: 36px; /* width of checkbox column */
    background: var(--card);
    z-index: 2;
  }
  Add a subtle right border (border-right:1px solid var(--border)) to the
  frozen column to visually separate it from scrolling content.
IMPROVED STRUCTURE: The keyword/ASIN/campaign name column remains visible
  at all horizontal scroll positions. Users always know which row they are on.
PRIORITY: Medium-High
EFFORT: Quick fix (CSS only, ~10 lines)
```

---

```
ISSUE: "Submit" button label is semantically empty across all config tables
LOCATION: Lines 883, 1015, 1127, 1450, 1651 — generic "Submit" buttons
PROBLEM: "Submit" describes the mechanism, not the outcome. Sellers using
  a tool that talks to Amazon's advertising API need to understand that
  clicking this button pushes changes to live campaigns.
SOLUTION: Rename based on context:
  - Campaigns table: "Push to Amazon Ads" or "Submit Changes (N)"
  - KWs Config: "Submit Bid Changes"
  - Campaign Config: "Submit Config Changes"
  - KWs Research List: "Save to Research List"
  - SearchTerm Config: "Submit ST Changes"
  Additionally, add a confirmation step for destructive or large-batch
  submissions: "You are about to push 8 bid changes to Amazon. Continue?"
PRIORITY: Medium
EFFORT: Quick fix (label text + optional confirmation modal)
```

---

```
ISSUE: Action Items panel conflates positive status with urgent alerts
LOCATION: Dashboard Action Items card, lines 691-697
PROBLEM: "B088FZ8TN9 performing — ACOS 18.2% below 20% target" is a positive
  status item. It appears in the same panel with the same card weight as
  two red critical alerts and one info alert. The panel is labelled "4 urgent."
  Including a positive status item in an "urgent" panel dilutes urgency and
  teaches users to scan everything — including non-actionable items.
SOLUTION: Separate action items from status updates:
  - Keep Action Items panel for items requiring action: ACOS above threshold,
    campaigns paused, sync failures, budget depletion — items where the user
    must DO something.
  - Add a separate "Highlights" or "Performance Wins" section (collapsible,
    smaller visual weight) for positive news: strong performers, budget
    efficiency improvements.
  - The badge should change from "4 urgent" to "3 urgent" (excluding the
    positive item).
IMPROVED STRUCTURE: Action Items panel (3 items, all requiring action) +
  small "Highlights" chip row below the chart showing positive signals
  in green with a checkmark. Or add a 5th card to the action items as
  "Performing well" type with lower visual weight (no border tint, just
  a checkmark icon in success green without the alert box styling).
PRIORITY: Medium
EFFORT: Quick fix (restructure one card)
```

---

## PHASE 5: IMPROVED UI/UX DESIGN FRAMEWORK

### Revised Layout Structure

**Dashboard — No major layout changes needed.** The 6-KPI grid, 2:1 chart/actions split, and full-width product table is a solid layout. Refinements: increase the grid gap from 14px to 18px in `.grid-6` to give KPI cards more breathing room at 1440px. The Action Items panel height should be constrained and scrollable (max-height:320px, overflow-y:auto) rather than extending to match the chart height — 4 items that are fully visible without scroll is better than a fixed-height panel.

**Campaign Management — Structural improvement needed.** The current layout stacks: page header + toolbar, tab bar, global settings bar (ACOS/bid config), filter bar, bulk action bar, table. This is 5 zones of chrome before the table. Consolidate:

- Move the Global Target ACOS and Max Bid Limit fields out of a card above the table and into the Settings page (Global Config). These are account-level settings, not per-session filter settings. The current placement implies the user needs to change them frequently — they do not.
- Combine the filter bar and the toolbar (Import/Export/Submit) into a single toolbar row. The filter bar left, actions right — on one horizontal line.
- Result: page header + toolbar row + tab bar + table. Three zones instead of five.

**Wide Tables — Column Grouping Architecture.** The 23-column KWs Config table should introduce column groups with a toggleable visibility panel:

- Fixed group (always visible): Keyword, Match Type, Scope, Campaign
- Performance group (default visible): Latest Bid, 7d ACOS, 30d ACOS
- Configuration group (default visible): Ceiling, Floor, Target ACOS, Status
- Automation group (collapsible by default): Bid Suggest, Prev Bid, Bid Delta, Bid Sync Status, System Remarks
- Metadata group (collapsible by default): Harvested, User Remarks

A small "Columns" button in the filter bar opens a popover with checkboxes for each group, persisted to localStorage. This reduces the default visible column count from 23 to approximately 12 without removing data availability.

### Better Navigation Model

**Recommendation: Collapse to Single Navigation System.**

Use the sidebar as the sole navigation authority. Remove the in-page horizontal tab bars for Campaign Management and ADS Performance. The sidebar sub-items replace them entirely.

Replace the flat sidebar sub-item list with a slightly structured approach: instead of 7 items under Campaign Management listed as plain text, group them visually:

```
Campaign Management
  Configuration
    Campaigns
    ASIN Config
    Campaign Config
  Keyword Intelligence
    KW Research List
    KWs Config
    KW Automation
  Search Terms
    SearchTerm Config
```

This grouping reduces cognitive load from "7 undifferentiated items" to "3 groups of 2-3 items each" — Miller's Law applied to navigation.

Move "Advertising Wizard" from "Tools" to immediately below "Campaign Management" under a "Get Started" label or as a persistent call-to-action in the sidebar header section for accounts with incomplete setups.

### Component Strategy

**Components to redesign:**
1. Toggle (`toggle`) — remove scale transform, define a stable small-toggle variant at 28×16px with proper touch target wrapper
2. Submit/action buttons — context-aware labels per section
3. Tab bar + tab pane — add full ARIA semantics as a global update
4. Action Items card — split into actionable alerts vs. positive highlights

**Components to consolidate:**
1. The inline-input-with-percentage-unit pattern (`<input>` + `<span>%</span>`) appears in at least 15 locations across tables. Extract this into a `.pct-input` component.
2. The ASIN badge (blue tinted monospace span) appears in ~30 table cells. It should be a formal `.asin-badge` component class rather than an inline style block.

**New components needed:**
1. `DirtyRowIndicator` — left border + subtle background tint + "1 change" chip for tables with inline editing
2. `ColumnVisibilityPanel` — popover with column group checkboxes for dense tables
3. `EmptyTableState` — icon + message + clear-filters action for zero-result filter states
4. `SyncStatusIndicator` — topbar persistent sync status chip with timestamp

### Design System Recommendations

**Token extensions needed:**

```css
:root {
  /* Fix contrast failure */
  --muted: #8BA3B8;  /* was #6B7E94 */
  
  /* Table-specific tokens */
  --table-row-hover: rgba(255,255,255,.025);
  --table-row-dirty: rgba(245,158,11,.05);
  --table-row-dirty-border: #F59E0B;
  --table-row-error: rgba(239,68,68,.05);
  --table-frozen-shadow: 4px 0 8px rgba(0,0,0,.25);
  
  /* Touch target enforcement */
  --touch-target-min: 44px;
  --toggle-height-table: 16px;
  --toggle-width-table: 28px;
  
  /* Focus ring */
  --focus-ring: 0 0 0 2px #F97316;
}

/* Global focus-visible rule — add to base styles */
*:focus-visible {
  outline: none;
  box-shadow: var(--focus-ring);
}
```

**Component naming:** The current naming is partially class-based (`.kpi`, `.badge`, `.btn`) and partially inline-style-based (dozens of `style="..."` in table cells). The design system should formalize all table cell variants as CSS classes:
- `.cell-asin` — for the ASIN badge pattern
- `.cell-bid` — for bid input cells
- `.cell-pct` — for percentage input + unit cells
- `.cell-actions` — for action button groups

### UX Pattern Alignment

**Pattern: Inline Table Editing with Save Protocol (Notion, Airtable model)**
When any cell is modified, the table row enters "dirty" state. A floating action bar appears at the bottom of the viewport (sticky) showing "N unsaved changes · Submit to Amazon Ads · Discard". This pattern ensures the submit affordance is always visible regardless of scroll position, and makes the consequences of clicking Submit clear.

**Pattern: Progressive Disclosure for Complex Tables (Salesforce Lightning model)**
For the 24-column SearchTerm Config table, use row expansion. The table shows 6-8 key columns by default. Each row has an expand chevron. Clicking expand shows all remaining columns in a horizontal sub-panel below the row. This dramatically reduces initial cognitive load while preserving full data access.

**Pattern: Contextual Panel for Row Details (Linear, GitHub model)**
For KWs Config, clicking a row opens a right-side panel (400px, sliding in) showing the full keyword detail: all fields, bid history chart, performance trend, system notes. The main table retains its position (no navigation). This makes the table read-only (no inline editing) and moves all editing into the focused panel — solving the dirty state problem cleanly.

**Pattern: Command Palette (Linear, Vercel model)**
Cmd/Ctrl+K opens a global command overlay with search across campaigns, keywords, ASINs, and actions. This replaces the non-functional search bar with a genuinely useful power-user tool. Placeholder: "Search campaigns, keywords, ASINs…". Results show with breadcrumb context and keyboard navigation.

### Scalability Plan

As the product grows to multiple seller accounts, multiple marketplaces (CA, US, UK, MX), and hundreds of campaigns per account, the following architectural investments protect the UX:

1. **Account/marketplace switcher in the topbar** (not just in the sidebar footer). When a seller manages 3+ accounts, they need rapid context switching without losing their current page state.

2. **Saved filter presets** for all config tables. Power users running the same ACOS > 30% filter every day need a "My Filters" dropdown that saves named filter states.

3. **Bulk selection scope control**: when a seller has 400 campaigns, "Select All" in the checkbox column must specify "Select all 12 on this page" vs. "Select all 400 campaigns in this filter set". The distinction matters enormously when bulk-submitting changes.

4. **Notification center** to replace the Dashboard Action Items panel. As the seller grows, action items will outpace 4 items. A dedicated notification tray (bell icon in topbar) with priority levels, read/unread state, and pagination will scale better than a dashboard card.

---

## EXECUTIVE SUMMARY

**For Stakeholders: Key Findings and Recommended Next Steps**

The Kepler Commerce Advertising Portal prototype is at an Intermediate-Advanced level of UX maturity — it is substantially better than average B2B tools at this prototype stage. The design language is coherent, the domain modeling is sophisticated, and several sections (particularly APDC Diagnostics and the Change Log) are production-quality designs.

**The five most critical issues requiring immediate attention before user testing:**

1. **Inline table edits have no save mechanism.** Users can modify bids and budgets with no confirmation that changes will be saved and no clarity on how to submit them. This creates a real risk of incorrect data being pushed to Amazon's advertising API. Fix: add row dirty state indicators and a clearly connected "Submit N changes" button.

2. **The global search bar does nothing.** It is a prominent UI element with no functionality. Remove it or implement it — a non-functional search in a tool managing thousands of records damages trust in the product's quality.

3. **Toggle buttons are too small to click reliably.** The CSS scale transform makes all "Optimize Bid" and "Auto Pacing" controls in the config tables inaccessibly small. One CSS variable change fixes all instances.

4. **Wide tables need sticky first columns.** At 23-24 columns, the identity column (keyword name, ASIN) disappears immediately on horizontal scroll. Users lose context on every row. A 10-line CSS addition fixes this.

5. **ADS Performance has a layout bug** — its content renders without the standard 24px page padding, making it visually inconsistent with every other section. This is a 2-line HTML fix.

**Three quick wins that would immediately increase the prototype's professional credibility:**

- Fix the muted text color from `#6B7E94` to `#8BA3B8` (1 CSS variable, fixes WCAG contrast failure everywhere)
- Add a `<div class="content">` wrapper to the ADS Performance view (2 lines of HTML)
- Rename all "Submit" buttons to context-specific labels: "Submit Bid Changes", "Push to Amazon Ads", etc. (5 text changes)

**The most impactful medium-term investment:** Implement the contextual row-detail panel pattern for KWs Config and SearchTerm Config. This single architectural change eliminates the 23-column problem, the inline edit problem, the dirty state problem, and the column management problem all at once — by moving all editing into a focused panel while keeping the table as a read-only overview.

---

*Audit conducted via full source code review of `C:\Users\fabah\Advertising Product\kepler-ads-design\index.html` (3,400+ lines) and browser inspection of all major views and interactions via Playwright.*
