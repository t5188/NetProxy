#!/system/bin/sh
# Environment variable settings
export PATH="/data/adb/ap/bin:/data/adb/ksu/bin:/data/adb/magisk:$PATH"

MODULE_DIR="/data/adb/modules/ANetProxy"
SCRIPTS_DIR="/data/adb/NetProxy/scripts"

restart_proxy_service() {
  if [ ! -f "${MODULE_DIR}/disable" ]; then
    echo "🔁Restart NetProxy"
    ${SCRIPTS_DIR}/NetProxy.service enable >/dev/null 2>&1
  else
    echo "🥴 Module Disabled"
    sleep 1
    exit
  fi
}

restart_proxy_service

# Last edited: 2026.1.13
