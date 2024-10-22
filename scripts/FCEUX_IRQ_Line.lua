-----------------------
-- Name: Show IRQ Scanline for FCEUX
-- Author: FlameCyclone
-- Date: 2023.8.5
-----------------------
-- Draws a line for IRQ
-----------------------

local cur_frame_cycles = 0
local last_frame_cycles = 0
local frame_cycles = 0
local irq_addr = 0
local reset_addr = 0
local nmi_addr = 0

--IRQ回调
function on_irq()
    
    --如果IRQ开始就RTI了, 那就是没有IRQ
    instruction = memory.readbyte(irq_addr)
    if 0x40 == instruction then
        return nil    
    end
    
    NTSC_cycles = 29781
    PAL_cycles = 33248
    Dendy_cycles = 35464

    --总扫描线
    scan_line_total = 262
    
    --NMI扫描线
    vblank_scan_line = 240
    
    --每条扫描线CPU周期
    scan_line_cycle = 341/3
    
    --NTSC制式
    if (frame_cycles > (NTSC_cycles - 10) and frame_cycles < (NTSC_cycles + 10)) then
        scan_line_total = 262
        vblank_scan_line = 240
        scan_line_cycle = 341/3
    --PAL制式
    elseif (frame_cycles > (PAL_cycles - 10) and frame_cycles < (PAL_cycles + 10)) then
        scan_line_total = 312
        vblank_scan_line = 240
        scan_line_cycle = 341/3.2
    --Dendy制式
    elseif (frame_cycles > (Dendy_cycles - 10) and frame_cycles < (Dendy_cycles + 10)) then
        scan_line_total = 312
        vblank_scan_line = 290
        scan_line_cycle = 341/3
    end
    
    if frame_cycles > 0 then
        current_cpu_cycles = debugger.getcyclescount() - last_frame_cycles
        irq_scanline = (current_cpu_cycles - (scan_line_total - vblank_scan_line) * scan_line_cycle) / scan_line_cycle
        gui.line(0, irq_scanline, 256, irq_scanline, "#ffff00ff")
        gui.text(0, irq_scanline + 2, string.format("%d", irq_scanline), "#ffff00ff", "#0000001f")
    end
end

--停止回调
function on_exit()
    emu.print("stop...")
end

emu.registerexit(on_exit)

emu.print("start...")
while (true) do
    cur_frame_cycles = debugger.getcyclescount()
	emu.frameadvance()
    last_frame_cycles = debugger.getcyclescount()
    frame_cycles = last_frame_cycles - cur_frame_cycles

    --IRQ入口变化时重新注册IRQ回调
    irq_addr_check = memory.readword(0xFFFE)
    if irq_addr ~= irq_addr_check then
        memory.registerrun(irq_addr_check, on_irq)
        irq_addr = irq_addr_check
        
        --检测是否存在 IRQ
        instruction = memory.readbyte(irq_addr)
        if 0x40 ~= instruction then
            emu.print(string.format("irq addr = $%04X", irq_addr))
        else
            emu.print(string.format("no irq"))
        end
    end
    
    reset_addr_check = memory.readword(0xFFFC)
    if reset_addr ~= reset_addr_check then
        reset_addr = reset_addr_check
    end
    
    nmi_addr_check = memory.readword(0xFFFA)
    if nmi_addr ~= nmi_addr_check then
        nmi_addr = nmi_addr_check
    end
    
    gui.text(1, 9 * 1, string.format("nmi: $%04X", nmi_addr), "#ffff00ff", "#0000001f")
    gui.text(64, 9 * 1, string.format("reset: $%04X", reset_addr), "#ffff00ff", "#0000001f")
    
    --检测是否存在 IRQ
    instruction = memory.readbyte(irq_addr)
    if 0x40 ~= instruction then
        gui.text(136, 9 * 1, string.format("irq: $%04X", irq_addr), "#ffff00ff", "#0000001f")
    else
        gui.text(136, 9 * 1, string.format("irq: $%04X(no irq)", irq_addr), "#ffff00ff", "#0000001f")
    end
end
