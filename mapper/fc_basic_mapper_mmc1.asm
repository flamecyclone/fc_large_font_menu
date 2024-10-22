;==================================================
;Mapper号
;MAPPER_NUMBER           =   1
;==================================================
MAPPER_CONTROL      =   $8000
;4bit0
;-----
;CPPMM
;|||||
;|||++- 镜像 (0: 单屏, 低库; 1: 单屏, 高库; 2: 垂直; 3: 水平)
;|++--- PRG ROM bank mode (0, 1: 切换 32 KB $8000, 忽略 bank号 的低位;
;|                         2: 第1个 bank 固定在 $8000 并且 切换$C000 的 16 KB bank;
;|                         3: 倒数第1个 bank 固定在 $C000 并且 切换$8000 的 16 KB bank)
;+----- CHR ROM bank mode (0: 一次切换 8 KB; 1: 切换两个独立的 4 KB bank)

;PRG切页
MAPPER_PRG_8000     =   $FFFF
;4bit0
;-----
;RPPPP
;|||||
;|++++- 选择 16 KB PRG ROM 组（在 32 KB 模式下忽略低位）
;+----- MMC1B 及更高版本：PRG RAM 芯片启用（0：启用；1：禁用；MMC1A 上忽略）
;       MMC1A：位 3 在 16K 模式下旁路固定组逻辑（0：受影响；1：旁路）

MAPPER_CHR_0000     =   $BFFF
;4bit0
;-----
;CCCCC
;|||||
;+++++- 在 PPU $0000 处选择 4 KB 或 8 KB CHR 存储体（在 8 KB 模式下忽略低位）

MAPPER_CHR_1000     =   $DFFF
;4bit0
;-----
;CCCCC
;|||||
;+++++- 选择 PPU $1000 的 4 KB CHR 存储体（在 8 KB 模式下被忽略）

;==================================================
;宏常量
;==================================================

;==================================================
    .MACRO MACRO_MAPPER_INIT
Init_Mapper
;初始化图形块

    LDA #$1F
    STA FC_Mapper_Control
    
    STA MAPPER_CONTROL
    LSR A
    STA MAPPER_CONTROL
    LSR A
    STA MAPPER_CONTROL
    LSR A
    STA MAPPER_CONTROL
    LSR A
    STA MAPPER_CONTROL
 
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
    AND #%00000011 ^ $FF
    ORA #%00000011
    STA FC_Mapper_Control
    STA MAPPER_CONTROL
    LSR A
    STA MAPPER_CONTROL
    LSR A
    STA MAPPER_CONTROL
    LSR A
    STA MAPPER_CONTROL
    LSR A
    STA MAPPER_CONTROL
    .ENDM

;--------------------------------------------------
    .MACRO MACRO_MIRRORING_V
    LDA FC_Mapper_Control
    AND #%00000011 ^ $FF
    ORA #%00000010
    STA FC_Mapper_Control
    STA MAPPER_CONTROL
    LSR A
    STA MAPPER_CONTROL
    LSR A
    STA MAPPER_CONTROL
    LSR A
    STA MAPPER_CONTROL
    LSR A
    STA MAPPER_CONTROL
    .ENDM

;==================================================
;PRG 切页操作
;--------------------------------------------------
    .MACRO MACRO_SWITCH_PRG_8000_A
    STA MAPPER_PRG_8000
    LSR A
    STA MAPPER_PRG_8000
    LSR A
    STA MAPPER_PRG_8000
    LSR A
    STA MAPPER_PRG_8000
    LSR A
    STA MAPPER_PRG_8000
    .ENDM

;==================================================
;CHR 切页操作
;--------------------------------------------------
    .MACRO MACRO_SWITCH_CHR_0000_A
    STA MAPPER_CHR_0000
    LSR A
    STA MAPPER_CHR_0000
    LSR A
    STA MAPPER_CHR_0000
    LSR A
    STA MAPPER_CHR_0000
    LSR A
    STA MAPPER_CHR_0000
    .ENDM
    
;--------------------------------------------------
    .MACRO MACRO_SWITCH_CHR_1000_A
    STA MAPPER_CHR_1000
    LSR A
    STA MAPPER_CHR_1000
    LSR A
    STA MAPPER_CHR_1000
    LSR A
    STA MAPPER_CHR_1000
    LSR A
    STA MAPPER_CHR_1000
    .ENDM