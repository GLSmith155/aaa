PackageManifest subclass: #ManifestCPSC3220Adventure
	instanceVariableNames: ''
	classVariableNames: ''
	package: 'CPSC3220-Adventure-Manifest'!
!ManifestCPSC3220Adventure commentStamp: '' prior: 0!
An text-based adventure game framework.!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

ManifestCPSC3220Adventure class
	instanceVariableNames: ''!

!ManifestCPSC3220Adventure class methodsFor: 'code-critics'!
ruleReGuardClauseRuleV1FalsePositive
	^ #(#(#(#RGMethodDefinition #(#Game #executeCommand: #false)) #'2023-02-03T17:02:31.899303-05:00') )! !

!ManifestCPSC3220Adventure class methodsFor: 'code-critics'!
ruleGuardingClauseRuleV1FalsePositive
	^ #(#(#(#RGMethodDefinition #(#Game #executeCommand: #false)) #'2023-02-03T17:02:26.712693-05:00') )! !
SpPresenter subclass: #GamePresenter
	instanceVariableNames: 'commandTextInput commandTextOutput game'
	classVariableNames: ''
	package: 'CPSC3220-Adventure-SpecUI'!
!GamePresenter commentStamp: '' prior: 0!
Primary Pharo user interface for text-based adventure games.!


!GamePresenter methodsFor: 'actions'!
commandEntered: aString

	| result |
	result := game executeCommand: (Command parse: aString).
	commandTextOutput text:
		 result , String cr , String cr ,  commandTextOutput text.
	commandTextInput text: ''! !


!GamePresenter methodsFor: 'initialization' stamp: 'GeorgeSmith 2/19/2023 10:12'!
initialize

	super initialize.
	game := Game Fallout! !

!GamePresenter methodsFor: 'initialization' stamp: 'GeorgeSmith 2/19/2023 10:14'!
initializeWindow: aWindow

	super initializeWindow: aWindow.
	aWindow title: 'Fallout'.
	aWindow aboutText: 'A great game!!'.! !

!GamePresenter methodsFor: 'initialization'!
defaultLayout

	layout := SpBoxLayout newTopToBottom.
	layout
		spacing: 5;
		add: commandTextInput withConstraints: [ :c | c height: 40 ];
		add: commandTextOutput.
	^ layout! !

!GamePresenter methodsFor: 'initialization'!
initializePresenters

	super initializePresenters.
	commandTextInput := self newTextInput
		                    placeholder: 'Enter your command';
		                    yourself.
	commandTextInput whenSubmitDo: [:t |
		self commandEntered: t].
	commandTextOutput := self newText! !
Object subclass: #Command
	instanceVariableNames: 'commandWord arguments'
	classVariableNames: ''
	package: 'CPSC3220-Adventure-Core'!
!Command commentStamp: '' prior: 0!
A command has a keyword (#commandWord) and a collection of 0 or more arguments.  For example, the string 'go west' corresponds to the commandWord 'go' and an arguments list of #('west').!


!Command methodsFor: 'initialization'!
arguments: anObject

	arguments := anObject! !


!Command methodsFor: 'executing'!
executeInGame: aGame

	self subclassResponsibility! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

Command class
	instanceVariableNames: ''!

!Command class methodsFor: 'instance creation'!
parse: aString

	| tokens commandClass |
	tokens := aString substrings: ' '.
	commandClass := self allSubclasses
		                detect: [ :each | each commandWord = tokens first ]
		                ifNone: [ InvalidCommand ].
	^ commandClass new
		 
		  arguments: tokens allButFirst;
		  yourself! !


Object subclass: #Game
	instanceVariableNames: 'player'
	classVariableNames: ''
	package: 'CPSC3220-Adventure-Core'!
!Game commentStamp: '' prior: 0!
An adventure game.  I start the player in a given location and can execute commands.!


!Game methodsFor: 'command execution'!
executeCommand: aCommand

	^aCommand executeInGame: self! !

!Game methodsFor: 'command execution'!
go: aDirection

	player go: aDirection.
	^player look! !

!Game methodsFor: 'command execution'!
invalidCommand

	^'Invalid command'! !

!Game methodsFor: 'command execution'!
look

	^player look! !


!Game methodsFor: 'initialization'!
initializeStartLocation: aLocation

	player := Player location: aLocation! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

Game class
	instanceVariableNames: ''!

!Game class methodsFor: 'sample games' stamp: 'GeorgeSmith 2/19/2023 11:11'!
Fallout

| goodspringsPrimm primmMojaveOutpost primmBisonSteve novac newVegas |
goodspringsPrimm := Location new
                    description: 'The quiet town of Goodsprings';
                    yourself.
primmMojaveOutpost := Location new
                      description: 'The Mojave Outpost, a small NCR checkpoint';
                      yourself.
primmBisonSteve := Location new
                   description: 'The Bison Steve Hotel, now infested with raiders';
                   yourself.
novac := Location new
         description: 'The Dino Dee-lite Motel, the home of the infamous "No-Bark" Noonan';
         yourself.
newVegas := Location new
            description: 'The shining jewel of the Mojave, where fortunes are won and lost';
            yourself.
goodspringsPrimm
    addExit: primmMojaveOutpost direction: 'south';
    addExit: primmBisonSteve direction: 'east';
    addExit: newVegas direction: 'northwest'.
primmMojaveOutpost
    addExit: goodspringsPrimm direction: 'north';
    addExit: novac direction: 'east'.
primmBisonSteve
    addExit: goodspringsPrimm direction: 'west';
    addExit: newVegas direction: 'southwest'.
novac addExit: primmMojaveOutpost direction: 'west'.
newVegas
    addExit: goodspringsPrimm direction: 'southeast';
    addExit: novac direction: 'west';
    addExit: primmBisonSteve direction: 'northwest'.
^ self startLocation: goodspringsPrimm! !

!Game class methodsFor: 'sample games'!
skyrim

	| riverwoodSouth riverwoodNorth riverwoodTrader |
	riverwoodSouth := Location new
		                  description: 'South end of Riverwood';
		                  yourself.
	riverwoodNorth := Location new
		                  description: 'North end of Riverwood';
		                  yourself.
	riverwoodTrader := Location new
		                   description:
			                   'The Riverwood Trader.  Sell all of your useless gear here!!';
		                   yourself.
	riverwoodSouth
		addExit: riverwoodNorth direction: 'north';
		addExit: riverwoodTrader direction: 'east'.
	riverwoodNorth addExit: riverwoodSouth direction: 'south'.
	riverwoodTrader addExit: riverwoodSouth direction: 'out'.
	^ self startLocation: riverwoodSouth! !


!Game class methodsFor: 'instance creation'!
startLocation: aLocation

	^self new initializeStartLocation: aLocation! !


Command subclass: #GoCommand
	instanceVariableNames: ''
	classVariableNames: ''
	package: 'CPSC3220-Adventure-Core'!
!GoCommand commentStamp: '' prior: 0!
The go command.!


!GoCommand methodsFor: 'executing'!
executeInGame: aGame

	^ aGame go: arguments first! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!
TimePassage subclass: #GameTime
   instanceVariableNames: 'hours'
   classVariableNames: ''
   package: 'CPSC3220-Adventure-Core'!

!GameTime methodsFor: 'initialization'!
initialize
   super initialize.
   hours := 12. "starting at noon"!

!GameTime methodsFor: 'actions'!
update: hoursIncrement
   hours := hours + hoursIncrement.
   self display.

!GameTime methodsFor: 'display'!
display
   Transcript show: 'Current time: ' , self asString; cr.

!Game subclass: #Game
   instanceVariableNames: 'player time'
   classVariableNames: ''
   package: 'CPSC3220-Adventure-Core'!

!Game methodsFor: 'command execution'!
executeCommand: aCommand
   | result |
   result := aCommand executeInGame: self.
   time update: 2. "every time the player goes to a new location it goes up by 2 hours"
   result := result, String cr, 'Time: ', time asString, String cr.
   ^ result! 

!Game methodsFor: 'initialization'!
initializeStartLocation: aLocation
   player := Player location: aLocation.
   time := GameTime new! 
"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

GoCommand class
	instanceVariableNames: ''!

!GoCommand class methodsFor: 'accessing'!
commandWord

	^'go'! !


Command subclass: #InvalidCommand
	instanceVariableNames: ''
	classVariableNames: ''
	package: 'CPSC3220-Adventure-Core'!
!InvalidCommand commentStamp: '' prior: 0!
I correspond to an invalid command (one whose command word is not understood).!


!InvalidCommand methodsFor: 'executing'!
executeInGame: aGame

	^aGame invalidCommand! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

InvalidCommand class
	instanceVariableNames: ''!

!InvalidCommand class methodsFor: 'accessing'!
commandWord

	^'invalid'! !


Object subclass: #Location
	instanceVariableNames: 'exits description'
	classVariableNames: ''
	package: 'CPSC3220-Adventure-Core'!
!Location commentStamp: '' prior: 0!
A location in the game world.  Has exits each with a unique direction associated with them.!


!Location methodsFor: 'exits'!
exitNames

	^ exits keys asSet! !

!Location methodsFor: 'exits'!
exitInDirection: aDirection

	^exits at: aDirection

	! !

!Location methodsFor: 'exits'!
addExit: anExit direction: aDirection

	exits at: aDirection put: anExit
	! !


!Location methodsFor: 'accessing'!
description

	^ description! !

!Location methodsFor: 'accessing'!
description: anObject

	description := anObject! !


!Location methodsFor: 'initialization'!
initialize

	super initialize.
	exits := Dictionary new.! !


Command subclass: #LookCommand
	instanceVariableNames: ''
	classVariableNames: ''
	package: 'CPSC3220-Adventure-Core'!
!LookCommand commentStamp: '' prior: 0!
The look command.!


!LookCommand methodsFor: 'executing'!
executeInGame: aGame

	^aGame look! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

LookCommand class
	instanceVariableNames: ''!

!LookCommand class methodsFor: 'accessing'!
commandWord

	^'look'! !


Object subclass: #Player
	instanceVariableNames: 'location'
	classVariableNames: ''
	package: 'CPSC3220-Adventure-Core'!
!Player commentStamp: '' prior: 0!
I am a player with a location and...!


!Player methodsFor: 'actions'!
go: aDirection

	location := location exitInDirection: aDirection! !

!Player methodsFor: 'actions'!
look

	| ws |
	ws := String new writeStream.
	ws
		nextPutAll: location description;
		cr;
		cr.
	self describeExitsOn: ws.
	^ ws contents! !


!Player methodsFor: 'private'!
describeExitsOn: ws
location exitNames
		ifEmpty: [ ws nextPutAll: 'No exits' ]
		ifNotEmpty: [ 
			ws
				nextPutAll: 'Exits:';
				cr.
			location exitNames
				do: [ :e | ws nextPutAll: e ]
				separatedBy: [ ws nextPutAll: ', ' ] ].! !


!Player methodsFor: 'initialization'!
initializeLocation: aLocation

	location := aLocation.
	! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

Player class
	instanceVariableNames: ''!

!Player class methodsFor: 'instance creation'!
location: aLocation

	^self new initializeLocation: aLocation! !
