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

## Static PDF output

In PDF mode (`xelatex`, `pdflatex`) the package detects the output format and
adapts automatically:

- **No `\noanimate`** — `\reveal` elements are drawn at full opacity
  simultaneously (all steps stacked), which is useful for a quick overview.
- **`\noanimate{content}` present** — `\reveal` elements are suppressed and
  only the `\noanimate` content is drawn, giving a single clean static frame.
- **`\reveal[noanimate]{content}`** — forces this specific element to render
  in PDF even when `\noanimate` is active in the same environment.

`\noanimate` is completely ignored in SVG mode.

## Key interface

| Level | Syntax | Scope |
|---|---|---|
| Global | `\tikzset{/anim/duration=2}` | all diagrams |
| Environment | `\begin{animate}[duration=1, inactive opacity=0]` | this environment |
| Step | `\animstep[duration=0.5]` | following step |
| Element | `\reveal[inactive opacity=0.2]{...}` | this element |
| Static fallback | `\noanimate{...}` | PDF only, SVG ignored |

### `/anim/.cd` keys

| Key | Default | Description |
|---|---|---|
| `duration` | `2` | seconds per step |
| `active opacity` | `1` | opacity when step is active |
| `inactive opacity` | `0` | opacity when step is inactive (`0`=hidden, `>0`=dimmed) |
| `loop` | `true` | `false` = play once and freeze on last frame |
| `noanimate` | — | force this `\reveal` to render in PDF even when `\noanimate` is present |
| `step=<spec>` | — | show element during specific steps (see below) |
| `blink=<seconds>` | — | blink at given period during the active step (see below) |

### One-shot animation with `loop=false`

By default animations loop indefinitely.  Set `loop=false` to play through
all steps once and freeze on the last frame:

```latex
\begin{animate}[duration=1, loop=false]
  \reveal{\node {Step 1};}
  \animstep
  \reveal{\node {Step 2};}
  \animstep
  \reveal{\node {Step 3};}
\end{animate}
```

The global default can be changed with `\tikzset{/anim/loop=false}`.

When the animation ends, the SVG browser reverts each element to its base
opacity (fully visible).  If a `\noanimate` fallback is present it therefore
becomes visible at that point, giving the diagram a natural static resting
state after the animation completes.

### Multi-step visibility with `step=`

By default `\reveal` makes an element visible only during the **current step**.
The `step=` key overrides this: the element becomes visible during every step
in the specification, regardless of where `\reveal` is placed.

```latex
\begin{animate}[inactive opacity=0.08]
  \reveal[step={1,3}]{\node[red]  at (4,1) {visible in steps 1 and 3};}
  \reveal[step=2-4]{  \node[blue] at (4,0) {visible in steps 2 through 4};}
  \reveal[step={1,3-5}]{\node at (4,-1) {steps 1, 3, 4, 5};}
\end{animate}
```

**Syntax:**

- Single step — `step=2`
- Range — `step=2-5` (steps 2, 3, 4, 5)
- List — `step={1,3}` (braces required when listing multiple values)
- Mix — `step={1,3-5}` (braces required)

Consecutive steps in the specification are automatically merged into one
animation window (no redundant keyframe at the shared boundary).

### Blinking elements with `blink=`

The `blink=` key makes an element flash on and off during its active step.
The value is the **full blink period** in seconds: the element is visible for
`period/2` seconds, hidden for `period/2` seconds, and repeats.

```latex
\begin{animate}[duration=2, inactive opacity=0.15]
  \reveal{\node at (0,1) {Step 1 — static};}
  \animstep
  \reveal[blink=0.4]{\node[fill=yellow] at (0,0) {Step 2 — blinks};}
  \animstep
  \reveal{\node at (0,-1) {Step 3 — static};}
\end{animate}
```

If the step duration is not an exact multiple of `period/2`, the last
partial half-period is shown up to the step boundary.

`blink=` and `step=` are mutually exclusive; when both are given, `blink=`
takes priority.

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
