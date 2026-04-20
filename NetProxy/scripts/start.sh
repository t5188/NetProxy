#!/system/bin/sh
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "${SCRIPT_DIR}/settings.ini"

proxy_service() {
  if [[ ! -f "${module_dir}/disable" ]]; then
    ${SCRIPT_DIR}/NetProxy.service enable >/dev/null 2>&1
  else
    toast "Module Disabled"
  fi
}

start_inotifyd() {
  for PID in $(busybox pidof inotifyd 2>/dev/null); do
    if grep -q "${SCRIPT_DIR}/NetProxy.inotify" "/proc/$PID/cmdline"; then
      return
    fi
  done
  inotifyd "${SCRIPT_DIR}/NetProxy.inotify" "${module_dir}" >/dev/null 2>&1 &
}

proxy_service
start_inotifyd

# Last edited: 2026.4.20
