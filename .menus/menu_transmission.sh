#!/usr/bin/env bash
set -euo pipefail

menu_transmission() {
  local -a OPTIONS
  OPTIONS+=("TRANS_WEBPROXY" "Enable Web Proxy.")
  OPTIONS+=("TRANS_UI" "Change Web UI.")
  OPTIONS+=("TRANS_RATIO_LIMIT_ENABLE" "Enable Ratio Limit. True/False")
  OPTIONS+=("TRANS_RATIO_LIMIT" "Set Ratio Limit.")
  OPTIONS+=("TRANS_IDLE_SEEDING_LIMIT_ENABLED" "Enable Idle Limit. True/False.")
  OPTIONS+=("TRANS_IDLE_SEEDING_LIMIT" "Set Idle Time Limit.")
  
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
