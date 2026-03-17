# Advertising Portal UI Prototype -- Structured Audit Report

**File**: `C:\Users\fabah\Advertising Product\kepler-ads-design\Advertising Portal UI Design.html`
**Date**: 2026-02-27
**Scope**: ASIN Launch Wizard (Steps 1-6), ACG Create Listing Wizard (Steps 1-5), Campaign Management tabs, and supporting JavaScript

---

## P1: BROKEN / NON-FUNCTIONAL INTERACTIONS

### P1-01. Malformed HTML -- Double `<tbody>` in KWs Config Table
**Location**: Line 2453
**What's wrong**: A second `<tbody>` tag opens at line 2453 without the first `<tbody>` (opened at line 2426) being closed. The first `<tbody>` wraps Row 1, then a new `<tbody>` opens for Rows 2-9. This is invalid HTML. While browsers are forgiving, it causes the `querySelectorAll('#kwConfigTable tbody tr')` selector used by `filterTable()` and `markRowDirty()` to potentially target rows in unexpected ways, and any "select all" checkbox logic operating on `tbody` descendants will only affect one of the two tbody groups.
**Recommended fix**: Remove the extra `<tbody>` tag at line 2453. All rows should be in a single `<tbody>` block opened at line 2426 and closed at line 2637.

---

### P1-02. Wizard Step 4 Uses Two Different KW Tab Systems Simultaneously
**Location**: Lines 9033-9060 (`switchKwTab`/`submitKwTab` functions) and lines 9282-9360 (`switchKwrTab`/`kwrFilter`/`kwrSelectAll`/`kwrApproveAll` functions)
**What's wrong**: Step 4 declares two completely separate tab switching systems:
1. `switchKwTab(n)` / `submitKwTab(n)` -- operates on `kwTabPanel1/2/3` and `kwt1btn/2btn/3btn` (the Branding/Listing/Grouping tabs from the KW Automation section).
2. `switchKwrTab(tabId)` / `kwrFilter` / `kwrSelectAll` -- operates on `kwr-exact/broad/phrase` panes with `kwt-exact/broad/phrase` buttons (the keyword review tabs within wizard Step 4).

These are separate UI flows for different purposes, but both coexist in Step 4. The `kwTabApproved` gating (which blocks progress at Step 4 until all 3 tabs are approved via `submitKwTab`) operates on the first system (Tabs 1/2/3), while the visible keyword review UI uses the second system (Exact/Broad/Phrase). The user must approve via `submitKwTab(1/2/3)` to proceed, but the visible Step 4 content shows the Exact/Broad/Phrase review with no obvious connection to those approval buttons. If the HTML for Step 4 was designed to show the `kwTabPanel1/2/3` panels (the branding/listing/grouping tabs) alongside or instead of the keyword review panels, the two systems conflict.

**Recommended fix**: Clarify the Step 4 architecture. If Step 4 is meant to show the KW Review (Exact/Broad/Phrase), then the gate condition in `updateWizFooter(4)` should check whether keywords have been reviewed and approved through the KWR system, not the KW Automation tab system. If Step 4 is meant to present Tabs 1/2/3, remove the `kwr-*` tab system from Step 4. Currently the user cannot tell which actions actually advance them.

---

### P1-03. `wizConfirmClose()` Does Not Auto-Save Draft
**Location**: Line 8753-8758
**What's wrong**: The confirm dialog says "Your progress will be saved as a draft" but `wizConfirmClose()` calls `closeWizard()` directly without calling `saveDraft()`. The user is told their progress is saved but it is silently discarded.
**Recommended fix**: Call `saveDraft()` before `closeWizard()` inside `wizConfirmClose()`:
```javascript
function wizConfirmClose() {
  if (wizStep > 1) {
    if (!confirm('Leave ASIN Launch? Your progress will be saved as a draft.')) return;
    saveDraft();
  }
  closeWizard();
}
```

---

### P1-04. Step 5 Campaign Table Hardcoded -- Does Not Reflect Step 4 Outcomes
**Location**: Lines 7327-7403 (wizCampTable HTML)
**What's wrong**: The campaign table in Step 5 shows 9 hardcoded campaign rows. These campaigns should be dynamically generated based on the keyword groups approved in Step 4 (Tab 3 shows "7 groups -> 9 campaigns"). But the table is static HTML -- if the user changed keyword groupings or scopes in Step 4, the Step 5 table would not reflect those changes. This breaks the wizard's premise of a linear cause-and-effect flow.
**Recommended fix**: Either (a) generate Step 5 campaign rows dynamically from Step 4 tab 3 data when entering Step 5, or (b) at minimum display a note: "Campaigns below are generated from your approved keyword groups." For the prototype, option (b) is acceptable but the discrepancy should be documented as a known limitation.

---

### P1-05. `saveDraft()` References Non-Existent Input `asinDailyBudget`
**Location**: Line 8766
**What's wrong**: `saveDraft()` reads `document.getElementById('asinDailyBudget')?.value` but no element with `id="asinDailyBudget"` exists anywhere in the HTML. The ASIN Config check panel in Step 1 only has `asinTargetAcos` and the status toggle. This means drafts never persist the daily budget field -- even though the user may have configured it.
**Recommended fix**: Either remove this line from `saveDraft()` if daily budget is not set in Step 1, or add the budget field to the ASIN Config panel and give it `id="asinDailyBudget"`.

---

### P1-06. Campaign Config Tab `markRowDirty()` Not Wired on All Editable Fields
**Location**: Lines 2193-2290 (campConfigTable)
**What's wrong**: In the Campaign Config table, `oninput="markRowDirty(this)"` is attached only to the Daily Budget `<input>` fields. The Target ACOS inputs, Relevancy Tag inputs, Negative KWs textareas, and Status toggles do not trigger `markRowDirty()`. This means changes to those fields never show the "unsaved changes" submit bar, and clicking "Submit Config Changes" would not capture them.
**Recommended fix**: Add `oninput="markRowDirty(this)"` to every editable field in the Campaign Config table: Target ACOS inputs, Relevancy Tag inputs, Negative KWs textareas, and Status toggle `onclick` handlers.

---

### P1-07. ACG Wizard Step Navigation Allows Arbitrary Forward Jumping
**Location**: Lines 9621-9628 (`acgGoToStep`) and line 9530 (step dot `onclick="acgSetStep(1)"`)
**What's wrong**: Step 1's stepper dot calls `acgSetStep(1)` (which is an alias for `acgRenderStep` -- no guard), while steps 2-5 call `acgGoToStep(n)` which guards against forward jumps. But `acgSetStep()` has no guard at all -- it directly calls `acgRenderStep(n)`. If any stepper dot's onclick were changed to `acgSetStep(n)`, it would allow jumping forward past incomplete steps. While currently only Step 1's dot uses `acgSetStep`, the inconsistency is a bug waiting to happen.
**Recommended fix**: Remove `acgSetStep()` entirely. Change Step 1's dot to use `acgGoToStep(1)` like all other steps.

---

### P1-08. ACG Wizard Has No Validation Before Step Advancement
**Location**: Lines 9630-9640 (`acgNext`)
**What's wrong**: `acgNext()` advances to the next step unconditionally. There is no validation that:
- Step 1 required fields (Market, MSKU, Product Category, Product Name, Description, 3 Key Features) are filled
- Step 2 has at least 1 search term selected
- Step 3 has at least 1 competitor selected
- Step 4 has at least 1 USP approved

A user can click through all 5 steps without entering or selecting anything.
**Recommended fix**: Add per-step validation in `acgNext()`. Disable the Next button until minimum requirements are met, or show inline errors.

---

## P2: MAJOR UX FRICTION OR MISSING KEY AFFORDANCES

### P2-01. Wizard Step 3 "Generate Research" is a Dead-End Wait With No Cancel
**Location**: Lines 9007-9031 (`generateResearch`)
**What's wrong**: Clicking "Generate Research" starts a 5-second simulated process with no way to cancel. The button is disabled, a spinner runs, and status messages cycle. If the user realizes they need to go back and change competitors, they must wait for the full animation. The 5 seconds is bearable in a prototype, but in production this could be 30+ seconds.
**Recommended fix**: Add a "Cancel" button next to the spinner. On cancel, reset `kwResearchDone = false`, hide the status panel, re-enable the Generate button.

---

### P2-02. Wizard Lacks Ability to Edit Completed Steps Without Linear Regression
**Location**: Lines 8904-8908 (`wizardNext`/`wizardBack`) and 8802-8810 (`updateWizProgress`)
**What's wrong**: The stepper header (ws1-ws6) shows completed/active states but the step dots are not clickable. Users can only navigate with Next/Back buttons. If a user on Step 5 wants to change a competitor from Step 2, they must click Back four times through Steps 4, 3, and 2. Every real wizard in Amazon Ads, Shopify, or similar tools allows clicking completed step dots to jump back.
**Recommended fix**: Make completed wizard steps clickable. Add `onclick="goToStep(n)"` to each `.wiz-step` element, guarded to only allow jumping to steps <= current highest completed step.

---

### P2-03. No Confirmation Dialog Before Completing Setup
**Location**: Lines 8910-8927 (`completeSetup`)
**What's wrong**: Clicking "Complete Setup & Go to Campaigns" immediately creates campaigns on Amazon (as described by the toast). There is no confirmation dialog. This is a destructive action -- campaigns go live with real money spent. Every ad platform shows a final "Are you sure?" modal before activating live campaigns.
**Recommended fix**: Add a `confirm()` dialog or a dedicated confirmation modal before `showToast('Setup complete! Campaigns are being activated on Amazon.')`.

---

### P2-04. Step 6 Launch Checklist Item 9 is Hardcoded to `true`
**Location**: Line 8988
**What's wrong**: The launch checklist renders item 9 as `{ label: 'Campaign ACOS and budgets configured (Step 5)', ok: true }` -- it is always checked regardless of whether the user actually filled in Step 5 fields. This defeats the purpose of a pre-launch checklist.
**Recommended fix**: Compute this value dynamically, matching the Step 5 validation logic:
```javascript
{
  label: 'Campaign ACOS and budgets configured (Step 5)',
  ok: (() => {
    let valid = true;
    document.querySelectorAll('#wizStep5 table tbody tr').forEach(row => {
      row.querySelectorAll('input[type="number"]').forEach(inp => {
        if (!inp.value || parseFloat(inp.value) <= 0) valid = false;
      });
    });
    return valid;
  })()
}
```

---

### P2-05. Campaign Management Tab Bar is Hidden But Required for Navigation
**Location**: Lines 1507-1515 (tab bar HTML, `aria-hidden="true"`) and sidebar `nav-sub` items
**What's wrong**: The comment says "Tab Bar (hidden -- sidebar is sole nav)" and the bar has `aria-hidden="true"`. The sidebar sub-items navigate to the correct tabs. However, the tab bar buttons still have `onclick="switchTab('main','...')"` handlers and visual `active` states. This means the tab bar is an invisible but functional DOM element. Screen readers will skip it due to `aria-hidden`, but sighted users may be confused if they ever see it flash during rendering. More critically, the sidebar navigation items for KWs Automation sub-tabs (Branding, Listing Attributes, KW Grouping) need their own `onclick` handlers to switch both the main tab to `kw-automation` AND the sub-tab -- but the HTML only shows sidebar `nav-sub` items calling `navigate('campaigns', 'nav-kwauto')`. The sub-tab switching would need extra logic.
**Recommended fix**: Either remove the tab bar entirely and wire all navigation through the sidebar, or make the tab bar visible as a secondary navigation aid. The current hybrid is fragile.

---

### P2-06. Wizard Overlay Does Not Block Background Scrolling
**Location**: Line 6811 (wizOverlay) and CSS lines 397-400
**What's wrong**: When the ASIN Launch wizard or ACG wizard is open, the background page behind the overlay remains scrollable. On mobile or small viewports, users can inadvertently scroll the main content behind the modal, which is disorienting and breaks the modal's focus trap intent.
**Recommended fix**: Add `document.body.style.overflow = 'hidden'` in `openWizard()` and `openAcgWizard()`, and restore `document.body.style.overflow = ''` in `closeWizard()` and `closeAcgWizard()`.

---

### P2-07. "Already Active" ASIN Warning Detection Logic is Fragile
**Location**: Lines 9083-9094 (inside `selectProduct`)
**What's wrong**: The warning for already-active ASINs relies on `el.querySelector('.badge.b-orange') !== null`. This is CSS-class-based detection. If the badge class is changed for any reason (styling update, theme), the check silently breaks. Also, the HTML product rows at lines 6880-6910 show Eligible/Ineligible badges but no orange badge at all -- meaning the already-active warning can never trigger for any of the prototype products.
**Recommended fix**: Use a `data-active="true/false"` attribute on product rows and check that instead. Or add at least one product with a `b-orange` badge to demonstrate the warning.

---

### P2-08. KWs Config Table -- Bulk Action Buttons Are Non-Functional
**Location**: Lines 2386-2392 (kwBulkBar)
**What's wrong**: The bulk action bar shows buttons for Pause, Resume, Set Bid Ceiling, Set Bid Floor, and Delete -- but none have `onclick` handlers. They are pure HTML with no JS. Selecting keywords via checkboxes correctly shows the bar (via `countKwSelected()`), but clicking any action does nothing.
**Recommended fix**: Add `onclick` handlers for each bulk action. At minimum for the prototype, wire them to `showToast('Bulk [action] applied to N keywords')`.

---

### P2-09. ACG Wizard "selected count" Badge Does Not Update
**Location**: Line 7660 (`<span class="badge b-blue" style="font-size:11px">10 selected</span>`)
**What's wrong**: The Step 2 search terms table shows "10 selected" as a static badge. Checking/unchecking rows does not update this count. The checkboxes have no `onchange` handlers.
**Recommended fix**: Add an `onchange` handler to each checkbox (and the select-all header checkbox) that recomputes and updates the badge text.

---

### P2-10. ACG Wizard Competitor Step Shows Static "4 selected" Count
**Location**: Line 7694
**What's wrong**: Same issue as P2-09. The "4 selected" text is hardcoded. Checking/unchecking competitor checkboxes does not update the count.
**Recommended fix**: Same as P2-09 -- add dynamic count update on checkbox change.

---

### P2-11. Wizard Step 1 -- "Show All" Toggle References Missing Element on Non-PuroSentido Products
**Location**: Line 9108 (`filterProducts`)
**What's wrong**: `filterProducts()` reads `document.getElementById('showAll').checked`. If the checkbox with `id="showAll"` is missing from the DOM (it is present in the HTML, but if removed during iteration), this throws an error. More importantly, the Show All toggle and search filter only operate on the product rows visible in the wizard's Step 1 panel. There are only 5 products hardcoded -- for a real seller with hundreds of ASINs, this list would need virtualized scrolling or server-side pagination. The prototype gives no indication of this scalability need.
**Recommended fix**: Add a note in the prototype indicating "Showing 5 of N products -- search to filter" for verisimilitude. The `showAll` checkbox works but the product list needs to clearly indicate it is a filtered subset.

---

## P3: POLISH, CONSISTENCY, AND ENHANCEMENT OPPORTUNITIES

### P3-01. Inconsistent Toggle Component Patterns
**Location**: Throughout the file
**What's wrong**: Three different toggle patterns are used:
1. `.toggle` / `.toggle.on` class (KWs Config table, line 2450) -- uses `classList.toggle('on')` and `aria-checked`
2. `.tog-switch` / `.tog-on` class (Step 6 master toggle, line 7454) -- uses `classList.toggle('tog-on')`
3. Direct `aria-checked` flip on `.toggle` buttons (Campaign Config, line 2201)

These three patterns have different CSS rules, different JS toggle logic, and different visual designs. A user cannot predict toggle behavior.
**Recommended fix**: Standardize on one toggle component. Recommend the `.tog-switch` / `.tog-on` pattern with `aria-checked` for accessibility. Replace all others.

---

### P3-02. Mock Data Mismatch Between Wizard Products and Campaign Config ASINs
**Location**: Lines 6840-6910 (wizard product list: B09L4KWX6Q, B0BF8PNNJH, B0B4Z3DVVX, etc.) vs. Lines 2193-2290 (campaign config: B0BHZXP3MS, B08N5WRWNW, B07THHQMHM)
**What's wrong**: The wizard's ASIN list shows PuroSentido fragrance products. The Campaign Config and KWs Config tables show entirely different ASINs (B0BHZXP3MS "Burt's Bees Chapstick", Echo Dot, etc.). This creates a jarring disconnect -- the wizard sets up campaigns for one product universe, but all management tabs show a different universe. Anyone evaluating the prototype end-to-end will notice this immediately.
**Recommended fix**: Align the mock data. Use the same ASINs across the wizard and all management tabs. Ideally, the wizard's newly created campaigns should appear in the Campaign Config tab after completion.

---

### P3-03. Benchmark Scorecard Data Shows Entity B088FYX5R7 Which Is Not in the ASIN List
**Location**: Lines 8047-8060 (BSC_DATASETS.asin: B088FYX5R7, B088FZ8TN9, B0DKGD4DSM)
**What's wrong**: The Benchmark Scorecard data uses ASINs B088FYX5R7, B088FZ8TN9, and B0DKGD4DSM, none of which appear in either the wizard product list or the Campaign Config tables. This is a third set of mock ASINs, further fragmenting the prototype narrative.
**Recommended fix**: Use one consistent set of 3-5 ASINs across all sections: wizard, campaigns, KW config, scorecard, and reports.

---

### P3-04. Campaign Config Table -- "Showing 1-8 of 410 campaigns" Pagination is Non-Functional
**Location**: Lines 2294-2304
**What's wrong**: Pagination buttons are static. Clicking page numbers, next/prev arrows does nothing. The "52 pages" indicator is hardcoded.
**Recommended fix**: For the prototype, wire the pagination buttons to `showToast('Page N loaded')` or at minimum add `cursor:pointer` and `onclick` handlers. Non-interactive pagination in a data-heavy SaaS tool is conspicuous.

---

### P3-05. `submitDirtyRows()` Fakes Submit Without Feedback on What Changed
**Location**: Lines 8916-8922
**What's wrong**: `submitDirtyRows()` clears dirty state and shows "Changes submitted successfully" but does not indicate which rows were changed, what values were submitted, or provide undo capability. In a real product this would be an API call, but even for the prototype, the toast should say "N changes submitted" to match the submit bar's "N unsaved changes" message.
**Recommended fix**: Change the toast to include the count: `showToast(count + ' changes submitted successfully')`.

---

### P3-06. Step 5 "Advanced Bidding Settings" Uses `<details>` With No Persistence
**Location**: Lines 7417-7435
**What's wrong**: The Advanced Bidding Settings section uses native `<details>`/`<summary>`. Values entered in Bid Ceiling, Bid Floor, and Negative Keywords inputs are not read by any function -- they are not saved in `saveDraft()`, not validated in `updateWizFooter(5)`, and not shown in the Step 6 launch checklist. They are decorative-only.
**Recommended fix**: Either wire these fields into the wizard state (include in `saveDraft()`, show in Step 6 checklist) or remove them. Displaying inputs that are silently ignored is worse than not showing them.

---

### P3-07. ACG Wizard -- No Dirty State or Unsaved Changes Warning on Step 1
**Location**: Lines 9561-9566 (`acgConfirmClose`)
**What's wrong**: `acgConfirmClose()` shows a confirm dialog only when `acgStep > 1`. But Step 1 has extensive form fields (Market, MSKU, ASIN, Brand, Product URL, Category, Name, Description, 3 Features). If a user fills out all of Step 1 and closes, there is no warning and all data is lost.
**Recommended fix**: Track dirty state for Step 1 fields. Show the confirmation dialog if any Step 1 field has been modified, regardless of step number.

---

### P3-08. Step 5 Match Type Checkboxes -- Broad is Unchecked by Default With No Explanation
**Location**: Line 7294 (`id="mtBroad"` -- no `checked` attribute)
**What's wrong**: Exact, Phrase, and Auto are checked by default, but Broad is unchecked. This silently PAUSEs all Broad match campaigns. There is no tooltip or explanation for why Broad is excluded. A user unfamiliar with match type strategy will not understand why some campaigns start paused.
**Recommended fix**: Add a brief explanation next to the match type row: "Broad unchecked by default -- recommended for launch phase to control spend. Enable when ready to scale." Or add a tooltip on the Broad checkbox.

---

### P3-09. Multiple Submit Buttons in Campaign Config -- Ambiguous Hierarchy
**Location**: Lines 2164 (top-right "Submit Config Changes") and 2171 (submit bar "Submit Config Changes")
**What's wrong**: There are two identical "Submit Config Changes" buttons -- one in the top action bar (always visible) and one in the floating submit bar (visible only when dirty rows exist). The top button does nothing when clicked (no `onclick` handler). The submit bar button calls `submitDirtyRows('campConfigTable')`. Users will likely click the always-visible top button first and be confused when nothing happens.
**Recommended fix**: Wire the top button to `submitDirtyRows('campConfigTable')` as well, or remove it and rely solely on the submit bar.

---

### P3-10. ACG Wizard Step Dots -- Cursor Inconsistency
**Location**: Lines 7530-7553 (ACG stepper)
**What's wrong**: Step 1's dot has `cursor:pointer`, Steps 2-5 have `cursor:default`. After completing Step 1, the Step 1 dot becomes clickable (via `acgGoToStep(1)`) but shows pointer cursor from the start. Steps 2-5 become clickable after completion but never get pointer cursor.
**Recommended fix**: Dynamically set `cursor:pointer` on completed/active steps and `cursor:default` on future steps in `acgRenderStep()`.

---

### P3-11. ASIN Launch Wizard -- No Loading State After "Complete Setup"
**Location**: Line 8925
**What's wrong**: After passing validation, `completeSetup()` immediately shows a toast and closes the wizard. There is no loading spinner, no simulated delay, no "Creating campaigns on Amazon..." state. For a real API call, this would take several seconds. The instant close feels disconnected from the gravity of the action (creating 9 live campaigns).
**Recommended fix**: Add a brief simulated loading state: disable the button, show a spinner, wait 1.5-2 seconds, then toast and close.

---

### P3-12. Global Search -- Incomplete Searchable Items
**Location**: Lines 9474-9484 (searchable array)
**What's wrong**: The global search index only covers 10 items. Major sections are missing: ADS Performance, Logs & Analysis, APDC Diagnostics, Benchmark Scorecard, Bid Optimization, Keyword Bid Status, Upload History, Pacing Management, Analytics, Account Management, Security & Audit, Internal Tools. These are all defined in the `navigate()` function's title map (lines 8610-8627) but not in the search index.
**Recommended fix**: Add all navigable sections to the `searchable` array.

---

### P3-13. Wizard Footer Layout -- "Save Draft" Button Left-Aligned, "Next" Right-Aligned Creates Split Attention
**Location**: Lines 7494-7506 (wiz-footer)
**What's wrong**: The footer has Save Draft on the far left and Back/Next on the far right with the info text between them. On wide screens, the two action zones are very far apart. The `wizStepInfo` text sits between them with no visual anchor. This layout works on narrow modals but the wizard is a full-screen overlay.
**Recommended fix**: Group all footer actions on the right side. Move Save Draft next to Back. The info text can sit to the left of the action group.

---

### P3-14. KWs Config Table -- "..." (More Actions) Button Has No Dropdown
**Location**: Lines 2451, 2478, etc. (every keyword row's last cell)
**What's wrong**: Each row has a `<button class="btn btn-ghost btn-xs">...</button>` that suggests a contextual menu. Clicking it does nothing -- no dropdown, no tooltip, no action.
**Recommended fix**: Wire to a dropdown showing contextual actions (View History, Negate, Clone to Another Campaign, etc.) or remove the button.

---

### P3-15. Wizard Step 2 Competitor Chips -- No Drag-Reorder or Priority Indication
**Location**: Lines 9143-9167 (`renderCompList`)
**What's wrong**: Competitor chips are rendered in insertion order with no ability to reorder. The Step 3 research step might weight competitors differently based on order or priority, but the user has no way to indicate which competitor is most relevant.
**Recommended fix**: Add a visual cue like "Most similar" for the first competitor, or add a simple drag handle to reorder.

---

### P3-16. Step 6 "Kepler Bid Optimization" Toggle CSS State Not Visually Reflected
**Location**: Line 7454 (masterOptimizeBidTog)
**What's wrong**: The toggle uses `.tog-switch.tog-on` CSS to show the active state (orange background, slider right). The `onclick` handler toggles `tog-on` class. However, the inner `<div>` (slider) positioning is controlled by CSS `.tog-switch.tog-on > div { left:19px }` -- this works. But the default state at line 7454 has `background:var(--border)` inline, which conflicts with the `.tog-on` CSS rule that sets `background:var(--primary)`. The inline style has higher specificity and could override the class-based style depending on browser behavior. Testing confirms it works because CSS `!important` is used on the `.tog-on` rule (line 116), but relying on `!important` to override inline styles is fragile.
**Recommended fix**: Remove the inline `background:var(--border)` from the toggle element. Let the CSS class handle both states cleanly.

---

## SUMMARY TABLE

| Priority | Count | Description |
|----------|-------|-------------|
| P1       | 8     | Broken interactions, data inconsistencies, silent failures |
| P2       | 11    | Major friction, missing affordances, validation gaps |
| P3       | 16    | Polish, consistency, enhancement opportunities |
| **Total**| **35**| |

### Top 5 Fixes by Impact (recommended order):

1. **P1-03**: `wizConfirmClose` not saving drafts -- trust violation, easy fix
2. **P1-01**: Double `<tbody>` -- silent DOM corruption, one line delete
3. **P1-06**: Campaign Config dirty tracking incomplete -- data loss on submit
4. **P2-03**: No confirmation before going live -- money at stake
5. **P1-08**: ACG wizard zero validation -- wizard has no integrity without it

---

## CROSS-CUTTING OBSERVATIONS

### Mock Data Fragmentation
The prototype uses at least three distinct ASIN universes:
- Wizard: B09L4KWX6Q, B0BF8PNNJH, B0B4Z3DVVX (PuroSentido fragrance oils)
- Campaign/KW Config: B0BHZXP3MS, B08N5WRWNW, B07THHQMHM (Burt's Bees, Echo Dot, etc.)
- Benchmark Scorecard: B088FYX5R7, B088FZ8TN9, B0DKGD4DSM (Lumbar Brace, Posture Corrector, Desk Pillow)

For any demo or stakeholder review, this immediately undermines credibility. Unifying to one ASIN set should be a high-priority task.

### State Architecture
The wizard's state management uses global variables (`wizStep`, `selectedAsin`, `competitors`, `kwResearchDone`, `kwTabApproved`). There is no centralized state object. The `saveDraft()` function manually picks specific fields. This means any new wizard state (e.g., Step 5 Advanced Bidding values, Step 4 keyword review selections) requires manual additions to both `saveDraft()` and `openWizard()` draft restoration. In a React/Next.js implementation, this should be a single wizard context or Zustand store.

### Accessibility Gaps
- Wizard overlay traps focus (`trapFocus()`) but the trap function is called via `setTimeout` which is unreliable
- Toggle buttons use `role="switch"` and `aria-checked` in KWs Config but not in Campaign Config or the wizard
- Step 4 keyword review rows have no ARIA labels for screen readers
- ACG wizard stepper dots use `onclick` on divs with no `role="button"` or `tabindex="0"`
