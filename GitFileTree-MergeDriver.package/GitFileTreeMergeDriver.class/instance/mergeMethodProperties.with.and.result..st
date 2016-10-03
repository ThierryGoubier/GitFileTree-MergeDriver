merge-properties
mergeMethodProperties: ancestor with: current and: other result: result
	"Method properties are Json (or ston?) data. A two way merge is good enough since we have timestamps on all entries."

	| otherProperties currentProperties mergedProperties |
	other readStreamDo: [ :s | otherProperties := MCFileTreeJsonParser parseStream: s ].
	current readStreamDo: [ :s | currentProperties := MCFileTreeJsonParser parseStream: s ].
	mergedProperties := currentProperties copy.
	#(#class #instance)
		do: [ :mainKey | 
			(currentProperties at: mainKey)
				keysAndValuesDo: [ :key :valueA | 
					((otherProperties at: mainKey) at: key ifAbsent: [  ])
						ifNotNil: [ :valueB | 
							(self getTimeStampFrom: valueB) > (self getTimeStampFrom: valueA)
								ifTrue: [ (mergedProperties at: mainKey) at: key put: valueB ] ] ].
			(otherProperties at: mainKey)
				keysAndValuesDo: [ :key :valueB | (currentProperties at: mainKey) at: key ifAbsent: [ (mergedProperties at: mainKey) at: key put: valueB ] ] ].	"Write propertiesMerged."
	result exists
		ifTrue: [ result delete ].
	result writeStreamDo: [ :s | mergedProperties writeCypressJsonOn: s ]