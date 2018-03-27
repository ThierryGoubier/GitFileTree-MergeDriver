tests
testStack
	core
		x: 1;
		enter;
		x: 2;
		enter;
		x: 3;
		enter;
		x: 4.
	self assert: core x equals: 4.
	self assert: core y equals: 3.
	self assert: core z equals: 2.
	self assert: core t equals: 1.
	core rollDown.
	self assert: core x equals: 3.
	self assert: core y equals: 2.
	self assert: core z equals: 1.
	self assert: core t equals: 4.
	core swap.
	self assert: core x equals: 2.
	self assert: core y equals: 3