actions
mergeVersion
	| args |
	args := self argumentsWithoutOptions.
	Transcript
		show: (Smalltalk os environment at: 'PWD' ifAbsent: [ Smalltalk os environment at: 'CD' ]);
		cr.
	GitFileTreeMergeDriver new
		mergeVersion: args first asFileReference
		with: args second asFileReference
		and: args third asFileReference