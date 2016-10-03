merge-version
mergeVersion: ancestor with: current and: other result: result
	"Looks like a two way merge, but MC will do a proper three way merge and find the common ancestor."

	| mcCurrentInfo mcOtherInfo mcMergedInfo ancestry name versionA versionB versionMerged infoWriter |
	mcCurrentInfo := self getVersionInfoFrom: current.
	mcOtherInfo := self getVersionInfoFrom: other.
	ancestry := MCWorkingAncestry new
		addAncestor: mcCurrentInfo;
		addAncestor: mcOtherInfo.	"Now I need to generate a new name."
	versionA := self getVersionNoFromName: (mcCurrentInfo name).
	name := mcCurrentInfo name copyUpToLast: $-.
	versionB :=  self getVersionNoFromName: (mcOtherInfo name).
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
	result exists
		ifTrue: [ result delete ].
	result
		writeStreamDo: [ :fileStream | 
			infoWriter stream: fileStream.
			infoWriter writeVersionInfo: mcMergedInfo ]