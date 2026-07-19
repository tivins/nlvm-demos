.phony: clean run

# The server runs until interrupted (Ctrl+C), so "all" only builds — it
# does not chain into "run" like the other demos, to avoid hanging
# non-interactive builds (e.g. the top-level `make`).
all: build

build:
	nlc src/httpserver/ -o nl_modules

run:
	nlvm nl_modules/

clean:
	rm -rf nl_modules/
