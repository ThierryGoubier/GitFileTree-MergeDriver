merge-properties
mergeClassProperties: ancestor with: current and: other result: result
	"We should do a three way merge here. At the moment, the idea of using the superset of all variable names is probably a safe bet."

	| currentProperties otherProperties mergedProperties |
	current readStreamDo: [ :s | currentProperties := MCFileTreeJsonParser parseStream: s ].
	other readStreamDo: [ :s | otherProperties := MCFileTreeJsonParser parseStream: s ].
	mergedProperties := currentProperties copy.
	#(#classinstvars #classvars #instvars #pools)
		do: [ :key | 
			(currentProperties includesKey: key)
				ifTrue: [ 
					mergedProperties
						at: key
						put:
							(Set new
								addAll: (currentProperties at: key);
								addAll: (otherProperties at: key);
								asArray) ] ].
	#(#commentStamp)
		do: [ :key | (otherProperties at: key ifAbsent: [  ]) ifNotNil: [ :tsB | mergedProperties at: key put: tsB ] ].
	#(#category #super #type #name) do: [ :key | self assert: (currentProperties at: key) = (otherProperties at: key) ].
	result exists
		ifTrue: [ result delete ].
	result writeStreamDo: [ :s | mergedProperties writeCypressJsonOn: s ]