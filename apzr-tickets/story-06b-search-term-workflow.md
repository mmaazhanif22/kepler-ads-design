# Search Term Workflow Tabs (Story 6B): Harvest Queue, Negative Keywords, High Performers

## User Story

As a seller, I want workflow-specific tabs for harvesting promising search terms, managing negative keywords, and spotlighting high performers, so that I can act on search term data efficiently without manually filtering the main table.

## Problem / Context

- Search term management involves multiple distinct workflows: harvesting promising terms into campaigns, flagging terms for negative keyword addition, and identifying high performers for expansion.
- Without dedicated tabs, sellers must mentally filter between these different workflows in a single table.
- Sellers managing thousands of search terms need efficient bulk operations for each workflow.
- Harvest and negate actions are currently backend-automated but lack a review/approval UI.

## Existing vs. Net-New

| Area | Status | Notes |
|------|--------|-------|
| Harvest logic | EXISTS (backend) | `SearchTermsHarvestingPhraseChecker` + `SearchTermsHarvestingBroadAutoChecker`. Rule: `MAX(ACoS_7d/15d/30d/90d) <= Target_ACoS` AND `Lifetime_Spend >= ASIN_Price`. Celery: `calculate_search_terms()` -> `calculate_search_terms_harvesting()`. |
| Negate logic | EXISTS (backend) | `SearchTerm.negative_status_manual`: 1=MARK_AS_NEGATIVE, 2=REMOVE_EXISTING_NEGATIVE. `SearchTermService.bulk_update()`. Tasks: `create_negative_keyword()`, `update_negative_search_terms()`. |
| Harvest Queue UI | NEW | No harvest review/approval UI exists. Backend auto-harvests. New UI lets sellers review before promotion. |
| Negative Keywords UI | NEW | No dedicated negative keyword management tab. New UI with scope selector. |
| High Performers UI | NEW | No high-performer spotlight view exists. |

## Solution Outline

Three additional tabs within the Search Term Settings view (alongside the Active Search Terms tab from Story 6A).

**Tab 2: Harvest Queue**
- Search terms that meet harvesting criteria (e.g., 3+ conversions, ACOS below target).
- Seller can select terms and promote them to keyword campaigns.
- Bulk harvest action for multiple terms.
- Each term shows: Search Term, ASIN, Campaign, Conversions, ACOS, Spend, and Harvest action button.

**Tab 3: Negative Keywords**
- Search terms generating spend with zero or very low conversions.
- Seller can add terms as negative keywords to campaigns.
- Scope selector: apply to all campaigns, manual only, auto only, or PT only.
- Each term shows: Search Term, ASIN, Campaign, Spend, Conversions, ACOS, Negative Status, and Negate action button.
- Remove existing negatives option for terms previously marked negative.

**Tab 4: High Performers**
- Search terms with the best conversion rates and ACOS.
- Seller can quickly identify winning search terms for keyword expansion.
- Data includes conversion count, ACOS, revenue attribution, trend indicators.
- Sorted by conversion rate by default.

**Shared Features:**
- Active tab shows count of items (e.g., "Harvest Queue (12)").
- Sortable, filterable, paginated tables.
- Bulk selection with multi-action toolbar.
- Export per tab.

**UI Requirements:**
- Mockup: [Prototype: Search Term Settings](https://mmaazhanif22.github.io/kepler-ads-design/ads-only.html) (navigate to Manage Ads > Search Term Settings, switch tabs)
- Tabs render within the sub-tab shell built in Story 6A.
- Consistent styling with Story 6A Active Search Terms table.

## Sub-Tasks

| # | Sub-Task | Exists / New | Backend Reference |
|---|----------|-------------|-------------------|
| 1 | **Harvest Queue tab** with term list, bulk select, promote-to-keyword action | NEW (UI) / EXISTS (backend) | Backend: `SearchTerm.is_harvested`, `HarvestedAsinService.identify_harvested_asins()`, `process_harvested_search_terms()`. Harvesting criteria from `SearchTermsHarvestingPhraseChecker`. |
| 2 | **Negative Keywords tab** with scope selector (All/Manual/Auto/PT), negate action, remove-negative action | NEW (UI) / EXISTS (backend) | Backend: `SearchTerm.negative_status_manual` (1=MARK, 2=REMOVE). `SearchTermService.bulk_update()`. Tasks: `create_negative_keyword()`, `set_auto_negative_keywords_from_manual()`. Consumers: `create_negative_keywords`, `update_negative_keywords`, `sync_negative_keywords`. |
| 3 | **High Performers tab** with top-converting search terms, trend indicators, expansion actions | NEW | Derived from search term performance data. Filter criteria: ACOS below average, conversion count above threshold. |
| 4 | **Bulk actions toolbar** for all 3 tabs: multi-select, bulk harvest, bulk negate, export | NEW (UI) / EXISTS (backend for harvest/negate) | Bulk operations via `SearchTermService.bulk_update()`. |

## Backend References

| Endpoint / Service | Method | Purpose |
|----------|--------|---------|
| `SearchTerm.is_harvested` | Model field | Boolean flag for harvested search terms |
| `SearchTerm.negative_status_manual` | Model field | 1=MARK_AS_NEGATIVE, 2=REMOVE_EXISTING_NEGATIVE |
| `SearchTermService.bulk_update()` | Service | Bulk update search term status (harvest, negate) |
| `SearchTermsHarvestingPhraseChecker` | Checker | Phrase match harvest rule evaluation |
| `SearchTermsHarvestingBroadAutoChecker` | Checker | Broad/auto match harvest rule evaluation |
| `HarvestedAsinService.identify_harvested_asins()` | Service | Identify ASINs with harvestable search terms |
| `process_harvested_search_terms()` | Function | Process and promote harvested terms |
| `create_negative_keyword()` | Celery Task | Create negative keyword via Amazon API |
| `update_negative_search_terms()` | Celery Task | Update negative status for search terms |
| `set_auto_negative_keywords_from_manual()` | Celery Task | Apply manual negative selections to auto campaigns |
| `AmazonAdNegativeKeywordsAPI.delete_keywords()` | API | Delete negative keywords from Amazon |
| `CustomNegativeKeywordsManager.remove_custom_negative_keywords()` | Service | Soft-delete (set PAUSED) custom negatives |
| `create_negative_keywords` (RabbitMQ) | Consumer | Process negative keyword creation queue |
| `update_negative_keywords` (RabbitMQ) | Consumer | Process negative keyword update queue |
| `sync_negative_keywords` (RabbitMQ) | Consumer | Sync negative keywords with Amazon |

**Harvest Rule:** `MAX(ACoS_7d/15d/30d/90d) <= Target_ACoS` AND `Lifetime_Spend >= ASIN_Price`

## Connected Work Items

**Blocks:** None.
**Is Blocked By:** Story 6A (Active Search Terms table and sub-tab shell must exist first). Story 9 (UX Infrastructure) for table patterns.
**Relates To:** Story 5 (Keyword Settings), harvested terms become keywords. Story 1 (Wizard), wizard creates initial campaign structure that generates search terms.

## Implementation Notes

- Harvest Queue criteria should be configurable (e.g., minimum conversions, maximum ACOS).
- Negative Keywords tab should show which campaigns the negative applies to.
- High Performers criteria: ACOS below average, conversion count above threshold.
- Backend harvesting is automatic/rule-based. The UI provides a review layer before promotion.
- Negative keyword operations use multiple consumer queues for Amazon API rate limiting.

## Out of Scope

- Active Search Terms table (covered by Story 6A)
- Keyword-level bid management (covered by Story 5)
- Automated harvesting rule configuration (backend concern)
- Search term data collection from Amazon (backend data pipeline)
- Cross-marketplace search term comparison

## Test Cases

- Seller switches to Harvest Queue. Sees search terms meeting harvest criteria with conversion and ACOS data.
- Seller selects 5 search terms and clicks "Harvest". Terms promoted to keywords with confirmation.
- Seller switches to Negative Keywords. Sees underperforming terms with scope selector.
- Seller adds 3 negative keywords with scope "Auto only". Negatives apply to auto campaigns only.
- Seller removes an existing negative keyword. Status changes to REMOVE_EXISTING_NEGATIVE.
- Seller switches to High Performers. Sees top-converting terms sorted by conversion rate.
- Tab badges show counts: "Harvest Queue (12)", "Negative Keywords (8)", "High Performers (25)".
- Seller bulk-selects 10 terms in Harvest Queue and clicks Harvest. Confirmation dialog shows count.
- Export from Negative Keywords tab includes all visible columns for that tab.

## Acceptance Criteria

- [ ] Harvest Queue tab shows search terms meeting harvest criteria with promote-to-keyword action
- [ ] Bulk harvest action allows selecting and promoting multiple terms at once
- [ ] Negative Keywords tab supports scope selector (All/Manual/Auto/PT) for applying negatives
- [ ] Remove-negative action available for previously negated terms
- [ ] High Performers tab highlights top-converting search terms sorted by conversion rate
- [ ] Tab badges show item counts for each workflow tab
- [ ] Bulk selection and multi-action toolbar work across all 3 tabs
- [ ] All tabs support sorting, filtering, pagination, and export
- [ ] Tests passed (unit + integration)
- [ ] UI matches approved mockup
