@echo off

set IN_FILE_NAME=fc_basic_main.asm
set OUT_FILE_NAME=fc_basic_main.nes
set NESASM3=nesasm_Gui_3_2_x86.exe

cd /d %~dp0

FC_Menu_List_Tool.exe -in text/text_title.txt -asm tmp/title_output -list tmp/title_output.txt -line 16 -return 8 -begin 0 -name Title_Text_ -bank_count 1 -index_enable 0
FC_Font_Tool_Title.exe -in tmp/title_output.txt -out tmp/chr_title.chr -ini Config/FC_Font_Tool_Title.ini
FC_Menu_List_Tool.exe -in text/text_list.txt -asm tmp/list_output -list tmp/list_output.txt -line 16 -return 8 -begin 0 -name Item_Text_ -info tmp/list_info.asm -bank_count 8 -index_enable 1
FC_Font_Tool_List.exe -in tmp/list_output.txt -out tmp/chr_list.chr -ini Config/FC_Font_Tool_List.ini
FC_Font_Tool_List.exe -in data/English.txt -out tmp/chr_english.chr -ini Config/FC_Font_Tool_English.ini
call "%NESASM3%" %IN_FILE_NAME% -out "%OUT_FILE_NAME%"
set result=%errorlevel%

IF 0 NEQ %result% (
    pause
) else (
    rem TODO
)

goto:eof