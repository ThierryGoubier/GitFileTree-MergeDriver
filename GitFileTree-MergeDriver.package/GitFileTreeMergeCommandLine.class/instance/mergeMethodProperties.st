actions
mergeMethodProperties
	| args |
	args := self argumentsWithoutOptions.
	[ 
	GitFileTreeMergeDriver new
		mergeMethodProperties: args first asFileReference
		with: args second asFileReference
		and: args third asFileReference ]
		on: Error
		do: [ self exitFailure ]