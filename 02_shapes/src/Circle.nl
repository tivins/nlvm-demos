namespace shapes;

class Circle extends Shape {
	private float radius;

	public construct(float radius) {
		if (radius <= 0) {
			throw new IllegalArgumentException("radius must be positive");
		}
		this.radius = radius;
	}

	public float area() const {
		return 3.14159 * this.radius * this.radius;
	}

	public float perimeter() const {
		return 2 * 3.14159 * this.radius;
	}

	public string name() const {
		return "Circle";
	}
}
