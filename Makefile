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
	install -m 0755 libexec/sabayon-steambox.sh $(DESTDIR)/$(LIBEXECDIR)/

	install -d $(DESTDIR)/$(UBINDIR)
	install -m 0755 bin/steambox $(DESTDIR)/$(UBINDIR)/

	install -d $(DESTDIR)/$(SYSTEMD_UNITDIR)/
	install -m 0644 systemd/*.service $(DESTDIR)/$(SYSTEMD_UNITDIR)/

	install -d $(DESTDIR)/$(SYSV_INITDIR)/
	install -m 0755 init.d/* $(DESTDIR)/$(SYSV_INITDIR)/
