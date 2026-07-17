namespace shapes;

class Rectangle extends Shape {
	protected float width;
	protected float height;

	public construct(float width, float height) {
		if (width <= 0 || height <= 0) {
			throw new IllegalArgumentException("width and height must be positive");
		}
		this.width = width;
		this.height = height;
	}

	public float area() const {
		return this.width * this.height;
	}

	public float perimeter() const {
		return 2 * (this.width + this.height);
	}

	public string name() const {
		return "Rectangle";
	}
}
