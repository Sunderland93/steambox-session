#!/usr/bin/python

import os
import signal
import subprocess
import threading
import time

import cairo

from gi.repository import Gtk, Gdk, GLib

class Manager(object):

    def __init__(self):

        self._builder = Gtk.Builder()
        self._builder.add_from_file(
            os.path.join(os.getcwd(), "manager.ui"))

        self._window = self._builder.get_object("mainWindow")
        self._win_setup()

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

    def _setup_cursor(self):
        cursor = Gdk.Cursor(Gdk.CursorType.TARGET)
        gdk_w = self._window.get_root_window()
        gdk_w.set_cursor(cursor)

    def _unsetup_cursor(self):
        cursor = Gdk.Cursor(Gdk.CursorType.ARROW)
        gdk_w = self._window.get_root_window()
        gdk_w.set_cursor(cursor)

    def _win_setup(self):
        self._window.connect("delete-event", self._on_delete)
        self._window.connect("draw", self._on_win_draw)
        self._window.connect("enter-notify-event", self._on_win_enter)
        self._window.connect("leave-notify-event", self._on_win_leave)

        self._window.set_app_paintable(True)
        screen = self._window.get_screen()
        if screen is not None:
            visual = screen.get_rgba_visual()
            if visual is not None and screen.is_composited():
                self._window.set_visual(visual)

        self._window.show()
        self._window.set_keep_below(True)

        self._setup_cursor()

        self._on_steam(None)

    def _on_win_draw(self, wid, cr):
        cr.set_source_rgba(0.2, 0.2, 0.2, 1.0)
        cr.set_operator(cairo.OPERATOR_SOURCE)
        cr.paint()

    def _on_win_enter(self, _widget, _event):
        self._setup_cursor()

    def _on_win_leave(self, _widget, _event):
        self._unsetup_cursor()

    def run(self):
        """
        Run Steam Manager ;-)
        """
        GLib.threads_init()
        Gdk.threads_enter()
        Gtk.main()
        Gdk.threads_leave()

if __name__ == "__main__":
    import signal
    signal.signal(signal.SIGINT, signal.SIG_DFL)
    app = Manager()
    app.run()
