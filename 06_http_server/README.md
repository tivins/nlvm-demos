# HTTP server (multi-threaded)

A static file server that serves `index.html`, `style.css` and `script.js`
to a browser, using **one OS thread per connection** so requests are
actually handled in parallel instead of being queued behind one another.

- `src/httpserver/Server.nl` — `Server` holds the web root, a request
  counter and a connection counter, both protected by a
  `system.thread.Mutex` since the same `Server` instance is shared across
  every worker thread (heap objects, including the object a closure
  captures, are shared across threads — see
  [vm.md § Threading model](https://github.com/tivins/nlvm-specs/blob/main/docs/vm.md#threading-model)).
  `handle()` reads the request line off a `system.net.TcpStream`, routes it
  against a small whitelist (`resolveFile()` — only `/`, `/index.html`,
  `/style.css` and `/script.js` ever reach the filesystem, so a
  client-supplied path can never escape `public/`), and writes back a
  minimal HTTP/1.1 response built by `sendResponse()`. Two extra JSON
  routes, `/api/stats` and `/api/work`, exist purely to make the
  parallelism visible from the browser (see below).
- `src/httpserver/Main.nl` — `Main.main()` binds a `system.net.TcpListener`
  on `127.0.0.1:8090`, then loops on `accept()`; each accepted
  `TcpStream` is handed to a fresh `system.thread.Thread` that calls
  `server.handle(stream, connId)` and is started immediately, so the main
  thread is back at `accept()` while previous connections are still being
  served.
- `public/index.html` / `public/style.css` / `public/script.js` — the page
  served to the browser. It polls `/api/stats` every second to show a live
  request count, and has a "Fire 5 parallel requests" button that hits the
  deliberately slow `/api/work` endpoint (which sleeps 600 ms per request)
  five times concurrently via `Promise.all`. On a single-threaded server
  that would take ~3 s; here it finishes in ~600 ms, because five threads
  are sleeping at the same time instead of one thread sleeping five times.

```shell
make build   # nlc src/httpserver/ -o output.nlp
make run     # nlvm output.nlp  — blocks; open http://127.0.0.1:8090, Ctrl+C to stop
```

> Note: unlike the other demos, `make` (`all`) only **builds** here — it
> does not chain into `run`, because the server loops forever accepting
> connections and would hang a non-interactive `make all`. Run `make run`
> explicitly, in its own terminal, to actually start it.

> Note: only `GET` is implemented (other methods get `405`), there is no
> keep-alive (every response sends `Connection: close` and the socket is
> closed right after), and request parsing assumes the full request line
> arrives in a single `read()` — all reasonable simplifications for a demo
> server, not something to copy for production use.

Expected behavior (no fixed "expected output" here, since it's a
long-running server):

```
$ make run
NL multi-thread HTTP server listening on http://127.0.0.1:8090
Open it in a browser, or try: curl http://127.0.0.1:8090/api/stats
Press Ctrl+C to stop.
[worker 1] GET / (request #1)
[worker 2] GET /style.css (request #2)
[worker 3] GET /script.js (request #3)
[worker 4] GET /api/stats (request #4)
...
```

Firing 5 parallel requests at `/api/work` (either via the page's button or
`for i in 1 2 3 4 5; do curl -s http://127.0.0.1:8090/api/work & done; wait`)
completes in ~600 ms total, each with a distinct `worker` id in the JSON
response — direct evidence that the five connections ran on five different
threads at the same time.
