namespace catalog;

class Product implements Stringable {
	private string name;
	private float price;

	public construct(string name, float price) {
		if (price < 0) {
			throw new IllegalArgumentException("price must not be negative");
		}
		this.name = name;
		this.price = price;
	}

	public string getName() const {
		return this.name;
	}

	public float getPrice() const {
		return this.price;
	}

	public string toString() const {
		return this.name + " ($" + this.price + ")";
	}
}
