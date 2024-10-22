
;==================================================
;通过PPU缓冲方式写入文本并指定文本起始字符和显示宽度
;--------------------------------------------------
;前提: 需要先设置滚动所需参数
;参数1    FC_Data_Index_L 文本显示地址低位
;参数2    FC_Data_Index_H 文本显示地址高位
;参数3    FC_Data_Addr_L  文本数据地址低位
;参数4    FC_Data_Addr_H  文本数据地址高位
;参数5    FC_Data_Count_L 滚动计数器地址低位
;参数6    FC_Data_Count_H 滚动计数器地址高位
;参数7    FC_Data_Count   滚动区域字符宽度(0-128)
;--------------------------------------------------
;返回1    FC_Data_Result  滚动结束则 FC_Data_Result = 1
;--------------------------------------------------
;例如
;   LDA #>$2080
;   STA FC_Data_Index_H
;   LDA #<$2080
;   STA FC_Data_Index_L
;   
;   LDA #<Text_Scroll_Data
;   STA FC_Data_Addr_L
;   LDA #>Text_Scroll_Data
;   STA FC_Data_Addr_H
;
;   LDA #<$80
;   STA FC_Data_Count_L
;   LDA #>$80
;   STA FC_Data_Count_H
;   
;   LDA #64
;   STA FC_Data_Count
;   
;   JSR PPU_Write_Text_Buf_By_Scroll_Index
;--------------------------------------------------
PPU_Write_Text_Buf_By_Scroll_Index
    LDA FC_Data_Count
    BEQ .End
    
    LDA FC_Data_Index
    PHA
    
    LDY #$00
    LDA [FC_Data_Count_L],Y
    STA FC_Data_Index
    
    ;获取文本长度
    LDY #$00
    LDA [FC_Data_Addr_L],Y
    STA FC_Data_Length
    
    ;检查重置起始显示字符
    LDA #$00
    STA FC_Data_Result
    
    LDA FC_Data_Length
    CLC
    ADC FC_Data_Count
    BCS .Text_Index_Reset_End
    CMP FC_Data_Index
    BCS .Text_Index_Reset_End
.Text_Index_Reset
    LDA #$00
    STA FC_Data_Index
    LDA #$01
    STA FC_Data_Result
    PLA
    STA FC_Data_Index
    RTS
.Text_Index_Reset_End

    LDX FC_PPU_Buf_Count
    
    LDA #FC_PPU_MODE_LINE
    STA FC_PPU_Buf_Addr,X
    INX
    
    ;设置PPU地址高位
    LDA FC_Data_Index_H
    STA FC_PPU_Buf_Addr,X
    INX

    ;设置PPU地址低位
    LDA FC_Data_Index_L
    STA FC_PPU_Buf_Addr,X
    INX
    
    ;设置PPU显示字符数量
    LDA FC_Data_Count
    STA FC_PPU_Buf_Addr,X
    INX
    
    JSR .Write_Scroll_Text_Buf
    STX FC_PPU_Buf_Count
    INC FC_Data_Index
    
    LDY #$00
    LDA FC_Data_Index
    STA [FC_Data_Count_L],Y
    
    PLA
    STA FC_Data_Index
    
.End
    RTS

;--------------------------------------------------
;滚动文本缓冲
.Write_Scroll_Text_Buf
    LDA FC_Data_Count
    STA FC_Data_Buf
    
    ;检查是否需要在文本前填充空字符
    LDA FC_Data_Index
    CMP FC_Data_Count
    BCS .Write_Text_Begin

    ;获取文本前填充字符数量
    LDA FC_Data_Count
    SEC
    SBC FC_Data_Index
    TAY
    
    ;填充空字符
    LDA #FC_PPU_CHAR_NULL
.Write_Empty_Data
    STA FC_PPU_Buf_Addr,X
    INX
    DEC FC_Data_Buf
    DEY
    BNE .Write_Empty_Data

;开始写入文本
.Write_Text_Begin
    LDA FC_Data_Index
    CMP FC_Data_Count
    BCS .Write_Update_Data_Index
    LDA #$00
    BEQ .Write_Start
.Write_Update_Data_Index
    SEC
    SBC FC_Data_Count
.Write_Start
    TAY
    INY
    
    LDA FC_Data_Buf
    BEQ .Write_End
    
    INC FC_Data_Length
    
.Write_Text_Data
    CPY FC_Data_Length
    BCC .Write_Text_Char_Data

    ;尾部补上空字符
    LDA #FC_PPU_CHAR_NULL
    LDY FC_Data_Buf
.Write_Empty_Char
    STA FC_PPU_Buf_Addr,X
    INX
    DEY
    BNE .Write_Empty_Char
    RTS
    
    ;写入文本字符
.Write_Text_Char_Data
    LDA [FC_Data_Addr_L],Y
.Write_Text_Set_Data
    JSR Get_Char_Data_Up
    CLC
    ADC FC_Char_Offset
    STA FC_PPU_Buf_Addr,X
    INX
    INY
    DEC FC_Data_Buf
    BNE .Write_Text_Data
.Write_End
    RTS

;==================================================
;获取文本长度
Get_Item_Text_Lenght
    SEC
    LDA FC_Item_Index_L
    SBC FC_Page_Index_L
    STA FC_Page_Item_Index
    JSR Page_List_Get_Cur_Item_Text_Addr
    LDY #$00
    LDA [FC_Data_Addr_L],Y
    RTS

;==================================================
;获取文本数据位置
Get_Item_Text_Addr
    SEC
    LDA FC_Item_Index_L
    SBC FC_Page_Index_L
    STA FC_Page_Item_Index
    JSR Page_List_Get_Cur_Item_Text_Addr
    RTS

;==================================================
;获取显示位置
Get_Item_Show_Pos
    
    SEC
    LDA FC_Item_Index_L
    SBC FC_Page_Index_L
    STA FC_Data_Index_L
    LDA FC_Item_Index_H
    SBC FC_Page_Index_H
    STA FC_Data_Index_H
    
    ASL FC_Data_Index_L
    ROL FC_Data_Index_H

    CLC
    LDA FC_Data_Index_L
    ADC #<Page_List_Item_Pos
    STA FC_Data_Index_L
    
    LDA FC_Data_Index_H
    ADC #>Page_List_Item_Pos
    STA FC_Data_Index_H
    
    LDY #$00
    LDA [FC_Data_Index_L],Y
    PHA
    INY
    LDA [FC_Data_Index_L],Y
    STA FC_Data_Index_H
    PLA
    CLC
    ADC #(ITEM_ORDINAL_LENGTH + ITEM_ORDINAL_DOT)
    STA FC_Data_Index_L
    RTS

;==================================================
;滚动节目文本
Scroll_Item_Name_Text
    
    ;获取文本数据
    JSR Get_Item_Text_Addr
    
    ;获取显示位置
    JSR Get_Item_Show_Pos
    
    ;设置显示宽度
    LDA #ITEM_NAME_SCROLL_ENGTH
    STA FC_Data_Count
    
    ;设置滚动计数器地址
    LDA #<FC_Item_Name_Scroll
    STA FC_Data_Count_L
    LDA #>FC_Item_Name_Scroll
    STA FC_Data_Count_H
    
    LDA FC_Char_Offset
    PHA
    
    LDA FC_Item_Name_Scroll
    PHA
    LDA #$00
    STA FC_Char_Offset
    JSR PPU_Write_Text_Buf_By_Scroll_Index
    
    PLA
    STA FC_Item_Name_Scroll
    
    ;获取显示位置
    JSR Get_Item_Show_Pos
    
    LDA FC_Data_Index_L
    CLC
    ADC #$20
    STA FC_Data_Index_L
    LDA FC_Data_Index_H
    ADC #$00
    STA FC_Data_Index_H
    
    ;设置滚动计数器地址
    LDA #<FC_Item_Name_Scroll
    STA FC_Data_Count_L
    LDA #>FC_Item_Name_Scroll
    STA FC_Data_Count_H
    
    LDA #$10
    STA FC_Char_Offset
    JSR PPU_Write_Text_Buf_By_Scroll_Index
    
    PLA
    STA FC_Char_Offset

.End
    RTS

;==============================
;重置节目名滚动
Reset_Item_Name_Scroll
    LDA #ITEM_NAME_SCROLL_DELAY
    STA FC_Item_Name_Delay
    LDA #ITEM_NAME_SCROLL_ENGTH
    STA FC_Item_Name_Scroll
    RTS
    
;==================================================
;项名称滚动
Item_Name_Scroll
    LDA FC_PPU_Mask
    BEQ .End
    LDA FC_Item_Name_Delay
    BEQ .Delay_Check
    DEC FC_Item_Name_Delay
    RTS
.Delay_Check
    LDA FC_Scroll_Speed_Delay
    BEQ .Scroll_Start
    DEC FC_Scroll_Speed_Delay
    RTS
.Scroll_Start

    LDA FC_NMI_Task_Flag
    AND #FC_NMI_TASK_PAGING
    BNE .End
    
    LDA #ITEM_NAME_SCROLL_SPEED
    STA FC_Scroll_Speed_Delay

    JSR Get_Item_Text_Lenght
    STA FC_Item_Name_Length
    
    LDA FC_Item_Name_Length
    CMP #ITEM_NAME_SCROLL_ENGTH
    BEQ .Scroll_End
    BCC .Scroll_End
    
    JSR Scroll_Item_Name_Text
    LDA FC_Data_Result
    BEQ .Scroll_End
    
    LDA #ITEM_NAME_SCROLL_ENGTH
    STA FC_Item_Name_Scroll
    LDA #ITEM_NAME_SCROLL_DELAY
    STA FC_Item_Name_Delay
    JSR Scroll_Item_Name_Text
    
.Scroll_End

.End
    RTS
    