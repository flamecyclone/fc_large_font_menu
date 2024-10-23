;==================================================================================================
;ROM信息
NES_16KB_PRG_SIZE           =   32   ;16KB PRG大小数量
NES_8KB_CHR_SIZE            =   0   ;8KB CHR大小数量
FC_PRG_E000                 =   NES_16KB_PRG_SIZE * 2 - 1   ;最后一个 8KB bank
FC_PRG_C000                 =   NES_16KB_PRG_SIZE * 2 - 2   ;倒数第2个 8KB bank
;==================================================================================================
    .INCLUDE "tmp/list_info.asm"
ITEM_COUNT_MAX              =   Item_Text_Item_Count
;ITEM_COUNT_MAX              =   32                     ;项总数(1-65536)
ITEM_ORDINAL_BEGIN          =   001                    ;起始项序号

;--------------------------------------------------------------------------------------------------
ROM_MAPPER                  =   342 ;342: CoolGirl 268: CoolBoy
SUB_NUMBER                  =   0   ;子映射器号 0:  CoolBoy 1: MindKids
MAPPER_NUMBER               =   4   ;映射器号
;-------------------------------------------------
LIST_FIRST_IRQ_VALUE        =   40
LIST_TITLE_NEXT_VALUE       =   5
LIST_FIRST_NEXT_VALUE       =   14
;-------------------------------------------------

    .INCLUDE "tmp/list_info.asm"
NES_1KB_CHR_COUNT = Item_Text_Line_Count + 8

    .IF 0 == (NES_1KB_CHR_COUNT % 8)
NES_8KB_CHR_RAM_SIZE        =   NES_1KB_CHR_COUNT / 8      ;CHE 8KB 数据计数
    .ELSE
NES_8KB_CHR_RAM_SIZE        =   (NES_1KB_CHR_COUNT / 8) + 1        ;CHE 8KB 数据计数
    .ENDIF
;==================================================================================================
    .INCLUDE "fc_basic_config_music.asm"
;--------------------------------------------------------------------------------------------------
PRG_8K_BANK_MASK            =   NES_16KB_PRG_SIZE * 2 - 1
;--------------------------------------------------------------------------------------------------
FC_PPU_NT_ADDR              =   1  ;0: $0000 1: $1000
FC_PPU_SP_ADDR              =   0  ;0: $0000 1: $1000
FC_PPU_SP_SIZE              =   0  ;0: 8*8 1: 8*16
;--------------------------------------------------------------------------------------------------
BANK_DATA_MASK              =   PRG_8K_BANK_MASK
;======================================================================
    .IF 0 = NES_8KB_CHR_SIZE
    .IF FC_MUSIC_THEME > 0
CHR_DATA_BANK   =   $12
    .ELSE
CHR_DATA_BANK   =   $10
    .ENDIF
CHR_DATA_ADDR               =   $A000   ;CHR 图形数据位置
    .ELSE
CHR_DATA_BANK   =   NES_16KB_PRG_SIZE * 2
CHR_DATA_ADDR               =   $0000
    .ENDIF
    
;切换数据配置
CUSTOM_DATA_BANK            =   FC_PRG_E000 - 2     ;数据Bank页
CUSTOM_DATA_ADDR            =   $A000   ;数据起始地址

TEXT_DATA_BANK              =   CUSTOM_DATA_BANK - 1     ;数据Bank页
TEXT_DATA_ADDR              =   $8000   ;数据起始地址

LIST_INDEX_BANK             =   TEXT_DATA_BANK - 1    ;数据Bank页
LIST_INDEX_ADDR             =   $A000   ;数据起始地址

LIST_DATA_BANK              =   LIST_INDEX_BANK - 8    ;数据Bank页
LIST_DATA_ADDR              =   $A000   ;数据起始地址

;--------------------------------------------------------------------------------------------------
;Mapper号       名称      PRG 容量    CHR 容量        IRQ  扩展声音  PRG 窗口                
;--------------------------------------------------------------------------------------------------
;Mapper 1.0:    MMC1      PRG 256KB   CHR 128KB       No      No     PRG 16KB + 16KB(Fixed)        
;--------------------------------------------------------------------------------------------------
;Mapper 4.0:    MMC3      PRG 512KB   CHR 256KB       Yes     No     PRG 8KB * 2 + 16KB(Fixed)     
;--------------------------------------------------------------------------------------------------
;Mapper 5.0:    MMC5      PRG 1024KB  CHR 1024KB      Yes     Yes    PRG 8KB * 4                   
;--------------------------------------------------------------------------------------------------
;Mapper 9.0:    MMC2      PRG 128KB   CHR 128KB       No      No     PRG 8KB + 24KB(Fixed)         
;--------------------------------------------------------------------------------------------------
;Mapper 10.0:   MMC4      PRG 256KB   CHR 128KB       No      No     PRG 16KB + 16KB(Fixed)        
;--------------------------------------------------------------------------------------------------
;Mapper 19.0:   Namco 163 PRG 512KB   CHR 256KB       Yes     Yes    PRG 8KB * 3 + 8KB(Fixed)      
;--------------------------------------------------------------------------------------------------
;Mapper 21.0:   VRC4a     PRG 256KB   CHR 512KB       Yes     No     PRG 8KB * 2  + 16KB(Fixed)    
;Mapper 21.1:   VRC4a     PRG 256KB   CHR 512KB       Yes     No     PRG 8KB * 2  + 16KB(Fixed)    
;Mapper 21.2:   VRC4c     PRG 256KB   CHR 512KB       Yes     No     PRG 8KB * 2  + 16KB(Fixed)    
;--------------------------------------------------------------------------------------------------
;Mapper 22.0    VRC2a     PRG 256KB   CHR 256KB       No      No     PRG 8KB * 2  + 16KB(Fixed)    
;--------------------------------------------------------------------------------------------------
;Mapper 23.0:   VRC4e     PRG 256KB   CHR 512KB       Yes     No     PRG 8KB * 2  + 16KB(Fixed)    
;Mapper 23.1:   VRC4f     PRG 256KB   CHR 512KB       Yes     No     PRG 8KB * 2  + 16KB(Fixed)    
;Mapper 23.2:   VRC4e     PRG 256KB   CHR 512KB       Yes     No     PRG 8KB * 2  + 16KB(Fixed)    
;Mapper 23.3:   VRC2b     PRG 256KB   CHR 256KB       No      No     PRG 8KB * 2  + 16KB(Fixed)    
;--------------------------------------------------------------------------------------------------
;Mapper 25.0:   VRC4d     PRG 256KB   CHR 512KB       Yes     No     PRG 8KB * 2  + 16KB(Fixed)    
;Mapper 25.1:   VRC4b     PRG 256KB   CHR 512KB       Yes     No     PRG 8KB * 2  + 16KB(Fixed)    
;Mapper 25.2:   VRC4d     PRG 256KB   CHR 512KB       Yes     No     PRG 8KB * 2  + 16KB(Fixed)    
;Mapper 25.3:   VRC2c     PRG 256KB   CHR 256KB       No      No     PRG 8KB * 2  + 16KB(Fixed)    
;--------------------------------------------------------------------------------------------------
;Mapper 24.0    VRC6a     PRG 256KB   CHR 256KB       Yes     Yes    PRG 16KB + 8KB + 8KB(Fixed)   
;Mapper 26.0    VRC6b     PRG 256KB   CHR 256KB       Yes     Yes    PRG 16KB + 8KB + 8KB(Fixed)   
;--------------------------------------------------------------------------------------------------
;Mapper 69.0:   FME-7     PRG 512KB   CHR 256KB       Yes     Yes    PRG 8KB * 3 + 8KB(Fixed)      
;--------------------------------------------------------------------------------------------------
;Mapper 73.0:   VRC3      PRG 128KB   CHR 8KB         Yes     No     PRG 16KB + 16KB(Fixed)        
;--------------------------------------------------------------------------------------------------
;Mapper 75.0:   VRC1      PRG 128KB   CHR 128KB       No      No     PRG 8KB * 3 + 8KB(Fixed)      
;--------------------------------------------------------------------------------------------------
;Mapper 85.0:   VRC7      PRG 512KB   CHR 256KB       Yes     Yes    PRG 8KB * 3 + 8KB Fixed       
;==================================================================================================
    .IF (1 = MAPPER_NUMBER) | (10 = MAPPER_NUMBER) | (24 = MAPPER_NUMBER) | (26 = MAPPER_NUMBER) | (73 = MAPPER_NUMBER)
MAPPER_PRG_8KB_SUPPORT      =   0
    .ELSE
MAPPER_PRG_8KB_SUPPORT      =   1
    .ENDIF

    .IF 268 = ROM_MAPPER
    
    .IF NES_16KB_PRG_SIZE >= 32
ROM_16KB_PRG_SIZE = NES_16KB_PRG_SIZE
    .ELSE
ROM_16KB_PRG_SIZE = 32
    .ENDIF
    
    .ENDIF

    .IF 342 = ROM_MAPPER
ROM_16KB_PRG_SIZE = NES_16KB_PRG_SIZE
    .ENDIF

;==================================================================================================
;文件头信息
    .INESPRG NES_16KB_PRG_SIZE      ;16KB PRG 数量, $01-$EF8(1-3832),即16-61,312 KB
    .INESCHR NES_8KB_CHR_SIZE       ;8KB CHR 数量,$01-$EF8(1-3832),即0-30,656 KB
    .INESMAP ROM_MAPPER          ;Mapper号 (0-4095)
    .INESSUBMAP SUB_NUMBER                   ;子Mapper号 (0-15)
    .INESMIR 0                      ;命名表镜像 (0: 水平 1: 垂直 2: 四屏)
    .INESBAT 0                      ;指定是否存在电池备份 (0: 不存在 1: 存在)
    .INESPRGRAM 0                   ;指定 PRG RAM 大小 (大小 = 64字节 << 计数)
    .INESPRGNVRAM $0                 ;指定 PRG NVRAM 大小(大小 = 64字节 << 计数)
    .INESCHRRAM $0C                 ;指定 CHR RAM 大小(大小 = 64字节 << 计数)
    .INESCHRNVRAM 0                 ;指定 CHR NVRAM 大小(大小 = 64字节 << 计数)
    .INESTIM 0                      ;指定时序 (0: NTSC, 1: PAL, 2: 多区域, 3: Dendy)
;==================================================================================================
;文本列表翻页
ITEM_INDEX_MAX              =   ITEM_COUNT_MAX - 1      ;项最大索引(0-65535)
ITEM_PAGE_ROW               =   10                      ;每页行数(1-20)
ITEM_PAGE_COLUMN            =   1                       ;每页列数(1-5)
ITEM_ORDINAL_LENGTH         =   4                       ;文本序号长度(1-5)
ITEM_ORDINAL_DOT            =   1                       ;序号后点号
LIST_ITEM_POS               =   $20C3                   ;列表显示位置
LIST_ITEM_LINE_SPACING      =   1                       ;列表空行(0-2)
LIST_TEXT_CHR_BEGIN         =   5
PPU_PAL_BUFFER_ENABLE       =   0                       ;启用调色板缓冲
;-------------------------------------------------
;节目名滚动配置
ITEM_NAME_SCROLL_ENGTH      =   24                      ;文本滚动长度
ITEM_NAME_SCROLL_SPEED      =   10                      ;节目名滚动速度
ITEM_NAME_SCROLL_DELAY      =   30                      ;文本滚动延迟
ITEM_PAGE_BUFFER_SIZE       =   1                       ;每页刷新项缓冲数量(1-4)
TEXT_SCROLL_IRQ_ENABLE      =   1                       ;启用文本滚动IRQ
;-------------------------------------------------
;按键连发配置
FC_GAMEPAD_BURST_TIME       =   20      ;连发触发帧数
FC_GAMEPAD_BURST_INTERVAL   =   00      ;连发间隔帧数
;-------------------------------------------------
;光标配置
ITEM_CURSOR_TILE_ID_X       =   $EF
ITEM_CURSOR_ATTR_PAL        =   0   ;调色板索引(0-3)
ITEM_CURSOR_ATTR_BACK       =   0   ;后台显示
ITEM_CURSOR_ATTR_H_FLIP     =   0   ;水平翻转
ITEM_CURSOR_ATTR_V_FLIP     =   0   ;垂直翻转
ITEM_CURSOR_OFFSET_X        =   -2   ;水平偏移
ITEM_CURSOR_OFFSET_Y        =   4   ;垂直偏移
;-------------------------------------------------
;每页项数量
ITEM_PAGE_SIZE              =   ITEM_PAGE_ROW *  ITEM_PAGE_COLUMN

    .IF 0 = (ITEM_COUNT_MAX % ITEM_PAGE_SIZE)
PAGE_INDEX_MAX              =   ((ITEM_COUNT_MAX / ITEM_PAGE_SIZE) - 1) * ITEM_PAGE_SIZE
    .ELSE
    
    .IF 0 = (ITEM_COUNT_MAX / ITEM_PAGE_SIZE)
PAGE_INDEX_MAX              =   0
    .ELSE
PAGE_INDEX_MAX              =   ((ITEM_COUNT_MAX / ITEM_PAGE_SIZE)) * ITEM_PAGE_SIZE
    .ENDIF
    
    .ENDIF

;最后一页列数项起始索引
    .IF 0 = (ITEM_COUNT_MAX % ITEM_PAGE_SIZE)
    
    .IF ITEM_COUNT_MAX < ITEM_PAGE_ROW
PAGE_LAST_COLUMN_INDEX_MAX       =   0
    .ELSE
PAGE_LAST_COLUMN_INDEX_MAX       =   ((ITEM_COUNT_MAX / ITEM_PAGE_ROW) - 1) * ITEM_PAGE_ROW
    .ENDIF

    .ELSE
PAGE_LAST_COLUMN_INDEX_MAX       =   (ITEM_COUNT_MAX / ITEM_PAGE_ROW) * ITEM_PAGE_ROW
    .ENDIF

;=================================================
;零页内存分配
Use_Zero_Page_Begin         =   $40
    .RSSET  Use_Zero_Page_Begin
;=================================================
FC_Data_Index_L             .RS 1
FC_Data_Index_H             .RS 1
FC_Data_Addr_L              .RS 1
FC_Data_Addr_H              .RS 1
FC_Irq_Addr_L               .RS 1
FC_Irq_Addr_H               .RS 1
FC_Data_Count               .RS 1
FC_Data_Index               .RS 1
FC_Data_Temp                .RS 1
;-------------------------------------------------
;文本滚动
FC_Text_Info_Index_L        .RS 1       ;文本信息索引低位
FC_Text_Info_Index_H        .RS 1       ;文本信息索引高位
FC_Text_Item_Addr_L         .RS 1       ;文本数据地址低位
FC_Text_Item_Addr_H         .RS 1       ;文本数据地址高位
FC_Data_Count_L             .RS 1       ;数据计数用
FC_Data_Count_H             .RS 1       ;数据计数用
;-------------------------------------------------
Use_Zero_Page_End           .RS 1

    .RSSET  $200
OAM_DMA_Buffer              .RS $100
;=================================================
    .RSSET  $300
;-------------------------------------------------
FC_PPU_Buf_Addr             .RS $A0     ;PPU数据缓冲地址
FC_PPU_Pal_Addr             .RS $20     ;PPU调色板缓冲地址
FC_ATTRIBUTES_BUF_SIZE      =   $12     ;PPU属性缓冲大小

FC_PPU_Attr_Read_Buf        .RS FC_ATTRIBUTES_BUF_SIZE ;PPU属性读缓冲地址
FC_PPU_Attr_AND_Buf         .RS FC_ATTRIBUTES_BUF_SIZE ;PPU属性与运算缓冲地址
FC_PPU_Attr_ORA_Buf         .RS FC_ATTRIBUTES_BUF_SIZE ;PPU属性或运算缓冲地址
FC_PPU_Attr_LT_Buf          .RS 1
FC_PPU_Attr_RT_Buf          .RS 1
FC_PPU_Attr_LB_Buf          .RS 1
FC_PPU_Attr_RB_Buf          .RS 1
;=================================================
;非零页内存分配
Use_Non_Zero_Page_Begin     =   $400
;=================================================
;PPU操作内存分配
    .RSSET  Use_Non_Zero_Page_Begin
FC_PPU_Ctrl                 .RS 1       ;PPU控制缓冲
FC_PPU_Mask                 .RS 1       ;PPU掩码缓冲
FC_PPU_H_Scroll             .RS 1       ;PPU水平滚动缓冲
FC_PPU_V_Scroll             .RS 1       ;PPU垂直滚动缓冲
FC_PPU_Buf_Count            .RS 1       ;PPU数据缓冲待处理数据量
FC_NMI_Level                .RS 1       ;NMI 递归层级
FC_DMA_Count                .RS 1
FC_NMI_Time_Delay           .RS 1
FC_NMI_Time_Count           .RS 1
;-------------------------------------------------
FC_NMI_Task_Flag            .RS 1       ;NMI 任务标记

FC_NMI_TASK_PAGING          =   %10000000   ;翻页中
FC_NMI_TASK_ATTR            =   %01000000   ;属性表更新中
FC_NMI_TASK_BUF_READY       =   %00100000   ;翻页缓存准备完毕

;-------------------------------------------------
;PRG 8KB Bank 备份
FC_Music_Prg_8000           .RS 1
FC_Music_Prg_A000           .RS 1
FC_Music_Prg_C000           .RS 1
FC_Music_Prg_E000           .RS 1
FC_Prg_8000                 .RS 1
FC_Prg_A000                 .RS 1
FC_Prg_C000                 .RS 1
FC_Prg_E000                 .RS 1
FC_Music_DMC_Offset         .RS 1
;=================================================
;手柄输入内存分配
FC_GAMEPAD_COUNT            =   2       ;输入设备数量
FC_Gamepad_Keep             .RS FC_GAMEPAD_COUNT       ;按住状态
FC_Gamepad_Once_Down        .RS FC_GAMEPAD_COUNT       ;单次按下
FC_Gamepad_Keep_Last        .RS FC_GAMEPAD_COUNT       ;上次按住状态
FC_Gamepad_Once_Up          .RS FC_GAMEPAD_COUNT       ;单次弹起
FC_Gamepad_Temp             .RS FC_GAMEPAD_COUNT       ;按键缓冲
FC_Gamepad_Buf              .RS FC_GAMEPAD_COUNT       ;按键缓冲
FC_Gamepad_Status           .RS FC_GAMEPAD_COUNT       ;按键读取状态
FC_Gamepad_Burst_Delay      .RS FC_GAMEPAD_COUNT       ;按键连发延迟
;=================================================
FC_Mapper_Control           .RS 1       ;Mapper 占用
;=================================================
;IRQ内存分配
FC_Irq_Latch_L              .RS 1       ;IRQ 扫描线触发值(仅扫描线模式)  /  ;IRQ 触发值低位(仅CPU周期模式)
FC_Irq_Latch_H              .RS 1       ;IRQ 触发值高位(仅CPU周期模式)
FC_Irq_Interval_L           .RS 1       ;IRQ 触发间隔低位
FC_Irq_Interval_H           .RS 1       ;IRQ 触发间隔高位
FC_Irq_Index                .RS 1       ;IRQ 操作索引
FC_Irq_Scroll               .RS 1       ;IRQ 发生时设置 PPU 的滚动值
;=================================================
FC_Music_Index              .RS 1       ;曲目
FC_Music_Index_Max          .RS 1       ;最大曲目索引
FC_Char_Offset              .RS 1
FC_Hex_Data_L               .RS 1       ;十六进制数据低位
FC_Hex_Data_H               .RS 1       ;十六进制数据高位
FC_Dec_Data_1               .RS 1
FC_Dec_Data_10              .RS 1
FC_Dec_Data_100             .RS 1
FC_Dec_Data_1000            .RS 1
FC_Dec_Data_10000           .RS 1
;=================================================
;文本列表翻页
FC_Item_Index_L             .RS 1       ;当前索引低位
FC_Item_Index_H             .RS 1       ;当前索引高位
FC_Item_Index_Last_L        .RS 1       ;上次索引低位
FC_Item_Index_Last_H        .RS 1       ;上次索引高位
FC_Page_Index_L             .RS 1       ;当前页起始索引低位
FC_Page_Index_H             .RS 1       ;当前页起始索引高位
FC_Page_Index_Last_L        .RS 1       ;上次页起始索引低位
FC_Page_Index_Last_H        .RS 1       ;上次页起始索引高位
FC_Temp_Src_Index_L         .RS 1       ;临时索引低位
FC_Temp_Src_Index_H         .RS 1       ;临时索引高位
FC_Temp_Dest_Index_L        .RS 1       ;临时索引低位
FC_Temp_Dest_Index_H        .RS 1       ;临时索引高位
FC_Page_Item_Index          .RS 1       ;页面项索引
FC_Page_Item_Buffer         .RS 1       ;页面项缓冲
FC_Page_Row_Index           .RS 1       ;行索引
FC_Page_Column_Index        .RS 1       ;列索引
FC_Page_Row_Index_Last      .RS 1       ;上次行索引
FC_Page_Column_Index_Last   .RS 1       ;上次列索引
FC_Cursor_Index             .RS 1       ;当前光标索引
FC_Cursor_Index_Last        .RS 1       ;上次光标索引
FC_Page_Cursor_Index        .RS 1       ;页面光标索引
;-------------------------------------------------
;文本滚动
FC_Data_Buf                 .RS 1       ;数据缓冲用
FC_Data_Length              .RS 1
FC_Data_Result              .RS 1
FC_Item_Name_Length         .RS 1
FC_Item_Name_Scroll         .RS 1
FC_Item_Name_Delay          .RS 1
FC_Scroll_Speed_Delay       .RS 1
;-------------------------------------------------
FC_Chr_Index                .RS ITEM_PAGE_ROW   ;CHR缓冲
FC_Chr_Index_Last           .RS ITEM_PAGE_ROW   ;上次CHR缓冲
FC_Chr_Index_Ready          .RS ITEM_PAGE_ROW   ;CHR缓冲准备就绪
;=================================================
Use_Non_Zero_Page_End       .RS 1

;=================================================
;常量定义
;-------------------------------------------------
;PPU缓冲处理模式
FC_PPU_MODE_LINE            =   $FE     ;单行文本写入模式
FC_PPU_MODE_CLEAR           =   $FD     ;单行文本清理模式
FC_PPU_MODE_ATTR            =   $FC     ;命名表属性替换模式
FC_PPU_CHAR_NULL            =   $40
;-------------------------------------------------
;手柄按键常量
JOY_KEY_UP                  =   $08     ;上
JOY_KEY_DOWN                =   $04     ;下
JOY_KEY_LEFT                =   $02     ;左
JOY_KEY_RIGHT               =   $01     ;右
JOY_KEY_SELECT              =   $20     ;选择
JOY_KEY_START               =   $10     ;开始
JOY_KEY_B                   =   $40     ;B
JOY_KEY_A                   =   $80     ;A

;=================================================
;文本数据位置索引常量
TEXT_INFO_INDEX_FLAG        =   0   ;文本显示控制偏移
TEXT_INFO_INDEX_POS_L       =   1   ;文本显示地址偏移
TEXT_INFO_INDEX_POS_H       =   2   ;文本显示地址偏移
TEXT_INFO_INDEX_DATA        =   3   ;文本数据地址偏移
