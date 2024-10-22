# FC 基础框架示例

## 

很详细的框架代码, 涵盖 FC ROM的 重启处理, NMI中断处理, IRQ处理, PPU处理, 手柄输入处理, 以及常见的Mapper 的操作

框架例子中使用的 Mapper 包括:

| 公司     | 映射器(Mapper号)                                             |
| -------- | ------------------------------------------------------------ |
| Nintendo | MMC1 (Mapper 1)<br />MMC2 (Mapper 9)<br />MMC3 (Mapper 4)<br />MMC4 (Mapper 10)<br />MMC5 (Mapper 5) |
| Konami   | VRC1 (Mapper 75)<br />VRC2 (Mapper 22 & 23 & 25)<br />VRC3 (Mapper 73)<br />VRC4 (Mapper 21 & 23 & 25)<br />VRC6 (Mapper 24 & 26)<br />VRC7 (Mapper 85) |
| Sunsoft  | Sunsoft FME-7 / 5A /5B (Mapper 69)                           |
| Namco    | Namco 163 (Mapper 19)                                        |



源码文件如下:

| 文件名                         | 描述                    |
| ------------------------------ | ----------------------- |
| [fc_basic_constant.asm](fc_basic_constant.asm) | NES端口常量             |
| [fc_basic_config.asm](fc_basic_config.asm) | 配置                    |
| [fc_basic_framework.asm](fc_basic_framework.asm) | 框架                    |
| [fc_basic_data.asm](fc_basic_data.asm) | 数据(文本内容等等)      |
| [fc_basic_chr.asm](fc_basic_chr.asm) | CHR数据                 |
| [fc_basic_ppu.asm](fc_basic_ppu.asm) | PPU图像处理             |
| [fc_basic_text.asm](fc_basic_text.asm) | 文本处理                |
| [fc_basic_joy.asm](fc_basic_joy.asm) | 手柄输入处理            |
| [fc_basic_joy_test.asm](fc_basic_joy_test.asm) | 手柄测试                |
| [fc_basic_mapper.asm](fc_basic_mapper.asm) | Mapper处理              |
| [fc_basic_mapper_mmc1.asm](fc_basic_mapper_mmc1.asm) | Nintendo MMC1 操作      |
| [fc_basic_mapper_mmc2.asm](fc_basic_mapper_mmc2.asm) | Nintendo MMC2 操作      |
| [fc_basic_mapper_mmc3.asm](fc_basic_mapper_mmc3.asm) | Nintendo MMC3 操作      |
| [fc_basic_mapper_mmc4.asm](fc_basic_mapper_mmc4.asm) | Nintendo MMC4 操作      |
| [fc_basic_mapper_mmc5.asm](fc_basic_mapper_mmc5.asm) | Nintendo MMC5 操作      |
| [fc_basic_mapper_vrc1.asm](fc_basic_mapper_vrc1.asm) | Konami VRC1 操作        |
| [fc_basic_mapper_vrc3.asm](fc_basic_mapper_vrc3.asm) | Konami VRC3 操作        |
| [fc_basic_mapper_vrc4.asm](fc_basic_mapper_vrc4.asm) | Konami VRC4 操作        |
| [fc_basic_mapper_vrc6.asm](fc_basic_mapper_vrc6.asm) | Konami VRC6 操作        |
| [fc_basic_mapper_vrc7.asm](fc_basic_mapper_vrc7.asm) | Konami VRC7 操作        |
| [fc_basic_mapper_namco_163.asm](fc_basic_mapper_namco_163.asm) | Namco 163 操作          |
| [fc_basic_mapper_sunsoft_5b.asm](fc_basic_mapper_sunsoft_5b.asm) | Sunsoft FME7/5A/5B 操作 |
| [fc_basic_framework_bg.chr](fc_basic_framework_bg.chr) | 背景图形数据            |
| [fc_basic_framework_sp.chr](fc_basic_framework_sp.chr) | 精灵图形数据            |
| [fc_basic_music.asm](fc_basic_music.asm) | 音乐播放处理 |
| [fc_basic_music_bank.asm](fc_basic_music_bank.asm) | 音乐数据配置 |
| [fc_basic_interface.asm](fc_basic_interface.asm) | 外部切页接口 |

