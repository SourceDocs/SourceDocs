TOOL_NAME = sourcedocs
VERSION = 0.6.1

PREFIX = /usr/local
INSTALL_PATH = $(PREFIX)/bin/$(TOOL_NAME)
BUILD_PATH = .build/release/$(TOOL_NAME)
TAR_FILENAME = $(VERSION).tar.gz

.PHONY: build docs

install: build
	install -d "$(PREFIX)/bin"
	install -C -m 755 $(BUILD_PATH) $(INSTALL_PATH)

build:
	swift build --disable-sandbox -c release 

uninstall:
	rm -f $(INSTALL_PATH)

lint:
	swiftlint autocorrect --quiet
	swiftlint lint --quiet --strict

docs:
	swift run sourcedocs generate --clean --spm-module SourceDocsDemo --output-folder docs/reference --module-name-path

xcode:
	swift package generate-xcodeproj --enable-code-coverage

linuxmain:
	swift test --generate-linuxmain

zip: build
	zip -D $(TOOL_NAME).macos.zip $(BUILD_PATH)

get_sha:
	curl -OLs https://github.com/eneko/$(TOOL_NAME)/archive/$(VERSION).tar.gz
	shasum -a 256 $(TAR_FILENAME)
	rm $(TAR_FILENAME)

