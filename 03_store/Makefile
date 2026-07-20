
.phony: clean

all: build run

build:
	nlc src/ -o output.nlp

run:
	nlvm output.nlp

clean:
	rm -f output.nlp
