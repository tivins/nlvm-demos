namespace httpserver;

class Server {
	private string webRoot;
	private int requestCount;
	private int nextConnId;
	private system.thread.Mutex countMutex;

	public construct(string webRoot) {
		this.webRoot = webRoot;
		this.requestCount = 0;
		this.nextConnId = 0;
		this.countMutex = new system.thread.Mutex();
	}

	public int nextConnectionId() {
		this.countMutex.lock();
		this.nextConnId = this.nextConnId + 1;
		int id = this.nextConnId;
		this.countMutex.unlock();
		return id;
	}

	public int recordRequest() {
		this.countMutex.lock();
		this.requestCount = this.requestCount + 1;
		int count = this.requestCount;
		this.countMutex.unlock();
		return count;
	}

	public string contentTypeFor(const string file) const {
		return match(file) {
			"index.html": "text/html; charset=utf-8",
			"style.css": "text/css; charset=utf-8",
			"script.js": "text/javascript; charset=utf-8",
			default: "application/octet-stream",
		};
	}

	// Whitelist-based routing: only known static files can ever be opened,
	// so client-supplied paths never reach the filesystem directly (no path traversal).
	public string resolveFile(const string path) const {
		return match(path) {
			"/": "index.html",
			"/index.html": "index.html",
			"/style.css": "style.css",
			"/script.js": "script.js",
			default: "",
		};
	}

	public void sendResponse(system.net.TcpStream stream, int statusCode, const string statusText, const string contentType, const string body) throws IOException {
		byte[] bodyBytes = system.text.Encoding.encodeUtf8(body);
		string header = "HTTP/1.1 " + statusCode + " " + statusText + "\r\n"
			+ "Content-Type: " + contentType + "\r\n"
			+ "Content-Length: " + bodyBytes.length() + "\r\n"
			+ "Connection: close\r\n"
			+ "\r\n";
		byte[] headerBytes = system.text.Encoding.encodeUtf8(header);
		stream.write(headerBytes, 0, headerBytes.length());
		stream.write(bodyBytes, 0, bodyBytes.length());
	}

	public void handle(system.net.TcpStream stream, int connId) {
		try {
			byte[] buf = new byte[8192];
			int n = stream.read(buf, 0, buf.length());
			if (n <= 0) {
				stream.close();
				return;
			}

			string request = system.text.Encoding.decodeUtf8(buf.slice(0, n));
			string[] lines = request.split("\r\n");
			string[] parts = lines[0].split(" ");
			if (parts.length() < 2) {
				this.sendResponse(stream, 400, "Bad Request", "text/plain; charset=utf-8", "Bad request\n");
				stream.close();
				return;
			}

			string method = parts[0];
			string path = parts[1];
			int count = this.recordRequest();

			system.Out.println("[worker " + connId + "] " + method + " " + path + " (request #" + count + ")");

			if (method != "GET") {
				this.sendResponse(stream, 405, "Method Not Allowed", "text/plain; charset=utf-8", "Method not allowed\n");
			} else if (path == "/api/stats") {
				string json = "{\"requests\": " + count + ", \"worker\": " + connId + "}";
				this.sendResponse(stream, 200, "OK", "application/json; charset=utf-8", json);
			} else if (path == "/api/work") {
				// Simulated slow endpoint: proves requests run in parallel across
				// worker threads instead of queuing behind each other.
				system.thread.Thread.sleep(600);
				string json = "{\"worker\": " + connId + ", \"requests\": " + count + "}";
				this.sendResponse(stream, 200, "OK", "application/json; charset=utf-8", json);
			} else {
				string file = this.resolveFile(path);
				if (file == "") {
					this.sendResponse(stream, 404, "Not Found", "text/plain; charset=utf-8", "Not found: " + path + "\n");
				} else {
					string fullPath = this.webRoot + "/" + file;
					if (!system.io.File.exists(fullPath)) {
						this.sendResponse(stream, 404, "Not Found", "text/plain; charset=utf-8", "Missing file: " + file + "\n");
					} else {
						string content = system.io.File.readAllText(fullPath);
						this.sendResponse(stream, 200, "OK", this.contentTypeFor(file), content);
					}
				}
			}

			stream.close();
		}
		catch (Exception ex) {
			system.Err.println("[worker " + connId + "] error: " + ex.message);
			stream.close();
		}
	}
}
