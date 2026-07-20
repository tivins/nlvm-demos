namespace liskov;

// A subclass of ImportException: strictly more specific, so it "covers"
// ImportException wherever the parent contract is expected.
class readonly InvalidRecordException extends ImportException {
	public string rawLine;

	public construct(string message, string rawLine) {
		super(message);
		this.rawLine = rawLine;
	}
}
