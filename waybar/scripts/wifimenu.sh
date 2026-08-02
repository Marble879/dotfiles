#!/usr/bin/env bash

notify() {
    notify-send -t 3000 "Wi-Fi" "$1"
}

get_connected_ssid() {
    nmcli -t -f active,ssid dev wifi | awk -F: '$1=="yes"{print $2}'
}

get_wifi_dev() {
    nmcli -t -f device,type dev | awk -F: '$2=="wifi"{print $1; exit}'
}

connected="$(get_connected_ssid)"
wifi_dev="$(get_wifi_dev)"
wifi_state="$(nmcli -t radio wifi)"

nmcli dev wifi rescan >/dev/null 2>&1 &

items=()
keys=()

if [ "$wifi_state" = "enabled" ]; then
    items+=("󰖪  Turn Wi-Fi OFF")
    keys+=("toggle")
else
    items+=("󰖩  Turn Wi-Fi ON")
    keys+=("toggle")
fi

if [ -n "$connected" ]; then
    items+=("󰖪  Disconnect ($connected)")
    keys+=("disconnect")
fi

while IFS=: read -ra f; do
    n=${#f[@]}
    [ "$n" -lt 3 ] && continue
    sig="${f[$n-1]}"
    sec="${f[$n-2]}"
    ssid=$(IFS=:; echo "${f[*]:0:$((n-2))}" | sed 's/\\:/:/g')
    [ -z "$ssid" ] || [ "$ssid" = "--" ] && continue

    if   [ "$sig" -ge 80 ]; then icon="󰤨"
    elif [ "$sig" -ge 60 ]; then icon="󰤥"
    elif [ "$sig" -ge 40 ]; then icon="󰤢"
    elif [ "$sig" -ge 20 ]; then icon="󰤟"
    else icon="󰤯"; fi

    if [ -n "$sec" ] && [ "$sec" != "--" ]; then lock=" 󰤾"; else lock=""; fi

    items+=("$icon$lock  $ssid")
    keys+=("$ssid")
done < <(nmcli -t -f ssid,security,signal dev wifi list)

[ "${#items[@]}" -eq 0 ] && notify "No Wi-Fi networks found" && exit 1

chosen=$(printf '%s\n' "${items[@]}" | rofi -dmenu -p "Wi-Fi" -i -format i -selected-row 0)
[ -z "$chosen" ] && exit 0

key="${keys[$chosen]}"

case "$key" in
    toggle)
        nmcli radio wifi toggle
        notify "Wi-Fi toggled"
        ;;
    disconnect)
        nmcli dev disconnect "$wifi_dev"
        notify "Disconnected from $connected"
        ;;
    *)
        if [ "$key" = "$connected" ]; then
            nmcli dev disconnect "$wifi_dev"
            notify "Disconnected from $key"
        elif nmcli dev wifi connect "$key" >/dev/null 2>&1; then
            notify "Connected to $key"
        else
            pass=$(rofi -dmenu -password -p "Password for $key")
            if nmcli dev wifi connect "$key" password "$pass" >/dev/null 2>&1; then
                notify "Connected to $key"
            else
                notify "Failed to connect to $key"
            fi
        fi
        ;;
esac
