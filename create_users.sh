#!/bin/bash

# skriptet ska köras som root.
if [ "$(id -u)" -ne 0 ]; then
  echo "Please run this script as root."
  exit 1
fi

# skapa användare först
for username in "$@"; do
  if id "$username" &>/dev/null; then
    echo "User $username already exists."
  else
    # visa felmeddelandet om användaren inte kan skapas
    if ! error=$(useradd -m "$username" 2>&1); then
      echo "Failed to create user $username: $error"
    fi
  fi
done

# skapa mappar och welcome.txt efter att alla användare finns
for username in "$@"; do
  if id "$username" &>/dev/null; then
    for folder in Work Documents Downloads; do
      install -d -m 700 -o "$username" -g "$username" "/home/$username/$folder"
    done

    {
      echo "Välkommen $username"
      getent passwd | cut -d: -f1 | grep -vx "$username"
    } > "/home/$username/welcome.txt"

    chown "$username":"$username" "/home/$username/welcome.txt"
  fi
done