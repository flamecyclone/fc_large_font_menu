;==================================================
;Mapper号
;MAPPER_NUMBER                       =   26
;VRC6a - iNES Mapper 024
;VRC6b - iNES Mapper 026
;==================================================
    .MACRO MACRO_GET_IRQ_FIRST_VALUE_L
        LDA #\1 + 20
    .ENDM

    .MACRO MACRO_GET_IRQ_INTERVAL_VALUE_L
        LDA #\1
    .ENDM

;==================================================
;VRC6 寄存器常量
    .IF 24 = MAPPER_NUMBER
MAPPER_PRG_8000                 =   $8000
MAPPER_PRG_A000                 =   $8000
MAPPER_PRG_C000                 =   $C000
MAPPER_PPU_BANK_MODE            =   $B003    ;W.PN MMDD

MAPPER_CHR_0000                 =   $D000
MAPPER_CHR_0400                 =   $D001
MAPPER_CHR_0800                 =   $D002
MAPPER_CHR_0C00                 =   $D003
MAPPER_CHR_1000                 =   $E000
MAPPER_CHR_1400                 =   $E001
MAPPER_CHR_1800                 =   $E002
MAPPER_CHR_1C00                 =   $E003

MAPPER_IRQ_LATCH                =   $F000
MAPPER_IRQ_CTRL                 =   $F001
MAPPER_IRQ_ACK                  =   $F002

;VRC6音频 
MAPPER_AUDIO_FREQUENCY          =   $9003
MAPPER_AUDIO_PULSE_1            =   $9000;控制脉冲 1
MAPPER_AUDIO_PULSE_2            =   $A000;控制脉冲 2
MAPPER_AUDIO_SAW_ACCUM_RATE     =   $B000;控制锯体积
MAPPER_AUDIO_FREQ_PULSE_1_LOW   =   $9001;脉冲 1 频率低位
MAPPER_AUDIO_FREQ_PULSE_1_HIGH  =   $9002;脉冲 1 频率高位
MAPPER_AUDIO_FREQ_PULSE_2_LOW   =   $A001;脉冲 2 频率低位
MAPPER_AUDIO_FREQ_PULSE_2_HIGH  =   $A002;脉冲 2 频率高位
MAPPER_AUDIO_FREQ_SAW_LOW       =   $B001;锯体积 频率低位
MAPPER_AUDIO_FREQ_SAW_HIGH      =   $B002;锯体积 频率高位
    .ENDIF

    .IF 26 = MAPPER_NUMBER
MAPPER_PRG_8000                 =   $8000
MAPPER_PRG_A000                 =   $8000
MAPPER_PRG_C000                 =   $C000

MAPPER_PPU_BANK_MODE            =   $B003    ;W.PN MMDD

MAPPER_CHR_0000                 =   $D000
MAPPER_CHR_0400                 =   $D002
MAPPER_CHR_0800                 =   $D001
MAPPER_CHR_0C00                 =   $D003
MAPPER_CHR_1000                 =   $E000
MAPPER_CHR_1400                 =   $E002
MAPPER_CHR_1800                 =   $E001
MAPPER_CHR_1C00                 =   $E003

MAPPER_IRQ_LATCH                =   $F000
MAPPER_IRQ_CTRL                 =   $F002
MAPPER_IRQ_ACK                  =   $F001

;VRC6音频
MAPPER_AUDIO_FREQUENCY          =   $9003
MAPPER_AUDIO_PULSE_1            =   $9000;控制脉冲 1
MAPPER_AUDIO_PULSE_2            =   $A000;控制脉冲 2
MAPPER_AUDIO_SAW_ACCUM_RATE     =   $B000;控制锯体积
MAPPER_AUDIO_FREQ_PULSE_1_LOW   =   $9002;脉冲 1 频率低位
MAPPER_AUDIO_FREQ_PULSE_1_HIGH  =   $9001;脉冲 1 频率高位
MAPPER_AUDIO_FREQ_PULSE_2_LOW   =   $A002;脉冲 2 频率低位
MAPPER_AUDIO_FREQ_PULSE_2_HIGH  =   $A001;脉冲 2 频率高位
MAPPER_AUDIO_FREQ_SAW_LOW       =   $B002;锯体积 频率低位
MAPPER_AUDIO_FREQ_SAW_HIGH      =   $B001;锯体积 频率高位
    .ENDIF
;==================================================
IRQ_SCANLINE_BEGIN                  =   256 - (20 + 36)

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

    LDA FC_Mapper_Control
    ORA #%00100000
    STA FC_Mapper_Control
    
	LDA FC_Mapper_Control
	STA MAPPER_PPU_BANK_MODE

    .ENDM

;==================================================
    .MACRO MACRO_MAPPER_SOUND_CLEAR
    LDA #$00
    STA MAPPER_AUDIO_PULSE_1
    JSR .Wait
    STA MAPPER_AUDIO_PULSE_2
    JSR .Wait
    STA MAPPER_AUDIO_SAW_ACCUM_RATE
    JSR .Wait
    JMP .End
.Wait
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    RTS
.End
    .ENDM
 
;==================================================
;命名表镜像 操作
;--------------------------------------------------
    .MACRO MACRO_MIRRORING_H
    LDA FC_Mapper_Control
    AND #%00001111 ^ $FF
    ORA #%00000100
    STA MAPPER_PPU_BANK_MODE
    .ENDM

;--------------------------------------------------
    .MACRO MACRO_MIRRORING_V
    LDA FC_Mapper_Control
    AND #%00001111 ^ $FF
    ORA #%00000000
    STA MAPPER_PPU_BANK_MODE
    .ENDM

;==================================================
;PRG RAM 操作
;--------------------------------------------------
    .MACRO MACRO_SRAM_ENABLE
    LDA FC_Mapper_Control
    ORA #%10000000
	STA MAPPER_PPU_BANK_MODE
	.ENDM
 
;--------------------------------------------------
    .MACRO MACRO_SRAM_DISABLE
    LDA FC_Mapper_Control
    AND #%10000000 ^ $FF
    STA MAPPER_PPU_BANK_MODE
    .ENDM
 
;--------------------------------------------------
    .MACRO MACRO_IRQ_LATCH_L
    EOR #$FF
    CLC
    ADC #$01
    STA MAPPER_IRQ_LATCH
	.ENDM
 
;==================================================
    .MACRO MACRO_IRQ_ENABLE 
	LDA #$03
	STA MAPPER_IRQ_CTRL
	.ENDM
 
;==================================================
    .MACRO MACRO_IRQ_DISABLE 
	LDA #$00
	STA MAPPER_IRQ_CTRL
	.ENDM
 
;==================================================
    .MACRO MACRO_IRQ_ACK
	LDA #$00
	STA MAPPER_IRQ_CTRL
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
    