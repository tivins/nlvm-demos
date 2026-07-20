# Liskov (checked-exception covariance)

A small program built to show that NL doesn't just *allow* SOLID-style
design — it has a compiler rule that actively enforces the Liskov
Substitution Principle for one specific, easy-to-get-wrong case: what an
overriding method is allowed to change in its `throws` clause.

The idea: `RecordSource` is an abstract contract for "give me the next
record, or fail with `ImportException`." Two unrelated implementations
satisfy it. Client code (`Main.nl`) only ever programs against
`RecordSource`/`ImportException` and never needs to know, or care, which
concrete subclass it's holding — that's substitutability.

- `src/ImportException.nl` — a **checked** exception (`extends Exception`,
  not `RuntimeException`), the base failure type of the whole contract.
- `src/InvalidRecordException.nl` — `extends ImportException`: a strictly
  more specific checked exception.
- `src/RecordSource.nl` — abstract class declaring
  `public abstract string next() throws ImportException;`.
- `src/MemorySource.nl` — overrides `next()` with the exact same
  `throws ImportException`. The plain, unremarkable case.
- `src/CsvLineSource.nl` — overrides `next()` with a **narrower**
  `throws InvalidRecordException`. Legal, because
  `InvalidRecordException` is a subtype of `ImportException`, so it still
  covers everything the parent's contract promised.
- `src/Main.nl` — builds a `system.List<RecordSource>` holding one of each,
  and reads every source through the exact same
  `catch (ImportException e)` block. It compiles and catches everything
  regardless of which concrete `next()` — the wide one or the narrow one —
  actually ran.

## Why this is Liskov, concretely

Per [compiler.md § Exception inheritance rules](https://github.com/nlvm-lang/nlvm-specs/blob/main/docs/compiler.md#exception-inheritance-rules),
an overriding method's `throws` clause must, for every *checked* exception
`E` declared by the parent, declare `E` or a subclass of `E` — and may not
declare any checked exception outside that. In other words: a subclass is
free to make the contract more specific, but never free to make it wider,
so any code written against the parent stays correct no matter which
subclass it actually gets — the textbook definition of LSP, machine-checked
at compile time instead of left to code review.

Two ways to break it, both rejected by `nlc` (not part of the buildable
demo — these are shown here as illustrations, matching
[specs.md § Exception inheritance rules](https://github.com/nlvm-lang/nlvm-specs/blob/main/docs/specs.md#exception-inheritance-rules)):

```nl
// E016 — widening: dropping ImportException from the throws clause (Exception
// is a supertype, not a subtype, of ImportException) breaks every caller that
// only knows how to catch ImportException.
class BrokenWiden extends RecordSource {
    public bool hasNext() const { return false; }
    public string next() throws Exception {
        throw new Exception("boom");
    }
}
// Error: E016 — Overriding method 'next' does not declare exception
// 'liskov.ImportException' from parent method

// E017 — adding an unrelated checked exception the parent never promised.
class BrokenExtra extends RecordSource {
    public bool hasNext() const { return false; }
    public string next() throws ImportException, UnrelatedException {
        throw new ImportException("boom");
    }
}
// Error: E017 — Overriding method 'next' declares exception
// 'liskov.UnrelatedException' not thrown by parent method
```

Runtime exceptions (subclasses of `RuntimeException`) are exempt from both
rules — only the *checked* part of a `throws` clause is covariant-checked,
matching the leniency `stdlib`/other demos already rely on for things like
`IndexOutOfBoundsException`.

```shell
nlc src/ -o output.nlp
nlvm output.nlp
```

Expected output:

```
-- reading source --
  ok: mem-1
  ok: mem-2
-- reading source --
  ok: 42,widget,3
  ok: 43,gadget,7
  rejected: expected 3 comma-separated fields, got 2
  ok: 44,gizmo,1
```
