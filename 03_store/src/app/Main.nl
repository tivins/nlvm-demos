namespace app;

use catalog.Product;
use catalog.Catalog;
use warehouse.Stock;
use billing.Invoice;

class Main {
	public static int main(string[] args) {
		auto laptop = new Product("Laptop", 999.99);
		auto mouse = new Product("Mouse", 24.5);

		auto storeCatalog = new Catalog();
		storeCatalog.add(laptop);
		storeCatalog.add(mouse);
		system.Out.print(storeCatalog.summary() + "\n\n");

		auto stock = new Stock(laptop, 12);
		system.Out.print(stock.describe() + "\n\n");

		try {
			new Stock(mouse, -5);
		}
		catch (IllegalArgumentException e) {
			system.Out.print("Rejected stock entry: " + e.message + "\n\n");
		}

		auto invoice = new Invoice();
		invoice.addLine(laptop, 1);
		invoice.addLine(mouse, 3);
		system.Out.print(invoice.summary() + "\n");

		return 0;
	}
}
