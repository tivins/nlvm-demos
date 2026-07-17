namespace shapes;

class Square extends Rectangle {
	public construct(float side) {
		super(side, side);
	}

	public string name() const {
		return "Square";
	}
}
