
.phony: clean

all: build run

build:
	nlc src/*.nl -o nl_modules

run:
	nlvm nl_modules/*.nlm

clean:
	rm -rf nl_modules/
