namespace liskov;

// Reads "field,field,field" lines. Its `next()` narrows the parent's
// `throws ImportException` down to `throws InvalidRecordException` — legal
// because InvalidRecordException extends ImportException, so it still
// covers everything the parent's contract promised (compiler.md's E016/E017
// — see the README for what happens if you widen or swap this instead).
class CsvLineSource extends RecordSource {
	private system.List<string> lines;
	private int cursor;

	public construct(system.List<string> lines) {
		this.lines = lines;
		this.cursor = 0;
	}

	public bool hasNext() const {
		return this.cursor < this.lines.size();
	}

	public string next() throws InvalidRecordException {
		string line = this.lines.get(this.cursor);
		this.cursor = this.cursor + 1;

		string[] fields = line.split(",");
		if (fields.length() != 3) {
			throw new InvalidRecordException(
				"expected 3 comma-separated fields, got " + fields.length(),
				line
			);
		}
		return line;
	}
}
