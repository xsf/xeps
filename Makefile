.SILENT:

OUTDIR?=build
RESOURCESDIR=$(OUTDIR)/resources
TEMPDIR?=$(OUTDIR)/xepbuild
XMLDEPS=xep.xsl xep.xsd xep.ent xep.dtd ref.xsl $(OUTDIR)
TEXMLDEPS=xep2texml.xsl $(TEMPDIR) $(XMLDEPS) $(RESOURCESDIR)/xmpp.pdf $(RESOURCESDIR)/xmpp-text.pdf
XMPPIMAGESURL=https://xmpp.org/images


.PHONY: help
help:
	@echo 'XEP makefile targets:'
	@echo ' '
	@echo '                  help  -  (this message)'
	@echo '                   all  -  build all XEPs (html and pdfs)'
	@echo '                   pdf  -  build all XEPs'
	@echo '                  html  -  build all XEPs'
	@echo '                 clean  -  recursively unlink the build tree'
	@echo '              xep-xxxx  -  build xep-xxxx.html and xep-xxxx.pdf'
	@echo '         xep-xxxx.html  -  build xep-xxxx.html'
	@echo '          xep-xxxx.pdf  -  build xep-xxxx.html'
	@echo ' '
	@echo 'Output directory: "$(OUTDIR)/"'

.PHONY: all
all: html pdfs

.PHONY: html
html: $(patsubst %.xml, $(OUTDIR)/%.html, $(wildcard *.xml))

.PHONY: pdf
pdf: $(patsubst %.xml, $(OUTDIR)/%.pdf, $(wildcard *.xml))

.PHONY: xep-%
xep-%: $(OUTDIR)/xep-%.html $(OUTDIR)/xep-%.pdf ;

.PHONY: xep-%.html
xep-%.html: $(OUTDIR)/xep-%.html ;

.PHONY: xep-%.pdf
xep-%.pdf: $(OUTDIR)/xep-%.pdf ;

$(OUTDIR)/%.html: %.xml $(XMLDEPS)
	xsltproc --path $(CURDIR) xep.xsl "$<" > "$@" && echo "Finished building $@"

$(OUTDIR)/%.pdf: %.xml $(TEMPDIR)/%.xml.texml $(TEMPDIR)/%.xml.texml.tex $(TEXMLDEPS)
	cd $(TEMPDIR); xelatex $(TEMPDIR)/$<.texml.tex
	mv $(TEMPDIR)/$<.texml.pdf $(OUTDIR)/$(patsubst %.xml.pdf,%.pdf,$<.pdf)
	echo "Finished building $(patsubst %.xml.pdf,%.pdf,$<.pdf)"

$(TEMPDIR)/%.xml.texml: %.xml $(TEXMLDEPS) $(TEMPDIR)
	xsltproc -o $(TEMPDIR)/$<.texml xep2texml.xsl "$<"

$(TEMPDIR)/%.xml.texml.tex: $(TEMPDIR)/%.xml.texml $(OUTDIR) $(TEMPDIR)
	texml -e utf8 $< $<.tex
	sed -i -e 's|\([\s"]\)\([^"]http\://[^ "]*\)|\1\\path{\2}|g' \
	       -e 's|\\hyperref\[#\([^}]*\)\]|\\hyperref\[\1\]|g' \
	       -e 's|\\pageref{#\([^}]*\)}|\\pageref{\1}|g' $<.tex

$(RESOURCESDIR)/xmpp-text.pdf: $(RESOURCESDIR)
	curl -o $@ $(XMPPIMAGESURL)/xmpp-text.pdf

$(RESOURCESDIR)/xmpp.pdf: $(RESOURCESDIR)
	curl -o $@ $(XMPPIMAGESURL)/images/xmpp.pdf

$(TEMPDIR) $(OUTDIR) $(RESOURCESDIR):
	mkdir -p $@

.PHONY: clean
clean:
	rm -rf $(OUTDIR)
