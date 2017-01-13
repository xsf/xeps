.SILENT:
.SECONDARY:

OUTDIR?=build
REFSDIR?=$(OUTDIR)/refs
EXAMPLESDIR?=$(OUTDIR)/examples
XMLDEPS=xep.xsd xep.ent xep.dtd ref.xsl $(OUTDIR)
TEXMLDEPS=xep2texml.xsl $(OUTDIR)/xmpp.pdf $(OUTDIR)/xmpp-text.pdf
XMPPIMAGESURL=https://xmpp.org/images
XEPDIRS=. inbox
HTMLDEPS=xep.xsl $(OUTDIR)/prettify.css $(OUTDIR)/prettify.js $(OUTDIR)/xmpp.css


.PHONY: help
help:
	@echo 'XEP makefile targets:'
	@echo ' '
	@echo '                  help  -  (this message)'
	@echo '                   all  -  build all XEPs (same as make html)'
	@echo '                  refs  -  build all IETF refs'
	@echo '                  html  -  build all XEPs'
	@echo '                 clean  -  recursively unlink the build tree'
	@echo '               preview  -  builds html whenever an XEP changes (requires inotify-tools)'
	@echo '              examples  -  extract all examples'
	@echo '              xep-xxxx  -  build HTML, PDF, examples, and reference for the XEP'
	@echo '          xep-xxxx.pdf  -  build xep-xxxx.pdf (requires xelatex and texml)'
	@echo '         xep-xxxx.html  -  build xep-xxxx.html'
	@echo ' '
	@echo 'Output directory: "$(OUTDIR)/"'

.PHONY: all
all: html

.PHONY: html
html: $(patsubst %.xml, $(OUTDIR)/%.html, $(wildcard *.xml))

.PHONY: pdf
pdf: $(patsubst %.xml, $(OUTDIR)/%.pdf, $(wildcard *.xml))

.PHONY: refs
refs: $(patsubst xep-%.xml, $(REFSDIR)/reference.XSF.XEP-%.xml, $(wildcard *.xml))

.PHONY: examples
examples: $(patsubst xep-%.xml, $(EXAMPLESDIR)/%.xml, $(wildcard *.xml))

.PHONY: xep-%
xep-%: $(OUTDIR)/xep-%.html $(REFSDIR)/reference.XSF.XEP-%.xml $(OUTDIR)/xep-%.pdf $(EXAMPLESDIR)/%.xml;

.PHONY: xep-%.html
xep-%.html: $(OUTDIR)/xep-%.html ;

.PHONY: xep-%.pdf
xep-%.pdf: $(OUTDIR)/xep-%.pdf ;

$(EXAMPLESDIR)/%.xml: xep-%.xml $(XMLDEPS) examples.xsl $(EXAMPLESDIR)
	xsltproc --path $(CURDIR) examples.xsl "$<" > "$@" && echo "Finished building $@"

$(REFSDIR)/reference.XSF.XEP-%.xml: xep-%.xml $(XMLDEPS) ref.xsl $(REFSDIR)
	xsltproc --path $(CURDIR) ref.xsl "$<" > "$@" && echo "Finished building $@"

$(OUTDIR)/%.html: %.xml $(XMLDEPS) $(HTMLDEPS)
	xmllint --nonet --noout --noent --loaddtd --valid "$<"
	# Check for non-data URIs
	! xmllint --nonet --noout --noent --loaddtd --xpath "//img/@src[not(starts-with(., 'data:'))]" $< 2>/dev/null && true

	# Actually build the HTML
	xsltproc --path $(CURDIR) xep.xsl "$<" > "$@" && echo "Finished building $@"

$(OUTDIR)/xmpp.pdf $(OUTDIR)/xmpp-text.pdf: $(OUTDIR)
	cp "resources/$(notdir $@)" "$@"

$(OUTDIR)/%.pdf: %.xml $(XMLDEPS) $(TEXMLDEPS)
	xmllint --nonet --noout --noent --loaddtd --valid "$<"
	# Check for non-data URIs
	! xmllint --nonet --noout --noent --loaddtd --xpath "//img/@src[not(starts-with(., 'data:'))]" $< 2>/dev/null && true

	xsltproc --path $(CURDIR) xep2texml.xsl "$<" > "$(@:.pdf=.tex.xml)"
	texml -e utf8 "$(@:.pdf=.tex.xml)" "$(@:.pdf=.tex)"
	sed -i -e 's|\([\s"]\)\([^"]http://[^ "]*\)|\1\\path{\2}|g' \
		-e 's|\\hyperref\[#\([^}]*\)\]|\\hyperref\[\1\]|g' \
		-e 's|\\pageref{#\([^}]*\)}|\\pageref{\1}|g' "$(@:.pdf=.tex)"
	cd $(OUTDIR); xelatex -interaction=batchmode -no-shell-escape "$(notdir $(basename $@)).tex" && echo "Finished building $@"

$(OUTDIR)/%.js: %.js $(OUTDIR)
	cp "$<" "$@"

$(OUTDIR)/%.css: %.css $(OUTDIR)
	cp "$<" "$@"

$(EXAMPLESDIR) $(REFSDIR) $(OUTDIR):
	mkdir -p "$@"

.PHONY: clean
clean:
	rm -rf $(OUTDIR)

.PHONY: preview
preview:
	inotifywait -m -e close_write,moved_to --format '%e %w %f' $(XEPDIRS) | \
	while read -r event dir file; do \
		if [ "$${file: -4}" == ".xml" ]; then \
			xsltproc --path $(CURDIR) xep.xsl "$${dir}/$${file}" > "$(OUTDIR)/$${file%.*}.html" && echo "Built $${file%.*}.html $${event}"; \
		fi \
	done
