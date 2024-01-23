
################################################################
# This is a generated script based on design: pcam_csi_sys
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2022.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_gid_msg -ssname BD::TCL -id 2041 -severity "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source pcam_csi_sys_script.tcl


# The design that will be created by this Tcl script contains the following 
# module references:
# hdmi_rx_detect, hdmi_rx_detect

# Please add the sources of those modules before sourcing this Tcl script.

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xcvu19p-fsva3824-2-e
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name pcam_csi_sys

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_gid_msg -ssname BD::TCL -id 2001 -severity "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_gid_msg -ssname BD::TCL -id 2002 -severity "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_gid_msg -ssname BD::TCL -id 2003 -severity "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_gid_msg -ssname BD::TCL -id 2004 -severity "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_gid_msg -ssname BD::TCL -id 2005 -severity "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_gid_msg -ssname BD::TCL -id 2006 -severity "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:axi_iic:2.1\
xilinx.com:ip:axi_uartlite:2.0\
xilinx.com:ip:axi_vdma:6.3\
xilinx.com:ip:axis_subset_converter:1.1\
xilinx.com:ip:c_counter_binary:12.0\
xilinx.com:ip:clk_wiz:6.0\
xilinx.com:ip:ddr4:2.2\
xilinx.com:ip:fifo_generator:13.2\
xilinx.com:ip:mdm:3.2\
xilinx.com:ip:microblaze:11.0\
xilinx.com:ip:mipi_csi2_rx_subsystem:5.2\
xilinx.com:ip:mipi_csi2_tx_subsystem:2.2\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:system_ila:1.1\
xilinx.com:ip:v_demosaic:1.1\
xilinx.com:ip:v_gamma_lut:1.1\
xilinx.com:ip:vio:3.0\
xilinx.com:ip:xlconstant:1.1\
xilinx.com:ip:xlconcat:2.1\
xilinx.com:ip:lmb_bram_if_cntlr:4.0\
xilinx.com:ip:lmb_v10:3.0\
xilinx.com:ip:blk_mem_gen:8.4\
"

   set list_ips_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2011 -severity "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2012 -severity "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

##################################################################
# CHECK Modules
##################################################################
set bCheckModules 1
if { $bCheckModules == 1 } {
   set list_check_mods "\ 
hdmi_rx_detect\
hdmi_rx_detect\
"

   set list_mods_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2020 -severity "INFO" "Checking if the following modules exist in the project's sources: $list_check_mods ."

   foreach mod_vlnv $list_check_mods {
      if { [can_resolve_reference $mod_vlnv] == 0 } {
         lappend list_mods_missing $mod_vlnv
      }
   }

   if { $list_mods_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2021 -severity "ERROR" "The following module(s) are not found in the project: $list_mods_missing" }
      common::send_gid_msg -ssname BD::TCL -id 2022 -severity "INFO" "Please add source files for the missing module(s) above."
      set bCheckIPsPassed 0
   }
}

if { $bCheckIPsPassed != 1 } {
  common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: reset_sys
proc create_hier_cell_reset_sys { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_reset_sys() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir O -from 0 -to 0 -type rst bus_struct_reset
  create_bd_pin -dir I dcm_locked
  create_bd_pin -dir I -type rst ext_reset_in
  create_bd_pin -dir O -from 0 -to 0 -type rst interconnect_aresetn
  create_bd_pin -dir O -from 0 -to 0 -type rst interconnect_aresetn1
  create_bd_pin -dir O -from 0 -to 0 -type rst interconnect_aresetn2
  create_bd_pin -dir I -type rst mb_debug_sys_rst
  create_bd_pin -dir O -type rst mb_reset
  create_bd_pin -dir O -from 0 -to 0 -type rst peripheral_aresetn
  create_bd_pin -dir O -from 0 -to 0 -type rst peripheral_aresetn1
  create_bd_pin -dir O -from 0 -to 0 -type rst peripheral_aresetn2
  create_bd_pin -dir I -type clk slowest_sync_clk
  create_bd_pin -dir I -type clk slowest_sync_clk1
  create_bd_pin -dir I -type clk slowest_sync_clk2
  create_bd_pin -dir I -type clk slowest_sync_clk3

  # Create instance: reset_100M, and set properties
  set reset_100M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 reset_100M ]

  # Create instance: reset_200M, and set properties
  set reset_200M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 reset_200M ]

  # Create instance: reset_half_pixelclk, and set properties
  set reset_half_pixelclk [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 reset_half_pixelclk ]

  # Create instance: reset_pixelclk, and set properties
  set reset_pixelclk [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 reset_pixelclk ]

  # Create port connections
  connect_bd_net -net ARESETN_1 [get_bd_pins interconnect_aresetn] [get_bd_pins reset_100M/interconnect_aresetn]
  connect_bd_net -net ARESETN_2 [get_bd_pins interconnect_aresetn1] [get_bd_pins reset_pixelclk/interconnect_aresetn]
  connect_bd_net -net Net [get_bd_pins ext_reset_in] [get_bd_pins reset_100M/ext_reset_in] [get_bd_pins reset_200M/ext_reset_in] [get_bd_pins reset_half_pixelclk/ext_reset_in] [get_bd_pins reset_pixelclk/ext_reset_in]
  connect_bd_net -net S00_ARESETN_1 [get_bd_pins peripheral_aresetn] [get_bd_pins reset_100M/peripheral_aresetn]
  connect_bd_net -net clk_wiz_0_clk_out2 [get_bd_pins slowest_sync_clk1] [get_bd_pins reset_pixelclk/slowest_sync_clk]
  connect_bd_net -net clk_wiz_0_locked [get_bd_pins dcm_locked] [get_bd_pins reset_pixelclk/dcm_locked]
  connect_bd_net -net mdm_1_debug_sys_rst [get_bd_pins mb_debug_sys_rst] [get_bd_pins reset_100M/mb_debug_sys_rst]
  connect_bd_net -net microblaze_0_Clk [get_bd_pins slowest_sync_clk] [get_bd_pins reset_100M/slowest_sync_clk]
  connect_bd_net -net proc_sys_reset_0_bus_struct_reset [get_bd_pins bus_struct_reset] [get_bd_pins reset_100M/bus_struct_reset]
  connect_bd_net -net proc_sys_reset_0_mb_reset [get_bd_pins mb_reset] [get_bd_pins reset_100M/mb_reset]
  connect_bd_net -net proc_sys_reset_1_peripheral_aresetn [get_bd_pins peripheral_aresetn1] [get_bd_pins reset_pixelclk/peripheral_aresetn]
  connect_bd_net -net reset_half_pixelclk_interconnect_aresetn [get_bd_pins interconnect_aresetn2] [get_bd_pins reset_half_pixelclk/interconnect_aresetn]
  connect_bd_net -net reset_half_pixelclk_peripheral_aresetn [get_bd_pins peripheral_aresetn2] [get_bd_pins reset_half_pixelclk/peripheral_aresetn]
  connect_bd_net -net slowest_sync_clk2_1 [get_bd_pins slowest_sync_clk2] [get_bd_pins reset_200M/slowest_sync_clk]
  connect_bd_net -net slowest_sync_clk3_1 [get_bd_pins slowest_sync_clk3] [get_bd_pins reset_half_pixelclk/slowest_sync_clk]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: microblaze_0_local_memory
proc create_hier_cell_microblaze_0_local_memory { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_microblaze_0_local_memory() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode MirroredMaster -vlnv xilinx.com:interface:lmb_rtl:1.0 DLMB

  create_bd_intf_pin -mode MirroredMaster -vlnv xilinx.com:interface:lmb_rtl:1.0 ILMB


  # Create pins
  create_bd_pin -dir I -type clk LMB_Clk
  create_bd_pin -dir I -type rst SYS_Rst

  # Create instance: dlmb_bram_if_cntlr, and set properties
  set dlmb_bram_if_cntlr [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_bram_if_cntlr:4.0 dlmb_bram_if_cntlr ]
  set_property CONFIG.C_ECC {0} $dlmb_bram_if_cntlr


  # Create instance: dlmb_v10, and set properties
  set dlmb_v10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_v10:3.0 dlmb_v10 ]

  # Create instance: ilmb_bram_if_cntlr, and set properties
  set ilmb_bram_if_cntlr [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_bram_if_cntlr:4.0 ilmb_bram_if_cntlr ]
  set_property CONFIG.C_ECC {0} $ilmb_bram_if_cntlr


  # Create instance: ilmb_v10, and set properties
  set ilmb_v10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_v10:3.0 ilmb_v10 ]

  # Create instance: lmb_bram, and set properties
  set lmb_bram [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 lmb_bram ]
  set_property -dict [list \
    CONFIG.Enable_B {Use_ENB_Pin} \
    CONFIG.Memory_Type {True_Dual_Port_RAM} \
    CONFIG.Port_B_Clock {100} \
    CONFIG.Port_B_Enable_Rate {100} \
    CONFIG.Port_B_Write_Rate {50} \
    CONFIG.Use_RSTB_Pin {true} \
    CONFIG.use_bram_block {BRAM_Controller} \
  ] $lmb_bram


  # Create interface connections
  connect_bd_intf_net -intf_net microblaze_0_dlmb [get_bd_intf_pins DLMB] [get_bd_intf_pins dlmb_v10/LMB_M]
  connect_bd_intf_net -intf_net microblaze_0_dlmb_bus [get_bd_intf_pins dlmb_bram_if_cntlr/SLMB] [get_bd_intf_pins dlmb_v10/LMB_Sl_0]
  connect_bd_intf_net -intf_net microblaze_0_dlmb_cntlr [get_bd_intf_pins dlmb_bram_if_cntlr/BRAM_PORT] [get_bd_intf_pins lmb_bram/BRAM_PORTA]
  connect_bd_intf_net -intf_net microblaze_0_ilmb [get_bd_intf_pins ILMB] [get_bd_intf_pins ilmb_v10/LMB_M]
  connect_bd_intf_net -intf_net microblaze_0_ilmb_bus [get_bd_intf_pins ilmb_bram_if_cntlr/SLMB] [get_bd_intf_pins ilmb_v10/LMB_Sl_0]
  connect_bd_intf_net -intf_net microblaze_0_ilmb_cntlr [get_bd_intf_pins ilmb_bram_if_cntlr/BRAM_PORT] [get_bd_intf_pins lmb_bram/BRAM_PORTB]

  # Create port connections
  connect_bd_net -net SYS_Rst_1 [get_bd_pins SYS_Rst] [get_bd_pins dlmb_bram_if_cntlr/LMB_Rst] [get_bd_pins dlmb_v10/SYS_Rst] [get_bd_pins ilmb_bram_if_cntlr/LMB_Rst] [get_bd_pins ilmb_v10/SYS_Rst]
  connect_bd_net -net microblaze_0_Clk [get_bd_pins LMB_Clk] [get_bd_pins dlmb_bram_if_cntlr/LMB_Clk] [get_bd_pins dlmb_v10/LMB_Clk] [get_bd_pins ilmb_bram_if_cntlr/LMB_Clk] [get_bd_pins ilmb_v10/LMB_Clk]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: csitx_setting
proc create_hier_cell_csitx_setting { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_csitx_setting() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir O -from 95 -to 0 dout
  create_bd_pin -dir I -from 0 -to 0 tuser

  # Create instance: datatype, and set properties
  set datatype [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 datatype ]
  set_property -dict [list \
    CONFIG.CONST_VAL {36} \
    CONFIG.CONST_WIDTH {32} \
  ] $datatype


  # Create instance: word_count, and set properties
  set word_count [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 word_count ]
  set_property -dict [list \
    CONFIG.CONST_VAL {0x1680} \
    CONFIG.CONST_WIDTH {16} \
  ] $word_count


  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [list \
    CONFIG.IN0_WIDTH {1} \
    CONFIG.IN1_WIDTH {32} \
    CONFIG.IN2_WIDTH {15} \
    CONFIG.IN3_WIDTH {16} \
    CONFIG.IN4_WIDTH {32} \
    CONFIG.NUM_PORTS {5} \
  ] $xlconcat_0


  # Create instance: xlconstant_2, and set properties
  set xlconstant_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_2 ]
  set_property -dict [list \
    CONFIG.CONST_VAL {0} \
    CONFIG.CONST_WIDTH {15} \
  ] $xlconstant_2


  # Create instance: xlconstant_3, and set properties
  set xlconstant_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_3 ]
  set_property -dict [list \
    CONFIG.CONST_VAL {0} \
    CONFIG.CONST_WIDTH {32} \
  ] $xlconstant_3


  # Create port connections
  connect_bd_net -net In0_1 [get_bd_pins tuser] [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins dout] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlconstant_1_dout [get_bd_pins datatype/dout] [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net xlconstant_2_dout [get_bd_pins xlconcat_0/In2] [get_bd_pins xlconstant_2/dout]
  connect_bd_net -net xlconstant_3_dout [get_bd_pins xlconcat_0/In4] [get_bd_pins xlconstant_3/dout]
  connect_bd_net -net xlconstant_4_dout [get_bd_pins word_count/dout] [get_bd_pins xlconcat_0/In3]

  # Restore current instance
  current_bd_instance $oldCurInst
}


# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set C0_SYS_CLK_0 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 C0_SYS_CLK_0 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {300000000} \
   ] $C0_SYS_CLK_0

  set CLK_IN [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 CLK_IN ]

  set IIC [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 IIC ]

  set IIC_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 IIC_0 ]

  set UART_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:uart_rtl:1.0 UART_0 ]

  set c0_ddr4 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddr4_rtl:1.0 c0_ddr4 ]

  set mipi_phy [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:mipi_phy_rtl:1.0 mipi_phy ]

  set mipi_phy_if_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:mipi_phy_rtl:1.0 mipi_phy_if_0 ]


  # Create ports
  set bg0_pin6_nc_0 [ create_bd_port -dir I bg0_pin6_nc_0 ]
  set ddr4ht3_refclk_en_n [ create_bd_port -dir O -from 0 -to 0 ddr4ht3_refclk_en_n ]

  # Create instance: axi_iic_0, and set properties
  set axi_iic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.1 axi_iic_0 ]
  set_property CONFIG.IIC_FREQ_KHZ {100} $axi_iic_0


  # Create instance: axi_iic_1, and set properties
  set axi_iic_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.1 axi_iic_1 ]

  # Create instance: axi_interconnect_0, and set properties
  set axi_interconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_0 ]
  set_property CONFIG.NUM_MI {9} $axi_interconnect_0


  # Create instance: axi_interconnect_1, and set properties
  set axi_interconnect_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_1 ]
  set_property -dict [list \
    CONFIG.NUM_MI {1} \
    CONFIG.NUM_SI {2} \
  ] $axi_interconnect_1


  # Create instance: axi_uartlite_0, and set properties
  set axi_uartlite_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uartlite:2.0 axi_uartlite_0 ]

  # Create instance: axi_vdma_0, and set properties
  set axi_vdma_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vdma:6.3 axi_vdma_0 ]
  set_property -dict [list \
    CONFIG.C_FAMILY {zynquplus} \
    CONFIG.c_include_mm2s_dre {0} \
    CONFIG.c_include_s2mm_dre {0} \
    CONFIG.c_m_axis_mm2s_tdata_width {64} \
    CONFIG.c_mm2s_genlock_mode {3} \
    CONFIG.c_mm2s_linebuffer_depth {4096} \
    CONFIG.c_mm2s_max_burst_length {256} \
    CONFIG.c_num_fstores {3} \
    CONFIG.c_s2mm_genlock_mode {2} \
    CONFIG.c_s2mm_linebuffer_depth {4096} \
    CONFIG.c_s2mm_max_burst_length {256} \
    CONFIG.c_use_s2mm_fsync {2} \
  ] $axi_vdma_0


  # Create instance: axis_subset_converter_0, and set properties
  set axis_subset_converter_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_subset_converter:1.1 axis_subset_converter_0 ]
  set_property -dict [list \
    CONFIG.M_HAS_TKEEP {1} \
    CONFIG.M_HAS_TLAST {1} \
    CONFIG.M_HAS_TREADY {1} \
    CONFIG.M_HAS_TSTRB {1} \
    CONFIG.M_TDATA_NUM_BYTES {4} \
    CONFIG.M_TDEST_WIDTH {1} \
    CONFIG.M_TID_WIDTH {1} \
    CONFIG.M_TUSER_WIDTH {1} \
    CONFIG.S_HAS_TKEEP {1} \
    CONFIG.S_HAS_TLAST {1} \
    CONFIG.S_HAS_TREADY {1} \
    CONFIG.S_HAS_TSTRB {1} \
    CONFIG.S_TDATA_NUM_BYTES {4} \
    CONFIG.S_TDEST_WIDTH {1} \
    CONFIG.S_TID_WIDTH {1} \
    CONFIG.S_TUSER_WIDTH {1} \
    CONFIG.TDATA_REMAP {8'b00000000,tdata[29:22],tdata[19:12],tdata[9:2]} \
    CONFIG.TDEST_REMAP {tdest[0:0]} \
    CONFIG.TID_REMAP {tid[0:0]} \
    CONFIG.TKEEP_REMAP {tkeep[3:0]} \
    CONFIG.TLAST_REMAP {tlast[0]} \
    CONFIG.TSTRB_REMAP {tstrb[3:0]} \
    CONFIG.TUSER_REMAP {tuser[0:0]} \
  ] $axis_subset_converter_0


  # Create instance: axis_subset_converter_1, and set properties
  set axis_subset_converter_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_subset_converter:1.1 axis_subset_converter_1 ]
  set_property -dict [list \
    CONFIG.M_HAS_TKEEP {1} \
    CONFIG.M_HAS_TLAST {1} \
    CONFIG.M_HAS_TREADY {1} \
    CONFIG.M_HAS_TSTRB {0} \
    CONFIG.M_TDATA_NUM_BYTES {6} \
    CONFIG.M_TDEST_WIDTH {0} \
    CONFIG.M_TID_WIDTH {0} \
    CONFIG.M_TUSER_WIDTH {1} \
    CONFIG.S_HAS_TKEEP {1} \
    CONFIG.S_HAS_TLAST {1} \
    CONFIG.S_HAS_TREADY {1} \
    CONFIG.S_HAS_TSTRB {0} \
    CONFIG.S_TDATA_NUM_BYTES {8} \
    CONFIG.S_TDEST_WIDTH {0} \
    CONFIG.S_TID_WIDTH {0} \
    CONFIG.S_TUSER_WIDTH {0} \
    CONFIG.TDATA_REMAP {tdata[55:32],tdata[23:0]} \
  ] $axis_subset_converter_1


  # Create instance: c_counter_binary_0, and set properties
  set c_counter_binary_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_counter_binary:12.0 c_counter_binary_0 ]

  # Create instance: clk_wiz_pixel, and set properties
  set clk_wiz_pixel [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_pixel ]
  set_property -dict [list \
    CONFIG.CLKOUT1_JITTER {228.536} \
    CONFIG.CLKOUT1_PHASE_ERROR {394.762} \
    CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {148.5} \
    CONFIG.CLKOUT2_JITTER {250.227} \
    CONFIG.CLKOUT2_PHASE_ERROR {394.762} \
    CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {74.25} \
    CONFIG.CLKOUT2_USED {true} \
    CONFIG.MMCM_CLKFBOUT_MULT_F {111.375} \
    CONFIG.MMCM_CLKOUT0_DIVIDE_F {7.500} \
    CONFIG.MMCM_CLKOUT1_DIVIDE {15} \
    CONFIG.MMCM_DIVCLK_DIVIDE {10} \
    CONFIG.NUM_OUT_CLKS {2} \
    CONFIG.PRIM_SOURCE {No_buffer} \
    CONFIG.USE_LOCKED {false} \
    CONFIG.USE_RESET {false} \
  ] $clk_wiz_pixel


  # Create instance: clk_wiz_sys, and set properties
  set clk_wiz_sys [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_sys ]
  set_property -dict [list \
    CONFIG.CLKOUT1_JITTER {115.831} \
    CONFIG.CLKOUT1_PHASE_ERROR {87.180} \
    CONFIG.CLKOUT2_JITTER {115.831} \
    CONFIG.CLKOUT2_PHASE_ERROR {87.180} \
    CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {100} \
    CONFIG.CLKOUT2_USED {true} \
    CONFIG.CLKOUT3_JITTER {102.086} \
    CONFIG.CLKOUT3_PHASE_ERROR {87.180} \
    CONFIG.CLKOUT3_REQUESTED_OUT_FREQ {200} \
    CONFIG.CLKOUT3_USED {true} \
    CONFIG.CLKOUT4_JITTER {86.155} \
    CONFIG.CLKOUT4_PHASE_ERROR {76.967} \
    CONFIG.CLKOUT4_REQUESTED_OUT_FREQ {100.000} \
    CONFIG.CLKOUT4_USED {false} \
    CONFIG.CLKOUT5_JITTER {101.340} \
    CONFIG.CLKOUT5_PHASE_ERROR {76.967} \
    CONFIG.CLKOUT5_REQUESTED_OUT_FREQ {100.000} \
    CONFIG.CLKOUT5_USED {false} \
    CONFIG.MMCM_CLKFBOUT_MULT_F {12.000} \
    CONFIG.MMCM_CLKOUT0_DIVIDE_F {12.000} \
    CONFIG.MMCM_CLKOUT1_DIVIDE {12} \
    CONFIG.MMCM_CLKOUT2_DIVIDE {6} \
    CONFIG.MMCM_CLKOUT3_DIVIDE {1} \
    CONFIG.MMCM_CLKOUT4_DIVIDE {1} \
    CONFIG.MMCM_DIVCLK_DIVIDE {1} \
    CONFIG.NUM_OUT_CLKS {3} \
    CONFIG.PRIM_SOURCE {Differential_clock_capable_pin} \
    CONFIG.USE_RESET {false} \
  ] $clk_wiz_sys


  # Create instance: csitx_setting
  create_hier_cell_csitx_setting [current_bd_instance .] csitx_setting

  # Create instance: ddr4_0, and set properties
  set ddr4_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:ddr4:2.2 ddr4_0 ]
  set_property -dict [list \
    CONFIG.C0.CKE_WIDTH {2} \
    CONFIG.C0.CK_WIDTH {2} \
    CONFIG.C0.CS_WIDTH {2} \
    CONFIG.C0.DDR4_AxiAddressWidth {34} \
    CONFIG.C0.DDR4_AxiDataWidth {512} \
    CONFIG.C0.DDR4_AxiIDWidth {4} \
    CONFIG.C0.DDR4_CasLatency {15} \
    CONFIG.C0.DDR4_CasWriteLatency {11} \
    CONFIG.C0.DDR4_DataMask {DM_NO_DBI} \
    CONFIG.C0.DDR4_DataWidth {64} \
    CONFIG.C0.DDR4_InputClockPeriod {3335} \
    CONFIG.C0.DDR4_MemoryPart {MTA16ATF2G64HZ-2G3} \
    CONFIG.C0.DDR4_MemoryType {SODIMMs} \
    CONFIG.C0.DDR4_TimePeriod {938} \
    CONFIG.C0.ODT_WIDTH {2} \
  ] $ddr4_0


  # Create instance: fifo_generator_0, and set properties
  set fifo_generator_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fifo_generator:13.2 fifo_generator_0 ]
  set_property -dict [list \
    CONFIG.Clock_Type_AXI {Independent_Clock} \
    CONFIG.Enable_TLAST {true} \
    CONFIG.HAS_TKEEP {false} \
    CONFIG.HAS_TSTRB {false} \
    CONFIG.INTERFACE_TYPE {AXI_STREAM} \
    CONFIG.Programmable_Empty_Type_axis {Single_Programmable_Empty_Threshold_Constant} \
    CONFIG.Programmable_Full_Type_axis {Single_Programmable_Full_Threshold_Constant} \
    CONFIG.TDATA_NUM_BYTES {8} \
    CONFIG.TUSER_WIDTH {1} \
  ] $fifo_generator_0


  # Create instance: fifo_video_cnt, and set properties
  set block_name hdmi_rx_detect
  set block_cell_name fifo_video_cnt
  if { [catch {set fifo_video_cnt [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $fifo_video_cnt eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: mdm_1, and set properties
  set mdm_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mdm:3.2 mdm_1 ]
  set_property -dict [list \
    CONFIG.C_ADDR_SIZE {32} \
    CONFIG.C_M_AXI_ADDR_WIDTH {32} \
    CONFIG.C_USE_UART {1} \
  ] $mdm_1


  # Create instance: microblaze_0, and set properties
  set microblaze_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:microblaze:11.0 microblaze_0 ]
  set_property -dict [list \
    CONFIG.C_DEBUG_ENABLED {1} \
    CONFIG.C_D_AXI {1} \
    CONFIG.C_D_LMB {1} \
    CONFIG.C_I_LMB {1} \
  ] $microblaze_0


  # Create instance: microblaze_0_local_memory
  create_hier_cell_microblaze_0_local_memory [current_bd_instance .] microblaze_0_local_memory

  # Create instance: mipi_csi2_rx_subsyst_0, and set properties
  set mipi_csi2_rx_subsyst_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mipi_csi2_rx_subsystem:5.2 mipi_csi2_rx_subsyst_0 ]
  set_property -dict [list \
    CONFIG.CLK_LANE_IO_LOC {T41} \
    CONFIG.CMN_NUM_LANES {2} \
    CONFIG.CMN_NUM_PIXELS {1} \
    CONFIG.CMN_PXL_FORMAT {RAW10} \
    CONFIG.CMN_VC {All} \
    CONFIG.CSI_BUF_DEPTH {4096} \
    CONFIG.C_CLK_LANE_IO_POSITION {19} \
    CONFIG.C_CSI_EN_ACTIVELANES {true} \
    CONFIG.C_CSI_FILTER_USERDATATYPE {false} \
    CONFIG.C_DATA_LANE0_IO_POSITION {10} \
    CONFIG.C_DATA_LANE1_IO_POSITION {13} \
    CONFIG.C_DATA_LANE2_IO_POSITION {51} \
    CONFIG.C_DATA_LANE3_IO_POSITION {51} \
    CONFIG.C_DPHY_LANES {2} \
    CONFIG.C_EN_BG0_PIN0 {false} \
    CONFIG.C_EN_BG0_PIN6 {true} \
    CONFIG.C_EN_BG1_PIN0 {false} \
    CONFIG.C_HS_LINE_RATE {912} \
    CONFIG.C_HS_SETTLE_NS {145} \
    CONFIG.DATA_LANE0_IO_LOC {U43} \
    CONFIG.DATA_LANE1_IO_LOC {P45} \
    CONFIG.DATA_LANE2_IO_LOC {None} \
    CONFIG.DATA_LANE2_IO_LOC_NAME {IO_L16P_T2U_N6_QBC_AD3P_64} \
    CONFIG.DATA_LANE3_IO_LOC {None} \
    CONFIG.DATA_LANE3_IO_LOC_NAME {IO_L15P_T2L_N4_AD11P_64} \
    CONFIG.DPY_LINE_RATE {912} \
    CONFIG.HP_IO_BANK_SELECTION {38} \
    CONFIG.SupportLevel {1} \
    CONFIG.VFB_TU_WIDTH {1} \
  ] $mipi_csi2_rx_subsyst_0


  # Create instance: mipi_csi2_tx_subsyst_0, and set properties
  set mipi_csi2_tx_subsyst_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mipi_csi2_tx_subsystem:2.2 mipi_csi2_tx_subsyst_0 ]
  set_property -dict [list \
    CONFIG.CLK_LANE_IO_LOC {B42} \
    CONFIG.C_CSI_CRC_ENABLE {true} \
    CONFIG.C_CSI_LANES {4} \
    CONFIG.C_CSI_LINE_BUFR_DEPTH {4096} \
    CONFIG.C_DPHY_EN_REG_IF {true} \
    CONFIG.C_EN_REG_BASED_FE_GEN {false} \
    CONFIG.C_HS_LINE_RATE {500} \
    CONFIG.DATA_LANE0_IO_LOC {E44} \
    CONFIG.DATA_LANE1_IO_LOC {C44} \
    CONFIG.DATA_LANE2_IO_LOC {A44} \
    CONFIG.DATA_LANE3_IO_LOC {B41} \
    CONFIG.HP_IO_BANK_SELECTION {37} \
    CONFIG.SupportLevel {1} \
  ] $mipi_csi2_tx_subsyst_0


  set_property -dict [ list \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.PROTOCOL {AXI4LITE} \
   CONFIG.ADDR_WIDTH {13} \
 ] [get_bd_intf_pins /mipi_csi2_tx_subsyst_0/s_axi]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {s_axi:s_axis} \
   CONFIG.ASSOCIATED_RESET {s_axis_aresetn} \
 ] [get_bd_pins /mipi_csi2_tx_subsyst_0/s_axis_aclk]

  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] [get_bd_pins /mipi_csi2_tx_subsyst_0/s_axis_aresetn]

  # Create instance: proc_sys_reset_2, and set properties
  set proc_sys_reset_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_2 ]

  # Create instance: reset_sys
  create_hier_cell_reset_sys [current_bd_instance .] reset_sys

  # Create instance: s2mm_video_cnt, and set properties
  set block_name hdmi_rx_detect
  set block_cell_name s2mm_video_cnt
  if { [catch {set s2mm_video_cnt [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $s2mm_video_cnt eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: system_ila_0, and set properties
  set system_ila_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 system_ila_0 ]
  set_property -dict [list \
    CONFIG.C_MON_TYPE {MIX} \
    CONFIG.C_NUM_MONITOR_SLOTS {1} \
    CONFIG.C_NUM_OF_PROBES {9} \
    CONFIG.C_PROBE0_TYPE {0} \
    CONFIG.C_PROBE1_TYPE {0} \
    CONFIG.C_PROBE2_TYPE {0} \
    CONFIG.C_PROBE3_TYPE {0} \
    CONFIG.C_PROBE4_TYPE {0} \
    CONFIG.C_PROBE5_TYPE {0} \
    CONFIG.C_PROBE6_TYPE {0} \
    CONFIG.C_PROBE7_TYPE {0} \
    CONFIG.C_PROBE8_TYPE {0} \
    CONFIG.C_SLOT_0_APC_EN {0} \
    CONFIG.C_SLOT_0_AXI_DATA_SEL {1} \
    CONFIG.C_SLOT_0_AXI_TRIG_SEL {1} \
    CONFIG.C_SLOT_0_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
  ] $system_ila_0


  # Create instance: system_ila_1, and set properties
  set system_ila_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 system_ila_1 ]
  set_property -dict [list \
    CONFIG.C_MON_TYPE {INTERFACE} \
    CONFIG.C_NUM_MONITOR_SLOTS {2} \
    CONFIG.C_SLOT_0_APC_EN {0} \
    CONFIG.C_SLOT_0_AXI_AR_SEL_DATA {1} \
    CONFIG.C_SLOT_0_AXI_AR_SEL_TRIG {1} \
    CONFIG.C_SLOT_0_AXI_AW_SEL_DATA {0} \
    CONFIG.C_SLOT_0_AXI_AW_SEL_TRIG {0} \
    CONFIG.C_SLOT_0_AXI_B_SEL_DATA {0} \
    CONFIG.C_SLOT_0_AXI_B_SEL_TRIG {0} \
    CONFIG.C_SLOT_0_AXI_R_SEL_DATA {1} \
    CONFIG.C_SLOT_0_AXI_R_SEL_TRIG {1} \
    CONFIG.C_SLOT_0_AXI_W_SEL_DATA {0} \
    CONFIG.C_SLOT_0_AXI_W_SEL_TRIG {0} \
    CONFIG.C_SLOT_0_INTF_TYPE {xilinx.com:interface:aximm_rtl:1.0} \
    CONFIG.C_SLOT_1_APC_EN {0} \
    CONFIG.C_SLOT_1_AXI_AR_SEL_DATA {0} \
    CONFIG.C_SLOT_1_AXI_AR_SEL_TRIG {0} \
    CONFIG.C_SLOT_1_AXI_AW_SEL_DATA {1} \
    CONFIG.C_SLOT_1_AXI_AW_SEL_TRIG {1} \
    CONFIG.C_SLOT_1_AXI_B_SEL_DATA {1} \
    CONFIG.C_SLOT_1_AXI_B_SEL_TRIG {1} \
    CONFIG.C_SLOT_1_AXI_R_SEL_DATA {0} \
    CONFIG.C_SLOT_1_AXI_R_SEL_TRIG {0} \
    CONFIG.C_SLOT_1_AXI_W_SEL_DATA {1} \
    CONFIG.C_SLOT_1_AXI_W_SEL_TRIG {1} \
    CONFIG.C_SLOT_1_INTF_TYPE {xilinx.com:interface:aximm_rtl:1.0} \
  ] $system_ila_1


  # Create instance: v_demosaic_0, and set properties
  set v_demosaic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_demosaic:1.1 v_demosaic_0 ]
  set_property -dict [list \
    CONFIG.MAX_COLS {1920} \
    CONFIG.MAX_DATA_WIDTH {10} \
    CONFIG.MAX_ROWS {1080} \
    CONFIG.SAMPLES_PER_CLOCK {1} \
  ] $v_demosaic_0


  # Create instance: v_gamma_lut_0, and set properties
  set v_gamma_lut_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_gamma_lut:1.1 v_gamma_lut_0 ]
  set_property -dict [list \
    CONFIG.MAX_COLS {1920} \
    CONFIG.MAX_DATA_WIDTH {10} \
    CONFIG.MAX_ROWS {1080} \
    CONFIG.SAMPLES_PER_CLOCK {1} \
  ] $v_gamma_lut_0


  # Create instance: vio_0, and set properties
  set vio_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:vio:3.0 vio_0 ]
  set_property CONFIG.C_NUM_PROBE_IN {0} $vio_0


  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property CONFIG.CONST_VAL {0} $xlconstant_0


  # Create interface connections
  connect_bd_intf_net -intf_net C0_SYS_CLK_0_1 [get_bd_intf_ports C0_SYS_CLK_0] [get_bd_intf_pins ddr4_0/C0_SYS_CLK]
  connect_bd_intf_net -intf_net CLK_IN1_D_0_1 [get_bd_intf_ports CLK_IN] [get_bd_intf_pins clk_wiz_sys/CLK_IN1_D]
  connect_bd_intf_net -intf_net axi_iic_0_IIC [get_bd_intf_ports IIC] [get_bd_intf_pins axi_iic_0/IIC]
  connect_bd_intf_net -intf_net axi_iic_1_IIC [get_bd_intf_ports IIC_0] [get_bd_intf_pins axi_iic_1/IIC]
  connect_bd_intf_net -intf_net axi_interconnect_0_M00_AXI [get_bd_intf_pins axi_interconnect_0/M00_AXI] [get_bd_intf_pins mipi_csi2_rx_subsyst_0/csirxss_s_axi]
  connect_bd_intf_net -intf_net axi_interconnect_0_M01_AXI [get_bd_intf_pins axi_interconnect_0/M01_AXI] [get_bd_intf_pins axi_vdma_0/S_AXI_LITE]
  connect_bd_intf_net -intf_net axi_interconnect_0_M02_AXI [get_bd_intf_pins axi_interconnect_0/M02_AXI] [get_bd_intf_pins v_demosaic_0/s_axi_CTRL]
  connect_bd_intf_net -intf_net axi_interconnect_0_M03_AXI [get_bd_intf_pins axi_interconnect_0/M03_AXI] [get_bd_intf_pins v_gamma_lut_0/s_axi_CTRL]
  connect_bd_intf_net -intf_net axi_interconnect_0_M04_AXI [get_bd_intf_pins axi_iic_0/S_AXI] [get_bd_intf_pins axi_interconnect_0/M04_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M05_AXI [get_bd_intf_pins axi_interconnect_0/M05_AXI] [get_bd_intf_pins mipi_csi2_tx_subsyst_0/s_axi]
  connect_bd_intf_net -intf_net axi_interconnect_0_M06_AXI [get_bd_intf_pins axi_interconnect_0/M06_AXI] [get_bd_intf_pins axi_uartlite_0/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M07_AXI [get_bd_intf_pins axi_interconnect_0/M07_AXI] [get_bd_intf_pins mdm_1/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M08_AXI [get_bd_intf_pins axi_iic_1/S_AXI] [get_bd_intf_pins axi_interconnect_0/M08_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_1_M00_AXI [get_bd_intf_pins axi_interconnect_1/M00_AXI] [get_bd_intf_pins ddr4_0/C0_DDR4_S_AXI]
  connect_bd_intf_net -intf_net axi_uartlite_0_UART [get_bd_intf_ports UART_0] [get_bd_intf_pins axi_uartlite_0/UART]
  connect_bd_intf_net -intf_net axi_vdma_0_M_AXI_MM2S [get_bd_intf_pins axi_interconnect_1/S00_AXI] [get_bd_intf_pins axi_vdma_0/M_AXI_MM2S]
connect_bd_intf_net -intf_net [get_bd_intf_nets axi_vdma_0_M_AXI_MM2S] [get_bd_intf_pins axi_vdma_0/M_AXI_MM2S] [get_bd_intf_pins system_ila_1/SLOT_0_AXI]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_intf_nets axi_vdma_0_M_AXI_MM2S]
  connect_bd_intf_net -intf_net axi_vdma_0_M_AXI_S2MM [get_bd_intf_pins axi_interconnect_1/S01_AXI] [get_bd_intf_pins axi_vdma_0/M_AXI_S2MM]
connect_bd_intf_net -intf_net [get_bd_intf_nets axi_vdma_0_M_AXI_S2MM] [get_bd_intf_pins axi_vdma_0/M_AXI_S2MM] [get_bd_intf_pins system_ila_1/SLOT_1_AXI]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_intf_nets axi_vdma_0_M_AXI_S2MM]
  connect_bd_intf_net -intf_net axis_subset_converter_1_M_AXIS [get_bd_intf_pins axis_subset_converter_1/M_AXIS] [get_bd_intf_pins mipi_csi2_tx_subsyst_0/s_axis]
connect_bd_intf_net -intf_net [get_bd_intf_nets axis_subset_converter_1_M_AXIS] [get_bd_intf_pins axis_subset_converter_1/M_AXIS] [get_bd_intf_pins system_ila_0/SLOT_0_AXIS]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_intf_nets axis_subset_converter_1_M_AXIS]
  connect_bd_intf_net -intf_net ddr4_0_C0_DDR4 [get_bd_intf_ports c0_ddr4] [get_bd_intf_pins ddr4_0/C0_DDR4]
  connect_bd_intf_net -intf_net microblaze_0_M_AXI_DP [get_bd_intf_pins axi_interconnect_0/S00_AXI] [get_bd_intf_pins microblaze_0/M_AXI_DP]
  connect_bd_intf_net -intf_net microblaze_0_debug [get_bd_intf_pins mdm_1/MBDEBUG_0] [get_bd_intf_pins microblaze_0/DEBUG]
  connect_bd_intf_net -intf_net microblaze_0_dlmb_1 [get_bd_intf_pins microblaze_0/DLMB] [get_bd_intf_pins microblaze_0_local_memory/DLMB]
  connect_bd_intf_net -intf_net microblaze_0_ilmb_1 [get_bd_intf_pins microblaze_0/ILMB] [get_bd_intf_pins microblaze_0_local_memory/ILMB]
  connect_bd_intf_net -intf_net mipi_csi2_rx_subsyst_0_video_out [get_bd_intf_pins mipi_csi2_rx_subsyst_0/video_out] [get_bd_intf_pins v_demosaic_0/s_axis_video]
  connect_bd_intf_net -intf_net mipi_csi2_tx_subsyst_0_mipi_phy_if [get_bd_intf_ports mipi_phy_if_0] [get_bd_intf_pins mipi_csi2_tx_subsyst_0/mipi_phy_if]
  connect_bd_intf_net -intf_net mipi_phy_if_0_1 [get_bd_intf_ports mipi_phy] [get_bd_intf_pins mipi_csi2_rx_subsyst_0/mipi_phy_if]
  connect_bd_intf_net -intf_net v_demosaic_0_m_axis_video [get_bd_intf_pins v_demosaic_0/m_axis_video] [get_bd_intf_pins v_gamma_lut_0/s_axis_video]
  connect_bd_intf_net -intf_net v_gamma_lut_0_m_axis_video [get_bd_intf_pins axis_subset_converter_0/S_AXIS] [get_bd_intf_pins v_gamma_lut_0/m_axis_video]

  # Create port connections
  connect_bd_net -net ARESETN_1 [get_bd_pins axi_interconnect_0/ARESETN] [get_bd_pins reset_sys/interconnect_aresetn]
  connect_bd_net -net ARESETN_2 [get_bd_pins axi_interconnect_1/ARESETN] [get_bd_pins reset_sys/interconnect_aresetn1]
  connect_bd_net -net M05_ARESETN_1 [get_bd_pins axi_interconnect_0/M02_ARESETN] [get_bd_pins axi_interconnect_0/M03_ARESETN] [get_bd_pins axi_interconnect_0/M05_ARESETN] [get_bd_pins reset_sys/interconnect_aresetn2]
  connect_bd_net -net Net [get_bd_pins proc_sys_reset_2/ext_reset_in] [get_bd_pins reset_sys/ext_reset_in] [get_bd_pins vio_0/probe_out0]
  connect_bd_net -net S00_ARESETN_1 [get_bd_pins axi_iic_0/s_axi_aresetn] [get_bd_pins axi_iic_1/s_axi_aresetn] [get_bd_pins axi_interconnect_0/M00_ARESETN] [get_bd_pins axi_interconnect_0/M01_ARESETN] [get_bd_pins axi_interconnect_0/M04_ARESETN] [get_bd_pins axi_interconnect_0/M06_ARESETN] [get_bd_pins axi_interconnect_0/M07_ARESETN] [get_bd_pins axi_interconnect_0/M08_ARESETN] [get_bd_pins axi_interconnect_0/S00_ARESETN] [get_bd_pins axi_uartlite_0/s_axi_aresetn] [get_bd_pins axi_vdma_0/axi_resetn] [get_bd_pins mdm_1/S_AXI_ARESETN] [get_bd_pins mipi_csi2_rx_subsyst_0/lite_aresetn] [get_bd_pins reset_sys/peripheral_aresetn]
  connect_bd_net -net axi_vdma_0_m_axis_mm2s_tdata [get_bd_pins axi_vdma_0/m_axis_mm2s_tdata] [get_bd_pins fifo_generator_0/s_axis_tdata]
  connect_bd_net -net axi_vdma_0_m_axis_mm2s_tlast [get_bd_pins axi_vdma_0/m_axis_mm2s_tlast] [get_bd_pins fifo_generator_0/s_axis_tlast]
  connect_bd_net -net axi_vdma_0_m_axis_mm2s_tuser [get_bd_pins axi_vdma_0/m_axis_mm2s_tuser] [get_bd_pins fifo_generator_0/s_axis_tuser]
  connect_bd_net -net axi_vdma_0_m_axis_mm2s_tvalid [get_bd_pins axi_vdma_0/m_axis_mm2s_tvalid] [get_bd_pins fifo_generator_0/s_axis_tvalid]
  connect_bd_net -net axi_vdma_0_s_axis_s2mm_tready [get_bd_pins axi_vdma_0/s_axis_s2mm_tready] [get_bd_pins axis_subset_converter_0/m_axis_tready] [get_bd_pins s2mm_video_cnt/s_axis_tready]
  connect_bd_net -net axis_prog_empty [get_bd_pins fifo_generator_0/axis_prog_empty] [get_bd_pins system_ila_0/probe4]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_nets axis_prog_empty]
  connect_bd_net -net axis_prog_full [get_bd_pins fifo_generator_0/axis_prog_full] [get_bd_pins system_ila_0/probe5]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_nets axis_prog_full]
  connect_bd_net -net axis_subset_converter_0_m_axis_tdata [get_bd_pins axi_vdma_0/s_axis_s2mm_tdata] [get_bd_pins axis_subset_converter_0/m_axis_tdata]
  connect_bd_net -net axis_subset_converter_0_m_axis_tlast [get_bd_pins axi_vdma_0/s_axis_s2mm_tlast] [get_bd_pins axis_subset_converter_0/m_axis_tlast] [get_bd_pins s2mm_video_cnt/s_axis_tlast]
  connect_bd_net -net axis_subset_converter_0_m_axis_tuser [get_bd_pins axi_vdma_0/s_axis_s2mm_tuser] [get_bd_pins axis_subset_converter_0/m_axis_tuser] [get_bd_pins s2mm_video_cnt/s_axis_tuser]
  connect_bd_net -net axis_subset_converter_0_m_axis_tvalid [get_bd_pins axi_vdma_0/s_axis_s2mm_tvalid] [get_bd_pins axis_subset_converter_0/m_axis_tvalid] [get_bd_pins s2mm_video_cnt/s_axis_tvalid]
  connect_bd_net -net axis_subset_converter_1_s_axis_tready [get_bd_pins axis_subset_converter_1/s_axis_tready] [get_bd_pins fifo_generator_0/m_axis_tready] [get_bd_pins fifo_video_cnt/s_axis_tready]
  connect_bd_net -net bg0_pin6_nc_0_1 [get_bd_ports bg0_pin6_nc_0] [get_bd_pins mipi_csi2_rx_subsyst_0/bg0_pin6_nc]
  connect_bd_net -net clk_wiz_0_clk_out2 [get_bd_pins axi_interconnect_1/ACLK] [get_bd_pins axi_interconnect_1/S00_ACLK] [get_bd_pins axi_interconnect_1/S01_ACLK] [get_bd_pins axi_vdma_0/m_axi_mm2s_aclk] [get_bd_pins axi_vdma_0/m_axi_s2mm_aclk] [get_bd_pins axi_vdma_0/m_axis_mm2s_aclk] [get_bd_pins clk_wiz_pixel/clk_out1] [get_bd_pins fifo_generator_0/s_aclk] [get_bd_pins reset_sys/slowest_sync_clk1] [get_bd_pins system_ila_1/clk]
  connect_bd_net -net clk_wiz_0_clk_out3 [get_bd_pins clk_wiz_pixel/clk_in1] [get_bd_pins clk_wiz_sys/clk_out2]
  connect_bd_net -net clk_wiz_0_clk_out4 [get_bd_pins clk_wiz_sys/clk_out3] [get_bd_pins mipi_csi2_rx_subsyst_0/dphy_clk_200M] [get_bd_pins mipi_csi2_tx_subsyst_0/dphy_clk_200M] [get_bd_pins reset_sys/slowest_sync_clk2]
  connect_bd_net -net clk_wiz_0_locked [get_bd_pins clk_wiz_sys/locked] [get_bd_pins reset_sys/dcm_locked]
  connect_bd_net -net clk_wiz_pixel_clk_out2 [get_bd_pins axi_interconnect_0/M02_ACLK] [get_bd_pins axi_interconnect_0/M03_ACLK] [get_bd_pins axi_interconnect_0/M05_ACLK] [get_bd_pins axi_vdma_0/s_axis_s2mm_aclk] [get_bd_pins axis_subset_converter_0/aclk] [get_bd_pins axis_subset_converter_1/aclk] [get_bd_pins clk_wiz_pixel/clk_out2] [get_bd_pins fifo_generator_0/m_aclk] [get_bd_pins fifo_video_cnt/ACLK] [get_bd_pins mipi_csi2_rx_subsyst_0/video_aclk] [get_bd_pins mipi_csi2_tx_subsyst_0/s_axis_aclk] [get_bd_pins reset_sys/slowest_sync_clk3] [get_bd_pins s2mm_video_cnt/ACLK] [get_bd_pins system_ila_0/clk] [get_bd_pins v_demosaic_0/ap_clk] [get_bd_pins v_gamma_lut_0/ap_clk]
  connect_bd_net -net ddr4_0_c0_ddr4_ui_clk [get_bd_pins axi_interconnect_1/M00_ACLK] [get_bd_pins ddr4_0/c0_ddr4_ui_clk] [get_bd_pins proc_sys_reset_2/slowest_sync_clk]
  connect_bd_net -net fifo_generator_0_m_axis_tdata [get_bd_pins axis_subset_converter_1/s_axis_tdata] [get_bd_pins fifo_generator_0/m_axis_tdata]
  connect_bd_net -net fifo_generator_0_m_axis_tlast [get_bd_pins axis_subset_converter_1/s_axis_tlast] [get_bd_pins fifo_generator_0/m_axis_tlast] [get_bd_pins fifo_video_cnt/s_axis_tlast]
  connect_bd_net -net fifo_generator_0_m_axis_tuser [get_bd_pins csitx_setting/tuser] [get_bd_pins fifo_generator_0/m_axis_tuser] [get_bd_pins fifo_video_cnt/s_axis_tuser]
  connect_bd_net -net fifo_generator_0_m_axis_tvalid [get_bd_pins axis_subset_converter_1/s_axis_tvalid] [get_bd_pins fifo_generator_0/m_axis_tvalid] [get_bd_pins fifo_video_cnt/s_axis_tvalid]
  connect_bd_net -net fifo_generator_0_s_axis_tready [get_bd_pins axi_vdma_0/m_axis_mm2s_tready] [get_bd_pins fifo_generator_0/s_axis_tready]
  connect_bd_net -net mdm_1_debug_sys_rst [get_bd_pins mdm_1/Debug_SYS_Rst] [get_bd_pins reset_sys/mb_debug_sys_rst]
  connect_bd_net -net microblaze_0_Clk [get_bd_pins axi_iic_0/s_axi_aclk] [get_bd_pins axi_iic_1/s_axi_aclk] [get_bd_pins axi_interconnect_0/ACLK] [get_bd_pins axi_interconnect_0/M00_ACLK] [get_bd_pins axi_interconnect_0/M01_ACLK] [get_bd_pins axi_interconnect_0/M04_ACLK] [get_bd_pins axi_interconnect_0/M06_ACLK] [get_bd_pins axi_interconnect_0/M07_ACLK] [get_bd_pins axi_interconnect_0/M08_ACLK] [get_bd_pins axi_interconnect_0/S00_ACLK] [get_bd_pins axi_uartlite_0/s_axi_aclk] [get_bd_pins axi_vdma_0/s_axi_lite_aclk] [get_bd_pins clk_wiz_sys/clk_out1] [get_bd_pins mdm_1/S_AXI_ACLK] [get_bd_pins microblaze_0/Clk] [get_bd_pins microblaze_0_local_memory/LMB_Clk] [get_bd_pins mipi_csi2_rx_subsyst_0/lite_aclk] [get_bd_pins reset_sys/slowest_sync_clk] [get_bd_pins vio_0/clk]
  connect_bd_net -net mipi_csi2_tx_subsyst_0_txbyteclkhs [get_bd_pins c_counter_binary_0/CLK] [get_bd_pins mipi_csi2_tx_subsyst_0/txbyteclkhs]
  connect_bd_net -net o_col_cnt [get_bd_pins s2mm_video_cnt/o_col_cnt] [get_bd_pins system_ila_0/probe0]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_nets o_col_cnt]
  connect_bd_net -net o_col_cnt_1 [get_bd_pins fifo_video_cnt/o_col_cnt] [get_bd_pins system_ila_0/probe6]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_nets o_col_cnt_1]
  connect_bd_net -net o_frame_cnt [get_bd_pins s2mm_video_cnt/o_frame_cnt] [get_bd_pins system_ila_0/probe1]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_nets o_frame_cnt]
  connect_bd_net -net o_frame_cnt_1 [get_bd_pins fifo_video_cnt/o_frame_cnt] [get_bd_pins system_ila_0/probe7]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_nets o_frame_cnt_1]
  connect_bd_net -net o_row_cnt [get_bd_pins s2mm_video_cnt/o_row_cnt] [get_bd_pins system_ila_0/probe2]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_nets o_row_cnt]
  connect_bd_net -net o_row_cnt_1 [get_bd_pins fifo_video_cnt/o_row_cnt] [get_bd_pins system_ila_0/probe8]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_nets o_row_cnt_1]
  connect_bd_net -net proc_sys_reset_0_bus_struct_reset [get_bd_pins microblaze_0_local_memory/SYS_Rst] [get_bd_pins reset_sys/bus_struct_reset]
  connect_bd_net -net proc_sys_reset_0_mb_reset [get_bd_pins microblaze_0/Reset] [get_bd_pins reset_sys/mb_reset]
  connect_bd_net -net proc_sys_reset_1_peripheral_aresetn [get_bd_pins axi_interconnect_1/S00_ARESETN] [get_bd_pins axi_interconnect_1/S01_ARESETN] [get_bd_pins fifo_generator_0/s_aresetn] [get_bd_pins reset_sys/peripheral_aresetn1] [get_bd_pins system_ila_1/resetn]
  connect_bd_net -net proc_sys_reset_2_peripheral_aresetn [get_bd_pins axi_interconnect_1/M00_ARESETN] [get_bd_pins ddr4_0/c0_ddr4_aresetn] [get_bd_pins proc_sys_reset_2/peripheral_aresetn]
  connect_bd_net -net reset_sys_peripheral_aresetn2 [get_bd_pins axis_subset_converter_0/aresetn] [get_bd_pins axis_subset_converter_1/aresetn] [get_bd_pins fifo_video_cnt/ARESETN] [get_bd_pins mipi_csi2_rx_subsyst_0/video_aresetn] [get_bd_pins mipi_csi2_tx_subsyst_0/s_axis_aresetn] [get_bd_pins reset_sys/peripheral_aresetn2] [get_bd_pins s2mm_video_cnt/ARESETN] [get_bd_pins system_ila_0/resetn] [get_bd_pins v_demosaic_0/ap_rst_n] [get_bd_pins v_gamma_lut_0/ap_rst_n]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins csitx_setting/dout] [get_bd_pins mipi_csi2_tx_subsyst_0/s_axis_tuser] [get_bd_pins system_ila_0/probe3]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_nets xlconcat_0_dout]
  connect_bd_net -net xlconstant_0_dout [get_bd_ports ddr4ht3_refclk_en_n] [get_bd_pins ddr4_0/sys_rst] [get_bd_pins xlconstant_0/dout]

  # Create address segments
  assign_bd_address -offset 0x80000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces axi_vdma_0/Data_MM2S] [get_bd_addr_segs ddr4_0/C0_DDR4_MEMORY_MAP/C0_DDR4_ADDRESS_BLOCK] -force
  assign_bd_address -offset 0x80000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces axi_vdma_0/Data_S2MM] [get_bd_addr_segs ddr4_0/C0_DDR4_MEMORY_MAP/C0_DDR4_ADDRESS_BLOCK] -force
  assign_bd_address -offset 0x40800000 -range 0x00010000 -target_address_space [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs axi_iic_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x40810000 -range 0x00010000 -target_address_space [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs axi_iic_1/S_AXI/Reg] -force
  assign_bd_address -offset 0x40600000 -range 0x00010000 -target_address_space [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs axi_uartlite_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A10000 -range 0x00010000 -target_address_space [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs axi_vdma_0/S_AXI_LITE/Reg] -force
  assign_bd_address -offset 0x00000000 -range 0x00100000 -target_address_space [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs microblaze_0_local_memory/dlmb_bram_if_cntlr/SLMB/Mem] -force
  assign_bd_address -offset 0x41400000 -range 0x00001000 -target_address_space [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs mdm_1/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00001000 -target_address_space [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs mipi_csi2_rx_subsyst_0/csirxss_s_axi/Reg] -force
  assign_bd_address -offset 0x44A02000 -range 0x00002000 -target_address_space [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs mipi_csi2_tx_subsyst_0/s_axi/Reg] -force
  assign_bd_address -offset 0x44A40000 -range 0x00010000 -target_address_space [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs v_demosaic_0/s_axi_CTRL/Reg] -force
  assign_bd_address -offset 0x44A50000 -range 0x00010000 -target_address_space [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs v_gamma_lut_0/s_axi_CTRL/Reg] -force
  assign_bd_address -offset 0x00000000 -range 0x00100000 -target_address_space [get_bd_addr_spaces microblaze_0/Instruction] [get_bd_addr_segs microblaze_0_local_memory/ilmb_bram_if_cntlr/SLMB/Mem] -force


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


