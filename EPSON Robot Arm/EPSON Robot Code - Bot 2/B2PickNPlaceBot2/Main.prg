Integer Tokens
Integer Blocks
Double TokenHeight
Double BlockHeight

Function main
    If TaskState(2) = 0 Then
        Xqt 2, RobotJob
    EndIf
Fend

Function RobotJob
    Motor On
    Power High
    Speed 45
    Accel 45, 45
    SpeedS 500
    AccelS 5000
    Tool 1
    
    ' Initialize Variables
    Tokens = 0
    Blocks = 0
    TokenHeight = 6.0
    BlockHeight = 6.0
    Integer TokenID
    Integer BlockID
    
    ' Define the Interrupt (Trap)
    ' When Sw(4) is pressed, immediately jump to PauseRoutine
    Trap 1, Sw(4) = On Call PauseRoutine

    Begining:
    ' Check Start Button (Sw0)
    If Sw(0) <> On Then
        Wait 0.1
        GoTo Begining
    EndIf
    
    ' Check for typo in your original code: "Nettral" -> "Neutral"
    Go Nettral
   	TmReset 0
    ' --- Token Cycle ---
    For TokenID = 0 To 2
        Pick_Infeed_Token()
        Alignment_Token()
        Place_Tray_Token()
    Next TokenID
    
    ' --- Block Cycle ---
    For BlockID = 0 To 2
        Pick_Infeed_Block()
        Alignment_Block()
        Place_Tray_Block()
    Next BlockID
    
    Go Nettral
    
    ' Reset counters if you want the loop to run again indefinitely
    Tokens = 0
    Blocks = 0
    
    Print "--------------------------------"
    Print "Cycle Complete."
    Print "Total Running Time: ", Tmr(0), " seconds"
    Print "--------------------------------"
Fend

' ---------------------------------------------------------
' PAUSE ROUTINE (Press and Hold Logic)
' ---------------------------------------------------------
Function PauseRoutine
    ' 1. The Trap automatically decelerates and stops the robot here.
    Print "!!! SYSTEM PAUSED - Release Button to Resume !!!"
    
    ' 2. Turn off output 8 (Vacuum) if safety requires it, 
    '    otherwise leave it to hold the part.
    
    ' 3. Loop here as long as the button is held down
    Do While Sw(4) = On
        Wait 0.1
    Loop
    
    ' 4. Once button is released, code continues here
    Print "System Resuming..."
    
    ' 5. When Fend is reached, the robot accelerates back 
    '    to where it was and finishes the interrupted move.
    Trap 1, Sw(4) = On Call PauseRoutine
Fend

' ---------------------------------------------------------
' SUB ROUTINES
' ---------------------------------------------------------

Function Pick_Infeed_Token
    Print "Picking Token. Count = ", Tokens
    Go startPickCir -Z(10 + (Tokens * TokenHeight)) CP
    Move startPickCir +Z(Tokens * TokenHeight) CP
    On 8
    Wait .5
    Move startPickCir -Z(20 + (Tokens * TokenHeight)) +X(10) -Y(10)
    Go Local1to2Cir CP
    Tokens = Tokens + 1
Fend

Function Pick_Infeed_Block
    Print "Picking Block. Count = ", Blocks
    Go startPickRec -Z(10 + (Blocks * BlockHeight)) CP
    Go startPickRec +Z(Blocks * BlockHeight) CP
    On 8
    Wait .35
    Move startPickRec -Z(20 + (Blocks * BlockHeight)) +X(10) -Y(10)
    Go Local1to2Rec CP
    Blocks = Blocks + 1
Fend

Function Alignment_Token
    Print "Aligning Token."
    Go alignCirclePlace +Z(30) CP
    Go alignCirclePlace
    Off 8
    Go alignCirclePick +Z(5)
    Wait .25
    Go alignCirclePick
    On 8
    Wait .35
    Go alignCirclePick +Z(30) CP
Fend

Function Alignment_Block
    Print "Aligning Block."
    Go alignRecPlace +Z(30) CP
    Go alignRecPlace
    Off 8
    Move alignRecPick +Z(5)
    Wait .25
    Move alignRecPick
    On 8
    Wait .5
    Go alignRecPick +Z(30)
Fend

Function Place_Tray_Token
    Pallet 1, Pallet1, Pallet3, Pallet4, 3, 2
    Print "Placing Token. Position = ", Tokens
    Go Pallet(1, 3) -Z(45) CP
    ' Note: Using 'Tokens' here works because you incremented it in Pick.
    ' Ensure the logic matches: if Tokens is now 1, do you want Pallet ID 1?
    Go Pallet(1, Tokens) -Z(20) CP
    Move Pallet(1, Tokens)
    Off 8
    Wait .1
    Move Pallet(1, Tokens) -Y(15)
Fend

Function Place_Tray_Block
    Pallet 1, Pallet1, Pallet3, Pallet4, 3, 2
    Print "Placing Block. Position = ", Blocks
    Go Pallet(1, 6) -Z(45) +U(75 - 90) CP
    Go Pallet(1, Blocks + 3) -Z(20) +U(75 - 90) CP
    Go Pallet(1, Blocks + 3) +U(75 - 90)
    Off 8
    Wait .1
    Go Pallet(1, Blocks + 3) +Y(15) +U(75 - 90)
    Go Pallet(1, Blocks + 3) +Y(15) +U(75 - 90) -Z(10)
Fend
