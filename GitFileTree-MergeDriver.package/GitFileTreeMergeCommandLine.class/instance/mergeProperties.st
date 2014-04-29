actions
mergeProperties
	| args |
	args := self argumentsWithoutOptions.
	[ 
	GitFileTreeMergeDriver new
		mergeClassProperties: args first asFileReference
		with: args second asFileReference
		and: args third asFileReference ]
		on: Error
		do: [ self exitFailure ]