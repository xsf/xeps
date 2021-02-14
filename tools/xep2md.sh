#!/bin/bash

xmllint --nonet --noent --loaddtd "$@" | lua5.3 -lluarocks.loader xep2md.lua
