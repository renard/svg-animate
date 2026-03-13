.PHONY: all clean

all: example.svg svg-animate.pdf

## Animated SVG ────────────────────────────────────────────────────────────────

example.dvi: example.tex svg-animate.sty
	latex $<
	latex $<

example.svg: example.dvi
	dvisvgm --font-format=woff2 --optimize=all --bbox=min $< -o $@

## Static PDF of the example (included in svg-animate.pdf via \includegraphics) ────────

example.pdf: example.tex svg-animate.sty
	xelatex $<

## Documentation PDF ──────────────────────────────────────────────────────────

svg-animate.pdf: svg-animate.tex svg-animate.sty example.pdf
	xelatex $<
	xelatex $<

## Cleanup ────────────────────────────────────────────────────────────────────

clean:
	rm -f *.aux *.log *.dvi *.toc *.out *.tcbtemp

clean-all: clean
	rm -f example.svg example.pdf svg-animate.pdf
