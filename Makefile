D:=docker
.PHONY:= all build-rpi test-rpi: clean

all: test-rpi

build-rpi:
	${D} run --rm --privileged -v /dev:/dev -v ${PWD}:/build -v ${HOME}/.ssh/id_personal.pub:/root/.ssh/id_personal.pub:ro mkaczanowski/packer-builder-arm build -var-file=secrets.json raspios/raspios-armhf.json

test-rpi: build-rpi
	${D} run -it -v ${PWD}/raspios-armhf.img:/sdcard/filesystem.img lukechilds/dockerpi:vm

write-rpi:
	sudo dd bs=4m if=raspios-armhf.img of=${DISK}

clean: 
	${RM} -rf *.img packer-cache

