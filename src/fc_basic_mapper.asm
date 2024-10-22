    .IF 5 = MAPPER_NUMBER
MAPPER_IS_ABSOLUTE  =   1
    .ELSE
MAPPER_IS_ABSOLUTE  =   0
    .ENDIF

;==================================================
;初始化 操作
;--------------------------------------------------
Mapper_Init
    .IFDEF MACRO_MAPPER_INIT
        MACRO_MAPPER_INIT
    .ENDIF
    RTS

;==================================================
;音频清除 操作
;--------------------------------------------------
Mapper_Sound_Clear
    .IFDEF MACRO_MAPPER_SOUND_CLEAR
        MACRO_MAPPER_SOUND_CLEAR
    .ENDIF
    RTS

;--------------------------------------------------
;启用 IRQ
Mapper_Irq_Enable
    .IFDEF MACRO_IRQ_ENABLE
        MACRO_IRQ_ENABLE
    .ENDIF
    RTS

;--------------------------------------------------
;禁用 IRQ
Mapper_Irq_Disable
    .IFDEF MACRO_IRQ_DISABLE
        MACRO_IRQ_DISABLE
    .ENDIF
    RTS

;--------------------------------------------------
;响应 IRQ
Mapper_Irq_Ack
    .IFDEF MACRO_IRQ_ACK
        MACRO_IRQ_ACK
    .ENDIF
    RTS

;--------------------------------------------------
;设置 IRQ 触发值低位
Mapper_Irq_Value_L
    .IFDEF MACRO_IRQ_LATCH_L
        MACRO_IRQ_LATCH_L
    .ENDIF
    RTS

;--------------------------------------------------
;设置 IRQ 触发值高位
Mapper_Irq_Value_H
    .IFDEF MACRO_IRQ_LATCH_H
        MACRO_IRQ_LATCH_H
    .ENDIF
    RTS

;--------------------------------------------------
;设置 IRQ 重载值低位
Mapper_Irq_Reload_L
    .IFDEF MACRO_IRQ_RELOAD_L
        MACRO_IRQ_RELOAD_L
    .ENDIF
    RTS

;--------------------------------------------------
;设置 IRQ 重载值高位
Mapper_Irq_Reload_H
    .IFDEF MACRO_IRQ_RELOAD_H
        MACRO_IRQ_RELOAD_H
    .ENDIF
    RTS

;==================================================
;PRG RAM 操作
;--------------------------------------------------
;启用 PRG RAM
Mapper_Sram_Enable
    .IFDEF MACRO_SRAM_ENABLE
        MACRO_SRAM_ENABLE
    .ENDIF
    RTS

;--------------------------------------------------
;禁用 PRG RAM
Mapper_Sram_Disable
    .IFDEF MACRO_SRAM_DISABLE
        MACRO_SRAM_DISABLE
    .ENDIF
    RTS

;==================================================
;命名表镜像 操作
;--------------------------------------------------
;命名表水平镜像
Mapper_Mirroring_H
    .IFDEF MACRO_MIRRORING_H
        MACRO_MIRRORING_H
    .ENDIF
    RTS

;--------------------------------------------------
;命名表垂直镜像
Mapper_Mirroring_V
    .IFDEF MACRO_MIRRORING_V
        MACRO_MIRRORING_V
    .ENDIF
    RTS

;==================================================
;PRG 切页操作
;--------------------------------------------------
;切换 PRG bank 到8000-9FFF
Mapper_Prg_8000_Banking
    PHP
    SEI
    .IF 0 = MAPPER_PRG_8KB_SUPPORT
        LSR
    .ENDIF

    STA FC_Prg_8000
    .IFDEF MACRO_SWITCH_PRG_8000_A
        MACRO_SWITCH_PRG_8000_A
    .ENDIF
    PLP
    RTS

;--------------------------------------------------
;切换 PRG bank 到A000-BFFF
Mapper_Prg_A000_Banking
    PHP
    SEI
    STA FC_Prg_A000
    .IFDEF MACRO_SWITCH_PRG_A000_A
        MACRO_SWITCH_PRG_A000_A
    .ENDIF
    PLP
    RTS

;--------------------------------------------------
;切换 PRG bank 到C000-DFFF
Mapper_Prg_C000_Banking
    PHP
    SEI
    STA FC_Prg_C000
    .IFDEF MACRO_SWITCH_PRG_C000_A
        MACRO_SWITCH_PRG_C000_A
    .ENDIF
    PLP
    RTS

;--------------------------------------------------
;切换 PRG bank 到E000-FFFF
Mapper_Prg_E000_Banking
    PHP
    SEI
    STA FC_Prg_E000
    .IFDEF MACRO_SWITCH_PRG_E000_A
        MACRO_SWITCH_PRG_E000_A
    .ENDIF
    PLP
    RTS

;==================================================
;CHR 切页操作
;--------------------------------------------------
;切换 CHR bank 到0000-03FF
Mapper_Chr_0000_Banking
    .IFDEF MACRO_SWITCH_CHR_0000_A
        MACRO_SWITCH_CHR_0000_A
    .ENDIF
    RTS

;--------------------------------------------------
;切换 CHR bank 到0400-07FF
Mapper_Chr_0400_Banking
    .IFDEF MACRO_SWITCH_CHR_0400_A
        MACRO_SWITCH_CHR_0400_A
    .ENDIF
    RTS

;--------------------------------------------------
;切换 CHR bank 到0800-0BFF
Mapper_Chr_0800_Banking
    .IFDEF MACRO_SWITCH_CHR_0800_A
        MACRO_SWITCH_CHR_0800_A
    .ENDIF
    RTS

;--------------------------------------------------
;切换 CHR bank 到0C00-0FFF
Mapper_Chr_0C00_Banking
    .IFDEF MACRO_SWITCH_CHR_0C00_A
        MACRO_SWITCH_CHR_0C00_A
    .ENDIF
    RTS

;--------------------------------------------------
;切换 CHR bank 到1000-13FF
Mapper_Chr_1000_Banking
    .IFDEF MACRO_SWITCH_CHR_1000_A
        MACRO_SWITCH_CHR_1000_A
    .ENDIF
    RTS

;--------------------------------------------------
;切换 CHR bank 到1400-17FF
Mapper_Chr_1400_Banking
    .IFDEF MACRO_SWITCH_CHR_1400_A
        MACRO_SWITCH_CHR_1400_A
    .ENDIF
    RTS

;--------------------------------------------------
;切换 CHR bank 到1800-1BFF
Mapper_Chr_1800_Banking
    .IFDEF MACRO_SWITCH_CHR_1800_A
        MACRO_SWITCH_CHR_1800_A
    .ENDIF
    RTS

;--------------------------------------------------
;切换 CHR bank 到1C00-1FFF
Mapper_Chr_1C00_Banking
    .IFDEF MACRO_SWITCH_CHR_1C00_A
        MACRO_SWITCH_CHR_1C00_A
    .ENDIF
    RTS


