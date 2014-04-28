merge-properties
mergeClassProperties: aFileReferenceA with: aFileReferenceB into: aFileReferenceC
	"Class properties are Json (or ston?) data, but can we do a global merge? Note that in some cases we end in conflict because a human intervention is needed."

	| propertiesA propertiesB propertiesMerged |
	aFileReferenceA readStreamDo: [ :s | propertiesA := MCFileTreeJsonParser parseStream: s ].
	aFileReferenceB readStreamDo: [ :s | propertiesB := MCFileTreeJsonParser parseStream: s ].
	propertiesMerged := propertiesA copy.
	#(#classinstvars #classvars #instvars #pools)
		do: [ :key | 
			(propertiesA includesKey: key)
				ifTrue: [ 
					propertiesMerged
						at: key
						put:
							(Set new
								addAll: (propertiesA at: key);
								addAll: (propertiesB at: key);
								asArray) ] ].
	#(#commentStamp)
		do: [ :key | (propertiesB at: key ifAbsent: [  ]) ifNotNil: [ :tsB | propertiesMerged at: key put: tsB ] ].
	#(#category #super #type #name) do: [ :key | self assert: (propertiesA at: key) = (propertiesB at: key) ].
	aFileReferenceC delete.
	aFileReferenceC writeStreamDo: [ :s | propertiesMerged writeCypressJsonOn: s ]