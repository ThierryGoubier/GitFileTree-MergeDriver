GitFileTree-MergeDriver
=======================

This is a merge driver for git. It handles merging conflict-prone files in FileTree, which are: monticello.meta/version, methodProperties.json and properties.json.

How to make it work:

Load the GitFileTree-MergeDriver package.

Add, in ~/.gitconfig or whichever place it is in your git setup, the following (depending on where your image is):

```
[merge "mcVersion"]
	name = GitFileTree MergeDriver for Monticello
	driver = src/Pharo3/pharo/pharo /home/thierry/src/Pharo3/pharo/Pharo.image mergeDriver --version %O %A %B
[merge "mcMethodProperties"]
	name = GitFileTree MergeDriver for Monticello
	driver = src/Pharo3/pharo/pharo /home/thierry/src/Pharo3/pharo/Pharo.image mergeDriver --methodProperties %O %A %B
[merge "mcProperties"]
	name = GitFileTree MergeDriver for Monticello
	driver = src/Pharo3/pharo/pharo /home/thierry/src/Pharo3/pharo/Pharo.image mergeDriver --properties %O %A %B
```

Add, in each .package directory, a .gitattributes file containing the following:

```
/monticello.meta/version		          merge=mcVersion
/*.class/methodProperties.json                    merge=mcMethodProperties
/*.class/properties.json                          merge=mcProperties
```

Now, you should be able to merge with git and have a minimum of conflicts.
