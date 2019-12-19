.POSIX:
.SUFFIXES:
.PHONY: \
	clean \
	docker \
	dockerhtml \
	examples \
	help \
	html \
	pdf \
	preview \
	refs \
	stopdocker \
	xeplist \
	xml \
	testdocker

# Normalize .CURDIR as used by NetBSD Make et al and CURDIR as used by GNU Make.
.CURDIR?=$(CURDIR)
.CURDIR?=$(PWD)

OUT?=build
XEPS!=find . -type d -path ./$(OUT) -prune -o -type f \( -name '*.xml' ! -name '*.tex.xml' \) -print
NUMBERED!=find . -maxdepth 1 -type f -regex '.*xep-....\.xml' -print
REFS:=$(NUMBERED:./xep-%.xml=$(OUT)/refs/reference.XSF.XEP-%.xml)
EXAMPLES:=$(NUMBERED:./xep-%.xml=$(OUT)/examples/%.xml)

CSS=xmpp.css prettify.css
JS=prettify.js

help:
	@echo 'Makefile targets:'
	@echo ' '
	@echo '   xep-xxxx.pdf — build xep-xxxx.pdf (requires xelatex and texml)'
	@echo '  xep-xxxx.html — build xep-xxxx.html'
	@echo ' '
	@echo '           help — (this message)'
	@echo '           refs — build all IETF refs to $(OUT)/refs/'
	@echo '           html — build all XEPs to $(OUT)/'
	@echo '          clean — recursively unlink $(OUT) tree and other build files'
	@echo '        preview — builds html whenever an XEP changes (requires inotify-tools)'
	@echo '       examples — extract all examples'
	@echo '        xeplist — build the index of XEPs'
	@echo ' '
	@echo 'Output directory: "$(OUT)/"'

$(OUT) $(OUT)/examples $(OUT)/refs $(OUT)/inbox:
	mkdir -p $@

.SUFFIXES: .xml .html
.xml.html: $< xep.xsl $(CSS) $(JS)
	xmllint --nonet --noout --noent --loaddtd --valid "$<"
	! xmllint --nonet --noout --noent --loaddtd --xpath "//img/@src[not(starts-with(., 'data:'))]" "$<" 2>/dev/null && true

	RELPATH=$$(realpath --relative-to=`dirname $@` $(.CURDIR)); xsltproc --path $(.CURDIR) --param htmlbase $${RELPATH} xep.xsl "$<" > "$@"

$(CSS:%=$(OUT)/%) $(JS:%=$(OUT)/%) $(OUT)/xmpp.pdf $(OUT)/xmpp-text.pdf: $(OUT) xmpp.pdf xmpp-text.pdf $(CSS) $(JS)
	cp "$$(basename $@)" '$(OUT)'

.SUFFIXES: .xml .pdf
.xml.pdf: $< xep2texml.xsl xmpp.pdf xmpp-text.pdf
	xmllint --nonet --noout --noent --loaddtd --valid "$<"
	! xmllint --nonet --noout --noent --loaddtd --xpath "//img/@src[not(starts-with(., 'data:'))]" $< 2>/dev/null && true

	xsltproc --path $(.CURDIR) xep2texml.xsl "$<" > "$(@:%.pdf=%.tex.xml)"
	texml -e utf8 "$(@:%.pdf=%.tex.xml)" "$(@:%.pdf=%.tex)"
	sed -i -e 's|\([\s"]\)\([^"]http://[^ "]*\)|\1\\path{\2}|g' \
		-e 's|\\hyperref\[#\([^}]*\)\]|\\hyperref\[\1\]|g' \
		-e 's|\\pageref{#\([^}]*\)}|\\pageref{\1}|g' "$(@:%.pdf=%.tex)"

	while (cd "$$(dirname $@)"; xelatex --interaction=nonstopmode -no-shell-escape "$$(basename $(@:%.pdf=%)).tex" >/dev/null ; \
		grep -q "Rerun to get" "$$(basename $(<:%.xml=%.log))" ) do true; \
	done

clean:
	@rm -f $(XEPS:%.xml=%.aux)
	@rm -f $(XEPS:%.xml=%.html)
	@rm -f $(XEPS:%.xml=%.log)
	@rm -f $(XEPS:%.xml=%.out)
	@rm -f $(XEPS:%.xml=%.pdf)
	@rm -f $(XEPS:%.xml=%.tex)
	@rm -f $(XEPS:%.xml=%.tex.xml)
	@rm -f $(XEPS:%.xml=%.toc)
	@rm -rf ./$(OUT)

html: $(XEPS:%.xml=%.html) $(CSS:%=$(OUT)/%) $(JS:%=$(OUT)/%)
	@mkdir -p $$(dirname $(XEPS:%.xml=$(OUT)/%))
	@for f in $(XEPS:%.xml=%.html); do \
		cp "$$f" "$(OUT)/$$(dirname $$f)/"; \
	done

pdf: $(XEPS:%.xml=%.pdf) $(OUT)/xmpp.pdf $(OUT)/xmpp-text.pdf
	@mkdir -p $$(dirname $(XEPS:%.xml=$(OUT)/%))
	@for f in $(XEPS:%.xml=%.pdf); do \
		cp "$$f" "$(OUT)/$$(dirname $$f)/"; \
	done

$(XEPS:./%.xml=$(OUT)/%.xml): $(XEPS)
	mkdir -p "$$(dirname $@)"
	echo xmllint --nonet --noent --loaddtd --dropdtd "$(@:$(OUT)/%.xml=%.xml)" --output $@

$(OUT)/xeplist.xml: $(OUT) $(XEPS)
	./tools/extract-metadata.py > $@

$(EXAMPLES): $(XEPS) xep.xsd xep.ent xep.dtd examples.xsl $(OUT)/examples
	xsltproc --path $(.CURDIR) examples.xsl "$(@:$(OUT)/examples/%.xml=xep-%.xml)" > "$@"

$(REFS): $(XEPS) xep.xsd xep.ent xep.dtd ref.xsl $(OUT)/refs
	xsltproc --path $(.CURDIR) ref.xsl "$(@:$(OUT)/refs/reference.XSF.XEP-%.xml=xep-%.xml)" > "$@"

docker:
	docker build -t xmpp-org/extensions .

dockerhtml:
	docker build -t xmpp-org/extensions . --build-arg NCORES=9 --build-arg TARGETS="html"

testdocker:
	docker run -d --name tmpxeps -p 3080:80 xmpp-org/extensions

stopdocker:
	docker stop tmpxeps; docker rm -v tmpxeps

preview: $(CSS:%=$(OUT)/%) $(JS:%=$(OUT)/%)
	inotifywait -m -e close_write,moved_to --format '%e %w %f' . ./inbox | \
	while read -r event dir file; do \
		if [ "$${file: -4}" == ".xml" ]; then \
			xsltproc --path $(.CURDIR) xep.xsl "$${dir}/$${file}" > "$(OUT)/$${file%.*}.html" && echo "Built $${file%.*}.html $${event}"; \
		fi \
	done

xeplist: $(OUT)/xeplist.xml

$(XEPS:%.xml=$(OUT)/%.xml): $<
	xmllint --nonet --noent --loaddtd --dropdtd $< --output $@

refs: $(REFS)

xml: $(XEPS:./%.xml=$(OUT)/%.xml)

examples: $(EXAMPLES)
