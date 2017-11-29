#!/bin/bash
( echo -ne '<root>'; xpath -e '/xep-infos/xep[string(status)="Proposed"]' build/xeplist.xml 2>/dev/null | tr -d '\n'; echo -ne '</root>' ) | python3 -c 'import lxml.etree, sys; tree = lxml.etree.fromstring(sys.stdin.read())
for xep in tree: print("XEP-{number:04d} ({title}), LC ends: {enddate}; https://xmpp.org/extensions/xep-{number:04d}.html".format(number=int(xep.find("number").text), enddate=xep.find("lastcall").text, title=xep.find("title").text))'
