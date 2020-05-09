VERSION=$(shell git rev-parse --short HEAD)

all: build run

build:
	docker build -t pimba/librespot:$(VERSION) .

run:
	docker run -ti --rm \
	  --device /dev/snd \
	  -v /etc/asound.conf:/etc/asound.conf:ro \
	  -v /etc/avahi/services:/etc/avahi/services \
	  -p 4070:4070 \
	  pimba/librespot:$(VERSION) -n pi --zeroconf-port 4070

push:
	docker push docker.io/pimba/librespot:$(VERSION)
