#! /bin/bash

#TODO: enable source code for ubuntu
#TODO: install developscripts

apt-get build-dep snapd
TMPDIR=$(mktemp -d)
cd $TMPDIR
apt-get -y source snapd
sed -i 's/"http", "https", "mailto", "snap", "help"/"http", "https", "mailto", "snap", "help", "apt", "zoommtg", "slack"/' snapd-*/usersession/userd/launcher.go
sed -i 's/!osutil.GetenvBool(reExecKey, true)/true/' snapd-*/cmd/cmd_linux.go
cd snapd-* && dch -l$(hostname) fix_missing_app_types
cd ..
cd snapd-* && DEB_BUILD_OPTIONS=nocheck debuild -b -uc -us
cd ..
sudo dpkg -i snapd_*.deb
sudo service snapd restart
killall snap
