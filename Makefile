#A makefile to build the merge driver

pharo/Pharo.image:
	mkdir pharo
	cd pharo; wget -O- get.pharo.org/30+vm | bash
	pharo/pharo pharo/Pharo.image --no-default-preferences eval --save Gofer new url: \'http://smalltalkhub.com/mc/ThierryGoubier/Alt30/main/\'\; package: \'GitFileTree-MergeDriver\'\; load

all: pharo/Pharo.image

clean:
	rm -rf pharo

