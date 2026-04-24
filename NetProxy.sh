#!/system/bin/sh
scripts_dir="/data/adb/NetProxy/scripts"
. "${scripts_dir}/settings.ini"
(
  until [ "$(getprop sys.boot_completed)" = "1" ]; do
    sleep 3
  done
  "${scripts_dir}/start.sh"
) &
inotifyd "${scripts_dir}/NetProxy.inotify" "${module_dir}" >/dev/null 2>&1 &
exit 0