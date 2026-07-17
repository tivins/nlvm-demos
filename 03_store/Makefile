
.phony: clean

all: build run

build:
	nlc src/ -o nl_modules

run:
	nlvm nl_modules/

clean:
	rm -rf nl_modules/
