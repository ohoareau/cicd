all: install

install:
	@true

build:
	@docker build -t ohoareau/cicd .

start:
	@docker run -it --rm ohoareau/cicd || true