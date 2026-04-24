#!/system/bin/sh
scripts_dir="/data/adb/NetProxy/scripts"
. "${scripts_dir}/settings.ini"

(
  until [ "$(getprop sys.boot_completed)" = "1" ]; do
    sleep 3
  done
proxy_service() {
  if [[ ! -f "${module_dir}/disable" ]]; then
    ${scripts_dir}/NetProxy.service enable >/dev/null 2>&1
  else
    toast "Module Disabled"
  fi
}
start_inotifyd() {
  for PID in $(busybox pidof inotifyd 2>/dev/null); do
    if grep -q "${scripts_dir}/NetProxy.inotify" "/proc/$PID/cmdline"; then
      return
    fi
  done
  inotifyd "${scripts_dir}/NetProxy.inotify" "${module_dir}" >/dev/null 2>&1 &
}
proxy_service
start_inotifyd
) &

exit 0

# Last edited: 2026.4.24
