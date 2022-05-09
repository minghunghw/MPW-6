module load modelsim/10.6c
module load cmake/3.12.0
module load vcs

RI5CY_BIN=/home/lchsun/projects/ri5cy_gnu_toolchain/install/bin
export PATH=$PATH:$RI5CY_BIN
export MCROOT=/afs/umich.edu/class/eecs627/ibm13/IBM_cmrf8sf/arm_2009q1
alias mcompiler="$MCROOT/lpvt_sram-sp-v20_2008q3v1/aci/ra1shd/bin/ra1shd &"
