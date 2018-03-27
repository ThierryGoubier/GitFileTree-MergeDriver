actions
mergetool
	| args name |
	args := self argumentsAsFileReferences.
	name := args fourth basename.
	[ | driver |
	driver := GitFileTreeMergeDriver new.
	name = 'methodProperties.json'
		ifTrue: [ driver
				mergeMethodProperties: args first
				with: args second
				and: args third
				result: args fourth ].
	name = 'version'
		ifTrue: [ driver
				mergeVersion: args first
				with: args second
				and: args third
				result: args fourth ] ]
		on: Exception
		do:
			[ :ex | self exitFailure: 'GitFileTree-MergeDriver: ' , ex description ]