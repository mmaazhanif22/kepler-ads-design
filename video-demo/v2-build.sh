#!/bin/bash
FFMPEG="C:/Users/fabah/AppData/Local/Microsoft/WinGet/Packages/Gyan.FFmpeg_Microsoft.Winget.Source_8wekyb3d8bbwe/ffmpeg-8.0.1-full_build/bin/ffmpeg.exe"
VDIR="C:/Users/fabah/Advertising Product/kepler-ads-design/video-demo"
F="$VDIR/v2-frames"
cd "$VDIR"

mk() { "$FFMPEG" -y -loop 1 -i "$1" -t "$2" -c:v libx264 -tune stillimage -pix_fmt yuv420p -vf "scale=1920:1080" -r 30 -an "$3" 2>/dev/null; }
cat2() { "$FFMPEG" -y -i "$1" -i "$2" -filter_complex "[0:v][1:v]concat=n=2:v=1:a=0[v]" -map "[v]" -c:v libx264 -pix_fmt yuv420p "$3" 2>/dev/null; }
cat3() { "$FFMPEG" -y -i "$1" -i "$2" -i "$3" -filter_complex "[0:v][1:v][2:v]concat=n=3:v=1:a=0[v]" -map "[v]" -c:v libx264 -pix_fmt yuv420p "$4" 2>/dev/null; }
cat4() { "$FFMPEG" -y -i "$1" -i "$2" -i "$3" -i "$4" -filter_complex "[0:v][1:v][2:v][3:v]concat=n=4:v=1:a=0[v]" -map "[v]" -c:v libx264 -pix_fmt yuv420p "$5" 2>/dev/null; }
cat5() { "$FFMPEG" -y -i "$1" -i "$2" -i "$3" -i "$4" -i "$5" -filter_complex "[0:v][1:v][2:v][3:v][4:v]concat=n=5:v=1:a=0[v]" -map "[v]" -c:v libx264 -pix_fmt yuv420p "$6" 2>/dev/null; }
cat6() { "$FFMPEG" -y -i "$1" -i "$2" -i "$3" -i "$4" -i "$5" -i "$6" -filter_complex "[0:v][1:v][2:v][3:v][4:v][5:v]concat=n=6:v=1:a=0[v]" -map "[v]" -c:v libx264 -pix_fmt yuv420p "$7" 2>/dev/null; }
addaudio() { "$FFMPEG" -y -i "$1" -i "$2" -c:v copy -c:a aac -shortest "$3" 2>/dev/null; }

# Scene 1: Dashboard (25.0s) — 3 frames
mk "$F/01-01-dashboard-kpis.png" 9 s01a.mp4
mk "$F/01-02-dashboard-ai-recs.png" 9 s01b.mp4
mk "$F/01-03-dashboard-trends.png" 7.02 s01c.mp4
cat3 s01a.mp4 s01b.mp4 s01c.mp4 s01v.mp4
addaudio s01v.mp4 v2-01-dashboard.wav v2-seg01.mp4
echo "Scene 1 done"

# Scene 2: Ads Management (21.7s) — 3 frames
mk "$F/02-01-ads-mgmt-overview.png" 8 s02a.mp4
mk "$F/02-02-campaigns-list.png" 7 s02b.mp4
mk "$F/02-03-campaign-rows.png" 6.69 s02c.mp4
cat3 s02a.mp4 s02b.mp4 s02c.mp4 s02v.mp4
addaudio s02v.mp4 v2-02-ads-mgmt.wav v2-seg02.mp4
echo "Scene 2 done"

# Scene 3: KW Automation (26.7s) — 3 frames
mk "$F/03-01-kw-automation-bsc.png" 9 s03a.mp4
mk "$F/03-02-listing-attributes.png" 9 s03b.mp4
mk "$F/03-03-kw-grouping.png" 8.69 s03c.mp4
cat3 s03a.mp4 s03b.mp4 s03c.mp4 s03v.mp4
addaudio s03v.mp4 v2-03-kw-automation.wav v2-seg03.mp4
echo "Scene 3 done"

# Scene 4: Campaign Config (25.7s) — 2 frames
mk "$F/04-01-campaign-config.png" 13 s04a.mp4
mk "$F/04-02-config-rows.png" 12.69 s04b.mp4
cat2 s04a.mp4 s04b.mp4 s04v.mp4
addaudio s04v.mp4 v2-04-campaign-config.wav v2-seg04.mp4
echo "Scene 4 done"

# Scene 5: Search Terms (30.5s) — 4 frames
mk "$F/05-01-st-settings-active.png" 8 s05a.mp4
mk "$F/05-02-st-harvest-negate.png" 8 s05b.mp4
mk "$F/05-03-harvest-queue.png" 8 s05c.mp4
mk "$F/05-04-negative-kw.png" 6.50 s05d.mp4
cat4 s05a.mp4 s05b.mp4 s05c.mp4 s05d.mp4 s05v.mp4
addaudio s05v.mp4 v2-05-search-terms.wav v2-seg05.mp4
echo "Scene 5 done"

# Scene 6: ADS Performance (18.9s) — 3 frames
mk "$F/06-01-targeting-dashboard.png" 7 s06a.mp4
mk "$F/06-02-st-dashboard.png" 6 s06b.mp4
mk "$F/06-03-targeting-records.png" 5.92 s06c.mp4
cat3 s06a.mp4 s06b.mp4 s06c.mp4 s06v.mp4
addaudio s06v.mp4 v2-06-ads-perf.wav v2-seg06.mp4
echo "Scene 6 done"

# Scene 7: Reports (19.2s) — 2 frames
mk "$F/07-01-report-campaigns.png" 10 s07a.mp4
mk "$F/07-02-profit-analysis.png" 9.17 s07b.mp4
cat2 s07a.mp4 s07b.mp4 s07v.mp4
addaudio s07v.mp4 v2-07-reports.wav v2-seg07.mp4
echo "Scene 7 done"

# Scene 8: Competitor ST (18.4s) — 2 frames
mk "$F/08-01-competitor-st.png" 10 s08a.mp4
mk "$F/08-02-competitor-data.png" 8.43 s08b.mp4
cat2 s08a.mp4 s08b.mp4 s08v.mp4
addaudio s08v.mp4 v2-08-competitor.wav v2-seg08.mp4
echo "Scene 8 done"

# Scene 9: IBO (31.5s) — 6 frames
mk "$F/09-01-ibo-stage1.png" 5.5 s09a.mp4
mk "$F/09-02-ibo-stage2.png" 5.5 s09b.mp4
mk "$F/09-03-ibo-stage3.png" 5.5 s09c.mp4
mk "$F/09-04-ibo-stage4.png" 5 s09d.mp4
mk "$F/09-05-ibo-stage5.png" 5 s09e.mp4
mk "$F/09-06-ibo-stage6.png" 5.0 s09f.mp4
cat6 s09a.mp4 s09b.mp4 s09c.mp4 s09d.mp4 s09e.mp4 s09f.mp4 s09v.mp4
addaudio s09v.mp4 v2-09-ibo.wav v2-seg09.mp4
echo "Scene 9 done"

# Scene 10: Wizard (22.5s) — 5 frames
mk "$F/10-01-wizard-step1.png" 4.5 s10a.mp4
mk "$F/10-02-wizard-step2.png" 4.5 s10b.mp4
mk "$F/10-03-wizard-step3.png" 4.5 s10c.mp4
mk "$F/10-04-wizard-step4.png" 4.5 s10d.mp4
mk "$F/10-05-wizard-step5.png" 4.46 s10e.mp4
cat5 s10a.mp4 s10b.mp4 s10c.mp4 s10d.mp4 s10e.mp4 s10v.mp4
addaudio s10v.mp4 v2-10-wizard.wav v2-seg10.mp4
echo "Scene 10 done"

# Scene 11: Closing (26.7s) — 1 frame
"$FFMPEG" -y -loop 1 -i "$F/11-01-closing.png" -i v2-11-closing.wav \
  -c:v libx264 -tune stillimage -pix_fmt yuv420p -vf "scale=1920:1080" -r 30 \
  -c:a aac -shortest v2-seg11.mp4 2>/dev/null
echo "Scene 11 done"

# ── Final concatenation ──
echo ""
echo "Concatenating all 11 scenes..."
cat > v2-concat.txt << 'EOF'
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
EOF

"$FFMPEG" -y -f concat -safe 0 -i v2-concat.txt \
  -c:v libx264 -c:a aac -movflags +faststart \
  Kepler_Advertising_Section_Full_Demo.mp4 2>/dev/null

echo ""
echo "=== VIDEO COMPLETE ==="
ls -lh Kepler_Advertising_Section_Full_Demo.mp4

# Cleanup temp
rm -f s0*.mp4 v2-seg*.mp4 v2-concat.txt
echo "Temp files cleaned."
