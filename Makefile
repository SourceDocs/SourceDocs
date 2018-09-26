TOOL_NAME = sourcedocs
VERSION = 0.5.1

PREFIX = /usr/local
INSTALL_PATH = $(PREFIX)/bin/$(TOOL_NAME)
BUILD_PATH = .build/release/$(TOOL_NAME)
TAR_FILENAME = $(TOOL_NAME)-$(VERSION).tar.gz

.PHONY: build docs

install: build
	install -d "$(PREFIX)/bin"
	install -C -m 755 $(BUILD_PATH) $(INSTALL_PATH)

build:
	swift build --disable-sandbox -c release -Xswiftc -static-stdlib

uninstall:
	rm -f $(INSTALL_PATH)

lint:
	swiftlint autocorrect --quiet
	swiftlint lint --quiet

docs:
	swift run sourcedocs generate --clean --spm-module SourceDocsDemo --output-folder docs/reference --module-name-path

get_sha:
	wget https://github.com/eneko/$(TOOL_NAME)/archive/$(VERSION).tar.gz -O $(TAR_FILENAME)
	shasum -a 256 $(TAR_FILENAME)
	rm $(TAR_FILENAME)

