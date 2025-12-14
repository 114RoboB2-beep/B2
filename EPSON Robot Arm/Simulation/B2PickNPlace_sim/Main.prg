Integer Tokens
Integer Blocks
Double TokenHeight
Double BlockHeight

Function main
	TmReset 0
    Motor On
    Power High
    Speed 30
    Accel 30, 30
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

    
    ' Check for typo in your original code: "Nettral" -> "Neutral"
    Go Nettral
    
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
    Wait .5
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
    Wait .5
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
    Move Pallet(1, Tokens) -Y(10)
Fend

Function Place_Tray_Block
    Pallet 1, Pallet1, Pallet3, Pallet4, 3, 2
    Print "Placing Block. Position = ", Blocks
    Go Pallet(1, 6) -Z(45) +U(75) CP
    Go Pallet(1, Blocks + 3) -Z(20) +U(75) CP
    Go Pallet(1, Blocks + 3) +U(75)
    Off 8
    Go Pallet(1, Blocks + 3) +Y(10) +U(75)
Fend
