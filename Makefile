install:
	mkdir -p /usr/share/hera/lib /usr/share/hera/repositories /usr/share/licenses/hera /usr/share/doc/hera
	install -m 755 ./lib/*.sh /usr/share/hera/lib
	install -m 755 ./init.sh /usr/share/hera
	install -m 755 ./hera.sh /usr/bin/hera

uninstall:
	rm -rf /usr/share/hera /usr/share/licenses/hera /usr/share/doc/hera /usr/bin/hera

reinstall:
	rm -rf /usr/share/hera /usr/share/licenses/hera /usr/share/doc/hera /usr/bin/hera
	mkdir -p /usr/share/hera/lib /usr/share/hera/repositories /usr/share/licenses/hera /usr/share/doc/hera
	install -m 755 ./lib/*.sh /usr/share/hera/lib
	install -m 755 ./init.sh /usr/share/hera
	install -m 755 ./hera.sh /usr/bin/hera