;=================================================
;项切换音效
FC_Sound_For_Item_Index_Changed
    .IF MUSIC_PLAY_ENABLE
        .IF (FC_MUSIC_THEME > 0) & (CUSTOM_MUSIC_ITEM_CHANGE > 0)
            LDA #CUSTOM_MUSIC_ITEM_CHANGE - 1
            STA FC_Music_Index
            JSR Music_Track_Select
        .ELSE
             LDA #$03
             STA $4015
             LDA #$87
             STA $4000
             LDA #$89
             STA $4001
             LDA #$F0
             STA $4002
             LDA #$00
             STA $4003
        .ENDIF
    
    .ENDIF

    RTS

;=================================================
;页切换音效
FC_Sound_For_Page_Index_Changed

    .IF MUSIC_PLAY_ENABLE > 0
        .IF (FC_MUSIC_THEME > 0) & (CUSTOM_MUSIC_PAGE_CHANGE > 0)
            LDA #CUSTOM_MUSIC_PAGE_CHANGE - 1
            STA FC_Music_Index
            JSR Music_Track_Select
        .ELSE
             LDA #$03
             STA $4015
             LDA #$87
             STA $4000
             LDA #$89
             STA $4001
             LDA #$F0
             STA $4002
             LDA #$00
             STA $4003
        .ENDIF
    
    .ENDIF

    RTS

;=================================================
;项进入音效
FC_Sound_For_Enter_Item

    .IF MUSIC_PLAY_ENABLE > 0
        .IF (FC_MUSIC_THEME > 0) & (CUSTOM_MUSIC_ITEM_ENTER > 0)
            LDA #CUSTOM_MUSIC_ITEM_ENTER - 1
            STA FC_Music_Index
            JSR Music_Track_Select
        .ELSE
             LDA #$02
             STA $4015
             LDA #$3F
             STA $4004
             LDA #$9A
             STA $4005
             LDA #$FF
             STA $4006
             LDA #$00
             STA $4007
        .ENDIF
    
    .ENDIF

    RTS
