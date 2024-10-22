;=================================================
FC_Cursor_Buffer_Flash
    LDA FC_Cursor_Index
    CMP FC_Cursor_Index_Last
    BNE .Hide

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
    STA FC_Data_Index_L
    
    LDA FC_Data_Index_L
    AND #$E0
    STA FC_Data_Addr_L
    INY
    LDA FC_Data_Index_H
    AND #$03
    STA FC_Data_Addr_H
    
    LSR FC_Data_Addr_H
    ROR FC_Data_Addr_L
    
    LSR FC_Data_Addr_H
    ROR FC_Data_Addr_L
    
    ;光标Y坐标
    LDX FC_DMA_Count
    LDA FC_Data_Addr_L
    SEC
    SBC #$01
    STA OAM_DMA_Buffer + $00,X
    CLC
    ADC #ITEM_CURSOR_OFFSET_Y
    STA OAM_DMA_Buffer + $00,X
    
    ;光标Tile
    LDA #ITEM_CURSOR_TILE_ID_X
    STA OAM_DMA_Buffer + $01,X
    
    ;光标属性
    LDA #(ITEM_CURSOR_ATTR_V_FLIP << 4) | (ITEM_CURSOR_ATTR_H_FLIP << 3) | (ITEM_CURSOR_ATTR_BACK << 2) | ITEM_CURSOR_ATTR_PAL
    STA OAM_DMA_Buffer + $02,X
    
    ;光标X坐标
    LDA FC_Data_Index_L
    AND #$1F
    ASL A
    ASL A
    ASL A
    SEC
    SBC #08
    STA OAM_DMA_Buffer + $03,X
    CLC
    ADC #ITEM_CURSOR_OFFSET_X
    STA OAM_DMA_Buffer + $03,X
    STX FC_DMA_Count
    
.End
    RTS
    
    
.Hide
    ;光标Y坐标
    LDX FC_DMA_Count
    LDA #$F8
    STA OAM_DMA_Buffer + $00,X
    STA OAM_DMA_Buffer + $01,X
    STA OAM_DMA_Buffer + $02,X
    STA OAM_DMA_Buffer + $03,X
    STX FC_DMA_Count
    
    RTS
    