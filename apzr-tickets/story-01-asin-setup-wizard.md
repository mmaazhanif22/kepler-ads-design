# ASIN Advertising Setup Wizard

## User Story

As a seller, I want a guided step-by-step wizard that walks me through the complete ASIN advertising setup, so that I can configure and launch ad campaigns for any product without needing to understand the full advertising system upfront.

## Problem / Context

- Setting up advertising for a new ASIN requires configuring multiple interdependent settings: product selection, competitor research, keyword research, campaign structure, and launch parameters
- Currently, sellers must navigate multiple disconnected screens to complete a setup, leading to incomplete configurations and support requests
- New sellers especially struggle to understand which settings matter and in what order they should be configured
- There is no guided flow that ensures all required steps are completed before campaigns go live
- Keyword research (Step 3) takes approximately 20 minutes to complete — sellers need to be notified when it finishes so they can leave the page and return later

## Solution Outline

A 6-step wizard overlay that guides the seller through the full ASIN advertising setup process. The wizard opens as a modal dialog over the main portal content.

**Step 1 — Product & Global Settings:**
- Seller selects which ASIN to set up from their product catalog
- Seller sets a Target ACOS (no default value — must be set explicitly)
- Optional: Auto Pacing toggle to automatically pause/resume campaigns based on daily spend targets
- Optional: Bid Ceiling field as a maximum bid safety cap
- Both optional fields clearly labeled as "Optional" or "Conditional"

**Step 2 — Competitor Research:**
- Seller enters competitor ASINs for the selected product
- System validates competitor ASINs exist on the marketplace
- Sellers can add multiple competitors to inform keyword and targeting strategies

**Step 3 — Keyword Research:**
- System automatically triggers keyword research when the seller enters this step
- Animated progress indicator shows research status
- On completion, system auto-advances to Step 4
- Seller does not need to manually trigger research
- **Notification on Completion:** When keyword research finishes, the system adds a notification to the Notification Bell (e.g., "Keyword Research complete for {ASIN} — 156 keywords found. Ready for review.") so the seller is alerted even if they navigated away from the wizard during the ~20-minute research period
- If the seller stays on the wizard, auto-advance to Step 4 still occurs as normal
- If the seller navigated away, they can return to the wizard via the notification or ASIN Overview resume flow

**Step 4 — Keyword Review & Grouping:**
- Seller reviews the keyword research results
- Keywords are organized into logical groups
- Seller can approve, modify, or reject keyword suggestions

**Step 5 — Campaign Configuration:**
- System displays 16 pre-built campaigns in 3 sections:
  - 8 manual keyword campaigns (SPKW)
  - 4 auto-targeting campaigns for Close Match, Loose Match, Substitutes, and Complements (SPAU)
  - 4 product targeting campaigns for competitor brands (SPAS)
- Each campaign row shows: Type, Targeting strategy, keyword count, search volume, and an Optimize toggle
- Campaign names follow the Kepler naming convention and are system-generated (not editable by the seller)
- **Negative Keywords** section is prominently visible below the campaign table (not hidden)
- Negative keyword scope selector: All campaigns, Manual only, Auto only, or Product Targeting only
- Listing Quality Score panel shows a score gauge and per-dimension quality bars

**Step 6 — Launch Summary & Confirmation:**
- No Global Target ACOS field (removed — each campaign inherits its own)
- Launch summary includes Auto Budget and Auto Pacing status
- Pre-launch checklist shows all completed items with green checkmarks
- Optional skipped items (Bid Ceiling, Negative Keywords) shown with amber indicators
- Single "Complete Setup" button to activate campaigns
- After completion, navigation links go directly to Keyword Settings or Search Term Settings

**Wizard Edit Mode:**
- Sellers who have already launched an ASIN can re-enter the wizard to edit specific steps
- An "Edit" button appears next to launched ASINs in the ASIN Config table
- Edit menu offers direct navigation to: Competitors (Step 2), Keywords (Step 4), Campaigns (Step 5), or Launch Settings (Step 6)
- Wizard shows an "Edit Mode" indicator when editing a previously launched ASIN
- All previously saved settings are pre-populated when editing

**Notification Bell Integration:**
- The portal header includes a Notification Bell with a dropdown panel
- Notifications are added dynamically when background processes complete (e.g., KW research)
- Each notification shows: icon, message, timestamp, and unread indicator
- Bell badge shows unread count; "Mark all read" clears all unread indicators
- Notification types: success (green), warning (amber), info (blue), error (red)
- Bell icon pulses briefly when a new notification arrives

**UI Requirements:**
- Mockup: [Prototype — ASIN Setup Wizard](http://localhost:8765/Advertising%20Portal%20UI%20Design.html) (open wizard from sidebar "ASIN Launch")
- Wizard opens as a modal overlay with backdrop
- Progress indicator shows current step and completion status
- "Back" and "Next" navigation between steps
- Discard confirmation when closing wizard with unsaved changes
- Accessible: screen reader announces step changes, focus management on open/close

## Connected Work Items

**Blocks:** Story 5 (Keyword Settings), Story 6 (Search Term Settings) — wizard creates the initial configuration that these views manage
**Is Blocked By:** None — this is the primary entry point for ASIN advertising setup
**Relates To:** Story 2 (IBO) — IBO is the bulk equivalent of this single-ASIN wizard; Story 3 (ASIN Overview) — ASIN Overview provides an alternative entry point to the wizard

✅ The wizard is foundational — it must be delivered before sellers can set up advertising for individual ASINs.

## Implementation Notes

- The wizard must support both "new setup" and "edit existing" modes
- Step 3 auto-research should show real-time progress and auto-advance
- **Step 3 must fire a notification to the Notification Bell when research completes**, so sellers who navigate away during the ~20-minute research window are alerted when results are ready
- Campaign naming follows the Kepler convention: `{Type}H1-SPKW-PB01-{Country}-S-{ASIN}-{Match}-KW`
- Campaign names are read-only in the UI (system-generated)
- The wizard must save progress so sellers can resume if they close it
- Negative Keywords scope selector applies negatives to the selected campaign subset
- Listing Quality Score is calculated from product listing attributes (title, bullets, images, etc.)
- The wizard is for single-ASIN setup only — bulk operations use the IBO (Story 2)

## Out of Scope

- Bulk ASIN setup (covered by Story 2: IBO)
- Post-launch campaign performance monitoring (covered by Story 4: Dashboards)
- Keyword bid adjustments after launch (covered by Story 5: Keyword Settings)
- Search term harvesting and negative keyword management post-launch (covered by Story 6: Search Term Settings)
- Campaign budget pacing (covered by Story 8: Pacing Management)

## Test Cases

- Seller opens wizard, selects an ASIN, and completes all 6 steps successfully — campaigns are created
- Seller sets Target ACOS to 35%, enables Auto Pacing, and sets Bid Ceiling to $3.00 — all values saved
- Seller skips optional Bid Ceiling — Step 6 shows amber indicator for skipped item
- Seller enters Step 3 — research auto-triggers without manual action, progress shows, auto-advances to Step 4
- **Seller navigates away during Step 3 research — notification bell updates with "KW Research complete" when research finishes**
- **Seller clicks the KW Research notification — navigates back to wizard at Step 4 (review)**
- Seller in Step 5 sees 16 campaigns in 3 sections (SPKW, SPAU, SPAS) with correct columns
- Seller adds negative keywords with scope "Auto only" — negatives applied only to auto campaigns
- Seller closes wizard with unsaved changes — discard confirmation appears
- Seller clicks "Edit" on a launched ASIN — wizard opens in edit mode with pre-populated data at the selected step
- Seller navigates back from Step 4 to Step 2 — previous inputs are preserved
- Screen reader user navigates the wizard — step changes are announced, focus is managed

## Acceptance Criteria

- [ ] Wizard provides a 6-step guided flow for complete ASIN advertising setup
- [ ] Step 1 requires explicit Target ACOS (no default) and offers optional Auto Pacing and Bid Ceiling
- [ ] Step 3 auto-triggers keyword research and auto-advances to Step 4 on completion
- [ ] **Step 3 sends a notification to the Notification Bell when keyword research completes**
- [ ] **Seller can navigate away during research and return via the notification when research is done**
- [ ] Step 5 displays 16 campaigns in 3 sections (SPKW, SPAU, SPAS) with campaign type, targeting, and keyword data
- [ ] Negative Keywords are visible below campaigns with scope selector (All/Manual/Auto/PT)
- [ ] Step 6 shows launch summary with checklist, amber indicators for skipped optional items, and no Global Target ACOS
- [ ] Wizard supports edit mode for previously launched ASINs with pre-populated data
- [ ] Discard confirmation appears when closing wizard with unsaved changes
- [ ] Wizard is accessible: focus managed, step changes announced to screen readers
- [ ] All 16 campaign names follow the Kepler naming convention and are not editable
- [ ] Tests passed (unit + integration)
- [ ] UI matches approved mockup
