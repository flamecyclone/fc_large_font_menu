;==================================================
;Mapper号
;MAPPER_NUMBER           =   10
;==================================================
;PRG切页
MAPPER_PRG_8000         =   $A000
;7  bit  0
;---- ----
;xxxx PPPP
;     ||||
;     ++++- 为CPU地址 $8000-$BFFF 选择 16 KB PRG ROM 库

;CHR 切页
MAPPER_CHR_FD_0000      =   $B000
;7  bit  0
;---- ----
;xxxC CCCC
;   | ||||
;   +-++++- 选择 4 KB CHR ROM 组用于 PPU $0000-$0FFF，当锁存器 0 = $FD 时使用
MAPPER_CHR_FE_0000      =   $C000
;7  bit  0
;---- ----
;xxxC CCCC
;   | ||||
;   +-++++- 选择 4 KB CHR ROM 组用于 PPU $0000-$0FFF，当锁存器 0 = $FE 时使用
MAPPER_CHR_FD_1000      =   $D000
;7  bit  0
;---- ----
;xxxC CCCC
;   | ||||
;   +-++++- 选择 4 KB CHR ROM 组用于 PPU $1000-$1FFF，当锁存器 0 = $FD 时使用
MAPPER_CHR_FE_1000      =   $E000
;7  bit  0
;---- ----
;xxxC CCCC
;   | ||||
;   +-++++- 选择 4 KB CHR ROM 组用于 PPU $1000-$1FFF，当锁存器 0 = $FE 时使用

MAPPER_MIRRORING        =   $F000
;7  bit  0
;---- ----
;xxxx xxxM
;        |
;        +- 选择命名表镜像 (0: 垂直; 1: 水平)

;==================================================
;宏常量
;==================================================

;==================================================
    .MACRO MACRO_MAPPER_INIT
Init_Mapper
;初始化图形块
 
    LDA #$00
    STA MAPPER_CHR_FD_0000
    LDA #$00
    STA MAPPER_CHR_FE_0000
    LDA #$01
    STA MAPPER_CHR_FD_1000
    LDA #$01
    STA MAPPER_CHR_FE_1000
 
    LDA #$01
    STA MAPPER_MIRRORING
 
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
;PRG 切页操作
;--------------------------------------------------
    .MACRO MACRO_SWITCH_PRG_8000_A
    STA MAPPER_PRG_8000
    .ENDM
    
;==================================================
;CHR 切页操作
;--------------------------------------------------
    .MACRO MACRO_SWITCH_CHR_0000_A
    STA MAPPER_CHR_FD_0000
    .ENDM

;--------------------------------------------------
    .MACRO MACRO_SWITCH_CHR_1000_A
    STA MAPPER_CHR_FD_1000
    .ENDM
