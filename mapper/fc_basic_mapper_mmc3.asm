;==================================================
;Mapper号
;MAPPER_NUMBER               = 4
;==================================================
    .MACRO MACRO_GET_IRQ_FIRST_VALUE_L
        LDA #\1 + 1
    .ENDM

    .MACRO MACRO_GET_IRQ_INTERVAL_VALUE_L
        LDA #\1
    .ENDM

;==================================================
MAPPER_CHR_0000             =   $00
MAPPER_CHR_0800             =   $01
MAPPER_CHR_1000             =   $02
MAPPER_CHR_1400             =   $03
MAPPER_CHR_1800             =   $04
MAPPER_CHR_1C00             =   $05
MAPPER_PRG_8000             =   $06
MAPPER_PRG_A000             =   $07

;MMC3 (Mapper 4) 寄存器常量
MAPPER_CTRL                 =   $8000
MAPPER_DATA                 =   $8001
MAPPER_MIRRORING            =   $A000
MAPPER_PRG_RAM_PROTECT      =   $A001
MAPPER_IRQ_LATCH            =   $C000
MAPPER_IRQ_RELOAD           =   $C001
MAPPER_IRQ_DISABLE          =   $E000
MAPPER_IRQ_ENABLE           =   $E001

;==================================================
;初始化操作
;--------------------------------------------------
    .MACRO MACRO_MAPPER_INIT
    ;禁用IRQ
    STA MAPPER_IRQ_DISABLE
 
    ;水平镜像
    LDA #$01
    STA MAPPER_MIRRORING
 
    ;初始化图形bank
    LDX #$05
.Init_Chr_Bank
    STX MAPPER_CTRL
    LDA .ChrBankData,X
    STA MAPPER_DATA
    DEX
    BPL .Init_Chr_Bank
    JMP .Init_Chr_Bank_End
.ChrBankData
    .DB $00,$02,$04,$05,$06,$07
.Init_Chr_Bank_End

    ;启用SRAM
    LDA #$80
    STA MAPPER_PRG_RAM_PROTECT
    .ENDM
 
;==================================================
;音频操作
;--------------------------------------------------
    .MACRO MACRO_MAPPER_SOUND_CLEAR
    .ENDM
 
;==================================================
;命名表镜像 操作
;--------------------------------------------------
    .MACRO MACRO_MIRRORING_H
    LDA #$01
    STA MAPPER_MIRRORING
    .ENDM

;--------------------------------------------------
    .MACRO MACRO_MIRRORING_V
    LDA #$00
    STA MAPPER_MIRRORING
    .ENDM

;==================================================
;SRAM 操作
;--------------------------------------------------
    .MACRO MACRO_SRAM_ENABLE
    LDA #$80
    STA MAPPER_PRG_RAM_PROTECT
    .ENDM
 
;--------------------------------------------------
    .MACRO MACRO_SRAM_DISABLE
    LDA #$00
    STA MAPPER_PRG_RAM_PROTECT
    .ENDM
 
;--------------------------------------------------
    .MACRO MACRO_IRQ_LATCH_L
    STA MAPPER_IRQ_LATCH
    .ENDM
 
;--------------------------------------------------
    .MACRO MACRO_IRQ_RELOAD_L
    STA MAPPER_IRQ_RELOAD
    .ENDM
 
;--------------------------------------------------
    .MACRO MACRO_IRQ_ENABLE
    STA MAPPER_IRQ_ENABLE
    .ENDM
 
;--------------------------------------------------
    .MACRO MACRO_IRQ_DISABLE
    STA MAPPER_IRQ_DISABLE
    .ENDM
 
;--------------------------------------------------
    .MACRO MACRO_IRQ_ACK
    STA MAPPER_IRQ_DISABLE
    .ENDM
 
;==================================================
;PRG 切页操作
;--------------------------------------------------
    .MACRO MACRO_SWITCH_PRG_8000_A
    PHA
    LDA #$06
    STA MAPPER_CTRL
    PLA
    STA MAPPER_DATA
    .ENDM

;--------------------------------------------------
    .MACRO MACRO_SWITCH_PRG_A000_A
    PHA
    LDA #$07
    STA MAPPER_CTRL
    PLA
    STA MAPPER_DATA
    .ENDM
 
;--------------------------------------------------
    .MACRO MACRO_SWITCH_PRG_C000_A
    .ENDM

;--------------------------------------------------
    .MACRO MACRO_SWITCH_PRG_E000_A
    .ENDM

;==================================================
;CHR 切页操作
;--------------------------------------------------
    .MACRO MACRO_SWITCH_CHR_0000_A
    PHA
    LDA #$00
    STA MAPPER_CTRL
    PLA
    STA MAPPER_DATA
    .ENDM

;--------------------------------------------------
    .MACRO MACRO_SWITCH_CHR_0800_A
    PHA
    LDA #$01
    STA MAPPER_CTRL
    PLA
    STA MAPPER_DATA
    .ENDM

;--------------------------------------------------
    .MACRO MACRO_SWITCH_CHR_1000_A
    PHA
    LDA #$02
    STA MAPPER_CTRL
    PLA
    STA MAPPER_DATA
    .ENDM

;--------------------------------------------------
    .MACRO MACRO_SWITCH_CHR_1400_A
    PHA
    LDA #$03
    STA MAPPER_CTRL
    PLA
    STA MAPPER_DATA
    .ENDM
    
;--------------------------------------------------
    .MACRO MACRO_SWITCH_CHR_1800_A
    PHA
    LDA #$04
    STA MAPPER_CTRL
    PLA
    STA MAPPER_DATA
    .ENDM
    
;--------------------------------------------------
    .MACRO MACRO_SWITCH_CHR_1C00_A
    PHA
    LDA #$05
    STA MAPPER_CTRL
    PLA
    STA MAPPER_DATA
    .ENDM