;======================================================================
;按键处理
FC_Gamepad_Process
    LDX #FC_GAMEPAD_COUNT - 1
.Get_Gamepad_State
    JSR .Gamepad_Scan
    LDA FC_Gamepad_Keep,X
    STA FC_Gamepad_Temp,X
    JSR .Gamepad_Scan
    LDA FC_Gamepad_Keep,X
    CMP FC_Gamepad_Temp,X
    BEQ .Gamepad_Check_Value
    LDA FC_Gamepad_Buf,X
    STA FC_Gamepad_Keep,X
.Gamepad_Check_Value
    TAY
    EOR FC_Gamepad_Buf,X
    AND FC_Gamepad_Keep,X
    STA FC_Gamepad_Once_Down,X
    TYA
    STA FC_Gamepad_Buf,X

.Gamepad_Release
    LDY #$07
    LDA #$00
    STA FC_Gamepad_Once_Up,X

    LDA #$01
    STA FC_Gamepad_Status

.Gamepad_Release_Check
    LDA FC_Gamepad_Keep,X
    AND FC_Gamepad_Status
    BNE .Gamepad_Release_Continue
    
    LDA FC_Gamepad_Keep_Last,X
    AND FC_Gamepad_Status
    BEQ .Gamepad_Release_Continue
    
    LDA FC_Gamepad_Once_Up,X
    ORA FC_Gamepad_Status
    STA FC_Gamepad_Once_Up,X
.Gamepad_Release_Continue
    ASL FC_Gamepad_Status
    DEY
    BPL .Gamepad_Release_Check

.Get_Gamepad_State_Continue
    LDA FC_Gamepad_Keep,X
    STA FC_Gamepad_Keep_Last,X
    
    DEX
    BPL .Get_Gamepad_State
    
    ;按键连发处理
    JSR FC_Gamepad_Burst_Process
    
    RTS
.Gamepad_Scan;按键扫描
    LDY #$01
    STY JOY1        ;$4016
    DEY
    STY JOY1        ;$4016
    LDY #$08
.Scan_Value;扫描键值
    LDA JOY1,X      ;$4016
    STA FC_Gamepad_Status,X
    LSR A
    ORA FC_Gamepad_Status,X
    LSR A
    ROL FC_Gamepad_Keep,X
    DEY
    BNE .Scan_Value
    RTS

;======================================================================
;按键连发处理
FC_Gamepad_Burst_Process
    LDX #FC_GAMEPAD_COUNT - 1
    
.Get_Gamepad_State
    JSR .Check_Keep_Value
    
    LDA FC_Gamepad_Burst_Delay,X
    CMP #FC_GAMEPAD_BURST_TIME + FC_GAMEPAD_BURST_INTERVAL
    BCC .Continue 
    LDA FC_Gamepad_Keep,X
    STA FC_Gamepad_Once_Down,X
    LDA #FC_GAMEPAD_BURST_TIME
    STA FC_Gamepad_Burst_Delay,X

.Continue 
    DEX
    BPL .Get_Gamepad_State
    RTS
    
.Check_Keep_Value
    LDA FC_Gamepad_Keep,X
    BEQ .Check_Keep_Value_Clear
    INC FC_Gamepad_Burst_Delay,X
    RTS

.Check_Keep_Value_Clear
    LDA #$00
    STA FC_Gamepad_Burst_Delay,X
    RTS
    