# Project
NAME=rawide
VERSION=1.0

# Sources
TRADS=i18n
BLD=build
POS=$(wildcard $(TRADS)/*.po)
MOS=$(POS:$(TRADS)/%.po=$(BLD)/%.mo)

# Targets
DESTDIR?=pkg
BIN?=usr/bin
LOCALE?=usr/share/locale
TARGETS=$(BIN)/$(NAME) $(MOS:$(BLD)/%.mo=$(LOCALE)/%/LC_MESSAGES/$(NAME).mo)
INSTALLED=$(TARGETS:%=$(DESTDIR)/%)
PO=$(TRADS)/$(shell echo $(LANG) | sed 's|_.*||').po

# Rights
EXEC=755
NOEXEC=644

.PHONY: all install uninstall translate clean mrproper

all: $(BLD)/ $(MOS)

install: $(INSTALLED)

%/:
	mkdir -p $@

$(BLD)/%.mo: $(TRADS)/%.po $(BLD)/
	msgfmt $< -o $@

$(DESTDIR)/$(BIN)/$(NAME): $(NAME)
	install -D -m $(EXEC) $< $@

$(DESTDIR)/$(LOCALE)/%/LC_MESSAGES/$(NAME).mo: $(BLD)/%.mo
	install -D -m $(NOEXEC) $< $@

$(TRADS)/$(NAME).pot: $(NAME)
	xgettext -L Shell -k_ --omit-header -o $@ $<

$(PO): $(TRADS)/$(NAME).pot
ifeq ($(shell [ -f '$(PO)' ] || echo 'missing'), missing)
	msginit -i $^ -o $@
else
	msgmerge -o $@ $@ $^

endif

translate: $(PO)
	$(EDITOR) $<

uninstall:
	rm -f $(INSTALLED)

clean:
	rm -f $(MOS)

mrproper: clean
	rm -rf $(BLD)

