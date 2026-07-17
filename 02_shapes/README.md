# Shapes (multi-file program)

A small program spread across several `.nl` files to show how classes in the
same namespace reference each other: an abstract base class, three concrete
subclasses (one of them extending another), a generic `system.List<Shape>`,
`Stringable`, and exception handling.

- `src/Shape.nl` — abstract class `Shape implements Stringable`, declares the
  abstract `area()`/`perimeter()`/`name()` and a shared `toString()`.
- `src/Circle.nl`, `src/Rectangle.nl` — concrete shapes extending `Shape`.
- `src/Square.nl` — extends `Rectangle` and delegates to it via `super(side, side)`.
- `src/Main.nl` — builds a `system.List<Shape>`, catches an
  `IllegalArgumentException` thrown by an invalid constructor, then iterates
  the list with a `for (const auto s : list)` loop.

Compile (all sources are compiled together as one program; `nlc` emits one
`.nlm` per class, including the prelude exception hierarchy, into `nl_modules`):

```shell
/data/projects/nlvm/target/release/nlc src/Shape.nl src/Circle.nl src/Rectangle.nl src/Square.nl src/Main.nl -o nl_modules
```

Execute (`nlvm` needs every `.nlm` the program can reach at runtime, not just
the entry point — pass the whole directory):

```shell
/data/projects/nlvm/target/release/nlvm nl_modules/*.nlm
```

Expected output:

```
Rejected invalid shape: radius must be positive
Circle (area=28.274309999999996, perimeter=18.849539999999998)
Rectangle (area=12, perimeter=14)
Square (area=25, perimeter=20)

Shapes: 3
Total area: 65.27431
```
