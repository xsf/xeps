[![Docker Build Status](https://img.shields.io/docker/build/xmppxsf/xeps.svg)](https://hub.docker.com/r/xmppxsf/xeps/)

XMPP Extension Protocols (XEPs)
=========

This repository is used to manage work on XMPP Extension Protocols
(XEPs), which are the specifications produced by the XMPP Standards
Foundation (XSF). See http://xmpp.org/ for details. The rendered
documents can be found here:

https://xmpp.org/extensions/

Please use this repository to raise issues and submit pull requests:

https://github.com/xsf/xeps/issues
https://github.com/xsf/xeps/pulls

For in-depth technical discussion, please post to the standards@xmpp.org
email list:

http://mail.jabber.org/mailman/listinfo/standards

To submit a new proposal for consideration as a XEP, please read this
page:

https://xmpp.org/about/standards-process.html#submitting-a-xep

[XEP-0001: XMPP Extension Protocols](https://xmpp.org/extensions/xep-0001.html)
defines the standards process followed by the XMPP Standards Foundation.

Building XEPs
-------------

To build a single XEP as HTML simply run:

    make xep-xxxx.html

To build PDFs, you'll need to install [TeXML](http://getfo.org/texml/) (probably
in a Python 2 virtual environment).
You can then build PDFs with:

    make xep-xxxx.pdf

To change the output directory, set the variable `OUTDIR`, eg.

    OUTDIR=/tmp/xeps make all

For more information try `make help`.

Using Docker
------------

A full set of HTML and PDFs can be generated inside a docker container, with no dependencies on the host other than Docker itself, and served by nginx in the container. To build the template `make docker`, to run it `make testdocker` (serves on http://localhost:3080), and to stop/delete it afterwards `make stopdocker`
