//------------------------------------------------
// NLVM Demo
// Specs: https://specs.nlvm.dev
// Implementation: https://github.com/nlvm-lang/nlvm
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
