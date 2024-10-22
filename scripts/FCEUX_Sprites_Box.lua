-----------------------
-- Name: Show Mouse Position for FCEUX
-- Author: FlameCyclone
-- Date: 2023.8.5
-----------------------
-- Show Mouse Position
-----------------------
-----------------------
-- Name: Show Sprites Box for FCEUX
-- Author: FlameCyclone
-- Date: 2023.8.5
-----------------------
-- Draws a line for IRQ
-----------------------

local oam_dma_addr = 0
local sprites_size = 16
local sprite_data_index = 0
local sprite_data_list = {0}

--初始化精灵缓冲
for i = 0, 63, 1 do
    sprite_data_list[i * 4 + 0] = 0xF8
    sprite_data_list[i * 4 + 1] = 0xF8
    sprite_data_list[i * 4 + 2] = 0xF8
    sprite_data_list[i * 4 + 3] = 0xF8
end

--PPU控制写入回调
function on_ppu_ctrl(address, size, value)
    --检测是否为 8 * 16精灵模式
    if (0 ~= AND(value, 0x20)) then
        sprites_size = 16
    else
        sprites_size = 8
    end
end

--精灵数据DMA写入回调
function on_oam_dma_write(address, size, value)
    oam_dma_addr = value
end

--精灵 OAM_ADDR 写入回调
function on_oam_addr(address, size, value)
    sprite_data_index = value
end

--精灵 OAM_DATA 写入回调
function on_oam_data(address, size, value)
    if sprite_data_index < 256 then
        sprite_data_list[sprite_data_index] = value
        sprite_data_index = sprite_data_index + 1
    end
end

--注册端口写入回调
memory.registerwrite(0x4014, on_oam_dma_write)
memory.registerwrite(0x2000, on_ppu_ctrl)
memory.registerwrite(0x2003, on_oam_addr)
memory.registerwrite(0x2004, on_oam_data)

--停止回调
function on_exit()
    emu.print("stop...")
end

emu.registerexit(on_exit)

emu.print("start...")
while (true) do
    state = input.get()
    xmouse = state['xmouse'];
    ymouse = state['ymouse'];
    leftclick = state['leftclick'];
    
    sprite_hit = false
    sprite_hit_x = 0
    sprite_hit_y = 0
    sprite_hit_id = 0
    sprite_hit_tile = 0
    
    x_offset = 0
    y_offset = 0
    
    if xmouse > (256 - 76) then
        x_offset = -76
    end

    if ymouse > (240 - 48) then
        y_offset = -48
    end

    if leftclick then
        gui.text(xmouse + 8 + x_offset, ymouse + y_offset, string.format("[%d,%d]", xmouse, ymouse), "#00ff00ff", "#0000007f")
    end
    
    for i = 0, 63, 1 do
        sprite_x = sprite_data_list[i * 4 + 3]
        sprite_y = sprite_data_list[i * 4 + 0]
        sprite_tile = sprite_data_list[i * 4 + 1]
        if (sprite_y < 240) then
            gui.drawbox(sprite_x, sprite_y, sprite_x + 8, sprite_y + sprites_size, "#00000000", "#ffff00ff")
        end
        
        if (ymouse >= sprite_y and ymouse < sprite_y + sprites_size) and (xmouse >= sprite_x and xmouse < sprite_x + 8) then
            sprite_hit = true
            sprite_hit_x = sprite_x
            sprite_hit_y = sprite_y
            sprite_hit_id = i
            sprite_hit_tile = sprite_tile
            
        end
    end
    
    if sprite_hit then
        gui.drawbox(sprite_hit_x, sprite_hit_y, sprite_hit_x + 8, sprite_hit_y + sprites_size, "#00ff007f", "#ff0000ff")
        gui.text(xmouse + 8 + x_offset, ymouse + 9 + y_offset, string.format("[pos: $%02X,$%02X]", sprite_hit_x, sprite_hit_y), "#00ff00ff", "#0000007f")
        gui.text(xmouse + 8 + x_offset, ymouse + 18 + y_offset, string.format("[addr: $%04X]", oam_dma_addr * 256 + sprite_hit_id * 4), "#00ff00ff", "#0000007f")
        gui.text(xmouse + 8 + x_offset, ymouse + 27 + y_offset, string.format("[id: $%02X]", sprite_hit_id), "#00ff00ff", "#0000007f")
        gui.text(xmouse + 8 + x_offset, ymouse + 36 + y_offset, string.format("[tile: $%02X]", sprite_hit_tile), "#00ff00ff", "#0000007f")
    end
    
    sprite_data_index = 0
    
	FCEU.frameadvance();
end