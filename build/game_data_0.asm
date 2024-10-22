game_data_begin_000
 .WORD 0
game_data_list_000
 .WORD game_data_000,game_data_001,game_data_002

game_data_000;[忍者龙剑传][Ninja Gaiden][J][Mapper4]
 .DW $0040 ;000001000000 00080000 CRC32: ABDCF1F8 Size: 00020000
 .DB $08 ;PRG Size
 .DW $0070 ;000001110000 000E0000 CRC32: D9C285E1 Size: 00020000
 .DB $10 ;CHR Size
 .DB %00000000 ;Mirroring D0(0: H 1: V) Battery: D1(0: N 1: Y) Four-Screen: D2(0: N 1: Y)
 .DB 004 ;Mapper
game_data_001;[忍者龙剑传2][Ninja Gaiden 2][J][Mapper4]
 .DW $0050 ;000001010000 000A0000 CRC32: DEBEA5A6 Size: 00020000
 .DB $08 ;PRG Size
 .DW $0080 ;000010000000 00100000 CRC32: 91012A18 Size: 00020000
 .DB $10 ;CHR Size
 .DB %00000001 ;Mirroring D0(0: H 1: V) Battery: D1(0: N 1: Y) Four-Screen: D2(0: N 1: Y)
 .DB 004 ;Mapper
game_data_002;[忍者龙剑传3][Ninja Gaiden 3][J][Mapper4]
 .DW $0060 ;000001100000 000C0000 CRC32: AAFE699C Size: 00020000
 .DB $08 ;PRG Size
 .DW $0090 ;000010010000 00120000 CRC32: 0A5BE22C Size: 00020000
 .DB $10 ;CHR Size
 .DB %00000001 ;Mirroring D0(0: H 1: V) Battery: D1(0: N 1: Y) Four-Screen: D2(0: N 1: Y)
 .DB 004 ;Mapper

