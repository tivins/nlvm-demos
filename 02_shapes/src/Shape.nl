namespace shapes;

abstract class Shape implements Stringable {
	public abstract float area() const;
	public abstract float perimeter() const;
	public abstract string name() const;

	public string toString() const {
		return this.name() + " (area=" + this.area() + ", perimeter=" + this.perimeter() + ")";
	}
}
