A GitFileTreeMergeDriver handles the merge of FileTree metadata: version and methodProperties.

Use the author names of the two files, if any is required.

Fail if we detect some incoherencies: incoherencies require by hand manipulations, and, for that, we need someone to fire up a GUI tool (i.e. a git merge-tool written in Pharo)