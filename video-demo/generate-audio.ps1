Add-Type -AssemblyName System.Speech
$synth = New-Object System.Speech.Synthesis.SpeechSynthesizer
$synth.SelectVoice('Microsoft Zira Desktop')
$synth.Rate = 1

$outDir = "C:\Users\fabah\Advertising Product\kepler-ads-design\video-demo"

$clips = [ordered]@{
  "01-intro"      = "Welcome to the Kepler Advertising Portal. Today we will walk through two new features in the Campaign Setup Wizard: Progressive Disclosure, and Contextual Field Guidance."
  "02-section-a"  = "This is Step 4, Campaign Configuration. Notice the page is now split into three progressive sections instead of showing everything at once. Section A is revealed by default. It shows the Configuration Summary with 23 auto-generated campaigns, the Match Type Strategy with a question mark hint icon, and an Apply to All panel for bulk Target ACOS and Daily Budget."
  "03-hints"      = "Notice the blue question mark icons next to each field label. When you hover over them, a tooltip appears with a customer-friendly explanation. For example, Target ACOS shows: Your target Advertising Cost of Sales, typical range 25 to 40 percent. Daily Budget explains the minimum 5 dollar spend. Each hint is written for sellers, not engineers."
  "04-section-b"  = "Clicking Continue to ASIN Settings smoothly reveals Section B. This section contains ASIN-Level Settings and the Auto Pacing toggle, each with their own hint icons. The progress dots at the top update to show your current position in the setup flow."
  "05-section-c"  = "Clicking Continue to Campaign Review reveals the final section. Here you see the full campaign table with all 23 campaigns organized into collapsible groups: 15 manual keyword, 4 auto targeting, and 4 product targeting. Each column header has its own contextual hint icon."
  "06-show-all"   = "Power users can skip the progressive flow entirely by clicking Show All Sections at the top. This instantly reveals everything at once. The sub-wizard resets automatically whenever you re-enter Step 4."
  "07-closing"    = "These features address two key pieces of feedback: reducing Campaign Config overwhelm through progressive disclosure, and providing contextual guidance so sellers understand every field without needing documentation. Thank you for watching."
}

foreach ($key in $clips.Keys) {
  $path = Join-Path $outDir "$key.wav"
  $synth.SetOutputToWaveFile($path)
  $synth.Speak($clips[$key])
  Write-Host "Generated: $key.wav"
}
$synth.SetOutputToDefaultAudioDevice()
$synth.Dispose()
Write-Host "All audio clips generated."
