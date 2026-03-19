# Search Term Workflow Tabs: Harvest Queue, Negative Keywords, High Performers

# User Story

As a seller, I want workflow-specific tabs for harvesting promising search terms, managing negative keywords, and spotlighting high performers so that I can act on search term data without manually filtering the main table.

# Problem / Context

- Search term management involves 3 distinct workflows: harvesting terms into campaigns, flagging terms as negatives, identifying high performers for expansion. All 3 are currently mixed into one flat table.
- Harvesting logic exists in the backend (`SearchTermsHarvestingPhraseChecker`, `SearchTermsHarvestingBroadAutoChecker`) but runs automatically with no review/approval UI. Sellers cannot review before promotion.
- Negative keyword operations exist (`SearchTerm.negative_status_manual`: 1=MARK_AS_NEGATIVE, 2=REMOVE_EXISTING_NEGATIVE, `SearchTermService.bulk_update()`) but lack a dedicated management interface with scope selection.
- There is no way to spotlight high-performing search terms separately from the full table.

# Solution Outline

**3 tabs within Search Term Settings (alongside Active Search Terms from PROD-4125):**

**Tab 2 - Harvest Queue:** Search terms meeting harvest criteria (rule: `MAX(ACoS_7d/15d/30d/90d) <= Target_ACoS` AND `Lifetime_Spend >= ASIN_Price`). Columns: Search Term, ASIN, Campaign, Conversions, ACOS, Spend, Harvest action. Bulk harvest for multiple terms.

**Tab 3 - Negative Keywords:** Terms generating spend with zero/low conversions. Scope selector: All campaigns, Manual only, Auto only, PT only. Negate action and Remove-negative action. Uses `create_negative_keyword()` Celery task and RabbitMQ consumers (`create_negative_keywords`, `update_negative_keywords`, `sync_negative_keywords`).

**Tab 4 - High Performers:** Top-converting terms sorted by conversion rate. ACOS below average, conversion count above threshold. Trend indicators for expansion decisions.

**Shared:** Tab badges with item counts. Sortable, filterable, paginated. Bulk selection with multi-action toolbar. Per-tab export.

# Connected Work Items

**Blocked By:** [PROD-4125](https://keplercommerce.atlassian.net/browse/PROD-4125) (sub-tab shell must exist)
**Relates To:** [PROD-4124](https://keplercommerce.atlassian.net/browse/PROD-4124) (harvested terms become keywords)

# Implementation Notes

- Harvest Queue: backend checkers `SearchTermsHarvestingPhraseChecker` and `SearchTermsHarvestingBroadAutoChecker` identify candidates. `HarvestedAsinService.identify_harvested_asins()` and `process_harvested_search_terms()` handle promotion. UI adds review layer before auto-promotion.
- Negative Keywords: `SearchTerm.negative_status_manual` field (1=MARK, 2=REMOVE). Bulk via `SearchTermService.bulk_update()`. Tasks: `create_negative_keyword()`, `set_auto_negative_keywords_from_manual()`. Consumers: `create_negative_keywords`, `update_negative_keywords`, `sync_negative_keywords`. Delete via `AmazonAdNegativeKeywordsAPI.delete_keywords()`.
- High Performers: derived from search term performance data, filtered by ACOS below average and conversion count above threshold. No new backend endpoint needed.

# Test Cases

1. Seller switches to Harvest Queue. Sees terms meeting criteria with conversion and ACOS data.
2. Seller selects 5 terms, clicks Harvest. Terms promoted to keywords.
3. Seller opens Negative Keywords. Adds 3 negatives with scope "Auto only". Applied to auto campaigns only.
4. Seller removes an existing negative. Status changes to REMOVE_EXISTING_NEGATIVE.
5. High Performers tab shows top-converting terms sorted by conversion rate.
6. Tab badges show counts: "Harvest Queue (12)", "Negative Keywords (8)".

# Acceptance Criteria

- [ ] Harvest Queue shows terms meeting harvest criteria with promote action
- [ ] Bulk harvest allows selecting and promoting multiple terms
- [ ] Negative Keywords supports scope selector (All/Manual/Auto/PT)
- [ ] Remove-negative action available for previously negated terms
- [ ] High Performers highlights top-converting terms by conversion rate
- [ ] Tab badges show item counts
- [ ] Bulk selection and multi-action toolbar across all 3 tabs
- [ ] Tests passed (unit + integration)
- [ ] UI matches prototype

Prototype: https://mmaazhanif22.github.io/kepler-ads-design/ads-only.html
