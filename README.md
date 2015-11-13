XMPP Extension Protocols (XEPs)
=========

This repository is used to manage work on XMPP Extension Protocols
(XEPs), which are the specifications produced by the XMPP Standards
Foundation (XSF). See http://xmpp.org/ for details. The rendered
documents can be found here:

http://xmpp.org/xmpp-protocols/xmpp-extensions/

Please use this repository to raise issues and submit pull requests:

https://github.com/xsf/xeps/issues
https://github.com/xsf/xeps/pulls

For in-depth technical discussion, please post to the standards@xmpp.org
email list:

http://mail.jabber.org/mailman/listinfo/standards

To submit a new proposal for consideration as a XEP, please read this
page:

http://xmpp.org/xmpp-protocols/xmpp-extensions/submitting-a-xep/

[XEP-0001: XMPP Extension Protocols](http://xmpp.org/extensions/xep-0001.html)
defines the standards process followed by the XMPP Standards Foundation.

Building XEPs
-------------

To build a single XEP as HTML simply run:

    make xep-xxxx

To change the output directory, set the variable `OUTDIR`, eg.

    OUTDIR=/tmp/xeps make all

For more information try `make help`.
