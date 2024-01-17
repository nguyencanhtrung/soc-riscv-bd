# ----------------------------------------------------------------------------
# 
# Project   : 5G UE
# Filename  : ila
# 
# Author    : Nguyen Canh Trung
# Email     : nguyencanhtrung 'at' me 'dot' com
# Date      : 2024-01-17 15:31:26
# Last Modified : 2024-01-17 15:32:52
# Modified By   : Nguyen Canh Trung
# 
# Description: 
# 
# HISTORY:
# Date      	By	Comments
# ----------	---	---------------------------------------------------------
# 2024-01-17	NCT	Add ILA for debugging OCM transaction
# ----------------------------------------------------------------------------


# OCM ILA
create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 DDR/system_ila_0
set_property name ila_ocm [get_bd_cells DDR/system_ila_0]
set_property -dict [list \
  CONFIG.C_NUM_MONITOR_SLOTS {3} \
  CONFIG.C_SLOT {0} \
  CONFIG.C_SLOT_1_INTF_TYPE {xilinx.com:interface:bram_rtl:1.0} \
] [get_bd_cells DDR/ila_ocm]

connect_bd_intf_net [get_bd_intf_pins DDR/ila_ocm/SLOT_0_AXI] [get_bd_intf_pins DDR/smartconnect_1/S00_AXI]
connect_bd_intf_net [get_bd_intf_pins DDR/ila_ocm/SLOT_2_AXI] [get_bd_intf_pins DDR/axi_bram_ctrl_0/S_AXI]
connect_bd_intf_net [get_bd_intf_pins DDR/ila_ocm/SLOT_1_BRAM] [get_bd_intf_pins DDR/axi_bram_ctrl_0/BRAM_PORTA]
connect_bd_net [get_bd_pins DDR/axi_clock] [get_bd_pins DDR/ila_ocm/clk]
connect_bd_net [get_bd_pins DDR/axi_reset] [get_bd_pins DDR/ila_ocm/resetn]


# DDR4 ILA
create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 DDR/system_ila_0
set_property name ila_ddr [get_bd_cells DDR/system_ila_0]
connect_bd_intf_net [get_bd_intf_pins DDR/ila_ddr/SLOT_0_AXI] [get_bd_intf_pins DDR/smartconnect_1/M00_AXI]
connect_bd_net [get_bd_pins DDR/ila_ddr/clk] [get_bd_pins DDR/ddr4_0/c0_ddr4_ui_clk]
connect_bd_net [get_bd_pins DDR/ila_ddr/resetn] [get_bd_pins DDR/synchronizer_0/dout]