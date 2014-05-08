#A makefile for building pharo as per use.

Pharo.image:
	wget -O- get.pharo.org/30 | bash
	./pharo --nodisplay Pharo.image --no-default-preferences eval --save Gofer new url: \'http://smalltalkhub.com/mc/ThierryGoubier/Alt30/main/\'\; package: \'GitFileTree-MergeDriver\'\; load
#	pharo/pharo pharo/Pharo.image eval --save Gofer new url: \'http://smalltalkhub.com/mc/Pharo/MetaRepoForPharo30/main/\'\; configurationOf: \'SmaCC\'\; loadDevelopment
#	pharo/pharo pharo/Pharo.image eval --save Gofer new url: \'http://smalltalkhub.com/mc/ThierryGoubier/Alt30/main/\'\; package: \'UITheme-Pharo\'\; load
#	pharo/pharo pharo/Pharo.image eval --save PolymorphSystemSettings uiThemeClass: PharoTheme. FreeTypeFontProvider current updateFromSystem.

all: Pharo.image

clean:
	rm -rf Pharo.image Pharo.changes

run: Pharo.image
	./pharo Pharo.image
