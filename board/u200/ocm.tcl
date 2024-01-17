# ------------------------------------------
# Author:   Nguyen Canh Trung
# Email:    nguyencanhtrung (at) me (dot) com
# Date:     2024-01-11 12:17:17
# Filename: ocm
# Last Modified by:   Nguyen Canh Trung
# Last Modified time: 2024-01-12 16:26:22
# ------------------------------------------
#
# Adding BRAM as OCM
#   Size: 4 MB
# DDR4 Memory
#   Size: 1 GB
#
#   32bit CPU supports max 4GB
#   64bit CPU supports max 16GB
#

# AXI BRAM controller 
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 DDR/axi_bram_ctrl_0
set_property CONFIG.DATA_WIDTH {64} [get_bd_cells DDR/axi_bram_ctrl_0]
set_property CONFIG.SINGLE_PORT_BRAM {1} [get_bd_cells DDR/axi_bram_ctrl_0]

# Block RAM - use URAM type
create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 DDR/blk_mem_gen_0
set_property -dict [list \
  CONFIG.PRIM_type_to_Implement {URAM} \
  CONFIG.use_bram_block {BRAM_Controller} \
] [get_bd_cells DDR/blk_mem_gen_0]

# Connection
connect_bd_intf_net [get_bd_intf_pins DDR/axi_bram_ctrl_0/BRAM_PORTA] [get_bd_intf_pins DDR/blk_mem_gen_0/BRAM_PORTA]
connect_bd_net [get_bd_pins DDR/axi_clock] [get_bd_pins DDR/axi_bram_ctrl_0/s_axi_aclk]
connect_bd_net [get_bd_pins DDR/axi_reset] [get_bd_pins DDR/axi_bram_ctrl_0/s_axi_aresetn]

# Smart connect - add one more master AXI
set_property CONFIG.NUM_MI {2} [get_bd_cells DDR/smartconnect_1]

apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { \
    Clk_master {/clk_wiz_0/clk_out1 (125 MHz)} \
    Clk_slave {/clk_wiz_0/clk_out1 (125 MHz)} \
    Clk_xbar {/clk_wiz_0/clk_out1 (125 MHz)} \
    Master {/RocketChip/MEM_AXI4} \
    Slave {/DDR/axi_bram_ctrl_0/S_AXI} \
    ddr_seg {Auto} intc_ip {/DDR/smartconnect_1} \
    master_apm {0}}  \
    [get_bd_intf_pins DDR/axi_bram_ctrl_0/S_AXI]

set_property name on_chip_mem [get_bd_cells DDR/blk_mem_gen_0]

# Set 1GB for DDR4
set_property range 1G [get_bd_addr_segs {RocketChip/MEM_AXI4/SEG_ddr4_0_C0_DDR4_ADDRESS_BLOCK}]

# Set OCM to 4MB
include_bd_addr_seg [get_bd_addr_segs -excluded RocketChip/MEM_AXI4/SEG_axi_bram_ctrl_0_Mem0]
assign_bd_address -target_address_space /RocketChip/MEM_AXI4 [get_bd_addr_segs DDR/axi_bram_ctrl_0/S_AXI/Mem0] -force
set_property offset 0x40000000 [get_bd_addr_segs {RocketChip/MEM_AXI4/SEG_axi_bram_ctrl_0_Mem0}]
set_property range 4M [get_bd_addr_segs {RocketChip/MEM_AXI4/SEG_axi_bram_ctrl_0_Mem0}]