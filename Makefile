PACKAGE = svg-animate
VERSION = $(shell grep '\\def\\svganimateversion' $(PACKAGE).sty | sed 's/.*{\(.*\)}/\1/')

## Report overfull hboxes wider than this many points.
CHECK_THRESHOLD = 5

.PHONY: all clean ctan check

all: svg-animate-example.svg svg-animate-test.svg svg-animate.pdf

## Animated SVG ────────────────────────────────────────────────────────────────

svg-animate-example.dvi: svg-animate-example.tex svg-animate.sty
	latex $<
	latex $<

svg-animate-example.svg: svg-animate-example.dvi
	dvisvgm --font-format=woff2 --optimize=all --bbox=min $< -o $@

## Static PDF of the example (included in svg-animate.pdf via \includegraphics) ────────

svg-animate-example.pdf: svg-animate-example.tex svg-animate.sty
	xelatex $<

# ==========

svg-animate-test.dvi: svg-animate-test.tex svg-animate.sty
	latex $<
	latex $<

svg-animate-test.svg: svg-animate-test.dvi
	dvisvgm --font-format=woff2 --optimize=all --bbox=papersize $< -o $@

## Static PDF of the test (included in svg-animate.pdf via \includegraphics) ────────

svg-animate-test.pdf: svg-animate-test.tex svg-animate.sty
	xelatex $<


# ==========
## Documentation PDF ──────────────────────────────────────────────────────────

svg-animate.pdf: svg-animate.tex svg-animate.sty svg-animate-example.pdf
	xelatex $<
	xelatex $<

## Overfull box report ─────────────────────────────────────────────────────────
## Portable on macOS (BSD) and Linux (GNU) awk, no gawk extensions.

check: svg-animate.log
	@sed -n 's/^Overfull .hbox (\([0-9.]*\)pt too wide.*/\1 &/p' \
	        svg-animate.log | \
	awk -v t=$(CHECK_THRESHOLD) '{ \
	    if ($$1 + 0 >= t) { n++; sub(/^[0-9.]+ /, ""); print } \
	  } \
	  END { if (n) { printf "%d overfull box(es) >= %spt\n", n, t; exit 1 } \
	        else printf "no overfull box >= %spt\n", t }'

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
	rm -f svg-animate-example*.svg svg-animate-example*.pdf svg-animate-test*.svg svg-animate-test*.pdf svg-animate.pdf
	rm -f $(PACKAGE)-*.zip
	rm -rf $(PACKAGE)-*/
