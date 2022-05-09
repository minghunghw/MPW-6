# Configurations
## Set top design
set top         pulpino_mem

## Set main clock and reset for the top design
set clk_port    clk_l2h
set rst_port    rstn_l2h

## Set clock period
set clk_period  8


# Set general variables
set clk_ports   [list $clk_port spi_clk_i tck_i]
set clk_names   {clk spi_sck tck}


# Suppress messages
suppress_message { VER-318 VER-61 VER-26 VER-708 VER-329 VHD-4 VER-130 ELAB-311 UID-401 }
if { $top != "pulpino_top" } {
    suppress_message { UID-95 }
}

# Set maximal threads
set_host_options -max_cores 6


# Set output file names
set synth_dir    ".."
set netlist_dir  "$synth_dir/netlist"
set ddc_dir      "$synth_dir/ddc"
set rpt_dir      "$synth_dir/rpt"
set sdf_dir      "$synth_dir/sdf"
set netlist_file "$netlist_dir/$top.vg"
set svsim_file   "$netlist_dir/$top\_svsim.sv"
set ddc_file     "$ddc_dir/$top.ddc"
set chk_file     "$rpt_dir/$top.chk"
set sdf_file     "$sdf_dir/$top.sdf"
set sdc_file     "$netlist_dir/$top.syn.sdc"

set PULP_HSA_SIM 1
set PULPINO_TOP  "$synth_dir/.."
set RTL          $PULPINO_TOP/rtl
set IPS          $PULPINO_TOP/ips


# Source file list configurations
source $synth_dir/src_files.tcl
source $synth_dir/ips_src_files.tcl


# Set libraries
set include_dirs " \
    $INC_AXI_NODE \
    $INC_APB_EVENT_UNIT \
    $INC_FPU \
    $INC_APB_I2C \
    $INC_ZERORISCY_REGFILE_FPGA \
    $INC_ZERORISCY \
    $INC_RISCV \
    $INC_RISCV_REGFILE_FPGA \
    $INC_APB_AES \
    $INC_ADV_DBG_IF \
"

## 0.13um IBM Artisan Library
set SYNOPSYS [get_unix_variable SYNOPSYS]
set search_path_mem     "$PULPINO_TOP/mem"
set search_path_artisan "/afs/umich.edu/class/eecs627/ibm13/artisan/current/aci/sc-x/synopsys/"
set target_library      "typical.db"
set mem_library         "RA1SHD_tt_1p2v_25c_syn.db"
set synthetic_library   "dw_foundation.sldb"


set_app_var search_path       "$include_dirs $search_path_mem $search_path_artisan $SYNOPSYS/libraries/syn"
set_app_var target_library    $target_library
set_app_var synthetic_library $synthetic_library
set_app_var link_library      "* $target_library $mem_library $synthetic_library"

# set_dont_use any *XL* cell
# set_dont_use { typical/*XLTR }
# Used in 627 Lab 1, but will incur error


# Work with designs in memory
analyze -f sverilog $SRC_APB_GPIO
analyze -f sverilog $SRC_AXI_SLICE_DC
analyze -f sverilog $SRC_APB_EVENT_UNIT
analyze -f sverilog $SRC_AXI_NODE
analyze -f sverilog $SRC_RISCV
analyze -f sverilog $SRC_RISCV_REGFILE_FPGA
analyze -f sverilog $SRC_APB_PULPINO
analyze -f sverilog $SRC_AXI_MEM_IF_DP
analyze -f sverilog $SRC_APB_FLL_IF
analyze -f sverilog $SRC_AXI_SLICE
analyze -f sverilog $SRC_APB_AES
analyze -f vhdl     $SRC_APB_UART
analyze -f sverilog $SRC_APB_SPI_MASTER
analyze -f sverilog $SRC_APB_TIMER
analyze -f sverilog $SRC_AXI2APB
analyze -f sverilog $SRC_AXI_SPI_SLAVE
analyze -f sverilog $SRC_APB_I2C
analyze -f sverilog $SRC_ADV_DBG_IF
analyze -f sverilog $SRC_AXI_SPI_MASTER
analyze -f sverilog $SRC_CORE2AXI
analyze -f sverilog $SRC_APB_NODE
analyze -f sverilog $SRC_APB2PER
analyze -f sverilog $SRC_COMPONENTS
analyze -f sverilog $SRC_PULPINO

elaborate $top
current_design $top
uniquify
link

# Create clocks
create_clock -period $clk_period -name clk [get_nets $clk_port]
create_clock -period 40.000 -name spi_sck  [get_nets spi_clk_i]
create_clock -period 40.000 -name tck      [get_nets tck_i]


# Define design environments
set op_cond                  "typical"
set rst_drive                0
set driving_cell             "INVX2TR"
set avg_load                 0.1
set avg_fo_load              10
set auto_wire_load_selection "false"

set_operating_conditions $op_cond -library "typical"
set_drive $rst_drive $rst_port
set_driving_cell -lib_cell $driving_cell [all_inputs]
remove_driving_cell [find port $clk_ports]
set_load $avg_load [all_outputs]
set_fanout_load $avg_fo_load [all_outputs]
set_resistance 0 $rst_port
set_wire_load_model -name "ibm13_wl10" -library "typical"
set_wire_load_mode "segmented"


# Define design constraints
set crit_range      [expr $clk_period * 0.1]
set clk_latency     0.1
set clk_uncertainty 0.1
set clk_transition  0.1
set input_delay     0.1
set output_delay    0.1

set spi_input_ports  [remove_from_collection [get_ports spi*_i] [get_ports spi_master*]]
set spi_input_ports  [remove_from_collection $spi_input_ports [get_ports spi_clk_i]]
set jtag_input_ports [get_ports {trstn_i tms_i tdi_i}]
set sys_input_ports  [get_ports {testmode_i fetch_enable_i scan_enable_i gpio_in}]

set spi_output_ports [remove_from_collection [get_ports spi*_o] [get_ports spi_master*]]
set jtag_output_ports [get_ports tdo_o]
set sys_output_ports [get_ports {gpio_out gpio_dir gpio_padcfg pad_cfg_o pad_mux_o}]

set_critical_range $crit_range [current_design]
set_clock_latency $clk_latency [get_clocks $clk_names]
set_clock_uncertainty $clk_uncertainty [get_clocks $clk_names]
set_clock_transition $clk_transition [get_clocks $clk_names]

set_input_delay $input_delay -clock spi_sck $spi_input_ports
set_input_delay $input_delay -clock tck $jtag_input_ports
set_input_delay $input_delay -clock clk $sys_input_ports

set_output_delay $output_delay -clock spi_sck $spi_output_ports
set_output_delay $output_delay -clock tck $jtag_output_ports
set_output_delay $output_delay -clock clk $sys_output_ports

set_max_delay $clk_period [all_outputs]
group_path -from [all_inputs] -name input_grp
group_path -to [all_outputs] -name output_grp
set_fix_multiple_port_nets -outputs -buffer_constants
set_fix_hold $clk_names


# Optimize the design
set_clock_groups \
    -asynchronous \
    -group { clk } \
    -group { spi_sck } \
    -group { tck }
set_dont_touch [get_nets $rst_port]
set_case_analysis 0 [get_nets { clk_sel_i testmode_i uart_cts uart_dsr }]


# Compile the design
# compile -map_effort medium
compile_ultra -gate_clock


# Analyze the design
set report_level "low"
set max_paths 8
exec mkdir -p $rpt_dir

check_design > $chk_file
report_area -hier > "$rpt_dir/$top\_area.rpt"
report_timing -max_paths $max_paths -input_pins -nets \
    -transition_time \
    > "$rpt_dir/$top\_timing.rpt"

if { $report_level == "high" } {
    report_design > "$rpt_dir/$top\_design.rpt"
    report_cell > "$rpt_dir/$top\_cell.rpt"
    report_reference > "$rpt_dir/$top\_ref.rpt"
    report_port > "$rpt_dir/$top\_port.rpt"
    report_net > "$rpt_dir/$top\_net.rpt"
    report_compile_options > "$rpt_dir/$top\_comp.rpt"
    report_constraint -max_delay -verbose \
        > "$rpt_dir/$top\_constr.rpt"
    report_hierarchy > "$rpt_dir/$top\_hier.rpt"
    report_resources > "$rpt_dir/$top\_res.rpt"
}


# Name rules
set bus_inference_style {%s[%d]}
set bus_naming_style {%s[%d]}
set hdlout_internal_busses true
change_names -hierarchy -rule verilog
define_name_rules name_rule -allowed "A-Z a-z 0-9 _" -max_length 255 -type cell
define_name_rules name_rule -allowed "A-Z a-z 0-9 _[]" -max_length 255 -type net
define_name_rules name_rule -map {{"\\*cell\\*" "cell"}}
define_name_rules name_rule -case_insensitive
change_names -hierarchy -rules name_rule


# Save the design database
exec mkdir -p $netlist_dir
exec mkdir -p $ddc_dir
exec mkdir -p $sdf_dir
write -hier -format verilog -output $netlist_file $top
write -format svsim -output $svsim_file $top
write_sdc $sdc_file
write_sdf $sdf_file
write -hier -format ddc -output $ddc_file $top


# Quit
quit
