# Makefile for generating assets using kicad-cli

# Project settings
PROJECT_NAME := lamp-control
SCHEMATIC := $(PROJECT_NAME).kicad_sch
BOARD := $(PROJECT_NAME).kicad_pcb

# Output directories
OUTPUT_DIR := build
GERBER_DIR := $(OUTPUT_DIR)/gerber
DOCS_DIR := docs

# Tools
KICAD_CLI := kicad-cli

# Output files
PDF_FILE := $(OUTPUT_DIR)/schematic.pdf
PNG_FILE := $(DOCS_DIR)/board.png
SVG_FILE := $(DOCS_DIR)/schematic.svg
GERBER_ZIP := $(OUTPUT_DIR)/gerber.zip
BOM_FILE := $(OUTPUT_DIR)/bom.csv
POS_FILE := $(OUTPUT_DIR)/pos.csv

.PHONY: all clean pdf gerber png svg zip bom pos docs assets help

all: docs build

docs: png svg

build: pdf bom pos gerber zip

pdf: $(PDF_FILE)

gerber: $(GERBER_DIR)/

png: $(PNG_FILE)

svg: $(SVG_FILE)

zip: $(GERBER_ZIP)

bom: $(BOM_FILE)

pos: $(POS_FILE)

$(PDF_FILE): $(SCHEMATIC)
	mkdir -p $(OUTPUT_DIR)
	$(KICAD_CLI) sch export pdf -o $@ $<

$(GERBER_DIR)/: $(BOARD)
	mkdir -p $(GERBER_DIR)
	$(KICAD_CLI) pcb export gerbers --output $(GERBER_DIR) $<
	$(KICAD_CLI) pcb export drill --output $(GERBER_DIR) $<

$(PNG_FILE): $(BOARD)
	mkdir -p $(DOCS_DIR)
	$(KICAD_CLI) pcb render --output $@ --rotate '315,0,315' --width 1920 --height 1080 --quality high --floor --zoom 0.75 $<

$(SVG_FILE): $(SCHEMATIC)
	mkdir -p $(DOCS_DIR)
	$(KICAD_CLI) sch export svg -o $(DOCS_DIR)/svg_tmp $<
	mv $(DOCS_DIR)/svg_tmp/$(PROJECT_NAME).svg $@
	rm -rf $(DOCS_DIR)/svg_tmp

$(BOM_FILE): $(SCHEMATIC)
	mkdir -p $(OUTPUT_DIR)
	$(KICAD_CLI) sch export bom --output $@ $<

$(POS_FILE): $(BOARD)
	mkdir -p $(OUTPUT_DIR)
	$(KICAD_CLI) pcb export pos --output $@ $<

$(GERBER_ZIP): $(GERBER_DIR)/
	cd $(GERBER_DIR) && zip -r ../gerber.zip .

clean:
	rm -rf $(OUTPUT_DIR) $(DOCS_DIR)/board.png $(DOCS_DIR)/schematic.svg $(DOCS_DIR)/svg_tmp

help:
	@echo "Makefile targets:"
	@echo "  all     - Build docs and assets (default)"
	@echo "  docs    - Build documentation images (PNG, SVG)"
	@echo "  build   - Build manufacturing assets (PDF, BOM, POS, Gerber, ZIP)"
	@echo "  pdf     - Export schematic as PDF (schematic.pdf)"
	@echo "  gerber  - Export PCB Gerber and drill files (for fabrication)"
	@echo "  png     - Render 3D board image (docs/board.png)"
	@echo "  svg     - Export schematic as SVG (docs/schematic.svg)"
	@echo "  zip     - Zip Gerber and drill files (gerber.zip)"
	@echo "  bom     - Export Bill of Materials (bom.csv)"
	@echo "  pos     - Export pick-and-place (component position) file (pos.csv)"
	@echo "  clean   - Remove all generated files"