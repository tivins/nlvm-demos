# Priority (typed enums)

A small program showing NL's typed `enum`: an `int`-backed `Priority` enum
with custom instance methods, the built-in `from()`/`tryFrom()` string
converters, and the `??` nullish-coalescing operator used to fall back to a
default case.

- `src/Priority.nl` — `enum Priority: int { Low = 1, Medium = 2, High = 3, ... }`
  with two custom instance methods: `label()` (an exhaustive `match(this)`
  over every case — enum matches don't need a `default` arm once every case
  is covered) and `isUrgent()` (compares `this.value` against
  `Priority.High.value`).

  > Note: as of this compiler version, an `enum` and a `class` cannot live
  > in the same `.nl` file — the class silently fails to compile (no
  > `Main.nlm` is emitted, with no error). Keeping the enum in its own file,
  > like the classes in [02_shapes](../02_shapes/), works reliably.

- `src/Main.nl` — reads `Priority.High.value`, parses a valid case with
  `Priority.from("Medium")`, catches the `IllegalArgumentException` thrown
  by `Priority.from("Critical")` (not a known case), then uses
  `Priority.tryFrom(...) ?? Priority.Low` to parse a small inbox of
  raw strings — some valid, one not — falling back to `Priority.Low`
  instead of throwing.

```shell
nlc src/ -o nl_modules
nlvm nl_modules/
```

Expected output:

```
High (3): urgent
Parsed: Medium
Rejected: unknown case for enum Priority
Fallback: Low
  Low -> Low
  High -> High [!]
  Nope -> Low
  Medium -> Medium
```
