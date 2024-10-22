
;=================================================
;缓冲方式写入一条文本
;需要先将文本数据地址写入 FC_Data_Addr_L 和 FC_Data_Addr_H
Clear_Text_Item_By_Buffer

    LDX FC_PPU_Buf_Count        ;读取缓冲数据量

    ;获取字符串长度, 字符串长度为 0 则跳过
    LDY #TEXT_INFO_INDEX_DATA
    LDA [FC_Data_Addr_L],Y
    BEQ Clear_Text_Item_By_Buffer_End
    STA FC_Data_Count
    
    ;设置 PPU 缓冲清除模式
    LDA #FC_PPU_MODE_CLEAR
    STA FC_PPU_Buf_Addr,X
    INX
    
    LDY #TEXT_INFO_INDEX_FLAG
    LDA [FC_Data_Addr_L],Y
    
    ;文本标志入栈保存
    PHA
    BEQ Clear_Text_Item_By_Buffer_Pos
    
    ;居中处理
    LDA #$20
    SEC
    SBC FC_Data_Count
    LSR
    STA FC_Data_Count

;设置文本地址
Clear_Text_Item_By_Buffer_Pos
    ;PPU 地址高位
    LDY #TEXT_INFO_INDEX_POS_H
    LDA [FC_Data_Addr_L],Y
    STA FC_PPU_Buf_Addr,X
    INX
    DEY
    
    ;文本标志入栈出栈检查
    PLA
    BNE Clear_Text_Item_By_Buffer_Pos_Center
    LDA [FC_Data_Addr_L],Y
    STA FC_PPU_Buf_Addr,X
    INX
    INY
    BNE Clear_Text_Item_By_Buffer_Count
    
Clear_Text_Item_By_Buffer_Pos_Center
    ;PPU 地址低位
    LDA [FC_Data_Addr_L],Y
    AND #$E0
    CLC
    ADC FC_Data_Count
    STA FC_PPU_Buf_Addr,X
    INX
    INY
    
Clear_Text_Item_By_Buffer_Count
    ;文本数据长度
    LDY #TEXT_INFO_INDEX_DATA
    LDA [FC_Data_Addr_L],Y
    STA FC_PPU_Buf_Addr,X
    INX
    STX FC_PPU_Buf_Count        ;记录缓冲数据量

Clear_Text_Item_By_Buffer_End
    RTS

;=================================================
;缓冲方式写入一条文本
;需要先将文本数据地址写入 FC_Data_Addr_L 和 FC_Data_Addr_H
Write_Text_Item_By_Buffer

    LDX FC_PPU_Buf_Count        ;读取缓冲数据量

    ;获取字符串长度, 字符串长度为 0 则跳过
    LDY #TEXT_INFO_INDEX_DATA
    LDA [FC_Data_Addr_L],Y
    BEQ Write_Text_Item_By_Buffer_End
    STA FC_Data_Count
    
    ;设置 PPU 缓冲写入模式
    LDA #FC_PPU_MODE_LINE
    STA FC_PPU_Buf_Addr,X
    INX
    
    LDY #TEXT_INFO_INDEX_FLAG
    LDA [FC_Data_Addr_L],Y
    
    ;文本标志入栈保存
    PHA
    BEQ Write_Text_Item_By_Buffer_Pos
    
    ;居中处理
    LDA #$20
    SEC
    SBC FC_Data_Count
    LSR
    STA FC_Data_Count

;设置文本地址
Write_Text_Item_By_Buffer_Pos
    ;PPU 地址高位
    LDY #TEXT_INFO_INDEX_POS_H
    LDA [FC_Data_Addr_L],Y
    STA FC_PPU_Buf_Addr,X
    INX
    DEY
    
    ;文本标志入栈出栈检查
    PLA
    BNE Write_Text_Item_By_Buffer_Pos_Center
    
    LDA [FC_Data_Addr_L],Y
    STA FC_PPU_Buf_Addr,X
    INX
    INY
    BNE Write_Text_Item_By_Buffer_Count
   
;居中位置写入
Write_Text_Item_By_Buffer_Pos_Center
    ;PPU 地址低位
    LDA [FC_Data_Addr_L],Y
    AND #$E0
    CLC
    ADC FC_Data_Count
    STA FC_PPU_Buf_Addr,X
    INX
    INY
    
Write_Text_Item_By_Buffer_Count
    ;文本数据长度
    LDY #TEXT_INFO_INDEX_DATA
    LDA [FC_Data_Addr_L],Y
    STA FC_Data_Count
    STA FC_PPU_Buf_Addr,X
    INX
    INY
    
;写入文本字符数据
Write_Text_Item_By_Buffer_Write_Char
    LDA [FC_Data_Addr_L],Y
    STA FC_PPU_Buf_Addr,X
    INX
    INY
    DEC FC_Data_Count
    BNE Write_Text_Item_By_Buffer_Write_Char

    STX FC_PPU_Buf_Count        ;记录缓冲数据量

Write_Text_Item_By_Buffer_End
    RTS

;=================================================
;缓冲方式清除指定索引的文本
;需要先指定文本索引地址 FC_Data_Addr_L FC_Data_Addr_H
;以及文本索引 FC_Data_Index
Clear_Text_By_Buffer_With_Index
    
    LDA FC_Data_Index
    ASL
    TAY

    ;获取文本数据地址
    LDA [FC_Data_Addr_L],Y
    PHA
    INY
    LDA [FC_Data_Addr_L],Y
    STA FC_Data_Addr_H
    PLA
    STA FC_Data_Addr_L
    
    ;将指定地址文本写入 PPU 缓冲
    JSR Clear_Text_Item_By_Buffer
    RTS

;=================================================
;获取文本组中指定索引的文本信息位置
;需要先指定文本索引地址 FC_Data_Addr_L FC_Data_Addr_H
;以及文本索引 FC_Data_Index
Get_Text_Data_By_Group_Index
    
    LDA FC_Data_Index
    ASL
    TAY

    ;获取文本数据地址
    LDA [FC_Data_Addr_L],Y
    PHA
    INY
    LDA [FC_Data_Addr_L],Y
    STA FC_Data_Addr_H
    PLA
    STA FC_Data_Addr_L
    RTS

;=================================================
;缓冲方式写入文本组
Write_Text_Group_By_Buffer
    LDA #(Text_Data_Index_End - Text_Data_Index) / 2
    BEQ Init_Text_End
    
    LDA #$00
    STA FC_Data_Index

;通过文本索引写入单条文本
Write_Text_Group_By_Item_Index
    LDA #<Text_Data_Index
    STA FC_Data_Addr_L
    LDA #>Text_Data_Index
    STA FC_Data_Addr_H
    
    JSR Get_Text_Data_By_Group_Index    ;获取文本信息
    JSR Write_Text_Item_By_Buffer       ;写入文本数据

;检查文本写入是否结束
Write_Text_Group_By_Buffer_Next
    INC FC_Data_Index
    LDA FC_Data_Index
    CMP #(Text_Data_Index_End - Text_Data_Index) / 2
    BCC Write_Text_Group_By_Item_Index

Init_Text_End
    RTS

;=================================================
;直接写数据方式写入文本组
Write_Text_Group_By_Data
    LDA #(Text_Data_Index_End - Text_Data_Index) / 2
    BEQ Init_Text_End
    
    LDA #$00
    STA FC_Data_Index

Write_Text_Group_By_Data_Write
    JSR Write_Text_Group_By_Data_Write_Up
    JSR Write_Text_Group_By_Data_Write_Down

;检查文本写入是否结束
Write_Text_Group_By_Data_Write_Next
    INC FC_Data_Index
    LDA FC_Data_Index
    CMP #(Text_Data_Index_End - Text_Data_Index) / 2
    BCC Write_Text_Group_By_Data_Write

Write_Text_Group_By_Data_Write_End
    RTS

;-------------------------------------------------
;单条静态文本写入
Write_Text_Group_By_Data_Write_Up
    LDA #<Text_Data_Index
    STA FC_Data_Addr_L
    LDA #>Text_Data_Index
    STA FC_Data_Addr_H
    
    LDA FC_Data_Index
    ASL
    TAY
    
    ;获取文本数据地址
    LDA [FC_Data_Addr_L],Y
    PHA
    INY
    LDA [FC_Data_Addr_L],Y
    STA FC_Data_Addr_H
    PLA
    STA FC_Data_Addr_L
    
    ;获取字符串长度, 字符串长度为 0 则跳过
    LDY #TEXT_INFO_INDEX_DATA
    LDA [FC_Data_Addr_L],Y
    BEQ Write_Text_Group_By_Data_Write_Next
    STA FC_Data_Count
    
    LDY #TEXT_INFO_INDEX_FLAG
    LDA [FC_Data_Addr_L],Y
    BEQ Write_Text_Group_By_Data_Pos_Up
    
    ;居中处理
    LDA #$20
    SEC
    SBC FC_Data_Count
    LSR
    STA FC_Data_Count
    
;设置文本地址
Write_Text_Group_By_Data_Pos_Up
    ;PPU地址高位
    LDY #TEXT_INFO_INDEX_POS_H
    LDA [FC_Data_Addr_L],Y
    STA PPU_ADDRESS
    DEY
    
    ;PPU地址低位
    LDA [FC_Data_Addr_L],Y
    AND #$E0
    CLC
    ADC FC_Data_Count
    STA PPU_ADDRESS
    INY
    
    ;文本数据长度
    LDY #TEXT_INFO_INDEX_DATA
    LDA [FC_Data_Addr_L],Y
    STA FC_Data_Count
    INY
    
;写入文本字符数据
Write_Text_Group_By_Data_Write_Char_Up
    LDA [FC_Data_Addr_L],Y
    JSR Get_Char_Data_Up
    STA PPU_DATA
    INY
    DEC FC_Data_Count
    BNE Write_Text_Group_By_Data_Write_Char_Up
    RTS
    
;-------------------------------------------------
;单条静态文本写入
Write_Text_Group_By_Data_Write_Down
    LDA #<Text_Data_Index
    STA FC_Data_Addr_L
    LDA #>Text_Data_Index
    STA FC_Data_Addr_H
    
    LDA FC_Data_Index
    ASL
    TAY
    
    ;获取文本数据地址
    LDA [FC_Data_Addr_L],Y
    PHA
    INY
    LDA [FC_Data_Addr_L],Y
    STA FC_Data_Addr_H
    PLA
    STA FC_Data_Addr_L
    
    ;获取字符串长度, 字符串长度为 0 则跳过
    LDY #TEXT_INFO_INDEX_DATA
    LDA [FC_Data_Addr_L],Y
    BEQ Write_Text_Group_By_Data_Write_Next
    STA FC_Data_Count
    
    LDY #TEXT_INFO_INDEX_FLAG
    LDA [FC_Data_Addr_L],Y
    BEQ Write_Text_Group_By_Data_Pos_Down
    
    ;居中处理
    LDA #$20
    SEC
    SBC FC_Data_Count
    LSR
    STA FC_Data_Count
    
;设置文本地址
Write_Text_Group_By_Data_Pos_Down
    LDA FC_Data_Addr_H
    PHA
    LDA FC_Data_Addr_L
    PHA
    
    ;PPU地址高位
    LDY #TEXT_INFO_INDEX_POS_H
    LDA [FC_Data_Addr_L],Y
    PHA
    DEY
    
    ;PPU地址低位
    LDA [FC_Data_Addr_L],Y
    INY
    STA FC_Data_Addr_L
    PLA
    STA FC_Data_Addr_H
    
    CLC
    LDA FC_Data_Addr_L
    AND #$E0
    ADC FC_Data_Count
    ADC #$20
    STA FC_Data_Addr_L
    LDA FC_Data_Addr_H
    ADC #$00
    STA FC_Data_Addr_H
    
    LDA FC_Data_Addr_H
    STA PPU_ADDRESS
    LDA FC_Data_Addr_L
    STA PPU_ADDRESS
    
    PLA
    STA FC_Data_Addr_L
    PLA
    STA FC_Data_Addr_H
    
    ;文本数据长度
    LDY #TEXT_INFO_INDEX_DATA
    LDA [FC_Data_Addr_L],Y
    STA FC_Data_Count
    INY
    
;写入文本字符数据
Write_Text_Group_By_Data_Write_Char_Down
    LDA [FC_Data_Addr_L],Y
    JSR Get_Char_Data_Down
    STA PPU_DATA
    INY
    DEC FC_Data_Count
    BNE Write_Text_Group_By_Data_Write_Char_Down
    RTS