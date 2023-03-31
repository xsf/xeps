#!/bin/bash

echo "Ensure you have ../xep-attic, then press enter"
read
echo "Generating pre-merge xeplist"
make build/xeplist.xml
cp build/xeplist.xml tools/old-xeplist.xml
echo "Do your merges now and update the local checkout if you did that remotely (enter)"
echo "(Follow https://github.com/xsf/xeps/blob/master/docs/PROCESSING.md )"
read
make build/xeplist.xml
echo "Now archiving (enter)"
read
./tools/archive.py tools/old-xeplist.xml build/xeplist.xml
pushd ../xep-attic
git add content/xep-*
git commit -a -m "Add latest changes"
echo "Showing commit (enter)"
read
git show
echo "If that looks good, push (enter)"
read
git push origin master
popd
echo "Now generate the docker image and upload it (enter)"
read
echo "Performing dry-run email using ./tools/xeps-email.conf (create if you don't have it) (enter)"
read
./tools/send-updates.py -c tools/xeps-email.conf --dry-run tools/old-xeplist.xml build/xeplist.xml standards@xmpp.org
echo "Assuming that was right, running the real emails (enter)"
read
./tools/send-updates.py -c tools/xeps-email.conf tools/old-xeplist.xml build/xeplist.xml standards@xmpp.org
