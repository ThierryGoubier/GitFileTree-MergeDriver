activation
argumentsAsFileReferences
	| pwd |
	pwd := (Smalltalk os environment at: 'PWD' ifAbsent: [ Smalltalk os environment at: 'CD' ]) asFileReference.
	^ self argumentsWithoutOptions collect: [ :each | pwd resolveReference: each asFileReference ]