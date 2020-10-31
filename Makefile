D:=docker
.PHONY:= all build-rpi test-rpi: clean

all: test-rpi

build-rpi:
	${D} run --rm --privileged -v /dev:/dev -v ${PWD}:/build mkaczanowski/packer-builder-arm build -var-file=secrets.json raspios/raspios-armhf.json

test-rpi: build-rpi
	${D} run -it -v ${PWD}/raspios-armhf.img:/sdcard/filesystem.img lukechilds/dockerpi:vm

write-rpi:
	diskutil unmountDisk ${DISK}
	sudo gdd bs=32M if=raspios-armhf.img of=${DISK} status=progress

clean: 
	${RM} -rf *.img packer-cache

