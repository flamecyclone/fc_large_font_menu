;==================================================
;Mapper号
;MAPPER_NUMBER           = 05
;==================================================
    .MACRO MACRO_GET_IRQ_FIRST_VALUE_L
        LDA #\1
    .ENDM

    .MACRO MACRO_GET_IRQ_INTERVAL_VALUE_L
        LDA #\1
    .ENDM

;==================================================
;MMC5 (Mapper 5) 寄存器常量
MAPPER_APU_Pulse_1_0        =   $5000
MAPPER_APU_Pulse_1_1        =   $5001
MAPPER_APU_Pulse_1_2        =   $5002
MAPPER_APU_Pulse_1_3        =   $5003
MAPPER_APU_Pulse_2_0        =   $5004
MAPPER_APU_Pulse_2_1        =   $5005
MAPPER_APU_Pulse_2_2        =   $5006
MAPPER_APU_Pulse_2_3        =   $5007

MAPPER_PCM_MODE_IRQ         =   $5010
MAPPER_RAW_PCM              =   $5011
MAPPER_APU_STATUS           =   $5015

MAPPER_PRG_MODE             =   $5100; 0: 32KB 1: 16KB * 2 2: 16KB + 8 * 2 3: 8*4
MAPPER_CHR_MODE             =   $5101; 0: 8KB 1: 4KB * 2 2: 2KB * 4 3: 1KB * 8
MAPPER_PRG_RAM_PROTECT_1    =   $5102;
MAPPER_PRG_RAM_PROTECT_2    =   $5103;
MAPPER_EX_RAM_MODE          =   $5104; 0: Write Only 1: Write Only 2: RW 3:R
                                            ;0: 只写
                                            ;1: 只写, 扩展属性表模式
                                            ;2: 读写
                                            ;3: 只读
MAPPER_EX_RAM_ADDR          =   $5C00
MAPPER_NT_MAPPING           =   $5105;
MAPPER_FILL_MODE_TILE       =   $5106
MAPPER_FILL_MODE_COLOR      =   $5107

MAPPER_PRG_BANK_6000        =   $5113
MAPPER_PRG_BANK_8000        =   $5114
MAPPER_PRG_BANK_A000        =   $5115
MAPPER_PRG_BANK_C000        =   $5116
MAPPER_PRG_BANK_E000        =   $5117

MAPPER_CHR_0000             =   $5120
MAPPER_CHR_0400             =   $5121
MAPPER_CHR_0800             =   $5122
MAPPER_CHR_0C00             =   $5123
MAPPER_CHR_1000             =   $5124
MAPPER_CHR_1400             =   $5125
MAPPER_CHR_1800             =   $5126
MAPPER_CHR_1C00             =   $5127
        
MAPPER_CHR_0000_1000        =   $5128
MAPPER_CHR_0400_1400        =   $5129
MAPPER_CHR_0800_1800        =   $512A
MAPPER_CHR_0C00_1C00        =   $512B
        
MAPPER_CHR_UPPER            =   $5130
MAPPER_V_SPLIT_MODE         =   $5200
MAPPER_V_SPLIT_SCROLL       =   $5201
MAPPER_V_SPLIT_BANK         =   $5202

MAPPER_IRQ_SCANLINE_VALUE   =   $5203
MAPPER_IRQ_STATUS           =   $5204
MAPPER_MULTIPLIER_A         =   $5205
MAPPER_MULTIPLIER_B         =   $5206

;--------------------------------------------------
MMC5A_CL3_SL3_DATA          =   $5207
MMC5A_CL3_SL3_STATUS        =   $5208
MMC5A_IRQ_TIMER_LSB         =   $5209
MMC5A_IRQ_TIMER_MSB         =   $520A

;==================================================
;宏常量
;==================================================

;==================================================
;初始化操作
;--------------------------------------------------
    .MACRO MACRO_MAPPER_INIT

    ;设置 PRG 切页模式
    LDA #$03
    STA MAPPER_PRG_MODE

    ;设置 CHR 切页模式
    LDA #$03
    STA MAPPER_CHR_MODE

    ;设置屏幕镜像($50: 水平; $44: 垂直)
    LDA #$44
    STA MAPPER_NT_MAPPING

    ;设置 $C000-$DFFF bank
    LDA #$FE
    ORA #$80
    STA MAPPER_PRG_BANK_C000

    LDA #$00
    STA MAPPER_CHR_UPPER
    
    ;初始化 CHR bank
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

    LDA #$00
    STA MAPPER_CHR_0000_1000
    LDA #$01
    STA MAPPER_CHR_0400_1400
    LDA #$02
    STA MAPPER_CHR_0800_1800
    LDA #$03
    STA MAPPER_CHR_0C00_1C00

    ;禁用IRQ
    LDA #$00
    STA MAPPER_IRQ_SCANLINE_VALUE
    STA MAPPER_IRQ_STATUS

    ;设置一下6000-7FFF的RAM
    LDA #$00
    STA MAPPER_PRG_BANK_6000
    
    ;启用 1KB 扩展RAM ($5C00-$5FFF) 0: 只写 1: 只写 2: 读写 3: 只读
    LDA #$02
    STA MAPPER_EX_RAM_MODE

    ;开启 PRG RAM 写入
    LDA #$02
    STA MAPPER_PRG_RAM_PROTECT_1
    LDA #$01
    STA MAPPER_PRG_RAM_PROTECT_2

    LDX #$00
    LDA #$00
Init_Ex_RAM_Set
    STA MAPPER_EX_RAM_ADDR + $0000,X
    STA MAPPER_EX_RAM_ADDR + $0100,X
    STA MAPPER_EX_RAM_ADDR + $0200,X
    STA MAPPER_EX_RAM_ADDR + $0300,X
    INX
    BNE Init_Ex_RAM_Set
 
    .ENDM

;==================================================
;音频操作
;--------------------------------------------------
    .MACRO MACRO_MAPPER_SOUND_CLEAR
    LDA #$03
    STA $4015

    LDA #$30
    STA $5000
    JSR .Mapper_Clear_Sound_Wait
    STA $5004
    JSR .Mapper_Clear_Sound_Wait
    LDA #$7F
    STA $5001
    STA $5005
    
    LDA #$0F
    STA $4015
    
    JMP .Mapper_Clear_Sound_End
.Mapper_Clear_Sound_Wait
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
.Mapper_Clear_Sound_End


    .ENDM
 
;==================================================
;命名表镜像 操作
;--------------------------------------------------
    .MACRO MACRO_MIRRORING_H
    ;设置屏幕镜像($50: 水平; $44: 垂直)
    LDA #$50
    STA MAPPER_NT_MAPPING
    .ENDM

;--------------------------------------------------
    .MACRO MACRO_MIRRORING_V
    ;设置屏幕镜像($50: 水平; $44: 垂直)
    LDA #$44
    STA MAPPER_NT_MAPPING
    .ENDM

;==================================================
;SRAM 操作
;--------------------------------------------------
    .MACRO MACRO_SRAM_ENABLE
    LDA #$02
    STA MAPPER_PRG_RAM_PROTECT_1
    LDA #$01
    STA MAPPER_PRG_RAM_PROTECT_2
    LDA #$02
    STA MAPPER_EX_RAM_MODE
    .ENDM
 
;--------------------------------------------------
    .MACRO MACRO_SRAM_DISABLE
    LDA #$00
    STA MAPPER_PRG_RAM_PROTECT_1
    LDA #$00
    STA MAPPER_PRG_RAM_PROTECT_2
    LDA #$00
    STA MAPPER_EX_RAM_MODE
    .ENDM
 
;--------------------------------------------------
    .MACRO MACRO_IRQ_LATCH_L
    STA MAPPER_IRQ_SCANLINE_VALUE
    .ENDM
 
;--------------------------------------------------
    .MACRO MACRO_IRQ_ENABLE 
    LDA #$80
    STA MAPPER_IRQ_STATUS
    .ENDM
 
;--------------------------------------------------
    .MACRO MACRO_IRQ_DISABLE 
    LDA #$00
    STA MAPPER_IRQ_SCANLINE_VALUE
    STA MAPPER_IRQ_STATUS
    .ENDM
 
;--------------------------------------------------
    .MACRO MACRO_IRQ_ACK
    LDA MAPPER_IRQ_STATUS
    .ENDM
 
;==================================================
;PRG 切页操作
;--------------------------------------------------
    .MACRO MACRO_SWITCH_PRG_8000_A
    ORA #$80
    STA MAPPER_PRG_BANK_8000
    .ENDM

;--------------------------------------------------
    .MACRO MACRO_SWITCH_PRG_A000_A
    ORA #$80
    STA MAPPER_PRG_BANK_A000
    .ENDM
 
;--------------------------------------------------
    .MACRO MACRO_SWITCH_PRG_C000_A
    ORA #$80
    STA MAPPER_PRG_BANK_C000
    .ENDM

;--------------------------------------------------
    .MACRO MACRO_SWITCH_PRG_E000_A
    ORA #$80
    STA MAPPER_PRG_BANK_E000
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
