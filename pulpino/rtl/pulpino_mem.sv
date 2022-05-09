module pulpino_mem #(
  parameter AXI_ADDR_WIDTH       = 32,
  parameter AXI_DATA_WIDTH       = 32,
  parameter AXI_ID_MASTER_WIDTH  = 2,
  parameter AXI_ID_SLAVE_WIDTH   = 4,
  parameter AXI_USER_WIDTH       = 1,

  parameter DATA_RAM_SIZE        = 32768, // in bytes
  parameter INSTR_RAM_SIZE       = 32768, // in bytes

  localparam INSTR_ADDR_WIDTH    = $clog2(INSTR_RAM_SIZE)+1, // to make space for the boot rom
  localparam DATA_ADDR_WIDTH     = $clog2(DATA_RAM_SIZE)
) (
  // External signal directly to higher power domain
  input  logic                        testmode_i,

  // Internal clock and reset signal passed to higher power domain
  input  logic                        clk_l2h,
  input  logic                        rstn_l2h,

  // Data MEM interface to higher power domain
  input  logic                        data_mem_en,
  input  logic [DATA_ADDR_WIDTH-1:0]  data_mem_addr,
  input  logic                        data_mem_we,
  input  logic [AXI_DATA_WIDTH/8-1:0] data_mem_be,
  output logic [AXI_DATA_WIDTH-1:0]   data_mem_rdata,
  input  logic [AXI_DATA_WIDTH-1:0]   data_mem_wdata,

  // Instruction MEM interface to higher power domain
  input  logic                        instr_mem_en,
  input  logic [INSTR_ADDR_WIDTH-1:0] instr_mem_addr,
  input  logic                        instr_mem_we,
  input  logic [AXI_DATA_WIDTH/8-1:0] instr_mem_be,
  output logic [AXI_DATA_WIDTH-1:0]   instr_mem_rdata,
  input  logic [AXI_DATA_WIDTH-1:0]   instr_mem_wdata
);

  logic clk, rst_n;

  assign clk   = clk_l2h;
  assign rst_n = rstn_l2h;

  //----------------------------------------------------------------------------//
  // Instruction RAM
  //----------------------------------------------------------------------------//
  instr_ram_wrap
  #(
    .RAM_SIZE   ( INSTR_RAM_SIZE ),
    .DATA_WIDTH ( AXI_DATA_WIDTH )
  )
  instr_mem
  (
    .clk         ( clk             ),
    .rst_n       ( rst_n           ),
    .en_i        ( instr_mem_en    ),
    .addr_i      ( instr_mem_addr  ),
    .wdata_i     ( instr_mem_wdata ),
    .rdata_o     ( instr_mem_rdata ),
    .we_i        ( instr_mem_we    ),
    .be_i        ( instr_mem_be    ),
    .bypass_en_i ( testmode_i      )
  );

  //----------------------------------------------------------------------------//
  // Data RAM
  //----------------------------------------------------------------------------//
  sp_ram_wrap
  #(
    .RAM_SIZE   ( DATA_RAM_SIZE  ),
    .DATA_WIDTH ( AXI_DATA_WIDTH )
  )
  data_mem
  (
    .clk          ( clk            ),
    .rstn_i       ( rst_n          ),
    .en_i         ( data_mem_en    ),
    .addr_i       ( data_mem_addr  ),
    .wdata_i      ( data_mem_wdata ),
    .rdata_o      ( data_mem_rdata ),
    .we_i         ( data_mem_we    ),
    .be_i         ( data_mem_be    ),
    .bypass_en_i  ( testmode_i     )
  );

endmodule : pulpino_mem
