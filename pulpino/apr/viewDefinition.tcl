################################################
#  EECS 627 W22                                #
#  Created by Jaeyoung Kim                     #
#  Updated by Hyochan An and Qirui Zhang       #
#  Innvous Input configuration file            #
################################################


# Insert the standard cell and macro library files
create_library_set \
    -name typical \
	-timing [list "$ibm13_dir/synopsys/typical.lib" "$top_dir/mem/RA1SHD_tt_1p2v_25c_syn.lib"]

# For timing based placement include the timing constraints in sdc format
# Get this constraints from synthesis Design Compiler
create_constraint_mode -name my_constraint_mode \
	-sdc_files	[list "$top_dir/synth/netlist/${top}.syn.sdc"]

set delaycal_use_default_delay_limit {1000}
set delaycal_default_net_delay {20.0ps}
set delaycal_default_net_load {0.05pf}
set delaycal_input_transition_delay {100.0ps}

create_rc_corner -name typical_rc_corner \
	-qx_tech_file		/afs/umich.edu/class/eecs627/w22/resources/cmos8rf_8LM_62_SigCmax.tch \
	-preRoute_res		1 \
	-postRoute_res		1 \
	-preRoute_cap		1 \
	-postRoute_cap		1 \
	-postRoute_xcap		1 \
	-preRoute_clkres	0 \
	-preRoute_clkcap	0 \
	-postRoute_clkres	0 \
	-postRoute_clkcap	0

create_delay_corner -name typical_delay_corner -library_set typical -rc_corner typical_rc_corner
create_analysis_view -name typical_analysis_view -delay_corner typical_delay_corner -constraint_mode my_constraint_mode
set_analysis_view -setup {typical_analysis_view} -hold {typical_analysis_view}

set extract_shrink_factor {1.0}
