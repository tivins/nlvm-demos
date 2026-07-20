.phony: clean run

# The server runs until interrupted (Ctrl+C), so "all" only builds — it
# does not chain into "run" like the other demos, to avoid hanging
# non-interactive builds (e.g. the top-level `make`).
all: build

build:
	nlc src/httpserver/ -o output.nlp

run:
	nlvm output.nlp

clean:
	rm -f output.nlp
