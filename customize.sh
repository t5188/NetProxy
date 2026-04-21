#!/system/bin/sh

SKIPUNZIP=1
ASH_STANDALONE=1
unzip_path="/data/adb"

source_folder="/data/adb/NetProxy"
destination_folder="/data/adb/NetProxy$(date +%Y%m%d_%H%M%S)"

unzip -j -o "${ZIPFILE}" 'CHANGELOG.md' -d "${MODPATH}" >&2
cat "${MODPATH}/CHANGELOG.md"
rm -f "${MODPATH}/CHANGELOG.md"

if [ -d "${source_folder}" ]; then
  mv "${source_folder}" "${destination_folder}"
  ui_print "- 正在备份已有文件"
  rm -rf "${source_folder}"
else
  ui_print "- 正在初始安装"
fi

if [ -d "/data/adb/modules/ANetProxy" ]; then
  rm -rf "/data/adb/modules/ANetProxy"
  ui_print "- 旧模块已删除"
fi

ui_print "- 正在释放文件"
unzip -o "${ZIPFILE}" 'NetProxy/*' -d "${unzip_path}" >&2
unzip -j -o "${ZIPFILE}" 'NetProxy.sh' -d /data/adb/service.d >&2
unzip -j -o "${ZIPFILE}" 'uninstall.sh' -d "${MODPATH}" >&2
unzip -j -o "${ZIPFILE}" "action.sh" -d "${MODPATH}" >&2
unzip -j -o "${ZIPFILE}" "module.prop" -d "${MODPATH}" >&2
unzip -j -o "${ZIPFILE}" "system.prop" -d "${MODPATH}" >&2

if [ "${KSU}" = "true" ]; then
  sed -i "s/name=.*/name=NetProxy for KernelSU/g" "${MODPATH}/module.prop"
elif [ "${APATCH}" = "true" ]; then
  sed -i "s/name=.*/name=NetProxy for APatch/g" "${MODPATH}/module.prop"
else
  sed -i "s/name=.*/name=NetProxy for Magisk/g" "${MODPATH}/module.prop"
fi

largest_folder=$(find /data/adb -maxdepth 1 -type d -name 'NetProxy[0-9]*' | sed 's/.*NetProxy//' | sed 's/_//g' | sort -nr | head -n 1)

if [ -n "${largest_folder}" ]; then
  for folder in /data/adb/NetProxy*; do
    clean_name=$(echo "${folder}" | sed 's/.*NetProxy//' | sed 's/_//g')
    if [ "${clean_name}" = "${largest_folder}" ]; then
      ui_print "- Found folder: ${folder}"
      if [ -d "${folder}/conf" ]; then
        cp -rf "${folder}/conf/"* /data/adb/NetProxy/conf/
        ui_print "- Copied contents of ${folder}/conf to /data/adb/NetProxy/conf/"
        ui_print "- 成功还原配置文件"
      fi
      break
    fi
  done
else
  ui_print "- 首次安装，无备份配置可还原"
fi

ui_print "- 正在设置权限"
set_perm_recursive "${MODPATH}" 0 0 0755 0755
set_perm_recursive /data/adb/NetProxy/ 0 3005 0755 0755
set_perm /data/adb/service.d/NetProxy.sh 0 0 0755
set_perm "${MODPATH}/uninstall.sh" 0 0 0755
set_perm "${MODPATH}/action.sh" 0 0 0755
ui_print "- 完成权限设置"

pm install -r /data/adb/NetProxy/scripts/toast.apk && rm -f /data/adb/NetProxy/scripts/toast.apk || ui_print "- 请手动安装toast.apk"
find "${source_folder}" -type f -name ".gitkeep" -exec rm -f {} +
ui_print "- enjoy!"

# Last edited: 2026.4.22
