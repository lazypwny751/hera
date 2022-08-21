PREFIX  = /usr
HOMEDIR = $(PREFIX)/share/hera
LIBDIR  = $(HOMEDIR)/lib

install:
	bash install-requirements.sh
	mkdir -p $(LIBDIR)
	cp ./lib/*.sh $(LIBDIR)
	cp ./etc/herapkg.conf /etc/herapkg.conf
	install -m 755 ./src/hera.sh $(PREFIX)/bin/hera

uninstall:
	rm -rf $(HOMEDIR) $(PREFIX)/bin/hera /etc/herapkg.conf

reinstall:
	rm -rf $(HOMEDIR) $(PREFIX)/bin/hera /etc/herapkg.conf
	bash install-requirements.sh
	mkdir -p $(LIBDIR)
	cp ./lib/*.sh $(LIBDIR)
	cp ./etc/herapkg.conf /etc/herapkg.conf
	install -m 755 ./src/hera.sh $(PREFIX)/bin/hera
