# Keyword Research (PROD-4409)

## User Story

As a seller, I want a keyword research view with competitive intelligence data from both Amazon and third-party sources (Jungle Scout), so that I can discover growth opportunities and make data-driven keyword targeting decisions.

## Problem / Context

- Keyword research tools need to surface competitive intelligence data (from sources like Jungle Scout) alongside Amazon's native data.
- Sellers need both visible and hidden column sets to avoid information overload while still having access to advanced data when needed.
- Running keyword research requires a completed ASIN setup. The UI must enforce this prerequisite clearly.

## Existing vs. Net-New

| Area | Status | Notes |
|------|--------|-------|
| Keyword Research table (16 visible columns) | EXISTS (rebuild) | Current portal has keyword research data. Rebuild with enhanced columns and Jungle Scout toggle. |
| Jungle Scout data (10 hidden columns) | NEW | Third-party data integration columns are new to the UI. |
| "Run KW Research" prerequisite check | EXISTS (rebuild) | Research trigger exists. Rebuild with clear prerequisite messaging. |
| Bulk import (3-column template) | EXISTS (rebuild) | Import via `POST /amazon-ads/upload-file` type=k-research. |

## Solution Outline

**Keyword Research Table (16 visible + 10 hidden columns):**
- Visible: Keyword, Search Volume (Exact), Organic Rank, Sponsored Rank, Competition Level, CPR, Bid Suggestion, Relevancy, Word Count, Title Density, plus 6 more.
- Hidden (toggle-able): JS Search Volume (Broad), JS Organic ASIN Count, JS Sponsored ASIN Count, JS Ease of Ranking, JS Relevancy Score, JS PPC Bid (Exact/Broad), JS SP Brand Ad Bid, JS Recommended Promotions, JS Last Updated.
- "Columns" toggle button to show/hide the Jungle Scout data columns.
- Bulk import (3-column template: ASIN, Keyword, Source) and export.
- "Run KW Research" requires completed ASIN setup (prerequisites shown if not met).

**UI Requirements:**
- Mockup: [Prototype](https://mmaazhanif22.github.io/kepler-ads-design/ads-only.html) | Keyword Research accessible from Manage Ads
- KW Research hidden columns toggle is a button similar to Keyword Settings column visibility.

## Sub-Tasks

| # | Sub-Task | Exists / New | Backend Reference |
|---|----------|-------------|-------------------|
| 1 | **Keyword Research table** with 16 visible columns, sortable/filterable/paginated | EXISTS (rebuild) | `GET /amazon-ads/keywords-research/` for keyword research data. |
| 2 | **Jungle Scout columns toggle** showing/hiding 10 additional third-party data columns | NEW | JS data from third-party integration. Columns stored alongside keyword research data. |
| 3 | **"Run KW Research" button** with prerequisite check and disabled state messaging | EXISTS (rebuild) | `POST /amazon-ads/approve-kw-stage` to trigger research. Prerequisite: ASIN setup complete (stage status check). |
| 4 | **Bulk import/export** with 3-column template (ASIN, Keyword, Source) | EXISTS (rebuild) | Import: `POST /amazon-ads/upload-file` type=k-research. Export: `GET /amazon-ads/keywords-research/export/`. |

## Backend References

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/amazon-ads/keywords-research/` | GET | Retrieve keyword research results |
| `/amazon-ads/keywords-research/export/` | GET/POST | Export keyword research as CSV |
| `/amazon-ads/upload-file` (type=k-research) | POST | Import keyword research CSV (3-column: ASIN, Keyword, Source) |
| `/amazon-ads/approve-kw-stage` | POST | Trigger keyword research for an ASIN |
| Jungle Scout API (third-party) | External | Source for JS Search Volume, Ease of Ranking, PPC Bid, etc. |

## Connected Work Items

**Blocks:** None.
**Is Blocked By:** PROD-4120 (Wizard), ASIN setup must be complete before research can run. PROD-4128 (UX Infrastructure), table patterns.
**Relates To:** PROD-4126 (Campaign List & Config). PROD-4124 (KW Settings), manages keywords post-research. PROD-4410 (Branding Scope), classifies researched keywords.

## Implementation Notes

- Jungle Scout (JS) columns come from a third-party data integration.
- "Run KW Research" button should be disabled with a prerequisite message if ASIN setup is incomplete.
- Import template uses 3 columns only: ASIN, Keyword, Source.

## Out of Scope

- Campaign list and config (covered by PROD-4126)
- Branding Scope classification (covered by PROD-4410)
- Keyword bid management (covered by PROD-4124)
- Third-party data provider integration setup (backend concern)

## Test Cases

- Seller opens Keyword Research. Sees 16 visible columns with data.
- Seller clicks "Columns" to reveal 10 JS columns. Additional data appears.
- Seller clicks "Run KW Research" without ASIN setup. Sees prerequisite message, button disabled.
- Seller clicks "Run KW Research" with completed ASIN. Research triggers successfully.
- Seller imports 3-column CSV (ASIN, Keyword, Source). System validates and loads.
- Seller exports keyword research. CSV includes visible columns only.

## Acceptance Criteria

- [ ] Keyword Research shows 16 visible columns with toggle to reveal 10 additional Jungle Scout columns
- [ ] "Run KW Research" disabled with prerequisite message when ASIN setup is incomplete
- [ ] Bulk import accepts 3-column template (ASIN, Keyword, Source) with validation
- [ ] Export includes visible columns with current filters applied
- [ ] Table supports sorting, filtering, pagination, and export
- [ ] Tests passed (unit + integration)
- [ ] UI matches approved mockup
