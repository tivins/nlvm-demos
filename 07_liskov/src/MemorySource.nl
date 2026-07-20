namespace liskov;

// Reads from an in-memory queue. Its `next()` declares the exact same
// `throws ImportException` as the parent — the simplest legal override.
class MemorySource extends RecordSource {
	private system.List<string> records;
	private int cursor;

	public construct(system.List<string> records) {
		this.records = records;
		this.cursor = 0;
	}

	public bool hasNext() const {
		return this.cursor < this.records.size();
	}

	public string next() throws ImportException {
		if (!this.hasNext()) {
			throw new ImportException("MemorySource: no more records");
		}
		string value = this.records.get(this.cursor);
		this.cursor = this.cursor + 1;
		return value;
	}
}
