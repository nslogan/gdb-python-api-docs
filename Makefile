
# You can set these variables from the command line.
#
# TODO(logan): Why are these assigned using the "dynamic" syntax instead of
# "static" ":=" (?) It's been a while since I've done make stuff
PYTHON        = python3
VENVDIR       = ./.venv
UV            = uv
REQUIREMENTS  = requirements.txt
SPHINXBUILD   = PATH=$(VENVDIR)/bin:$$PATH sphinx-build
JOBS          = auto
SOURCES       =
BUILDER       = html
# SPHINXERRORHANDLING = -W
ALLSPHINXOPTS = -b $(BUILDER) \
                -d build/doctrees \
                -j $(JOBS) \
                $(SPHINXOPTS) $(SPHINXERRORHANDLING) \
                . build/$(BUILDER) $(SOURCES)

# TODO(logan): Intelligent directory building
.PHONY: build
build:
	-mkdir -p build
	$(SPHINXBUILD) $(ALLSPHINXOPTS)

.PHONY: clean-venv
clean-venv:
	rm -rf $(VENVDIR)

.PHONY: venv
venv:
	@if [ -d $(VENVDIR) ] ; then \
		echo "venv already exists."; \
		echo "To recreate it, remove it first with \`make clean-venv'."; \
	else \
		echo "Creating venv in $(VENVDIR)"; \
		if $(UV) --version >/dev/null 2>&1; then \
			$(UV) venv $(VENVDIR); \
			VIRTUAL_ENV=$(VENVDIR) $(UV) pip install -r $(REQUIREMENTS); \
		else \
			$(PYTHON) -m venv $(VENVDIR); \
			$(VENVDIR)/bin/python3 -m pip install --upgrade pip; \
			$(VENVDIR)/bin/python3 -m pip install -r $(REQUIREMENTS); \
		fi; \
		echo "The venv has been created in the $(VENVDIR) directory"; \
	fi
