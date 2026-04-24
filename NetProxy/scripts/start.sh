#!/system/bin/sh
scripts_dir="$(cd "$(dirname "$0")" && pwd)"
. "${scripts_dir}/settings.ini"
proxy_service() {
  if [[ ! -f "${module_dir}/disable" ]]; then
    ${scripts_dir}/NetProxy.service enable >/dev/null 2>&1
  else
    toast "Module Disabled"
  fi
}
proxy_service