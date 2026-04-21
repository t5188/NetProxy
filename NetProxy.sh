#!/system/bin/sh
scripts_dir="/data/adb/NetProxy/scripts"

(
  until [ "$(getprop sys.boot_completed)" = "1" ]; do sleep 3; done
   "${scripts_dir}/start.sh"
) &

exit 0
# Last edited: 2026.4.21