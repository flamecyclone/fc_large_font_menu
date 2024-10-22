;=================================================
;PPU缓冲数据处理
FC_PPU_Buffer_Process
    LDX FC_PPU_Buf_Count
    BEQ FC_PPU_Palette_Buffer_Process
    LDA #$00
    STA FC_PPU_Buf_Count
    STA FC_PPU_Buf_Addr,X
    TAX
    
    ;关闭 PPU 显示
    LDA #$00
    STA PPU_MASK            ;$2001
    JSR FC_PPU_Buffer_Mode_Select

;PPU调色板缓冲处理
FC_PPU_Palette_Buffer_Process
    .IF PPU_PAL_BUFFER_ENABLE > 0
    LDA #$3F
    STA PPU_ADDRESS         ;$2006
    LDA #$00
    STA PPU_ADDRESS         ;$2006
    LDX #$00
    LDY #$20
FC_PPU_Palette_Buffer_Write
    LDA FC_PPU_Pal_Addr,X
    STA PPU_DATA            ;$2007
    INX
    DEY
    BNE FC_PPU_Palette_Buffer_Write
    .ENDIF
    
FC_PPU_Buffer_Process_End
    
    ;重置 PPU 位置
    LDA #$00
    STA PPU_ADDRESS         ;$2006
    STA PPU_ADDRESS         ;$2006
    STA FC_PPU_Buf_Count
    
    ;恢复 PPU 滚动
    LDA FC_PPU_H_Scroll
    STA PPU_SCROLL          ;$2005
    LDA FC_PPU_V_Scroll
    STA PPU_SCROLL          ;$2005
    
    ;恢复 PPU 显示
    LDA FC_PPU_Mask
    STA PPU_MASK            ;$2001
    
    RTS

;======================================================================
;PPU命名表属性更新模式
FC_PPU_Attr_Update_Mode
    ;设置PPU地址高位
    LDA FC_PPU_Buf_Addr,X
    STA PPU_ADDRESS
    INX
    
    ;设置PPU地址低位
    LDA FC_PPU_Buf_Addr,X
    STA PPU_ADDRESS
    INX
    
    LDA FC_PPU_Buf_Addr,X
    TAY
    DEX
    DEX
    
    ;读取指定PPU数据
    LDA PPU_DATA
    TXA
    PHA
    
    ;读取指定PPU数据
    LDX FC_PPU_Buf_Count
.Read_Attr
    LDA PPU_DATA
    STA FC_PPU_Attr_Read_Buf,X
    INX
    DEY
    BNE .Read_Attr
    
    PLA
    TAX
    
    ;设置PPU地址高位
    LDA FC_PPU_Buf_Addr,X
    STA PPU_ADDRESS
    INX
    
    ;设置PPU地址低位
    LDA FC_PPU_Buf_Addr,X
    STA PPU_ADDRESS
    INX
    
    LDA FC_PPU_Buf_Addr,X
    TAY
    INX
    TXA
    PHA
    
    TYA
    TAX
    LDY FC_PPU_Buf_Count
.Update_Attr
    LDA FC_PPU_Attr_Read_Buf,Y
    AND FC_PPU_Attr_AND_Buf,Y
    ORA FC_PPU_Attr_ORA_Buf,Y
    STA PPU_DATA
    INY
    DEX
    BNE .Update_Attr
    STY FC_PPU_Buf_Count
    
    PLA
    TAX

;处理模式选择
FC_PPU_Buffer_Mode_Select
    LDA FC_PPU_Buf_Addr,X
    INX
    CMP #FC_PPU_MODE_LINE
    BEQ FC_PPU_Buffer_Line
    CMP #FC_PPU_MODE_CLEAR
    BEQ FC_PPU_Buffer_Clear
    CMP #FC_PPU_MODE_ATTR
    BEQ FC_PPU_Attr_Update_Mode
    RTS

;单行文本写入处理
FC_PPU_Buffer_Line
    LDA FC_PPU_Buf_Addr,X
    STA PPU_ADDRESS         ;$2006
    INX
    LDA FC_PPU_Buf_Addr,X
    STA PPU_ADDRESS         ;$2006
    INX
    LDY FC_PPU_Buf_Addr,X
    INX
FC_PPU_Buffer_Line_Write
    LDA FC_PPU_Buf_Addr,X
    STA PPU_DATA            ;$2007
    INX
    DEY
    BNE FC_PPU_Buffer_Line_Write
    BEQ FC_PPU_Buffer_Mode_Select
    
;单行文本清除处理
FC_PPU_Buffer_Clear
    LDA FC_PPU_Buf_Addr,X
    STA PPU_ADDRESS         ;$2006
    INX
    LDA FC_PPU_Buf_Addr,X
    STA PPU_ADDRESS         ;$2006
    INX
    LDY FC_PPU_Buf_Addr,X
    INX
    LDA #FC_PPU_CHAR_NULL
FC_PPU_Buffer_Clear_Write
    STA PPU_DATA            ;$2007
    DEY
    BNE FC_PPU_Buffer_Clear_Write
    BEQ FC_PPU_Buffer_Mode_Select

;==================================================
;通过PPU缓冲修改命名表属性颜色
;--------------------------------------------------
;前提: 需要先设置属性表参照地址
;参数1  FC_Data_Index_L 属性表横向位置(0-15)
;参数2  FC_Data_Index_H 属性表纵向位置(0-14)
;参数3  FC_Data_Index   设置颜色索引(0-3)
;参数4  FC_Data_Count   设置数量(0-32)
;--------------------------------------------------
PPU_Write_Attributes_Buf
    ; 写32列 耗时 4008周期
    JSR .Paramter_Limit
    BCC .End
    
    ;清除缓冲
    JSR .Clear_Attr_Buf
    
    ;设置递增字节计数
    LDA FC_Data_Index_L
    AND #$01
    BNE .Init_Tile_Count
    LDA #$02
.Init_Tile_Count
    STA FC_Data_Addr_H
    
    TYA
    PHA
    
    ;设置缓冲数据起始索引计数
    LDY #$00
    
    ;设置缓冲模式与地址
    LDX FC_PPU_Buf_Count
    JSR .Set_Attr_Buf_Mode_And_Addr
    
;写入调色板数据
.Update_Attr_Buf
    JSR .Get_Attribute_Pos 
    DEC FC_Data_Addr_H
    BNE .Update_Attr_Index
    
    ;重置地址递增计数(2列一个字节)
    LDA #$02
    STA FC_Data_Addr_H
    INC FC_PPU_Buf_Addr,X   ;递增缓冲数据计数
    INY
.Update_Attr_Index
    INC FC_Data_Index_L
    DEC FC_Data_Count
    BEQ .Update_Finish
    
    ;检查是否需要转行
    LDA FC_Data_Index_L
    CMP #16
    BCC .Update_Attr_Buf
    
    ;回到第0列
    LDA #$00
    STA FC_Data_Index_L
    
    ;行数递增
    INC FC_Data_Index_H
    
    ;检查是否越界
    LDA FC_Data_Index_H
    CMP #15
    BCS .Update_Finish
    
    INX
    
    ;设置缓冲模式与地址
    JSR .Set_Attr_Buf_Mode_And_Addr
    JMP .Update_Attr_Buf

.Update_Finish

    ;检查缓冲数据是否需要计数
    LDA FC_Data_Addr_H
    AND #$01
    BEQ .Write_Finish
    INC FC_PPU_Buf_Addr,X
    
.Write_Finish
    INX
    STX FC_PPU_Buf_Count
    PLA
    TAY

.End
    RTS

;-------------------------------------------------
;设置PPU缓冲模式与地址
.Set_Attr_Buf_Mode_And_Addr
    LDA #FC_PPU_MODE_ATTR
    STA FC_PPU_Buf_Addr,X
    INX
    
    ;设置PPU地址缓冲高位
    LDA #$23
    STA FC_PPU_Buf_Addr,X
    INX
    
    ;获取颜色块地址
    JSR .Get_Attribute_Addr
    STA FC_PPU_Buf_Addr,X
    INX
    
    LDA #$00
    STA FC_PPU_Buf_Addr,X
    RTS
    
;-------------------------------------------------
.Get_Attribute_Addr
    LDA FC_Data_Index_L
    LSR A
    STA FC_Data_Addr_L
    
    LDA FC_Data_Index_H
    LSR A
    ASL A
    ASL A
    ASL A
    CLC
    ADC FC_Data_Addr_L
    ADC #$C0
    RTS

;-------------------------------------------------
;设置PPU缓冲数据计数
.Set_PPU_Attr_Count
    LDA FC_Data_Addr_H
    AND #$01
    BEQ .Set_PPU_Attr_Count_End
    INC FC_PPU_Buf_Addr,X
.Set_PPU_Attr_Count_End
    RTS

;-------------------------------------------------
;获取属性颜色位置
.Get_Attribute_Pos
    LDA FC_Data_Index_H
    AND #$01
    ASL A
    STA FC_Data_Buf
    LDA FC_Data_Index_L
    AND #$01
    ORA FC_Data_Buf
    AND #$03
    CMP #$01
    BEQ .Get_Right_Top
    CMP #$02
    BEQ .Get_Left_Bottom
    CMP #$03
    BEQ .Get_Right_Bottom

;左上角 4 * 4 Tile 颜色
.Get_Left_Top
    LDA FC_PPU_Attr_AND_Buf,Y
    AND #$FC
    STA FC_PPU_Attr_AND_Buf,Y
    LDA FC_PPU_Attr_LT_Buf
    ORA FC_PPU_Attr_ORA_Buf,Y
    STA FC_PPU_Attr_ORA_Buf,Y
    RTS

;右上角 4 * 4 Tile 颜色
.Get_Right_Top
    LDA FC_PPU_Attr_AND_Buf,Y
    AND #$F3
    STA FC_PPU_Attr_AND_Buf,Y
    LDA FC_PPU_Attr_RT_Buf
    ORA FC_PPU_Attr_ORA_Buf,Y
    STA FC_PPU_Attr_ORA_Buf,Y
    RTS
    
;左下角 4 * 4 Tile 颜色
.Get_Left_Bottom
    LDA FC_PPU_Attr_AND_Buf,Y
    AND #$CF
    STA FC_PPU_Attr_AND_Buf,Y
    LDA FC_PPU_Attr_LB_Buf
    ORA FC_PPU_Attr_ORA_Buf,Y
    STA FC_PPU_Attr_ORA_Buf,Y
    RTS

;右下角 4 * 4 Tile 颜色
.Get_Right_Bottom
    LDA FC_PPU_Attr_AND_Buf,Y
    AND #$3F
    STA FC_PPU_Attr_AND_Buf,Y
    LDA FC_PPU_Attr_RB_Buf
    ORA FC_PPU_Attr_ORA_Buf,Y
    STA FC_PPU_Attr_ORA_Buf,Y
    RTS

;-------------------------------------------------
;参数检查
.Paramter_Limit
    LDA FC_Data_Index_L
    CMP #16
    BCC .Paramter_Limit_V_Count
    LDA #15
    STA FC_Data_Index_L
    
.Paramter_Limit_V_Count
    LDA FC_Data_Index_H
    CMP #15
    BCC .Paramter_Limit_Data_Count
    LDA #14
    STA FC_Data_Index_H
    
.Paramter_Limit_Data_Count
    LDA FC_Data_Count
    BEQ .Paramter_Limit_Invalid
    CMP #32
    BCC .Paramter_Limit_Valid
    LDA #32
    STA FC_Data_Count
    
.Paramter_Limit_Valid
    LDA FC_Data_Index
    AND #$03
    STA FC_PPU_Attr_LT_Buf
    ASL
    ASL
    STA FC_PPU_Attr_RT_Buf
    ASL
    ASL
    STA FC_PPU_Attr_LB_Buf
    ASL
    ASL
    STA FC_PPU_Attr_RB_Buf
    SEC
    RTS
    
.Paramter_Limit_Invalid
    CLC
    RTS

;-------------------------------------------------
;清除属性缓冲
.Clear_Attr_Buf
    LDX #$00
.Clear_Write
    LDA #$00
    STA FC_PPU_Attr_ORA_Buf,X
    LDA #$FF
    STA FC_PPU_Attr_AND_Buf,X
    INX
    CPX #FC_ATTRIBUTES_BUF_SIZE
    BCC .Clear_Write
    RTS
