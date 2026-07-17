namespace warehouse;

use catalog.Product;

class Stock {
	private Product product;
	private int quantity;

	public construct(Product product, int quantity) {
		if (quantity < 0) {
			throw new IllegalArgumentException("quantity must not be negative");
		}
		this.product = product;
		this.quantity = quantity;
	}

	public float totalValue() const {
		return this.product.getPrice() * this.quantity;
	}

	public string describe() const {
		return this.quantity + "x " + this.product.getName() + " (stock value: $" + this.totalValue() + ")";
	}
}
