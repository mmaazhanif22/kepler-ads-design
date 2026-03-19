# Keyword Research List

# User Story

As a seller, I want a keyword research view with competitive intelligence from Amazon and third-party sources (Jungle Scout) so that I can discover growth opportunities and make data-driven targeting decisions.

# Problem / Context

- The portal has keyword research data but does not surface third-party competitive intelligence (Jungle Scout) alongside Amazon native data.
- Sellers need both visible and hidden column sets. Showing all 26 columns at once causes information overload. The 10 Jungle Scout columns should be toggle-able.
- Running keyword research requires a completed ASIN setup, but the current UI does not clearly communicate this prerequisite or disable the trigger button.

# Solution Outline

**Keyword Research Table (16 visible + 10 hidden columns):**
- Visible: Keyword, Search Volume (Exact), Organic Rank, Sponsored Rank, Competition Level, CPR, Bid Suggestion, Relevancy, Word Count, Title Density, plus 6 more.
- Hidden (toggle-able): JS Search Volume (Broad), JS Organic ASIN Count, JS Sponsored ASIN Count, JS Ease of Ranking, JS Relevancy Score, JS PPC Bid (Exact/Broad), JS SP Brand Ad Bid, JS Recommended Promotions, JS Last Updated.
- "Columns" toggle button to show/hide Jungle Scout data.
- "Run KW Research" button: disabled with prerequisite message if ASIN setup incomplete. Triggers `POST /amazon-ads/approve-kw-stage`.
- Bulk import (3-column template: ASIN, Keyword, Source) and export.

**Behavior flow:**
1. Seller opens Keyword Research > 16 visible columns displayed.
2. Seller clicks "Columns" > reveals 10 JS columns.
3. Seller clicks "Run KW Research" without ASIN setup > sees prerequisite message.
4. Seller clicks "Run KW Research" with completed ASIN > research triggers.

# Connected Work Items

**Blocked By:** [PROD-4120](https://keplercommerce.atlassian.net/browse/PROD-4120) (ASIN setup required), [PROD-4128](https://keplercommerce.atlassian.net/browse/PROD-4128) (table patterns)
**Relates To:** [PROD-4126](https://keplercommerce.atlassian.net/browse/PROD-4126) (Campaign List), [PROD-4410](https://keplercommerce.atlassian.net/browse/PROD-4410) (Branding Scope classifies researched keywords)

# Implementation Notes

- Current data: `GET /amazon-ads/keywords-research/` for keyword research results. Export: `GET /amazon-ads/keywords-research/export/`.
- Import: `POST /amazon-ads/upload-file` type=k-research. 3 columns: ASIN, Keyword, Source.
- Research trigger: `POST /amazon-ads/approve-kw-stage`. Prerequisite check: verify ASIN `kw_research_status` and `competitor_asins` presence via ASIN config endpoint.
- Jungle Scout data from third-party integration, stored alongside keyword research data.

# Test Cases

1. Seller opens Keyword Research. 16 visible columns with data displayed.
2. Seller clicks "Columns". 10 JS columns appear.
3. "Run KW Research" disabled without ASIN setup. Prerequisite message shown.
4. "Run KW Research" triggers successfully with completed ASIN.
5. Seller imports 3-column CSV. System validates and loads.

# Acceptance Criteria

- [ ] 16 visible columns with toggle to reveal 10 Jungle Scout columns
- [ ] "Run KW Research" disabled with prerequisite message when ASIN setup incomplete
- [ ] Bulk import accepts 3-column template with validation
- [ ] Export includes visible columns with current filters
- [ ] Sorting, filtering, pagination, export
- [ ] Tests passed (unit + integration)
- [ ] UI matches prototype

Prototype: https://mmaazhanif22.github.io/kepler-ads-design/ads-only.html
