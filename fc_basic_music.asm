;======================================================================
    .IF FC_MUSIC_THEME > 0
NSF_Banking
    MACRO_INCBIN_NSF_DATA $70,$08
    .ENDIF
    
;----------------------------------------------------------------------
;显示曲目索引
Show_Track_Index
    CLC
    ADC #$01
    STA FC_Hex_Data_L
    JSR FC_HEX_To_Dec_16
    JSR FC_Convert_Dec_To_PPU_10_Up
    RTS

;----------------------------------------------------------------------
;显示曲目信息
Music_Info_Display
    LDX FC_PPU_Buf_Count
    
    LDA #FC_PPU_MODE_LINE
    STA FC_PPU_Buf_Addr,X
    INX
    LDA #>MUSIC_INFO_POS
    STA FC_PPU_Buf_Addr,X
    INX
    LDA #<MUSIC_INFO_POS
    ;LDA #<(MUSIC_INFO_POS & $E0) + (32 - 7)/2
    STA FC_PPU_Buf_Addr,X
    INX
    LDA #$05
    STA FC_PPU_Buf_Addr,X
    INX
    
    LDA #$00
    STA FC_Hex_Data_H
    LDA FC_Music_Index
    JSR Show_Track_Index
    
    LDA #'/'
    STA FC_PPU_Buf_Addr,X
    INX
    
    LDA #$00
    STA FC_Hex_Data_H
    LDA FC_Music_Index_Max
    JSR Show_Track_Index
    
    STX FC_PPU_Buf_Count
    RTS
    
;======================================================================
;音乐清理处理
Music_Clear_Process
    JSR Sound_Port_Clear
    
;清理零页上部分
    LDX #Use_Zero_Page_Begin - 1
    LDA #$00
.Write_Zero_Page_01
    STA $00,X
    DEX
    BNE .Write_Zero_Page_01
    STA $00,X

;清理零页下部分
    LDX #Use_Zero_Page_End + 1
.Write_Zero_Page_02
    STA $00,X
    INX
    BNE .Write_Zero_Page_02

;清理栈
    TSX
.Write_Stack
    STA $0100,X
    DEX
    BNE .Write_Stack
    STA $0100,X

;清理其他内存
    LDX #$00
    LDA #$00
.Write_Other
    ;STA $0300,X
    ;STA $0400,X
    ;STA $0500,X
    ;STA $0600,X
    ;STA $0700,X
    DEX
    BNE .Write_Other

    RTS
    
;======================================================================
;清除声音端口 $4000-4013
Sound_Port_Clear
    LDY #$14
    LDX #$00
    TXA
.Sound_Clear
    STA $4000,X
    INX
    DEY
    BNE .Sound_Clear
    RTS

;======================================================================
;音乐曲目初始化处理
Music_Init_Process
    
    .IF FC_MUSIC_THEME > 0
    
    ;备份 Prg Bank
    LDA FC_Prg_8000
    PHA
    LDA FC_Prg_A000
    PHA
    
    .IFDEF Music_Clear_Process
        JSR Music_Clear_Process
    .ENDIF
    
    LDA #$0F
    STA $4015
    
    LDA #BANK(Music_Data_8000)
    STA FC_Music_Prg_8000
    LDA #BANK(Music_Data_A000)
    STA FC_Music_Prg_A000
    LDA #BANK(Music_Data_C000)
    STA FC_Music_Prg_C000
    
    ;切换 音乐 Prg bank
    LDA FC_Music_Prg_8000
    JSR Mapper_Prg_8000_Banking
    LDA FC_Music_Prg_A000
    JSR Mapper_Prg_A000_Banking
    LDA FC_Music_Prg_C000
    JSR Mapper_Prg_C000_Banking

    ;初始化最大曲目索引
    .HEX A9;LDA
    MACRO_INCBIN_NSF_DATA $06,$01
    SEC
    SBC #$01
    STA FC_Music_Index_Max
    
    ;调用初始化选曲程序
    LDA FC_Music_Index
    .HEX 20
    MACRO_INCBIN_NSF_DATA $0A,$02
    
    .IF MUSIC_INFO_SHOW > 0
        JSR Music_Info_Display
    .ENDIF
    
    ;恢复 Prg Bank
    PLA
    JSR Mapper_Prg_A000_Banking
    PLA
    JSR Mapper_Prg_8000_Banking
    
    .ENDIF
    
    RTS

;======================================================================
;音乐曲目选择
Music_Track_Select
    
    .IF FC_MUSIC_THEME > 0
    
    ;备份 Prg Bank
    LDA FC_Prg_8000
    PHA
    LDA FC_Prg_A000
    PHA
    
    LDA #$0F
    STA $4015
    
    LDA #BANK(Music_Data_8000)
    STA FC_Music_Prg_8000
    LDA #BANK(Music_Data_A000)
    STA FC_Music_Prg_A000
    LDA #BANK(Music_Data_C000)
    STA FC_Music_Prg_C000
    
    ;切换 音乐 Prg bank
    LDA FC_Music_Prg_8000
    JSR Mapper_Prg_8000_Banking
    LDA FC_Music_Prg_A000
    JSR Mapper_Prg_A000_Banking
    LDA FC_Music_Prg_C000
    JSR Mapper_Prg_C000_Banking

    ;初始化最大曲目索引
    .HEX A9;LDA
    MACRO_INCBIN_NSF_DATA $06,$01
    SEC
    SBC #$01
    STA FC_Music_Index_Max
    
    ;调用初始化选曲程序
    LDA FC_Music_Index
    .HEX 20
    MACRO_INCBIN_NSF_DATA $0A,$02
    
    .IF MUSIC_INFO_SHOW > 0
        JSR Music_Info_Display
    .ENDIF
    
    ;恢复 Prg Bank
    PLA
    JSR Mapper_Prg_A000_Banking
    PLA
    JSR Mapper_Prg_8000_Banking
    
    .ENDIF
    
    RTS

;======================================================================
;音乐曲目初始化处理
Music_Play_Process
    
    .IF FC_MUSIC_THEME > 0
    
    ;备份 Prg Bank
    LDA FC_Prg_8000
    PHA
    LDA FC_Prg_A000
    PHA
    
    ;切换到音乐 Prg bank
    LDA FC_Music_Prg_8000
    JSR Mapper_Prg_8000_Banking
    LDA FC_Music_Prg_A000
    JSR Mapper_Prg_A000_Banking
    LDA FC_Music_Prg_C000
    JSR Mapper_Prg_C000_Banking

    ;调用播放程序
    .HEX 20
    MACRO_INCBIN_NSF_DATA $0C,$02
    
    ;恢复 Prg Bank
    PLA
    JSR Mapper_Prg_A000_Banking
    PLA
    JSR Mapper_Prg_8000_Banking
    
    .ENDIF
    
    RTS

;----------------------------------------------------------------------
;播放上一曲
Music_Play_Pre
    LDA FC_Music_Index
    BEQ .End
    DEC FC_Music_Index
    LDA FC_Music_Index
    JSR Music_Init_Process
.End
    RTS
;----------------------------------------------------------------------
;播放下一曲
Music_Play_Next
    LDA FC_Music_Index
    CMP FC_Music_Index_Max
    BCS .End
    INC FC_Music_Index
    LDA FC_Music_Index
    JSR Music_Init_Process
.End
    RTS

;----------------------------------------------------------------------
;播放上10曲
Music_Play_Pre_10
    LDA FC_Music_Index
    BEQ .End
    SEC
    SBC #10
    BCS .Pre_10
    LDA #$00
.Pre_10
    STA FC_Music_Index
    JSR Music_Init_Process
.End
    RTS
;----------------------------------------------------------------------
;播放下10曲
Music_Play_Next_10
    LDA FC_Music_Index
    CMP FC_Music_Index_Max
    BCS .End
    CLC
    ADC #10
    CMP FC_Music_Index_Max
    BCC .Next_10
    LDA FC_Music_Index_Max
.Next_10
    STA FC_Music_Index
    JSR Music_Init_Process
.End
    RTS

;======================================================================
;音乐曲目切换
Music_Select_Process

.Pre_Music;上一曲
    LDA FC_Gamepad_Once_Up
    AND #JOY_KEY_B
    BEQ .Next_Music
    ;JSR Music_Play_Pre
.Next_Music;下一曲
    LDA FC_Gamepad_Once_Up
    AND #JOY_KEY_A
    BEQ .Next_10_Music
    ;JSR Music_Play_Next
.Next_10_Music;上10曲
    LDA FC_Gamepad_Once_Up
    CMP #JOY_KEY_UP
    BNE .Pre_10_Music
    ;JSR Music_Play_Next_10
.Pre_10_Music;下10曲
    LDA FC_Gamepad_Once_Up
    CMP #JOY_KEY_DOWN
    BNE .Reset
    ;JSR Music_Play_Pre_10
.Reset;重播当前曲目
    ;LDA FC_Gamepad_Once_Up
    ;CMP #JOY_KEY_START
    ;BNE .End
    ;JMP [$FFFC]
.End
    RTS
