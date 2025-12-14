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

    ' ��l�]�w
    Tokens = 0       ' ���]�ƭܦ� 3 �� (ID 2,1,0)
    Blocks = 0       ' ���]�ƭܦ� 3 �� (ID 2,1,0)
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
    ' --- �ק�j���޿�G�令���裡���P���| ---
    ' �ڭ̥H TokenID ���D�j��A�C������@�� (Token + Block)
    For BlockID = Blocks To 9 Step +1
        
        ' Step 1: �����é�m Token (���h)
        Pick_Infeed_Token()
        
        Place_Stack_Token() ' �s�g����m�禡

        ' Step 2: �����ð��| Block (�W�h)
        Pick_Infeed_Block()
        
        Place_Stack_Block() ' �s�g�����|�禡
        
    Next BlockID

    Go Nettral
    Print "--------------------------------"
    Print "Cycle Complete."
    Print "Total Running Time: ", Tmr(0), " seconds"
    Print "--------------------------------"
    
Fend
'--- function start ---

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
'--- �H�U�O�ק諸��m Function ---

Function Place_Stack_Token
    ' �N Token ��b�Z�� startPickRec X(30) ���a�O�W
    ' ���]��m�I�� Z=0 �O�ୱ
    
    Print "Placing Token to Stack Base."
    Print "Current Stack Number: ", StackNum
    
    ' 1. �ֳt���ʨ�ؼФW��w���I (�H startPickRec ����ǩ� X+30)
    Go stackZ0 +Z(10 + (StackNum * TokenHeight)) CP
    
    ' 2. �����U����m (Z=0 �N���K�a�A������I�찪�׽վ�)
    Move stackZ0 +Z((StackNum + 1) * TokenHeight)
    
    Off 8
    'Wait .5
    
    ' 3. �W�����}
    Go stackZ0 +Z(StackNum * BlockHeight + 10)
    
    ' �����w�s�p��
    Tokens = Tokens + 1
    StackNum = StackNum + 1
Fend

Function Place_Stack_Block
    ' �N Block �|�b Token �W��
    ' ���I�G��m���� Z �����]�t�U�� Token ���p�� (TokenHeight)
    
    Print "Stacking Block on top of Token."
    Print "Current Stack Number: ", StackNum
    
    ' 1. ���ʨ�ؼФW��w���I
    Go stackZ0 +Z(10 + (StackNum * BlockHeight)) CP
    
    ' 2. �����U����m
    ' �`�N�G�o�̪� Z �O TokenHeight (6.0)�A�]���U���w�g���@�� Token �F
    Move stackZ0 +Z((StackNum + 1) * BlockHeight)
    
    Off 8
    'Wait .5
    
    ' 3. �W�����}
    Go stackZ0 +Z(StackNum * BlockHeight + 10)
    
    ' �����w�s�p��
    Blocks = Blocks + 1
    StackNum = StackNum + 1
Fend
