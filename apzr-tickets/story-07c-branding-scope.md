# Branding Scope

# User Story

As a seller, I want to classify keyword brand relationships (Non-Branded, Own Brand, Competitor Branded) with relationship types so that keywords are automatically assigned to the correct campaign type following the Kepler naming convention.

# Problem / Context

- The Kepler campaign naming convention relies on NB/OB/CB classification to determine which campaign type a keyword belongs to. The `KeywordBrandingScope` model and GET/PUT endpoints exist, but there is no dedicated management interface in the redesign.
- Branding scope values are auto-classified by the backend, but sellers have no way to review or override classifications without direct API calls or CSV uploads.
- Without a visible Branding Scope table, sellers cannot verify that keywords are assigned to the correct campaign types.

# Solution Outline

**Branding Scope Table:**
- Columns: Keyword, Branding Scope (NB/OB/CB dropdown), Relationship (N/R/S/C dropdown), Logs, Actions.
- NB = Non-Branded, OB = Own Brand, CB = Competitor Branded.
- N = Neutral, R = Related, S = Substitute, C = Complementary.
- Inline editable dropdowns. Classification changes feed into campaign naming (NB/OBH/CB prefix).
- Bulk import/export: 4-column CSV (ASIN, Keyword, Branding Scope, Relationship).
- Logs column shows classification change history per keyword.

**Behavior flow:**
1. Seller opens Branding Scope > sees keyword table with current classifications.
2. Seller changes keyword from NB to CB via dropdown > campaign assignment updates.
3. Seller imports 4-column CSV > system validates and applies changes.

# Connected Work Items

**Blocked By:** [PROD-4120](https://keplercommerce.atlassian.net/browse/PROD-4120) (keywords must exist), [PROD-4409](https://keplercommerce.atlassian.net/browse/PROD-4409) (keywords discovered through research)
**Relates To:** [PROD-4126](https://keplercommerce.atlassian.net/browse/PROD-4126) (branding scope drives campaign naming)

# Implementation Notes

- Current data: `GET /amazon-ads/keyword-branding-scope` for keyword branding data. `PUT /amazon-ads/keyword-branding-scope` for updates.
- Export: `GET /amazon-ads/keyword-branding-scope/export/`. Import: `POST /amazon-ads/upload-file` type=kw-branding-scope.
- Model: `KeywordBrandingScope`. Prompt Type: BRANDING_SCOPE=1.
- Dropdown values must match portal exactly. Classification changes should trigger campaign reassignment logic.

# Test Cases

1. Seller opens Branding Scope. Table shows Keyword, Branding Scope, Relationship, Logs, Actions.
2. Seller sets keyword "lavender oil" to NB, Relationship N. Saves.
3. Seller changes keyword from NB to CB. Campaign assignment updates.
4. Seller imports 4-column CSV. System validates and applies.
5. Logs column shows change history for a keyword.

# Acceptance Criteria

- [ ] Table supports NB/OB/CB and N/R/S/C dropdown values matching portal
- [ ] Inline dropdowns save changes immediately
- [ ] Classifications feed into campaign naming convention
- [ ] Bulk import/export uses 4-column CSV
- [ ] Logs column shows classification change history
- [ ] Sorting, filtering, pagination, export
- [ ] Tests passed (unit + integration)
- [ ] UI matches prototype

Prototype: https://mmaazhanif22.github.io/kepler-ads-design/ads-only.html
