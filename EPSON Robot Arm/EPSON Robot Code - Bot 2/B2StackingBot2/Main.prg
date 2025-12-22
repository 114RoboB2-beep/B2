Integer Tokens
Integer Blocks
Double TokenHeight
Double BlockHeight
Integer TokenID
Integer BlockID
Integer StackNum

Function main
    Motor On
    Power High
    Speed 35
    Accel 40, 40
    SpeedS 500
    AccelS 5000
    Tool 1

    ' Initialize Variables
    Tokens = 0
    Blocks = 0
    StackNum = 0
    TokenHeight = 6.0
    BlockHeight = 6.0

	' --- Mod based on the number of tokens needed ---
	' Original is three each
	startPickCir = startPickCir -Z(TokenHeight * 7)
	startPickRec = startPickRec -Z(BlockHeight * 7)
	Nettral = Nettral +Z(20)
	
	Begining:
    ' Check Start Button (Sw0)
    If Sw(0) <> On Then
        Wait 0.1
        GoTo Begining
    EndIf

    Go Nettral
    TmReset 0
    ' --- Stacking Cycle ---
    For BlockID = Blocks To 9 Step +1
        
        ' Step 1: Pick Up Token
        Pick_Infeed_Token()

        ' Place it on the stacking point
        Place_Stack_Token() 

        ' Step 2: Pick Up Block
        Pick_Infeed_Block()
        
        ' Place it on the stacking point
        Place_Stack_Block()
        
    Next BlockID

    Go Nettral
    Print "--------------------------------"
    Print "Cycle Complete."
    Print "Total Running Time: ", Tmr(0), " seconds"
    Print "--------------------------------"
    
Fend

'--- Functions Start ---
Function Pick_Infeed_Token
	'Pick Token from Infeed
	Print "Picking Token from Infeed. Token ID = ", Tokens
	Go startPickCir -Z(30) CP
	Move startPickCir +Z(Tokens * TokenHeight + 0.25)
	On 8
	Wait .35
	Move startPickCir -Z(45)
Fend

Function Pick_Infeed_Block
	'Pick Block from Infeed
	Print "Picking Block from Infeed. Block ID = ", Blocks
	Go startPickRec -Z(30) CP
	Move startPickRec +Z(Blocks * BlockHeight + 0.25)
	On 8
	Wait .35
	Move startPickRec -Z(45)
Fend

Function Place_Stack_Token
    ' Set Tokens Down
    
    Print "Placing Token to Stack Base."
    Print "Current Stack Number: ", StackNum
    
    ' 1. Go directly above the stacking point
    Go stackZ0 +Z(10 + (StackNum * TokenHeight)) CP
    
    ' 2. Move straight down
    Move stackZ0 +Z((StackNum + 1) * TokenHeight)
    
    Off 8
    'Wait .5
    
    ' 3. Lift up arm
    Go stackZ0 +Z(StackNum * BlockHeight + 10)
    
    ' Increment token counter
    Tokens = Tokens + 1
    StackNum = StackNum + 1
Fend

Function Place_Stack_Block
    ' Set Blocks Down

    Print "Stacking Block on top of Token."
    Print "Current Stack Number: ", StackNum
    
    ' 1. Go directly above the stacking point
    Go stackZ0 +Z(10 + (StackNum * BlockHeight)) CP
    
    ' 2. Move straight down
    Move stackZ0 +Z((StackNum + 1) * BlockHeight)
    
    Off 8
    'Wait .5
    
    ' 3. Lift up arm
    Go stackZ0 +Z(StackNum * BlockHeight + 10)

    ' Increment block counter
    Blocks = Blocks + 1
    StackNum = StackNum + 1
Fend
