//------------------------------------------------
// NLVM Demo
// Specs: https://github.com/tivins/nlvm-specs
// Implementation: https://github.com/tivins/nlvm
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
