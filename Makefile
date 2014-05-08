#A makefile to build the merge driver

pharo/Pharo.image:
	mkdir pharo
	cd pharo; wget -O- get.pharo.org/30+vm | bash
	pharo/pharo pharo/Pharo.image --no-default-preferences eval --save Gofer new url: \'http://smalltalkhub.com/mc/ThierryGoubier/Alt30/main/\'\; package: \'GitFileTree-MergeDriver\'\; load
	git config --global merge.mcVersion.driver "`pwd`/merge --version %O %A %B"
	git config --global merge.mcMethodProperties.name "GitFileTree MergeDriver for Monticello"
	git config --global merge.mcMethodProperties.driver "`pwd`/merge --methodProperties %O %A %B"
	git config --global merge.mcProperties.name "GitFileTree MergeDriver for Monticello"
	git config --global merge.mcProperties.driver "`pwd`/merge --properties %O %A %B"

all: pharo/Pharo.image

clean:
	rm -rf pharo

