actions
mergeVersion
	| args |
	args := self argumentsWithoutOptions.
	[ 
	GitFileTreeMergeDriver new
		mergeVersion: args first asFileReference
		with: args second asFileReference
		and: args third asFileReference ]
		on: Error
		do: [ self exitFailure ]