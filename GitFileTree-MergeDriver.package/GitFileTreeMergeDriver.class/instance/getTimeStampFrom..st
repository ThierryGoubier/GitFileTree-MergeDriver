private
getTimeStampFrom: aMethodStringTimeStamp
	aMethodStringTimeStamp isEmpty
		ifTrue: [ ^ DateAndTime epoch ].
	^ [ 
	| stream |
	stream := aMethodStringTimeStamp readStream.
	stream
		skipSeparators;
		skipTo: Character space.
	(stream peekFor: $()
		ifTrue: [ 
			stream
				skipTo: $);
				skipTo: Character space ].
	DateAndTime readSeparateDateAndTimeFrom: stream ]
		on: Exception
		do: [ DateAndTime epoch ]