# APZR Story Tickets: Quick Reference

**Epic:** PROD-2180 (UI/UX Modernization & Redesign)

| # | PROD ID | Story Name | Type |
|---|---------|------------|------|
| 9 | PROD-4128 | UX Infrastructure & Accessibility: Shared Patterns | Task (sequenced FIRST) |
| 1 | PROD-4120 | ASIN Advertising Setup Wizard: 5-Step Guided Flow | Story |
| 2 | PROD-4121 | Intelligent Batch Orchestrator (IBO): Bulk ASIN Launch (100% net-new) | Story |
| 3 | PROD-4122 | Manage Ads: ASIN Overview & Navigation Restructure | Story |
| 4 | PROD-4123 | Advertising Dashboards & Performance Intelligence | Story |
| 5 | PROD-4124 | Keyword Settings: Full Portal Parity with Enhancements (72 cols, rebuild) | Story |
| 6A | PROD-4125 | Search Term Settings (Story A): Active Search Terms Table (105 cols, rebuild) | Story |
| 6B | TBD | Search Term Workflow Tabs (Story B): Harvest Queue, Negative Keywords, High Performers (net-new UI, backend exists) | Story |
| 7A | PROD-4126 | Campaign List & Config (Story A): 20-column list + 10-column config (rebuild + enhancements) | Story |
| 7B | TBD | Keyword Research (Story B): 16 visible + 10 Jungle Scout columns (rebuild) | Story |
| 7C | TBD | Branding Scope (Story C): NB/OB/CB classification with import/export (rebuild) | Story |
| 8A | PROD-4127 | Pacing Management (Story A): Campaign pacing dashboard with Auto Pacing controls | Story |
| 8B | TBD | Bid Optimization (Story B): Keyword-level bid change monitoring with override | Story |
| 8C | TBD | Config Change Log (Story C): Aggregated human-readable event audit trail | Story |

**Prototype:** [https://mmaazhanif22.github.io/kepler-ads-design/ads-only.html](https://mmaazhanif22.github.io/kepler-ads-design/ads-only.html)

## Sequencing Notes

- **PROD-4128 (Story 9)** must be delivered first. All table-heavy stories (5, 6A, 6B, 7A, 7B, 7C) depend on shared infrastructure.
- **PROD-4120 (Story 1)** and **PROD-4121 (Story 2)** can run in parallel. Both are entry points for ASIN advertising setup.
- **PROD-4122 (Story 3)** depends on Story 1 for wizard resume/edit functionality.
- **Stories 6B, 7B, 7C, 8B, 8C** are split stories that need new PROD IDs assigned.

## Terminology

- "Manage Ads" (not "ASIN Overview", not "Ads Management", not "Campaign Management")
- "Automated Keyword Research" (not "Keyword Automation")
- Campaign naming: NB=`NBH1-SPKW-PB01-{Country}-S-{ASIN}-{Match}-KW`, OBH=`OBH1-...`, CB=`CBR1-...`
