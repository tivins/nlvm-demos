namespace scoreboard;

class Main {
	public static int main(string[] args) {
		string[] students = new string[]{"Alice", "Bob", "Chloe", "Dan", "Elena"};
		int[] scores = new int[]{95, 42, 77, 88, 60};

		auto isPassing = (int score) => score >= 60;

		int[] passingScores = scores.filter(isPassing);
		passingScores.sort((int a, int b) => b <=> a);

		system.Out.println("Passing scores (highest first):");
		passingScores.forEach((int s) => { system.Out.println("  " + s); });

		int[] curved = scores.map((int s) => s + 5);

		system.Out.println("");
		system.Out.println("Report card:");
		int i = 0;
		while (i < students.length()) {
			int score = curved[i];
			string grade = match(score / 10) {
				10: "A", 9: "A", 8: "B", 7: "C", 6: "D", default: "F",
			};
			bool passed = isPassing(score);
			system.Out.println("  " + students[i] + ": " + score + " (" + grade + ", " + (passed ? "pass" : "fail") + ")");
			i++;
		}

		int passCount = passingScores.length();
		system.Out.println("");
		system.Out.println(passCount + " / " + students.length() + " passed (pre-curve).");

		return 0;
	}
}
