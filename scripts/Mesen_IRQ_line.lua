-----------------------
-- Name: Show IRQ Scanline for Mesen
-- Author: FlameCyclone
-- Date: 2023.8.5
-----------------------
-- Draws a line for IRQ
-----------------------

local consoleType = emu.getState()["consoleType"]
if consoleType ~= "Nes" then
  emu.displayMessage("Script", "This script only works on the NES.")
  return
end

function on_irq()
    line_color   = 0x00ffff00
    bkg_color    = 0xf0000000
    text_color   = 0x00ffff00
    irq_scanline     = emu.getState()['ppu.scanline']
    
    
    nmi_addr = emu.readWord(0xfffa, emu.memType.nesDebug , false)
    irq_addr = emu.readWord(0xfffe, emu.memType.nesDebug , false)
    emu.drawLine(0, irq_scanline, 256, irq_scanline, line_color, 1)
    
    emu.drawString(1, 1, string.format("nmi: $%04X", nmi_addr), text_color, bkg_color)
    emu.drawString(1, 10, string.format("irq: $%04X", irq_addr), text_color, bkg_color)
    emu.drawString(0, irq_scanline + 2, irq_scanline, text_color, bkg_color)
end

emu.addEventCallback(on_irq, emu.eventType.irq)
emu.displayMessage("Script", "Irq Scanline")
