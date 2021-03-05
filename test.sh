#!/bin/bash
export $(dbus-launch)
echo "" | gnome-keyring-daemon --unlock
/usr/bin/gnome-keyring-daemon --components=secrets,pkcs11,ssh --start --daemonize
export $(echo "" | /usr/bin/gnome-keyring-daemon -r -d --unlock)
export SHELL
yarn test