;音乐配置
FC_MUSIC_THEME               =   3
                                ;0:经典BiuBiuBIu
                                ;1:魂斗罗
                                ;2:超级魂斗罗
                                ;3:洛克人3
                                
;音乐播放
MUSIC_PLAY_ENABLE           =   1       ;启用音乐播放
MUSIC_INFO_SHOW             =   0       ;曲目信息显示
MUSIC_INFO_POS              =   $2041   ;曲目信息位置
MUSIC_CLEAR_ENABLE          =   0       ;启用音乐清理
;--------------------------------------------------

    .IF FC_MUSIC_THEME > 0
ITEM_ENTER_TIME_DELAY       =   45      ;启用自定义音乐项进入延迟帧数
    .ELSE
ITEM_ENTER_TIME_DELAY       =   20      ;不启用自定义音乐项进入延迟帧数
    .ENDIF

;==================================================
;自定义音效配置
;==================================================
;--------------------------------------------------
;魂斗罗音源
;--------------------------------------------------
    .IF 1 = FC_MUSIC_THEME
CUSTOM_MUSCI_BACKGROUND     =   6      ;背景音乐曲目号
CUSTOM_MUSIC_ITEM_CHANGE    =   29      ;项切换音乐曲目号
CUSTOM_MUSIC_PAGE_CHANGE    =   26      ;页切换音乐曲目号
CUSTOM_MUSIC_ITEM_ENTER     =   38      ;项进入音乐曲目号
    .MACRO MACRO_INCBIN_NSF_DATA
        .INCBIN "data/Contra (J).nsf",\1,\2
    .ENDM
    .ENDIF
    
;--------------------------------------------------
;超级魂斗罗音源
;--------------------------------------------------
    .IF 2 = FC_MUSIC_THEME
CUSTOM_MUSCI_BACKGROUND     =   14      ;背景音乐曲目号
CUSTOM_MUSIC_ITEM_CHANGE    =   22      ;项切换音乐曲目号
CUSTOM_MUSIC_PAGE_CHANGE    =   19      ;页切换音乐曲目号
CUSTOM_MUSIC_ITEM_ENTER     =   36      ;项进入音乐曲目号
    .MACRO MACRO_INCBIN_NSF_DATA
        .INCBIN "data/Super Contra (J).nsf",\1,\2
    .ENDM
    .ENDIF

;--------------------------------------------------
;洛克人3音源
;--------------------------------------------------
    .IF 3 = FC_MUSIC_THEME
CUSTOM_MUSCI_BACKGROUND     =   01      ;背景音乐曲目号
CUSTOM_MUSIC_ITEM_CHANGE    =   22      ;项切换音乐曲目号
CUSTOM_MUSIC_PAGE_CHANGE    =   30      ;页切换音乐曲目号
CUSTOM_MUSIC_ITEM_ENTER     =   21      ;项进入音乐曲目号
    .MACRO MACRO_INCBIN_NSF_DATA
        .INCBIN "data/Rockman 3.nsf",\1,\2
    .ENDM
    .ENDIF
