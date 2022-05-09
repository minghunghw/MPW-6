################################################
#  EECS 627 W22                                #
#  Created by Qing Dong                        #
#  Updated by Hyochan An and Qirui Zhang       #
#  Innovus Input configuration file            #
################################################


# Specify Verilog source files
# Include the std cells verilog modules
set init_verilog [list \
    "$ibm13_dir/verilog/ibm13_modules.v" \
    "$top_dir/synth/netlist/pulpino_mem.vg" \
]

# Specify the name of your toplevel module
set init_top_cell {pulpino_mem}


set init_design_netlisttype {Verilog}
set init_design_settop {1}


# Insert I/O file (for use with I/O pads, not block I/O only
set init_io_file "$apr_dir/pulpino_mem.io"

# Insert the standard cell LEF file and other block LEF files
set init_lef_file [list \
    "$ibm13_dir/lef/ibm13_8lm_2thick_tech.lef" \
    "$ibm13_dir/lef/ibm13rvt_macros.lef" \
    "$top_dir/mem/MEM.lef" \
]

set init_mmmc_file "${apr_dir}/viewDefinition.tcl"

set init_pwr_net {VDD}
set init_gnd_net {VSS}
