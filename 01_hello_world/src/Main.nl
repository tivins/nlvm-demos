//------------------------------------------------
// NLVM Demo
// Specs: https://github.com/tivins/nlvm-specs
// Implementation: https://github.com/tivins/nlvm
//------------------------------------------------
// Demo 01: Hello World
//------------------------------------------------

namespace main;

class Main 
{
	public static int main(string[] args) 
	{
		auto message = "Hello world";
		system.Out.print(message + 	"\n");
		return 0;
	}
}
