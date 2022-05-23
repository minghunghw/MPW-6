set libs [list \
    "sky130_sram_2kbyte_1rw_32x512_8_TT_1p8V_25C" \
]

foreach lib $libs {
    read_lib "$lib.lib"
    write_lib -output "$lib.db" -format db sky130_sram_2kbyte_1rw_32x512_8_TT_1p8V_25C_lib
    remove_lib sky130_sram_2kbyte_1rw_32x512_8_TT_1p8V_25C_lib
}

quit
