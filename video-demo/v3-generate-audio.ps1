Add-Type -AssemblyName System.Speech
$synth = New-Object System.Speech.Synthesis.SpeechSynthesizer
$synth.SelectVoice('Microsoft Zira Desktop')
$synth.Rate = 2

$outDir = "C:\Users\fabah\Advertising Product\kepler-ads-design\video-demo"

# Narration clips timed to live recording timestamps:
# 0-15s    Dashboard (KPIs, AI recs, trends, products)
# 15-30s   Ads Management (ASIN Overview, Campaigns, Campaign Config)
# 30-41.5s KW Automation (Branding Scope, Listing Attributes, KW Grouping)
# 41.5-56s Search Terms (Active, Harvest/Negate, Queue, Negative KWs, High Perf)
# 56-67s   ADS Performance (Targeting, ST Dashboard, Records)
# 67-75.5s Reports (Campaign, Keywords, Profit Analysis)
# 75.5-81.5s Competitor Search Terms
# 81.5-99.5s IBO all 6 stages
# 99.5-114.5s Wizard Steps 1-5
# 114.5-121.7s Closing

# Each clip must be SHORT — matching the section duration
$clips = [ordered]@{
  "v3-01-dashboard"    = "The Dashboard displays real-time KPIs from the Search Term Report. AI Recommendations connect to bidding analytics endpoints for bid optimization and negative keyword suggestions."
  "v3-02-ads-mgmt"     = "Ads Management shows all campaigns with backend status enums: Enabled, Paused, Manual Edit. Campaign naming follows production conventions with relevancy tags."
  "v3-03-kw-automation" = "Keyword Automation tabs map to backend models. Branding Scope, Listing Attributes, and KW Grouping each have GET, PUT, export, and import endpoints."
  "v3-04-search-terms"  = "Search Terms is the most backend-connected section. Harvest is automatic via the Harvesting Checker. Negate uses bulk update with negative status. The queue shows qualified terms. Negative keywords use soft delete."
  "v3-05-ads-perf"      = "ADS Performance dashboards include Targeting, Search Terms, and Records views. Each supports all eight match types with real export endpoints."
  "v3-06-reports"        = "Reports include Campaign Performance, Keyword Performance, and Profit Analysis. Each has export via dedicated API endpoints."
  "v3-07-competitor"     = "Competitor Search Terms connects to the Analytics app with six endpoints for competitor ASINs, brands, terms, and best sellers data."
  "v3-08-ibo"            = "The Intelligent Batch Orchestrator has six stages, all mapped to production services. From ASIN config through keyword research, campaign configuration, and batch creation via RabbitMQ."
  "v3-09-wizard"         = "The ASIN Setup Wizard implements progressive disclosure across five steps: product selection, keyword config, research, campaign setup, and final review."
  "v3-10-closing"        = "Every advertising feature has been verified against the Kepler codebase. All status enums, match types, and naming conventions align with production."
}

foreach ($key in $clips.Keys) {
  $path = Join-Path $outDir "$key.wav"
  $synth.SetOutputToWaveFile($path)
  $synth.Speak($clips[$key])
  Write-Host "Generated: $key.wav"
}
$synth.SetOutputToDefaultAudioDevice()
$synth.Dispose()
Write-Host "All V3 audio clips generated."
