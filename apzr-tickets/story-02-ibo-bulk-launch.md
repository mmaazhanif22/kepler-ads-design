# Intelligent Batch Orchestrator (IBO): Bulk ASIN Launch

# User Story

As a seller with a large catalog, I want to launch advertising for multiple ASINs simultaneously with AI-powered grouping and batch processing so that I can scale setup from one ASIN at a time to dozens in a single workflow.

# Problem / Context

- Sellers with 10+ ASINs cannot practically use the single-ASIN wizard to set up each product individually. A 50-ASIN catalog would require 50 separate wizard flows.
- Different product types (e.g., essential oils vs. scented candles) require different competitor sets and keyword strategies, but there is no way to batch-configure by product type.
- Automated Keyword Research takes ~20 minutes per ASIN. For 12 ASINs processed sequentially, that is 4+ hours. There is no parallel processing capability.
- With 50+ ASINs, sellers cannot manually enter competitor ASINs for each product. There is no auto-discovery for competitors.
- There is no bulk review/approval workflow for keyword research results. Sellers must approve one ASIN at a time.
- There is no way to save a partially completed batch and resume later.

# Solution Outline

**6-stage progressive workflow accessible from sidebar "Launch Ads > Bulk Launch (IBO)".**

**Stage 1 - Mission Setup and AI Grouping:**
- Seller enters mission name, selects marketplace, pastes ASINs or imports CSV via drag-and-drop upload (`POST /api/amazon-ads/upload-file` type=asin-config).
- System validates ASINs and auto-groups by product type, brand relationship, price band. Price band splits when gap exceeds 2x group median. Singletons merged into nearest group.
- Each group card shows: name, ASIN count, product type, price range, plain-language grouping reason.

**Stage 2 - Per-Group Configuration:**
- Tab selector per group. Tier 1 auto-suggested category competitors pre-populated per group from `GET /analytics/search_terms/competitor_asins`. Tier 2 per-ASIN variant competitors auto-suggested (2-5 per ASIN). Seller reviews and overrides, not enters from scratch.
- Auto Pacing and Budget toggles at group level. KW Research Approval Mode toggle (Auto-Approve skips Stage 4, Manual Review sends to Stage 4).

**Stage 3 - Async Parallel Processing:**
- Up to 3 ASINs processed concurrently via RabbitMQ. Per-ASIN progress cards: Queued > Researching > Grouping > Building Campaigns > Done.
- "Review Completed ASINs" button appears after first ASIN finishes. "All Processing Complete" banner when batch finishes. Notification Bell fires when all ASINs complete.

**Stage 4 - Review Hub:**
- Filter tabs: All, Needs Review, Auto-Approved, Processing. Bulk actions: Export Review Spreadsheet, Import Reviewed Spreadsheet, Approve Selected.
- Still-processing ASINs shown with "Processing..." badge, update as they complete.

**Stage 5 - Campaign Configuration:**
- NB/OBH/CB color-coded campaign rows. Bid Optimization + Pacing in "Apply to All" section. Group filtering. Per-campaign negative keywords.
- Campaign names follow Kepler convention, locked/not editable. Bulk Edit and Export CSV controls.

**Stage 6 - Launch Confirmation:**
- Summary stats: Total ASINs, Campaigns, Daily Budget, Average Target ACOS. Pre-launch checklist. Single "Launch All Campaigns" button with confirmation. Launch date picker.

**Batch History and Resume:**
- Auto-saves after each stage transition. Saved Batches section with stage progress dots and resume buttons.

**Behavior flow:**
1. Seller clicks "Bulk Launch (IBO)" > Stage 1 loads. Seller pastes 12 ASINs > clicks Validate and Group > 4 groups created.
2. Seller reviews groups in Stage 2 > auto-populated competitors shown per group > clicks Next.
3. Stage 3 processes ASINs in parallel. Seller navigates away. Notification Bell fires when done.
4. Seller returns, reviews results in Stage 4 > bulk-approves all.
5. Stage 5 shows campaigns. Seller adjusts budgets > clicks Next.
6. Stage 6 shows summary. Seller clicks "Launch All Campaigns" > campaigns activate on Amazon.

# Connected Work Items

**Relates To:** [PROD-4120](https://keplercommerce.atlassian.net/browse/PROD-4120) (single-ASIN wizard equivalent), [PROD-4122](https://keplercommerce.atlassian.net/browse/PROD-4122) (Manage Ads entry point)

# Implementation Notes

- This is 100% net-new. No existing components to reuse.
- File upload: `apps/amazon_ads/api/views/file_views.py:19` (upload_file). Strategy `asin-config` for Stage 1. Template download: `GET /api/amazon-ads/download-config-file`.
- KW Research per ASIN: same flow as wizard Step 3 but called in a loop. POST `/api/amazon-ads/approve-kw-stage` per ASIN. Frontend polls `kw_research_status` per ASIN every 10 seconds.
- Campaign creation: same `CampaignCreationOrchestrator` as wizard, called per ASIN in batch.
- Competitor discovery: `apps/analytics/api/urls.py:78-80`. GET `/analytics/search_terms/competitor_asins` returns `{asin, clickShare, conversionShare, searchFrequencyRank}`.
- Stage 3 parallel: process up to 3 ASINs concurrently via separate RabbitMQ messages. Each goes through: trigger research > wait > approve branding > approve attributes > approve grouping. Estimated: 20-30 min for 12 ASINs.
- Batch persistence: no backend endpoint exists. Use localStorage for prototype phase. Structure: `{batchId, missionName, currentStage, asins, groupConfig, createdAt}`. If dedicated backend needed later, propose `BatchLaunchState` model.
- Campaign naming: same Kepler convention as wizard. NB=`NBH1-SPKW-PB01-{Country}-S-{ASIN}-{Match}-KW`, OBH=`OBH1-...`, CB=`CBR1-...`.
- Bulk import CSV columns: ASIN, TargetACOS, CompetitorASINs(comma-separated), DailyBudget, AutoBudgetStatus, AdStatus, AutoPacingStatus.

# Out of Scope

- Single-ASIN setup (PROD-4120)
- Post-launch campaign monitoring (PROD-4123, PROD-4124, PROD-4125, PROD-4127)
- Multi-marketplace expansion (launching same ASINs on multiple marketplaces simultaneously)

# Test Cases

1. Seller pastes 12 ASINs, clicks Validate and Group. System produces 4 logical groups with reasons.
2. Seller imports CSV with 25 ASINs. System validates, loads, and groups.
3. Stage 2 Tier 1 competitors are auto-populated (not empty). Tier 2 per-ASIN competitors pre-filled.
4. Auto-Approve ON: ASINs skip Stage 4 after processing. Auto-Approve OFF: ASINs appear in Review Hub.
5. Stage 3 processes ASINs in parallel. "Review Completed ASINs" button appears after first ASIN finishes.
6. Stage 3: Notification Bell fires when all ASINs complete.
7. Seller exports review spreadsheet, edits offline, imports back. Changes reflected.
8. Seller bulk-approves 10 ASINs. Confirmation dialog, status updates.
9. Stage 5 shows locked campaign names with group filtering and per-campaign neg KWs.
10. Seller saves batch, closes browser, returns. Batch resumable from Saved Batches.

# Acceptance Criteria

- [ ] 6-stage progressive workflow for bulk ASIN launch
- [ ] AI Grouping produces logical groups by product type, price band, brand
- [ ] Tier 1 and Tier 2 competitors auto-populated from marketplace data
- [ ] Stage 3 processes up to 3 ASINs in parallel with real-time progress cards
- [ ] Notification Bell fires when all processing completes
- [ ] "Review Completed ASINs" button enables partial Stage 4 access
- [ ] Review Hub supports bulk approve and CSV export/import
- [ ] Campaign names follow Kepler convention, locked/not editable
- [ ] Batch history persists with resume capability
- [ ] Tests passed (unit + integration)
- [ ] UI matches prototype

Prototype: https://mmaazhanif22.github.io/kepler-ads-design/ads-only.html
