namespace liskov;

// Checked exception (extends Exception, not RuntimeException): callers must
// catch it or declare it, and — the point of this demo — overriding methods
// are restricted in how they may change their `throws` clause relative to it.
class readonly ImportException extends Exception {
	public construct(string message) {
		super(message);
	}
}
