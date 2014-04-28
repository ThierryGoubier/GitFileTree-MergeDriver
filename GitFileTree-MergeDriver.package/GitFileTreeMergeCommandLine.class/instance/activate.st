activation
activate
	self activateHelp
		ifTrue: [ ^ self ].
	(self hasOption: 'version')
		ifTrue: [ 
			self mergeVersion.
			^ self exitSuccess ].
	(self hasOption: 'methodProperties')
		ifTrue: [ 
			self mergeMethodProperties.
			^ self exitSuccess ].
	(self hasOption: 'properties')
		ifTrue: [ 
			self mergeProperties.
			^ self exitSuccess ].
	self printHelp.
	^ self exitFailure