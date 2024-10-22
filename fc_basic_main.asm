;=================================================
;FC ROM 简单框架
;FlameCyclone
;2024.8.9
;=================================================
    .INCLUDE "fc_basic_config.asm"      ;配置
;=================================================
;音乐数据
    .IF (MUSIC_PLAY_ENABLE > 0) & (FC_MUSIC_THEME > 0)
        .INCLUDE "fc_basic_music_bank.asm"  ;音乐数据
    .ENDIF

;======================================================================
;自定义外部数据
    .IF CUSTOM_DATA_BANK > 0
        .BANK CUSTOM_DATA_BANK & BANK_DATA_MASK, "Custom Data"
        .ORG CUSTOM_DATA_ADDR
        .INCLUDE "build/game_final_data_0.asm"
    .ENDIF
    
;=================================================
;文本数据放在开头Bank
    .BANK TEXT_DATA_BANK, "Static Text Data"
    .ORG TEXT_DATA_ADDR
    .INCLUDE "fc_basic_text_data.asm"
;-------------------------------------------------
;列表文本数据
    .BANK LIST_DATA_BANK + 0, "List Text Data 0"
    .ORG LIST_DATA_ADDR 
    .INCLUDE "tmp\list_output_data_0.asm"
    .BANK LIST_DATA_BANK + 1, "List Text Data 1"
    .ORG LIST_DATA_ADDR
    .INCLUDE "tmp\list_output_data_1.asm"
    .BANK LIST_DATA_BANK + 2, "List Text Data 2"
    .ORG LIST_DATA_ADDR
    .INCLUDE "tmp\list_output_data_2.asm"
    .BANK LIST_DATA_BANK + 3, "List Text Data 3"
    .ORG LIST_DATA_ADDR
    .INCLUDE "tmp\list_output_data_3.asm"
    .BANK LIST_DATA_BANK + 4, "List Text Data 4"
    .ORG LIST_DATA_ADDR 
    .INCLUDE "tmp\list_output_data_4.asm"
    .BANK LIST_DATA_BANK + 5, "List Text Data 5"
    .ORG LIST_DATA_ADDR
    .INCLUDE "tmp\list_output_data_5.asm"
    .BANK LIST_DATA_BANK + 6, "List Text Data 6"
    .ORG LIST_DATA_ADDR
    .INCLUDE "tmp\list_output_data_6.asm"
    .BANK LIST_DATA_BANK + 7, "List Text Data 7"
    .ORG LIST_DATA_ADDR
    .INCLUDE "tmp\list_output_data_7.asm"
    
    .BANK LIST_INDEX_BANK, "List Index"
    .ORG LIST_INDEX_ADDR
Item_Text_Data_Bank_Index
    .INCLUDE "tmp\list_output_bank_index.asm"
Item_Text_Data_Chr_Index
    .INCLUDE "tmp\list_output_chr_index.asm"
    
;=================================================
;主程序放在最后一个 8KB bank
    .BANK FC_PRG_E000 & PRG_8K_BANK_MASK, "Main Program"
    .ORG $E000

;调色板数据
Init_Palette_Data
    .INCLUDE "data/fc_basic_palette.asm"

;属性表数据
PPU_Attributes_Data
    .INCBIN "data/fc_basic_attributes.attr"
    
;=================================================
;Mapper 操作引用
    .IF 342 = ROM_MAPPER

        .IF 4 = MAPPER_NUMBER
            .INCLUDE "mapper/fc_coolgirl_mmc3.asm"
        .ENDIF
        
        .IF 69 = MAPPER_NUMBER
            .INCLUDE "mapper/fc_coolgirl_5b.asm"
        .ENDIF
    
    .ENDIF
    
    .IF 268 = ROM_MAPPER
        .INCLUDE "mapper/fc_coolboy_mmc3.asm"
    .ENDIF
    
    .IF 1 = MAPPER_NUMBER
        .INCLUDE "mapper/fc_basic_mapper_mmc1"
    .ENDIF

    .IF 4 = MAPPER_NUMBER
        .INCLUDE "mapper/fc_basic_mapper_mmc3"
    .ENDIF

    .IF 5 = MAPPER_NUMBER
        .INCLUDE "mapper/fc_basic_mapper_mmc5"
    .ENDIF
    
    .IF 9 = MAPPER_NUMBER
        .INCLUDE "mapper/fc_basic_mapper_mmc2"
    .ENDIF
    
    .IF 10 = MAPPER_NUMBER
        .INCLUDE "mapper/fc_basic_mapper_mmc4"
    .ENDIF
    
    .IF 19 = MAPPER_NUMBER
        .INCLUDE "mapper/fc_basic_mapper_namco_163.asm"
    .ENDIF
    
    .IF (21 = MAPPER_NUMBER) | (22 = MAPPER_NUMBER) | (23 = MAPPER_NUMBER) | (25 = MAPPER_NUMBER)
        .INCLUDE "mapper/fc_basic_mapper_vrc4.asm"
    .ENDIF

    .IF (24 = MAPPER_NUMBER) | (26 = MAPPER_NUMBER)
        .INCLUDE "mapper/fc_basic_mapper_vrc6.asm"
    .ENDIF

    .IF 69 = MAPPER_NUMBER
        .INCLUDE "mapper/fc_basic_mapper_sunsoft_5b.asm"
    .ENDIF
    
    .IF 73 = MAPPER_NUMBER
        .INCLUDE "mapper/fc_basic_mapper_vrc3.asm"
    .ENDIF
    
    .IF 75 = MAPPER_NUMBER
        .INCLUDE "mapper/fc_basic_mapper_vrc1.asm"
    .ENDIF
    
    .IF 85 = MAPPER_NUMBER
    .INCLUDE "mapper/fc_basic_mapper_vrc7.asm"
    .ENDIF

;=================================================
;其他源码引用
    .INCLUDE "src/fc_basic_constant.asm"    ;常量定义
    .INCLUDE "src/fc_basic_ppu.asm"         ;PPU处理
    .INCLUDE "src/fc_basic_text_utils.asm"        ;文本处理
    .INCLUDE "src/fc_basic_text_scroll.asm" ;文本滚动
    .INCLUDE "src/fc_basic_joy.asm"         ;手柄输入处理
    .INCLUDE "src/fc_basic_utils.asm"       ;使用工具
    
    .IF MUSIC_PLAY_ENABLE
        .INCLUDE "fc_basic_music.asm"       ;音乐播放
        .INCLUDE "src/fc_basic_sound.asm"       ;音效处理
    .ENDIF
    
    .INCLUDE "src/fc_basic_paging.asm"      ;翻页操作
    .INCLUDE "src/fc_basic_page_list.asm"   ;翻页文本列表
    .INCLUDE "src/fc_basic_cursor.asm"      ;光标处理
    .INCLUDE "src/fc_basic_mapper.asm"      ;Mapper操作
    .INCLUDE "fc_basic_select.asm"      ;节目选择
    
;=================================================
;等待 Vblank 触发
Wait_For_Vblank
    LDA PPU_STATUS      ;$2002
    BPL Wait_For_Vblank
    RTS

;======================================================================
;等待帧延迟计数
Wait_Frame_Delay
    STA FC_NMI_Time_Delay
.Waiting
    LDA FC_NMI_Time_Delay
    BNE .Waiting
    RTS

;=================================================
;初始化调色板数据与调色板缓冲
Init_Palette_With_Buffer
    LDA #$3F
    STA PPU_ADDRESS     ;$2006      ;写入 PPU 地址高位
    LDA #$00
    STA PPU_ADDRESS     ;$2006      ;写入 PPU 地址低位
    LDX #$00
    LDY #$20
Init_Palette_With_Buffer_Write
    LDA Init_Palette_Data,X
    STA FC_PPU_Pal_Addr,X           ;写入到缓冲
    STA PPU_DATA        ;$2007      ;写入 PPU 数据
    INX
    DEY
    BNE Init_Palette_With_Buffer_Write
    RTS

;=================================================
;NMI(重置中断)处理, 上电时
Reset_Program
    SEI                 ;设置中断禁用标志, 防止程序执行被中断
    CLD                 ;禁用 10进制模式, NES 不支持 10进制
    
    .IF 1 = MAPPER_NUMBER
.Reset_Mapper
        INC .Reset_Mapper
    .ENDIF

    ;关闭屏幕
    LDA #$00
    STA PPU_CTRL        ;$2000  ;静音NMI
    STA PPU_MASK        ;$2001  ;禁用屏幕渲染
    
    LDA #$40
    STA JOY2_FRAME      ;$4017  ;禁用 APU 帧 IRQ

;-------------------------------------------------
;等待 PPU 准备完毕
    LDX #$02
.Wait_For_Vblank
    LDA PPU_STATUS      ;$2002
    BPL .Wait_For_Vblank
    DEX
    BNE .Wait_For_Vblank

;-------------------------------------------------
;清空 PPU 调色板(PPU 调色板内存: $3F00 - $3F1F)
;重要: 只能在 Vblank 期间操作调色板, 否则即使屏幕关闭, 也会出现撕裂的色条横线
.Clear_PPU_Palette
    LDA #$3F
    STA PPU_ADDRESS     ;$2006      ;写入 PPU 地址高位
    LDA #$00
    STA PPU_ADDRESS     ;$2006      ;写入 PPU 地址低位
    LDA #$0F
    LDX #$20
.Clear_PPU_Palette_Write
    STA PPU_DATA        ;$2007
    DEX
    BNE .Clear_PPU_Palette_Write
    
    ;设置栈指针
    LDX #$FF
    TXS
    
;-------------------------------------------------
;清空 APU 状态    
.Clear_Apu_Status
    LDY #$13
.Clear_Apu_Status_Write
    LDA .Default_Apu_Status_Data,Y
    STA $4000,Y
    DEY
    BPL .Clear_Apu_Status_Write
    LDA #$0F
    STA $4015
    JMP .Clear_Apu_Status_End
.Default_Apu_Status_Data
    .DB $30,$08,$00,$00
    .DB $30,$08,$00,$00
    .DB $80,$00,$00,$00
    .DB $30,$00,$00,$00
    .DB $00,$00,$00,$00
.Clear_Apu_Status_End

    JSR Mapper_Sound_Clear  ;Mapper 音频清理
    
;-------------------------------------------------
;清空 PPU 命名表(PPU 命名表内存: $2000 - $2FFF)
.Clear_PPU_Nametable
    LDA #$20
    STA PPU_ADDRESS     ;$2006      ;写入 PPU 地址高位
    LDA #$00
    STA PPU_ADDRESS     ;$2006      ;写入 PPU 地址低位
    LDX #$10
    LDY #$00
    LDA #FC_PPU_CHAR_NULL
.Clear_PPU_Nametable_Write
    STA PPU_DATA        ;$2007
    INY
    BNE .Clear_PPU_Nametable_Write
    DEX
    BNE .Clear_PPU_Nametable_Write

;-------------------------------------------------
;清空 PPU 属性表(PPU 命名表内存: $23C0 - $23FF)
.Clear_PPU_Attributes
    LDA #$23
    STA PPU_ADDRESS     ;$2006      ;写入 PPU 地址高位
    LDA #$C0
    STA PPU_ADDRESS     ;$2006      ;写入 PPU 地址低位
    LDY #$40
    LDX #$00
.Clear_PPU_Attributes_Write
    LDA PPU_Attributes_Data,X
    STA PPU_DATA        ;$2007
    INX
    DEY
    BNE .Clear_PPU_Attributes_Write
    
;-------------------------------------------------
;清空内存
.Clear_RAM
    LDA #$00
    STA $00
    STA $01
    LDX #$08
    LDY #$00
.Clear_RAM_Write
    STA [$00],Y
    INY
    BNE .Clear_RAM_Write
    INC $01
    DEX
    BNE .Clear_RAM_Write

;-------------------------------------------------
;初始化栈指针
    LDX #$FF
    TXS

;-------------------------------------------------
;清空OAM内存
.Clear_OAM
    LDA #$F8
    LDY #$00
    LDX #$00
.Clear_OAM_Write
    STA OAM_DMA_Buffer,X
    INX
    DEY
    BNE .Clear_OAM_Write

    JSR Mapper_Init                 ;Mapper 初始化
    
    .IF (NES_8KB_CHR_RAM_SIZE > 0) & (0 = NES_8KB_CHR_SIZE)
        LDA #NES_8KB_CHR_RAM_SIZE
        STA FC_Data_Index
        .IFDEF Mapper_VRAM_Init
            JSR Mapper_VRAM_Init
        .ENDIF
    .ENDIF
    
    LDA #$FF
    STA Use_Zero_Page_End
    STA Use_Non_Zero_Page_End
    
    ;调色板初始化 & 调色板缓冲初始化
    JSR Mapper_Mirroring_H           ;设置命名表水平镜像
    JSR Wait_For_Vblank              ;等到 Vblank
    JSR Init_Palette_With_Buffer     ;初始化调色板缓冲
    
    ;写入静态文本, 需要先切页
    LDA #BANK(Text_Data_Index)
    JSR Mapper_Prg_8000_Banking
    ;JSR Write_Text_Group_By_Buffer  ;写入静态文本组(缓冲方式)
    JSR Write_Text_Group_By_Data     ;写入静态文本组(直写模式)
    
    LDA #$00
    STA FC_NMI_Level
        
    JSR Reset_Item_Name_Scroll
    
    ;启用 NMI 中断
    LDA #$80 | (FC_PPU_SP_SIZE << 5) | (FC_PPU_NT_ADDR << 4) | (FC_PPU_SP_ADDR << 3)
    STA FC_PPU_Ctrl
    STA PPU_CTRL        ;$2000
    
    ;刷新文本列表
    JSR Page_List_Update
    
    ;开启屏幕显示
    LDA #$1E
    STA FC_PPU_Mask

    ;初始化音乐
    
    .IF (MUSIC_PLAY_ENABLE > 0) & (FC_MUSIC_THEME > 0)
        LDA #CUSTOM_MUSCI_BACKGROUND - 1
        STA FC_Music_Index
        JSR Music_Init_Process
    .ENDIF
    
    CLI
;-------------------------------------------------
;死循环, 后续操作交给 NMI 中断
.Loop
    JMP .Loop
    
;=================================================
;NMI(不可屏蔽中断)处理
Nmi_Program
    .INCLUDE "src/fc_basic_nmi.asm"
    
;=================================================
;IRQ(请求中断)处理
Irq_Program
    .INCLUDE "src/fc_basic_irq.asm"
    
;=================================================
;外部切页接口
    .INCLUDE "src/fc_basic_interface.asm"

;=================================================
;NES 中断向量入口
    .ORG $FFFA
    .DW Nmi_Program     ;NMI    ;开启NMI后, 渲染扫描线在第 241 行时触发
    .DW Reset_Program   ;RESET  ;开机上电时触发
    .DW Irq_Program     ;IRQ    ;发生IRQ时触发

;=================================================
;菜单大小重置
    .IF 342 = ROM_MAPPER
        .IFDEF COOLGIRL_SIZE_RESET
            COOLGIRL_SIZE_RESET
        .ENDIF
    .ENDIF

    .IF 268 = ROM_MAPPER
        .IFDEF COOLBOY_SIZE_RESET
        COOLBOY_SIZE_RESET
        .ENDIF
    .ENDIF
;=================================================
;CHR 数据
    .INCLUDE "fc_basic_chr.asm"