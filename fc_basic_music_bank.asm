;==================================================
;音乐配置
    
;==================================================
;魂斗罗音源
;==================================================
    .IF 1 = FC_MUSIC_THEME
;--------------------------------------------------
    .BANK 0 & PRG_8K_BANK_MASK, "nsf 8000"
Music_Data_8000
    MACRO_INCBIN_NSF_DATA $0080,$2000
;--------------------------------------------------
    .BANK 1 & PRG_8K_BANK_MASK, "nsf A000"
Music_Data_A000
    MACRO_INCBIN_NSF_DATA $2080,$2000
;--------------------------------------------------
    .BANK FC_PRG_C000 & PRG_8K_BANK_MASK, "nsf C000"
Music_Data_C000
    MACRO_INCBIN_NSF_DATA $4080,$2000
    .ENDIF
    
;==================================================
;超级魂斗罗音源
;==================================================
    .IF 2 = FC_MUSIC_THEME
;--------------------------------------------------
    .BANK 0 & PRG_8K_BANK_MASK, "nsf 8000"
Music_Data_8000
    MACRO_INCBIN_NSF_DATA $0080,$2000
;--------------------------------------------------
    .BANK 1 & PRG_8K_BANK_MASK, "nsf A000"
Music_Data_A000
    MACRO_INCBIN_NSF_DATA $2080,$4000
;--------------------------------------------------
    .BANK FC_PRG_C000 & PRG_8K_BANK_MASK, "nsf C000"
Music_Data_C000
    MACRO_INCBIN_NSF_DATA $6080,$2000
;--------------------------------------------------
    .BANK FC_PRG_C000 & PRG_8K_BANK_MASK
    .ORG $DF85
    LSR
    JMP Switch_Music_Bank_A000_A_Pre
    .ENDIF

;==================================================
;洛克人3音源
;==================================================
    .IF 3 = FC_MUSIC_THEME
;--------------------------------------------------
    .BANK 0 & PRG_8K_BANK_MASK, "nsf 8000"
Music_Data_8000
    MACRO_INCBIN_NSF_DATA $0080,$2000
;--------------------------------------------------
    .BANK 1 & PRG_8K_BANK_MASK, "nsf A000"
Music_Data_A000
    MACRO_INCBIN_NSF_DATA $2080,$4000
;--------------------------------------------------
    .BANK FC_PRG_C000 & PRG_8K_BANK_MASK, "nsf C000"
Music_Data_C000
    MACRO_INCBIN_NSF_DATA $6080,$2000
;--------------------------------------------------
    .BANK 0 & PRG_8K_BANK_MASK
    .ORG $8053
    JSR Switch_Music_Bank_A000_A_Pre
    .ORG $8060
    JSR Switch_Music_Bank_A000_A_Pre
    .ENDIF
