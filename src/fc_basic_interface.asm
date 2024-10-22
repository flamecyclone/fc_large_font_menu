;======================================================================
Switch_Music_Bank_8000_A_Pre
    PHA
    CLC
    ADC FC_Music_Prg_8000
    .IFDEF MACRO_SWITCH_PRG_8000_A
        MACRO_SWITCH_PRG_8000_A
    .ENDIF
    PLA
    RTS
;======================================================================
Switch_Music_Bank_A000_A_Pre
    PHP
    SEI
    PHA
    CLC
    ADC FC_Music_Prg_8000
    .IFDEF MACRO_SWITCH_PRG_A000_A
        MACRO_SWITCH_PRG_A000_A
    .ENDIF
    PLA
    PLP
    RTS
;======================================================================
Switch_Music_Bank_C000_A_Pre
    PHA
    CLC
    ADC FC_Music_Prg_8000
    .IFDEF MACRO_SWITCH_PRG_C000_A
        MACRO_SWITCH_PRG_C000_A
    .ENDIF
    PLA
    RTS
    
;======================================================================
Switch_Music_Bank_E000_A_Pre
    PHA
    CLC
    ADC FC_Music_Prg_8000
    .IFDEF MACRO_SWITCH_PRG_E000_A
        MACRO_SWITCH_PRG_E000_A
    .ENDIF
    PLA
    RTS
    
;==================================================
DMC_Offset_Set
    CLC
    ADC FC_Music_DMC_Offset
    STA $4012
    RTS

;======================================================================
;音乐切页接口工具宏
    .MACRO AUDIO_INTERFACE
        .ORG \1
        JMP \2
    .ENDM
;==================================================
;音乐切页接口
Sound_Bank_Interface
    AUDIO_INTERFACE $FFE0, Switch_Music_Bank_8000_A_Pre
    AUDIO_INTERFACE $FFE4, Switch_Music_Bank_A000_A_Pre
    AUDIO_INTERFACE $FFE8, Switch_Music_Bank_C000_A_Pre
    AUDIO_INTERFACE $FFEC, Switch_Music_Bank_E000_A_Pre

;==================================================
;DMC偏移调整
    .ORG $FFF0
    JMP DMC_Offset_Set
