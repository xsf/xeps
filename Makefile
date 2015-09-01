.SILENT:

OUTDIR?=build
XMLDEPS=xep.xsl xep.xsd xep.ent xep.dtd ref.xsl

.PHONY: help
help:
	@echo 'XEP makefile targets:'
	@echo ' '
	@echo '                  help  -  (this message)'
	@echo '                   all  -  build all XEPs'
	@echo '                 clean  -  recursively unlink the build tree'
	@echo '              xep-xxxx  -  build xep-xxxx.html'
	@echo ' '
	@echo 'Output directory: "$(OUTDIR)/"'

.PHONY: all
all: $(patsubst %.xml, $(OUTDIR)/%.html, $(wildcard *.xml))

.PHONY: xep-%
xep-%: $(OUTDIR)/xep-%.html
	

$(OUTDIR)/%.html: %.xml $(XMLDEPS) $(OUTDIR)
	xsltproc xep.xsl "$<" > "$@"

$(OUTDIR):
	mkdir -p $(OUTDIR)

.PHONY: clean
clean:
	rm -rf $(OUTDIR)
