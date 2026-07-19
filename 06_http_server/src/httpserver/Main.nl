namespace httpserver;

class Main {
	public static int main(string[] args) {
		int port = 8090;
		auto server = new Server("public");

		try {
			auto listener = new system.net.TcpListener("127.0.0.1", port);

			system.Out.println("NL multi-thread HTTP server listening on http://127.0.0.1:" + port);
			system.Out.println("Open it in a browser, or try: curl http://127.0.0.1:" + port + "/api/stats");
			system.Out.println("Press Ctrl+C to stop.");

			while (true) {
				auto stream = listener.accept();
				int connId = server.nextConnectionId();
				auto worker = new system.thread.Thread(() => {
					server.handle(stream, connId);
				});
				worker.start();
			}
			listener.close();
		}
		catch (Exception ex) {
			system.Err.println("Fatal server error: " + ex.message);
			return 1;
		}

		return 0;
	}
}
