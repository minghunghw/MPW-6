module apb_aes
  import aes_pkg::*;
  import aes_reg_pkg::*;
#(
  parameter int          APB_ADDR_WIDTH        = 12,
  parameter bit          AES192Enable          = 1, // Can be 0 (disable), or 1 (enable).
  parameter bit          Masking               = 1, // Can be 0 (no masking), or
                                                    // 1 (first-order masking) of the cipher
                                                    // core. Masking requires the use of a
                                                    // masked S-Box, see SBoxImpl parameter.
  parameter sbox_impl_e  SBoxImpl              = SBoxImplDom, // See aes_pkg.sv
  parameter int unsigned SecStartTriggerDelay  = 0, // Manual start trigger delay, useful for
                                                    // SCA measurements. A value of e.g. 40
                                                    // allows the processor to go into sleep
                                                    // before AES starts operation.
  parameter bit          SecAllowForcingMasks  = 0, // Allow forcing masks to 0 using
                                                    // FORCE_ZERO_MASK bit in Control Register.
                                                    // Useful for SCA only.
  parameter bit          SecSkipPRNGReseeding  = 1, // The current SCA setup doesn't provide enough
                                                    // resources to implement the infrastucture
                                                    // required for PRNG reseeding (CSRNG, EDN).
                                                    // To enable SCA resistance evaluations, we
                                                    // need to skip reseeding requests.
                                                    // Useful for SCA only.
  parameter logic [NumAlerts-1:0] AlertAsyncOn = {NumAlerts{1'b1}},
  parameter clearing_lfsr_seed_t RndCnstClearingLfsrSeed  = RndCnstClearingLfsrSeedDefault,
  parameter clearing_lfsr_perm_t RndCnstClearingLfsrPerm  = RndCnstClearingLfsrPermDefault,
  parameter clearing_lfsr_perm_t RndCnstClearingSharePerm = RndCnstClearingSharePermDefault,
  parameter masking_lfsr_seed_t  RndCnstMaskingLfsrSeed   = RndCnstMaskingLfsrSeedDefault,
  parameter masking_lfsr_perm_t  RndCnstMaskingLfsrPerm   = RndCnstMaskingLfsrPermDefault
) (
  input  logic                      HCLK,
  input  logic                      HRESETn,
  input  logic [APB_ADDR_WIDTH-1:0] PADDR,
  input  logic               [31:0] PWDATA,
  input  logic                      PWRITE,
  input  logic                      PSEL,
  input  logic                      PENABLE,
  output logic               [31:0] PRDATA,
  output logic                      PREADY,
  output logic                      PSLVERR
);

  localparam int unsigned EntropyWidth = edn_pkg::ENDPOINT_BUS_WIDTH;

  // Signals
  aes_reg2hw_t               reg2hw;
  aes_hw2reg_t               hw2reg;

  apb_aes_reg_top u_reg (
    .HCLK,
    .HRESETn,
    .PADDR,
    .PWDATA,
    .PWRITE,
    .PSEL,
    .PENABLE,
    .PRDATA,
    .PREADY,
    .PSLVERR,
    .reg2hw,
    .hw2reg
  );

  aes_core #(
    .AES192Enable             ( AES192Enable             ),
    .Masking                  ( Masking                  ),
    .SBoxImpl                 ( SBoxImpl                 ),
    .SecStartTriggerDelay     ( SecStartTriggerDelay     ),
    .SecAllowForcingMasks     ( SecAllowForcingMasks     ),
    .SecSkipPRNGReseeding     ( SecSkipPRNGReseeding     ),
    .EntropyWidth             ( EntropyWidth             ),
    .RndCnstClearingLfsrSeed  ( RndCnstClearingLfsrSeed  ),
    .RndCnstClearingLfsrPerm  ( RndCnstClearingLfsrPerm  ),
    .RndCnstClearingSharePerm ( RndCnstClearingSharePerm ),
    .RndCnstMaskingLfsrSeed   ( RndCnstMaskingLfsrSeed   ),
    .RndCnstMaskingLfsrPerm   ( RndCnstMaskingLfsrPerm   )
  ) u_aes_core (
    .clk_i                  ( HCLK                 ),
    .rst_ni                 ( HRESETn              ),
    .rst_shadowed_ni        ( HRESETn              ),
    .entropy_clearing_req_o (                      ),
    .entropy_clearing_ack_i ( '0                   ),
    .entropy_clearing_i     ( '0                   ),
    .entropy_masking_req_o  (                      ),
    .entropy_masking_ack_i  ( '0                   ),
    .entropy_masking_i      ( '0                   ),

    .keymgr_key_i           ( keymgr_pkg::hw_key_req_t'(0) ),

    .lc_escalate_en_i       ( lc_ctrl_pkg::LC_TX_DEFAULT   ),

    .intg_err_alert_i       ( '0                   ),
    .alert_recov_o          (                      ),
    .alert_fatal_o          (                      ),

    .reg2hw                 ( reg2hw               ),
    .hw2reg                 ( hw2reg               )
  );

endmodule : apb_aes
