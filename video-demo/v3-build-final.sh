#!/bin/bash
FFMPEG="C:/Users/fabah/AppData/Local/Microsoft/WinGet/Packages/Gyan.FFmpeg_Microsoft.Winget.Source_8wekyb3d8bbwe/ffmpeg-8.0.1-full_build/bin/ffmpeg.exe"
VDIR="C:/Users/fabah/Advertising Product/kepler-ads-design/video-demo"
REC="$VDIR/v2-recording/42c96881e28660c5118bfc5b15486750.webm"

cd "$VDIR"

echo "Step 1: Converting WebM to MP4..."
"$FFMPEG" -y -i "$REC" \
  -c:v libx264 -pix_fmt yuv420p -r 30 -vf "scale=1920:1080" \
  -an \
  v3-video-only.mp4 2>/dev/null
echo "Video converted."

echo "Step 2: Building narration audio track..."
# Place each narration clip at its correct start time using adelay
# Timestamps (ms): Dashboard=0, AdsMgmt=15000, KWAuto=30000, ST=41500,
# AdsPerf=56000, Reports=67000, Competitor=75500, IBO=81500, Wizard=99500, Closing=114500

"$FFMPEG" -y \
  -i v3-01-dashboard.wav \
  -i v3-02-ads-mgmt.wav \
  -i v3-03-kw-automation.wav \
  -i v3-04-search-terms.wav \
  -i v3-05-ads-perf.wav \
  -i v3-06-reports.wav \
  -i v3-07-competitor.wav \
  -i v3-08-ibo.wav \
  -i v3-09-wizard.wav \
  -i v3-10-closing.wav \
  -filter_complex "
    [0:a]adelay=0|0,aformat=sample_fmts=fltp:sample_rates=44100:channel_layouts=mono[a0];
    [1:a]adelay=15000|15000,aformat=sample_fmts=fltp:sample_rates=44100:channel_layouts=mono[a1];
    [2:a]adelay=30000|30000,aformat=sample_fmts=fltp:sample_rates=44100:channel_layouts=mono[a2];
    [3:a]adelay=41500|41500,aformat=sample_fmts=fltp:sample_rates=44100:channel_layouts=mono[a3];
    [4:a]adelay=56000|56000,aformat=sample_fmts=fltp:sample_rates=44100:channel_layouts=mono[a4];
    [5:a]adelay=67000|67000,aformat=sample_fmts=fltp:sample_rates=44100:channel_layouts=mono[a5];
    [6:a]adelay=75500|75500,aformat=sample_fmts=fltp:sample_rates=44100:channel_layouts=mono[a6];
    [7:a]adelay=81500|81500,aformat=sample_fmts=fltp:sample_rates=44100:channel_layouts=mono[a7];
    [8:a]adelay=99500|99500,aformat=sample_fmts=fltp:sample_rates=44100:channel_layouts=mono[a8];
    [9:a]adelay=114500|114500,aformat=sample_fmts=fltp:sample_rates=44100:channel_layouts=mono[a9];
    [a0][a1][a2][a3][a4][a5][a6][a7][a8][a9]amix=inputs=10:duration=longest:dropout_transition=0[aout]
  " \
  -map "[aout]" -c:a pcm_s16le v3-narration-mixed.wav 2>/dev/null
echo "Narration track built."

echo "Step 3: Combining video + narration..."
"$FFMPEG" -y -i v3-video-only.mp4 -i v3-narration-mixed.wav \
  -c:v copy -c:a aac -b:a 128k -shortest \
  -movflags +faststart \
  "Kepler_Advertising_Demo_V3.mp4" 2>/dev/null
echo ""
echo "=== VIDEO COMPLETE ==="
ls -lh "Kepler_Advertising_Demo_V3.mp4"

# Cleanup temp
rm -f v3-video-only.mp4 v3-narration-mixed.wav
echo "Temp files cleaned."
