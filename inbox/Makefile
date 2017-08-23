OUTDIR?=../build/

xeps=$(wildcard *.xml)

.PHONY: all
all: html

html: $(patsubst %.xml, $(OUTDIR)/%.html, $(xeps))
