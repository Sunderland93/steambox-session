#!/bin/bash

SABAYON_USER=$(cat /etc/sabayon/steambox-user 2>/dev/null)
. /sbin/sabayon-functions.sh

if sabayon_is_steambox; then

    _HOME="/home/${SABAYON_USER}"
    echo "Sabayon Steam Box mode enabled"

    echo "[Desktop]" > "${_HOME}"/.dmrc
    echo "Session=${SABAYON_USER}" >> "${_HOME}"/.dmrc
    chown "${SABAYON_USER}" "${_HOME}"/.dmrc
    if [ -x "/usr/libexec/gdm-set-default-session" ]; then
        # TODO: remove this in 6 months
        # oh my fucking glorious god, this
        # is AccountsService bullshit
        # cross fingers
        /usr/libexec/gdm-set-default-session steam
    fi
    if [ -x "/usr/libexec/gdm-set-session" ]; then
        # GDM 3.6 support
        /usr/libexec/gdm-set-session "${SABAYON_USER}" steam
    fi
    sabayon_setup_autologin

elif ! sabayon_is_live && ! sabayon_is_steambox; then
    echo "Sabayon Steam Box mode disabled"
    sabayon_disable_autologin
fi

exit 0
