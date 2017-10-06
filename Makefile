TOOL_NAME = sourcedocs

PREFIX = /usr/local
INSTALL_PATH = $(PREFIX)/bin/$(TOOL_NAME)
BUILD_PATH = .build/release/$(TOOL_NAME)
#CURRENT_PATH = $(PWD)

install: build
	mkdir -p $(PREFIX)/bin
	cp -f $(BUILD_PATH) $(INSTALL_PATH)

build:
	swift package clean
	swift build --disable-sandbox -c release -Xswiftc -static-stdlib

uninstall:
	rm -f $(INSTALL_PATH)
