#!/bin/sh
swift package clean
swift build -c release
cp .build/release/StringTool /usr/local/bin/stringtool
