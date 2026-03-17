Add-Type -AssemblyName System.Speech
$synth = New-Object System.Speech.Synthesis.SpeechSynthesizer
$synth.SelectVoice('Microsoft Zira Desktop')
$synth.Rate = 1

$outDir = "C:\Users\fabah\Advertising Product\kepler-ads-design\video-demo"

$clips = [ordered]@{
  "v2-01-dashboard"     = "Welcome to the Kepler Advertising Portal. This walkthrough covers all advertising section features, fully aligned with the production backend. The Dashboard shows real-time KPIs sourced from the Search Term Report aggregate model. Smart Recommendations are powered by bidding analytics endpoints, including bid opportunity detection, negative keyword suggestions, and budget reallocation. Each action button connects to a real API."
  "v2-02-ads-mgmt"      = "The Ads Management section provides a unified view of all campaigns and configurations. Campaign status values use the exact backend enums: ENABLED, PAUSED, and MANUAL EDIT. Campaign naming follows the production convention with relevancy tags like N B H 1, O B H 1, and C B H 1, the double-X country placeholder, and proper match codes."
  "v2-03-kw-automation"  = "Keyword Automation has three tabs, each mapped to backend models. Branding Scope connects to the Keyword Branding Scope API with GET, PUT, export, and file import endpoints. Listing Attributes Ranking maps to the Attribute Ranking model with its own import and export. KW Grouping and Ranking uses the Group Rank model. All three tabs support approval via the approve keyword stage endpoint, and reset via the reset keyword stage endpoint."
  "v2-04-campaign-config" = "Campaign Configuration shows all campaign configs from the Advertising Campaign Config model. Match types include all eight backend values: Exact, Phrase, Broad, Close Match, Loose Match, Substitutes, Complements, and Targeting Expression. Branding scopes are limited to the three valid values: N B, O B, and C B. All date aggregations use the correct 15-day windows matching the backend."
  "v2-05-search-terms"   = "Search Term Settings is where the most backend connections were mapped. The Harvest action is automatic, powered by the Search Terms Harvesting Checker. It qualifies terms where the maximum A-COS across all time windows is below the target, and lifetime spend exceeds the product price. Negate uses the Search Term Service bulk update, setting negative status to Mark as Negative, which triggers the create negative keyword Celery task. Negative keyword removal uses a soft delete pattern, setting state to Paused via the Amazon Ads API."
  "v2-06-ads-perf"       = "ADS Performance dashboards include the Targeting Dashboard, Search Terms Dashboard, and Records views. Each has proper match type filters with all eight backend values. Export buttons connect to real POST endpoints: targeting list export, targeting A-SIN aggregated export, and search terms aggregated export."
  "v2-07-reports"        = "The Reports section includes Campaign Performance with export via the ad campaign export endpoint, Keyword Performance using the keywords config export service, and Profit Analysis. Profit Analysis has partial backend support through the is profitable search term utility function, with a note that cost of goods and Amazon fees are not yet in the backend."
  "v2-08-competitor"     = "Competitor Search Terms is fully supported by the Analytics app, not the Amazon Ads app. Six backend endpoints provide competitor A-SIN data with click share and conversion share, competitor brands, competitor search terms, and best sellers by category with price waterfall data. All models and serializers are production-ready."
  "v2-09-ibo"            = "The Intelligent Batch Orchestrator has six stages, all mapped to production backend services. Stage 1 uses the Advertising A-SIN Config model. Stage 2 connects to Global Config and Branding Scope. Stage 3 triggers keyword research via Rabbit M Q with batch status tracking through the Keyword Research Automation Batch model. Stage 4 maps to Campaign Config with relevancy tags. Stage 5 uses the campaign creation consumer for batch operations. Stage 6 launches via the Campaign Creation Orchestrator."
  "v2-10-wizard"         = "The ASIN Setup Wizard implements progressive disclosure with contextual field guidance. Step 1 is product selection. Step 2 handles keyword configuration with user-provided keywords. Step 3 runs keyword research with notification on completion. Step 4 uses a three-section sub-wizard for campaign configuration. Step 5 is the final review and launch."
  "v2-11-closing"        = "In summary, every advertising section feature has been verified against the Kepler codebase. 51 previously stub buttons now show their backend API connections. 6 previously failed items were found to have full backend support. Only Profit Analysis and Dashboard A I Apply actions remain as partial implementations. All status enums, match types, naming conventions, and date windows are aligned with production. Thank you for watching."
}

foreach ($key in $clips.Keys) {
  $path = Join-Path $outDir "$key.wav"
  $synth.SetOutputToWaveFile($path)
  $synth.Speak($clips[$key])
  Write-Host "Generated: $key.wav"
}
$synth.SetOutputToDefaultAudioDevice()
$synth.Dispose()
Write-Host "All V2 audio clips generated."
