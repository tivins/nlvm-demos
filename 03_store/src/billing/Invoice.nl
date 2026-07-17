namespace billing;

use catalog.Product;

class Invoice {
	private system.List<LineItem> lines;

	public construct() {
		this.lines = new system.List<LineItem>();
	}

	public void addLine(Product product, int quantity) {
		this.lines.pushBack(new LineItem(product, quantity));
	}

	public float total() const {
		float sum = 0.0;
		for (const auto line : this.lines) {
			sum = sum + line.subtotal();
		}
		return sum;
	}

	public string summary() const {
		string out = "Invoice (" + this.lines.size() + " lines):\n";
		for (const auto line : this.lines) {
			out = out + "  - " + line.toString() + "\n";
		}
		out = out + "  Total: $" + this.total();
		return out;
	}
}
