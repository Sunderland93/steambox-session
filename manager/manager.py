#!/usr/bin/python

import os
import signal
import subprocess
import threading
import time

from gi.repository import Gtk, Gdk, GLib

class Manager(object):

    def __init__(self):

        self._builder = Gtk.Builder()
        self._builder.add_from_file(
            os.path.join(os.getcwd(), "manager.ui"))

        self._window = self._builder.get_object("mainWindow")
        self._window.connect("delete-event", self._on_delete)

        self._steam = self._builder.get_object("steamButton")
        self._steam.connect("clicked", self._on_steam)

        self._logout = self._builder.get_object("logoutButton")
        self._logout.connect("clicked", self._on_logout)

    def _exec(self, bin, args, env):

        def run():
            return subprocess.call([bin] + args, env=env)

        th = threading.Thread(target=run)
        th.daemon = True
        th.start()

    def _on_delete(self, widget, event=None):
        self._on_logout()

    def _on_steam(self, _widget):
        self._exec("/usr/bin/steambox-run", [], os.environ)

    def _on_logout(self, _widget):
        os.killpg(os.getpgid(0), signal.SIGTERM)
        time.sleep(5)
        os.killpg(os.getpgid(0), signal.SIGKILL)

    def run(self):
        """
        Run Steam Manager ;-)
        """
        GLib.idle_add(self._window.show)
        GLib.threads_init()
        Gdk.threads_enter()
        Gtk.main()
        Gdk.threads_leave()

if __name__ == "__main__":
    import signal
    signal.signal(signal.SIGINT, signal.SIG_DFL)
    app = Manager()
    app.run()
