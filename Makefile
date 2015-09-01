.SILENT:

OUTDIR?=build
TEMPDIR?=$(TMPDIR)/xepbuild
XMLDEPS=xep.xsl xep.xsd xep.ent xep.dtd ref.xsl $(OUTDIR)
TEXMLDEPS=xep2texml.xsl $(TEMPDIR) $(XMLDEPS) $(TEMPDIR)/xmpp.pdf $(TEMPDIR)/xmpp-text.pdf


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
xep-%: $(OUTDIR)/xep-%.html $(OUTDIR)/xep-%.pdf
	

.PHONY: xep-%.html
xep-%.html: $(OUTDIR)/xep-%.html
	

.PHONY: xep-%.pdf
xep-%.pdf: $(OUTDIR)/xep-%.pdf
	

$(OUTDIR)/%.html: %.xml $(XMLDEPS)
	xsltproc xep.xsl "$<" > "$@"

$(OUTDIR)/%.pdf: %.xml $(TEMPDIR)/%.xml.texml $(TEMPDIR)/%.xml.texml.tex $(TEXMLDEPS)
	cd $(TEMPDIR); xelatex $(TEMPDIR)/$<.texml.tex
	mv $(TEMPDIR)/$<.texml.pdf $(OUTDIR)/$(patsubst %.xml.pdf,%.pdf,$<.pdf)

$(TEMPDIR)/%.xml.texml: %.xml $(TEXMLDEPS) $(TEMPDIR)
	xsltproc -o $(TEMPDIR)/$<.texml xep2texml.xsl "$<"

$(TEMPDIR)/%.xml.texml.tex: $(TEMPDIR)/%.xml.texml $(OUTDIR) $(TEMPDIR)
	texml -e utf8 $< $<.tex
	sed -i 's|\([\s"]\)\([^"]http://[^ "]*\)|\1\\path{\2}|g' $<.tex
	sed -i 's|\\hyperref\[#\([^}]*\)\]|\\hyperref\[\1\]|g' $<.tex
	sed -i 's|\\pageref{#\([^}]*\)}|\\pageref{\1}|g' $<.tex

$(TEMPDIR)/xmpp-text.pdf: $(TEMPDIR)
	-[ -e $(TEMPDIR)/xmpp-text.pdf ] || curl -o "$(TEMPDIR)/xmpp-text.pdf" https://xmpp.org/images/xmpp-text.pdf

$(TEMPDIR)/xmpp.pdf: $(TEMPDIR)
	-[ -e $(TEMPDIR)/xmpp.pdf ] || curl -o "$(TEMPDIR)/xmpp.pdf" https://xmpp.org/images/xmpp.pdf

$(TEMPDIR):
	mkdir -p $(TEMPDIR)

$(OUTDIR):
	mkdir -p $(OUTDIR)

.PHONY: clean
clean:
	rm -rf $(TEMPDIR)
	rm -rf $(OUTDIR)
