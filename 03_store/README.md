# Store (multiple namespaces)

A small program spread across **four separate namespaces**, each living in
its own folder ("workspace"), to show how NL classes reference each other
across namespace boundaries via `use` imports.

- `src/catalog/` (namespace `catalog`) — `Product` (implements `Stringable`)
  and `Catalog`, a `system.List<Product>` wrapper with a `summary()` report.
- `src/warehouse/` (namespace `warehouse`) — `Stock`, which imports
  `catalog.Product` with `use catalog.Product;` and rejects a negative
  quantity by throwing `IllegalArgumentException`.
- `src/billing/` (namespace `billing`) — `LineItem` and `Invoice`, both
  importing `catalog.Product`; `LineItem` also implements `Stringable`.
- `src/app/` (namespace `app`) — `Main`, which imports classes from all
  three other namespaces and wires them together.

Per [specs.md § Source code files](https://github.com/tivins/nlvm-specs/blob/main/docs/specs.md#source-code-files),
the namespace declared in each file must match its folder path — that's
what makes each folder a distinct "workspace" here, even though `nlc`
compiles everything into one program in a single invocation:

```shell
nlc src/catalog/*.nl src/warehouse/*.nl src/billing/*.nl src/app/*.nl -o output.nlp
nlvm output.nlp
```

> Note: NL's `use` syntax supports an `as` alias for resolving name
> conflicts between namespaces (see specs.md § Imports), but this isn't
> wired up in `nlc` yet, and cross-class **static** method calls
> (`SomeClass.staticMethod()`) currently fail at codegen (`unsupported
> construct: undefined variable`) even within a single namespace — this
> demo sticks to constructors and instance methods, which work reliably
> across namespaces.

Expected output:

```
Catalog (2 products):
  - Laptop ($999.99)
  - Mouse ($24.5)
  Total catalog value: $1024.49

12x Laptop (stock value: $11999.880000000001)

Rejected stock entry: quantity must not be negative

Invoice (2 lines):
  - Laptop x1 = $999.99
  - Mouse x3 = $73.5
  Total: $1073.49
```
