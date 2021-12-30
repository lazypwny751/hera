install:
	mkdir -p /usr/share/hera/lib /usr/share/hera/repositories /usr/share/licenses/hera /usr/share/doc/hera
	install -m 755 ./lib/*.sh /usr/share/hera/lib
	cp ./repositories.yaml /usr/share/hera
	install -m 755 ./init.sh /usr/share/hera
	install -m 755 ./hera.sh /usr/bin/hera
	chmod +x 755 /usr/share/hera/*
	@echo "packages.btb could not creating with make rules please run '~# hera --fix'"

uninstall:
	rm -rf /usr/share/hera /usr/share/licenses/hera /usr/share/doc/hera /usr/bin/hera

reinstall:
	rm -rf /usr/share/hera /usr/share/licenses/hera /usr/share/doc/hera /usr/bin/hera
	mkdir -p /usr/share/hera/lib /usr/share/hera/repositories /usr/share/licenses/hera /usr/share/doc/hera
	install -m 755 ./lib/*.sh /usr/share/hera/lib
	cp ./repositories.yaml /usr/share/hera
	install -m 755 ./init.sh /usr/share/hera
	install -m 755 ./hera.sh /usr/bin/hera
	chmod +x 755 /usr/share/hera/*
	@echo "packages.btb could not creating with make rules please run '~# hera --fix'"