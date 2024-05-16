# Copyright (C) 2020  Intel Corporation. All rights reserved.
# Your use of Intel Corporation's design tools, logic functions 
# and other software and tools, and any partner logic 
# functions, and any output files from any of the foregoing 
# (including device programming or simulation files), and any 
# associated documentation or information are expressly subject 
# to the terms and conditions of the Intel Program License 
# Subscription Agreement, the Intel Quartus Prime License Agreement,
# the Intel FPGA IP License Agreement, or other applicable license
# agreement, including, without limitation, that your use is for
# the sole purpose of programming logic devices manufactured by
# Intel and sold by Intel or its authorized distributors.  Please
# refer to the applicable agreement for further details, at
# https://fpgasoftware.intel.com/eula.

# Quartus Prime: Generate Tcl File for Project
# File: ProjetoComunicacaoDigital.tcl
# Generated on: Fri Jun 17 11:28:06 2022

# Load Quartus Prime Tcl Project package
package require ::quartus::project

set need_to_close_project 0
set make_assignments 1

# Check that the right project is open
if {[is_project_open]} {
	if {[string compare $quartus(project) "ProjetoComunicacaoDigital"]} {
		puts "Project ProjetoComunicacaoDigital is not open"
		set make_assignments 0
	}
} else {
	# Only open if not already open
	if {[project_exists ProjetoComunicacaoDigital]} {
		project_open -revision ProjetoComunicacaoDigital ProjetoComunicacaoDigital
	} else {
		project_new -revision ProjetoComunicacaoDigital ProjetoComunicacaoDigital
	}
	set need_to_close_project 1
}

# Make assignments
if {$make_assignments} {
	set_global_assignment -name FAMILY "Cyclone IV E"
	set_global_assignment -name DEVICE EP4CE115F29C7
	set_global_assignment -name TOP_LEVEL_ENTITY ProjetoTeclado
	set_global_assignment -name ORIGINAL_QUARTUS_VERSION 20.1.1
	set_global_assignment -name PROJECT_CREATION_TIME_DATE "18:47:10  MAIO 25, 2022"
	set_global_assignment -name LAST_QUARTUS_VERSION "20.1.1 Lite Edition"
	set_global_assignment -name PROJECT_OUTPUT_DIRECTORY output_files
	set_global_assignment -name MIN_CORE_JUNCTION_TEMP 0
	set_global_assignment -name MAX_CORE_JUNCTION_TEMP 85
	set_global_assignment -name ERROR_CHECK_FREQUENCY_DIVISOR 1
	set_global_assignment -name NOMINAL_CORE_SUPPLY_VOLTAGE 1.2V
	set_global_assignment -name EDA_SIMULATION_TOOL "ModelSim-Altera (Verilog)"
	set_global_assignment -name EDA_TIME_SCALE "1 ps" -section_id eda_simulation
	set_global_assignment -name EDA_OUTPUT_DATA_FORMAT "VERILOG HDL" -section_id eda_simulation
	set_global_assignment -name EDA_GENERATE_FUNCTIONAL_NETLIST OFF -section_id eda_board_design_timing
	set_global_assignment -name EDA_GENERATE_FUNCTIONAL_NETLIST OFF -section_id eda_board_design_symbol
	set_global_assignment -name EDA_GENERATE_FUNCTIONAL_NETLIST OFF -section_id eda_board_design_signal_integrity
	set_global_assignment -name EDA_GENERATE_FUNCTIONAL_NETLIST OFF -section_id eda_board_design_boundary_scan
	set_global_assignment -name ENABLE_OCT_DONE OFF
	set_global_assignment -name ENABLE_CONFIGURATION_PINS OFF
	set_global_assignment -name ENABLE_BOOT_SEL_PIN OFF
	set_global_assignment -name USE_CONFIGURATION_DEVICE OFF
	set_global_assignment -name CRC_ERROR_OPEN_DRAIN OFF
	set_global_assignment -name RESERVE_ALL_UNUSED_PINS_WEAK_PULLUP "AS INPUT TRI-STATED"
	set_global_assignment -name OUTPUT_IO_TIMING_NEAR_END_VMEAS "HALF VCCIO" -rise
	set_global_assignment -name OUTPUT_IO_TIMING_NEAR_END_VMEAS "HALF VCCIO" -fall
	set_global_assignment -name OUTPUT_IO_TIMING_FAR_END_VMEAS "HALF SIGNAL SWING" -rise
	set_global_assignment -name OUTPUT_IO_TIMING_FAR_END_VMEAS "HALF SIGNAL SWING" -fall
	set_global_assignment -name VERILOG_FILE displayLCD.v
	set_global_assignment -name VERILOG_FILE leitorPS2.v
	set_global_assignment -name VERILOG_FILE registradorDesloc.v
	set_global_assignment -name VECTOR_WAVEFORM_FILE registradorDesloc.vwf
	set_global_assignment -name VECTOR_WAVEFORM_FILE leitorPS2.vwf
	set_global_assignment -name VERILOG_FILE ProjetoTeclado.v
	set_global_assignment -name VERILOG_FILE hexto7segment.v
	set_global_assignment -name POWER_PRESET_COOLING_SOLUTION "23 MM HEAT SINK WITH 200 LFPM AIRFLOW"
	set_global_assignment -name POWER_BOARD_THERMAL_MODEL "NONE (CONSERVATIVE)"
	set_global_assignment -name VERILOG_FILE PS2_to_LCD.v
	set_global_assignment -name VECTOR_WAVEFORM_FILE PS2_to_LCD.vwf
	set_global_assignment -name PARTITION_NETLIST_TYPE SOURCE -section_id Top
	set_global_assignment -name PARTITION_FITTER_PRESERVATION_LEVEL PLACEMENT_AND_ROUTING -section_id Top
	set_global_assignment -name PARTITION_COLOR 16764057 -section_id Top
	set_location_assignment PIN_G6 -to clk_ps2
	set_location_assignment PIN_H22 -to hex0[6]
	set_location_assignment PIN_H5 -to data_ps2
	set_location_assignment PIN_G19 -to end_scan
	set_location_assignment PIN_J22 -to hex0[5]
	set_location_assignment PIN_L25 -to hex0[4]
	set_location_assignment PIN_L26 -to hex0[3]
	set_location_assignment PIN_E17 -to hex0[2]
	set_location_assignment PIN_F22 -to hex0[1]
	set_location_assignment PIN_G18 -to hex0[0]
	set_location_assignment PIN_U24 -to hex1[6]
	set_location_assignment PIN_U23 -to hex1[5]
	set_location_assignment PIN_W25 -to hex1[4]
	set_location_assignment PIN_W22 -to hex1[3]
	set_location_assignment PIN_W21 -to hex1[2]
	set_location_assignment PIN_Y22 -to hex1[1]
	set_location_assignment PIN_M24 -to hex1[0]
	set_location_assignment PIN_L4 -to LCD_E
	set_location_assignment PIN_M2 -to LCD_RS
	set_location_assignment PIN_M1 -to LCD_RW
	set_location_assignment PIN_L3 -to LCD_DATA[0]
	set_location_assignment PIN_L1 -to LCD_DATA[1]
	set_location_assignment PIN_L2 -to LCD_DATA[2]
	set_location_assignment PIN_K7 -to LCD_DATA[3]
	set_location_assignment PIN_K1 -to LCD_DATA[4]
	set_location_assignment PIN_K2 -to LCD_DATA[5]
	set_location_assignment PIN_M3 -to LCD_DATA[6]
	set_location_assignment PIN_M5 -to LCD_DATA[7]
	set_location_assignment PIN_Y2 -to CLK50MHz
	set_location_assignment PIN_L5 -to LCD_ON
	set_location_assignment PIN_L6 -to LCD_BLON
	set_location_assignment PIN_F19 -to espera
	set_instance_assignment -name PARTITION_HIERARCHY root_partition -to | -section_id Top

	# Commit assignments
	export_assignments

	# Close project
	if {$need_to_close_project} {
		project_close
	}
}
