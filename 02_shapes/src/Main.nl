namespace shapes;

class Main {
	public static int main(string[] args) {
		auto shapeList = new system.List<Shape>();
		shapeList.pushBack(new Circle(3.0));
		shapeList.pushBack(new Rectangle(3.0, 4.0));
		shapeList.pushBack(new Square(5.0));

		try {
			shapeList.pushBack(new Circle(-1.0));
		}
		catch (IllegalArgumentException e) {
			system.Out.print("Rejected invalid shape: " + e.message + "\n");
			for (const auto frame : e.stackTrace) {
				system.Out.print("  at " + frame.file + ":" + frame.line + "\n");
			}
		}

		float totalArea = 0.0;
		for (const auto s : shapeList) {
			system.Out.print(s.toString() + "\n");
			totalArea = totalArea + s.area();
		}

		system.Out.print("\n");
		system.Out.print("Shapes: " + shapeList.size() + "\n");
		system.Out.print("Total area: " + totalArea + "\n");

		return 0;
	}
}
