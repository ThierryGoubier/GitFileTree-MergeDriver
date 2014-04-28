activation
argumentsWithoutOptions
	^ self arguments reject: [ :each | #('--version' '--methodProperties' '--properties') includes: each ]