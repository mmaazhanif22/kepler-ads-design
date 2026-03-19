# Branding Scope (PROD-4410)

## User Story

As a seller, I want to classify keyword brand relationships (Non-Branded, Own Brand, Competitor Branded) with relationship types, so that keywords are automatically assigned to the correct campaign type following the Kepler naming convention.

## Problem / Context

- The Branding Scope feature (NB/OB/CB classification) is essential for the Kepler campaign naming convention but lacks a dedicated management interface in the redesign.
- Correct brand classification drives which campaign type (NB/OBH/CB) a keyword belongs to.
- Sellers need to review and override auto-classified branding scope values.

## Existing vs. Net-New

| Area | Status | Notes |
|------|--------|-------|
| Branding Scope data | EXISTS (rebuild) | `KeywordBrandingScope` model exists. GET/PUT endpoints exist. Rebuild as dedicated table with inline dropdowns. |
| Branding Scope import/export | EXISTS (rebuild) | Export: `GET /amazon-ads/keyword-branding-scope/export/`. Import: `POST /amazon-ads/upload-file` type=kw-branding-scope. CSV: ASIN, Keyword, Branding Scope, Relationship. |
| Relationship dropdown | EXISTS (rebuild) | Relationship values (N/R/S/C) exist in model. Rebuild as inline editable dropdown. |

## Solution Outline

**Branding Scope Table:**
- Columns: Keyword, Branding Scope (NB/OB/CB), Relationship (N/R/S/C), Logs, Actions.
- Branding Scope dropdown values: NB (Non-Branded), OB (Own Brand), CB (Competitor Branded).
- Relationship dropdown values: N (Neutral), R (Related), S (Substitute), C (Complementary).
- Inline editable dropdowns.
- Branding classification drives which campaign type (NB/OBH/CB) a keyword belongs to.
- Bulk import/export with 4-column CSV: ASIN, Keyword, Branding Scope, Relationship.

**UI Requirements:**
- Mockup: [Prototype](https://mmaazhanif22.github.io/kepler-ads-design/ads-only.html) | Branding Scope accessible from Manage Ads
- Branding Scope dropdowns match portal values exactly.

## Sub-Tasks

| # | Sub-Task | Exists / New | Backend Reference |
|---|----------|-------------|-------------------|
| 1 | **Branding Scope table** with 5 columns, inline editable NB/OB/CB and N/R/S/C dropdowns | EXISTS (rebuild) | `GET /amazon-ads/keyword-branding-scope` for data. `PUT /amazon-ads/keyword-branding-scope` for updates. |
| 2 | **Bulk import/export** with 4-column CSV (ASIN, Keyword, Branding Scope, Relationship) | EXISTS (rebuild) | Export: `GET /amazon-ads/keyword-branding-scope/export/`. Import: `POST /amazon-ads/upload-file` type=kw-branding-scope. |
| 3 | **Logs column** showing classification change history per keyword | NEW | Change log derived from branding scope update history. |

## Backend References

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/amazon-ads/keyword-branding-scope` | GET | Retrieve all keywords with branding scope data |
| `/amazon-ads/keyword-branding-scope` | PUT | Update branding scope and relationship for keywords |
| `/amazon-ads/keyword-branding-scope/export/` | GET | Export branding scope as CSV |
| `/amazon-ads/upload-file` (type=kw-branding-scope) | POST | Import branding scope CSV (4 columns: ASIN, Keyword, Branding Scope, Relationship) |

**Model:** `KeywordBrandingScope`
**Prompt Type:** BRANDING_SCOPE=1

## Connected Work Items

**Blocks:** None.
**Is Blocked By:** PROD-4120 (Wizard), keywords must exist. PROD-4409 (Keyword Research), keywords discovered through research.
**Relates To:** PROD-4126 (Campaign List & Config), branding scope drives campaign naming. PROD-4121 (IBO), bulk launch uses branding scope for campaign structure.

## Implementation Notes

- Branding Scope classifications feed into the campaign naming convention (NB/OBH/CB prefix).
- Dropdown values must match portal exactly: NB, OB, CB for scope. N, R, S, C for relationship.
- Bulk import/export uses 4 columns: ASIN, Keyword, Branding Scope, Relationship.

## Out of Scope

- Campaign list and config (covered by PROD-4126)
- Keyword research and discovery (covered by PROD-4409)
- Keyword bid management (covered by PROD-4124)
- Auto-classification algorithm (backend concern)

## Test Cases

- Seller opens Branding Scope. Sees table with Keyword, Branding Scope, Relationship, Logs, Actions columns.
- Seller sets keyword "lavender oil" to NB, Relationship N. Saves successfully.
- Seller changes keyword from NB to CB. Campaign assignment updates accordingly.
- Seller imports 4-column CSV. System validates and applies branding scope changes.
- Seller exports branding scope. CSV includes ASIN, Keyword, Branding Scope, Relationship.
- Logs column shows history of classification changes for a keyword.

## Acceptance Criteria

- [ ] Branding Scope table supports NB/OB/CB and N/R/S/C dropdown values matching portal
- [ ] Inline editable dropdowns save changes immediately
- [ ] Branding classifications feed into campaign naming convention
- [ ] Bulk import/export uses 4-column CSV format (ASIN, Keyword, Branding Scope, Relationship)
- [ ] Logs column shows classification change history
- [ ] Table supports sorting, filtering, pagination, and export
- [ ] Tests passed (unit + integration)
- [ ] UI matches approved mockup
