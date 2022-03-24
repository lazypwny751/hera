# hera
alternative package manager written in bash 5.0.17

developed for [bychan multi tool](https://github.com/ByCh4n/BCHackTool) 

# installation
```
git clone https://github.com/ByCh4n-Group/hera ; cd hera && sudo bash installer.sh --install 
```

# uninstallation
```
cd /tmp
wget https://raw.githubusercontent.com/ByCh4n-Group/hera/main/installer.sh
sudo bash installer.sh --uninstall
```

# usage
```
~$ hera --build <dir1> <dir2>..:
    generate hera packages.

~$ hera --help:
    show this text.

~# hera --install <package1> <package2>..:
    Install packages from repositories or on your system.

~# hera --uninstall <package1> <package2>..:
    remove installed hera packages.

~$ hera --update:
    update catalogs.

~$ hera --list -p/-r:
    View packages installed with -p argument in repositories with -r.

~# hera --fix:
    If hera constantly makes mistakes, use this argument.
```

![image](https://user-images.githubusercontent.com/54551308/147975751-c91c3524-5fca-4901-a2ed-ed73c716a94c.png)


## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License
[GPL3](https://choosealicense.com/licenses/gpl-3.0/)
