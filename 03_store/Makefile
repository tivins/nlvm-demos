
.phony: clean

all: build run

build:
	nlc src/catalog/*.nl src/warehouse/*.nl src/billing/*.nl src/app/*.nl -o nl_modules

run:
	nlvm nl_modules/*.nlm

clean:
	rm -rf nl_modules/
