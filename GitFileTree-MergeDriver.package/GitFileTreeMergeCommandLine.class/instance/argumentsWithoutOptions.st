activation
argumentsWithoutOptions
	^ self arguments reject: [ :each | #('--version' '--methodProperties' '--properties' '--mergetool') includes: each ]