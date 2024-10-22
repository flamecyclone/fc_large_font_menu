;==================================================
;Mapper号
;MAPPER_NUMBER               =   85
;==================================================
    .MACRO MACRO_GET_IRQ_FIRST_VALUE_L
        LDA #\1 + 20
    .ENDM

    .MACRO MACRO_GET_IRQ_INTERVAL_VALUE_L
        LDA #\1
    .ENDM

;==================================================
;VRC7 寄存器常量
MAPPER_PRG_8000         =   $8000
MAPPER_PRG_A000         =   $8008
MAPPER_PRG_C000         =   $9000
    
MAPPER_CHR_0000         =   $A000
MAPPER_CHR_0400         =   $A008
MAPPER_CHR_0800         =   $B000
MAPPER_CHR_0C00         =   $B008
MAPPER_CHR_1000         =   $C000
MAPPER_CHR_1400         =   $C008
MAPPER_CHR_1800         =   $D000
MAPPER_CHR_1C00         =   $D008

MAPPER_WRAM_AUDIO_MIRRORING =   $E000    ;0 = 垂直 1 = 水平 2 = 单屏低 3 = 单屏高
;7  bit  0
;RS.. ..MM

MAPPER_IRQ_LATCH        =   $E010
MAPPER_IRQ_CTRL         =   $F000
MAPPER_IRQ_ACK          =   $F010
        
MAPPER_SOUND_RESET      =   $E000
MAPPER_SOUND_SELECT     =   $9010
MAPPER_SOUND_WRITE      =   $9030

;==================================================
IRQ_SCANLINE_BEGIN          =   256 - (20 + 136)
IRQ_SCANLINE_1              =   256 - (8)
IRQ_SCANLINE_2              =   256 - (54)
IRQ_SCANLINE_3              =   256 - (8)

;==================================================
;宏常量
;==================================================

;==================================================
    .MACRO MACRO_MAPPER_INIT

;设置VRC7图像bank
Init_MAPPER_Chr_Bank
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

    ;开启WRAM, 清除扩展音频, 水平镜像
    LDA #$81
    STA MAPPER_WRAM_AUDIO_MIRRORING

    .ENDM

;==================================================
    .MACRO MACRO_MAPPER_SOUND_CLEAR
    LDX #$07
VRC7_Sound_Reset
    STX MAPPER_SOUND_SELECT
    JSR VRC7_Sound_Reset_7
    LDA #$0F
    STA MAPPER_SOUND_WRITE
    JSR VRC7_Sound_Reset_5
    DEX
    CPX #$05
    BNE VRC7_Sound_Reset
    LDX #$05
VRC7_Sound_Reset_2
    TXA
    CLC
    ADC #$30
    STA MAPPER_SOUND_SELECT
    JSR VRC7_Sound_Reset_7
    LDA #$0F
    STA MAPPER_SOUND_WRITE
    JSR VRC7_Sound_Reset_5
    DEX
    BPL VRC7_Sound_Reset_2
    BMI VRC7_Sound_Reset_End
VRC7_Sound_Reset_5
    STX $82
    LDX #$08
VRC7_Sound_Reset_6
    DEX
    BNE VRC7_Sound_Reset_6
    LDX $82
VRC7_Sound_Reset_7
    RTS
VRC7_Sound_Reset_End
    .ENDM
 
;==================================================
;命名表镜像 操作
;--------------------------------------------------
    .MACRO MACRO_MIRRORING_H
    LDA FC_Mapper_Control
    AND #%00000011 ^ $FF
    ORA #%00000001
    STA MAPPER_WRAM_AUDIO_MIRRORING
    .ENDM

;--------------------------------------------------
    .MACRO MACRO_MIRRORING_V
    LDA FC_Mapper_Control
    AND #%00000011 ^ $FF
    ORA #%00000000
    STA MAPPER_WRAM_AUDIO_MIRRORING
    .ENDM

;==================================================
;PRG RAM 操作
;--------------------------------------------------
    .MACRO MACRO_SRAM_ENABLE
    LDA FC_Mapper_Control
    ORA #%10000000
    STA MAPPER_WRAM_AUDIO_MIRRORING
    .ENDM
 
;--------------------------------------------------
    .MACRO MACRO_SRAM_DISABLE
    LDA FC_Mapper_Control
    AND #%10000000 ^ $FF
    STA MAPPER_WRAM_AUDIO_MIRRORING
    .ENDM
 
;--------------------------------------------------
    .MACRO MACRO_IRQ_LATCH_L
    EOR #$FF
    CLC
    ADC #$01
    STA MAPPER_IRQ_LATCH
    .ENDM
 
;--------------------------------------------------
    .MACRO MACRO_IRQ_ENABLE 
    LDA #$03
    STA MAPPER_IRQ_CTRL
    .ENDM
 
;--------------------------------------------------
    .MACRO MACRO_IRQ_DISABLE 
    LDA #$00
    STA MAPPER_IRQ_CTRL
    .ENDM
 
;--------------------------------------------------
    .MACRO MACRO_IRQ_ACK
    STA MAPPER_IRQ_ACK
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
    STA MAPPER_PRG_C000
    .ENDM
 
;--------------------------------------------------
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