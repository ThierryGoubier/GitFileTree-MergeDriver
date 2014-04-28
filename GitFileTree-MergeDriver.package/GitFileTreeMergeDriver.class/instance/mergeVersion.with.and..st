merge-version
mergeVersion: ancestor with: current and: other
	"Looks like a two way merge, but MC will do a proper three way merge and find the common ancestor."

	| mcCurrentInfo mcOtherInfo mcMergedInfo ancestry name versionA versionB versionMerged infoWriter |
	mcCurrentInfo := MCWorkingCopy
		infoFromDictionary: (MCFileTreeAbstractReader new associate: (MCScanner scan: current readStream))
		cache: Dictionary new.
	mcOtherInfo := MCWorkingCopy
		infoFromDictionary: (MCFileTreeAbstractReader new associate: (MCScanner scan: other readStream))
		cache: Dictionary new.
	ancestry := MCWorkingAncestry new
		addAncestor: mcCurrentInfo;
		addAncestor: mcOtherInfo.	"Now I need to generate a new name."
	versionA := (mcCurrentInfo name copyAfterLast: $-) copyAfterLast: $..
	(versionA notEmpty and: [ versionA allSatisfy: [ :each | each isDigit ] ])
		ifTrue: [ versionA := versionA asNumber ]
		ifFalse: [ versionA := 0 ].
	name := mcCurrentInfo name copyUpToLast: $-.
	versionB := (mcOtherInfo name copyAfterLast: $-) copyAfterLast: $..
	(versionB notEmpty and: [ versionB allSatisfy: [ :each | each isDigit ] ])
		ifTrue: [ versionB := versionA asNumber ]
		ifFalse: [ versionB := 0 ].
	versionMerged := (versionA max: versionB) + 1.
	mcMergedInfo := MCVersionInfo
		name: name , '-' , mcCurrentInfo author , '.' , versionMerged printString
		id: UUID new
		message: 'merged by GitFileTree-MergeDriver'
		date: Date today
		time: Time now
		author: mcCurrentInfo author
		ancestors: ancestry ancestors asArray
		stepChildren: ancestry stepChildren asArray.
	infoWriter := MCFileTreeVersionInfoWriter new.
	current exists
		ifTrue: [ current delete ].
	current
		writeStreamDo: [ :fileStream | 
			infoWriter stream: fileStream.
			infoWriter writeVersionInfo: mcMergedInfo ]