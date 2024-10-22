;=================================================
;Mapper寄存器
MAPPER_CHR_INDEX_COUNT      =   $06
;=================================================
GAME_DATA_INDEX_ENABLE      =   0       ;是否使用节目数据 Bank 索引
GAME_DATA_INDEX_BANK        =   $3F     ;节目数据 Bank 索引 的 Bank 号
GAME_DATA_INDEX_ADDR        =   $A000   ;节目数据 Bank 索引 的 Bank 地址
;-------------------------------------------------
GAME_DATA_BANK              =   CUSTOM_DATA_BANK     ;最终切换数据所在Bank
GAME_DATA_ADDR              =   CUSTOM_DATA_ADDR    ;最终切换数据起始地址
GAME_SELECT_PROC_ADDR       =   $0400   ;切换节目地址
CHR_RAM_WRITE_PROC_ADDR     =   $0300   ;写入CHR-VRAM处理地址
SELECT_CLEAR_ADDR           =   $01E0   ;清除RAM代码地址
;=================================================

    .RSSET                  $20
;=================================================
FC_Game_Index_L             =   $01FE   ;节目索引低位
FC_Game_Index_H             =   $01FF   ;节目索引高位
;=================================================
FC_Game_Data_Tmp            .RS 1       ;临时缓冲数据
FC_Game_Data_Count          .RS 1       ;数据计数
FC_Game_Word_L              .RS 1       ;临时缓冲数据
FC_Game_Word_H              .RS 1       ;数据计数
FC_Game_Data_L              .RS 1       ;临时缓冲数据
FC_Game_Data_H              .RS 1       ;数据计数
;=================================================
;占用零页内存
Game_Chr_Size               .RS 1
Game_Flags                  .RS 1
;------------------------------------------------------------
CoolBoy_Reg_0_For_Chr       .RS 1
CoolBoy_Reg_1_For_Chr       .RS 1
CoolBoy_Reg_2_For_Chr       .RS 1
CoolBoy_Reg_3_For_Chr       .RS 1
;---------------------------------------------------------
CoolBoy_Reg_0_For_Prg       .RS 1
CoolBoy_Reg_1_For_Prg       .RS 1
CoolBoy_Reg_2_For_Prg       .RS 1
CoolBoy_Reg_3_For_Prg       .RS 1

;=================================================
;卡带寄存器
    .IF 1 = SUB_NUMBER
COOLBOY_REG_0               =   $5000
    .ENDIF
    .IF 0 = SUB_NUMBER
COOLBOY_REG_0               =   $6000
    .ENDIF

COOLBOY_REG_1               =   COOLBOY_REG_0 + 1
COOLBOY_REG_2               =   COOLBOY_REG_1 + 1
COOLBOY_REG_3               =   COOLBOY_REG_2 + 1
COOLBOY_REG_COUNT           =   4
;=================================================
;bank切页到8000-9FFF
Banking_Switch_8000
    PHA
    LDA #MAPPER_PRG_8000
    STA MAPPER_CTRL
    PLA
    STA MAPPER_DATA
    RTS

;=================================================
;bank切页到A000-BFFF
Banking_Switch_A000
    PHA
    LDA #MAPPER_PRG_A000
    STA MAPPER_CTRL
    PLA
    STA MAPPER_DATA
    RTS

;=================================================
;bank切页到C000-DFFF
Banking_Switch_C000
    RTS

;=================================================
;写入CHR-VRAM处理
Write_Vram_Proc
Write_Vram_Proc_Write
    LDA $8000,Y
    STA $2007
    INY
    BNE Write_Vram_Proc
    INC CHR_RAM_WRITE_PROC_ADDR + 2
    DEX
    BNE Write_Vram_Proc
    RTS
Write_Vram_Proc_End

;=================================================
;图案内存初始化
Mapper_VRAM_Init

    ;拷贝CHR-VRAM写入程序
    LDX #$00
.Select_Vram_Proc_Copy
    LDA Write_Vram_Proc,x
    STA CHR_RAM_WRITE_PROC_ADDR,X
    INX
    CPX #Write_Vram_Proc_End - Write_Vram_Proc
    BCC .Select_Vram_Proc_Copy
    
    LDA #CHR_DATA_BANK & BANK_DATA_MASK
    STA FC_Data_Temp
    LDA #$00
    STA FC_Data_Count
;--------------------------------------------------
;拷贝 CHR 数据 到 CHR-RAM
.Write_CHR_To_Vram
    LDA FC_Data_Temp
    JSR Banking_Switch_A000
    LDA #$A0
    STA CHR_RAM_WRITE_PROC_ADDR + 2

    LDA FC_Data_Count
    ASL A
    ASL A
    ASL A
    TAY
    JSR .Mapping_Vram_1000_1FFF_4K
    JSR .Write_Chr_Bank_To_Vram

    LDA FC_Data_Count
    ASL A
    ASL A
    ASL A
    CLC
    ADC #$04
    TAY
    JSR .Mapping_Vram_1000_1FFF_4K
    JSR .Write_Chr_Bank_To_Vram

    INC FC_Data_Temp   ;Bank号递增
    INC FC_Data_Count  ;计数器递增
    LDA FC_Data_Count  ;检查写入CHR Bank 数量
    CMP FC_Data_Index
    BCS .End
    JMP .Write_CHR_To_Vram
.End
    RTS

;-------------------------------------------------
.Mapping_Vram_1000_1FFF_4K
    LDX #$02
.Mapping_Vram_1000_1FFF_Bank
    STX MAPPER_CTRL
    STY MAPPER_DATA
    INX
    INY
    CPX #MAPPER_CHR_INDEX_COUNT
    BCC .Mapping_Vram_1000_1FFF_Bank
    RTS
;-------------------------------------------------
.Write_Chr_Bank_To_Vram
    LDA PPU_STATUS
    LDA #$10
    STA PPU_ADDRESS
    LDA #$00
    STA PPU_ADDRESS
    
    LDX #$10
    LDY #$00
    JSR CHR_RAM_WRITE_PROC_ADDR
    RTS

;=================================================
;获取节目数据所在bank
Get_Game_Config_From_Bank_Index
    LDA #$00
    STA FC_Game_Data_L
    STA FC_Game_Data_H
    
    .IF GAME_DATA_INDEX_ENABLE
    
        ;切换到存放配置bank号数据所在的bank
        LDA #GAME_DATA_INDEX_BANK & BANK_DATA_MASK
        JSR Banking_Switch_A000

        ;取到bank
        LDA FC_Game_Index_L
        CLC
        ADC #LOW(GAME_DATA_INDEX_ADDR)
        STA FC_Game_Data_L
        LDA FC_Game_Index_H
        ADC #HIGH(GAME_DATA_INDEX_ADDR)
        STA FC_Game_Data_H

    .ENDIF

    ;切换到节目数据所在bank
    LDY #$00
    LDA [FC_Game_Data_L],Y
    CLC
    ADC #GAME_DATA_BANK & BANK_DATA_MASK
    JSR Banking_Switch_A000

    ;得到起始
    LDA GAME_DATA_ADDR
    STA FC_Game_Word_L
    LDA GAME_DATA_ADDR + 1
    STA FC_Game_Word_H

    ;得到起始索引
    LDA FC_Game_Index_L
    SEC
    SBC FC_Game_Word_L
    STA FC_Game_Data_L
    
    LDA FC_Game_Index_H
    SBC FC_Game_Word_H
    STA FC_Game_Data_H

    ;索引地址左移1位
    ASL FC_Game_Data_L
    ROL FC_Game_Data_H

    ;得到配置数据起始地址
    LDA FC_Game_Data_L
    CLC
    ADC #LOW(GAME_DATA_ADDR) + 2
    STA FC_Game_Data_L
    LDA FC_Game_Data_H
    ADC #HIGH(GAME_DATA_ADDR)
    STA FC_Game_Data_H
    RTS

;=================================================
Get_Game_Config
    JSR Get_Game_Config_From_Bank_Index
    
    ;得到配置数据地址
    LDY #$00
    LDA [FC_Game_Data_L],Y
    PHA
    INY
    LDA [FC_Game_Data_L],Y
    STA FC_Game_Data_H
    PLA
    STA FC_Game_Data_L

    ;位组合标志
    LDY #$00
    LDA [FC_Game_Data_L],Y
    STA Game_Flags

    ;设置命名表镜像
    LDA Game_Flags
    AND #$01
    EOR #$01
    STA MAPPER_MIRRORING

    ;CHR大小
    INY
    LDA [FC_Game_Data_L],Y
    STA Game_Chr_Size

    ;CHR 8KB偏移 -> 16KB偏移
    LSR CoolBoy_Reg_0_For_Chr
    ROR CoolBoy_Reg_1_For_Chr
    INY

    ;最终CHR寄存器配置
    LDX #$00
.Get_Game_Chr_Config
    LDA [FC_Game_Data_L],Y
    STA CoolBoy_Reg_0_For_Chr,X
    INY
    INX
    CPX #COOLBOY_REG_COUNT
    BCC .Get_Game_Chr_Config
 
    ;最终PRG寄存器配置
    LDX #$00
.Get_Game_Prg_Config
    LDA [FC_Game_Data_L],Y
    STA CoolBoy_Reg_0_For_Prg,X
    INY
    INX
    CPX #COOLBOY_REG_COUNT
    BCC .Get_Game_Prg_Config
    RTS

;==================================================
;选择节目处理
Select_Game_Proc
    LDX #$00
.Rom_Select_Chr_Offset
    LDA CoolBoy_Reg_0_For_Chr,X
    STA COOLBOY_REG_0,X
    INX
    CPX #COOLBOY_REG_COUNT
    BCC .Rom_Select_Chr_Offset

    LDA #$00
    STA FC_Game_Data_Tmp
    STA FC_Game_Data_Count

;拷贝 CHR 数据 到 CHR-RAM
.Write_CHR_To_Vram
    LDA #$06
    STA MAPPER_CTRL

    ;如果8KB偏移地址是偶数, 则CHR-ROM从0开始, 否则从1开始, 因为8KB CHR的 ROM会组合成16KB放在一起
    LDA CoolBoy_Reg_3_For_Chr
    AND #%00001111
    CLC
    ADC FC_Game_Data_Tmp
    STA MAPPER_DATA

    LDA FC_Game_Data_Count
    ASL A
    ASL A
    ASL A
    TAY
.Mapping_Vram_0000_0FFF;设置PPU地址 $0000-$07FF, MMC3 8000写入$00,$01
    LDX #$00
    STX MAPPER_CTRL
    STY MAPPER_DATA ;0000-07FF
    INX
    INY
    INY
    STX MAPPER_CTRL
    STY MAPPER_DATA ;0800-0FFF
    INY
.Mapping_Vram_1000_1FFF;设置PPU地址 $1000-$1FFF, MMC3 8000写入$02,$03,$04,$05
    INX
    INY
    STX MAPPER_CTRL
    STY MAPPER_DATA ;1400-17FF
    CPX #$05
    BCC .Mapping_Vram_1000_1FFF

    LDA #$80
    STA CHR_RAM_WRITE_PROC_ADDR + 2

    LDA CoolBoy_Reg_3_For_Chr
    AND #%00010001
    CMP #%00010001
    BNE .Write_Game_Vram_From_8000

.Write_Game_Vram_From_A000
    LDA #$A0
    STA CHR_RAM_WRITE_PROC_ADDR + 2
.Write_Game_Vram_From_8000
    LDA Game_Chr_Size
    BEQ .Rom_Prg_Bank_Init
    LDA PPU_STATUS
    LDY #$00
    STY PPU_ADDRESS
    STY PPU_ADDRESS
    
    LDX #$20
    JSR CHR_RAM_WRITE_PROC_ADDR

    INC <FC_Game_Data_Tmp
    INC <FC_Game_Data_Count
    LDA FC_Game_Data_Count
    CMP <Game_Chr_Size
    BCC .Write_CHR_To_Vram
    
.Rom_Prg_Bank_Init;初始化 PRG Bank $8000-BFFF
    
    ;128KB耗费周期统计
    ;切页    2608: 163 * 16   = 0.087帧
    ;读写 1441792: (5 + 4 + 2) * 131072 = 48.40帧
    ;判断  393168: 3 * (131072 - 512) + 2 * 512 + 16 * 29 = 13.201帧
    ;粗略: 1837568: 61.698帧
    
    ;实测 128KB CHR 耗费周期1842515 61.85帧  1710611 57.435帧
    ;实测 256KB CHR 耗费周期3685027 123.73帧
    
    ;实测 128KB CHR 耗费周期: 1712083  57.48帧 之前 1842515  61.85帧, 节约4帧
    ;实测 128KB CHR 耗费周期: 3424163 114.97帧 之前 3685027 123.73帧, 节约9帧
    
    LDA #$06
    STA MAPPER_CTRL
    LDA #$00
    STA MAPPER_DATA
    LDA #$07
    STA MAPPER_CTRL
    LDA #$01
    STA MAPPER_DATA

.Rom_Chr_Bank_Init_0000_0FFF;初始化 CHR Bank $0000-0FFF
    LDX #$00
    LDY #$00
    STX MAPPER_CTRL
    STY MAPPER_DATA
    INX
    LDY #$02
    STX MAPPER_CTRL
    STY MAPPER_DATA
    
    LDY #$03
.Rom_Chr_Bank_Init_1000_1FFF;初始化 CHR Bank $1000-1FFF
    INX
    INY
    STX MAPPER_CTRL
    STY MAPPER_DATA
    CPX #$05
    BCC .Rom_Chr_Bank_Init_1000_1FFF
 
.Rom_Select_Prg_Offset
    LDX #$00
.Rom_Select_Prg_Offset_Set
    LDA CoolBoy_Reg_0_For_Prg,X
    STA COOLBOY_REG_0,X
    INX
    CPX #COOLBOY_REG_COUNT
    BCC .Rom_Select_Prg_Offset_Set

    ;启用 PRG RAM
    LDA #$80
    STA MAPPER_PRG_RAM_PROTECT
    
    JMP SELECT_CLEAR_ADDR
Select_Game_Proc_End

;=================================================
;选择节目后清理RAM处理
Clear_Ram_Proc
    LDX #$00
    TXA
.Write_Zero
    STA $00,X
    STA $0200,X
    STA $0300,X
    STA $0400,X
    STA $0500,X
    STA $0600,X
    STA $0700,X
    INX
    BNE .Write_Zero
    JMP [$FFFC]
Clear_Ram_Proc_End

;=================================================
;选择游戏
Select_Game
    LDA #$00
    STA PPU_CTRL
    LDA #$00
    STA PPU_MASK
.Nmi_Wait
    LDA PPU_STATUS
    BPL .Nmi_Wait

;清除调色板
.Palette_Clear
    LDA #$3F
    STA $2006
    LDA #$00
    STA $2006
    LDY #$20
    LDA #$0F
.Write_Pal_Data
    STA PPU_DATA
    DEY
    BNE .Write_Pal_Data
    
    ;拷贝选择节目的代码到内存
    LDX #$00
.Select_GameCopy
    LDA Select_Game_Proc,x
    STA GAME_SELECT_PROC_ADDR,X
    INX
    CPX #Select_Game_Proc_End - Select_Game_Proc
    BCC .Select_GameCopy
 
    ;清理切换节目端口
    LDA #$00
    LDX #$00
.Game_Temp_Reg_Clear
    STA CoolBoy_Reg_0_For_Chr,X
    STA CoolBoy_Reg_0_For_Prg,X
    INX
    CPX #08
    BCC .Game_Temp_Reg_Clear

    JSR Get_Game_Config

    ;拷贝选择节目后清理内存的代码到内存
    LDX #$00
.Select_Game_Ram_Clear_Copy
    LDA Clear_Ram_Proc,x
    STA SELECT_CLEAR_ADDR,X
    INX
    CPX #Clear_Ram_Proc_End - Clear_Ram_Proc
    BCC .Select_Game_Ram_Clear_Copy
    
    ;拷贝CHR-VRAM写入程序
    LDX #$00
.Select_Vram_Proc_Copy
    LDA Write_Vram_Proc,x
    STA CHR_RAM_WRITE_PROC_ADDR,X
    INX
    CPX #Write_Vram_Proc_End - Write_Vram_Proc
    BCC .Select_Vram_Proc_Copy
    
    LDX #$FF
    TXS
    JMP GAME_SELECT_PROC_ADDR

;==================================================
;PRG大小掩码

    .IF NES_16KB_PRG_SIZE >= $20
PRG_OFFSET      = 0
    .ELSE
PRG_OFFSET      = (($20 - NES_16KB_PRG_SIZE) >> 3)
    .ENDIF

PRG_MASK        = (($80 - NES_16KB_PRG_SIZE) >> 3)
CHR_256KB       = 1

    .IF CHR_256KB
CHR_MASK_256KB = 0
    .ELSE
CHR_MASK_256KB = 1
    .ENDIF

PRG_MASK_A20    = (PRG_MASK & $08) ^ $08
PRG_MASK_A19    = (PRG_MASK & $04) ^ $04
PRG_MASK_A18    = (PRG_MASK & $02) ^ $00
PRG_MASK_A17    = (PRG_MASK & $01) ^ $00

PRG_MASK_A18_A19_A20 = (PRG_MASK_A18 << 1) | (PRG_MASK_A19 >> 1) | (PRG_MASK_A20 >> 3)

PRG_OFFSET_A17 = ((PRG_OFFSET & $01) >> 0)
PRG_OFFSET_A18 = ((PRG_OFFSET & $02) >> 1)
PRG_OFFSET_A19 = ((PRG_OFFSET & $04) >> 2)
PRG_OFFSET_A20 = ((PRG_OFFSET & $08) >> 3)
PRG_OFFSET_A21 = ((PRG_OFFSET & $10) >> 4)

MULTICART_REG_0 = (CHR_MASK_256KB << 7) | (PRG_MASK_A17 << 6)  |  (PRG_OFFSET_A19 << 2)  |  (PRG_OFFSET_A18 << 1)  |  (PRG_OFFSET_A17 << 0)
MULTICART_REG_1 = (PRG_MASK_A18_A19_A20 << 5)  |  (PRG_OFFSET_A20 << 4)  |  (PRG_OFFSET_A21 << 2)
MULTICART_REG_2 = 0
MULTICART_REG_3 = 0

;=================================================
;CoolBoy 菜单大小重置
    .MACRO COOLBOY_SIZE_RESET
    
;==================================================
SWITCH_RAM_CODE_ADDR = $0400
;--------------------------------------------------
    .IF NES_16KB_PRG_SIZE  > 32
        .BANK $3F
    .ELSE
        .BANK FC_PRG_E000
    .ENDIF
    
    .ORG $FFA0

Reset_Ram_Program
    .DB MULTICART_REG_0
    .DB MULTICART_REG_1
    .DB MULTICART_REG_2
    .DB MULTICART_REG_3
    
    LDX #$00
.Write
    LDA SWITCH_RAM_CODE_ADDR,X
    STA COOLBOY_REG_0,X
    INX
    CPX #COOLBOY_REG_COUNT
    BCC .Write
    JMP Reset_Program
Reset_Ram_Program_End

Reset_Process_For_Coolgirl
    SEI
    CLD
    LDX #$00
    STX $2000
    STX $2001
.Write_Code_To_Ram
    LDA Reset_Ram_Program,X
    STA SWITCH_RAM_CODE_ADDR,X
    INX
    CPX #Reset_Ram_Program_End - Reset_Ram_Program
    BCC .Write_Code_To_Ram
    JMP SWITCH_RAM_CODE_ADDR + COOLBOY_REG_COUNT
    
    .ORG $FFFC
        .DW Reset_Process_For_Coolgirl

    .ENDM
