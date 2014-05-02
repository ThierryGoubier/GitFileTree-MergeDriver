private
getVersionInfoFrom: aVersionFile
	| mcInfo |
	aVersionFile
		readStreamDo: [ :aStream | 
			mcInfo := MCWorkingCopy
				infoFromDictionary: (MCFileTreeAbstractReader new associate: (MCScanner scan: aStream))
				cache: Dictionary new ].
	^ mcInfo