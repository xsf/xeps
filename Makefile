.SILENT:

OUTDIR?=build
RESOURCESDIR=$(OUTDIR)/resources
TEMPDIR?=$(OUTDIR)/xepbuild
XMLDEPS=xep.xsl xep.xsd xep.ent xep.dtd ref.xsl $(OUTDIR)
TEXMLDEPS=xep2texml.xsl $(TEMPDIR) $(XMLDEPS) $(RESOURCESDIR)/xmpp.pdf $(RESOURCESDIR)/xmpp-text.pdf
XMPPIMAGESURL=https://xmpp.org/images
XEPDIRS=. inbox


.PHONY: help
help:
	@echo 'XEP makefile targets:'
	@echo ' '
	@echo '                  help  -  (this message)'
	@echo '                   all  -  build all XEPs (same as make html)'
	@echo '                  html  -  build all XEPs'
	@echo '                 clean  -  recursively unlink the build tree'
	@echo '               preview  -  builds html whenever an XEP changes (requires inotify-tools)'
	@echo '              xep-xxxx  -  build xep-xxxx.html'
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

.PHONY: xep-%
xep-%: $(OUTDIR)/xep-%.html ;

.PHONY: xep-%.html
xep-%.html: $(OUTDIR)/xep-%.html ;

.PHONY: xep-%.pdf
xep-%.pdf: $(OUTDIR)/xep-%.pdf ;

.PHONY: dependencies
dependencies: $(OUTDIR)/prettify.css $(OUTDIR)/prettify.js $(OUTDIR)/xmpp.css ;

$(OUTDIR)/%.html: %.xml $(XMLDEPS) dependencies
	# TODO: After existing issues are worked out this and the ratcheting CI build
	#       should be removed and become an error, not just a warning.
	xmllint --nonet --noout --noent --loaddtd --valid "$<" || true
	# Check for non-data URIs
	! xmllint --nonet --noout --noent --loaddtd --xpath "//img/@src[not(starts-with(., 'data:'))]" $< 2>/dev/null && true

	# Actually build the HTML
	xsltproc --path $(CURDIR) xep.xsl "$<" > "$@" && echo "Finished building $@"

$(OUTDIR)/%.pdf: %.xml $(XMLDEPS) dependencies
	# TODO: After existing issues are worked out this and the ratcheting CI build
	#       should be removed and become an error, not just a warning.
	xmllint --nonet --noout --noent --loaddtd --valid "$<" || true
	# Check for non-data URIs
	! xmllint --nonet --noout --noent --loaddtd --xpath "//img/@src[not(starts-with(., 'data:'))]" $< 2>/dev/null && true

	xsltproc --path $(CURDIR) xep2texml.xsl "$<" > "$(@:.pdf=.tex.xml)"
	texml -e utf8 "$(@:.pdf=.tex.xml)" "$(@:.pdf=.tex)"
	sed -i -e 's|\([\s"]\)\([^"]http://[^ "]*\)|\1\\path{\2}|g' \
		-e 's|\\hyperref\[#\([^}]*\)\]|\\hyperref\[\1\]|g' \
		-e 's|\\pageref{#\([^}]*\)}|\\pageref{\1}|g' "$(@:.pdf=.tex)"
	cd $(OUTDIR); xelatex -interaction=batchmode -no-shell-escape "$(notdir $(basename $@)).tex" && echo "Finished building $@"

$(OUTDIR)/%.js: %.js
	cp "$<" "$@"

$(OUTDIR)/%.css: %.css
	cp "$<" "$@"

$(TEMPDIR) $(OUTDIR) $(RESOURCESDIR):
	mkdir -p $@

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
