GitFileTree-MergeDriver
=======================

This is a merge driver for git. It handles merging conflict-prone files in FileTree, which are: monticello.meta/version, methodProperties.json and properties.json.

How to make it work:

Clone this repository (or get from here the Makefile and the merge script and put them in a folder). Run the following command in that folder:

```
$ make
$ git config --global merge.mcVersion.name "GitFileTree MergeDriver for Monticello"
$ git config --global merge.mcVersion.driver "`pwd`/merge --version %O %A %B"
$ git config --global merge.mcMethodProperties.name "GitFileTree MergeDriver for Monticello"
$ git config --global merge.mcMethodProperties.driver "`pwd`/merge --methodProperties %O %A %B"
$ git config --global merge.mcProperties.name "GitFileTree MergeDriver for Monticello"
$ git config --global merge.mcProperties.driver "`pwd`/merge --properties %O %A %B"
```

In your global config file, you should now have the following :

```
[merge "mcVersion"]
	name = GitFileTree MergeDriver for Monticello
	driver = pathToGitFileTree-MergeDriver/merge --version %O %A %B
[merge "mcMethodProperties"]
	name = GitFileTree MergeDriver for Monticello
	driver = pathToGitFileTree-MergeDriver/merge --methodProperties %O %A %B
[merge "mcProperties"]
	name = GitFileTree MergeDriver for Monticello
	driver = pathToGitFileTree-MergeDriver/merge --properties %O %A %B
```

Add, in the main repository containing your FileTree packages (for example, top level or repository/), a .gitattributes file containing the following:

```
*.package/monticello.meta/version		merge=mcVersion
*.package/*.class/methodProperties.json		merge=mcMethodProperties
*.package/*.class/properties.json		merge=mcProperties
```

Now, you should be able to merge with git and have a minimum of conflicts.

As an example, this is the normal output when merging under git with FileTree (or GitFileTree) packages (with two versions of the SmaCC tutorial in each branch) :
```
$ git merge aBranch
Auto-merging SmaCC-Tutorial.package/monticello.meta/version
CONFLICT (content): Merge conflict in SmaCC-Tutorial.package/monticello.meta/version
Auto-merging SmaCC-Tutorial.package/CalculatorParser.class/methodProperties.json
CONFLICT (content): Merge conflict in SmaCC-Tutorial.package/CalculatorParser.class/methodProperties.json
Auto-merging SmaCC-Tutorial.package/ASTFunctionNode.class/methodProperties.json
CONFLICT (add/add): Merge conflict in SmaCC-Tutorial.package/ASTFunctionNode.class/methodProperties.json
Auto-merging SmaCC-Tutorial.package/ASTFunctionNode.class/instance/compositeTokenVariables.st
CONFLICT (add/add): Merge conflict in SmaCC-Tutorial.package/ASTFunctionNode.class/instance/compositeTokenVariables.st
Auto-merging SmaCC-Tutorial.package/ASTExpressionNode.class/methodProperties.json
CONFLICT (content): Merge conflict in SmaCC-Tutorial.package/ASTExpressionNode.class/methodProperties.json
Automatic merge failed; fix conflicts and then commit the result.
```
We have conflicts with monticello.meta/version, three methodProperties.json files, and a .st file

After adding the GitFileTree-MergeDriver (.gitattributes and config and ...), we get the following output when we try the same merge:
```
$ git reset --hard
HEAD is now at 4eadb6c Resaving to make sure we have a clean version file
$ git merge aBranch
Auto-merging SmaCC-Tutorial.package/monticello.meta/version
Auto-merging SmaCC-Tutorial.package/CalculatorParser.class/methodProperties.json
Auto-merging SmaCC-Tutorial.package/ASTFunctionNode.class/methodProperties.json
Auto-merging SmaCC-Tutorial.package/ASTFunctionNode.class/instance/compositeTokenVariables.st
CONFLICT (add/add): Merge conflict in SmaCC-Tutorial.package/ASTFunctionNode.class/instance/compositeTokenVariables.st
Auto-merging SmaCC-Tutorial.package/ASTExpressionNode.class/methodProperties.json
Automatic merge failed; fix conflicts and then commit the result.
```
See: the version file and the methodProperties.json file have been merged without conflict; and, when looking inside, the version file has the two branches versions as ancestors, and a common ancestor as well:

```smalltalk
(
	name 'SmaCC-Tutorial-ThierryGoubier.4'
	message 'merged by GitFileTree-MergeDriver'
	id 'f69f6d1f-d4d2-4da9-b755-e26f6432c980'
	date '29 April 2014' time '4:37:32.372857 pm'
	author 'ThierryGoubier'
	ancestors (
		(
			name 'SmaCC-Tutorial-ThierryGoubier.3'
			message 'Resaving to make sure we have a clean version file'
			id '911c2501-29ce-4a78-8596-51e84fdbb7fb'
			date '27 April 2014' time '10:21:24.06832 pm'
			author 'ThierryGoubier'
			ancestors (
				(
					name 'SmaCC-Tutorial-ThierryGoubier.2'
					message '3ème version'
					id 'fa358cff-9ffa-5db4-b04a-f88a0c3fc468'
					date '27 April 2014' time '10:08:59 pm'
					author 'ThierryGoubier'
					ancestors (
						(
							name 'SmaCC-Tutorial-ThierryGoubier.1'
							message 'First save.'
							id 'e198578e-77db-5e80-b4b5-70e05de13344'
							date '27 April 2014' time '10:07:06 pm'
							author 'ThierryGoubier'
							ancestors ()
							stepChildren ()))
					stepChildren ()))
			stepChildren ())
		(
			name 'SmaCC-Tutorial-ThierryGoubier.3'
			message 'Save again to get a clean version file'
			id 'e48d00a4-84cc-406d-b0d5-2382deb1f0e4'
			date '29 April 2014' time '2:25:09.900645 pm'
			author 'ThierryGoubier'
			ancestors (
				(
					name 'SmaCC-Tutorial-ThierryGoubier.2'
					message '2nd version'
					id '2e7ebe53-49bf-5f8b-b9ac-7e2da65a2761'
					date '27 April 2014' time '10:08:01 pm'
					author 'ThierryGoubier'
					ancestors (
						(id 'e198578e-77db-5e80-b4b5-70e05de13344'))
					stepChildren ()))
			stepChildren ()))
	stepChildren ())
```
(Formatted for an easier reading). Note how id 'e198578e-77db-5e80-b4b5-70e05de13344' is the common ancestor to both branches, and how GitFileTree-MergeDriver has created a proper merge in MC during the git merge.

This is especially important for FileTree and github:// Metacello Urls, since both rely on a correct version file to work. GitFileTree is less dependent in correct results; just the lack of conflicts is a huge boost.
