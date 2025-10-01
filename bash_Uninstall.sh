#!/system/bin/sh
#
# nonroot_brevent_booster_uninstall.sh
# Uninstall/Revert Booster → Restore Defaults
#
# Developer: Willy Jr Caransa Gailo
# Version: Booster Pro v2.0 Uninstaller
#

# ---------- HELPERS ----------
log() { printf "%s\n" "$*"; }

loading() {
  msg="$1"
  i=0
  spinner="/-\|"
  printf "⏳ %s " "$msg"
  while [ $i -lt 10 ]; do
    i=$((i+1))
    sleep 0.1
    printf "\b${spinner:i%4:1}"
  done
  printf "\b✔️\n"
}

progress_bar() {
  msg="$1"
  total=15
  printf "%s\n" "$msg"
  for i in $(seq 1 $total); do
    sleep 0.05
    bar=$(printf "%-${total}s" "#" | sed "s/ /#/g")
    printf "\r[%-${total}s] %d%%" "${bar:0:$i}" $(( i*100/total ))
  done
  printf "\n"
}

# ---------- START ----------
clear
echo "=============================================="
echo " 🔄 Reverting Booster Settings..."
echo " 👨‍💻 Developer: Willy Jr Caransa Gailo"
echo "=============================================="
sleep 1

progress_bar "Restoring animations..."
settings put global window_animation_scale 1.0 2>/dev/null
settings put global transition_animation_scale 1.0 2>/dev/null
settings put global animator_duration_scale 1.0 2>/dev/null

progress_bar "Restoring WiFi & Data defaults..."
settings put global wifi_scan_always_enabled 1 2>/dev/null
settings put global wifi_sleep_policy 0 2>/dev/null
settings delete global netpolicy 2>/dev/null

loading "Disabling performance hints..."
settings delete global debug.hwui.renderer 2>/dev/null
settings delete global debug.hwui.force_gpu_rendering 2>/dev/null
settings delete global debug.composition.type 2>/dev/null
settings delete global debug.egl.force_msaa 2>/dev/null
settings delete global debug.sf.latch_unsignaled 2>/dev/null

settings delete global power_profile 2>/dev/null
settings delete global performance_mode 2>/dev/null
settings delete global high_performance 2>/dev/null

# Restore battery saver
settings put global low_power 1 2>/dev/null

progress_bar "Restoring touch & responsiveness..."
settings put system pointer_speed 0 2>/dev/null

loading "Restoring brightness & timeout..."
settings put system screen_brightness 120 2>/dev/null
settings put system screen_off_timeout 60000 2>/dev/null

loading "Disabling Do Not Disturb..."
cmd notification set_dnd false 2>/dev/null || true

echo ""
echo "=============================================="
echo " ✅ Booster settings reverted!"
echo " 📱 Device is back to normal defaults"
echo "=============================================="