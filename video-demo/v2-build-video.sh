#!/bin/bash
# Build V2 demo video: Advertising Section Full Walkthrough
# All frames synced to narration audio clips with crossfade transitions

FFMPEG="C:/Users/fabah/AppData/Local/Microsoft/WinGet/Packages/Gyan.FFmpeg_Microsoft.Winget.Source_8wekyb3d8bbwe/ffmpeg-8.0.1-full_build/bin/ffmpeg.exe"
VDIR="C:/Users/fabah/Advertising Product/kepler-ads-design/video-demo"
FDIR="$VDIR/v2-frames"
FADE=0.4

cd "$VDIR"

# Helper: build a segment from N frames + 1 audio
# Usage: build_scene <scene_num> <audio_file> <frame1:dur> <frame2:dur> ...
build_scene() {
  local num=$1; shift
  local audio=$1; shift
  local frames=("$@")
  local n=${#frames[@]}

  if [ $n -eq 1 ]; then
    # Single frame — just combine with audio
    local img="${frames[0]%%:*}"
    "$FFMPEG" -y -loop 1 -i "$FDIR/$img" -i "$VDIR/$audio" \
      -c:v libx264 -tune stillimage -pix_fmt yuv420p -vf "scale=1920:1080" -r 30 \
      -c:a aac -shortest "$VDIR/v2-seg${num}.mp4" 2>/dev/null
  else
    # Multiple frames — create each sub-segment, concat, add audio
    local parts=""
    local inputs=""
    local count=0
    for fd in "${frames[@]}"; do
      local img="${fd%%:*}"
      local dur="${fd##*:}"
      "$FFMPEG" -y -loop 1 -i "$FDIR/$img" \
        -t "$dur" -c:v libx264 -tune stillimage -pix_fmt yuv420p -vf "scale=1920:1080" -r 30 \
        -an "$VDIR/v2-seg${num}_${count}.mp4" 2>/dev/null
      inputs="$inputs -i $VDIR/v2-seg${num}_${count}.mp4"
      parts="${parts}[${count}:v]"
      count=$((count+1))
    done

    # Concat all parts
    "$FFMPEG" -y $inputs \
      -filter_complex "${parts}concat=n=${count}:v=1:a=0[v]" \
      -map "[v]" -c:v libx264 -pix_fmt yuv420p "$VDIR/v2-seg${num}v.mp4" 2>/dev/null

    # Add audio
    "$FFMPEG" -y -i "$VDIR/v2-seg${num}v.mp4" -i "$VDIR/$audio" \
      -c:v copy -c:a aac -shortest "$VDIR/v2-seg${num}.mp4" 2>/dev/null
  fi
  echo "Scene $num done"
}

# ── Scene 1: Dashboard (25.0s) — 3 frames ──
build_scene "01" "v2-01-dashboard.wav" \
  "01-01-dashboard-kpis.png:9" \
  "01-02-dashboard-ai-recs.png:9" \
  "01-03-dashboard-trends.png:7.02"

# ── Scene 2: Ads Management (21.7s) — 3 frames ──
build_scene "02" "v2-02-ads-mgmt.wav" \
  "02-01-ads-mgmt-overview.png:8" \
  "02-02-campaigns-list.png:7" \
  "02-03-campaign-rows.png:6.69"

# ── Scene 3: KW Automation (26.7s) — 3 frames ──
build_scene "03" "v2-03-kw-automation.wav" \
  "03-01-kw-automation-bsc.png:9" \
  "03-02-listing-attributes.png:9" \
  "03-03-kw-grouping.png:8.69"

# ── Scene 4: Campaign Config (25.7s) — 2 frames ──
build_scene "04" "v2-04-campaign-config.wav" \
  "04-01-campaign-config.png:13" \
  "04-02-config-rows.png:12.69"

# ── Scene 5: Search Terms (30.5s) — 4 frames ──
build_scene "05" "v2-05-search-terms.wav" \
  "05-01-st-settings-active.png:8" \
  "05-02-st-harvest-negate.png:8" \
  "05-03-harvest-queue.png:8" \
  "05-04-negative-kw.png:6.50"

# ── Scene 6: ADS Performance (18.9s) — 3 frames ──
build_scene "06" "v2-06-ads-perf.wav" \
  "06-01-targeting-dashboard.png:7" \
  "06-02-st-dashboard.png:6" \
  "06-03-targeting-records.png:5.92"

# ── Scene 7: Reports (19.2s) — 2 frames ──
build_scene "07" "v2-07-reports.wav" \
  "07-01-report-campaigns.png:10" \
  "07-02-profit-analysis.png:9.17"

# ── Scene 8: Competitor ST (18.4s) — 2 frames ──
build_scene "08" "v2-08-competitor.wav" \
  "08-01-competitor-st.png:10" \
  "08-02-competitor-data.png:8.43"

# ── Scene 9: IBO (31.5s) — 6 frames ──
build_scene "09" "v2-09-ibo.wav" \
  "09-01-ibo-stage1.png:5.5" \
  "09-02-ibo-stage2.png:5.5" \
  "09-03-ibo-stage3.png:5.5" \
  "09-04-ibo-stage4.png:5" \
  "09-05-ibo-stage5.png:5" \
  "09-06-ibo-stage6.png:5.0"

# ── Scene 10: Wizard (22.5s) — 5 frames ──
build_scene "10" "v2-10-wizard.wav" \
  "10-01-wizard-step1.png:4.5" \
  "10-02-wizard-step2.png:4.5" \
  "10-03-wizard-step3.png:4.5" \
  "10-04-wizard-step4.png:4.5" \
  "10-05-wizard-step5.png:4.46"

# ── Scene 11: Closing (26.7s) — 1 frame ──
build_scene "11" "v2-11-closing.wav" \
  "11-01-closing.png:26.70"

echo ""
echo "All scenes built. Concatenating..."

# ── Concatenate all 11 segments ──
cat > "$VDIR/v2-concat.txt" << 'CONCAT'
file 'v2-seg01.mp4'
file 'v2-seg02.mp4'
file 'v2-seg03.mp4'
file 'v2-seg04.mp4'
file 'v2-seg05.mp4'
file 'v2-seg06.mp4'
file 'v2-seg07.mp4'
file 'v2-seg08.mp4'
file 'v2-seg09.mp4'
file 'v2-seg10.mp4'
file 'v2-seg11.mp4'
CONCAT

"$FFMPEG" -y -f concat -safe 0 -i "$VDIR/v2-concat.txt" \
  -c:v libx264 -c:a aac -movflags +faststart \
  "$VDIR/Kepler_Advertising_Section_Full_Demo.mp4" 2>/dev/null

echo ""
echo "=== VIDEO COMPLETE ==="
ls -lh "$VDIR/Kepler_Advertising_Section_Full_Demo.mp4"

# Clean up temp files
rm -f "$VDIR"/v2-seg*_*.mp4 "$VDIR"/v2-seg*v.mp4 "$VDIR/v2-concat.txt"
echo "Temp files cleaned."
