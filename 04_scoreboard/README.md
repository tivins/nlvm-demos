# Scoreboard (closures, functional arrays, match)

A single-file program that processes a list of exam scores using NL's
functional features: anonymous functions (closures), the built-in array
methods `filter`/`sort`/`forEach`/`map`/`find`, an exhaustive `match`
expression, and the `??` nullish-coalescing operator — none of which are
used by the earlier demos.

- `src/Main.nl` — declares a closure `isPassing` (an anonymous function bound
  with `auto`) and reuses it both as a predicate for `int[].filter()` and as
  a plain function call; sorts and prints the passing scores with `sort()`
  and `forEach()`; uses `find()` (which returns `int|null`) together with
  `??` to fall back to `-1` when nothing matches; curves every score with
  `map()`; then converts each curved score to a letter grade with a
  `match(int)` expression (which requires a `default` arm, since `int`'s
  value domain is unbounded).

```shell
nlc src/ -o output.nlp
nlvm output.nlp
```

> Note: per [specs.md § Anonymous Functions](https://github.com/tivins/nlvm-specs/blob/main/docs/specs.md#anonymous-functions),
> captured variables are documented as captured *by reference* and mutable
> (`counter++` inside a closure). The current `nlc`/`nlvm` implementation
> instead captures **by value** — a snapshot taken when the closure is
> created (confirmed by the compiler's own test suite) — and rejects
> `++`/`--` on a captured variable at codegen. This demo only reads
> captured/outer state, which works reliably. Also, calling a closure stored
> in an `auto` variable *inline* inside another expression (e.g.
> `scores.find((int s) => !isPassing(s))`) can trip up type inference
> (`Operator '!' is not defined for type 'void'`); binding the call result to
> a local variable first, or writing the predicate directly, works reliably
> — see `isPassing`/`firstFailing` above. Explicit function-type variable
> declarations (`(int) => bool x = ...;`) are still rejected by the parser
> as of this writing, so this demo only uses `auto` for closures.

Expected output:

```
Passing scores (highest first):
  95
  88
  77
  60

First failing score: 42

Report card:
  Alice: 100 (A, pass)
  Bob: 47 (F, fail)
  Chloe: 82 (B, pass)
  Dan: 93 (A, pass)
  Elena: 65 (D, pass)

4 / 5 passed (pre-curve).
```
