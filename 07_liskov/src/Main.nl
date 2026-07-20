namespace liskov;

class Main {
	public static int main(string[] args) {
		auto memoryRecords = new system.List<string>();
		memoryRecords.pushBack("mem-1");
		memoryRecords.pushBack("mem-2");

		auto csvLines = new system.List<string>();
		csvLines.pushBack("42,widget,3");
		csvLines.pushBack("43,gadget,7");
		csvLines.pushBack("bad,row"); // only 2 fields -> InvalidRecordException
		csvLines.pushBack("44,gizmo,1");

		auto sources = new system.List<RecordSource>();
		sources.pushBack(new MemorySource(memoryRecords));
		sources.pushBack(new CsvLineSource(csvLines));

		// Neither loop iteration nor this catch clause knows or cares which
		// concrete RecordSource it's holding. MemorySource never throws
		// anything narrower than ImportException; CsvLineSource always
		// throws the narrower InvalidRecordException. Both are caught here
		// by the exact same `catch (ImportException e)` — that's Liskov
		// substitution, guaranteed by the compiler rather than by convention.
		for (auto source : sources) {
			system.Out.print("-- reading source --\n");
			while (source.hasNext()) {
				try {
					string record = source.next();
					system.Out.print("  ok: " + record + "\n");
				}
				catch (ImportException e) {
					system.Out.print("  rejected: " + e.message + "\n");
				}
			}
		}

		return 0;
	}
}
