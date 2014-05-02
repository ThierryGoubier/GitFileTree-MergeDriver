actions
mergeVersion
	| args |
	args := self argumentsAsFileReferences.
	[ GitFileTreeMergeDriver new mergeVersion: args first with: args second and: args third ]
		on: Exception
		do: [ :ex | self exitFailure: 'GitFileTree-MergeDriver: ' , ex description ]