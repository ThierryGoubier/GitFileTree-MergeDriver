private
getVersionNoFromName: aName
	| versionNo |
	versionNo := (aName copyAfterLast: $-) copyAfterLast: $..
	(versionNo notEmpty and: [ versionNo allSatisfy: [ :each | each isDigit ] ])
		ifTrue: [ versionNo := versionNo asNumber ]
		ifFalse: [ versionNo := 0 ].
	^ versionNo