;=================================================
;记录上次项索引
FC_Item_Index_Save
    LDA FC_Item_Index_L
    STA FC_Item_Index_Last_L
    LDA FC_Item_Index_H
    STA FC_Item_Index_Last_H
    RTS

;=================================================
;记录上次页起始索引
FC_Page_Index_Save
    LDA FC_Page_Index_L
    STA FC_Page_Index_Last_L
    LDA FC_Page_Index_H
    STA FC_Page_Index_Last_H
    RTS

;=================================================
;记录上次行列索引
FC_Page_Row_Column_Save
    LDA FC_Page_Row_Index
    STA FC_Page_Row_Index_Last
    LDA FC_Page_Column_Index
    STA FC_Page_Column_Index_Last
    RTS
    
;=================================================
;比较索引
FC_Cmp_Item_Index
    LDA FC_Temp_Src_Index_H
    CMP FC_Temp_Dest_Index_H
    BNE .End
    LDA FC_Temp_Src_Index_L
    CMP FC_Temp_Dest_Index_L
.End
    RTS

;=================================================
;更新项索引
FC_Page_Item_Index_Update

    ;记录上次索引在上次页起始索引的位置
    SEC 
    LDA FC_Item_Index_Last_L
    SBC FC_Page_Index_Last_L
    STA FC_Temp_Dest_Index_L
    
    LDA FC_Item_Index_Last_H
    SBC FC_Page_Index_Last_H
    STA FC_Temp_Dest_Index_H
    
    ;得到当前项索引
    CLC
    LDA FC_Temp_Dest_Index_L
    ADC FC_Page_Index_L
    STA FC_Temp_Src_Index_L
    LDA FC_Temp_Dest_Index_H
    ADC FC_Page_Index_H
    STA FC_Temp_Src_Index_H
    BCS .Update_Item_Index_Max  ;产生进位, 超过65535则需要限制
    
    LDA #<ITEM_INDEX_MAX
    STA FC_Temp_Dest_Index_L
    LDA #>ITEM_INDEX_MAX
    STA FC_Temp_Dest_Index_H
    JSR FC_Cmp_Item_Index
    BCC .Update_Item_Index

;限制项最大索引
.Update_Item_Index_Max
    LDA #<ITEM_INDEX_MAX
    STA FC_Item_Index_L
    LDA #>ITEM_INDEX_MAX
    STA FC_Item_Index_H
    RTS

;更新项索引
.Update_Item_Index
    LDA FC_Temp_Src_Index_L
    STA FC_Item_Index_L
    LDA FC_Temp_Src_Index_H
    STA FC_Item_Index_H
    RTS

;=================================================
;判断当前项是否为最后一列
;C = 1: 是最后一列
;C = 0: 不是最后一列
FC_Page_Is_Max_Column_Index
    LDA FC_Page_Column_Index
    CMP #ITEM_PAGE_COLUMN - 1
    BCS .End_True

    LDA FC_Item_Index_L
    STA FC_Temp_Src_Index_L
    LDA FC_Item_Index_H
    STA FC_Temp_Src_Index_H
    
    LDA #<PAGE_LAST_COLUMN_INDEX_MAX
    STA FC_Temp_Dest_Index_L
    LDA #>PAGE_LAST_COLUMN_INDEX_MAX
    STA FC_Temp_Dest_Index_H

    JSR FC_Cmp_Item_Index
    RTS
    
.End_True
    SEC
    RTS

.End_False
    CLC
    RTS

;=================================================
;判断当前页是否为最前页
;C = 1: 是最前页
;C = 0: 不是最前页
FC_Page_Is_Min_Page_Index
    LDA FC_Page_Index_L
    ORA FC_Page_Index_H
    BNE .End_False
    
.End_True
    SEC
    RTS

.End_False
    CLC
    RTS
    
;=================================================
;判断当前页是否为最后页
;C = 1: 是最后页
;C = 0: 不是最后页
FC_Page_Is_Max_Page_Index
    LDA FC_Page_Index_L
    CMP #<PAGE_INDEX_MAX
    BNE .End_False
    LDA FC_Page_Index_H
    CMP #>PAGE_INDEX_MAX
    BNE .End_False
    
.End_True
    SEC
    RTS

.End_False
    CLC
    RTS

;=================================================
;获取列索引在页中起始索引
FC_Page_Get_Column_Min_Index
    CLC
    LDA #$00
    LDX FC_Page_Column_Index
    BEQ .End
.Calc
    ADC #ITEM_PAGE_ROW
    DEX
    BNE .Calc
.End
    RTS

;=================================================
;获取列索引在页中最大索引
FC_Page_Get_Column_Max_Index
    CLC
    LDA #$00
    LDX FC_Page_Column_Index
    BEQ .End
.Calc
    ADC #ITEM_PAGE_ROW
    DEX
    BNE .Calc
.End
    ADC #ITEM_PAGE_ROW - 1
    RTS

;=================================================
;项索引是否超出范围
FC_Page_Is_Item_Out_Of_Range
    LDA FC_Item_Index_L
    STA FC_Temp_Src_Index_L
    LDA FC_Item_Index_H
    STA FC_Temp_Src_Index_H
    LDA #<ITEM_INDEX_MAX
    STA FC_Temp_Dest_Index_L
    LDA #>ITEM_INDEX_MAX
    STA FC_Temp_Dest_Index_H
    JSR FC_Cmp_Item_Index
    RTS

;=================================================
;设置项索引为最大值
FC_Page_Set_Item_Index_Max
    LDA #<ITEM_INDEX_MAX
    STA FC_Item_Index_L
    LDA #>ITEM_INDEX_MAX
    STA FC_Item_Index_H
    RTS

;=================================================
;设置页索引为最大值
FC_Page_Set_Page_Index_Max
    LDA #<PAGE_INDEX_MAX
    STA FC_Page_Index_L
    LDA #>PAGE_INDEX_MAX
    STA FC_Page_Index_H
    RTS

;=================================================
;前一个
FC_Item_Pre
    
    ;检查是否需要切换到最后一项
    LDA FC_Item_Index_L
    ORA FC_Item_Index_H
    BNE .Item_Index_Pre

;设置为最后一项
.Item_Index_Max

    JSR FC_Page_Set_Page_Index_Max
    JSR FC_Page_Set_Item_Index_Max
    
    ;列表刷新
    .IF ITEM_COUNT_MAX > ITEM_PAGE_SIZE
        JSR FC_Page_Index_Changed
    .ELSE
        JSR FC_Item_Index_Changed
    .ENDIF
    
    RTS
    
;设置为前一项
.Item_Index_Pre

    ;获取前一项索引
    SEC
    LDA FC_Item_Index_L
    SBC #$01
    STA FC_Temp_Src_Index_L
    LDA FC_Item_Index_H
    SBC #$00
    STA FC_Temp_Src_Index_H
    
    ;获取触发翻页临界索引
    LDA FC_Page_Index_L
    STA FC_Temp_Dest_Index_L
    LDA FC_Page_Index_H
    STA FC_Temp_Dest_Index_H
    
    ;检查是否切换到前一页
    SEC
    LDA FC_Item_Index_L
    SBC #$01
    STA FC_Item_Index_L
    LDA FC_Item_Index_H
    SBC #$00
    STA FC_Item_Index_H
    
    ;检查是否需要翻页
    JSR FC_Cmp_Item_Index
    BCS .Item_Index_Pre_Item_Change
    
    SEC
    LDA FC_Page_Index_L
    SBC #ITEM_PAGE_SIZE
    STA FC_Page_Index_L
    LDA FC_Page_Index_H
    SBC #$00
    STA FC_Page_Index_H
    
    ;列表刷新
    .IF ITEM_COUNT_MAX > ITEM_PAGE_SIZE
        JSR FC_Page_Index_Changed
    .ELSE
        JSR FC_Item_Index_Changed
    .ENDIF
    
    RTS

.Item_Index_Pre_Item_Change
    JSR FC_Item_Index_Changed
    RTS

;=================================================
;下一个
FC_Item_Next

    ;检查是否需要切换到最前一项
    LDA FC_Item_Index_L
    CMP #<ITEM_INDEX_MAX
    BNE .Item_Index_Next
    LDA FC_Item_Index_H
    CMP #>ITEM_INDEX_MAX
    BNE .Item_Index_Next

;设置为最前一项
.Item_Index_Min
    LDA #$00
    STA FC_Page_Index_L
    STA FC_Page_Index_H
    STA FC_Item_Index_L
    STA FC_Item_Index_H
    
    .IF ITEM_COUNT_MAX > ITEM_PAGE_SIZE
        JSR FC_Page_Index_Changed
    .ELSE
        JSR FC_Item_Index_Changed
    .ENDIF
    RTS

.Item_Index_Next
    
    ;获取下一项索引
    CLC
    LDA FC_Item_Index_L
    ADC #$01
    STA FC_Temp_Src_Index_L
    LDA FC_Item_Index_H
    ADC #$00
    STA FC_Temp_Src_Index_H
    
    ;获取触发翻页临界索引
    CLC
    LDA FC_Page_Index_L
    ADC #ITEM_PAGE_SIZE
    STA FC_Temp_Dest_Index_L
    LDA FC_Page_Index_H
    ADC #$00
    STA FC_Temp_Dest_Index_H
    BCC .Item_Index_Next_Normal
    JSR .Item_Index_Next_Update
    
    JSR FC_Item_Index_Changed
    RTS

.Item_Index_Next_Normal
    JSR .Item_Index_Next_Update
    
    ;检查是否需要翻页
    JSR FC_Cmp_Item_Index
    BCC .Item_Index_Next_Item_Change
    
    CLC
    LDA FC_Page_Index_L
    ADC #ITEM_PAGE_SIZE
    STA FC_Page_Index_L
    LDA FC_Page_Index_H
    ADC #$00
    STA FC_Page_Index_H
    
    .IF ITEM_COUNT_MAX > ITEM_PAGE_SIZE
        JSR FC_Page_Index_Changed
    .ELSE
        JSR FC_Item_Index_Changed
    .ENDIF
    RTS
    
.Item_Index_Next_Item_Change
    JSR FC_Item_Index_Changed
    RTS
    
;项索引递增1
.Item_Index_Next_Update
    CLC
    LDA FC_Item_Index_L
    ADC #$01
    STA FC_Item_Index_L
    LDA FC_Item_Index_H
    ADC #$00
    STA FC_Item_Index_H
    RTS

;=================================================
;获取行列位置
FC_Page_Get_Row_Column_Index
    LDA #$00
    STA FC_Page_Column_Index
    SEC
    LDA FC_Item_Index_L
    SBC FC_Page_Index_L
.Calc_Column
    CMP #ITEM_PAGE_ROW
    BCC .End
    INC FC_Page_Column_Index
    SEC
    SBC #ITEM_PAGE_ROW
    BNE .Calc_Column
.End
    STA FC_Page_Row_Index
    RTS

;=================================================
;判断当前页是否为最后一行
;C = 1: 是最后一行
;C = 0: 不是最后一行
FC_Page_Is_Max_Row_Index
    LDA FC_Page_Row_Index
    CMP #ITEM_PAGE_ROW - 1
    BCS .End_True
    
    ;检查当前项是否为最后一项
    LDA FC_Item_Index_L
    CMP #<ITEM_INDEX_MAX
    BNE .End_False
    LDA FC_Item_Index_H
    CMP #>ITEM_INDEX_MAX
    BNE .End_False
    
.End_True
    SEC
    RTS

.End_False
    CLC
    RTS
    
;=================================================
;前一行
FC_Page_Row_Pre
    JSR FC_Page_Index_Save
    JSR FC_Item_Index_Save
    JSR FC_Item_Index_Change_Before
    
    LDA FC_Page_Row_Index
    BNE .Item_Pre
    
.Page_Row_Pre
    JSR FC_Page_Is_Min_Page_Index
    BCC .Page_Row_Pre_Page

;转到最末页
.Page_Row_Max_Page
    
    JSR FC_Page_Set_Page_Index_Max
    
    JSR FC_Page_Get_Column_Max_Index
    CLC
    ADC FC_Page_Index_L
    STA FC_Item_Index_L
    STA FC_Temp_Src_Index_L
    LDA FC_Page_Index_H
    ADC #$00
    STA FC_Item_Index_H
    STA FC_Temp_Src_Index_H
    BCS .Page_Row_Item_Max_Index
    
    LDA #<ITEM_INDEX_MAX
    STA FC_Temp_Dest_Index_L
    LDA #>ITEM_INDEX_MAX
    STA FC_Temp_Dest_Index_H
    
    JSR FC_Cmp_Item_Index
    BCC .Page_Row_Max_Page_End

.Page_Row_Item_Max_Index
    JSR FC_Page_Set_Item_Index_Max
    
.Page_Row_Max_Page_End

    ;列表刷新
    .IF ITEM_COUNT_MAX > ITEM_PAGE_SIZE
        JSR FC_Page_Index_Changed
    .ELSE
        JSR FC_Item_Index_Changed
    .ENDIF
    RTS
    
;转到前一页
.Page_Row_Pre_Page
    
    JSR FC_Item_Index_Change_Before
    
    JSR FC_Page_Get_Column_Min_Index
    CLC
    ADC #ITEM_PAGE_ROW - 1
    STA FC_Page_Item_Index
    
    ;页起始索引更新
    SEC
    LDA FC_Page_Index_L
    SBC #ITEM_PAGE_SIZE
    STA FC_Page_Index_L
    LDA FC_Page_Index_H
    SBC #$00
    STA FC_Page_Index_H
    
    ;项索引更新
    CLC
    LDA FC_Page_Item_Index
    ADC FC_Page_Index_L
    STA FC_Item_Index_L
    LDA FC_Page_Index_H
    ADC #$00
    STA FC_Item_Index_H
    
    ;列表刷新
    .IF ITEM_COUNT_MAX > ITEM_PAGE_SIZE
        JSR FC_Page_Index_Changed
    .ELSE
        JSR FC_Item_Index_Changed
    .ENDIF
    RTS
    
.Item_Pre
    JSR FC_Item_Pre
    RTS

;=================================================
;下一行
FC_Page_Row_Next
    JSR FC_Page_Index_Save
    JSR FC_Item_Index_Save
    JSR FC_Item_Index_Change_Before
    
    JSR FC_Page_Is_Max_Row_Index
    BCS .Page_Row_Next
    JSR FC_Item_Next
    RTS
    
.Page_Row_Next
    JSR FC_Page_Is_Max_Page_Index
    BCC .Page_Row_Next_Page

;转到最前页
.Page_Row_Min_Page
    
    JSR FC_Page_Get_Column_Min_Index
    STA FC_Item_Index_L
    
    LDA #$00
    STA FC_Item_Index_H
    STA FC_Page_Index_L
    STA FC_Page_Index_H
    
    ;列表刷新
    .IF ITEM_COUNT_MAX > ITEM_PAGE_SIZE
        JSR FC_Page_Index_Changed
    .ELSE
        JSR FC_Item_Index_Changed
    .ENDIF
    RTS

;转到下一页
.Page_Row_Next_Page
    
    JSR FC_Page_Get_Column_Min_Index
    STA FC_Page_Item_Index
    
    ;页起始索引更新
    CLC
    LDA FC_Page_Index_L
    ADC #ITEM_PAGE_SIZE
    STA FC_Page_Index_L
    LDA FC_Page_Index_H
    ADC #$00
    STA FC_Page_Index_H
    BCS .Page_Row_Item_Max_Index
    
    ;项索引更新
    CLC
    LDA FC_Page_Item_Index
    ADC FC_Page_Index_L
    STA FC_Item_Index_L
    LDA FC_Page_Index_H
    ADC #$00
    STA FC_Item_Index_H
    BCS .Page_Row_Item_Max_Index
    
    JSR FC_Page_Is_Item_Out_Of_Range
    BCS .Page_Row_Item_Max_Index
    
    ;列表刷新
    .IF ITEM_COUNT_MAX > ITEM_PAGE_SIZE
        JSR FC_Page_Index_Changed
    .ELSE
        JSR FC_Item_Index_Changed
    .ENDIF
    
    RTS
    
.Page_Row_Item_Max_Index
    LDA #<PAGE_LAST_COLUMN_INDEX_MAX
    STA FC_Item_Index_L
    LDA #>PAGE_LAST_COLUMN_INDEX_MAX
    STA FC_Item_Index_H

    ;列表刷新
    .IF ITEM_COUNT_MAX > ITEM_PAGE_SIZE
        JSR FC_Page_Index_Changed
    .ELSE
        JSR FC_Item_Index_Changed
    .ENDIF
    RTS

;=================================================
;前一列
FC_Page_Column_Pre
    JSR FC_Page_Index_Save
    JSR FC_Item_Index_Save
    
    .IF ITEM_PAGE_COLUMN > 1
        JSR FC_Item_Index_Change_Before
    .ENDIF
    
    LDA FC_Page_Column_Index
    BEQ .Page_Column_Pre
    
    SEC
    LDA FC_Item_Index_L
    SBC #ITEM_PAGE_ROW
    STA FC_Item_Index_L
    LDA FC_Item_Index_H
    SBC #$00
    STA FC_Item_Index_H
    JSR FC_Item_Index_Changed
    RTS

.Page_Column_Pre
    JSR FC_Page_Is_Min_Page_Index
    BCC .Page_Column_Pre_Page

;转到最末页
.Page_Column_Max_Page
    
    JSR FC_Page_Set_Page_Index_Max
    
    LDA #<PAGE_LAST_COLUMN_INDEX_MAX
    STA FC_Item_Index_L
    LDA #>PAGE_LAST_COLUMN_INDEX_MAX
    STA FC_Item_Index_H
    
    LDA FC_Page_Row_Index
    CLC
    ADC FC_Item_Index_L
    STA FC_Item_Index_L
    LDA FC_Item_Index_H
    ADC #$00
    STA FC_Item_Index_H
    BCS .Page_Column_Item_Max_Index
    
    JSR FC_Page_Is_Item_Out_Of_Range
    BCC .Page_Column_Update
    
.Page_Column_Item_Max_Index

    JSR FC_Page_Set_Item_Index_Max
    
.Page_Column_Update

    ;列表刷新
    .IF ITEM_COUNT_MAX > ITEM_PAGE_SIZE
        JSR FC_Page_Index_Changed
    .ELSE
        JSR FC_Item_Index_Changed
    .ENDIF
    
    RTS
    
.Page_Column_Pre_Page
    SEC
    LDA FC_Item_Index_L
    SBC #ITEM_PAGE_ROW
    STA FC_Item_Index_L
    LDA FC_Item_Index_H
    SBC #$00
    STA FC_Item_Index_H
    
    ;页起始索引更新
    SEC
    LDA FC_Page_Index_L
    SBC #ITEM_PAGE_SIZE
    STA FC_Page_Index_L
    LDA FC_Page_Index_H
    SBC #$00
    STA FC_Page_Index_H
    
    ;列表刷新
    .IF ITEM_COUNT_MAX > ITEM_PAGE_SIZE
        JSR FC_Page_Index_Changed
    .ELSE
        JSR FC_Item_Index_Changed
    .ENDIF
    RTS

;=================================================
;下一列
FC_Page_Column_Next
    JSR FC_Page_Index_Save
    JSR FC_Item_Index_Save
    
    .IF ITEM_PAGE_COLUMN > 1
        JSR FC_Item_Index_Change_Before
    .ENDIF
    
    JSR FC_Page_Is_Max_Column_Index
    BCS .Page_Column_Next
    
    CLC
    LDA FC_Item_Index_L
    ADC #ITEM_PAGE_ROW
    STA FC_Item_Index_L
    LDA FC_Item_Index_H
    ADC #$00
    STA FC_Item_Index_H
    BCS .Page_Column_Item_Max_Index
    
    JSR FC_Page_Is_Item_Out_Of_Range
    BCC .Page_Column_Update

.Page_Column_Item_Max_Index

    JSR FC_Page_Set_Item_Index_Max
    
.Page_Column_Update
    JSR FC_Item_Index_Changed
    RTS

.Page_Column_Next
    
    JSR FC_Page_Is_Max_Page_Index
    BCC .Page_Column_Next_Page

;转到最前页
.Page_Column_Min_Page
    
    LDA FC_Page_Row_Index
    STA FC_Item_Index_L
    
    LDA #$00
    STA FC_Item_Index_H
    STA FC_Page_Index_L
    STA FC_Page_Index_H
    
    ;列表刷新
    .IF ITEM_COUNT_MAX > ITEM_PAGE_SIZE
        JSR FC_Page_Index_Changed
    .ELSE
        JSR FC_Item_Index_Changed
    .ENDIF
    RTS

;转到下一页
.Page_Column_Next_Page
    
    ;项索引更新
    CLC
    LDA FC_Item_Index_L
    ADC #ITEM_PAGE_ROW
    STA FC_Item_Index_L
    LDA FC_Item_Index_H
    ADC #$00
    STA FC_Item_Index_H
    BCS .Page_Column_Next_Page_Item_Out_Of_Range
    
    ;页起始索引更新
    CLC
    LDA FC_Page_Index_L
    ADC #ITEM_PAGE_SIZE
    STA FC_Page_Index_L
    LDA FC_Page_Index_H
    ADC #$00
    STA FC_Page_Index_H
    
    JSR FC_Page_Is_Item_Out_Of_Range
    BCC .Page_Column_Next_Page_Update
    
.Page_Column_Next_Page_Item_Out_Of_Range
    JSR FC_Page_Set_Page_Index_Max
    JSR FC_Page_Set_Item_Index_Max

.Page_Column_Next_Page_Update
    ;列表刷新
    .IF ITEM_COUNT_MAX > ITEM_PAGE_SIZE
        JSR FC_Page_Index_Changed
    .ELSE
        JSR FC_Item_Index_Changed
    .ENDIF
    RTS

;=================================================
;前一页
FC_Page_Pre
    JSR FC_Item_Index_Save
    JSR FC_Page_Index_Save
    
    ;检查是否需要切换到最后页
    LDA FC_Page_Index_L
    ORA FC_Page_Index_H
    BNE .Page_Index_Pre

;最后页
.Page_Index_Max
    LDA #<PAGE_INDEX_MAX
    STA FC_Page_Index_L
    LDA #>PAGE_INDEX_MAX
    STA FC_Page_Index_H
    JSR FC_Page_Item_Index_Update
    JSR FC_Page_Index_Changed
    RTS

;前一页
.Page_Index_Pre
    SEC
    LDA FC_Page_Index_L
    SBC #ITEM_PAGE_SIZE
    STA FC_Page_Index_L
    LDA FC_Page_Index_H
    SBC #$00
    STA FC_Page_Index_H
    JSR FC_Page_Item_Index_Update
    JSR FC_Page_Index_Changed
    RTS

;=================================================
;下一页
FC_Page_Next
    JSR FC_Item_Index_Save
    JSR FC_Page_Index_Save
    
    ;检查是否需要切换到最前页
    LDA FC_Page_Index_L
    CMP #<PAGE_INDEX_MAX
    BNE .Page_Index_Next
    LDA FC_Page_Index_H
    CMP #>PAGE_INDEX_MAX
    BNE .Page_Index_Next

;最前页
.Page_Index_Min
    LDA #$00
    STA FC_Page_Index_L
    STA FC_Page_Index_H
    JSR FC_Page_Item_Index_Update
    JSR FC_Page_Index_Changed
    RTS

;下一页
.Page_Index_Next
    CLC
    LDA FC_Page_Index_L
    ADC #ITEM_PAGE_SIZE
    STA FC_Page_Index_L
    LDA FC_Page_Index_H
    ADC #$00
    STA FC_Page_Index_H
    JSR FC_Page_Item_Index_Update
    JSR FC_Page_Index_Changed
    RTS
    
;=================================================
;项索引变化
FC_Item_Index_Change_Before
    SEC
    LDA FC_Item_Index_L
    SBC FC_Page_Index_L
    STA FC_Cursor_Index_Last
    
    LDA FC_Page_Column_Index
    STA FC_Page_Column_Index_Last
    LDA FC_Page_Row_Index
    STA FC_Page_Row_Index_Last
    
    JSR Item_Text_Attributes_Update_No_Hover
    
    RTS

;=================================================
;项索引变化
FC_Item_Index_Changed
    SEC
    LDA FC_Item_Index_L
    SBC FC_Page_Index_L
    STA FC_Cursor_Index
    STA FC_Cursor_Index_Last
    STA FC_Page_Cursor_Index
    
    JSR FC_Cursor_Buffer_Flash
    JSR Reset_Item_Name_Scroll
    
    JSR Page_Item_Upate_Last_No_Active
    JSR Page_Item_Upate_Cur_Active
    
    JSR Item_Text_Attributes_Update_Hover
    
    .IFDEF FC_Sound_For_Item_Index_Changed
        JSR FC_Sound_For_Item_Index_Changed
    .ENDIF
    
    JSR FC_Page_Get_Row_Column_Index
    JSR FC_Page_Row_Column_Save
    
    LDA FC_NMI_Task_Flag
    AND #FC_NMI_TASK_ATTR ^ $FF
    STA FC_NMI_Task_Flag
    
    RTS

;=================================================
;页索引变化
FC_Page_Index_Changed
    LDX #$00
.Back_Chr_Index
    LDA FC_Chr_Index,X
    STA FC_Chr_Index_Last,X
    LDA #$00
    STA FC_Chr_Index_Ready,X
    INX
    CPX #ITEM_PAGE_ROW
    BCC .Back_Chr_Index

    SEC
    LDA FC_Item_Index_L
    SBC FC_Page_Index_L
    STA FC_Cursor_Index
    
    LDA FC_Cursor_Index_Last
    CMP FC_Cursor_Index
    BEQ .Start

    JSR Item_Text_Attributes_Update_No_Hover

.Start

    JSR FC_Cursor_Buffer_Flash
    JSR Reset_Item_Name_Scroll
    
    ;行列发生变化时还原上一行文本
    JSR FC_Page_Get_Row_Column_Index
    LDA FC_Page_Column_Index
    CMP FC_Page_Column_Index_Last
    BNE .No_Active
    LDA FC_Page_Row_Index
    CMP FC_Page_Row_Index_Last
    BEQ .Update
    
.No_Active
    
    LDA FC_Page_Index_L
    PHA
    LDA FC_Page_Index_H
    PHA
    
    LDA FC_Page_Index_Last_L
    STA FC_Page_Index_L
    LDA FC_Page_Index_Last_H
    STA FC_Page_Index_H
    
    PLA
    STA FC_Page_Index_H
    PLA
    STA FC_Page_Index_L
    
.Update
    
    .IFDEF FC_Sound_For_Page_Index_Changed
        JSR FC_Sound_For_Page_Index_Changed
    .ENDIF
    
    .IF ITEM_COUNT_MAX > ITEM_PAGE_SIZE
        JSR Page_List_Update
    .ELSE
        JSR Page_Item_Upate_Cur_Active
    .ENDIF
    
    JSR FC_Page_Get_Row_Column_Index
    JSR FC_Page_Row_Column_Save
    RTS
