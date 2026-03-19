# ASIN Advertising Setup Wizard

## User Story

As a seller, I want a guided step-by-step wizard that walks me through the complete ASIN advertising setup, so that I can configure and launch ad campaigns for any product without needing to understand the full advertising system upfront.

## Problem / Context

- Setting up advertising for a new ASIN requires configuring multiple interdependent settings: product selection, competitor research, keyword research, campaign structure, and launch parameters.
- Currently, sellers must navigate multiple disconnected screens to complete a setup, leading to incomplete configurations and support requests.
- New sellers especially struggle to understand which settings matter and in what order they should be configured.
- There is no guided flow that ensures all required steps are completed before campaigns go live.
- Automated Keyword Research (Step 3) takes approximately 20 minutes to complete. Sellers need to be notified when it finishes so they can leave the page and return later.

## Existing vs. Net-New

| Step | Status | Notes |
|------|--------|-------|
| Step 1: Product Selection | EXISTS (rebuild) | ASIN Config page exists. Rebuild as wizard step with Target ACOS, Auto Pacing, Bid Ceiling. |
| Step 2: Automated Competitor Research | EXISTS (rebuild) | Competitor ASIN entry exists in current flow. Elevate from sub-tab to dedicated step with validation. |
| Step 3: Automated Keyword Research | EXISTS (rebuild) | KW Research trigger exists (`POST /amazon-ads/approve-kw-stage`). Rebuild with Phase 1 Fetching + Phase 2 Analysis progress UI, notification bell integration. |
| Step 4: Campaign Config | NEW | New unified campaign config step. Auto Budget toggle, ASIN-Level Defaults, bulk select/enable, per-campaign neg KWs, Pacing badges. |
| Step 5: Activate | NEW | New launch confirmation step with non-technical Bid Opt text, ads toggle note, 3 nav cards. |
| Wizard Edit Mode | NEW | Re-entry to edit specific steps for launched ASINs. |
| Notification Bell | NEW | Dynamic notifications for background process completion. |

## Solution Outline

A 5-step wizard overlay that guides the seller through the full ASIN advertising setup process. The wizard opens as a modal dialog over the main portal content.

**Step 1: Product Selection**
- Seller selects which ASIN to set up from their product catalog.
- Seller sets a Target ACOS (no default value, must be set explicitly).
- Optional: Auto Pacing toggle to automatically pause/resume campaigns based on daily spend targets.
- Optional: Bid Ceiling field as a maximum bid safety cap.
- Both optional fields clearly labeled as "Optional" or "Conditional".

**Step 2: Automated Competitor Research**
- Elevated from a sub-tab to a dedicated wizard step.
- Seller enters competitor ASINs for the selected product.
- System validates competitor ASINs exist on the marketplace.
- Sellers can add multiple competitors to inform keyword and targeting strategies.

**Step 3: Automated Keyword Research**
- Merges the previous "KW Research" and "Keyword Automation" steps into a single step.
- **Phase 1 (Fetching):** System triggers keyword data collection from marketplace sources.
- **Phase 2 (Analysis):** System processes, groups, and ranks the fetched keywords.
- Animated progress indicator shows research status for both phases.
- On completion, system auto-advances to Step 4.
- **Notification on Completion:** When research finishes, the system adds a notification to the Notification Bell (e.g., "Automated Keyword Research complete for {ASIN}: 156 keywords found. Ready for review.") so the seller is alerted even if they navigated away during the ~20-minute research period.
- If the seller stays on the wizard, auto-advance to Step 4 still occurs as normal.
- If the seller navigated away, they can return to the wizard via the notification or Manage Ads resume flow.

**Step 4: Campaign Config**
- System displays dynamically generated campaigns organized in 3 sections:
  - SPKW (manual keyword campaigns): 1 campaign per keyword group per enabled match type. Count depends on how many groups KW Research produced and which match types are selected.
  - SPAU (auto-targeting campaigns): Close Match, Loose Match, Substitutes, Complements. Created when auto-targeting is enabled.
  - SPAS (product targeting campaigns): 1 per competitor brand identified in Step 2. Count depends on number of unique competitor brands.
- Campaign count varies per ASIN based on keyword research results, branding scope configuration (NB/OB/CB), and match type selection. The generation logic is in `CampaignService.create_campaigns()` using `KwResearchGroupRank` groups and `AdvertisingCampaignConfig` match type settings.
- Each campaign row shows: Type, Targeting strategy, keyword count, search volume, and an Optimize toggle.
- **Auto Budget toggle**: system calculates recommended daily budgets based on keyword volume and Target ACOS.
- **ASIN-Level Defaults**: sellers can set defaults that apply across all campaigns for this ASIN.
- **Bulk select/enable**: checkbox column for bulk-enabling or disabling campaigns.
- **Per-campaign Negative Keywords**: each campaign row allows adding campaign-specific negative keywords.
- **Pacing badges**: visual indicators showing projected pacing status per campaign.
- Campaign names follow the Kepler naming convention and are system-generated (not editable by the seller).
- Listing Quality Score panel shows a score gauge and per-dimension quality bars.

**Step 5: Activate**
- Non-technical Bid Optimization explanation text (seller-friendly language, no engineering jargon).
- Ads toggle note explaining what enabling/disabling ads does post-launch.
- Pre-launch checklist shows all completed items with green checkmarks.
- Optional skipped items (Bid Ceiling, Negative Keywords) shown with amber indicators.
- Single "Complete Setup" button to activate campaigns.
- **3 navigation cards** after completion: go to Manage Ads, go to Keyword Settings, go to Search Term Settings.

**Wizard Edit Mode:**
- Sellers who have already launched an ASIN can re-enter the wizard to edit specific steps.
- An "Edit" button appears next to launched ASINs in the ASIN Config table.
- Edit menu offers direct navigation to: Competitors (Step 2), Automated Keyword Research (Step 3), Campaigns (Step 4), or Activate Settings (Step 5).
- Wizard shows an "Edit Mode" indicator when editing a previously launched ASIN.
- All previously saved settings are pre-populated when editing.

**Notification Bell Integration:**
- The portal header includes a Notification Bell with a dropdown panel.
- Notifications are added dynamically when background processes complete (e.g., Automated Keyword Research).
- Each notification shows: icon, message, timestamp, and unread indicator.
- Bell badge shows unread count. "Mark all read" clears all unread indicators.
- Notification types: success (green), warning (amber), info (blue), error (red).
- Bell icon pulses briefly when a new notification arrives.

**UI Requirements:**
- Mockup: [Prototype: ASIN Setup Wizard](https://mmaazhanif22.github.io/kepler-ads-design/ads-only.html) (open wizard from sidebar "ASIN Launch")
- Wizard opens as a modal overlay with backdrop.
- Progress indicator shows current step and completion status.
- "Back" and "Next" navigation between steps.
- Discard confirmation when closing wizard with unsaved changes.
- Accessible: screen reader announces step changes, focus management on open/close.

## Sub-Tasks

| # | Sub-Task | Exists / New | Backend Reference |
|---|----------|-------------|-------------------|
| 1 | **Step 1: Product Selection** with Target ACOS, Auto Pacing toggle, Bid Ceiling | EXISTS (rebuild) | `GET /amazon-ads/asin-config/` for ASIN list. `PUT /amazon-ads/asin-config/` to save settings. |
| 2 | **Step 2: Automated Competitor Research** with ASIN validation and multi-competitor entry | EXISTS (rebuild) | `GET /analytics/search_terms/competitor_asins` for competitor data. Validation via Amazon catalog API. |
| 3 | **Step 3: Automated Keyword Research** with Phase 1 + Phase 2 progress, notification bell | EXISTS (rebuild) | `POST /amazon-ads/approve-kw-stage` to trigger research. `POST /amazon-ads/reset-kw-stage` to reset. Stage status model: PENDING(0), IN_QUEUE(1), RECEIVED(2), APPROVED(3), FAILED(4). |
| 4 | **Step 4: Campaign Config** with Auto Budget, ASIN-Level Defaults, bulk select, per-campaign neg KWs, Pacing badges | NEW | Campaign creation: RabbitMQ consumer `advertising_create_campaign` triggers `CampaignService.create_campaigns()`. Neg KWs: `CustomNegativeKeywordsManager`. |
| 5 | **Step 5: Activate** with non-technical Bid Opt text, ads toggle note, 3 nav cards | NEW | Campaign activation via `AdvertisingCampaignConfigService.bulk_update()`. |
| 6 | **Wizard Edit Mode**: re-entry for launched ASINs with step-specific navigation | NEW | Same endpoints as Steps 1-5. Pre-populate from existing ASIN config data. |
| 7 | **Notification Bell**: dynamic notification dropdown with unread count and bell pulse | NEW | Backend event queue for notification state (new endpoint needed, or client-side polling of stage status). |

**Separate Stories (not sub-tasks of this story):**
- **Listing Quality Score panel** (Step 4): depends on `GET /amazon-ads/attribute-ranking?asin=<id>`. Can be delivered independently.
- **Wizard progress persistence / resume**: auto-save and resume flow for interrupted wizards. Requires new backend state storage.

## Backend References

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/amazon-ads/asin-config/` | GET | Retrieve ASIN list and existing config |
| `/amazon-ads/asin-config/` | PUT | Save ASIN configuration (Target ACOS, Bid Ceiling, Auto Pacing) |
| `/amazon-ads/approve-kw-stage` | POST | Trigger keyword research for an ASIN (`{asin_id, prompt_type}`) |
| `/amazon-ads/reset-kw-stage` | POST | Reset keyword research stage (`{asin_id, check_only, confirm_external}`) |
| `/analytics/search_terms/competitor_asins` | GET | Competitor ASIN data (clickShare, conversionShare, searchFrequencyRank) |
| `/analytics/search_terms/competitor_brands` | GET | Competitor brand data |
| `/amazon-ads/attribute-ranking` | GET | Listing attributes for quality score (`?asin=<id>`) |
| `/amazon-ads/attribute-ranking` | PUT | Update listing attribute rankings |
| `advertising_create_campaign` (RabbitMQ) | Consumer | Batch campaign creation via `CampaignService.create_campaigns()` |
| `/amazon-ads/ad-campaign-config/` | GET/PUT | Campaign config CRUD |
| `AdvertisingCampaignConfigService.bulk_update()` | Service | Bulk campaign config updates with validation and duplicate detection |

**Models:** `KeywordResearchAutomationBatch` (table: `amazon_ads.kw_rs_batch`), `KeywordResearchAutomationBatchHistory`, `KeywordBrandingScope`, `AttributeRanking`, `KwResearchGroupRank`

**Stage Status Enum:** PENDING(0), IN_QUEUE(1), RECEIVED(2), APPROVED(3), FAILED(4)

**Prompt Types:** BRANDING_SCOPE=1, ATTRIBUTES_RANKING=2, GROUPING_RANKING=3

## Connected Work Items

**Blocks:** PROD-4124 (Keyword Settings), PROD-4125 (Search Term Settings). Wizard creates the initial configuration that these views manage.
**Is Blocked By:** None. This is the primary entry point for ASIN advertising setup.
**Relates To:** PROD-4121 (IBO), the bulk equivalent of this single-ASIN wizard. PROD-4122 (Manage Ads), which provides an alternative entry point to the wizard.

The wizard is foundational. It must be delivered before sellers can set up advertising for individual ASINs.

## Implementation Notes

- The wizard must support both "new setup" and "edit existing" modes.
- Step 3 auto-research should show real-time progress and auto-advance.
- Step 3 must fire a notification to the Notification Bell when research completes, so sellers who navigate away during the ~20-minute research window are alerted when results are ready.
- Campaign naming follows the Kepler convention: `{Type}H1-SPKW-PB01-{Country}-S-{ASIN}-{Match}-KW`
- Campaign names are read-only in the UI (system-generated).
- The wizard must save progress so sellers can resume if they close it.
- Negative Keywords scope selector applies negatives to the selected campaign subset.
- Listing Quality Score is calculated from product listing attributes (title, bullets, images, etc.).
- The wizard is for single-ASIN setup only. Bulk operations use the IBO (PROD-4121).

## Out of Scope

- Bulk ASIN setup (covered by PROD-4121: IBO)
- Post-launch campaign performance monitoring (covered by PROD-4123: Dashboards)
- Keyword bid adjustments after launch (covered by PROD-4124: Keyword Settings)
- Search term harvesting and negative keyword management post-launch (covered by PROD-4125: Search Term Settings)
- Campaign budget pacing (covered by PROD-4127: Pacing Management)

## Related Enhancement Stories

These enhancements are tracked as separate stories under PROD-2180. They extend the wizard but are not required for the core flow to ship.

| PROD Key | Enhancement | Dependency |
|----------|------------|------------|
| PROD-4390 | Notification Bell: full dropdown panel with history, clickable resume | This story benefits from it (Step 3 notify on completion) |
| PROD-4391 | Wizard Edit Mode: re-enter wizard for launched ASINs | This story provides the base wizard flow |
| PROD-4447 | Wizard Advanced Campaign Features: Auto Budget toggle, ASIN-Level Defaults grouping, bulk campaign select/enable/pause, per-campaign negative keywords, Pacing badges | Blocked by PROD-4120 |
| PROD-4448 | Wizard UX Enhancements: rich competitor tiles (price, velocity, rating, reviews), "Review Fetched Keywords" link between phases, 3 post-wizard navigation cards, ads toggle tip | Blocked by PROD-4120 |

## Test Cases

- Seller opens wizard, selects an ASIN, and completes all 5 steps successfully. Campaigns are created.
- Seller sets Target ACOS to 35%, enables Auto Pacing, and sets Bid Ceiling to $3.00. All values saved.
- Seller skips optional Bid Ceiling. Step 5 shows amber indicator for skipped item.
- Seller enters Step 3. Research auto-triggers without manual action, progress shows Phase 1 then Phase 2, auto-advances to Step 4.
- Seller navigates away during Step 3 research. Notification bell updates with "Automated Keyword Research complete" when research finishes.
- Seller clicks the notification. Navigates back to wizard at Step 4 (Campaign Config).
- Seller in Step 4 sees the generated campaigns in 3 sections (SPKW, SPAU, SPAS) with correct columns.
- Seller toggles Auto Budget in Step 4. Recommended budgets populate for all campaigns.
- Seller adds per-campaign negative keywords in Step 4. Negatives saved per campaign.
- Seller closes wizard with unsaved changes. Discard confirmation appears.
- Seller clicks "Edit" on a launched ASIN. Wizard opens in edit mode with pre-populated data at the selected step.
- Seller navigates back from Step 4 to Step 2. Previous inputs are preserved.
- Screen reader user navigates the wizard. Step changes are announced, focus is managed.
- Step 5 shows 3 navigation cards after completion: Manage Ads, Keyword Settings, Search Term Settings.

## Acceptance Criteria

- [ ] Wizard provides a 5-step guided flow for complete ASIN advertising setup
- [ ] Step 1 requires explicit Target ACOS (no default) and offers optional Auto Pacing and Bid Ceiling
- [ ] Step 2 provides dedicated Automated Competitor Research with ASIN validation
- [ ] Step 3 auto-triggers Automated Keyword Research with Phase 1 + Phase 2 progress and auto-advances to Step 4 on completion
- [ ] Step 3 sends a notification to the Notification Bell when research completes
- [ ] Seller can navigate away during research and return via the notification when research is done
- [ ] Step 4 displays the generated campaigns in 3 sections (SPKW, SPAU, SPAS) with Auto Budget, ASIN-Level Defaults, bulk select, per-campaign neg KWs, and Pacing badges
- [ ] Step 5 shows activate summary with non-technical Bid Opt text, ads toggle note, checklist, and 3 navigation cards
- [ ] Wizard supports edit mode for previously launched ASINs with pre-populated data
- [ ] Discard confirmation appears when closing wizard with unsaved changes
- [ ] Wizard is accessible: focus managed, step changes announced to screen readers
- [ ] All campaign names follow the Kepler naming convention and are not editable
- [ ] Tests passed (unit + integration)
- [ ] UI matches approved mockup
