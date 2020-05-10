TOOL_NAME = sourcedocs
VERSION = 1.0.0

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
	swift run sourcedocs generate --clean --spm-module SourceDocsDemo --output-folder docs/reference --module-name-path --min-acl private
	swift run sourcedocs generate --clean --spm-module SourceDocsLib --output-folder docs/reference --module-name-path
	swift run sourcedocs package -o docs/

linuxmain:
	swift test --generate-linuxmain

zip: build
	zip -D $(TOOL_NAME).macos.zip $(BUILD_PATH)

get_sha:
	curl -OLs https://github.com/eneko/$(TOOL_NAME)/archive/$(VERSION).tar.gz
	shasum -a 256 $(TAR_FILENAME) | cut -f 1 -d " " > sha_$(VERSION).txt
	rm $(TAR_FILENAME)

brew_push: get_sha
	SHA=$(shell cat sha_$(VERSION).txt); \
	brew bump-formula-pr --url=https://github.com/eneko/$(TOOL_NAME)/archive/$(VERSION).tar.gz --sha256=$$SHA

