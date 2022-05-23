# make          <- runs simv (after compiling simv if needed)
# make simv     <- compile simv if needed (but do not run)
# make syn      <- runs syn_simv (after synthesizing if needed then 
#                                 compiling synsimv if needed)
# make clean    <- remove files created during compilations (but not synthesis)
# make nuke     <- remove all files created during compilation and synthesis
#
# To compile additional files, add them to the TESTBENCH or SIMFILES as needed
# Every .vg file will need its own rule and one or more synthesis scripts
# The information contained here (in the rules for those vg files) will be 
# similar to the information in those scripts but that seems hard to avoid.
#

VCS = vcs -o $@ +v2k +vc -sverilog -timescale=1ns/1ps +vcs+lic+wait +multisource_int_delays                    \
	+neg_tchk +plusarg_save +overlap +warn=noSDFCOM_UHICD,noSDFCOM_IWSBA,noSDFCOM_IANE,noSDFCOM_PONF -full64 -cc gcc +libext+.v+.vlib+.vh 


all:    simv
	./simv | tee program.out

##### 
# Modify starting here
#####

TESTBENCH = tb_mem.sv
SIMFILES = ../ibm130/RA1SHD.v 
# SIMFILES = ../sky130/sky130_sram_2kbyte_1rw_32x512_8.v 
LIB = /afs/umich.edu/class/eecs627/ibm13/artisan/2005q3v1/aci/sc-x/verilog/ibm13_neg.v

SimplifiedAES.syn.v: 
	dc_shell-t -f synth.tcl | tee synth.out

#####
# Should be no need to modify after here
#####

dve:	$(SIMFILES) $(TESTBENCH) 
	$(VCS) +memcbk $(TESTBENCH) $(SIMFILES) -o dve -R -gui +define+ibm130

simv:	$(SIMFILES) $(TESTBENCH)
	$(VCS) $(TESTBENCH) $(SIMFILES)	-o simv +define+ibm130

ibm130:
	$(VCS) $(TESTBENCH) ../ibm130/RA1SHD.v	-o simv +define+ibm130
	./simv | tee program.out

sky130:
	$(VCS) $(TESTBENCH) ../sky130/sky130_sram_2kbyte_1rw_32x512_8.v -o simv +define+sky130
	./simv | tee program.out

clean:
	rm -rvf simv *.daidir csrc vcs.key program.out \
          dve *.vpd *.vcd *.dump ucli.key DVEfiles

