# Introduction

PULPino is an open-source single-core microcontroller system, based on 32-bit
RISC-V cores developed at ETH Zurich. PULPino is configurable to use either 
the RISCY or the zero-riscy core.


# Requirements

* Modelsim >= 10.2c
* CMake >= 2.8.0 (> 3.1.0 is recommended)
* riscv-toolchain (This version should be used [ri5cy_gnu_toolchain](https://github.com/pulp-platform/ri5cy_gnu_toolchain))
* Python2 >= 2.6

# Setup
### Building datasheet
* Go into the doc/datasheet/, and run ```make all```
    * [tgif](http://bourbon.usc.edu/tgif/install.html) is required for figure generation
    * textlive is required to convert .tex to .pdf


### Building Project
* Git clone the repository from the [original pulpino-platform](https://github.com/pulp-platform/pulpino)
    * After cloning, run ```./update-ips.py```
* Go to sw, create a build directory by running ```mkdir build```
* Copy cmake_configure.riscv.gcc.sh into sw/build/
* Run ```./cmake_configure.riscv.gcc.sh```
    * Remember to check ri5cy_gnu_toolchain is added to the ```$PATH```
* Run ```make vcompile``` to compile all the RTL files into lib with modelsim
* Run ```make hellowrold.vsimc``` to see the result
    * If Hello World! is seen, then the Pulpino platform is set successfully

# Description
* **ips**: Required ips (Systemverilog & VHDL)
* **rtl**: Related RTL files for Pulpino platform
* **sw**: C files
    * **apps**: Different applications
    * **libs**: lib files
    * **ref**: link files for compiling c files
    * **CMakeLists.txt**: Settings for cmake
* **tb**:: testbench files
* **vsim**: libs creation using modelsim

# Project with Pulpino
### Add new software
### Add new customized IPs
