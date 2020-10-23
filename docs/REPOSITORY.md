Using the repository
====================

Building XEPs
-------------

You'll need xmllint and xsltproc.

On Ubuntu, you can install them with `sudo apt install libxml2-utils xsltproc`

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

A full set of HTML and PDFs can be generated inside a docker container, with no
dependencies on the host other than Docker itself, and served by nginx in the
container. To build the template `make docker`, to run it `make testdocker`
(serves on http://localhost:3080), and to stop/delete it afterwards `make
stopdocker`
