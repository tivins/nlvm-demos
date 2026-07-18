//------------------------------------------------
// NLVM Demo
// Specs: https://github.com/tivins/nlvm-specs
// Implementation: https://github.com/tivins/nlvm
//------------------------------------------------
// Demo 05: Priority
//------------------------------------------------

namespace priority;

class Main {
	public static int main(string[] args) {
		Priority p = Priority.High;
		system.Out.println(p.label() + " (" + p.value + "): " + (p.isUrgent() ? "urgent" : "normal"));

		Priority fromName = Priority.from("Medium");
		system.Out.println("Parsed: " + fromName.label());

		try {
			Priority.from("Critical");
		}
		catch (IllegalArgumentException e) {
			system.Out.println("Rejected: " + e.message);
		}

		Priority safe = Priority.tryFrom("Critical") ?? Priority.Low;
		system.Out.println("Fallback: " + safe.label());

		string[] inbox = new string[]{"Low", "High", "Nope", "Medium"};
		int i = 0;
		while (i < inbox.length()) {
			Priority parsed = Priority.tryFrom(inbox[i]) ?? Priority.Low;
			string flag = parsed.isUrgent() ? " [!]" : "";
			system.Out.println("  " + inbox[i] + " -> " + parsed.label() + flag);
			i++;
		}

		return 0;
	}
}
