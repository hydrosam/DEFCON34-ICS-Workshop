#!/usr/bin/env bash

set -euo pipefail

if ! read -r -p "Terminal server device name: " device_name ||
   [ -z "$device_name" ]; then
  echo "Terminal server device name cannot be empty." >&2
  exit 1
fi

if ! read -r -p "Path to buffered IP list: " ip_list ||
   [ -z "$ip_list" ]; then
  echo "IP list path cannot be empty." >&2
  exit 1
fi

if [[ "$ip_list" == "~/"* ]]; then
  ip_list="$HOME/${ip_list#~/}"
fi

if [ ! -s "$ip_list" ]; then
  echo "IP list not found or empty: $ip_list" >&2
  exit 1
fi

if ! command -v ssh >/dev/null 2>&1; then
  echo "Required command not found: ssh" >&2
  exit 1
fi

banner_pattern="congrats on finding device ${device_name}!"
attempt_count=0
line_number=0

while IFS= read -r ip || [ -n "$ip" ]; do
  line_number=$((line_number + 1))
  ip=${ip%$'\r'}

  if [ -z "$ip" ]; then
    continue
  fi

  if ! [[ "$ip" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
    echo "Skipping invalid IPv4 address on line $line_number: $ip" >&2
    continue
  fi

  IFS=. read -r octet1 octet2 octet3 octet4 <<< "$ip"
  if [ "$octet1" -gt 255 ] || [ "$octet2" -gt 255 ] ||
     [ "$octet3" -gt 255 ] || [ "$octet4" -gt 255 ]; then
    echo "Skipping invalid IPv4 address on line $line_number: $ip" >&2
    continue
  fi

  attempt_count=$((attempt_count + 1))
  printf 'Checking %s...\n' "$ip"

  ssh_output=
  if ! ssh_output=$(
      ssh \
        -n \
        -T \
        -o BatchMode=yes \
        -o ConnectTimeout=3 \
        -o ConnectionAttempts=1 \
        -o KbdInteractiveAuthentication=no \
        -o NumberOfPasswordPrompts=0 \
        -o PasswordAuthentication=no \
        -o PreferredAuthentications=none \
        -o StrictHostKeyChecking=no \
        -o UserKnownHostsFile=/dev/null \
        "Administrator@$ip" 2>&1
    ); then
    # Authentication is expected to fail after sshd sends its pre-login banner.
    :
  fi

  while IFS= read -r banner_line; do
    if [[ "$banner_line" == *"$banner_pattern"* ]]; then
      printf 'Found %s at %s\n' "$device_name" "$ip"
      printf 'Banner: %s\n' "$banner_line"
      exit 0
    fi
  done <<< "$ssh_output"
done < "$ip_list"

if [ "$attempt_count" -eq 0 ]; then
  echo "The IP list contains no valid IPv4 addresses." >&2
else
  echo "No SSH banner matched terminal server $device_name." >&2
fi

exit 1
