# svg-animate

A LaTeX package for producing **animated SVG diagrams** with TikZ.

The animation model is simple: content is divided into discrete *steps*, and
only one step is fully visible at a time — like frames in a film.  Opacity
transitions are instantaneous (no cross-fades), implemented as SMIL keyframes
in the SVG output.

## Quick start

```latex
\documentclass{standalone}
\usepackage{svg-animate}

\begin{document}
\begin{tikzpicture}
  \begin{animate}[duration=1]
    \reveal{\node at (0,0) {Step 1};}
    \animstep
    \reveal{\node at (0,0) {Step 2};}
    \animstep
    \reveal{\node at (0,0) {Step 3};}
  \end{animate}
\end{tikzpicture}
\end{document}
```

## Compilation

```bash
# Animated SVG
latex diagram.tex && latex diagram.tex
dvisvgm --font-format=woff2 --optimize=all --bbox=min diagram.dvi -o diagram.svg

# Static PDF (animations ignored)
xelatex diagram.tex
```

Or simply run `make` inside the package directory to build `example.svg` and
`doc.pdf`.

## Example — traffic light

The included `example.tex` animates a traffic light.  Each coloured circle is
its own step; the amber light uses a shorter `duration`.

![Traffic light animation](example.svg)

> Open `example.svg` directly in a browser to see the animation.
> GitHub's Markdown renderer may display it as a static image.

## Key interface

| Level | Syntax | Scope |
|---|---|---|
| Global | `\tikzset{/anim/duration=2}` | all diagrams |
| Environment | `\begin{animate}[duration=1, inactive opacity=0]` | this environment |
| Step | `\animstep[duration=0.5]` | following step |
| Element | `\reveal[inactive opacity=0.2]{...}` | this element |

### `/anim/.cd` keys

| Key | Default | Description |
|---|---|---|
| `duration` | `2` | seconds per step |
| `active opacity` | `1` | opacity when step is active |
| `inactive opacity` | `0` | opacity when step is inactive (`0`=hidden, `>0`=dimmed) |

## Debugging

`\grid` draws a labelled coordinate grid over the current bounding box.  Call
it last in the `tikzpicture`.  `\pointmark{(coord)}` marks a specific point
with a small cross.

## Requirements

- PGF/TikZ ≥ 3.1.9 (for `\usetikzlibrary{animations}`)
- `dvisvgm` ≥ 2.9 for SVG output
- Any modern LaTeX distribution (TeX Live 2022+, MiKTeX 22+)

## Documentation

```bash
make doc.pdf
```

Full documentation with key reference and examples: `svg-animate.pdf`.

## Copyright

`svg-animate` is copyright 2026 Sébastien Gross and distributed under
the terms of the GNU Affero General Public License v3.0 or later.
