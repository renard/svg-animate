PACKAGE = svg-animate
VERSION = $(shell grep '\\def\\svganimateversion' $(PACKAGE).sty | sed 's/.*{\(.*\)}/\1/')

.PHONY: all clean ctan

all: example.svg test.svg svg-animate.pdf

## Animated SVG ────────────────────────────────────────────────────────────────

example.dvi: example.tex svg-animate.sty
	latex $<
	latex $<

example.svg: example.dvi
	dvisvgm --font-format=woff2 --optimize=all --bbox=min $< -o $@

## Static PDF of the example (included in svg-animate.pdf via \includegraphics) ────────

example.pdf: example.tex svg-animate.sty
	xelatex $<

# ==========

test.dvi: test.tex svg-animate.sty
	latex $<
	latex $<

test.svg: test.dvi
	dvisvgm --font-format=woff2 --optimize=all --bbox=papersize $< -o $@

## Static PDF of the example (included in svg-animate.pdf via \includegraphics) ────────

test.pdf: test.tex svg-animate.sty
	xelatex $<


# ==========
## Documentation PDF ──────────────────────────────────────────────────────────

svg-animate.pdf: svg-animate.tex svg-animate.sty example.pdf
	xelatex $<
	xelatex $<

## CTAN archive ────────────────────────────────────────────────────────────────

ctan: svg-animate.pdf
	rm -rf $(PACKAGE)-$(VERSION) $(PACKAGE)-$(VERSION).zip
	git archive HEAD --prefix=$(PACKAGE)-$(VERSION)/ --format=tar | tar -x
	rm -f $(PACKAGE)-$(VERSION)/.gitignore
	zip -r $(PACKAGE)-$(VERSION).zip $(PACKAGE)-$(VERSION)
	rm -rf $(PACKAGE)-$(VERSION)
	@echo "Created $(PACKAGE)-$(VERSION).zip"

## Cleanup ────────────────────────────────────────────────────────────────────

clean:
	rm -f *.aux *.log *.dvi *.toc *.out *.tcbtemp

clean-all: clean
	rm -f example*.svg example*.pdf test*.svg test*.pdf svg-animate.pdf
	rm -f $(PACKAGE)-*.zip
	rm -rf $(PACKAGE)-*/
