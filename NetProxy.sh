#!/system/bin/sh
scripts_dir="/data/adb/NetProxy/scripts"
MODE=$(stat -c %a "${scripts_dir}/start.sh")

(
  until [ "$(getprop sys.boot_completed)" = "1" ]; do sleep 3; done

  if [ "${MODE}" != "755" ]; then
    chmod 755 "${scripts_dir}/start.sh"
    chown root:net_admin "${scripts_dir}/start.sh"
  fi

  "${scripts_dir}/start.sh"
) &

exit 0
# Last edited: 2026.1.13