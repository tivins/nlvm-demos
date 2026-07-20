# Shapes (multi-file program)

A small program spread across several `.nl` files to show how classes in the
same namespace reference each other: an abstract base class, three concrete
subclasses (one of them extending another), a generic `system.List<Shape>`,
`Stringable`, and exception handling with stack traces.

- `src/Shape.nl` — abstract class `Shape implements Stringable`, declares the
  abstract `area()`/`perimeter()`/`name()` and a shared `toString()`.
- `src/Circle.nl`, `src/Rectangle.nl` — concrete shapes extending `Shape`.
- `src/Square.nl` — extends `Rectangle` and delegates to it via `super(side, side)`.
- `src/Main.nl` — builds a `system.List<Shape>`, catches an
  `IllegalArgumentException` thrown by an invalid constructor, and prints
  its `e.stackTrace` (an `ExecutionPoint[]` with `file`/`line` per frame,
  captured by the VM when the exception's `construct` runs — see
  [specs.md § Exceptions](https://github.com/nlvm-lang/nlvm-specs/blob/main/docs/specs.md#exceptions))
  before iterating the list with a `for (const auto s : list)` loop.

All sources are compiled together as one program; `nlc` bundles every
class, including the prelude exception hierarchy, into a single
`output.nlp`:

```shell
nlc src/ -o output.nlp
```

`nlvm` runs the bundle directly:

```shell
nlvm output.nlp
```

Expected output:

```
Rejected invalid shape: radius must be positive
  at shapes/Circle.nl:8
  at shapes/Main.nl:11
Circle (area=28.274309999999996, perimeter=18.849539999999998)
Rectangle (area=12, perimeter=14)
Square (area=25, perimeter=20)

Shapes: 3
Total area: 65.27431
```
