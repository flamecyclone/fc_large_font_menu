;=================================================
;NMI(不可屏蔽中断)处理
Nmi_Program_Process
    PHA
    TXA
    PHA
    TYA
    PHA
    
    LDA PPU_STATUS      ;$2002  读取清除 Vblank 状态
    
    LDA #NES_8KB_CHR_RAM_SIZE
    STA $20
    
    .IF TEXT_SCROLL_IRQ_ENABLE > 0
    ;设置IRQ触发位置低位, 假设在第 30 条扫描线触发 
    .IFDEF MACRO_GET_IRQ_FIRST_VALUE_L
        MACRO_GET_IRQ_FIRST_VALUE_L #LIST_FIRST_IRQ_VALUE
        STA FC_Irq_Latch_L
    .ENDIF
    
    .IFDEF MACRO_IRQ_LATCH_L
        MACRO_IRQ_LATCH_L
    .ENDIF
    
    .IFDEF MACRO_IRQ_RELOAD_L
        MACRO_IRQ_RELOAD_L
    .ENDIF
    
    ;设置IRQ触发位置高位, 假设在第 30 条扫描线触发
    .IFDEF MACRO_GET_IRQ_FIRST_VALUE_H
        MACRO_GET_IRQ_FIRST_VALUE_H #LIST_FIRST_IRQ_VALUE
        STA FC_Irq_Latch_H
    .ENDIF
    
    .IFDEF MACRO_IRQ_LATCH_H
        MACRO_IRQ_LATCH_H
    .ENDIF
    
    .IFDEF MACRO_IRQ_RELOAD_H
        MACRO_IRQ_RELOAD_H
    .ENDIF
    
    ;启用 IRQ
    .IFDEF MACRO_IRQ_ENABLE
        MACRO_IRQ_ENABLE
    .ENDIF 
    CLI
    
    .ENDIF
    
    ;设置标题文本图案
    .IFDEF MACRO_SWITCH_CHR_1000_A
        LDA #$04
        MACRO_SWITCH_CHR_1000_A
    .ENDIF
    
    ;页面缓冲没准备完毕则不处理PPU
    LDA FC_Page_Item_Buffer
    BNE .Normal_Task_Proc
    
    JSR FC_PPU_Buffer_Process   ;PPU缓冲处理
    
.Normal_Task_Proc
    LDA #OAM_DMA_Buffer / $100
    STA OAM_DMA         ;$4014  ;将精灵缓冲写入精灵内存
    
    INC FC_NMI_Level
    
    LDA #$01
    JSR Mapper_Chr_1400_Banking
    LDA #$02
    JSR Mapper_Chr_1800_Banking
    LDA #$03
    JSR Mapper_Chr_1C00_Banking
    
    ;备份Bank
    LDA FC_Prg_8000
    PHA
    LDA FC_Prg_A000
    PHA
    
    LDA FC_PPU_Ctrl
    STA PPU_CTRL        ;$2000  ;恢复屏幕控制
    
    JSR FC_Gamepad_Process      ;手柄输入处理
    
    INC FC_Irq_Scroll           ;IRQ 滚动增加
    
    JSR Item_Name_Scroll        ;文本滚动
    
    LDA FC_NMI_Time_Delay
    BNE .End_Task
    
    JSR FC_Item_Select          ;节目选择
    
    ;选择音乐
    .IFDEF Music_Select_Process
        JSR Music_Select_Process
    .ENDIF
    
.End_Task

    ;播放音乐
    .IFDEF Music_Play_Process
        JSR Music_Play_Process
    .ENDIF

    ;清除缓冲状态
    LDA FC_NMI_Task_Flag
    AND #FC_NMI_TASK_BUF_READY ^ $FF
    STA FC_NMI_Task_Flag
    
    DEC FC_NMI_Level
    
    ;恢复Bank
    PLA
    JSR Mapper_Prg_A000_Banking
    PLA
    JSR Mapper_Prg_8000_Banking
    
    JSR .Time_Count
.End
    PLA
    TAY
    PLA
    TAX
    PLA
    RTI
    
.Time_Count
    LDA FC_NMI_Time_Delay
    BNE .Time_Count_End
    INC FC_NMI_Time_Count
    RTS
.Time_Count_End
    DEC FC_NMI_Time_Delay
    RTS
