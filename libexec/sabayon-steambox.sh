#!/bin/bash

SABAYON_USER=$(cat /etc/sabayon/steambox-user 2>/dev/null)
. /sbin/sabayon-functions.sh

if sabayon_is_steambox; then

    _HOME="/home/${LIVE_USER}"
    echo "Sabayon Steam Box mode enabled, user: ${LIVE_USER}"

    sabayon_setup_desktop_session "${LIVE_USER}" "steambox"
    sabayon_setup_autologin

    # dive into the final executable
    exec /usr/libexec/steambox-consolekit
fi

# if we get here, we need to loop forever.
if ! sabayon_is_live && ! sabayon_is_steambox; then
    echo "Sabayon Steam Box mode disabled"
    sabayon_disable_autologin

    # KDE or GNOME only for now
    if [ -e /usr/share/xsessions/KDE-4.desktop ]; then
        sess="KDE-4"
    else
        sess="gnome"
    fi
    sabayon_setup_desktop_session "${LIVE_USER}" "${sess}"
fi

while true; do
    sleep 7d
done
