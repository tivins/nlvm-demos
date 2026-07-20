//------------------------------------------------
// NLVM Demo
// Specs: https://specs.nlvm.dev
// Implementation: https://github.com/nlvm-lang/nlvm
//------------------------------------------------
// Demo 05: Priority
//------------------------------------------------

namespace priority;

enum Priority: int
{
	Low = 1,
	Medium = 2,
	High = 3,

	public string label() const {
		return match(this) {
			Priority.Low: "Low",
			Priority.Medium: "Medium",
			Priority.High: "High",
		};
	}

	public bool isUrgent() const {
		return this.value >= Priority.High.value;
	}
}
