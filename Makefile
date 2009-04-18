META_DIR=$(shell awk -F "=" '/META_DIR=/ {print $$2}' conf/thindistro.conf)
META_CONF=$(shell awk -F "=" '/META_CONF=/ {print $$2}' conf/thindistro.conf)
META_MASTER=$(shell awk -F "=" '/META_MASTER=/ {print $$2}' conf/thindistro.conf)
META_SOURCES=$(shell awk -F "=" '/META_SOURCES=/ {print $$2}' conf/thindistro.conf)
META_ISOS=$(shell awk -F "=" '/META_ISOS=/ {print $$2}' conf/thindistro.conf)
WORKDIR=$(shell awk -F "=" '/WORKDIR=/ {print $$2}' conf/thindistro.conf)

THINDISTRO_DIR=/etc/thindistro

all:
	#no compile, only make install

test:
	@echo "META_DIR=$(META_DIR)"
	@echo "META_CONF=$(META_CONF)"

superclean: clean
	fakeroot debian/rules clean

clean:
	find . |grep "~" | xargs rm -rf --

distclean:
	find . |grep "~" | xargs rm -rf --



install:
	install -d $(DESTDIR)/usr/sbin
	install -d $(DESTDIR)$(META_CONF)
	touch $(DESTDIR)$(META_CONF)/modules
	install -d $(DESTDIR)$(META_CONF)/hooks
	install -d $(DESTDIR)$(META_CONF)/scripts
	install -d $(DESTDIR)$(META_DIR)

	install -d $(DESTDIR)/usr/sbin
	install -d $(DESTDIR)/$(META_DIR)
	
	install -d $(DESTDIR)/$(META_MASTER)
	install -d $(DESTDIR)/$(META_SOURCES)
	install -d $(DESTDIR)/$(META_ISOS)
	
	install -d $(DESTDIR)/$(META_MASTER)/meta
	install -d $(DESTDIR)/$(META_MASTER)/boot/grub
	
	install -d $(DESTDIR)/$(WORKDIR)
	install -d $(DESTDIR)/$(WORKDIR)/boot
	install -d $(DESTDIR)/$(WORKDIR)/pkgs
	install -d $(DESTDIR)/$(WORKDIR)/basepkgs
	install -d $(DESTDIR)/$(WORKDIR)/mods
	install -d $(DESTDIR)/$(WORKDIR)/modspkgs
	install -d $(DESTDIR)/$(WORKDIR)/chroot


	#  Creating directories
	for i in `find scripts/ -type d`; do install -d $(DESTDIR)/$(META_DIR)/$$i; done
	for i in `find scripts/ -type d`; do install -d $(DESTDIR)/$(META_CONF)/$$i; done
	for i in `find hooks/ -type d`; do install -d $(DESTDIR)/$(META_DIR)/$$i; done
	for i in `find hooks.thindistro/ -type d`; do install -d $(DESTDIR)/$(META_DIR)/$$i; done


	# Installing in  $(DESTDIR)
	for i in `find scripts/ -type f`; do install -m 755 $$i $(DESTDIR)/$(META_DIR)/$$i; done
	for i in `find hooks/ -type f`; do install -m 755 $$i $(DESTDIR)/$(META_DIR)/$$i; done
	for i in `find hooks.thindistro/ -type f`; do install -m 755 $$i $(DESTDIR)/$(META_DIR)/$$i; done

	mv $(DESTDIR)$(META_DIR)/hooks/metamain $(DESTDIR)$(META_CONF)/hooks/

	chmod -x $(DESTDIR)/$(META_DIR)/scripts/thindistro

	install -m 644 conf/thindistro.conf $(DESTDIR)/$(META_CONF)/thindistro.conf

	install -m 644 conf/settings.conf $(DESTDIR)/$(META_MASTER)/meta/settings.conf

	install -m 644 conf/initramfs.conf $(DESTDIR)/$(META_CONF)/initramfs.conf
	install -m 644 conf/version $(DESTDIR)/var/lib/thindistro/version

	install -m 755 bin/genthindistro $(DESTDIR)/usr/sbin/genthindistro
	install -m 755 bin/thindistro-rebuild $(DESTDIR)/usr/sbin/thindistro-rebuild
	install -m 755 bin/thindistro-copy $(DESTDIR)/usr/sbin/thindistro-copy

	install -m 644 grub/menu.lst $(DESTDIR)/$(META_MASTER)/boot/grub/


devel:
	debuild -us -uc; sudo dpkg -i ../thindistro_0.1.1_all.deb; sudo cp ../thindistro_0.1.1*deb /var/lib/thindistro/distro/pkgs/
