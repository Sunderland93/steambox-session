#!/bin/bash

SABAYON_USER=$(cat /etc/sabayon/steambox-user 2>/dev/null)
. /sbin/sabayon-functions.sh

if sabayon_is_steambox; then

    _HOME="/home/${LIVE_USER}"
    echo "Sabayon Steam Box mode enabled, user: ${LIVE_USER}"

    echo "[Desktop]" > "${_HOME}"/.dmrc
    echo "Session=steambox" >> "${_HOME}"/.dmrc
    chown "${LIVE_USER}" "${_HOME}"/.dmrc
    if [ -x "/usr/libexec/gdm-set-default-session" ]; then
        # TODO: remove this in 6 months
        # oh my fucking glorious god, this
        # is AccountsService bullshit
        # cross fingers
        /usr/libexec/gdm-set-default-session steambox
    fi
    if [ -x "/usr/libexec/gdm-set-session" ]; then
        # GDM 3.6 support
        /usr/libexec/gdm-set-session "${LIVE_USER}" steambox
    fi
    sabayon_setup_autologin

    # dive into the final executable
    exec /usr/libexec/steambox-consolekit
fi

# if we get here, we need to loop forever.
if ! sabayon_is_live && ! sabayon_is_steambox; then
    echo "Sabayon Steam Box mode disabled"
    sabayon_disable_autologin
fi

while true; do
    sleep 7d
done
