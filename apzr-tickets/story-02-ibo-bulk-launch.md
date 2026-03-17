# Intelligent Batch Orchestrator (IBO) — Bulk ASIN Launch

## User Story

As a seller with a large catalog, I want to launch advertising campaigns for multiple ASINs simultaneously with AI-powered grouping and unified campaign activation, so that I can scale my advertising setup from one ASIN at a time to dozens in a single workflow.

## Problem / Context

- Sellers with 10+ ASINs cannot practically use the single-ASIN wizard to set up advertising for each product individually
- Different product types within a catalog (e.g., essential oils vs. scented candles vs. car diffusers) require different competitor sets, keyword strategies, and bid configurations
- There is no way to batch-configure campaigns across multiple ASINs while still allowing per-product customization
- Keyword research for many ASINs takes significant time (~20 minutes per batch) — sellers need background processing with progress visibility and notifications when processing completes
- Sellers need to review and approve keyword research results before campaigns go live, but doing this one ASIN at a time is impractical for large batches
- Sellers should be able to start reviewing completed ASINs while others are still processing, rather than waiting for the entire batch to finish
- With 50+ ASINs, sellers cannot manually select competitor ASINs for each product — competitor discovery must be automatic with the option to review and override

## Solution Outline

A 6-stage progressive workflow for bulk ASIN launch, accessible from the sidebar under "ASIN Setup > Bulk Launch (IBO)".

**Stage 1 — Mission Setup & AI Grouping:**
- Seller enters a mission name, selects target marketplace, and sets global defaults (bid ceiling, bid strategy, daily budget)
- Seller pastes ASINs (one per line) or imports via CSV/Excel
- Bulk Import zone: drag-and-drop CSV upload with template download for configuring 20+ ASINs
- System validates ASINs and auto-groups them by product type, brand relationship, and price band
- AI Grouping algorithm:
  - Primary clustering by product type and brand (own vs. third-party)
  - Price band splitting when price gaps exceed 2x the group median
  - Size splitting for significantly different physical sizes
  - Bundle/gift set products grouped with their primary component type
  - Singleton groups (fewer than 2 ASINs) merged into the nearest matching group
- Each group card shows: group name, ASIN count, product type, price range, and a plain-language reason explaining why those ASINs were grouped together
- Seller can re-run grouping to get different results
- Campaign structure defaults: match types (Exact/Phrase/Broad), campaign types (NB/OBH/CB), bid strategy, daily budget

**Stage 2 — Per-Group Configuration:**
- Tab selector for each group (e.g., "Aroma Oils (4)", "Scented Candles (4)")
- **Tier 1 — Auto-Suggested Category Competitors (shared across group):**
  - System automatically discovers and pre-populates top category competitors based on the group's product type, subcategory, and price band
  - Each group tab switch auto-fills the Tier 1 competitor textarea with suggested ASINs
  - Competitor labels shown below the textarea (ASIN + product name) for easy identification
  - "Auto-populated" badge confirms suggestions were loaded automatically
  - Seller can review, add, or remove competitors — defaults are fully editable
  - "Re-Discover" button refreshes suggestions (e.g., after changing group composition)
  - "Validate" button confirms ASINs exist on the marketplace
- Campaign skeleton: per-group overrides for Target ACOS, daily budget, bid strategy
- **Tier 2 — Auto-Suggested Per-ASIN Variant Competitors:**
  - System automatically identifies and pre-fills direct competitors for each individual ASIN based on similar products, same subcategory, similar price point, and "customers also viewed" data
  - Each ASIN row in the variant table comes pre-populated with 2–5 suggested competitor ASINs
  - "Auto-suggested" label shown under pre-filled fields for clarity
  - Seller can override any individual ASIN's competitors if needed, but the default is fully automatic
  - For 50+ ASINs, sellers review group-level competitors per tab (~2 min total), and only drill into per-ASIN competitors when specific overrides are needed
- Variant table shows: ASIN, product name, variant attribute, Tier 2 competitors (pre-filled), Target ACOS override, bid ceiling override, status
- **KW Research Approval Mode** toggle:
  - ON (Auto-Approve): keyword research results automatically approved — skips Stage 4
  - OFF (Manual Review): all ASINs go through Stage 4 review hub for approval
  - Dynamic info text explains the selected mode

**Stage 3 — Async Parallel Processing:**
- Summary stats: Total ASINs, Completed, In Progress, Queued, Estimated Time Remaining
- Per-ASIN progress cards showing real-time status progression: Queued → Researching → Grouping → Building Campaigns → Done
- Each card updates progressively as processing advances — multiple ASINs process concurrently (up to 3 in parallel)
- Activity log stream with timestamped entries for each processing event (e.g., "10:23:45 — B09L4KWX6Q: Keyword research started", "10:24:12 — B09L4KWX6Q: 156 keywords found, grouping...")
- Stats boxes update in real-time as ASINs move through processing states
- **"Review Completed ASINs" button** appears after the first ASIN reaches "Done" status — shows count of ready ASINs (e.g., "Review Completed ASINs (3 ready)"). Clicking advances to Stage 4 with only completed ASINs shown; still-processing ASINs appear with a "Processing..." badge in the Stage 4 table
- **"All Processing Complete" banner** appears when every ASIN finishes — green success banner confirming all ASINs are ready for review
- **Notification on Completion:** When all ASINs finish processing, the system adds a notification to the Notification Bell (e.g., "IBO Processing complete — all 12 ASINs ready for review. Proceed to Review Hub.") so the seller is alerted even if they navigated away during the processing period
- Seller can pause processing or proceed to review at any time

**Stage 4 — Review Hub:**
- Stats: Auto-Approved count, Needs Review count, Still Processing count, Errors count
- Filter tabs: All, Needs Review, Auto-Approved, Processing
- Review table: ASIN, product name, group, keywords, KW groups, campaigns, status, actions
- Seller reviews keyword research results and approves or rejects ASINs
- ASINs needing review have Quick Review and Approve buttons
- **Still-processing ASINs** (from partial Stage 4 access) shown with "Processing..." badge — they update to reviewable status as processing completes
- **Bulk Actions toolbar:**
  - Export Review Spreadsheet: downloads CSV with all ASINs and their keyword data for offline review
  - Import Reviewed Spreadsheet: upload edited CSV back to apply changes
  - Approve Selected: bulk-approve all selected ASINs with a confirmation dialog

**Stage 5 — Campaign Configuration:**
- NB/OBH/CB color-coded campaign rows
- Campaign skeleton summary (shared defaults)
- Campaign table: ASIN, campaign name (Kepler convention, locked/not editable), type, match, targeting spec, brand, keywords, budget, Target ACOS, status, outlier flag
- New columns matching portal: Targeting Spec, Brand, Status
- Outlier campaigns flagged with warning indicator
- Bulk Edit and Export CSV controls
- **Negative Keywords** card below the table — applies negatives across the entire batch
- Scope selector: All campaigns, Manual only, Auto only, Product Targeting only

**Stage 6 — Launch Confirmation:**
- Single confirmation page (not a phased launch)
- Summary stats: Total ASINs, Total Campaigns, Total Daily Budget, Average Target ACOS, Bid Strategy
- Pre-launch checklist with green checkmarks for completed items
- Optional skipped items shown with amber indicators (e.g., negative keywords not added, bid ceiling not set)
- One ASIN summary table covering all products: ASIN, product name, group, campaigns, budget, Target ACOS, status
- Single "Launch All Campaigns" button with confirmation dialog
- Launch date picker

**Batch History & Resume:**
- Saved Batches section at the top of the IBO view with batch count badge
- Auto-saves progress after each stage transition
- Each saved batch shows stage progress dots and "Edit Stage N" buttons
- Seller can resume any saved batch or delete old ones
- "Start New Launch" resets to a fresh IBO flow

**UI Requirements:**
- Mockup: [Prototype — IBO](http://localhost:8765/Advertising%20Portal%20UI%20Design.html) (navigate to ASIN Setup > Bulk Launch IBO)
- 6-stage progress bar at top with numbered steps and completion states
- Each stage is a full panel — only one active at a time
- Back/Next navigation between stages
- Stage locking: cannot skip ahead to uncompleted stages

## Connected Work Items

**Blocks:** None directly — IBO is an alternative path to campaign creation
**Is Blocked By:** None — IBO is independent of the single-ASIN wizard
**Relates To:** Story 1 (Wizard) — IBO is the bulk equivalent; Story 3 (ASIN Overview) — provides entry point; Story 5 (KW Settings), Story 6 (ST Settings) — post-launch management

✅ IBO can be developed in parallel with the single-ASIN wizard. They share the same campaign naming convention and output format but are independent workflows.

## Implementation Notes

- AI Grouping algorithm uses product catalog data (product type, brand, price, size) to determine groups
- Campaign naming follows Kepler convention: NB=`NBH1-SPKW-PB01-{Country}-S-{ASIN}-{Match}-KW`, OBH=`OBH1-...`, CB=`CBR1-...`
- **Stage 2 Tier 1 competitors must be auto-populated** from marketplace/category data when a group tab is selected — sellers should not start from an empty textarea for 50+ ASINs
- **Stage 2 Tier 2 per-ASIN competitors must be auto-suggested** based on similar products, subcategory, price point, and Amazon "customers also viewed" data — each ASIN row comes pre-filled with 2–5 suggestions
- The seller's role shifts from "enter competitors" to "review suggested competitors" — same review-first pattern used for KW Research
- "Re-Discover" button allows refreshing competitor suggestions after group changes
- Stage 3 processing should use background jobs with real-time status updates
- **Stage 3 must fire a notification to the Notification Bell when all ASINs finish processing**, so sellers who navigate away during the processing window are alerted when results are ready
- **Stage 3 should allow partial Stage 4 access** — a "Review Completed ASINs" button appears as soon as the first ASIN completes, letting sellers start reviewing without waiting for the entire batch
- **Stage 3 should show an "All Processing Complete" banner** when every ASIN finishes, providing a clear visual signal that the batch is ready
- Stage 4 review hub allows sellers to review and approve keyword research results before campaign configuration
- Bulk approval via CSV export/import must preserve all ASIN data and keyword modifications
- Batch history should persist across sessions
- The IBO output (campaigns) must match the same format as single-ASIN wizard output

## Out of Scope

- Single-ASIN setup (covered by Story 1: Wizard)
- Post-launch campaign monitoring and optimization (covered by Stories 4, 5, 6, 8)
- Marketplace expansion (launching same ASINs on multiple marketplaces simultaneously)
- Automated scheduling of recurring batch launches

## Test Cases

- Seller pastes 12 ASINs, clicks Validate & Group — system produces 4 logical groups with reasons
- Seller imports CSV with 25 ASINs — system validates format, loads data, and groups
- Bundle product (gift set) is grouped with its primary component type, not isolated
- Seller switches between group tabs in Stage 2 — each group shows correct ASINs and variant data
- **Seller enters Stage 2 — Tier 1 category competitors are auto-populated with marketplace suggestions (not empty)**
- **Seller switches group tab — Tier 1 competitors update automatically for the new group's product type**
- **Seller views Tier 2 variant table — each ASIN row has pre-filled competitor ASINs with "Auto-suggested" label**
- **Seller with 50 ASINs — all competitors pre-populated, seller only reviews/overrides without manual entry**
- **Seller clicks Re-Discover — competitor suggestions refresh for the current group**
- Auto-Approve ON — after processing, ASINs skip Stage 4 and go directly to Stage 5
- Auto-Approve OFF — ASINs appear in Review Hub for manual approval
- **Stage 3: ASINs process progressively with real-time card updates (Queued → Researching → Grouping → Building → Done)**
- **Stage 3: Stats boxes update in real-time (Completed, In Progress, Queued counts)**
- **Stage 3: Activity log shows timestamped entries for each processing event**
- **Stage 3: "Review Completed ASINs" button appears after first ASIN finishes — shows ready count**
- **Stage 3: When all ASINs complete, "All Processing Complete" banner appears and Notification Bell receives alert**
- **Seller navigates away during Stage 3 processing — notification bell updates with "IBO Processing complete" when all ASINs finish**
- Seller exports review spreadsheet, edits offline, imports back — changes reflected in review table
- Seller bulk-approves 10 ASINs — confirmation dialog shows count, status updates to Approved
- Stage 5 shows campaigns with Kepler naming convention, locked campaign names, and negative keywords
- Stage 6 shows single Launch All button with pre-launch checklist and summary table
- Seller saves batch, closes browser, returns later — batch is in Saved Batches, can resume at last stage
- Seller re-runs grouping — groups may change based on updated algorithm pass

## Acceptance Criteria

- [ ] 6-stage progressive workflow guides sellers through bulk ASIN launch
- [ ] AI Grouping produces logical groups based on product type, price band, and brand relationship
- [ ] Grouping handles edge cases: bundles, singletons, price outliers, mixed sizes
- [ ] Each group card shows plain-language reason for the grouping
- [ ] Stage 2 supports per-group and per-ASIN configuration with Tier 1/Tier 2 competitors
- [ ] **Stage 2 Tier 1 competitors are auto-populated from marketplace data when group tab is selected**
- [ ] **Stage 2 Tier 2 per-ASIN competitors are auto-suggested with 2–5 competitor ASINs per product**
- [ ] **Seller can review, edit, or override auto-suggested competitors at both tiers**
- [ ] KW Research Approval Mode toggle controls whether ASINs go through manual review
- [ ] Stage 3 shows real-time processing progress for all ASINs with progressive card state updates
- [ ] **Stage 3 fires a Notification Bell alert when all ASINs finish processing**
- [ ] **Stage 3 shows "Review Completed ASINs" button after first ASIN completes for partial Stage 4 access**
- [ ] **Stage 3 shows "All Processing Complete" banner when every ASIN finishes**
- [ ] Stage 4 Review Hub supports bulk actions: export/import spreadsheet and bulk approve
- [ ] Stage 5 campaign names follow Kepler convention and are not editable
- [ ] Stage 6 provides single Launch All Campaigns with pre-launch checklist
- [ ] Batch history persists across sessions with resume capability
- [ ] Bulk CSV import supports 20+ ASINs with template download
- [ ] Tests passed (unit + integration)
- [ ] UI matches approved mockup
