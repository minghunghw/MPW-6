if ![info exists PULP_HSA_SIM] {
    set IPS ../.././ips
    set FPGA_IPS ../ips
    set FPGA_RTL ../rtl
}

# axi_node
set SRC_AXI_NODE " \
    $IPS/axi/axi_node/apb_regs_top.sv \
    $IPS/axi/axi_node/axi_address_decoder_AR.sv \
    $IPS/axi/axi_node/axi_address_decoder_AW.sv \
    $IPS/axi/axi_node/axi_address_decoder_BR.sv \
    $IPS/axi/axi_node/axi_address_decoder_BW.sv \
    $IPS/axi/axi_node/axi_address_decoder_DW.sv \
    $IPS/axi/axi_node/axi_AR_allocator.sv \
    $IPS/axi/axi_node/axi_ArbitrationTree.sv \
    $IPS/axi/axi_node/axi_AW_allocator.sv \
    $IPS/axi/axi_node/axi_BR_allocator.sv \
    $IPS/axi/axi_node/axi_BW_allocator.sv \
    $IPS/axi/axi_node/axi_DW_allocator.sv \
    $IPS/axi/axi_node/axi_FanInPrimitive_Req.sv \
    $IPS/axi/axi_node/axi_multiplexer.sv \
    $IPS/axi/axi_node/axi_node.sv \
    $IPS/axi/axi_node/axi_node_wrap.sv \
    $IPS/axi/axi_node/axi_node_wrap_with_slices.sv \
    $IPS/axi/axi_node/axi_regs_top.sv \
    $IPS/axi/axi_node/axi_request_block.sv \
    $IPS/axi/axi_node/axi_response_block.sv \
    $IPS/axi/axi_node/axi_RR_Flag_Req.sv \
"
set INC_AXI_NODE " \
    $IPS/axi/axi_node/. \
"

# apb_node
set SRC_APB_NODE " \
    $IPS/apb/apb_node/apb_node.sv \
    $IPS/apb/apb_node/apb_node_wrap.sv \
"

# axi_mem_if_DP
set SRC_AXI_MEM_IF_DP " \
    $IPS/axi/axi_mem_if_DP/axi_mem_if_MP_Hybrid_multi_bank.sv \
    $IPS/axi/axi_mem_if_DP/axi_mem_if_multi_bank.sv \
    $IPS/axi/axi_mem_if_DP/axi_mem_if_DP_hybr.sv \
    $IPS/axi/axi_mem_if_DP/axi_mem_if_DP.sv \
    $IPS/axi/axi_mem_if_DP/axi_mem_if_SP.sv \
    $IPS/axi/axi_mem_if_DP/axi_read_only_ctrl.sv \
    $IPS/axi/axi_mem_if_DP/axi_write_only_ctrl.sv \
"

# axi_spi_slave
set SRC_AXI_SPI_SLAVE " \
    $IPS/axi/axi_spi_slave/axi_spi_slave.sv \
    $IPS/axi/axi_spi_slave/spi_slave_axi_plug.sv \
    $IPS/axi/axi_spi_slave/spi_slave_cmd_parser.sv \
    $IPS/axi/axi_spi_slave/spi_slave_controller.sv \
    $IPS/axi/axi_spi_slave/spi_slave_dc_fifo.sv \
    $IPS/axi/axi_spi_slave/spi_slave_regs.sv \
    $IPS/axi/axi_spi_slave/spi_slave_rx.sv \
    $IPS/axi/axi_spi_slave/spi_slave_syncro.sv \
    $IPS/axi/axi_spi_slave/spi_slave_tx.sv \
"

# axi_spi_master
set SRC_AXI_SPI_MASTER " \
    $IPS/axi/axi_spi_master/axi_spi_master.sv \
    $IPS/axi/axi_spi_master/spi_master_axi_if.sv \
    $IPS/axi/axi_spi_master/spi_master_clkgen.sv \
    $IPS/axi/axi_spi_master/spi_master_controller.sv \
    $IPS/axi/axi_spi_master/spi_master_fifo.sv \
    $IPS/axi/axi_spi_master/spi_master_rx.sv \
    $IPS/axi/axi_spi_master/spi_master_tx.sv \
"

# apb_uart_sv
set SRC_APB_UART_SV " \
    $IPS/apb/apb_uart_sv/apb_uart_sv.sv \
    $IPS/apb/apb_uart_sv/uart_rx.sv \
    $IPS/apb/apb_uart_sv/uart_tx.sv \
    $IPS/apb/apb_uart_sv/io_generic_fifo.sv \
    $IPS/apb/apb_uart_sv/uart_interrupt.sv \
"

# apb_gpio
set SRC_APB_GPIO " \
    $IPS/apb/apb_gpio/apb_gpio.sv \
"

# apb_event_unit
set SRC_APB_EVENT_UNIT " \
    $IPS/apb/apb_event_unit/apb_event_unit.sv \
    $IPS/apb/apb_event_unit/generic_service_unit.sv \
    $IPS/apb/apb_event_unit/sleep_unit.sv \
"
set INC_APB_EVENT_UNIT " \
    $IPS/apb/apb_event_unit/./include/ \
"

# apb_spi_master
set SRC_APB_SPI_MASTER " \
    $IPS/apb/apb_spi_master/apb_spi_master.sv \
    $IPS/apb/apb_spi_master/spi_master_apb_if.sv \
    $IPS/apb/apb_spi_master/spi_master_clkgen.sv \
    $IPS/apb/apb_spi_master/spi_master_controller.sv \
    $IPS/apb/apb_spi_master/spi_master_fifo.sv \
    $IPS/apb/apb_spi_master/spi_master_rx.sv \
    $IPS/apb/apb_spi_master/spi_master_tx.sv \
"

# fpu
set SRC_FPU " \
    $IPS/fpu/hdl/fpu_utils/fpu_ff.sv \
    $IPS/fpu/hdl/fpu_v0.1/fpu_defs.sv \
    $IPS/fpu/hdl/fpu_v0.1/fpexc.sv \
    $IPS/fpu/hdl/fpu_v0.1/fpu_add.sv \
    $IPS/fpu/hdl/fpu_v0.1/fpu_core.sv \
    $IPS/fpu/hdl/fpu_v0.1/fpu_ftoi.sv \
    $IPS/fpu/hdl/fpu_v0.1/fpu_itof.sv \
    $IPS/fpu/hdl/fpu_v0.1/fpu_mult.sv \
    $IPS/fpu/hdl/fpu_v0.1/fpu_norm.sv \
    $IPS/fpu/hdl/fpu_v0.1/fpu_private.sv \
    $IPS/fpu/hdl/fpu_v0.1/riscv_fpu.sv \
    $IPS/fpu/hdl/fpu_v0.1/fp_fma_wrapper.sv \
    $IPS/fpu/hdl/fpu_div_sqrt_tp_nlp/fpu_defs_div_sqrt_tp.sv \
    $IPS/fpu/hdl/fpu_div_sqrt_tp_nlp/control_tp.sv \
    $IPS/fpu/hdl/fpu_div_sqrt_tp_nlp/fpu_norm_div_sqrt.sv \
    $IPS/fpu/hdl/fpu_div_sqrt_tp_nlp/iteration_div_sqrt_first.sv \
    $IPS/fpu/hdl/fpu_div_sqrt_tp_nlp/iteration_div_sqrt.sv \
    $IPS/fpu/hdl/fpu_div_sqrt_tp_nlp/nrbd_nrsc_tp.sv \
    $IPS/fpu/hdl/fpu_div_sqrt_tp_nlp/preprocess.sv \
    $IPS/fpu/hdl/fpu_div_sqrt_tp_nlp/div_sqrt_top_tp.sv \
    $IPS/fpu/hdl/fpu_fmac/fpu_defs_fmac.sv \
    $IPS/fpu/hdl/fpu_fmac/preprocess_fmac.sv \
    $IPS/fpu/hdl/fpu_fmac/booth_encoder.sv \
    $IPS/fpu/hdl/fpu_fmac/booth_selector.sv \
    $IPS/fpu/hdl/fpu_fmac/pp_generation.sv \
    $IPS/fpu/hdl/fpu_fmac/wallace.sv \
    $IPS/fpu/hdl/fpu_fmac/aligner.sv \
    $IPS/fpu/hdl/fpu_fmac/CSA.sv \
    $IPS/fpu/hdl/fpu_fmac/adders.sv \
    $IPS/fpu/hdl/fpu_fmac/LZA.sv \
    $IPS/fpu/hdl/fpu_fmac/fpu_norm_fmac.sv \
    $IPS/fpu/hdl/fpu_fmac/fmac.sv \
"
set INC_FPU " \
    $IPS/fpu/. \
"

# apb_pulpino
set SRC_APB_PULPINO " \
    $IPS/apb/apb_pulpino/apb_pulpino.sv \
"

# apb_fll_if
set SRC_APB_FLL_IF " \
    $IPS/apb/apb_fll_if/apb_fll_if.sv \
"

# core2axi
set SRC_CORE2AXI " \
    $IPS/axi/core2axi/core2axi.sv \
"

# apb_timer
set SRC_APB_TIMER " \
    $IPS/apb/apb_timer/apb_timer.sv \
    $IPS/apb/apb_timer/timer.sv \
"

# axi2apb
set SRC_AXI2APB " \
    $IPS/axi/axi2apb/AXI_2_APB.sv \
    $IPS/axi/axi2apb/AXI_2_APB_32.sv \
    $IPS/axi/axi2apb/axi2apb.sv \
    $IPS/axi/axi2apb/axi2apb32.sv \
"

# apb_i2c
set SRC_APB_I2C " \
    $IPS/apb/apb_i2c/apb_i2c.sv \
    $IPS/apb/apb_i2c/i2c_master_bit_ctrl.sv \
    $IPS/apb/apb_i2c/i2c_master_byte_ctrl.sv \
    $IPS/apb/apb_i2c/i2c_master_defines.sv \
"
set INC_APB_I2C " \
    $IPS/apb/apb_i2c/. \
"

# zeroriscy_regfile_fpga
set SRC_ZERORISCY_REGFILE_FPGA " \
    $IPS/zero-riscy/zeroriscy_register_file_ff.sv \
"
set INC_ZERORISCY_REGFILE_FPGA " \
    $IPS/zero-riscy/include \
"

# zeroriscy
set SRC_ZERORISCY " \
    $IPS/zero-riscy/include/zeroriscy_defines.sv \
    $IPS/zero-riscy/include/zeroriscy_tracer_defines.sv \
    $IPS/zero-riscy/zeroriscy_alu.sv \
    $IPS/zero-riscy/zeroriscy_compressed_decoder.sv \
    $IPS/zero-riscy/zeroriscy_controller.sv \
    $IPS/zero-riscy/zeroriscy_cs_registers.sv \
    $IPS/zero-riscy/zeroriscy_debug_unit.sv \
    $IPS/zero-riscy/zeroriscy_decoder.sv \
    $IPS/zero-riscy/zeroriscy_int_controller.sv \
    $IPS/zero-riscy/zeroriscy_ex_block.sv \
    $IPS/zero-riscy/zeroriscy_id_stage.sv \
    $IPS/zero-riscy/zeroriscy_if_stage.sv \
    $IPS/zero-riscy/zeroriscy_load_store_unit.sv \
    $IPS/zero-riscy/zeroriscy_multdiv_slow.sv \
    $IPS/zero-riscy/zeroriscy_multdiv_fast.sv \
    $IPS/zero-riscy/zeroriscy_prefetch_buffer.sv \
    $IPS/zero-riscy/zeroriscy_fetch_fifo.sv \
    $IPS/zero-riscy/zeroriscy_core.sv \
"
set INC_ZERORISCY " \
    $IPS/zero-riscy/include \
"



# axi_slice_dc
set SRC_AXI_SLICE_DC " \
    $IPS/axi/axi_slice_dc/axi_slice_dc_master.sv \
    $IPS/axi/axi_slice_dc/axi_slice_dc_slave.sv \
    $IPS/axi/axi_slice_dc/dc_data_buffer.v \
    $IPS/axi/axi_slice_dc/dc_full_detector.v \
    $IPS/axi/axi_slice_dc/dc_synchronizer.v \
    $IPS/axi/axi_slice_dc/dc_token_ring_fifo_din.v \
    $IPS/axi/axi_slice_dc/dc_token_ring_fifo_dout.v \
    $IPS/axi/axi_slice_dc/dc_token_ring.v \
"

# riscv
set SRC_RISCV " \
    $IPS/riscv/include/apu_core_package.sv \
    $IPS/riscv/include/riscv_defines.sv \
    $IPS/riscv/include/riscv_tracer_defines.sv \
    $IPS/riscv/riscv_alu.sv \
    $IPS/riscv/riscv_alu_basic.sv \
    $IPS/riscv/riscv_alu_div.sv \
    $IPS/riscv/riscv_compressed_decoder.sv \
    $IPS/riscv/riscv_controller.sv \
    $IPS/riscv/riscv_cs_registers.sv \
    $IPS/riscv/riscv_debug_unit.sv \
    $IPS/riscv/riscv_decoder.sv \
    $IPS/riscv/riscv_int_controller.sv \
    $IPS/riscv/riscv_ex_stage.sv \
    $IPS/riscv/riscv_hwloop_controller.sv \
    $IPS/riscv/riscv_hwloop_regs.sv \
    $IPS/riscv/riscv_id_stage.sv \
    $IPS/riscv/riscv_if_stage.sv \
    $IPS/riscv/riscv_load_store_unit.sv \
    $IPS/riscv/riscv_mult.sv \
    $IPS/riscv/riscv_prefetch_buffer.sv \
    $IPS/riscv/riscv_prefetch_L0_buffer.sv \
    $IPS/riscv/riscv_core.sv \
    $IPS/riscv/riscv_apu_disp.sv \
    $IPS/riscv/riscv_fetch_fifo.sv \
    $IPS/riscv/riscv_L0_buffer.sv \
"
set INC_RISCV " \
    $IPS/riscv/include \
    $IPS/riscv/../../rtl/includes \
"



# riscv_regfile_fpga
set SRC_RISCV_REGFILE_FPGA " \
    $IPS/riscv/riscv_register_file.sv \
"
set INC_RISCV_REGFILE_FPGA " \
    $IPS/riscv/include \
"


# apb_uart
set SRC_APB_UART " \
    $IPS/apb/apb_uart/apb_uart.vhd \
    $IPS/apb/apb_uart/slib_clock_div.vhd \
    $IPS/apb/apb_uart/slib_counter.vhd \
    $IPS/apb/apb_uart/slib_edge_detect.vhd \
    $IPS/apb/apb_uart/slib_fifo.vhd \
    $IPS/apb/apb_uart/slib_input_filter.vhd \
    $IPS/apb/apb_uart/slib_input_sync.vhd \
    $IPS/apb/apb_uart/slib_mv_filter.vhd \
    $IPS/apb/apb_uart/uart_baudgen.vhd \
    $IPS/apb/apb_uart/uart_interrupt.vhd \
    $IPS/apb/apb_uart/uart_receiver.vhd \
    $IPS/apb/apb_uart/uart_transmitter.vhd \
"

# axi_slice
set SRC_AXI_SLICE " \
    $IPS/axi/axi_slice/axi_ar_buffer.sv \
    $IPS/axi/axi_slice/axi_aw_buffer.sv \
    $IPS/axi/axi_slice/axi_b_buffer.sv \
    $IPS/axi/axi_slice/axi_buffer.sv \
    $IPS/axi/axi_slice/axi_r_buffer.sv \
    $IPS/axi/axi_slice/axi_slice.sv \
    $IPS/axi/axi_slice/axi_w_buffer.sv \
"

# apb_aes
set SRC_APB_AES " \
    $IPS/apb/apb_aes/prim_assert_standard_macros.svh \
    $IPS/apb/apb_aes/prim_assert.sv \
    $IPS/apb/apb_aes/prim_subreg_pkg.sv \
    $IPS/apb/apb_aes/prim_util_pkg.sv \
    $IPS/apb/apb_aes/prim_pkg.sv \
    $IPS/apb/apb_aes/prim_cipher_pkg.sv \
    $IPS/apb/apb_aes/entropy_src_pkg.sv \
    $IPS/apb/apb_aes/edn_pkg.sv \
    $IPS/apb/apb_aes/keymgr_reg_pkg.sv \
    $IPS/apb/apb_aes/keymgr_pkg.sv \
    $IPS/apb/apb_aes/lc_ctrl_state_pkg.sv \
    $IPS/apb/apb_aes/lc_ctrl_pkg.sv \
    $IPS/apb/apb_aes/aes_sbox_canright_pkg.sv \
    $IPS/apb/apb_aes/aes_reg_pkg.sv \
    $IPS/apb/apb_aes/aes_pkg.sv \
    $IPS/apb/apb_aes/prim_generic_buf.sv \
    $IPS/apb/apb_aes/prim_buf.sv \
    $IPS/apb/apb_aes/prim_subreg_ext.sv \
    $IPS/apb/apb_aes/prim_subreg_arb.sv \
    $IPS/apb/apb_aes/prim_subreg_shadow.sv \
    $IPS/apb/apb_aes/prim_subreg.sv \
    $IPS/apb/apb_aes/prim_lfsr.sv \
    $IPS/apb/apb_aes/prim_sparse_fsm_flop.sv \
    $IPS/apb/apb_aes/prim_flop.sv \
    $IPS/apb/apb_aes/prim_generic_flop.sv \
    $IPS/apb/apb_aes/prim_flop_en.sv \
    $IPS/apb/apb_aes/prim_generic_flop_en.sv \
    $IPS/apb/apb_aes/apb_aes_reg_top.sv \
    $IPS/apb/apb_aes/aes_ctrl_reg_shadowed.sv \
    $IPS/apb/apb_aes/aes_sel_buf_chk.sv \
    $IPS/apb/apb_aes/aes_ctr_fsm.sv \
    $IPS/apb/apb_aes/aes_ctr_fsm_n.sv \
    $IPS/apb/apb_aes/aes_ctr_fsm_p.sv \
    $IPS/apb/apb_aes/aes_ctr.sv \
    $IPS/apb/apb_aes/aes_cipher_core.sv \
    $IPS/apb/apb_aes/aes_prng_masking.sv \
    $IPS/apb/apb_aes/aes_prng_clearing.sv \
    $IPS/apb/apb_aes/aes_sub_bytes.sv \
    $IPS/apb/apb_aes/aes_sbox.sv \
    $IPS/apb/apb_aes/aes_sbox_canright.sv \
    $IPS/apb/apb_aes/aes_sbox_lut.sv \
    $IPS/apb/apb_aes/aes_sbox_dom.sv \
    $IPS/apb/apb_aes/aes_sbox_canright_masked_noreuse.sv \
    $IPS/apb/apb_aes/aes_sbox_canright_masked.sv \
    $IPS/apb/apb_aes/aes_shift_rows.sv \
    $IPS/apb/apb_aes/aes_mix_columns.sv \
    $IPS/apb/apb_aes/aes_mix_single_column.sv \
    $IPS/apb/apb_aes/aes_key_expand.sv \
    $IPS/apb/apb_aes/aes_cipher_control.sv \
    $IPS/apb/apb_aes/aes_cipher_control_fsm_p.sv \
    $IPS/apb/apb_aes/aes_cipher_control_fsm_n.sv \
    $IPS/apb/apb_aes/aes_cipher_control_fsm.sv \
    $IPS/apb/apb_aes/aes_control.sv \
    $IPS/apb/apb_aes/aes_control_fsm_p.sv \
    $IPS/apb/apb_aes/aes_control_fsm_n.sv \
    $IPS/apb/apb_aes/aes_control_fsm.sv \
    $IPS/apb/apb_aes/aes_reg_status.sv \
    $IPS/apb/apb_aes/aes_core.sv \
    $IPS/apb/apb_aes/apb_aes.sv \
"
set INC_APB_AES " \
    $IPS/apb/apb_aes/. \
"

# adv_dbg_if
set SRC_ADV_DBG_IF " \
    $IPS/adv_dbg_if/rtl/adbg_axi_biu.sv \
    $IPS/adv_dbg_if/rtl/adbg_axi_module.sv \
    $IPS/adv_dbg_if/rtl/adbg_lint_biu.sv \
    $IPS/adv_dbg_if/rtl/adbg_lint_module.sv \
    $IPS/adv_dbg_if/rtl/adbg_crc32.v \
    $IPS/adv_dbg_if/rtl/adbg_or1k_biu.sv \
    $IPS/adv_dbg_if/rtl/adbg_or1k_module.sv \
    $IPS/adv_dbg_if/rtl/adbg_or1k_status_reg.sv \
    $IPS/adv_dbg_if/rtl/adbg_top.sv \
    $IPS/adv_dbg_if/rtl/bytefifo.v \
    $IPS/adv_dbg_if/rtl/syncflop.v \
    $IPS/adv_dbg_if/rtl/syncreg.v \
    $IPS/adv_dbg_if/rtl/adbg_tap_top.v \
    $IPS/adv_dbg_if/rtl/adv_dbg_if.sv \
    $IPS/adv_dbg_if/rtl/adbg_axionly_top.sv \
    $IPS/adv_dbg_if/rtl/adbg_lintonly_top.sv \
"
set INC_ADV_DBG_IF " \
    $IPS/adv_dbg_if/rtl \
"

# apb2per
set SRC_APB2PER " \
    $IPS/apb/apb2per/apb2per.sv \
"
