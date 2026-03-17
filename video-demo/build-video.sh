#!/bin/bash
# Build demo video: images synced to narration audio clips

FFMPEG="C:/Users/fabah/AppData/Local/Microsoft/WinGet/Packages/Gyan.FFmpeg_Microsoft.Winget.Source_8wekyb3d8bbwe/ffmpeg-8.0.1-full_build/bin/ffmpeg.exe"
VDIR="C:/Users/fabah/Advertising Product/kepler-ads-design/video-demo"
FDIR="$VDIR/frames"

cd "$VDIR"

# ── Scene 1: Intro (9.6s) — 2 frames, split timing ──
# 01-01-dashboard.png for first 5s, 01-02-highlight-launch.png for last 4.6s
"$FFMPEG" -y -loop 1 -i "$FDIR/01-01-dashboard.png" -i "$VDIR/01-intro.wav" \
  -t 5 -c:v libx264 -tune stillimage -pix_fmt yuv420p -vf "scale=1920:1080" -r 30 \
  -an "$VDIR/seg01a.mp4" 2>/dev/null
"$FFMPEG" -y -loop 1 -i "$FDIR/01-02-highlight-launch.png" \
  -t 4.62 -c:v libx264 -tune stillimage -pix_fmt yuv420p -vf "scale=1920:1080" -r 30 \
  -an "$VDIR/seg01b.mp4" 2>/dev/null
# Concat 01a+01b video, then add audio
"$FFMPEG" -y -i "$VDIR/seg01a.mp4" -i "$VDIR/seg01b.mp4" -filter_complex "[0:v][1:v]concat=n=2:v=1:a=0[v]" -map "[v]" -c:v libx264 -pix_fmt yuv420p "$VDIR/seg01v.mp4" 2>/dev/null
"$FFMPEG" -y -i "$VDIR/seg01v.mp4" -i "$VDIR/01-intro.wav" -c:v copy -c:a aac -shortest "$VDIR/seg01.mp4" 2>/dev/null
echo "Scene 1 done"

# ── Scene 2: Section A (21.6s) — 2 frames, ~11s each ──
"$FFMPEG" -y -loop 1 -i "$FDIR/02-01-step4-top.png" \
  -t 11 -c:v libx264 -tune stillimage -pix_fmt yuv420p -vf "scale=1920:1080" -r 30 \
  -an "$VDIR/seg02a.mp4" 2>/dev/null
"$FFMPEG" -y -loop 1 -i "$FDIR/02-02-progress-dots.png" \
  -t 10.61 -c:v libx264 -tune stillimage -pix_fmt yuv420p -vf "scale=1920:1080" -r 30 \
  -an "$VDIR/seg02b.mp4" 2>/dev/null
"$FFMPEG" -y -i "$VDIR/seg02a.mp4" -i "$VDIR/seg02b.mp4" -filter_complex "[0:v][1:v]concat=n=2:v=1:a=0[v]" -map "[v]" -c:v libx264 -pix_fmt yuv420p "$VDIR/seg02v.mp4" 2>/dev/null
"$FFMPEG" -y -i "$VDIR/seg02v.mp4" -i "$VDIR/02-section-a.wav" -c:v copy -c:a aac -shortest "$VDIR/seg02.mp4" 2>/dev/null
echo "Scene 2 done"

# ── Scene 3: Hints (23s) — 2 frames, ~11.5s each ──
"$FFMPEG" -y -loop 1 -i "$FDIR/03-01-hint-match.png" \
  -t 11.5 -c:v libx264 -tune stillimage -pix_fmt yuv420p -vf "scale=1920:1080" -r 30 \
  -an "$VDIR/seg03a.mp4" 2>/dev/null
"$FFMPEG" -y -loop 1 -i "$FDIR/03-02-hint-asin.png" \
  -t 11.57 -c:v libx264 -tune stillimage -pix_fmt yuv420p -vf "scale=1920:1080" -r 30 \
  -an "$VDIR/seg03b.mp4" 2>/dev/null
"$FFMPEG" -y -i "$VDIR/seg03a.mp4" -i "$VDIR/seg03b.mp4" -filter_complex "[0:v][1:v]concat=n=2:v=1:a=0[v]" -map "[v]" -c:v libx264 -pix_fmt yuv420p "$VDIR/seg03v.mp4" 2>/dev/null
"$FFMPEG" -y -i "$VDIR/seg03v.mp4" -i "$VDIR/03-hints.wav" -c:v copy -c:a aac -shortest "$VDIR/seg03.mp4" 2>/dev/null
echo "Scene 3 done"

# ── Scene 4: Section B (14.3s) — 1 frame ──
"$FFMPEG" -y -loop 1 -i "$FDIR/04-01-section-b.png" -i "$VDIR/04-section-b.wav" \
  -c:v libx264 -tune stillimage -pix_fmt yuv420p -vf "scale=1920:1080" -r 30 \
  -c:a aac -shortest "$VDIR/seg04.mp4" 2>/dev/null
echo "Scene 4 done"

# ── Scene 5: Section C (16.8s) — 2 frames ──
"$FFMPEG" -y -loop 1 -i "$FDIR/05-01-section-c-top.png" \
  -t 9 -c:v libx264 -tune stillimage -pix_fmt yuv420p -vf "scale=1920:1080" -r 30 \
  -an "$VDIR/seg05a.mp4" 2>/dev/null
"$FFMPEG" -y -loop 1 -i "$FDIR/05-02-column-hints.png" \
  -t 7.78 -c:v libx264 -tune stillimage -pix_fmt yuv420p -vf "scale=1920:1080" -r 30 \
  -an "$VDIR/seg05b.mp4" 2>/dev/null
"$FFMPEG" -y -i "$VDIR/seg05a.mp4" -i "$VDIR/seg05b.mp4" -filter_complex "[0:v][1:v]concat=n=2:v=1:a=0[v]" -map "[v]" -c:v libx264 -pix_fmt yuv420p "$VDIR/seg05v.mp4" 2>/dev/null
"$FFMPEG" -y -i "$VDIR/seg05v.mp4" -i "$VDIR/05-section-c.wav" -c:v copy -c:a aac -shortest "$VDIR/seg05.mp4" 2>/dev/null
echo "Scene 5 done"

# ── Scene 6: Show All (11.7s) — 2 frames ──
"$FFMPEG" -y -loop 1 -i "$FDIR/06-01-reset-show-all.png" \
  -t 6 -c:v libx264 -tune stillimage -pix_fmt yuv420p -vf "scale=1920:1080" -r 30 \
  -an "$VDIR/seg06a.mp4" 2>/dev/null
"$FFMPEG" -y -loop 1 -i "$FDIR/06-02-all-revealed.png" \
  -t 5.71 -c:v libx264 -tune stillimage -pix_fmt yuv420p -vf "scale=1920:1080" -r 30 \
  -an "$VDIR/seg06b.mp4" 2>/dev/null
"$FFMPEG" -y -i "$VDIR/seg06a.mp4" -i "$VDIR/seg06b.mp4" -filter_complex "[0:v][1:v]concat=n=2:v=1:a=0[v]" -map "[v]" -c:v libx264 -pix_fmt yuv420p "$VDIR/seg06v.mp4" 2>/dev/null
"$FFMPEG" -y -i "$VDIR/seg06v.mp4" -i "$VDIR/06-show-all.wav" -c:v copy -c:a aac -shortest "$VDIR/seg06.mp4" 2>/dev/null
echo "Scene 6 done"

# ── Scene 7: Closing (13s) — 1 frame ──
"$FFMPEG" -y -loop 1 -i "$FDIR/07-01-closing.png" -i "$VDIR/07-closing.wav" \
  -c:v libx264 -tune stillimage -pix_fmt yuv420p -vf "scale=1920:1080" -r 30 \
  -c:a aac -shortest "$VDIR/seg07.mp4" 2>/dev/null
echo "Scene 7 done"

# ── Concatenate all 7 segments ──
cat > "$VDIR/concat.txt" << 'CONCAT'
file 'seg01.mp4'
file 'seg02.mp4'
file 'seg03.mp4'
file 'seg04.mp4'
file 'seg05.mp4'
file 'seg06.mp4'
file 'seg07.mp4'
CONCAT

"$FFMPEG" -y -f concat -safe 0 -i "$VDIR/concat.txt" \
  -c:v libx264 -c:a aac -movflags +faststart \
  "$VDIR/Kepler_SubWizard_Contextual_Guidance_Demo.mp4" 2>/dev/null

echo ""
echo "=== VIDEO COMPLETE ==="
ls -lh "$VDIR/Kepler_SubWizard_Contextual_Guidance_Demo.mp4"
