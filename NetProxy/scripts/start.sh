#!/system/bin/sh
cd ${0%/*} # current working directory
# source files
source "$(pwd)/settings.ini"

proxy_service() {
  if [[ ! -f "${module_dir}/disable" ]]; then
    $(pwd)/NetProxy.service enable >/dev/null 2>&1
  else
    toast "Module Disabled"
  fi
}

start_inotifyd() {
  PIDs=($(busybox pidof inotifyd)) # Environment variables are required.
  for PID in "${PIDs[@]}"; do
    if grep -q "$(pwd)/NetProxy.inotify" "/proc/$PID/cmdline"; then
      return
    fi
  done
  inotifyd "$(pwd)/NetProxy.inotify" "${module_dir}" >/dev/null 2>&1 &
}

proxy_service
start_inotifyd

# Last edited: 2026.4.15
