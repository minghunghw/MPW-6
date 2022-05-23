set libs [list \
    "RA1SHD_tt_1p2v_25c_syn" \
]

foreach lib $libs {
    read_lib "$lib.lib"
    write_lib -output "$lib.db" -format db USERLIB
    remove_lib USERLIB
}

quit
