const requestCountEl = document.getElementById("requestCount");
const runWorkBtn = document.getElementById("runWork");
const workElapsedEl = document.getElementById("workElapsed");
const workerListEl = document.getElementById("workerList");

async function pollStats() {
	try {
		const res = await fetch("/api/stats", { cache: "no-store" });
		const data = await res.json();
		requestCountEl.textContent = data.requests;
	} catch (err) {
		requestCountEl.textContent = "offline";
	}
}

async function runParallelDemo() {
	runWorkBtn.disabled = true;
	workElapsedEl.textContent = "running…";
	workerListEl.innerHTML = "";

	const started = performance.now();
	const requests = Array.from({ length: 5 }, () =>
		fetch("/api/work", { cache: "no-store" }).then((r) => r.json())
	);
	const results = await Promise.all(requests);
	const elapsed = Math.round(performance.now() - started);

	workElapsedEl.textContent = `${elapsed} ms for 5 requests`;
	for (const result of results) {
		const li = document.createElement("li");
		li.innerHTML = `<span>worker #${result.worker}</span><span>request #${result.requests}</span>`;
		workerListEl.appendChild(li);
	}

	runWorkBtn.disabled = false;
	pollStats();
}

runWorkBtn.addEventListener("click", runParallelDemo);

pollStats();
setInterval(pollStats, 1000);
