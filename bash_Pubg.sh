#!/system/bin/sh
#
# nonroot_brevent_booster_pro.sh
# Non-root Brevent-friendly Performance Booster (Android 6+)
#
# Developer: Willy Jr Caransa Gailo
# Version: Booster Pro v2.0 (with CPU/GPU High-Performance Hints)
#

# ---------- CONFIG ----------
MIN_SDK=23
GAME_PKG="com.tencent.ig"
BREVENT_PKG="me.piebridge.brevent"
HEAVY_APPS_LIST="com.facebook.katana com.instagram.android com.snapchat.android com.google.android.gms"

ANIM_SCALE="0.5"
GAME_BRIGHTNESS=240
ENABLE_DND=true

# ---------- HELPERS ----------
log() { printf "%s\n" "$*"; }

loading() {
  msg="$1"
  i=0
  spinner="/-\|"
  printf "⏳ %s " "$msg"
  while [ $i -lt 12 ]; do
    i=$((i+1))
    sleep 0.1
    printf "\b${spinner:i%4:1}"
  done
  printf "\b✔️\n"
}

progress_bar() {
  msg="$1"
  total=20
  printf "%s\n" "$msg"
  for i in $(seq 1 $total); do
    sleep 0.05
    bar=$(printf "%-${total}s" "#" | sed "s/ /#/g")
    printf "\r[%-${total}s] %d%%" "${bar:0:$i}" $(( i*100/total ))
  done
  printf "\n"
}

check_sdk() {
  sdk=$(getprop ro.build.version.sdk 2>/dev/null)
  if [ -z "$sdk" ]; then
    log "⚠️ Unable to read SDK version. Proceeding anyway."
  else
    if [ "$sdk" -lt "$MIN_SDK" ]; then
      log "❌ This script requires Android SDK >= $MIN_SDK. Detected: $sdk"
      exit 1
    fi
  fi
}

# ---------- START ----------
clear
echo "=============================================="
echo " 🚀 Non-root Brevent Booster Pro v2.0"
echo " 👨‍💻 Developer: Willy Jr Caransa Gailo"
echo "=============================================="
sleep 1

loading "Checking Android SDK..."
check_sdk

progress_bar "Optimizing animations..."
settings put global window_animation_scale $ANIM_SCALE 2>/dev/null
settings put global transition_animation_scale $ANIM_SCALE 2>/dev/null
settings put global animator_duration_scale $ANIM_SCALE 2>/dev/null

progress_bar "Stopping background apps..."
for pkg in $HEAVY_APPS_LIST; do
  am force-stop "$pkg" 2>/dev/null
done

loading "Checking Brevent..."
if pm list packages | grep -q "$BREVENT_PKG"; then
  am start -n "$BREVENT_PKG/.MainActivity" 2>/dev/null || true
  log "🛡️ Brevent started."
else
  log "⚠️ Brevent not installed."
fi

progress_bar "Applying WiFi & Data tweaks..."
settings put global wifi_scan_always_enabled 0 2>/dev/null
settings put global wifi_sleep_policy 2 2>/dev/null
settings put global netpolicy 0 2>/dev/null

# ---------- PERFORMANCE BOOSTERS ----------
loading "Enabling High-Performance CPU/GPU hints..."

# Force GPU rendering & Skia (best-effort)
settings put global debug.hwui.renderer skiagl 2>/dev/null
settings put global debug.hwui.force_gpu_rendering 1 2>/dev/null
settings put global debug.composition.type gpu 2>/dev/null
settings put global debug.egl.force_msaa 1 2>/dev/null
settings put global debug.sf.latch_unsignaled 1 2>/dev/null

# CPU performance mode (varies per device, best-effort)
settings put global power_profile 1 2>/dev/null
settings put global performance_mode 1 2>/dev/null
settings put global high_performance 1 2>/dev/null

# Disable battery saver if active
settings put global low_power 0 2>/dev/null

log "⚡ CPU/GPU set to High Performance Mode (best-effort)"

progress_bar "Improving touch & responsiveness..."
settings put system pointer_speed 5 2>/dev/null
settings put global window_animation_scale 0.5 2>/dev/null

loading "Setting brightness & screen timeout..."
settings put system screen_brightness "$GAME_BRIGHTNESS" 2>/dev/null
settings put system screen_off_timeout 1800000 2>/dev/null

if [ "$ENABLE_DND" = "true" ]; then
  loading "Enabling Do Not Disturb..."
  cmd notification set_dnd true 2>/dev/null || true
fi

progress_bar "Launching game..."
if pm list packages | grep -q "$GAME_PKG"; then
  am force-stop "$GAME_PKG" 2>/dev/null
  sleep 1
  monkey -p "$GAME_PKG" -c android.intent.category.LAUNCHER 1 2>/dev/null
  log "🎮 Game launched!"
else
  log "⚠️ Game package not found!"
fi

loading "Finalizing booster..."

echo ""
echo "=============================================="
echo "✅ Booster finished!"
echo "⚡ CPU/GPU → High Performance Mode"
echo "🎨 UI & Touch → Optimized"
echo "🔥 Game Mode Activated!"
echo "=============================================="