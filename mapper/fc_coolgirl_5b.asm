;=================================================
;Mapper寄存器
MAPPER_CHR_INDEX_COUNT      =   $08
;=================================================
GAME_DATA_INDEX_ENABLE      =   0       ;是否使用节目数据 Bank 索引
GAME_DATA_INDEX_BANK        =   $3F     ;节目数据 Bank 索引 的 Bank 号
GAME_DATA_INDEX_ADDR        =   $A000   ;节目数据 Bank 索引 的 Bank 地址
;-------------------------------------------------
GAME_DATA_BANK              =   CUSTOM_DATA_BANK     ;最终切换数据所在Bank
GAME_DATA_ADDR              =   CUSTOM_DATA_ADDR    ;最终切换数据起始地址
GAME_SELECT_PROC_ADDR       =   $0200   ;切换节目地址
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
Game_Chr_Offset_L           .RS 1
Game_Chr_Offset_H           .RS 1
Game_Chr_Size               .RS 1
Game_Flags                  .RS 1
;-------------------------------------------------
Coolgirl_Reg_5000_For_Chr   .RS 1
Coolgirl_Reg_5001_For_Chr   .RS 1
Coolgirl_Reg_5002_For_Chr   .RS 1
Coolgirl_Reg_5003_For_Chr   .RS 1
Coolgirl_Reg_5004_For_Chr   .RS 1
Coolgirl_Reg_5005_For_Chr   .RS 1
Coolgirl_Reg_5006_For_Chr   .RS 1
Coolgirl_Reg_5007_For_Chr   .RS 1
;-------------------------------------------------
Coolgirl_Reg_5000_For_Prg   .RS 1
Coolgirl_Reg_5001_For_Prg   .RS 1
Coolgirl_Reg_5002_For_Prg   .RS 1
Coolgirl_Reg_5003_For_Prg   .RS 1
Coolgirl_Reg_5004_For_Prg   .RS 1
Coolgirl_Reg_5005_For_Prg   .RS 1
Coolgirl_Reg_5006_For_Prg   .RS 1
Coolgirl_Reg_5007_For_Prg   .RS 1

;=================================================
;卡带寄存器
COOLGIRL_REG_5000           =   $5000
COOLGIRL_REG_5001           =   $5001
COOLGIRL_REG_5002           =   $5002
COOLGIRL_REG_5003           =   $5003
COOLGIRL_REG_5004           =   $5004
COOLGIRL_REG_5005           =   $5005
COOLGIRL_REG_5006           =   $5006
COOLGIRL_REG_5007           =   $5007
COOLGIRL_REG_COUNT          =   8
;=================================================
MAPPER_CODE                 =   %00011001
PRG_BANKING_MODE            =   %00000100
CHR_BANKING_MODE            =   %00000111
FLAG_CODE                   =   %00000000
;=================================================
;011001 Mapper 69 (Sunsoft FME-7)
;010100 Mapper 4,118,189,206
;Power-on/reset state: A=0, B=~2, C=~1, D=~0
; | Code | $8000 | $A000 | $E000 | $C000 | Notes                                    |
; | ==== + ===== + ===== + ===== + ===== + ======================================== |
; | 000  |       A       |       C       | UxROM, MMC4, MMC1 mode #3, etc.          |
; | ---- + ------------- + ------------- + ---------------------------------------- |
; | 001  |       C       |       A       | Mapper 97 (TAM-S1)                       |
; | ---- + ------------- + ------------- + ---------------------------------------- |
; | 010  |           Reserved            |                                          |
; | ---- + ----------------------------- + ---------------------------------------- |
; | 011  |           Reserved            |                                          |
; | ---- + ----- + ----- + ----- + ----- + ---------------------------------------- |
; | 100  |   A   |   B   |   C   |   D   | Universal, used by MMC3 mode 0, etc.     |
; | ---- + ----- + ----- + ----- + ----- + ---------------------------------------- |
; | 101  |   C   |   B   |   A   |   D   | MMC3 mode 1                              |
; | ---- + ----- + ----- + ----- + ----- + ---------------------------------------- |
; | 110  |               B               | Mapper 163                               |
; | ---- + ----------------------------- + ---------------------------------------- |
; | 111  |               A               | AxROM, MMC1 modes 0/1, Color Dreams      |
;Power-on/reset state: A=0, B=1, C=2, D=3, E=4, F=5, G=6, H=7
; | Code | $0000 | $0400 | $0800 | $0C00 | $1000 | $1400 | $1800 | $1C00 | Notes                                    |
; | ==== + ===== + ===== + ===== + ===== + ===== + ===== + ===== + ===== + ======================================== |
; | 000  |                               A                               | Used by many simple mappers              |
; | ---- + ------------------------------------------------------------- + ---------------------------------------- |
; | 001  |                          Special mode                         | Used by mapper 163                       |
; | ---- + ----- + ----- + ----- + ----- + ----- + ----- + ----- + ----- + ---------------------------------------- |
; | 010  |       A       |       C       |   E   |   F   |   G   |   H   | Used by MMC3 mode 0                      |
; | ---- + ----- + ----- + ----- + ----- + ----- + ----- + ----- + ----- + ---------------------------------------- |
; | 011  |   E   |   F   |   G   |   H   |       A       |       C       | Used by MMC3 mode 1                      |
; | ---- + ----- + ----- + ----- + ----- + ------------- + ------------- + ---------------------------------------- |
; | 100  |               A               |               E               | Used by MMC1                             |
; | ---- + ----------------------------- + ------------- + ------------- + ---------------------------------------- |
; | 101  |              A/B              |              E/F              | MMC2/MMC4, switched by tiles $FD or $FE  |
; | ---- + ------- ----- + ------------- + ------------- + ------------- + ---------------------------------------- |
; | 110  |       A       |       C       |       E       |       G       | Used by many complicated mappers         |
; | ---- + ----- + ----- + ----- + ----- + ----- + ----- + ----- + ----- + ---------------------------------------- |
; | 111  |   A   |   B   |   C   |   D   |   E   |  F    |   G   |   H   | Used by very complicated mappers         |

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
    PHA
    LDA #MAPPER_PRG_C000
    STA MAPPER_CTRL
    PLA
    STA MAPPER_DATA
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
    
    LDA #<CHR_DATA_ADDR
    STA CHR_RAM_WRITE_PROC_ADDR + 1
    
    LDA #>CHR_DATA_ADDR
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
    LDX #$04
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

    ;CHR 8KB偏移
    LDY #$00
.Get_Game_Chr_Config
    LDA [FC_Game_Data_L],Y
    STA Game_Chr_Offset_L
    STA Coolgirl_Reg_5001_For_Chr
    INY 
    LDA [FC_Game_Data_L],Y
    STA Game_Chr_Offset_H
    STA Coolgirl_Reg_5000_For_Chr

    ;CHR大小
    INY
    LDA [FC_Game_Data_L],Y
    STA Game_Chr_Size

    ;Flags
    INY
    LDA [FC_Game_Data_L],Y
    STA Game_Flags

    ;CHR 8KB偏移 -> 16KB偏移
    LSR Coolgirl_Reg_5000_For_Chr
    ROR Coolgirl_Reg_5001_For_Chr

    INY

    ;最终PRG寄存器配置
    LDX #$00
.Get_Game_Prg_Config
    LDA [FC_Game_Data_L],Y
    STA Coolgirl_Reg_5000_For_Prg,X
    INY
    INX
    CPX #COOLGIRL_REG_COUNT
    BCC .Get_Game_Prg_Config
    RTS

;=================================================
;选择节目处理
Select_Game_Proc
    LDX #$00
.Rom_Select_Chr_Offset
    LDA Coolgirl_Reg_5000_For_Chr,X
    STA COOLGIRL_REG_5000,X
    INX
    CPX #$06
    BCC .Rom_Select_Chr_Offset

    ;设置PRG切页模式
    LDA Coolgirl_Reg_5003_For_Chr
    AND #%00011111
    ORA #(PRG_BANKING_MODE << 5)
    STA COOLGIRL_REG_5003

    ;设置CHR切页模式
    LDA Coolgirl_Reg_5004_For_Chr
    AND #%00011111
    ORA #(CHR_BANKING_MODE << 5)
    STA COOLGIRL_REG_5004

    LDA #$00
    STA FC_Game_Data_Tmp
    STA FC_Game_Data_Count

;拷贝 CHR 数据 到 CHR-RAM
.Write_CHR_To_Vram
    LDA #MAPPER_PRG_8000
    STA MAPPER_CTRL

    ;如果8KB偏移地址是偶数, 则CHR-ROM从0开始, 否则从1开始, 因为8KB CHR的 ROM会组合成16KB放在一起
    LDA Game_Chr_Offset_L
    AND #%00000001
    CLC
    ADC FC_Game_Data_Tmp
    STA MAPPER_DATA

    LDA FC_Game_Data_Count
    ASL A
    ASL A
    ASL A
    TAY
    LDX #$00
    
;拷贝数据到VRAM $0000-$1FFF
.Mapping_Vram_0000_1FFF
    STX MAPPER_CTRL
    STY MAPPER_DATA
    INX
    INY
    CPX #MAPPER_CHR_INDEX_COUNT
    BCC .Mapping_Vram_0000_1FFF

    LDA #$80
    STA CHR_RAM_WRITE_PROC_ADDR + 2

    LDA Game_Chr_Size
    BEQ .Rom_Prg_Bank_Init
    LDA PPU_STATUS
    LDY #$00
    STY PPU_ADDRESS
    STY PPU_ADDRESS
    
    LDX #$20
    JSR CHR_RAM_WRITE_PROC_ADDR

    INC FC_Game_Data_Tmp
    INC FC_Game_Data_Count
    LDA FC_Game_Data_Count
    CMP Game_Chr_Size
    BCC .Write_CHR_To_Vram

;初始化 PRG Bank $8000-BFFF
.Rom_Prg_Bank_Init
    LDA #MAPPER_PRG_8000
    STA MAPPER_CTRL
    LDA #$00
    STA MAPPER_DATA
    
    LDA #MAPPER_PRG_A000
    STA MAPPER_CTRL
    LDA #$01
    STA MAPPER_DATA
    
    LDA #MAPPER_PRG_C000
    STA MAPPER_CTRL
    LDA #$FE
    STA MAPPER_DATA

;初始化 CHR Bank $0000-1FFF
    LDX #$00
    LDY #$00
.Rom_Chr_Bank_Init_0000_1FFF
    STX MAPPER_CTRL
    STY MAPPER_DATA
    INX
    INY
    CPX #MAPPER_CHR_INDEX_COUNT
    BCC .Rom_Chr_Bank_Init_0000_1FFF
 
.Rom_Select_Prg_Offset
    LDX #$00
.Rom_Select_Prg_Offset_Set
    LDA Coolgirl_Reg_5000_For_Prg,X
    STA COOLGIRL_REG_5000,X
    INX
    CPX #COOLGIRL_REG_COUNT
    BCC .Rom_Select_Prg_Offset_Set
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
    STA Coolgirl_Reg_5000_For_Chr,X
    STA Coolgirl_Reg_5000_For_Prg,X
    INX
    CPX #COOLGIRL_REG_COUNT
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
;$5xx0
; 7  bit  0
; ---- ----
; PPPP PPPP
; |||| ||||
; ++++-++++-- PRG base offset (A29-A22)
;$5xx1
; 7  bit  0
; ---- ----
; PPPP PPPP
; |||| ||||
; ++++-++++-- PRG base offset (A21-A14)
;$5xx2
; 7  bit  0
; ---- ----
; AMMM MMMM
; |||| ||||
; |+++-++++-- PRG mask (A20-A14, inverted+anded with PRG address)
; +---------- CHR mask (A18, inverted+anded with CHR address)
;$5xx3
; 7  bit  0
; ---- ----
; BBBC CCCC
; |||| ||||
; |||+-++++-- CHR bank A (bits 7-3)
; +++-------- PRG banking mode (see below)
;$5xx4
; 7  bit  0
; ---- ----
; DDDE EEEE
; |||| ||||
; |||+-++++-- CHR mask (A17-A13, inverted+anded with CHR address)
; +++-------- CHR banking mode (see below)
;$5xx5
; 7  bit  0
; ---- ----
; CDDE EEWW
; |||| ||||
; |||| ||++-- 8KiB WRAM page at $6000-$7FFF
; |+++-++---- PRG bank A (bits 5-1)
; +---------- CHR bank A (bit 8)
;$5xx6
; 7  bit  0
; ---- ----
; FFFM MMMM
; |||| ||||
; |||+ ++++-- Mapper code (bits 4-0, see below)
; +++-------- Flags 2-0, functionality depends on selected mapper
;$5xx7
; 7  bit  0
; ---- ----
; LMTR RSNO
; |||| |||+-- Enable WRAM (read and write) at $6000-$7FFF
; |||| ||+--- Allow writes to CHR RAM
; |||| |+---- Allow writes to flash chip
; |||+-+----- Mirroring (00=vertical, 01=horizontal, 10=1Sa, 11=1Sb)
; ||+-------- Enable four-screen mode
; |+-- ------ Mapper code (bit 5, see below)
; +---------- Lockout bit (prevent further writes to all registers)

;=================================================
MULTICART_REG_0 = %00000000
MULTICART_REG_1 = %00000000
MULTICART_REG_2 = (($80 - NES_16KB_PRG_SIZE) & $7F) | (($40 - NES_8KB_CHR_SIZE) & $1F)
MULTICART_REG_3 = (PRG_BANKING_MODE << 5)
MULTICART_REG_4 = (CHR_BANKING_MODE << 5)
MULTICART_REG_5 = %00000000
MULTICART_REG_6 = (MAPPER_CODE & %00011111)
MULTICART_REG_7 = %00000111 | ((MAPPER_CODE & %00100000) < 1)

;=================================================
;CoolGirl 菜单大小重置
    .MACRO COOLGIRL_SIZE_RESET
    
;==================================================
SWITCH_RAM_CODE_ADDR = $0400
;--------------------------------------------------
    .BANK $0F
    .ORG $FFA0
Reset_Ram_Program
    .DB MULTICART_REG_0
    .DB MULTICART_REG_1
    .DB MULTICART_REG_2
    .DB MULTICART_REG_3
    .DB MULTICART_REG_4
    .DB MULTICART_REG_5
    .DB MULTICART_REG_6
    .DB MULTICART_REG_7

    LDX #$00
.Write
    LDA SWITCH_RAM_CODE_ADDR,X
    STA COOLGIRL_REG_5000,X
    INX
    CPX #COOLGIRL_REG_COUNT
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
    JMP SWITCH_RAM_CODE_ADDR + COOLGIRL_REG_COUNT
    
    .ORG $FFFC
        .DW Reset_Process_For_Coolgirl
        
    .ENDM
