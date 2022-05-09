###################################
# EECS 627 W22
# Innovus basic script
# Cadence EDI Version 14.1
###################################

set top_dir       "../.."
set apr_dir       ".."
set enc_dir       "$apr_dir/enc"
set ibm13_dir     "/afs/umich.edu/class/eecs627/ibm13/artisan/current/aci/sc-x"
set top           "pulpino_top"

#############################################################

proc get_multithread_lic { } {
    setMultiCpuUsage -acquireLicense 4
}

#############################################################

source globals.tcl

#############################################################

proc run_init { } {

    global top

    init_design

    clearGlobalNets

    setCteReport

    saveDesign "${top}.init.enc"
}

#############################################################

proc connect_std_cells_to_power { } {

    globalNetConnect VDD -type tiehi -inst * -verbose
    globalNetConnect VSS -type tielo -inst * -verbose

    globalNetConnect VDD -type pgpin -pin VDD -inst * -verbose
    globalNetConnect VSS -type pgpin -pin VSS -inst * -verbose
}


#############################################################

proc run_floorplan { } {

    global top

    if {[expr ![dbIsHeadDesignInMemory]]} {
        puts "##############"
        puts "###"
        puts "### RESTORING INIT!!! "
        puts "###"
        puts "##############"
        restoreDesign "${top}.init.enc.dat" ${top}
    }

    get_multithread_lic

    floorPlan -site IBM13SITE -r 1 0.5 60.0 60.0 60.0 60.0

    # TODO: comment, might need to fix
    #loadIoFile ${top}.io

    fit

    # Create Power Rings
    addRing \
        -nets {VDD VSS} \
        -type core_rings \
        -follow core \
        -layer {top M3 bottom M3 left M4 right M4} \
        -width {top 2 bottom 2 left 2 right 2} \
        -spacing {top 1 bottom 1 left 1 right 1} \
        -offset {top 1.8 bottom 1.8 left 1.8 right 1.8} \
        -center 0 \
        -threshold 0 \
        -jog_distance 0 \
        -snap_wire_center_to_grid None \
        -use_wire_group 1 \
        -use_wire_group_bits 8 \
        -use_interleaving_wire_group 1

    # Place SRAM
    ## Instruction RAM
    dbSet [dbGet top.insts.name -p core_region_i_instr_mem_sp_ram_wrap_i_sp_ram_i_genblk2_1__genblk1_3__RA1SHD_i].orient R90
    setObjFPlanBox Instance core_region_i_instr_mem_sp_ram_wrap_i_sp_ram_i_genblk2_1__genblk1_3__RA1SHD_i 70 70 300 300

    dbSet [dbGet top.insts.name -p core_region_i_instr_mem_sp_ram_wrap_i_sp_ram_i_genblk2_1__genblk1_2__RA1SHD_i].orient R90
    setObjFPlanBox Instance core_region_i_instr_mem_sp_ram_wrap_i_sp_ram_i_genblk2_1__genblk1_2__RA1SHD_i 70 350 300 400

    dbSet [dbGet top.insts.name -p core_region_i_instr_mem_sp_ram_wrap_i_sp_ram_i_genblk2_1__genblk1_1__RA1SHD_i].orient R90
    setObjFPlanBox Instance core_region_i_instr_mem_sp_ram_wrap_i_sp_ram_i_genblk2_1__genblk1_1__RA1SHD_i 70 630 300 700

    dbSet [dbGet top.insts.name -p core_region_i_instr_mem_sp_ram_wrap_i_sp_ram_i_genblk2_1__genblk1_0__RA1SHD_i].orient R90
    setObjFPlanBox Instance core_region_i_instr_mem_sp_ram_wrap_i_sp_ram_i_genblk2_1__genblk1_0__RA1SHD_i 70 910 300 1000

    dbSet [dbGet top.insts.name -p core_region_i_instr_mem_sp_ram_wrap_i_sp_ram_i_genblk2_0__genblk1_3__RA1SHD_i].orient R90
    setObjFPlanBox Instance core_region_i_instr_mem_sp_ram_wrap_i_sp_ram_i_genblk2_0__genblk1_3__RA1SHD_i 70 1190 300 1200

    dbSet [dbGet top.insts.name -p core_region_i_instr_mem_sp_ram_wrap_i_sp_ram_i_genblk2_0__genblk1_2__RA1SHD_i].orient R90
    setObjFPlanBox Instance core_region_i_instr_mem_sp_ram_wrap_i_sp_ram_i_genblk2_0__genblk1_2__RA1SHD_i 70 1470 300 1500

    dbSet [dbGet top.insts.name -p core_region_i_instr_mem_sp_ram_wrap_i_sp_ram_i_genblk2_0__genblk1_1__RA1SHD_i].orient R90
    setObjFPlanBox Instance core_region_i_instr_mem_sp_ram_wrap_i_sp_ram_i_genblk2_0__genblk1_1__RA1SHD_i 70 1750 300 1800

    dbSet [dbGet top.insts.name -p core_region_i_instr_mem_sp_ram_wrap_i_sp_ram_i_genblk2_0__genblk1_0__RA1SHD_i].orient R90
    setObjFPlanBox Instance core_region_i_instr_mem_sp_ram_wrap_i_sp_ram_i_genblk2_0__genblk1_0__RA1SHD_i 70 2030 300 2100

    ## Data RAM
    dbSet [dbGet top.insts.name -p core_region_i_data_mem_sp_ram_i_genblk2_1__genblk1_3__RA1SHD_i].orient MX90
    setObjFPlanBox Instance core_region_i_data_mem_sp_ram_i_genblk2_1__genblk1_3__RA1SHD_i 2060 70 2100 300

    dbSet [dbGet top.insts.name -p core_region_i_data_mem_sp_ram_i_genblk2_1__genblk1_2__RA1SHD_i].orient MX90
    setObjFPlanBox Instance core_region_i_data_mem_sp_ram_i_genblk2_1__genblk1_2__RA1SHD_i 2060 350 2100 400

    dbSet [dbGet top.insts.name -p core_region_i_data_mem_sp_ram_i_genblk2_1__genblk1_1__RA1SHD_i].orient MX90
    setObjFPlanBox Instance core_region_i_data_mem_sp_ram_i_genblk2_1__genblk1_1__RA1SHD_i 2060 630 2100 700

    dbSet [dbGet top.insts.name -p core_region_i_data_mem_sp_ram_i_genblk2_1__genblk1_0__RA1SHD_i].orient MX90
    setObjFPlanBox Instance core_region_i_data_mem_sp_ram_i_genblk2_1__genblk1_0__RA1SHD_i 2060 910 2100 1000

    dbSet [dbGet top.insts.name -p core_region_i_data_mem_sp_ram_i_genblk2_0__genblk1_3__RA1SHD_i].orient MX90
    setObjFPlanBox Instance core_region_i_data_mem_sp_ram_i_genblk2_0__genblk1_3__RA1SHD_i 2060 1190 2100 1200

    dbSet [dbGet top.insts.name -p core_region_i_data_mem_sp_ram_i_genblk2_0__genblk1_2__RA1SHD_i].orient MX90
    setObjFPlanBox Instance core_region_i_data_mem_sp_ram_i_genblk2_0__genblk1_2__RA1SHD_i 2060 1470 2100 1500

    dbSet [dbGet top.insts.name -p core_region_i_data_mem_sp_ram_i_genblk2_0__genblk1_1__RA1SHD_i].orient MX90
    setObjFPlanBox Instance core_region_i_data_mem_sp_ram_i_genblk2_0__genblk1_1__RA1SHD_i 2060 1750 2100 1800

    dbSet [dbGet top.insts.name -p core_region_i_data_mem_sp_ram_i_genblk2_0__genblk1_0__RA1SHD_i].orient MX90
    setObjFPlanBox Instance core_region_i_data_mem_sp_ram_i_genblk2_0__genblk1_0__RA1SHD_i 2060 2030 2100 2100

    # Power rings for SRAM
    # Instruction RAM
    selectInst core_region_i_data_mem_sp_ram_i_genblk2_0__genblk1_0__RA1SHD_i
    selectInst core_region_i_data_mem_sp_ram_i_genblk2_0__genblk1_1__RA1SHD_i
    selectInst core_region_i_data_mem_sp_ram_i_genblk2_0__genblk1_2__RA1SHD_i
    selectInst core_region_i_data_mem_sp_ram_i_genblk2_0__genblk1_3__RA1SHD_i
    selectInst core_region_i_data_mem_sp_ram_i_genblk2_1__genblk1_0__RA1SHD_i
    selectInst core_region_i_data_mem_sp_ram_i_genblk2_1__genblk1_1__RA1SHD_i
    selectInst core_region_i_data_mem_sp_ram_i_genblk2_1__genblk1_2__RA1SHD_i
    selectInst core_region_i_data_mem_sp_ram_i_genblk2_1__genblk1_3__RA1SHD_i
    setAddRingMode \
        -ring_target default \
        -extend_over_row 0 \
        -ignore_rows 0 \
        -avoid_short 0 \
        -skip_crossing_trunks none \
        -stacked_via_top_layer LM \
        -stacked_via_bottom_layer M1 \
        -via_using_exact_crossover_size 1 \
        -orthogonal_only true \
        -skip_via_on_pin {  standardcell } \
        -skip_via_on_wire_shape {  noshape }
    addRing \
        -nets {VDD VSS} \
        -type block_rings \
        -around selected \
        -layer {top M3 bottom M3 left M4 right M4} \
        -width {top 2 bottom 2 left 2 right 2} \
        -spacing {top 1 bottom 1 left 1 right 1} \
        -offset {top 1.8 bottom 1.8 left 1.8 right 1.8} \
        -center 0 \
        -extend_corner {br tr } \
        -threshold 0 \
        -jog_distance 0 \
        -snap_wire_center_to_grid None \
        -use_wire_group 1 \
        -use_wire_group_bits 2 \
        -use_interleaving_wire_group 1
    deselectAll

    # Data RAM
    selectInst core_region_i_instr_mem_sp_ram_wrap_i_sp_ram_i_genblk2_0__genblk1_0__RA1SHD_i
    selectInst core_region_i_instr_mem_sp_ram_wrap_i_sp_ram_i_genblk2_0__genblk1_1__RA1SHD_i
    selectInst core_region_i_instr_mem_sp_ram_wrap_i_sp_ram_i_genblk2_0__genblk1_2__RA1SHD_i
    selectInst core_region_i_instr_mem_sp_ram_wrap_i_sp_ram_i_genblk2_0__genblk1_3__RA1SHD_i
    selectInst core_region_i_instr_mem_sp_ram_wrap_i_sp_ram_i_genblk2_1__genblk1_0__RA1SHD_i
    selectInst core_region_i_instr_mem_sp_ram_wrap_i_sp_ram_i_genblk2_1__genblk1_1__RA1SHD_i
    selectInst core_region_i_instr_mem_sp_ram_wrap_i_sp_ram_i_genblk2_1__genblk1_2__RA1SHD_i
    selectInst core_region_i_instr_mem_sp_ram_wrap_i_sp_ram_i_genblk2_1__genblk1_3__RA1SHD_i
    setAddRingMode \
        -ring_target default \
        -extend_over_row 0 \
        -ignore_rows 0 \
        -avoid_short 0 \
        -skip_crossing_trunks none \
        -stacked_via_top_layer LM \
        -stacked_via_bottom_layer M1 \
        -via_using_exact_crossover_size 1 \
        -orthogonal_only true \
        -skip_via_on_pin {  standardcell } \
        -skip_via_on_wire_shape {  noshape }
    addRing \
        -nets {VDD VSS} \
        -type block_rings \
        -around selected \
        -layer {top M3 bottom M3 left M4 right M4} \
        -width {top 2 bottom 2 left 2 right 2} \
        -spacing {top 1 bottom 1 left 1 right 1} \
        -offset {top 1.8 bottom 1.8 left 1.8 right 1.8} \
        -center 0 \
        -extend_corner {tl bl } \
        -threshold 0 \
        -jog_distance 0 \
        -snap_wire_center_to_grid None \
        -use_wire_group 1 \
        -use_wire_group_bits 2 \
        -use_interleaving_wire_group 1
    deselectAll


    # Add Stripes
    addStripe \
        -nets {VDD VSS} \
        -layer M4 \
        -direction vertical \
        -width 2 \
        -spacing 1 \
        -set_to_set_distance 100 \
        -start_from left \
        -switch_layer_over_obs false \
        -max_same_layer_jog_length 2 \
        -padcore_ring_top_layer_limit LM \
        -padcore_ring_bottom_layer_limit M1 \
        -block_ring_top_layer_limit LM \
        -block_ring_bottom_layer_limit M1 \
        -use_wire_group 0 \
        -snap_wire_center_to_grid None
    # FIXME:
    # SRAM block pin sroute failed

    # Add Halo
    createPlaceBlockage -box 64.23400 12.13200 601.20100 2284.52200 -type hard
    createPlaceBlockage -box 2046.46900 8.52600 2646.54200 2284.78200 -type hard

    # Link Power Nets with Power Pins of std cells
    connect_std_cells_to_power

    saveDesign "${top}.floorplan.enc"
}


#############################################################

proc run_place { } {

    global top

    if {[expr ![dbIsHeadDesignInMemory]]} {
        puts "##############"
        puts "###"
        puts "### RESTORING FLOORPLAN!!! "
        puts "###"
        puts "##############"
        restoreDesign "${top}.floorplan.enc.dat" ${top}
    }

    puts "####################"
    puts "###"
    puts "### Place Design ..."
    puts "###"
    puts "####################"

    get_multithread_lic

    # Run Placement
    puts "PLACE ITER 0"
    setTrialRouteMode -highEffort true -ignoreNetIsSpecial false
    setPlaceMode  -timingDriven true -congEffort high
    placeDesign  -inPlaceOpt

    connect_std_cells_to_power

    puts "PLACE ITER 1"
    placeDesign  -inPlaceOpt -incremental

    puts "PLACE ITER 2"
    # optDesign -preCTS

    saveDesign "${top}.place.enc"
}

#############################################################

proc run_clock { } {

    global top

    get_multithread_lic

    if {[expr ![dbIsHeadDesignInMemory]]} {
        puts "##############"
        puts "###"
        puts "### RESTORING PLACE!!! "
        puts "###"
        puts "##############"
        restoreDesign "${top}.place.enc.dat" ${top}
    }

    puts "##############"
    puts "###"
    puts "### Run CTS..."
    puts "###"
    puts "##############"

    if {[sizeof_collection [get_clocks -quiet]] == 0} {
        puts "No clocks found... not running CTS."
        return
    }

    connect_std_cells_to_power

    # Create Clock Tree Spec
    set_ccopt_mode -cts_opt_priority insertion_delay -cts_opt_type full
    set_ccopt_effort -high

    create_ccopt_clock_tree_spec -file ${top}.cts

    set_ccopt_property target_insertion_delay 600ps
    set_ccopt_property target_skew 600ps
    set_ccopt_property source_input_max_trans 10ps


    # Clock Tree Synthesis
    source ${top}.cts

    ccopt_design

    # Post CTS Timing Optimizations
    puts "POSTCTS ITER 0"
    # optDesign -postCTS

    puts "POSTCTS ITER 1"
    # optDesign -postCTS -hold

    # Link power pins of any newly added cells to the power nets
    connect_std_cells_to_power

    saveDesign "${top}.clock.enc"
}


#############################################################


proc run_route { } {

    global top

    get_multithread_lic

    if {[expr ![dbIsHeadDesignInMemory]]} {
        puts "##############"
        puts "###"
        puts "### RESTORING CLOCK!!! "
        puts "###"
        puts "##############"
        restoreDesign "${top}.clock.enc.dat" ${top}
    }

    puts "################################"
    puts "###"
    puts "### Final Routing   .... "
    puts "###"
    puts "################################"

    setNanoRouteMode -quiet -routeWithTimingDriven true
    setNanoRouteMode -quiet -routeSiEffort medium
    setNanoRouteMode -quiet -routeWithSiDriven false
    setNanoRouteMode -quiet -routeWithSiPostRouteFix false

    setNanoRouteMode -drouteFixAntenna true
    setNanoRouteMode -drouteAutoStop false
    setNanoRouteMode -routeAntennaCellName "ANTENNATR"
    setNanoRouteMode -routeReplaceFillerCellList "fillercelllist.txt"
    setNanoRouteMode -routeInsertAntennaDiode true
    setNanoRouteMode -drouteSearchAndRepair true

    setNanoRouteMode -quiet -routeWithViaInPin true
    setNanoRouteMode -quiet -drouteOnGridOnly none
    setNanoRouteMode -quiet -droutePostRouteSwapVia false
    setNanoRouteMode -quiet -drouteUseMultiCutViaEffort medium
    setNanoRouteMode -quiet -routeSelectedNetOnly false
    setNanoRouteMode -quiet -routeTopRoutingLayer    6
    setNanoRouteMode -quiet -routeBottomRoutingLayer 1

    setAttribute -net @CLOCK -weight 5 -preferred_extra_space 1

    routeDesign

    # Comment out some of the following post-route optimization iterations if it's taking too much time
    # Typically a simple design like this don't need so many iterations

    # For Innovus
    setDelayCalMode -engine aae -SIAware true
    setAnalysisMode -analysisType onChipVariation -cppr both
    setOptMode -addInst true -addInstancePrefix POSROT

    puts "POSTROUTE ITER 0"
    extractRC
    optDesign -postRoute
    connect_std_cells_to_power
    saveDesign "${top}.route_step0.enc"

    puts "POSTROUTE ITER 1"
    extractRC
    optDesign -postRoute -drv
    connect_std_cells_to_power
    saveDesign "${top}.route_step1.enc"

    puts "POSTROUTE ITER 2"
    extractRC
    optDesign -postRoute -hold
    connect_std_cells_to_power
    saveDesign "${top}.route_step2.enc"

    puts "POSTROUTE ITER 4"
    extractRC
    optDesign -postRoute -drv
    connect_std_cells_to_power
    saveDesign "${top}.route_step6.enc"

    puts "POSTROUTE ITER 5"
    extractRC
    optDesign -postRoute -hold
    connect_std_cells_to_power
    saveDesign "${top}.route_step7.enc"

    puts "POSTROUTE ITER 6"
    extractRC
    optDesign -postRoute
    connect_std_cells_to_power
    saveDesign "${top}.route_step8.enc"

    puts "Multicut via insertion"
    setNanoRouteMode -quiet -routeWithTimingDriven true
    setNanoRouteMode -quiet -routeSiEffort high
    setNanoRouteMode -quiet -routeWithSiDriven true
    setNanoRouteMode -quiet -routeWithSiPostRouteFix true
    setNanoRouteMode -quiet -droutePostRouteSwapVia multiCut
    detailRoute

    connect_std_cells_to_power

    saveDesign "${top}.route.enc"
}

#############################################################

proc run_final { } {

    global top

    if {[expr ![dbIsHeadDesignInMemory]]} {
        puts "##############"
        puts "###"
        puts "### RESTORING ROUTE!!! "
        puts "###"
        puts "##############"
        restoreDesign "${top}.route.enc.dat" ${top}
    }

    # Grab floorplan information
    get_multithread_lic

    set floorplan_width  [dbDBUToMicrons [lindex [dbFPlanBox [dbHeadFPlan]] 2]]
    set floorplan_height [dbDBUToMicrons [lindex [dbFPlanBox [dbHeadFPlan]] 3]]

    # Add fill cells
    addFiller -cell {FILL64TR FILL32TR FILL16TR FILL8TR FILL4TR FILL2TR FILL1TR} -prefix FILLER
    connect_std_cells_to_power

    # Report timing before metal fill so that sta mode works
    report_timing

    # Add metal fill
    set window_size 500

    setMetalFill -layer {1 2 3 4 5} -minDensity 20 -preferredDensity 25 -maxDensity 80 -maxLength 4 -maxWidth 1 -windowSize $window_size $window_size -windowStep $window_size $window_size

    for {set i 0} { $i < $floorplan_width } {set i [expr $i + $window_size]} {
        for {set j 0} { $j < $floorplan_height } {set j [expr $j + $window_size]} {
            addMetalFill -layer {1 2 3 4 5} -onCells -timingAware sta -area $i $j [expr min($floorplan_width,$i+$window_size)] [expr min($floorplan_height,$j+$window_size)]
        }
    }

    trimMetalFill -deleteViols

    # Run some checks, not that they matter
    clearDrc
    verifyGeometry -error 1000000 -noRoutingBlkg

    verifyConnectivity -type regular -error 1000000 -warning 500000
    verifyProcessAntenna -error 1000000

    # Output DEF
    set dbgLefDefOutVersion 5.5
    defOut -floorplan -netlist -routing ${top}.apr.def

    # Output LEF
    lefout "$top.lef" -stripePin -PGpinLayers 1 2 3 4 5

    # Output GDSII
    setStreamOutMode -snapToMGrid true
    streamOut "$top.gds" -mapFile "./enc2gdsLM.map" -libName ${top} -structureName $top -stripes 1 -mode ALL

    # Output Netlist
    saveNetlist -excludeLeafCell ${top}.apr.v
    saveNetlist -excludeLeafCell -lineLength 10000000 -includePowerGround -includePhysicalInst ${top}.apr.physical.v

    # Generate SDF
    extractRC -outfile ${top}.cap
    rcOut -spef ${top}.spef

    # write_sdf appears broken, but delayCal works.
    write_sdf -version 3.0 -collapse_internal_pins ${top}.apr.sdf
    #delayCal -sdf ${top}.apr.sdf -version 3.0

    # Save Final Design
    saveDesign "${top}.final.enc"
}

#############################################################

proc run_main { } {

    global top

    if { ![info exists top] } {
        puts "top must be provided to common.apr.tcl"
        exit
    }

    run_init
    run_floorplan
    run_place
    run_clock
    run_route
    run_final
}

exec mkdir -p $enc_dir
run_init
return
# run_main

puts "**************************************"
puts "*                                    *"
puts "* Innovus script finished            *"
puts "*                                    *"
puts "**************************************"

# comment out the exit if you want innovus to remain open at the end of the run
exit

#############################################################

