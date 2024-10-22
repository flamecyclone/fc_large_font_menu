;==================================================
;Mapper号
;MAPPER_NUMBER               = 22
;==================================================
    .MACRO MACRO_GET_IRQ_FIRST_VALUE_L
        LDA #\1 + 20
    .ENDM

    .MACRO MACRO_GET_IRQ_INTERVAL_VALUE_L
        LDA #\1
    .ENDM

;==================================================

    .IF 21 = MAPPER_NUMBER

        .IF 0 = SUB_NUMBER ;VRC4a
VRC_VARIATIONS_0            =   $00
VRC_VARIATIONS_1            =   $02
VRC_VARIATIONS_2            =   $04
VRC_VARIATIONS_3            =   $06
        .ENDIF

        .IF 1 = SUB_NUMBER ;VRC4a
VRC_VARIATIONS_0            =   $00
VRC_VARIATIONS_1            =   $02
VRC_VARIATIONS_2            =   $04
VRC_VARIATIONS_3            =   $06
        .ENDIF

        .IF 2 = SUB_NUMBER ;VRC4c
VRC_VARIATIONS_0            =   $00
VRC_VARIATIONS_1            =   $40
VRC_VARIATIONS_2            =   $80
VRC_VARIATIONS_3            =   $C0
        .ENDIF

    .ENDIF

    .IF 22 = MAPPER_NUMBER ;VRC2a
    
VRC_VARIATIONS_0            =   $00
VRC_VARIATIONS_1            =   $02
VRC_VARIATIONS_2            =   $01
VRC_VARIATIONS_3            =   $03
    
    .ENDIF

    .IF 23 = MAPPER_NUMBER

        .IF 0 = SUB_NUMBER ;VRC4e
VRC_VARIATIONS_0            =   $00
VRC_VARIATIONS_1            =   $04
VRC_VARIATIONS_2            =   $08
VRC_VARIATIONS_3            =   $0C
        .ENDIF
        
        .IF 1 = SUB_NUMBER ;VRC4f
VRC_VARIATIONS_0            =   $00
VRC_VARIATIONS_1            =   $01
VRC_VARIATIONS_2            =   $02
VRC_VARIATIONS_3            =   $03
        .ENDIF

        .IF 2 = SUB_NUMBER ;VRC4e
VRC_VARIATIONS_0            =   $00
VRC_VARIATIONS_1            =   $04
VRC_VARIATIONS_2            =   $08
VRC_VARIATIONS_3            =   $0C
        .ENDIF

        .IF 3 = SUB_NUMBER ;VRC2b
VRC_VARIATIONS_0            =   $00
VRC_VARIATIONS_1            =   $01
VRC_VARIATIONS_2            =   $02
VRC_VARIATIONS_3            =   $03
        .ENDIF

    .ENDIF

    .IF 25 = MAPPER_NUMBER
    
        .IF 0 = SUB_NUMBER ;VRC4d
VRC_VARIATIONS_0            =   $00
VRC_VARIATIONS_1            =   $08
VRC_VARIATIONS_2            =   $04
VRC_VARIATIONS_3            =   $0C
        .ENDIF
        
        .IF 1 = SUB_NUMBER ;VRC4b
VRC_VARIATIONS_0            =   $00
VRC_VARIATIONS_1            =   $02
VRC_VARIATIONS_2            =   $01
VRC_VARIATIONS_3            =   $03
        .ENDIF

        .IF 2 = SUB_NUMBER ;VRC4d
VRC_VARIATIONS_0            =   $00
VRC_VARIATIONS_1            =   $08
VRC_VARIATIONS_2            =   $04
VRC_VARIATIONS_3            =   $0C
        .ENDIF

        .IF 3 = SUB_NUMBER ;VRC2c
VRC_VARIATIONS_0            =   $00
VRC_VARIATIONS_1            =   $02
VRC_VARIATIONS_2            =   $01
VRC_VARIATIONS_3            =   $03
        .ENDIF

    .ENDIF

;PRG切页
MAPPER_PRG_8000         =   $8000
MAPPER_PRG_A000         =   $A000

;==================================================
;CHR切页
;VRC2 只有 4 个高位的 CHR 选择。$B 003 位 4 被忽略。
;在 VRC2a（映射器 22）上，低位被忽略（右移值 1）。
MAPPER_CHR_0000_L       =   $B000 + VRC_VARIATIONS_0
MAPPER_CHR_0000_H       =   $B000 + VRC_VARIATIONS_1
MAPPER_CHR_0400_L       =   $B000 + VRC_VARIATIONS_2
MAPPER_CHR_0400_H       =   $B000 + VRC_VARIATIONS_3
MAPPER_CHR_0800_L       =   $C000 + VRC_VARIATIONS_0
MAPPER_CHR_0800_H       =   $C000 + VRC_VARIATIONS_1
MAPPER_CHR_0C00_L       =   $C000 + VRC_VARIATIONS_2
MAPPER_CHR_0C00_H       =   $C000 + VRC_VARIATIONS_3
MAPPER_CHR_1000_L       =   $D000 + VRC_VARIATIONS_0
MAPPER_CHR_1000_H       =   $D000 + VRC_VARIATIONS_1
MAPPER_CHR_1400_L       =   $D000 + VRC_VARIATIONS_2
MAPPER_CHR_1400_H       =   $D000 + VRC_VARIATIONS_3
MAPPER_CHR_1800_L       =   $E000 + VRC_VARIATIONS_0
MAPPER_CHR_1800_H       =   $E000 + VRC_VARIATIONS_1
MAPPER_CHR_1C00_L       =   $E000 + VRC_VARIATIONS_2
MAPPER_CHR_1C00_H       =   $E000 + VRC_VARIATIONS_3

;PRG RAM(仅VRC4支持)
MAPPER_PRG_RAM          =   $9002

;IRQ操作
MAPPER_IRQ_LATCH_L      =   $F000 + VRC_VARIATIONS_0
MAPPER_IRQ_LATCH_H      =   $F000 + VRC_VARIATIONS_1
;7  bit  0
;---------
;LLLL LLLL
;|||| ||||
;++++-++++- IRQ Latch (reload value)

MAPPER_IRQ_CONTROL      =   $F000 + VRC_VARIATIONS_2
;7  bit  0
;---------
;.... .MEA
;      |||
;      ||+- IRQ Enable after acknowledgement (see IRQ Acknowledge)
;      |+-- IRQ Enable (1 = enabled)
;      +--- IRQ Mode (1 = cycle mode, 0 = scanline mode)

MAPPER_IRQ_ACKNOWLEDGE         =   $F000 + VRC_VARIATIONS_3
;对此寄存器的任何写入都将确认待处理的 IRQ。
;此外，“A”控制位移动到“E”控制位，从而启用或禁用 IRQ。
;写入此寄存器不会影响 IRQ 计数器或预分频器的当前状态。

;命名表
MAPPER_MIRRORING_CONTROL    =   $9000
;7  bit  0
;---------
;.... ..MM
;       ||
;       ++- 镜像 (0: 垂直; 1: 水平; 2: 单屏, 低库; 3: 单屏, 高库)
;VRC2 仅支持垂直或水平镜像。位 1 将被忽略。
;VRC4 仅以 9000 美元的价格提供镜像控制。9002 美元用于选择 PRG 交换模式（见上文）。
;使用 VRC2 的游戏通常表现良好，只将 0 或 1 写入此寄存器，但 Wai Wai World 在一个实例中写入 $FF

;==================================================
;初始化操作
;--------------------------------------------------
    .MACRO MACRO_MAPPER_INIT
Init_Mapper
;初始化图形块
 
    LDA #$00
    STA MAPPER_CHR_0000_H
    STA MAPPER_CHR_0400_H
    STA MAPPER_CHR_0800_H
    STA MAPPER_CHR_0C00_H
    STA MAPPER_CHR_1000_H
    STA MAPPER_CHR_1400_H
    STA MAPPER_CHR_1800_H
    STA MAPPER_CHR_1C00_H
 
    .IF 22 = MAPPER_NUMBER
    LDA #$00
    STA MAPPER_CHR_0000_L
    LDA #$02
    STA MAPPER_CHR_0400_L
    LDA #$04
    STA MAPPER_CHR_0800_L
    LDA #$06
    STA MAPPER_CHR_0C00_L
    LDA #$08
    STA MAPPER_CHR_1000_L
    LDA #$0A
    STA MAPPER_CHR_1400_L
    LDA #$0C
    STA MAPPER_CHR_1800_L
    LDA #$0E
    STA MAPPER_CHR_1C00_L
 
    .ELSE
 
    LDA #$00
    STA MAPPER_CHR_0000_L
    LDA #$01
    STA MAPPER_CHR_0400_L
    LDA #$02
    STA MAPPER_CHR_0800_L
    LDA #$03
    STA MAPPER_CHR_0C00_L
    LDA #$04
    STA MAPPER_CHR_1000_L
    LDA #$05
    STA MAPPER_CHR_1400_L
    LDA #$06
    STA MAPPER_CHR_1800_L
    LDA #$07
    STA MAPPER_CHR_1C00_L
 
    .ENDIF
 
    ;禁用IRQ
    LDA #$00
    STA MAPPER_IRQ_LATCH_L
    STA MAPPER_IRQ_LATCH_H
    STA MAPPER_IRQ_CONTROL
 
    ;命名表
    LDA #$01
    STA MAPPER_MIRRORING_CONTROL
 
    ;SRAM
    MACRO_SRAM_ENABLE
 
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
    STA MAPPER_MIRRORING_CONTROL
    .ENDM

;--------------------------------------------------
    .MACRO MACRO_MIRRORING_V
    LDA #$00
    STA MAPPER_MIRRORING_CONTROL
    .ENDM

;==================================================
;SRAM 操作
;--------------------------------------------------
    .MACRO MACRO_SRAM_ENABLE
    
    .IF (21 = MAPPER_NUMBER) | (23 = MAPPER_NUMBER) | (25 = MAPPER_NUMBER)
        LDA #$01
        STA MAPPER_PRG_RAM
    .ENDIF
 
    .ENDM
 
;--------------------------------------------------
    .MACRO MACRO_SRAM_DISABLE
    
    .IF (21 = MAPPER_NUMBER) | (23 = MAPPER_NUMBER) | (25 = MAPPER_NUMBER)
        LDA #$00
        STA MAPPER_PRG_RAM
    .ENDIF
 
    .ENDM
 
;--------------------------------------------------
    .MACRO MACRO_IRQ_LATCH_L
    EOR #$FF
    CLC
    ADC #$01
    STA MAPPER_IRQ_LATCH_L
    LSR
    LSR
    LSR
    LSR
    STA MAPPER_IRQ_LATCH_H
    .ENDM
 
;--------------------------------------------------
    .MACRO MACRO_IRQ_ENABLE
    LDA #$02
    STA MAPPER_IRQ_CONTROL
    .ENDM
 
;--------------------------------------------------
    .MACRO MACRO_IRQ_DISABLE
    LDA #$00
    STA MAPPER_IRQ_CONTROL
    .ENDM
 
;--------------------------------------------------
    .MACRO MACRO_IRQ_ACK
    STA MAPPER_IRQ_ACKNOWLEDGE
    .ENDM
 
;==================================================
;PRG 切页操作
;--------------------------------------------------
    .MACRO MACRO_SWITCH_PRG_8000_A
    STA MAPPER_PRG_8000
    .ENDM

;--------------------------------------------------
    .MACRO MACRO_SWITCH_PRG_A000_A
    STA MAPPER_PRG_A000
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
    .IF 22 = MAPPER_NUMBER
        ASL
    .ENDIF
    STA MAPPER_CHR_0000_L
    LSR
    LSR
    LSR
    LSR
    STA MAPPER_CHR_0000_H
    .ENDM

;--------------------------------------------------
    .MACRO MACRO_SWITCH_CHR_0400_A
    .IF 22 = MAPPER_NUMBER
        ASL
    .ENDIF
    STA MAPPER_CHR_0400_L
    LSR
    LSR
    LSR
    LSR
    STA MAPPER_CHR_0400_H
    .ENDM

;--------------------------------------------------
    .MACRO MACRO_SWITCH_CHR_0800_A
    .IF 22 = MAPPER_NUMBER
        ASL
    .ENDIF
    STA MAPPER_CHR_0800_L
    LSR
    LSR
    LSR
    LSR
    STA MAPPER_CHR_0800_H
    .ENDM

;--------------------------------------------------
    .MACRO MACRO_SWITCH_CHR_0C00_A
    .IF 22 = MAPPER_NUMBER
        ASL
    .ENDIF
    STA MAPPER_CHR_0C00_L
    LSR
    LSR
    LSR
    LSR
    STA MAPPER_CHR_0C00_H
    .ENDM

;--------------------------------------------------
    .MACRO MACRO_SWITCH_CHR_1000_A
    .IF 22 = MAPPER_NUMBER
        ASL
    .ENDIF
    STA MAPPER_CHR_1000_L
    LSR
    LSR
    LSR
    LSR
    STA MAPPER_CHR_1000_H
    .ENDM

;--------------------------------------------------
    .MACRO MACRO_SWITCH_CHR_1400_A
    .IF 22 = MAPPER_NUMBER
        ASL
    .ENDIF
    STA MAPPER_CHR_1400_L
    LSR
    LSR
    LSR
    LSR
    STA MAPPER_CHR_1400_H
    .ENDM
    
;--------------------------------------------------
    .MACRO MACRO_SWITCH_CHR_1800_A
    .IF 22 = MAPPER_NUMBER
        ASL
    .ENDIF
    STA MAPPER_CHR_1800_L
    LSR
    LSR
    LSR
    LSR
    STA MAPPER_CHR_1800_H
    .ENDM
    
;--------------------------------------------------
    .MACRO MACRO_SWITCH_CHR_1C00_A
    .IF 22 = MAPPER_NUMBER
        ASL
    .ENDIF
    STA MAPPER_CHR_1C00_L
    LSR
    LSR
    LSR
    LSR
    STA MAPPER_CHR_1C00_H
    .ENDM