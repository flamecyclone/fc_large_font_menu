;======================================================================
;节目选择
FC_Item_Select
    LDA FC_NMI_Task_Flag
    AND #FC_NMI_TASK_PAGING | FC_NMI_TASK_ATTR
    BNE .End
    LDA FC_Gamepad_Once_Down
    BEQ .End
    
    JSR FC_Page_Get_Row_Column_Index

.Column_Pre
    LDA FC_Gamepad_Once_Down
    AND #JOY_KEY_LEFT
    BEQ .Column_Next
    JSR FC_Page_Column_Pre
.Column_Next
    LDA FC_Gamepad_Once_Down
    AND #JOY_KEY_RIGHT
    BEQ .Row_Pre
    JSR FC_Page_Column_Next
.Row_Pre
    LDA FC_Gamepad_Once_Down
    CMP #JOY_KEY_UP
    BNE .Row_Next
    JSR FC_Page_Row_Pre
.Row_Next
    LDA FC_Gamepad_Once_Down
    CMP #JOY_KEY_DOWN
    BNE .Page_Pre
    JSR FC_Page_Row_Next
.Page_Pre
    LDA FC_Gamepad_Once_Down
    AND #JOY_KEY_B
    BEQ .Page_Next
    JSR FC_Page_Pre
.Page_Next
    LDA FC_Gamepad_Once_Down
    AND #JOY_KEY_A | JOY_KEY_SELECT
    BEQ .Item_Start
    JSR FC_Page_Next
.Item_Start
    LDA FC_Gamepad_Once_Down
    AND #JOY_KEY_START
    BEQ .End
    JMP Enter_Item
.End
    
    RTS

;======================================================================
;进入节目
Enter_Item
    
    ;清除音乐
    .IF MUSIC_PLAY_ENABLE > 0
        JSR Music_Clear_Process
    .ENDIF
    
    ;播放项进入音效
    .IF MUSIC_PLAY_ENABLE > 0
        JSR FC_Sound_For_Enter_Item
    .ENDIF
    
    .IF MUSIC_PLAY_ENABLE > 0
    
        ;等待延迟帧数
        LDA #ITEM_ENTER_TIME_DELAY
        JSR Wait_Frame_Delay
        
    .ENDIF
    
    ;关闭屏幕
    LDA #$00
    STA PPU_CTRL
    STA PPU_MASK
    STA APU_STATUS
    
    JSR Mapper_Sound_Clear
    JSR Mapper_Irq_Disable
    
    ;清除音乐
    .IF MUSIC_PLAY_ENABLE > 0
        JSR Music_Clear_Process
    .ENDIF
    
Enter_Item_Start

    ;暂存下节目序号
    LDA FC_Item_Index_L
    STA $01FE
    LDA FC_Item_Index_H
    STA $01FF
    
    ;清理内存
    LDX #$00
    LDA #$00
.Clear_RAM
    STA $00,X
    STA $0200,X
    STA $0300,X
    STA $0400,X
    STA $0500,X
    STA $0600,X
    STA $0700,X
    INX
    BNE .Clear_RAM
    
    LDX #$FD
    TXS
    
    ;清除栈
    TSX
.Clear_Stack
    STA $0100,X
    DEX
    BNE .Clear_Stack
    STA $0100,X
    
    ;外部切换节目程序
    .IFDEF Select_Game
        JMP Select_Game
    .ENDIF

    JMP [$FFFC]

.Program_On_Ram_End