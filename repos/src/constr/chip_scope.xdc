set_property MARK_DEBUG true [get_nets {pcam_csi_sys_i/mipi_csi2_tx_subsyst_0/inst/mipi_csi2_tx_ctrl_0_tx_mipi_ppi_if_DL0_TXDATAHS[0]}]
set_property MARK_DEBUG true [get_nets {pcam_csi_sys_i/mipi_csi2_tx_subsyst_0/inst/mipi_csi2_tx_ctrl_0_tx_mipi_ppi_if_DL0_TXDATAHS[1]}]
set_property MARK_DEBUG true [get_nets {pcam_csi_sys_i/mipi_csi2_tx_subsyst_0/inst/mipi_csi2_tx_ctrl_0_tx_mipi_ppi_if_DL0_TXDATAHS[2]}]
set_property MARK_DEBUG true [get_nets {pcam_csi_sys_i/mipi_csi2_tx_subsyst_0/inst/mipi_csi2_tx_ctrl_0_tx_mipi_ppi_if_DL0_TXDATAHS[3]}]
set_property MARK_DEBUG true [get_nets {pcam_csi_sys_i/mipi_csi2_tx_subsyst_0/inst/mipi_csi2_tx_ctrl_0_tx_mipi_ppi_if_DL0_TXDATAHS[4]}]
set_property MARK_DEBUG true [get_nets {pcam_csi_sys_i/mipi_csi2_tx_subsyst_0/inst/mipi_csi2_tx_ctrl_0_tx_mipi_ppi_if_DL0_TXDATAHS[5]}]
set_property MARK_DEBUG true [get_nets {pcam_csi_sys_i/mipi_csi2_tx_subsyst_0/inst/mipi_csi2_tx_ctrl_0_tx_mipi_ppi_if_DL0_TXDATAHS[6]}]
set_property MARK_DEBUG true [get_nets {pcam_csi_sys_i/mipi_csi2_tx_subsyst_0/inst/mipi_csi2_tx_ctrl_0_tx_mipi_ppi_if_DL0_TXDATAHS[7]}]
set_property MARK_DEBUG true [get_nets pcam_csi_sys_i/mipi_csi2_tx_subsyst_0/inst/mipi_csi2_tx_ctrl_0_tx_mipi_ppi_if_DL0_TXREQUESTHS]
set_property MARK_DEBUG true [get_nets pcam_csi_sys_i/mipi_csi2_tx_subsyst_0/inst/mipi_csi2_tx_ctrl_0_tx_mipi_ppi_if_DL0_TXREADYHS]
set_property MARK_DEBUG true [get_nets pcam_csi_sys_i/mipi_csi2_tx_subsyst_0/inst/txbyteclkhs]
set_property MARK_DEBUG false [get_nets {pcam_csi_sys_i/axi_vdma_0_M_AXI_MM2S_ARBURST[0]}]
set_property MARK_DEBUG false [get_nets {pcam_csi_sys_i/axi_vdma_0_M_AXI_S2MM_AWBURST[0]}]


set_property MARK_DEBUG false [get_nets pcam_csi_sys_i/mipi_csi2_tx_subsyst_0/inst/mipi_dphy_0_init_done]

create_debug_core csi_tx_hs_ila ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores csi_tx_hs_ila]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores csi_tx_hs_ila]
set_property C_ADV_TRIGGER false [get_debug_cores csi_tx_hs_ila]
set_property C_DATA_DEPTH 1024 [get_debug_cores csi_tx_hs_ila]
set_property C_EN_STRG_QUAL false [get_debug_cores csi_tx_hs_ila]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores csi_tx_hs_ila]
set_property C_TRIGIN_EN false [get_debug_cores csi_tx_hs_ila]
set_property C_TRIGOUT_EN false [get_debug_cores csi_tx_hs_ila]
set_property port_width 1 [get_debug_ports csi_tx_hs_ila/clk]
connect_debug_port csi_tx_hs_ila/clk [get_nets [list pcam_csi_sys_i/mipi_csi2_tx_subsyst_0/inst/txbyteclkhs]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports csi_tx_hs_ila/probe0]
set_property port_width 8 [get_debug_ports csi_tx_hs_ila/probe0]
connect_debug_port csi_tx_hs_ila/probe0 [get_nets [list {pcam_csi_sys_i/mipi_csi2_tx_subsyst_0/inst/mipi_csi2_tx_ctrl_0_tx_mipi_ppi_if_DL0_TXDATAHS[0]} {pcam_csi_sys_i/mipi_csi2_tx_subsyst_0/inst/mipi_csi2_tx_ctrl_0_tx_mipi_ppi_if_DL0_TXDATAHS[1]} {pcam_csi_sys_i/mipi_csi2_tx_subsyst_0/inst/mipi_csi2_tx_ctrl_0_tx_mipi_ppi_if_DL0_TXDATAHS[2]} {pcam_csi_sys_i/mipi_csi2_tx_subsyst_0/inst/mipi_csi2_tx_ctrl_0_tx_mipi_ppi_if_DL0_TXDATAHS[3]} {pcam_csi_sys_i/mipi_csi2_tx_subsyst_0/inst/mipi_csi2_tx_ctrl_0_tx_mipi_ppi_if_DL0_TXDATAHS[4]} {pcam_csi_sys_i/mipi_csi2_tx_subsyst_0/inst/mipi_csi2_tx_ctrl_0_tx_mipi_ppi_if_DL0_TXDATAHS[5]} {pcam_csi_sys_i/mipi_csi2_tx_subsyst_0/inst/mipi_csi2_tx_ctrl_0_tx_mipi_ppi_if_DL0_TXDATAHS[6]} {pcam_csi_sys_i/mipi_csi2_tx_subsyst_0/inst/mipi_csi2_tx_ctrl_0_tx_mipi_ppi_if_DL0_TXDATAHS[7]}]]
create_debug_port csi_tx_hs_ila probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports csi_tx_hs_ila/probe1]
set_property port_width 1 [get_debug_ports csi_tx_hs_ila/probe1]
connect_debug_port csi_tx_hs_ila/probe1 [get_nets [list pcam_csi_sys_i/mipi_csi2_tx_subsyst_0/inst/mipi_csi2_tx_ctrl_0_tx_mipi_ppi_if_DL0_TXREQUESTHS]]
create_debug_port csi_tx_hs_ila probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports csi_tx_hs_ila/probe2]
set_property port_width 1 [get_debug_ports csi_tx_hs_ila/probe2]
connect_debug_port csi_tx_hs_ila/probe2 [get_nets [list pcam_csi_sys_i/mipi_csi2_tx_subsyst_0/inst/mipi_csi2_tx_ctrl_0_tx_mipi_ppi_if_DL0_TXREADYHS]]
set_property MARK_DEBUG true [get_nets {pcam_csi_sys_i/c_counter_binary_0/Q[3]}]
set_property MARK_DEBUG true [get_nets {pcam_csi_sys_i/c_counter_binary_0/Q[0]}]
set_property MARK_DEBUG true [get_nets {pcam_csi_sys_i/c_counter_binary_0/Q[1]}]
set_property MARK_DEBUG true [get_nets {pcam_csi_sys_i/c_counter_binary_0/Q[2]}]
set_property MARK_DEBUG true [get_nets {pcam_csi_sys_i/c_counter_binary_0/Q[4]}]
set_property MARK_DEBUG true [get_nets {pcam_csi_sys_i/c_counter_binary_0/Q[5]}]
set_property MARK_DEBUG true [get_nets {pcam_csi_sys_i/c_counter_binary_0/Q[6]}]
set_property MARK_DEBUG true [get_nets {pcam_csi_sys_i/c_counter_binary_0/Q[12]}]
set_property MARK_DEBUG true [get_nets {pcam_csi_sys_i/c_counter_binary_0/Q[13]}]
set_property MARK_DEBUG true [get_nets {pcam_csi_sys_i/c_counter_binary_0/Q[7]}]
set_property MARK_DEBUG true [get_nets {pcam_csi_sys_i/c_counter_binary_0/Q[8]}]
set_property MARK_DEBUG true [get_nets {pcam_csi_sys_i/c_counter_binary_0/Q[9]}]
set_property MARK_DEBUG true [get_nets {pcam_csi_sys_i/c_counter_binary_0/Q[10]}]
set_property MARK_DEBUG true [get_nets {pcam_csi_sys_i/c_counter_binary_0/Q[14]}]
set_property MARK_DEBUG true [get_nets {pcam_csi_sys_i/c_counter_binary_0/Q[15]}]
set_property MARK_DEBUG true [get_nets {pcam_csi_sys_i/c_counter_binary_0/Q[11]}]
create_debug_port csi_tx_hs_ila probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports csi_tx_hs_ila/probe3]
set_property port_width 16 [get_debug_ports csi_tx_hs_ila/probe3]
connect_debug_port csi_tx_hs_ila/probe3 [get_nets [list {pcam_csi_sys_i/c_counter_binary_0/Q[0]} {pcam_csi_sys_i/c_counter_binary_0/Q[1]} {pcam_csi_sys_i/c_counter_binary_0/Q[2]} {pcam_csi_sys_i/c_counter_binary_0/Q[3]} {pcam_csi_sys_i/c_counter_binary_0/Q[4]} {pcam_csi_sys_i/c_counter_binary_0/Q[5]} {pcam_csi_sys_i/c_counter_binary_0/Q[6]} {pcam_csi_sys_i/c_counter_binary_0/Q[7]} {pcam_csi_sys_i/c_counter_binary_0/Q[8]} {pcam_csi_sys_i/c_counter_binary_0/Q[9]} {pcam_csi_sys_i/c_counter_binary_0/Q[10]} {pcam_csi_sys_i/c_counter_binary_0/Q[11]} {pcam_csi_sys_i/c_counter_binary_0/Q[12]} {pcam_csi_sys_i/c_counter_binary_0/Q[13]} {pcam_csi_sys_i/c_counter_binary_0/Q[14]} {pcam_csi_sys_i/c_counter_binary_0/Q[15]}]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk]
