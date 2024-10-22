;==================================================
;Mapper号
;MAPPER_NUMBER               =   75
;==================================================
;PRG切页
MAPPER_PRG_8000         =   $8000
;7  bit  0
;---------
;.... PPPP
;     ||||
;     ++++-  在地址 $8000 选择 8 KB PRG ROM

MAPPER_PRG_A000         =   $A000
;7  bit  0
;---------
;.... PPPP
;     ||||
;     ++++-  在地址 $A000 选择 8 KB PRG ROM

MAPPER_PRG_C000         =   $C000
;7  bit  0
;---------
;.... PPPP
;     ||||
;     ++++-  在地址 $C000 选择 8 KB PRG ROM

;命名表操作
MAPPER_MIRRORING_CONTROL    =   $9000
;7  bit  0
;---------
;.... .BAM
;      |||
;      ||+- 镜像  (0: 垂直; 1: 水平)
;      |+-- 映射到 PPU $0000 的 4 KB CHR 高位
;      +--- 映射到 PPU $1000 的 4 KB CHR 高位

MAPPER_CHR_0000            =   $E000
;7  bit  0
;---------
;.... CCCC
;     ||||
;     ++++- 映射到 PPU $0000 的 4 KB CHR 低4位

MAPPER_CHR_1000            =   $F000
;7  bit  0
;---------
;.... CCCC
;     ||||
;     ++++- 映射到 PPU $1000 的 4 KB CHR 低4位

;==================================================
;宏常量
;==================================================

;==================================================
    .MACRO MACRO_MAPPER_INIT
Init_Mapper
;初始化图形块
 
    MACRO_MIRRORING_H
 
    LDA #$00
    MACRO_SWITCH_CHR_0000_A
 
    LDA #$01
    MACRO_SWITCH_CHR_1000_A
 
    .ENDM

;==================================================
;命名表镜像 操作
;--------------------------------------------------
    .MACRO MACRO_MIRRORING_H
    LDA FC_Mapper_Control
    ORA #%00000001
    STA MAPPER_MIRRORING_CONTROL
    .ENDM

;--------------------------------------------------
    .MACRO MACRO_MIRRORING_V
    LDA FC_Mapper_Control
    AND #%00000001 ^ $FF
    STA MAPPER_MIRRORING_CONTROL
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

;==================================================
;CHR 切页操作
;--------------------------------------------------
    .MACRO MACRO_SWITCH_CHR_0000_A
    STA MAPPER_CHR_0000
    PHA
    LDA FC_Mapper_Control
    AND #%00000010 ^ $FF
    STA FC_Mapper_Control
    PLA
    LSR
    LSR
    LSR
    AND #%00000010
    ORA FC_Mapper_Control
    STA FC_Mapper_Control
    STA MAPPER_MIRRORING_CONTROL
    .ENDM

;--------------------------------------------------
    .MACRO MACRO_SWITCH_CHR_1000_A
    STA MAPPER_CHR_1000
    PHA
    LDA FC_Mapper_Control
    AND #%00000100 ^ $FF
    STA FC_Mapper_Control
    PLA
    LSR
    LSR
    AND #%00000100
    ORA FC_Mapper_Control
    STA FC_Mapper_Control
    STA MAPPER_MIRRORING_CONTROL
    .ENDM
