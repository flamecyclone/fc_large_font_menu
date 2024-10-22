;==================================================
;Mapper号
;MAPPER_NUMBER           = 69
;==================================================
;IRQ 触发扫描线转周期: ((260 - 241 + 扫描线) * 341 / 3)
;IRQ 间隔扫描线转周期: (间隔扫描线 * 341 / 3)
;==================================================
    .MACRO MACRO_GET_IRQ_FIRST_VALUE_L
        LDA #(((20 + \1) * 341) / 3) & $FF
    .ENDM

    .MACRO MACRO_GET_IRQ_FIRST_VALUE_H
        LDA #(((20 + \1) * 341) / 3) >> 8
    .ENDM

    .MACRO MACRO_GET_IRQ_INTERVAL_VALUE_L
        LDA #((\1 * 341) / 3) & $FF
    .ENDM

    .MACRO MACRO_GET_IRQ_INTERVAL_VALUE_H
        LDA #((\1 * 341) / 3) >> 8
    .ENDM

;==================================================
;Sunsoft 5B 寄存器常量
MAPPER_CTRL             =   $8000
MAPPER_DATA             =   $A000

MAPPER_CHR_0000         =   $00
MAPPER_CHR_0400         =   $01
MAPPER_CHR_0800         =   $02
MAPPER_CHR_0C00         =   $03
MAPPER_CHR_1000         =   $04
MAPPER_CHR_1400         =   $05
MAPPER_CHR_1800         =   $06
MAPPER_CHR_1C00         =   $07
MAPPER_PRG_6000         =   $08
MAPPER_PRG_8000         =   $09
MAPPER_PRG_A000         =   $0A
MAPPER_PRG_C000         =   $0B
MAPPER_MIRRORING        =   $0C
MAPPER_IRQ_CTRL         =   $0D
MAPPER_IRQ_COUNTER_L    =   $0E
MAPPER_IRQ_COUNTER_H    =   $0F

MAPPER_AUDIO_SELECT         =   $C000
MAPPER_AUDIO_WRITE          =   $E000

;==================================================
;初始化操作
;--------------------------------------------------
    .MACRO MACRO_MAPPER_INIT
Init_Mapper
    ;禁用IRQ
    LDA #MAPPER_IRQ_CTRL
    STA MAPPER_CTRL
    LDA #$00
    STA MAPPER_DATA

    ;水平镜像
    LDA #MAPPER_MIRRORING
    STA MAPPER_CTRL
    LDA #$01
    STA MAPPER_DATA

    ;初始化图形bank
    LDA #MAPPER_CHR_0000
    STA MAPPER_CTRL
    LDA #$00
    STA MAPPER_DATA

    LDA #MAPPER_CHR_0400
    STA MAPPER_CTRL
    LDA #$01
    STA MAPPER_DATA

    LDA #MAPPER_CHR_0800
    STA MAPPER_CTRL
    LDA #$02
    STA MAPPER_DATA

    LDA #MAPPER_CHR_0C00
    STA MAPPER_CTRL
    LDA #$03
    STA MAPPER_DATA

    LDA #MAPPER_CHR_1000
    STA MAPPER_CTRL
    LDA #$04
    STA MAPPER_DATA

    LDA #MAPPER_CHR_1400
    STA MAPPER_CTRL
    LDA #$05
    STA MAPPER_DATA

    LDA #MAPPER_CHR_1800
    STA MAPPER_CTRL
    LDA #$06
    STA MAPPER_DATA

    LDA #MAPPER_CHR_1C00
    STA MAPPER_CTRL
    LDA #$07
    STA MAPPER_DATA

    ;启用SRAM
    LDA #MAPPER_PRG_6000
    STA MAPPER_CTRL
    LDA #$C0
    STA MAPPER_DATA
    .ENDM

;==================================================
;音频操作
;--------------------------------------------------
    .MACRO MACRO_MAPPER_SOUND_CLEAR
    LDA #$00
    LDX #$00
MAPPER_Sound_Clear
    STX MAPPER_AUDIO_SELECT
    STA MAPPER_AUDIO_WRITE
    INX
    CPX #$10
    BCC MAPPER_Sound_Clear

    .ENDM
 
;==================================================
;命名表镜像 操作
;--------------------------------------------------
    .MACRO MACRO_MIRRORING_H
    LDA #MAPPER_MIRRORING
    STA MAPPER_CTRL
    LDA #$01
    STA MAPPER_DATA
    .ENDM

;--------------------------------------------------
    .MACRO MACRO_MIRRORING_V
    LDA #MAPPER_MIRRORING
    STA MAPPER_CTRL
    LDA #$00
    STA MAPPER_DATA
    .ENDM

;==================================================
;SRAM 操作
;--------------------------------------------------
    .MACRO MACRO_SRAM_ENABLE
    LDA #MAPPER_PRG_6000
    STA MAPPER_CTRL
    LDA #$C0
    STA MAPPER_DATA
    .ENDM
 
;--------------------------------------------------
    .MACRO MACRO_SRAM_DISABLE
    LDA #MAPPER_PRG_6000
    STA MAPPER_CTRL
    LDA #$40
    STA MAPPER_DATA
    .ENDM
 
;--------------------------------------------------
    .MACRO MACRO_IRQ_LATCH_L
    PHA
    LDA #MAPPER_IRQ_COUNTER_L
    STA MAPPER_CTRL
    PLA
    STA MAPPER_DATA
    .ENDM
 
;--------------------------------------------------
    .MACRO MACRO_IRQ_LATCH_H
    PHA
    LDA #MAPPER_IRQ_COUNTER_H
    STA MAPPER_CTRL
    PLA
    STA MAPPER_DATA
    .ENDM
 
;--------------------------------------------------
    .MACRO MACRO_IRQ_ENABLE 
    LDA #MAPPER_IRQ_CTRL
    STA MAPPER_CTRL
    LDA #$81
    STA MAPPER_DATA
    .ENDM
 
;--------------------------------------------------
    .MACRO MACRO_IRQ_DISABLE 
    LDA #MAPPER_IRQ_CTRL
    STA MAPPER_CTRL
    LDA #$00
    STA MAPPER_DATA
    .ENDM

;--------------------------------------------------
    .MACRO MACRO_IRQ_ACK
    LDA #MAPPER_IRQ_CTRL
    STA MAPPER_CTRL
    LDA #$00
    STA MAPPER_DATA
    .ENDM
 
;==================================================
;PRG 切页操作
;--------------------------------------------------
    .MACRO MACRO_SWITCH_PRG_8000_A
    PHA
    LDA #MAPPER_PRG_8000
    STA MAPPER_CTRL
    PLA
    STA MAPPER_DATA
    .ENDM

;--------------------------------------------------
    .MACRO MACRO_SWITCH_PRG_A000_A
    PHA
    LDA #MAPPER_PRG_A000
    STA MAPPER_CTRL
    PLA
    STA MAPPER_DATA
    .ENDM
 
;--------------------------------------------------
    .MACRO MACRO_SWITCH_PRG_C000_A
    PHA
    LDA #MAPPER_PRG_C000
    STA MAPPER_CTRL
    PLA
    STA MAPPER_DATA
    .ENDM

;--------------------------------------------------
    .MACRO MACRO_SWITCH_PRG_E000_A
    .ENDM

;==================================================
;CHR 切页操作
;--------------------------------------------------
    .MACRO MACRO_SWITCH_CHR_0000_A
    PHA
    LDA #MAPPER_CHR_0000
    STA MAPPER_CTRL
    PLA
    STA MAPPER_DATA
    .ENDM

;--------------------------------------------------
    .MACRO MACRO_SWITCH_CHR_0400_A
    PHA
    LDA #MAPPER_CHR_0400
    STA MAPPER_CTRL
    PLA
    STA MAPPER_DATA
    .ENDM

;--------------------------------------------------
    .MACRO MACRO_SWITCH_CHR_0800_A
    PHA
    LDA #MAPPER_CHR_0800
    STA MAPPER_CTRL
    PLA
    STA MAPPER_DATA
    .ENDM

;--------------------------------------------------
    .MACRO MACRO_SWITCH_CHR_0C00_A
    PHA
    LDA #MAPPER_CHR_0C00
    STA MAPPER_CTRL
    PLA
    STA MAPPER_DATA
    .ENDM

;--------------------------------------------------
    .MACRO MACRO_SWITCH_CHR_1000_A
    PHA
    LDA #MAPPER_CHR_1000
    STA MAPPER_CTRL
    PLA
    STA MAPPER_DATA
    .ENDM

;--------------------------------------------------
    .MACRO MACRO_SWITCH_CHR_1400_A
    PHA
    LDA #MAPPER_CHR_1400
    STA MAPPER_CTRL
    PLA
    STA MAPPER_DATA
    .ENDM
    
;--------------------------------------------------
    .MACRO MACRO_SWITCH_CHR_1800_A
    PHA
    LDA #MAPPER_CHR_1800
    STA MAPPER_CTRL
    PLA
    STA MAPPER_DATA
    .ENDM
    
;--------------------------------------------------
    .MACRO MACRO_SWITCH_CHR_1C00_A
    PHA
    LDA #MAPPER_CHR_1C00
    STA MAPPER_CTRL
    PLA
    STA MAPPER_DATA
    .ENDM