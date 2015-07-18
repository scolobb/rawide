# Project
NAME=rawide
VERSION=1.0

# Sources
TRADS=i18n
BLD=build
POS=$(wildcard $(TRADS)/*/$(NAME).po)
MOS=$(POS:$(TRADS)/%/$(NAME).po=$(BLD)/%.mo)

# Targets
DESTDIR?=pkg
BIN?=usr/bin
LOCALE?=usr/share/locale
TARGETS=$(BIN)/$(NAME) $(MOS:$(BLD)/%.mo=$(LOCALE)/%/LC_MESSAGES/$(NAME).mo)
INSTALLED=$(TARGETS:%=$(DESTDIR)/%)

# Rights
EXEC=755
NOEXEC=644

all: $(BLD)/ $(MOS)

install: $(INSTALLED)

%/:
	mkdir -p $@

$(BLD)/%.mo: $(TRADS)/%/$(NAME).po $(BLD)/
	msgfmt $< -o $@

$(DESTDIR)/$(BIN)/$(NAME): $(NAME)
	install -D -m $(EXEC) $< $@

$(DESTDIR)/$(LOCALE)/%/LC_MESSAGES/$(NAME).mo: $(BLD)/%.mo
	install -D -m $(EXEC) $< $@

uninstall:
	rm -f $(INSTALLED)

clean:
	rm -f $(MOS)

mrproper: clean
	rm -rf $(BLD)

