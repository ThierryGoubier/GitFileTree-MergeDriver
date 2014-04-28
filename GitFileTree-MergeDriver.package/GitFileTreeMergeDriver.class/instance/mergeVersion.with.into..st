merge-version
mergeVersion: aFileReferenceA with: aFileReferenceB into: aFileReferenceC
	"Do a merge of the two versions, write it back into the third one."

	| mcWorkingCopyA mcWorkingCopyB mcWorkingCopyMerged ancestry name versionA versionB versionMerged infoWriter |
	mcWorkingCopyA := MCWorkingCopy
		infoFromDictionary: (MCFileTreeAbstractReader new associate: (MCScanner scan: aFileReferenceA readStream))
		cache: Dictionary new.
	mcWorkingCopyB := MCWorkingCopy
		infoFromDictionary: (MCFileTreeAbstractReader new associate: (MCScanner scan: aFileReferenceB readStream))
		cache: Dictionary new.
	ancestry := MCWorkingAncestry new
		addAncestor: mcWorkingCopyA;
		addAncestor: mcWorkingCopyB.	"Now I need to generate a new name."
	versionA := (mcWorkingCopyA name copyAfterLast: $-) copyAfterLast: $..
	(versionA notEmpty and: [ versionA allSatisfy: [ :each | each isDigit ] ])
		ifTrue: [ versionA := versionA asNumber ]
		ifFalse: [ versionA := 0 ].
	name := mcWorkingCopyA name copyUpToLast: $-.
	versionB := (mcWorkingCopyB name copyAfterLast: $-) copyAfterLast: $..
	(versionB notEmpty and: [ versionB allSatisfy: [ :each | each isDigit ] ])
		ifTrue: [ versionB := versionA asNumber ]
		ifFalse: [ versionB := 0 ].
	versionMerged := (versionA max: versionB) + 1.
	mcWorkingCopyMerged := MCVersionInfo
		name: name , '-' , mcWorkingCopyA author , '.' , versionMerged printString
		id: UUID new
		message: 'merged by GitFileTree-MergeDriver'
		date: Date today
		time: Time now
		author: mcWorkingCopyA author
		ancestors: ancestry ancestors asArray
		stepChildren: ancestry stepChildren asArray.
	infoWriter := MCFileTreeVersionInfoWriter new.
	aFileReferenceC delete.
	aFileReferenceC
		writeStreamDo: [ :fileStream | 
			infoWriter stream: fileStream.
			infoWriter writeVersionInfo: mcWorkingCopyMerged ]