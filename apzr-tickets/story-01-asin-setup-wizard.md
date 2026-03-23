# ASIN Advertising Setup Wizard

# User Story

As a seller, I want the existing campaign wizard restructured into a clearer 5-step flow so that each step has a single focus and the setup process is easier to follow.

# Problem / Context

The portal has a 4-step campaign wizard that handles product selection, competitor entry, keyword research, keyword automation, and campaign configuration ([current wizard with 4-step bar and bundled sub-steps](https://drive.google.com/file/d/1K8PouADDPepnCFODM5kV4DLlii2UfQSa/view)). The current design has several limitations:

- Step 1 bundles product selection and competitor entry together, making it too complex for the first screen a seller sees. Two distinct tasks compete for attention on one page.
- There is no notification when keyword research completes, so sellers must keep checking back manually.
- If the browser closes mid-setup, all progress is lost. There is no way to resume a partially completed wizard.
- There is no summary or launch step before campaigns go live. Sellers activate campaigns without a final review of the full picture (total budget commitment, keyword count, optimization settings).
- The wizard is a routed page, not a modal overlay, so navigating away destroys the context.

# Solution Outline

Restructure the wizard from 4 steps to 5 steps, with each step focused on a single task. Change the wizard from a routed page to a modal overlay that preserves context.

**Step 1 - Product Selection** ([current](https://drive.google.com/file/d/1K8PouADDPepnCFODM5kV4DLlii2UfQSa/view) | [target](https://drive.google.com/file/d/1hjYk7pCK10elSUxyg5woOmjb7VcHDB3q/view))**.** This step remains the product selection table as it exists today, with the search bar, radio select, SP Status column, "Show all products" toggle, and pagination. The competitor entry that currently lives in this step moves to its own dedicated Step 2. A warning banner is added that appears when the seller selects a product that already has active campaigns.

**Step 2 - Competitor Research** ([current](https://drive.google.com/file/d/16FJGxTUpWhKOKWeirphFC89TCvmKCspe/view) | [target](https://drive.google.com/file/d/1gTylNSOsBrlVwNK_7ACyne5rlOcGLDXE/view))**.** This becomes its own step, separated from product selection. The existing manual ASIN entry, AI-Powered Discovery, and competitor tiles (showing image, price, reviews, and ratings) all carry over unchanged. New additions include a relevance score percentage and estimated monthly revenue displayed on each competitor tile, removable chips showing the selected competitors at a glance, a visual progress bar that fills as competitors are added, and "Redo from this step" and "Rediscover" buttons for flexibility.

**Step 3 - Keyword Research** ([target: research options](https://drive.google.com/file/d/1YYMCHkhTwKaA3MeWOPxJv2YeNyf-bvWS/view) | [target: review with KW Automation link](https://drive.google.com/file/d/1r5Spr8wQMMSxgDiyab_ehrsakLM-wrJV/view))**.** This step combines the existing KW Research trigger (current Step 2) and the KW Automation approval tabs (current Step 3) into a single continuous flow within one view.

Sellers can add their own keywords (via textarea or CSV upload) before running research. Two research option cards are presented: "Run AI Research" (recommended, uses the existing keyword fetching pipeline) or "Upload Keyword List" (CSV upload, skips automated research). A progress bar with 4-phase tracking and ETA (~8 minutes) replaces the simple polling indicator. "Cancel Research" and "Close & Notify Me" buttons are added. On completion, a "Review Fetched Keywords" link lets the seller navigate to the KW Research List tab and return to the wizard.

Once fetching completes, AI analysis automatically starts in the same view. The three processing stages (Branding Scope classification, Attributes Ranking, Keyword Grouping) run sequentially with a progress display and ETA (~25-30 min). When analysis finishes, a summary card shows results with a "Review Research Output" button that navigates to the KW Automation tab. The seller reviews and approves the three tabs there. Tab 3 (Grouping) is locked until the seller approves Tab 1 and Tab 2. Once all three are approved and the seller returns, the wizard auto-advances to Step 4.

**Step 4 - Campaign Config** ([current](https://drive.google.com/file/d/1qzMRSaGTOTlmLaErrkQjybEPfW9ZocvH/view) | [target](https://drive.google.com/file/d/1SqFXNcfcnUQEOQgCO4cnaU15XojE_Jy4/view))**.** The existing campaign table (with per-campaign Target ACOS, Daily Budget, Status, and Custom Negative Keywords) remains the core of this step. Three new sections are added around it:

A Defaults & Budget section at the top introduces Match Type Strategy with 5 checkboxes (Exact, Phrase, Broad [paused by default], Auto Targeting, Product Targeting) and an "Apply to All Campaigns" control for Target ACOS % and Daily Budget $.

An ASIN Settings section adds Auto Pacing (OFF by default, manages budget distribution throughout the day) and Auto Budget (OFF by default, adjusts daily budgets automatically based on performance) toggles.

The campaign table itself gains a Simple/Advanced view toggle (Advanced reveals additional columns: KWs, SV Exact, SV Broad, Relevancy, Competition, Suggested Bid, Organic Rank), a Bulk Action Bar that appears when campaigns are selected (Enable, Pause, Set ACOS, Set Budget), and a total daily budget footer. Campaign names continue to follow the existing Kepler naming convention and remain read-only.

**Step 5 - Activate (new)** ([target](https://drive.google.com/file/d/1x5e7DDQ8rG7_agzlOTiIHeRR-HEbZyqh/view))**.** This step does not exist today. It provides a Bid Optimization master toggle with a count display ("X / Y campaigns with Opt ON"), a launch summary with 6 stat cards (Campaigns, Total Daily Budget, Keywords, Opt Bid Enabled count, Auto Budget status, Auto Pacing status), a "Complete Setup & Go to Campaigns" button that triggers the existing campaign creation pipeline, a post-launch tip ("Toggle ads on or off from the Manage Ads page"), and 3 navigation cards linking to Keyword Settings, Search Term Settings, and Manage Ads.

**Navigation and UX improvements.** The wizard changes from a routed page to a modal overlay. "Back to Campaign Management" becomes "Back to Manage Ads". Wizard state persists to localStorage so sellers can resume an incomplete setup. A discard confirmation appears when closing the wizard with unsaved changes. Notification Bell integration (PROD-4390) alerts sellers when Step 3 research completes.

# Connected Work Items

**Blocks:** [PROD-4124](https://keplercommerce.atlassian.net/browse/PROD-4124), [PROD-4125](https://keplercommerce.atlassian.net/browse/PROD-4125)
**Relates To:** [PROD-4121](https://keplercommerce.atlassian.net/browse/PROD-4121) (IBO), [PROD-4122](https://keplercommerce.atlassian.net/browse/PROD-4122) (Manage Ads)

**Related enhancement stories:** [PROD-4390](https://keplercommerce.atlassian.net/browse/PROD-4390) (Notification Bell), [PROD-4391](https://keplercommerce.atlassian.net/browse/PROD-4391) (Wizard Edit Mode), [PROD-4447](https://keplercommerce.atlassian.net/browse/PROD-4447) (Advanced Campaign Features), [PROD-4448](https://keplercommerce.atlassian.net/browse/PROD-4448) (Wizard UX Enhancements).

# Implementation Notes

- Product list comes from existing ASIN configuration data, including SP eligibility status
- Competitors are stored per-ASIN in the existing product config, populated via the existing AI Discovery service
- Keyword research uses the same trigger and status polling pipeline as the current wizard Step 2
- Keyword automation uses the same approval flow as the current wizard Step 3 (three tabs with per-tab approval)
- Campaign data comes from the existing campaign config, same data the Campaign Config tab displays today
- Auto Pacing and Auto Budget are product-level settings in existing config
- Campaign creation uses the existing campaign generation pipeline
- Campaign names are generated by the existing naming convention logic
- Wizard state persistence is a new frontend concern (localStorage), no backend changes needed

# Out of Scope

- Bulk ASIN setup (PROD-4121: IBO)
- Post-launch keyword bid adjustments (PROD-4124)
- Post-launch search term management (PROD-4125)

# Test Cases

1. Seller opens wizard, selects ASIN, completes all 5 steps. Campaigns created on Amazon.
2. Step 1 shows product table only (no competitors). Already-active ASIN shows warning banner.
3. Step 2 shows competitor tiles with relevance scores and revenue estimates. Selected competitors appear as removable chips.
4. Step 3: seller adds own keywords, triggers AI research. Progress bar shows fetching phases. "Close & Notify Me" lets seller leave. "Review Fetched Keywords" navigates to KW Research List and back. AI analysis auto-starts after fetching, "Review Research Output" navigates to KW Automation tab. Tab 3 locked until Tab 1+2 approved. Auto-advances to Step 4.
6. Step 4: seller sets Match Type Strategy, applies Target ACOS and Budget to all campaigns. Enables Auto Pacing. Reviews campaigns in Advanced view, uses bulk actions to pause Broad match campaigns.
7. Step 5: launch summary with 6 stat cards and Bid Optimization master toggle.
8. Seller closes wizard with unsaved changes. Discard confirmation appears.
9. Seller navigates away during Step 3 research. Notification bell fires on completion.
10. Step 5 shows 3 navigation cards after completion.

# Acceptance Criteria

- [ ] Wizard restructured from 4 steps to 5 steps
- [ ] Step 1 is product selection only (competitors separated to Step 2)
- [ ] Step 2 shows competitor tiles with relevance score %, estimated revenue, removable chips
- [ ] Step 3 combines KW Research + KW Automation into a single continuous flow with auto-triggered AI analysis
- [ ] Step 3 approval gate: Tab 3 locked until Tab 1+2 approved in KW Automation tab
- [ ] Step 4 adds Match Type Strategy, "Apply to All", Auto Pacing/Budget toggles, Simple/Advanced view, Bulk Action Bar
- [ ] Step 5 shows launch summary (6 stat cards) with Bid Optimization toggle and 3 navigation cards
- [ ] Wizard renders as modal overlay (not routed page)
- [ ] State persists to localStorage for resume
- [ ] Discard confirmation on close with unsaved changes
- [ ] Notification Bell fires on Step 3 research completion
- [ ] Tests passed (unit + integration)
- [ ] UI matches prototype

Prototype: https://mmaazhanif22.github.io/kepler-ads-design/ads-only.html
