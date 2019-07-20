#!/usr/bin/env bash
set -euo pipefail

menu_vpn() {
  local -a OPTIONS
  OPTIONS+=("WEBPROXY_ENABLED" "Enable Web Proxy.")
  OPTIONS+=("TRANSMISSION_WEB_UI" "Change Web UI.")
  OPTIONS+=("TRANSMISSION_RATIO_LIMIT_ENABLED" "Enable Ratio Limit. True/False")
  OPTIONS+=("TRANSMISSION_RATIO_LIMIT" "Set Ratio Limit.")
  OPTIONS+=("TRANSMISSION_IDLE_SEEDING_LIMIT_ENABLED" "Enable Idle Limit. True/False.")
  OPTIONS+=("TRANSMISSION_IDLE_SEEDING_LIMIT" "Set Idle Time Limit.")
  
  log 7 "Opening Transmission menu."
  local SELECTION
  SELECTION=$(whiptail --fb --clear --title "media-docker Configuration" \
    --cancel-button "Exit" --menu "Select an item to update." 0 0 0 \
    "${OPTIONS[@]}" 3>&1 1>&2 2>&3 || echo "Exit")

  case $SELECTION in
    "Exit")
      log 7 "Exit selected, returning to config menu."
      run_sh "$MENUDIR" "menu_manual"
    ;;
    *)
      log 7 "Opening .ENV update menu."
      run_sh "$MENUDIR" "menu_env_update" \
        "$SELECTION" \
        "$(run_sh "$SCRIPTDIR" "env_get" "$SELECTION" "$BASEDIR/.env")" \

      run_sh "$MENUDIR" "menu_transmission"
      exit
    ;;
  esac
}
