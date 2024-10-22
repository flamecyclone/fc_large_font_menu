;==================================================
;Mapper号
MAPPER_NUMBER               =   19
;==================================================
;IRQ 触发扫描线转周期: 32768 - ((260 - 240 + 扫描线) * 341 / 3)
;IRQ 间隔扫描线转周期: 32768 - (间隔扫描线 * 341 / 3)
;==================================================
    .MACRO MACRO_GET_IRQ_FIRST_VALUE_L
        LDA #(32768 - ((20 + \1) * 341) / 3) & $FF
    .ENDM

    .MACRO MACRO_GET_IRQ_FIRST_VALUE_H
        LDA #(32768 - ((20 + \1) * 341) / 3) >> 8
    .ENDM

    .MACRO MACRO_GET_IRQ_INTERVAL_VALUE_L
        LDA #(32768 - (\1 * 341) / 3) & $FF
    .ENDM

    .MACRO MACRO_GET_IRQ_INTERVAL_VALUE_H
        LDA #(32768 - (\1 * 341) / 3) >> 8
    .ENDM

;==================================================
;Namcot163 (Mapper 19) 寄存器常量
MAPPER_CHR_0000         =   $8000
MAPPER_CHR_0400         =   $8800
MAPPER_CHR_0800         =   $9000
MAPPER_CHR_0C00         =   $9800
MAPPER_CHR_1000         =   $A000
MAPPER_CHR_1400         =   $A800
MAPPER_CHR_1800         =   $B000
MAPPER_CHR_1C00         =   $B800
MAPPER_NT_2000          =   $C000
MAPPER_NT_2400          =   $C800
MAPPER_NT_2800          =   $D000
MAPPER_NT_2C00          =   $D800
MAPPER_PRG_8000         =   $E000
MAPPER_PRG_A000         =   $E800
MAPPER_PRG_C000         =   $F000
MAPPER_EX_RAM_PROTECT   =   $F800
MAPPER_IRQ_COUNT_L      =   $5000
MAPPER_IRQ_COUNT_H      =   $5800
MAPPER_AUDIO_ADDR_PORT  =   $F800
MAPPER_AUDIO_DATA_PORT  =   $4800

;==================================================
;宏常量
;==================================================

;==================================================
    .MACRO MACRO_MAPPER_INIT
Init_Mapper
;初始化图形块
    LDA #$00
    STA MAPPER_CHR_0000
    LDA #$01
    STA MAPPER_CHR_0400
    LDA #$02
    STA MAPPER_CHR_0800
    LDA #$03
    STA MAPPER_CHR_0C00
    LDA #$04
    STA MAPPER_CHR_1000
    LDA #$05
    STA MAPPER_CHR_1400
    LDA #$06
    STA MAPPER_CHR_1800
    LDA #$07
    STA MAPPER_CHR_1C00

    ;C000 bank块
    LDA #$3E
    STA MAPPER_PRG_C000

    ;禁用IRQ
    LDA MAPPER_IRQ_COUNT_H
    AND #$7F
    STA MAPPER_IRQ_COUNT_H

    ;命名表
    MACRO_MIRRORING_H

    ;PRG RAM
    MACRO_SRAM_ENABLE
    .ENDM

;==================================================
;音频操作
;--------------------------------------------------
    .MACRO MACRO_MAPPER_SOUND_CLEAR
MAPPER_Sound_Clear
    LDA #$80
    STA MAPPER_AUDIO_ADDR_PORT
    LDX #$7F
    LDA #$00
MAPPER_Sound_Clear_Write
    STA MAPPER_AUDIO_DATA_PORT
    DEX
    BPL MAPPER_Sound_Clear_Write
MAPPER_Sound_Clear_End
    .ENDM

;==================================================
;命名表镜像 操作
;--------------------------------------------------
    .MACRO MACRO_MIRRORING_H
    LDA #$E0
    STA MAPPER_NT_2000
    STA MAPPER_NT_2400
    
    LDA #$E1
    STA MAPPER_NT_2C00
    STA MAPPER_NT_2800
    .ENDM

;--------------------------------------------------
    .MACRO MACRO_MIRRORING_V
    LDA #$E0
    STA MAPPER_NT_2000
    STA MAPPER_NT_2800
    LDA #$E1
    STA MAPPER_NT_2400
    STA MAPPER_NT_2C00
    .ENDM

;==================================================
;SRAM 操作
;--------------------------------------------------
    .MACRO MACRO_SRAM_ENABLE
    LDA #$4C
    STA MAPPER_EX_RAM_PROTECT
    .ENDM
 
;--------------------------------------------------
    .MACRO MACRO_SRAM_DISABLE
    LDA #$00
    STA MAPPER_EX_RAM_PROTECT
    .ENDM
 
;--------------------------------------------------
    .MACRO MACRO_IRQ_LATCH_L
    STA MAPPER_IRQ_COUNT_L
    .ENDM
 
;--------------------------------------------------
    .MACRO MACRO_IRQ_LATCH_H
    ORA #$80
    STA MAPPER_IRQ_COUNT_H
    .ENDM
 
;--------------------------------------------------
    .MACRO MACRO_IRQ_ENABLE
    ORA #$80
    STA MAPPER_IRQ_COUNT_H
    .ENDM
 
;--------------------------------------------------
    .MACRO MACRO_IRQ_DISABLE
    LDA #$00
    STA MAPPER_IRQ_COUNT_L
    STA MAPPER_IRQ_COUNT_H
    .ENDM
 
;--------------------------------------------------
    .MACRO MACRO_IRQ_ACK
    LDA #$00
    STA MAPPER_IRQ_COUNT_L
    STA MAPPER_IRQ_COUNT_H
    .ENDM
 
;==================================================
;PRG 切页操作
;--------------------------------------------------
    .MACRO MACRO_SWITCH_PRG_8000_A
    STA MAPPER_PRG_8000
    .ENDM

    .MACRO MACRO_SWITCH_PRG_A000_A
    STA MAPPER_PRG_A000
    .ENDM
 
    .MACRO MACRO_SWITCH_PRG_C000_A
    STA MAPPER_PRG_C000
    .ENDM
 
    .MACRO MACRO_SWITCH_PRG_E000_A
    .ENDM

;==================================================
;CHR 切页操作
;--------------------------------------------------
    .MACRO MACRO_SWITCH_CHR_0000_A
    STA MAPPER_CHR_0000
    .ENDM

;--------------------------------------------------
    .MACRO MACRO_SWITCH_CHR_0400_A
    STA MAPPER_CHR_0400
    .ENDM

;--------------------------------------------------
    .MACRO MACRO_SWITCH_CHR_0800_A
    STA MAPPER_CHR_0800
    .ENDM

;--------------------------------------------------
    .MACRO MACRO_SWITCH_CHR_0C00_A
    STA MAPPER_CHR_0C00
    .ENDM

;--------------------------------------------------
    .MACRO MACRO_SWITCH_CHR_1000_A
    STA MAPPER_CHR_1000
    .ENDM

;--------------------------------------------------
    .MACRO MACRO_SWITCH_CHR_1400_A
    STA MAPPER_CHR_1400
    .ENDM
    
;--------------------------------------------------
    .MACRO MACRO_SWITCH_CHR_1800_A
    STA MAPPER_CHR_1800
    .ENDM
    
;--------------------------------------------------
    .MACRO MACRO_SWITCH_CHR_1C00_A
    STA MAPPER_CHR_1C00
    .ENDM
