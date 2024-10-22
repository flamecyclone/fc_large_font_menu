;======================================================================
;页文本列表项显示位置
Page_List_Item_Pos
    .DW (LIST_ITEM_POS & $23E0)+(($20*(LIST_ITEM_LINE_SPACING+1))*00 + (LIST_ITEM_POS & $1F))
    .DW (LIST_ITEM_POS & $23E0)+(($20*(LIST_ITEM_LINE_SPACING+1))*01 + (LIST_ITEM_POS & $1F))
    .DW (LIST_ITEM_POS & $23E0)+(($20*(LIST_ITEM_LINE_SPACING+1))*02 + (LIST_ITEM_POS & $1F))
    .DW (LIST_ITEM_POS & $23E0)+(($20*(LIST_ITEM_LINE_SPACING+1))*03 + (LIST_ITEM_POS & $1F))
    .DW (LIST_ITEM_POS & $23E0)+(($20*(LIST_ITEM_LINE_SPACING+1))*04 + (LIST_ITEM_POS & $1F))
    .DW (LIST_ITEM_POS & $23E0)+(($20*(LIST_ITEM_LINE_SPACING+1))*05 + (LIST_ITEM_POS & $1F))
    .DW (LIST_ITEM_POS & $23E0)+(($20*(LIST_ITEM_LINE_SPACING+1))*06 + (LIST_ITEM_POS & $1F))
    .DW (LIST_ITEM_POS & $23E0)+(($20*(LIST_ITEM_LINE_SPACING+1))*07 + (LIST_ITEM_POS & $1F))
    .DW (LIST_ITEM_POS & $23E0)+(($20*(LIST_ITEM_LINE_SPACING+1))*08 + (LIST_ITEM_POS & $1F))
    .DW (LIST_ITEM_POS & $23E0)+(($20*(LIST_ITEM_LINE_SPACING+1))*09 + (LIST_ITEM_POS & $1F))

    .DW (LIST_ITEM_POS & $23E0)+(($20*(LIST_ITEM_LINE_SPACING+1))*00 + 17)
    .DW (LIST_ITEM_POS & $23E0)+(($20*(LIST_ITEM_LINE_SPACING+1))*01 + 17)
    .DW (LIST_ITEM_POS & $23E0)+(($20*(LIST_ITEM_LINE_SPACING+1))*02 + 17)
    .DW (LIST_ITEM_POS & $23E0)+(($20*(LIST_ITEM_LINE_SPACING+1))*03 + 17)
    .DW (LIST_ITEM_POS & $23E0)+(($20*(LIST_ITEM_LINE_SPACING+1))*04 + 17)
    .DW (LIST_ITEM_POS & $23E0)+(($20*(LIST_ITEM_LINE_SPACING+1))*05 + 17)
    .DW (LIST_ITEM_POS & $23E0)+(($20*(LIST_ITEM_LINE_SPACING+1))*06 + 17)
    .DW (LIST_ITEM_POS & $23E0)+(($20*(LIST_ITEM_LINE_SPACING+1))*07 + 17)
    .DW (LIST_ITEM_POS & $23E0)+(($20*(LIST_ITEM_LINE_SPACING+1))*08 + 17)
    .DW (LIST_ITEM_POS & $23E0)+(($20*(LIST_ITEM_LINE_SPACING+1))*09 + 17)
    
;======================================================================
;写入文本PPU位置
Page_List_Item_Pos_Write
    LDA FC_Page_Item_Index
    STA FC_Data_Index_L
    LDA #$00
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
    
    RTS

;======================================================================
;获取文本数据所在Bank
Page_List_Get_Item_Text_Bank
    LDA FC_Prg_A000
    PHA
    LDA #BANK(Item_Text_Data_Bank_Index)
    JSR Mapper_Prg_A000_Banking
    
    CLC
    LDA FC_Data_Index_L
    ADC #<Item_Text_Data_Bank_Index
    STA FC_Data_Index_L
    
    LDA FC_Data_Index_H
    ADC #>Item_Text_Data_Bank_Index
    STA FC_Data_Index_H
    
    LDY #$00
    LDA [FC_Data_Index_L],Y
    CLC
    ADC #LIST_DATA_BANK
    STA FC_Data_Addr_L
    
    PLA
    JSR Mapper_Prg_A000_Banking
    
    RTS

;======================================================================
;获取节目名所在Bank
Page_List_Get_Last_Item_Text_Bank
    CLC
    LDA FC_Page_Item_Index
    ADC FC_Page_Index_Last_L
    STA FC_Data_Index_L
    LDA #$00
    ADC FC_Page_Index_Last_H
    STA FC_Data_Index_H
    
    JMP Page_List_Get_Item_Text_Bank
    
;======================================================================
;获取节目名所在Bank
Page_List_Get_Cur_Item_Text_Bank
    CLC
    LDA FC_Page_Item_Index
    ADC FC_Page_Index_L
    STA FC_Data_Index_L
    LDA #$00
    ADC FC_Page_Index_H
    STA FC_Data_Index_H
    JMP Page_List_Get_Item_Text_Bank
    
;======================================================================
;获取文本数据位置
Page_List_Get_Item_Text_Addr
    SEC
    LDA FC_Data_Index_L
    SBC LIST_DATA_ADDR + 0
    STA FC_Data_Index_L
    LDA FC_Data_Index_H
    SBC LIST_DATA_ADDR + 1
    STA FC_Data_Index_H
    
    ASL FC_Data_Index_L
    ROL FC_Data_Index_H
    
    CLC
    LDA FC_Data_Index_L
    ADC #<LIST_DATA_ADDR + 2
    STA FC_Data_Addr_L
    LDA FC_Data_Index_H
    ADC #>LIST_DATA_ADDR + 0
    STA FC_Data_Addr_H
    
    LDY #$00
    LDA [FC_Data_Addr_L],Y
    PHA
    INY
    LDA [FC_Data_Addr_L],Y
    STA FC_Data_Addr_H
    PLA
    STA FC_Data_Addr_L
    
    RTS

;======================================================================
;获取上次文本数据位置
Page_List_Get_Last_Item_Text_Addr
    JSR Page_List_Get_Last_Item_Text_Bank
    LDA FC_Data_Addr_L
    JSR Mapper_Prg_A000_Banking

    CLC
    LDA FC_Page_Item_Index
    ADC FC_Page_Index_Last_L
    STA FC_Data_Index_L
    LDA #$00
    ADC FC_Page_Index_Last_H
    STA FC_Data_Index_H
    JSR Page_List_Get_Item_Text_Addr
    RTS

;======================================================================
;获取当前文本数据位置
Page_List_Get_Cur_Item_Text_Addr
    JSR Page_List_Get_Cur_Item_Text_Bank
    LDA FC_Data_Addr_L
    JSR Mapper_Prg_A000_Banking
    
    CLC
    LDA FC_Page_Item_Index
    ADC FC_Page_Index_L
    STA FC_Data_Index_L
    LDA #$00
    ADC FC_Page_Index_H
    STA FC_Data_Index_H
    JSR Page_List_Get_Item_Text_Addr
    RTS

;======================================================================
;更新活动项
Page_Item_Upate_Cur_Active
    RTS
    
    LDA FC_Prg_A000
    PHA

    SEC
    LDA FC_Item_Index_L
    SBC FC_Page_Index_L
    STA FC_Page_Item_Index

    LDA FC_Char_Offset
    PHA
    LDA #$00
    STA FC_Char_Offset
    JSR Page_List_Item_Write
    PLA
    STA FC_Char_Offset

    PLA
    JSR Mapper_Prg_A000_Banking

    RTS
    
;======================================================================
;更新非活动项
Page_Item_Upate_Last_No_Active
    LDA FC_Prg_A000
    PHA

    SEC
    LDA FC_Item_Index_Last_L
    SBC FC_Page_Index_Last_L
    STA FC_Page_Item_Index

    LDA FC_Char_Offset
    PHA
    LDA #$00
    STA FC_Char_Offset
    JSR Page_List_Item_Write
    PLA
    STA FC_Char_Offset

    PLA
    JSR Mapper_Prg_A000_Banking

    RTS

;======================================================================
;页文本列表项清除
Page_List_Item_Clear
    LDA FC_Page_Item_Index
    CLC
    ADC FC_Page_Index_Last_L
    STA FC_Temp_Src_Index_L
    
    LDA #$00
    ADC FC_Page_Index_Last_H
    STA FC_Temp_Src_Index_H
    
    LDA #<ITEM_INDEX_MAX
    STA FC_Temp_Dest_Index_L
    LDA #>ITEM_INDEX_MAX
    STA FC_Temp_Dest_Index_H
    
    JSR FC_Cmp_Item_Index
    BEQ .Start
    BCC .Start

.Pre_End
    RTS
    
.Start

.Part_1
    LDX FC_PPU_Buf_Count
    
    ;写入行模式
    LDA #FC_PPU_MODE_CLEAR
    STA FC_PPU_Buf_Addr,X
    INX
    
    JSR Page_List_Item_Pos_Write
    
    LDY #$01
    LDA [FC_Data_Index_L],Y
    STA FC_PPU_Buf_Addr,X
    INX
    DEY
    LDA [FC_Data_Index_L],Y
    STA FC_PPU_Buf_Addr,X
    INX
    
    JSR Page_List_Get_Last_Item_Text_Addr
    
    ;获取文本长度
    LDY #$00
    LDA [FC_Data_Addr_L],Y
    STA FC_Item_Name_Length
    CMP #ITEM_NAME_SCROLL_ENGTH
    BCC .Part_1_Set_Length
    LDA #ITEM_NAME_SCROLL_ENGTH
    STA FC_Item_Name_Length
.Part_1_Set_Length
    CLC
    LDA FC_Item_Name_Length
    ADC #ITEM_ORDINAL_LENGTH + ITEM_ORDINAL_DOT
    STA FC_PPU_Buf_Addr,X
    INX
    
    STX FC_PPU_Buf_Count
    
.Part_2
    LDX FC_PPU_Buf_Count
    
    ;写入行模式
    LDA #FC_PPU_MODE_CLEAR
    STA FC_PPU_Buf_Addr,X
    INX
    
    JSR Page_List_Item_Pos_Write
    
    LDA FC_Data_Addr_H
    PHA
    LDA FC_Data_Addr_L
    PHA
    
    LDY #$01
    LDA [FC_Data_Index_L],Y
    STA FC_Data_Addr_H
    DEY
    LDA [FC_Data_Index_L],Y
    STA FC_Data_Addr_L
    
    CLC
    LDA FC_Data_Addr_L
    ADC #$20
    STA FC_Data_Addr_L
    LDA FC_Data_Addr_H
    ADC #$00
    STA FC_Data_Addr_H
    
    LDA FC_Data_Addr_H
    STA FC_PPU_Buf_Addr,X
    INX
    LDA FC_Data_Addr_L
    STA FC_PPU_Buf_Addr,X
    INX
    
    PLA
    STA FC_Data_Addr_L
    PLA
    STA FC_Data_Addr_H
    
    JSR Page_List_Get_Last_Item_Text_Addr
    
    ;获取文本长度
    LDY #$00
    LDA [FC_Data_Addr_L],Y
    STA FC_Item_Name_Length
    CMP #ITEM_NAME_SCROLL_ENGTH
    BCC .Part_2_Set_Length
    LDA #ITEM_NAME_SCROLL_ENGTH
    STA FC_Item_Name_Length
.Part_2_Set_Length
    CLC
    LDA FC_Item_Name_Length
    ADC #ITEM_ORDINAL_LENGTH + ITEM_ORDINAL_DOT
    STA FC_PPU_Buf_Addr,X
    INX
    
    STX FC_PPU_Buf_Count
    
.End
    RTS

;======================================================================
;页文本列表项写入
Page_List_Item_Write

    LDA FC_Page_Item_Index
    CLC
    ADC FC_Page_Index_L
    STA FC_Temp_Src_Index_L
    LDA #$00
    ADC FC_Page_Index_H
    STA FC_Temp_Src_Index_H
    BCS .End_Pre
    
    LDA #<ITEM_INDEX_MAX
    STA FC_Temp_Dest_Index_L
    LDA #>ITEM_INDEX_MAX
    STA FC_Temp_Dest_Index_H
    
    JSR FC_Cmp_Item_Index
    BCC .Start
    BEQ .Start
    
.End_Pre
    RTS

.Start

.Part_1
    LDX FC_PPU_Buf_Count
    LDA #$00
    STA FC_Char_Offset
    
    ;写入行模式
    LDA #FC_PPU_MODE_LINE
    STA FC_PPU_Buf_Addr,X
    INX
    
    JSR Page_List_Item_Pos_Write
    
    LDY #$01
    LDA [FC_Data_Index_L],Y
    STA FC_PPU_Buf_Addr,X
    INX
    DEY
    LDA [FC_Data_Index_L],Y
    STA FC_PPU_Buf_Addr,X
    INX
    
    JSR Page_List_Get_Cur_Item_Text_Addr
    
    ;获取文本长度
    LDY #$00
    LDA [FC_Data_Addr_L],Y
    STA FC_Item_Name_Length
    CMP #ITEM_NAME_SCROLL_ENGTH
    BCC .Part_1_Set_Length
    LDA #ITEM_NAME_SCROLL_ENGTH
    STA FC_Item_Name_Length
.Part_1_Set_Length
    CLC
    LDA FC_Item_Name_Length
    ;写入序号长度
    ADC #ITEM_ORDINAL_LENGTH + ITEM_ORDINAL_DOT
    STA FC_PPU_Buf_Addr,X
    INX
    
    LDA FC_Page_Item_Index
    CLC
    ADC FC_Page_Index_L
    STA FC_Hex_Data_L
    
    LDA #$00
    ADC FC_Page_Index_H
    STA FC_Hex_Data_H
    
    LDA FC_Hex_Data_L
    CLC
    ADC #LOW(ITEM_ORDINAL_BEGIN)
    STA FC_Hex_Data_L
    LDA FC_Hex_Data_H
    ADC #HIGH(ITEM_ORDINAL_BEGIN)
    STA FC_Hex_Data_H
    
    JSR FC_HEX_To_Dec_16
    
    .IF 5 = ITEM_ORDINAL_LENGTH
        JSR FC_Convert_Dec_To_PPU_10000_Up
    .ENDIF

    .IF 4 = ITEM_ORDINAL_LENGTH
        JSR FC_Convert_Dec_To_PPU_1000_Up
    .ENDIF

    .IF 3 = ITEM_ORDINAL_LENGTH
        JSR FC_Convert_Dec_To_PPU_100_Up
    .ENDIF

    .IF 2 = ITEM_ORDINAL_LENGTH
        JSR FC_Convert_Dec_To_PPU_10_Up
    .ENDIF

    .IF 1 = ITEM_ORDINAL_LENGTH
        JSR FC_Convert_Dec_To_PPU_1_Up
    .ENDIF
    
    .IF ITEM_ORDINAL_DOT > 0
        LDA #'.'
        JSR Get_Char_Data_Up
        STA FC_PPU_Buf_Addr,X
        INX
    .ENDIF

    LDY #$01
.Part_1_Write_Text_Data
    LDA [FC_Data_Addr_L],Y
    JSR Get_Char_Data_Up
    STA FC_PPU_Buf_Addr,X
    INY
    INX
    DEC FC_Item_Name_Length
    BNE .Part_1_Write_Text_Data
    STX FC_PPU_Buf_Count
    
.Part_2
    LDX FC_PPU_Buf_Count
    LDA #$10
    STA FC_Char_Offset
    
    ;写入行模式
    LDA #FC_PPU_MODE_LINE
    STA FC_PPU_Buf_Addr,X
    INX
    
    JSR Page_List_Item_Pos_Write
    
    LDA FC_Data_Addr_H
    PHA
    LDA FC_Data_Addr_L
    PHA
    
    LDY #$01
    LDA [FC_Data_Index_L],Y
    STA FC_Data_Addr_H
    DEY
    LDA [FC_Data_Index_L],Y
    STA FC_Data_Addr_L
    
    CLC
    LDA FC_Data_Addr_L
    ADC #$20
    STA FC_Data_Addr_L
    LDA FC_Data_Addr_H
    ADC #$00
    STA FC_Data_Addr_H
    
    LDA FC_Data_Addr_H
    STA FC_PPU_Buf_Addr,X
    INX
    LDA FC_Data_Addr_L
    STA FC_PPU_Buf_Addr,X
    INX
    
    PLA
    STA FC_Data_Addr_L
    PLA
    STA FC_Data_Addr_H
    
    JSR Page_List_Get_Cur_Item_Text_Addr
    
    ;获取文本长度
    LDY #$00
    LDA [FC_Data_Addr_L],Y
    STA FC_Item_Name_Length
    CMP #ITEM_NAME_SCROLL_ENGTH
    BCC .Part_2_Set_Length
    LDA #ITEM_NAME_SCROLL_ENGTH
    STA FC_Item_Name_Length
.Part_2_Set_Length
    CLC
    LDA FC_Item_Name_Length
    ;写入序号长度
    ADC #ITEM_ORDINAL_LENGTH + ITEM_ORDINAL_DOT
    STA FC_PPU_Buf_Addr,X
    INX
    
    LDA FC_Page_Item_Index
    CLC
    ADC FC_Page_Index_L
    STA FC_Hex_Data_L
    
    LDA #$00
    ADC FC_Page_Index_H
    STA FC_Hex_Data_H
    
    LDA FC_Hex_Data_L
    CLC
    ADC #LOW(ITEM_ORDINAL_BEGIN)
    STA FC_Hex_Data_L
    LDA FC_Hex_Data_H
    ADC #HIGH(ITEM_ORDINAL_BEGIN)
    STA FC_Hex_Data_H
    
    JSR FC_HEX_To_Dec_16
    
    .IF 5 = ITEM_ORDINAL_LENGTH
        JSR FC_Convert_Dec_To_PPU_10000_Down
    .ENDIF

    .IF 4 = ITEM_ORDINAL_LENGTH
        JSR FC_Convert_Dec_To_PPU_1000_Down
    .ENDIF

    .IF 3 = ITEM_ORDINAL_LENGTH
        JSR FC_Convert_Dec_To_PPU_100_Down
    .ENDIF

    .IF 2 = ITEM_ORDINAL_LENGTH
        JSR FC_Convert_Dec_To_PPU_10_Down
    .ENDIF

    .IF 1 = ITEM_ORDINAL_LENGTH
        JSR FC_Convert_Dec_To_PPU_1_Down
    .ENDIF
    
    .IF ITEM_ORDINAL_DOT > 0
        LDA #'.'
        JSR Get_Char_Data_Down
        STA FC_PPU_Buf_Addr,X
        INX
    .ENDIF

    LDY #$01
.Part_2_Write_Text_Data
    LDA [FC_Data_Addr_L],Y
    JSR Get_Char_Data_Down
    STA FC_PPU_Buf_Addr,X
    INY
    INX
    DEC FC_Item_Name_Length
    BNE .Part_2_Write_Text_Data
    STX FC_PPU_Buf_Count
    RTS

;======================================================================
;活动项设置
Page_List_Item_Hover
    LDA #$00
    STA FC_Char_Offset
    
    LDA FC_Page_Item_Index
    CMP FC_Cursor_Index
    BNE .End
.Hover
    LDA #$00
    STA FC_Char_Offset
    
    LDA FC_Cursor_Index
    STA FC_Cursor_Index_Last
    STA FC_Page_Cursor_Index
    JSR FC_Cursor_Buffer_Flash
    
.End

    RTS

;======================================================================
;活动项图形设置
Page_List_Item_Hover_Chr

    LDA FC_Page_Item_Index
    CLC
    ADC FC_Page_Index_L
    STA FC_Temp_Src_Index_L
    
    LDA #$00
    ADC FC_Page_Index_H
    STA FC_Temp_Src_Index_H
    BCS .End_Pre
    
    LDA #<ITEM_INDEX_MAX
    STA FC_Temp_Dest_Index_L
    LDA #>ITEM_INDEX_MAX
    STA FC_Temp_Dest_Index_H
    
    JSR FC_Cmp_Item_Index
    BCC .Start
    BEQ .Start
    
.End_Pre
    RTS

.Start
    TXA
    PHA
    
    LDX FC_Page_Item_Index
    LDA #$00
    STA FC_Chr_Index,X
    
    LDA FC_Data_Index_L
    PHA
    LDA FC_Data_Index_H
    PHA
    
    LDA #$00
    STA FC_Data_Index_H
    
    CLC
    LDA FC_Page_Item_Index
    ADC FC_Page_Index_L
    STA FC_Data_Index_L
    LDA FC_Page_Index_H
    ADC #$00
    STA FC_Data_Index_H
    
    LDA FC_Prg_A000
    PHA
    LDA #BANK(Item_Text_Data_Chr_Index)
    JSR Mapper_Prg_A000_Banking
    
    CLC
    LDA FC_Data_Index_L
    ADC #<Item_Text_Data_Chr_Index
    STA FC_Data_Index_L
    
    LDA FC_Data_Index_H
    ADC #>Item_Text_Data_Chr_Index
    STA FC_Data_Index_H
    
    LDX FC_Page_Item_Index
    LDY #$00
    LDA [FC_Data_Index_L],Y
    CLC
    ADC #LIST_TEXT_CHR_BEGIN
    STA FC_Chr_Index,X
    
    PLA
    JSR Mapper_Prg_A000_Banking
    
    PLA
    STA FC_Data_Index_H
    PLA
    STA FC_Data_Index_L
    
    PLA
    TAX
    RTS

;======================================================================
;活动项图形设置
Page_List_Item_Hover_Chr_After

    LDA FC_Page_Item_Index
    SEC
    SBC #$01
    CLC
    ADC FC_Page_Index_L
    STA FC_Temp_Src_Index_L
    
    LDA #$00
    ADC FC_Page_Index_H
    STA FC_Temp_Src_Index_H
    BCS .End_Pre
    
    LDA #<ITEM_INDEX_MAX
    STA FC_Temp_Dest_Index_L
    LDA #>ITEM_INDEX_MAX
    STA FC_Temp_Dest_Index_H
    
    JSR FC_Cmp_Item_Index
    BCC .Start
    BEQ .Start
    
.End_Pre
    RTS

.Start
    TXA
    PHA
    
    LDX FC_Page_Item_Index
    DEX
    LDA #$01
    STA FC_Chr_Index_Ready,X
    
    PLA
    TAX
    RTS

;======================================================================
;活动项图形设置
Page_List_Item_Hover_Attributes
    TXA
    PHA
    
    SEC
    LDA FC_Page_Item_Index
    SBC #$01
    CMP FC_Cursor_Index
    BNE .End

    JSR Item_Text_Attributes_Update_Hover

.End
    PLA
    TAX

    RTS

;======================================================================
;更新非活动项属性颜色
Item_Text_Attributes_Update_Hover
    LDA FC_NMI_Task_Flag
    ORA #FC_NMI_TASK_ATTR
    STA FC_NMI_Task_Flag
    
    LDA #00
    STA FC_Data_Index_L
    
    LDA FC_Cursor_Index
    CLC
    ADC #$03
    STA FC_Data_Index_H
    
    LDA #01
    STA FC_Data_Index

    LDA #16
    STA FC_Data_Count

    JSR PPU_Write_Attributes_Buf
    JSR Page_Buffer_Flush

    LDA FC_NMI_Task_Flag
    AND #FC_NMI_TASK_ATTR ^ $FF
    STA FC_NMI_Task_Flag
    
    RTS

;======================================================================
;更新非活动项属性颜色
Item_Text_Attributes_Update_No_Hover
    LDA FC_NMI_Task_Flag
    ORA #FC_NMI_TASK_ATTR
    STA FC_NMI_Task_Flag
    
    LDA #00
    STA FC_Data_Index_L
    
    LDA FC_Cursor_Index_Last
    CLC
    ADC #$03
    STA FC_Data_Index_H
    
    LDA #00
    STA FC_Data_Index

    LDA #16
    STA FC_Data_Count

    JSR PPU_Write_Attributes_Buf
    JSR Page_Buffer_Flush

    LDA FC_NMI_Task_Flag
    AND #FC_NMI_TASK_ATTR ^ $FF
    STA FC_NMI_Task_Flag
    
.End
    RTS


;刷新 PPU 缓冲(等待 NMI 处理完缓冲)
Page_Buffer_Flush
    LDA FC_NMI_Task_Flag
    ORA #FC_NMI_TASK_BUF_READY
    STA FC_NMI_Task_Flag
.Wait_Vblank
    LDA FC_NMI_Task_Flag
    AND #FC_NMI_TASK_BUF_READY
    BNE .Wait_Vblank
    RTS

;======================================================================
;页文本列表更新
Page_List_Update
    LDA FC_NMI_Task_Flag
    AND #FC_NMI_TASK_PAGING
    BEQ .Start
    RTS

.Start
    ;标记翻页进行中
    LDA FC_NMI_Task_Flag
    ORA #FC_NMI_TASK_PAGING
    STA FC_NMI_Task_Flag
    
    LDA FC_Char_Offset
    PHA
    
.Update_Start
    LDA #$00
    STA FC_Page_Item_Index
    STA FC_Page_Item_Buffer
    
    ;PPU 缓冲还有数据则处理完
    LDX FC_PPU_Buf_Count
    BEQ .Update_Item_Content
    
    JSR .Page_Buffer_Flush
    
.Update_Item_Content

    LDA FC_Prg_A000
    PHA

    JSR Page_List_Item_Clear
    JSR Page_List_Item_Hover
    JSR Page_List_Item_Write
    JSR Page_List_Item_Hover_Chr
    
    PLA
    JSR Mapper_Prg_A000_Banking
    
    INC FC_Page_Item_Index
    INC FC_Page_Item_Buffer
    
    LDA FC_Page_Item_Buffer
    CMP #ITEM_PAGE_BUFFER_SIZE
    BCC .Update_Item_Content_Continue
    
    ;刷新缓冲
    JSR .Page_Buffer_Flush
    JSR Page_List_Item_Hover_Chr_After
    JSR Page_List_Item_Hover_Attributes
    
.Update_Item_Content_Continue
    LDA FC_Page_Item_Index
    CMP #ITEM_PAGE_SIZE
    BCC .Update_Item_Content

.Update_Item_Finish
    LDA FC_Page_Item_Buffer
    BEQ .Page_List_Update_End
    
    JSR .Page_Buffer_Flush
    JSR Page_List_Item_Hover_Chr_After
    JSR Page_List_Item_Hover_Attributes
    
.Page_List_Update_End
    PLA
    STA FC_Char_Offset
    
    LDA FC_NMI_Task_Flag
    AND #FC_NMI_TASK_PAGING ^ $FF
    STA FC_NMI_Task_Flag
    
.End

    RTS

;刷新 PPU 缓冲(等待 NMI 处理完缓冲)
.Page_Buffer_Flush
    LDA #$00
    STA FC_Page_Item_Buffer
    LDA FC_NMI_Task_Flag
    ORA #FC_NMI_TASK_BUF_READY
    STA FC_NMI_Task_Flag
.Wait_Vblank
    LDA FC_NMI_Task_Flag
    AND #FC_NMI_TASK_BUF_READY
    BNE .Wait_Vblank
    RTS
    