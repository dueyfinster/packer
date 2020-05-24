D:=docker
.PHONY:= all build-rpi test-rpi: clean

all: test-rpi

build-rpi:
	${D} run --rm --privileged -v ${PWD}:/build:ro -v ${HOME}/.ssh/id_personal.pub:/root/.ssh/id_personal.pub:ro -v ${PWD}/packer_cache:/build/packer_cache -v ${PWD}/output-arm-image:/build/output-arm-image -e PACKER_CACHE_DIR=/build/packer_cache quay.io/solo-io/packer-builder-arm-image:v0.1.4.5 build raspbian/raspbian-lite.json

test-rpi: build-rpi
	${D} run -it -v ${PWD}/output-arm-image/image:/sdcard/filesystem.img lukechilds/dockerpi:vm

write-rpi:
	sudo dd bs=4m if=output-arm-image/image of=${DISK}

clean: 
	${RM} -rf output-arm-image packer-cache

