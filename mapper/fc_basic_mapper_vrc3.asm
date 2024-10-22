;==================================================
;Mapper号
;MAPPER_NUMBER               =   73
;==================================================
;IRQ 触发扫描线转周期: 65536 - ((260 - 240 + 扫描线) * 341 / 3)
;IRQ 间隔扫描线转周期: 65536 - (间隔扫描线 * 341 / 3)
;==================================================
    .MACRO MACRO_GET_IRQ_FIRST_VALUE_L
        LDA #(65536 - ((20 + \1) * 341) / 3) & $FF
    .ENDM

    .MACRO MACRO_GET_IRQ_FIRST_VALUE_H
        LDA #(65536 - ((20 + \1) * 341) / 3) >> 8
    .ENDM

    .MACRO MACRO_GET_IRQ_INTERVAL_VALUE_L
        LDA #(65536 - (\1 * 341) / 3) & $FF
    .ENDM

    .MACRO MACRO_GET_IRQ_INTERVAL_VALUE_H
        LDA #(65536 - (\1 * 341) / 3) >> 8
    .ENDM

;==================================================
;PRG切页
MAPPER_PRG_8000         =   $F000

;IRQ操作
MAPPER_IRQ_LATCH_LL     =   $8000
MAPPER_IRQ_LATCH_LH     =   $9000
MAPPER_IRQ_LATCH_HL     =   $A000
MAPPER_IRQ_LATCH_HH     =   $B000
MAPPER_IRQ_CONTROL      =   $C000
MAPPER_IRQ_ACKNOWLEDGE  =   $D000

;==================================================
    .MACRO MACRO_MAPPER_INIT
Init_Mapper
;初始化图形块
 
    ;禁用IRQ
    LDA #$00
    STA MAPPER_IRQ_LATCH_LL
    STA MAPPER_IRQ_LATCH_LH
    STA MAPPER_IRQ_LATCH_HL
    STA MAPPER_IRQ_LATCH_HH
    STA MAPPER_IRQ_CONTROL
 
    .ENDM

;==================================================
;PRG 切页操作
;--------------------------------------------------
    .MACRO MACRO_SWITCH_PRG_8000_A
    LSR A
    STA MAPPER_PRG_8000
    .ENDM

;--------------------------------------------------
    .MACRO MACRO_IRQ_LATCH_L
    STA MAPPER_IRQ_LATCH_LL
    LSR
    LSR
    LSR
    LSR
    STA MAPPER_IRQ_LATCH_LH
    .ENDM
 
;--------------------------------------------------
    .MACRO MACRO_IRQ_LATCH_H
    STA MAPPER_IRQ_LATCH_HL
    LSR
    LSR
    LSR
    LSR
    STA MAPPER_IRQ_LATCH_HH
    .ENDM
 
;==================================================
;IRQ启用
    .MACRO MACRO_IRQ_ENABLE 
    LDA #$03
    STA MAPPER_IRQ_CONTROL
    .ENDM
 
;==================================================
;IRQ禁用
    .MACRO MACRO_IRQ_DISABLE 
    LDA #$00
    STA MAPPER_IRQ_CONTROL
    .ENDM
 
;==================================================
;IRQ确认
    .MACRO MACRO_IRQ_ACK
    LDA MAPPER_IRQ_CONTROL
    STA MAPPER_IRQ_ACKNOWLEDGE
    .ENDM
