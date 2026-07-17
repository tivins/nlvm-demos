namespace catalog;

class Catalog {
	private system.List<Product> products;

	public construct() {
		this.products = new system.List<Product>();
	}

	public void add(Product product) {
		this.products.pushBack(product);
	}

	public system.List<Product> getProducts() const {
		return this.products;
	}

	public string summary() const {
		string out = "Catalog (" + this.products.size() + " products):\n";
		float total = 0.0;
		for (const auto p : this.products) {
			out = out + "  - " + p.toString() + "\n";
			total = total + p.getPrice();
		}
		out = out + "  Total catalog value: $" + total;
		return out;
	}
}
