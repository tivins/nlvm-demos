namespace billing;

use catalog.Product;

class LineItem implements Stringable {
	private Product product;
	private int quantity;

	public construct(Product product, int quantity) {
		if (quantity <= 0) {
			throw new IllegalArgumentException("quantity must be positive");
		}
		this.product = product;
		this.quantity = quantity;
	}

	public float subtotal() const {
		return this.product.getPrice() * this.quantity;
	}

	public string toString() const {
		return this.product.getName() + " x" + this.quantity + " = $" + this.subtotal();
	}
}
