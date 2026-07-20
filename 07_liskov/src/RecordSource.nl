namespace liskov;

// The contract every record source must honor: read records one at a time,
// failing with (a subtype of) ImportException when a record can't be
// produced. Any code written against RecordSource — see Main.nl — can
// `catch (ImportException e)` and trust that it has handled every failure
// mode any current or future subclass can raise.
abstract class RecordSource {
	public abstract bool hasNext() const;
	public abstract string next() throws ImportException;
}
