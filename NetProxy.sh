#!/system/bin/sh
SCRIPTS_DIR="/data/adb/NetProxy/scripts"
MODE=$(stat -c %a "${SCRIPTS_DIR}/start.sh")

(
  until [ "$(getprop sys.boot_completed)" = "1" ]; do sleep 3; done

  if [ "${MODE}" != "755" ]; then
    chmod 755 "${SCRIPTS_DIR}/start.sh"
    chown root:net_admin "${SCRIPTS_DIR}/start.sh"
  fi

  "${SCRIPTS_DIR}/start.sh"
) &

exit 0
# Last edited: 2026.1.13