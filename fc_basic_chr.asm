;=================================================
;CHR 数据
;=================================================
    .BANK CHR_DATA_BANK, "CHR Data"

    ;英文字符普通
    .ORG CHR_DATA_ADDR + $0400
    .INCBIN "tmp/chr_english.chr",$0,$1000
    
    .ORG CHR_DATA_ADDR + $0EF0
    .INCBIN "data/Cursor.chr",$0,$10

    ;标题文本CHR
    .ORG CHR_DATA_ADDR + $1000
    .INCBIN "tmp/chr_title.chr"

    .ORG CHR_DATA_ADDR + $1400
    ;节目单文本CHR
    .INCBIN "tmp/chr_list.chr"

    ;CHR末尾填充
    .IF NES_8KB_CHR_SIZE > 0
        .BANK NES_16KB_PRG_SIZE * 2 + NES_8KB_CHR_SIZE - 1
        .ORG $1FFF
        .HEX 00
    .ELSE
        
    .ENDIF
