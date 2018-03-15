#!/bin/sh
swift package clean
swift test
swift build -c release
cp .build/release/StringTool /usr/local/bin/stringtool
