set_property BITSTREAM.CONFIG.UNUSEDPIN pulldown [current_design]
set_property BITSTREAM.GENERAL.COMPRESS true [current_design]
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 85.0 [current_design]
set_property BITSTREAM.CONFIG.SPI_FALL_EDGE YES [current_design]
set_property CONFIG_VOLTAGE 1.8 [current_design]
set_property CONFIG_MODE SPIx4 [current_design]
set_property CFGBVS GND [current_design]

# SI570 user clock
set_property -dict {LOC AV19 IOSTANDARD LVDS} [get_ports clk_user_clk_n]
set_property -dict {LOC AU19 IOSTANDARD LVDS} [get_ports clk_user_clk_p]

set_property BITSTREAM.General.UnconstrainedPins {Allow} [current_design]