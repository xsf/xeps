#!/bin/bash

xmllint --nonet --noent --loaddtd "$@" | lua5.3 -lluarocks.loader ${0%/*}/xep2md.lua
