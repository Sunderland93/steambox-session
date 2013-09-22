SUBDIRS =
DESTDIR = 
UBINDIR ?= /usr/bin
LIBDIR ?= /usr/lib
USBINDIR ?= /usr/sbin
LIBEXECDIR ?= /usr/libexec
SYSCONFDIR ?= /etc
SYSTEMD_UNITDIR ?= $(LIBDIR)/systemd/system
SYSV_INITDIR = /etc/init.d

all:
	for d in $(SUBDIRS); do $(MAKE) -C $$d; done

clean:
	for d in $(SUBDIRS); do $(MAKE) -C $$d clean; done

install:
	for d in $(SUBDIRS); do $(MAKE) -C $$d install; done

	install -d $(DESTDIR)/$(LIBEXECDIR)
	install -m 0755 libexec/* $(DESTDIR)/$(LIBEXECDIR)/

	install -d $(DESTDIR)/$(UBINDIR)
	install -m 0755 bin/* $(DESTDIR)/$(UBINDIR)/

	install -d $(DESTDIR)/$(XSESSIONDIR)
	install -m 0644 xsession/steambox.desktop $(DESTDIR)/$(XSESSIONDIR)/

	install -d $(DESTDIR)/$(LIBDIR)/steam-manager
	install -m 0644 manager/manager.ui $(DESTDIR)/$(LIBDIR)/steam-manager/
	install -m 0644 manager/*.png $(DESTDIR)/$(LIBDIR)/steam-manager/
	install -m 0755 manager/manager.py $(DESTDIR)/$(LIBDIR)/steam-manager/

	install -d $(DESTDIR)/$(SYSTEMD_UNITDIR)/
	install -m 0644 systemd/*.service $(DESTDIR)/$(SYSTEMD_UNITDIR)/

	install -d $(DESTDIR)/$(SYSV_INITDIR)/
	install -m 0755 init.d/* $(DESTDIR)/$(SYSV_INITDIR)/
