;=================================================
;设置下次IRQ触发值
    .MACRO MACRO_NEXT_IRQ_VALUE

    .IF MAPPER_IS_ABSOLUTE
        ;如果是绝对位置触发IRQ, 则累加后写入触发IRQ
        
        .IFDEF MACRO_IRQ_LATCH_L
            LDA FC_Irq_Latch_L
            CLC
            ADC FC_Irq_Interval_L
            STA FC_Irq_Latch_L
            MACRO_IRQ_LATCH_L
        .ENDIF
        
        .IFDEF MACRO_IRQ_LATCH_H
            LDA FC_Irq_Latch_H
            ADC FC_Irq_Interval_H
            STA FC_Irq_Latch_H
            MACRO_IRQ_LATCH_H
        .ENDIF
        
    .ELSE
        ;如果是相对位置触发IRQ, 则直接写入触发IRQ
        .IFDEF MACRO_IRQ_LATCH_L
            LDA FC_Irq_Interval_L
            MACRO_IRQ_LATCH_L
        .ENDIF
        
        .IFDEF MACRO_IRQ_RELOAD_L
            MACRO_IRQ_RELOAD_L
        .ENDIF
        
        .IFDEF MACRO_IRQ_LATCH_H
            LDA FC_Irq_Interval_H
            MACRO_IRQ_LATCH_H
        .ENDIF
        
        .IFDEF MACRO_IRQ_RELOAD_H
            MACRO_IRQ_RELOAD_H
        .ENDIF
        
    .ENDIF
    
    .ENDM

;=================================================
;IRQ(请求中断)处理
Irq_Program_Process
    PHA
    TXA
    PHA
    TYA
    PHA
    
    ;响应IRQ
    .IFDEF MACRO_IRQ_ACK
        MACRO_IRQ_ACK
    .ENDIF
    
    LDX FC_Irq_Index
    BNE .Item_Chr
    
    .IFDEF MACRO_SWITCH_CHR_1000_A
        LDA #$00
        MACRO_SWITCH_CHR_1000_A
    .ENDIF
    
    ;获取下次 IRQ 触发时机低位, 假设在第 14 条扫描线后触发
    .IFDEF MACRO_GET_IRQ_INTERVAL_VALUE_L
        MACRO_GET_IRQ_INTERVAL_VALUE_L #LIST_TITLE_NEXT_VALUE
        STA FC_Irq_Interval_L
    .ENDIF
    
    ;获取下次 IRQ 触发时机高位, 假设在第 14 条扫描线后触发
    .IFDEF MACRO_GET_IRQ_INTERVAL_VALUE_H
        MACRO_GET_IRQ_INTERVAL_VALUE_H #LIST_TITLE_NEXT_VALUE
        STA FC_Irq_Interval_H
    .ENDIF
    
    JMP .Next_Irq

.Item_Chr
    DEX
    LDA FC_Chr_Index_Ready,X
    BNE .Chr_Cur
    
.Chr_Last
    .IFDEF MACRO_SWITCH_CHR_1000_A
        LDA FC_Chr_Index_Last,X
        MACRO_SWITCH_CHR_1000_A
    .ENDIF
    
    JMP .Start
    
.Chr_Cur
    .IFDEF MACRO_SWITCH_CHR_1000_A
        LDA FC_Chr_Index,X
        MACRO_SWITCH_CHR_1000_A
    .ENDIF
    
.Start

    .IFDEF MACRO_SWITCH_CHR_1400_A
        LDA #$01
        MACRO_SWITCH_CHR_1400_A
    .ENDIF
    
    .IFDEF MACRO_SWITCH_CHR_1800_A
        LDA #$02
        MACRO_SWITCH_CHR_1800_A
    .ENDIF
    
    .IFDEF MACRO_SWITCH_CHR_1C00_A
        LDA #$03
        MACRO_SWITCH_CHR_1C00_A
    .ENDIF

    ;获取下次 IRQ 触发时机低位, 假设在第 14 条扫描线后触发
    .IFDEF MACRO_GET_IRQ_INTERVAL_VALUE_L
        MACRO_GET_IRQ_INTERVAL_VALUE_L #LIST_FIRST_NEXT_VALUE
        STA FC_Irq_Interval_L
    .ENDIF
    
    ;获取下次 IRQ 触发时机高位, 假设在第 14 条扫描线后触发
    .IFDEF MACRO_GET_IRQ_INTERVAL_VALUE_H
        MACRO_GET_IRQ_INTERVAL_VALUE_H #LIST_FIRST_NEXT_VALUE
        STA FC_Irq_Interval_H
    .ENDIF
    
.Next_Irq
    MACRO_NEXT_IRQ_VALUE
    
    INC FC_Irq_Index
    LDA FC_Irq_Index
    CMP #ITEM_PAGE_ROW + 1
    BCS Irq_Process_Disable
    LDA $00
Irq_Process_Enable
    .IFDEF MACRO_IRQ_ENABLE
        MACRO_IRQ_ENABLE
    .ENDIF
    JMP Irq_Program_End

Irq_Process_Disable
    NOP
    LDA #$00
    STA FC_Irq_Index
    
    ;禁用IRQ
    .IFDEF MACRO_IRQ_DISABLE
        MACRO_IRQ_DISABLE
    .ENDIF

    JMP Irq_Program_End

Irq_Program_End
    
    PLA
    TAY
    PLA
    TAX
    PLA
    RTI
