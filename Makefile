#A makefile to build the merge driver

# Use the PHARO_VM environment variable to indicate where to find the
# Pharo VM. If the environment variable is not set, set it to a newly
# downloaded VM.
PHARO_VM ?= 'pharo/pharo'

pharo/Pharo.image:
	mkdir pharo
	cd pharo; wget -O- get.pharo.org/61-minimal | bash
	cd pharo; wget -O- get.pharo.org/vmI61 | bash
	$(PHARO_VM) pharo/Pharo.image --no-default-preferences eval --save Gofer new url: \'http://ss3.gemstone.com/ss/STON\'\; package: \'STON-Core\'\; load
	$(PHARO_VM) pharo/Pharo.image --no-default-preferences eval --save Gofer new url: \'http://source.squeakfoundation.org/FFI\'\; package: \'FFI-Pools\'\; load
	$(PHARO_VM) pharo/Pharo.image --no-default-preferences eval --save Gofer new url: \'http://smalltalkhub.com/mc/Pharo/FFI-NB/main/\'\; package: \'FFI-Kernel\'\; package: \'Alien\'\; package: \'UnifiedFFI\'\; load
	$(PHARO_VM) pharo/Pharo.image --no-default-preferences eval --save Gofer new url: \'http://smalltalkhub.com/mc/Pharo/Pharo60/main/\'\; package: \'System-OSEnvironments\'\; load
	$(PHARO_VM) pharo/Pharo.image --no-default-preferences eval --save Gofer new url: \'http://smalltalkhub.com/mc/ThierryGoubier/Alt30/main/\'\; package: \'GitFileTree-MergeDriver\'\; load
	git config --global merge.mcVersion.driver "`pwd`/merge --version %O %A %B"
	git config --global merge.mcMethodProperties.name "GitFileTree MergeDriver for Monticello"
	git config --global merge.mcMethodProperties.driver "`pwd`/merge --methodProperties %O %A %B"
	git config --global merge.mcProperties.name "GitFileTree MergeDriver for Monticello"
	git config --global merge.mcProperties.driver "`pwd`/merge --properties %O %A %B"
	git config --global mergetool.mcmerge.cmd "`pwd`/merge --mergetool \$$BASE \$$LOCAL \$$REMOTE \$$MERGED"


all: pharo/Pharo.image

clean:
	rm -rf pharo

