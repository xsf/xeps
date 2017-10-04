.SILENT:

OUTDIR?=build
REFSDIR?=$(OUTDIR)/refs
EXAMPLESDIR?=$(OUTDIR)/examples
XMLDEPS=xep.xsd xep.ent xep.dtd ref.xsl $(OUTDIR)
TEXMLDEPS=xep2texml.xsl $(OUTDIR)/xmpp.pdf $(OUTDIR)/xmpp-text.pdf
XEPDIRS=. inbox
HTMLDEPS=xep.xsl $(CSSTARGETS) $(JSTARGETS)

base_CSSTARGETS=xmpp.css prettify.css
CSSTARGETS=$(addprefix $(OUTDIR)/,$(base_CSSTARGETS))
proto_CSSTARGETS=$(addprefix $(OUTDIR)/inbox/,$(base_CSSTARGETS))
base_JSTARGETS=prettify.js
JSTARGETS=$(addprefix $(OUTDIR)/,$(base_JSTARGETS))
proto_JSTARGETS=$(addprefix $(OUTDIR)/inbox/,$(base_JSTARGETS))

proto_HTMLDEPS=xep.xsl $(proto_CSSTARGETS) $(proto_JSTARGETS)

DO_XELATEX=cd $(OUTDIR); xelatex --interaction=nonstopmode -no-shell-escape "$(notdir $(basename $@)).tex" >/dev/null

xeps=$(wildcard *.xml)
proto_xeps=$(wildcard inbox/*.xml)
all_xeps=$(xeps) $(proto_xeps)

xep_xmls=$(patsubst %.xml,$(OUTDIR)/%.xml,$(xeps))
proto_xep_xmls=$(patsubst %.xml,$(OUTDIR)/%.xml,$(proto_xeps))
all_xep_xmls=$(xep_xmls) $(proto_xep_xmls)

xep_htmls=$(patsubst %.xml,$(OUTDIR)/%.html,$(xeps))
proto_xep_htmls=$(patsubst %.xml,$(OUTDIR)/%.html,$(proto_xeps))
all_xep_htmls=$(xep_htmls) $(proto_xep_htmls)

xep_pdfs=$(patsubst %.xml,$(OUTDIR)/%.pdf,$(xeps))
xep_refs=$(patsubst xep-%.xml, $(REFSDIR)/reference.XSF.XEP-%.xml, $(xeps))
xep_examples=$(patsubst xep-%.xml, $(EXAMPLESDIR)/%.xml, $(xeps))


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

.PHONY: xeplist
xeplist: $(OUTDIR)/xeplist.xml

.PHONY: html
html: $(xep_htmls)

.PHONY: xml
xml: $(xep_xmls)

.PHONY: inbox-html
inbox-html: $(proto_xep_htmls)

.PHONY: inbox-xml
inbox-xml: $(proto_xep_xmls)

.PHONY: pdf
pdf: $(xep_pdfs)

.PHONY: refs
refs: $(xep_refs)

.PHONY: examples
examples: $(xep_examples)

.PHONY: xep-%
xep-%: $(OUTDIR)/xep-%.html $(REFSDIR)/reference.XSF.XEP-%.xml $(OUTDIR)/xep-%.pdf $(EXAMPLESDIR)/%.xml;

.PHONY: xep-%.html
xep-%.html: $(OUTDIR)/xep-%.html ;

.PHONY: xep-%.pdf
xep-%.pdf: $(OUTDIR)/xep-%.pdf ;

$(all_xep_xmls): $(OUTDIR)/%.xml: %.xml
	cp $< $@

$(OUTDIR)/xeplist.xml: $(wildcard *.xml) $(wildcard inbox/*.xml)
	./tools/extract-metadata.py > $@

$(EXAMPLESDIR)/%.xml: xep-%.xml $(XMLDEPS) examples.xsl $(EXAMPLESDIR)
	xsltproc --path $(CURDIR) examples.xsl "$<" > "$@" && echo "Finished building $@"

$(REFSDIR)/reference.XSF.XEP-%.xml: xep-%.xml $(XMLDEPS) ref.xsl $(REFSDIR)
	xsltproc --path $(CURDIR) ref.xsl "$<" > "$@" && echo "Finished building $@"

$(xep_htmls): $(OUTDIR)/xep-%.html: xep-%.xml $(XMLDEPS) $(HTMLDEPS)
	xmllint --nonet --noout --noent --loaddtd --valid "$<"
	# Check for non-data URIs
	! xmllint --nonet --noout --noent --loaddtd --xpath "//img/@src[not(starts-with(., 'data:'))]" $< 2>/dev/null && true

	# Actually build the HTML
	xsltproc --path $(CURDIR) --param htmlbase "$(if $(findstring inbox,$<),'../','./')" xep.xsl "$<" > "$@" && echo "Finished building $@"

$(proto_xep_htmls): $(OUTDIR)/inbox/%.html: inbox/%.xml $(XMLDEPS) $(proto_HTMLDEPS)
	xmllint --nonet --noout --noent --loaddtd --valid "$<"
	# Check for non-data URIs
	! xmllint --nonet --noout --noent --loaddtd --xpath "//img/@src[not(starts-with(., 'data:'))]" $< 2>/dev/null && true

	# Actually build the HTML
	xsltproc --path $(CURDIR) --param htmlbase "$(if $(findstring inbox,$<),'../','./')" xep.xsl "$<" > "$@" && echo "Finished building $@"

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
	while ($(DO_XELATEX) ; \
		grep -q "Rerun to get" $(<:.xml=.log) ) do true; \
	done
	echo "Finished building $@"

$(JSTARGETS): $(OUTDIR)
	cp "$(notdir $@)" "$@"

$(CSSTARGETS): $(OUTDIR)
	cp "$(notdir $@)" "$@"

$(proto_JSTARGETS): $(OUTDIR)/inbox
	cp "$(notdir $@)" "$@"

$(proto_CSSTARGETS): $(OUTDIR)/inbox
	cp "$(notdir $@)" "$@"

$(EXAMPLESDIR) $(REFSDIR) $(OUTDIR) $(OUTDIR)/inbox:
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

.PHONY: docker
docker:
	docker build -t xmpp-org/extensions .

.PHONY: testdocker
testdocker:
	docker run -d --name tmpxeps -p 3080:80 xmpp-org/extensions

.PHONY: stopdocker
stopdocker:
	docker stop tmpxeps; docker rm -v tmpxeps
