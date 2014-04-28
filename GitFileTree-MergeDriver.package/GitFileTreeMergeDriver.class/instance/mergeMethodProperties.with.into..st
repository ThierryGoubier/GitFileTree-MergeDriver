merge-properties
mergeMethodProperties: aFileReferenceA with: aFileReferenceB into: aFileReferenceC
	"Method properties are Json (or ston?) data."

	| propertiesA propertiesB propertiesMerged |
	aFileReferenceA readStreamDo: [ :s | propertiesA := MCFileTreeJsonParser parseStream: s ].
	aFileReferenceB readStreamDo: [ :s | propertiesB := MCFileTreeJsonParser parseStream: s ].
	propertiesMerged := propertiesA copy.
	#(#class #instance)
		do: [ :mainKey | 
			(propertiesA at: mainKey)
				keysAndValuesDo: [ :key :valueA | 
					((propertiesB at: mainKey) at: key ifAbsent: [  ])
						ifNotNil: [ :valueB | 
							(DateAndTime fromMethodTimeStamp: valueB) > (DateAndTime fromMethodTimeStamp: valueA)
								ifTrue: [ (propertiesMerged at: mainKey) at: key put: valueB ] ] ].
			(propertiesB at: mainKey)
				keysAndValuesDo: [ :key :valueB | (propertiesA at: mainKey) at: key ifAbsent: [ (propertiesMerged at: mainKey) at: key put: valueB ] ] ].	"Write propertiesMerged."
	aFileReferenceC delete.
	aFileReferenceC writeStreamDo: [ :s | propertiesMerged writeCypressJsonOn: s ]