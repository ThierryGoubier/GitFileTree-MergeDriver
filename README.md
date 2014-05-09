GitFileTree-MergeDriver
=======================

This is a merge driver for git. It handles merging conflict-prone files in FileTree, which are: monticello.meta/version, methodProperties.json and properties.json.

How to make it work:

Clone this repository (or get from here the Makefile and the merge script and put them in a folder). Run the following command in that folder:

```
$ make
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

How does this works?
--------------------

From reading the git man pages, and particularly gitattributes(5), one can note that git has a huge amount of customisation available for different file types, for specific operations: diff, merge, and merge conflict resolutions.

When conflicts occurs, they do appear when git attempts three-way merges between the current version of a file, the version being merged, and the common ancestor. Git has a strategy for doing the merge if the file is considered as text (three way per line merge), and another strategy if the file is considered binary (keep the current one?); git may also do more merges between ancestors to create the common ancestor. For merging, git delegates to a merge driver and can give him up to four parameters: the current file, the _other_ (from the commit to merge), the _ancestor_, and eventually the length of the conflict markers.

From gitattributes, we see that it is possible to define a merge driver, as an external command (in gitconfig), and to associate it to a file (in the attributes).

So, this is what the GitFileTree-MergeDriver uses:
- version and .json files in FileTree are in fact binary data; git however consider them as text files and tries to merge them as text, which is wrong and creates conflicts.
- Take Monticello and FileTree code to be able to merge two version files (FileTree for reading the version file as a MCVersionInfo, Monticello for creating a new version merging both branches, FileTree for writing back the version file)
- Use FileTree json support for reading properties files, choosing an ad-hoc strategy for merging the two versions.
	- Merging method properties is done by timestamp comparison, with a fall back on epoch if the timestamp can't be parsed (which happens).
	- Merging class properties (class definition) is done by merging sets of attributes and failing in other cases.

And, by being defined as a merge driver for git and associated with those files, GitFileTree-MergeDriver is called by git on each merge, with the three files: _current_, _other_ and _ancestor_. A correct merge is written back into _current_, a failure to merge is a non-zero return status and git will tell us it is a conflict.

Not all conflicts can be resolved that way. In the resolution of conflicts, we have yet another way of customizing git behavior, by using a specific merge tool for interactive conflict resolution. For example, a common merge will have the following process:

```
$ git merge aCommit
...
Automatic merge failed; fix conflicts and then commit the result.
$ git merge-tool
...
```

The git merge-tool command will call an external GUI tool, such as meld, to let us resolve the conflict by hand by selecting parts of the two versions of the file (_current_ and _other_, with usually _ancestor_ also displayed) to keep or reject.

However, usual tools are not too good at merging .st files :) or version files the merge driver hasn't managed to merge, so the next step after the merge driver would be to implement a merge tool in Smalltalk which knows how to:
- Interactively let us merge standard text files
- Handle .st files a bit better (by putting them, for example, in their package context?)
- Handle conflicting version and properties file as well.

This will be for the future :)

