`define AXI_ADDR_WIDTH         32
`define AXI_DATA_WIDTH         32
`define AXI_ID_MASTER_WIDTH     2
`define AXI_ID_SLAVE_WIDTH      4
`define AXI_USER_WIDTH          1


module pulpino_top #(
  parameter USE_ZERO_RISCY       = 0,
  parameter RISCY_RV32F          = 0,
  parameter ZERO_RV32M           = 1,
  parameter ZERO_RV32E           = 0
) (
  // Clock and Reset
  input logic               clk,
  input logic               rst_n,

  input  logic              clk_sel_i,
  input  logic              clk_standalone_i,
  input  logic              testmode_i,
  input  logic              fetch_enable_i,
  input  logic              scan_enable_i,

  //SPI Slave
  input  logic              spi_clk_i,
  input  logic              spi_cs_i,
  output logic [1:0]        spi_mode_o,
  output logic              spi_sdo0_o,
  output logic              spi_sdo1_o,
  output logic              spi_sdo2_o,
  output logic              spi_sdo3_o,
  input  logic              spi_sdi0_i,
  input  logic              spi_sdi1_i,
  input  logic              spi_sdi2_i,
  input  logic              spi_sdi3_i,

  //SPI Master
  output logic              spi_master_clk_o,
  output logic              spi_master_csn0_o,
  output logic              spi_master_csn1_o,
  output logic              spi_master_csn2_o,
  output logic              spi_master_csn3_o,
  output logic [1:0]        spi_master_mode_o,
  output logic              spi_master_sdo0_o,
  output logic              spi_master_sdo1_o,
  output logic              spi_master_sdo2_o,
  output logic              spi_master_sdo3_o,
  input  logic              spi_master_sdi0_i,
  input  logic              spi_master_sdi1_i,
  input  logic              spi_master_sdi2_i,
  input  logic              spi_master_sdi3_i,

  input  logic              scl_pad_i,
  output logic              scl_pad_o,
  output logic              scl_padoen_o,
  input  logic              sda_pad_i,
  output logic              sda_pad_o,
  output logic              sda_padoen_o,

  output logic              uart_tx,
  input  logic              uart_rx,
  output logic              uart_rts,
  output logic              uart_dtr,
  input  logic              uart_cts,
  input  logic              uart_dsr,

  input  logic       [31:0] gpio_in,
  output logic       [31:0] gpio_out,
  output logic       [31:0] gpio_dir,
  output logic [31:0] [5:0] gpio_padcfg,

  // JTAG signals
  input  logic              tck_i,
  input  logic              trstn_i,
  input  logic              tms_i,
  input  logic              tdi_i,
  output logic              tdo_o,

  // PULPino specific pad config
  output logic [31:0] [5:0] pad_cfg_o,
  output logic       [31:0] pad_mux_o
);

  // Local parameters
  localparam AXI_ADDR_WIDTH       = `AXI_ADDR_WIDTH;
  localparam AXI_DATA_WIDTH       = `AXI_DATA_WIDTH;
  localparam AXI_ID_MASTER_WIDTH  = `AXI_ID_MASTER_WIDTH;
  localparam AXI_ID_SLAVE_WIDTH   = `AXI_ID_SLAVE_WIDTH;
  localparam AXI_USER_WIDTH       = `AXI_USER_WIDTH;

  localparam DATA_RAM_SIZE        = 32768;
  localparam INSTR_RAM_SIZE       = 32768;

  localparam INSTR_ADDR_WIDTH     = $clog2(INSTR_RAM_SIZE) + 1;
  localparam DATA_ADDR_WIDTH      = $clog2(DATA_RAM_SIZE);


  // Internal clock and reset signal passed to higher power domain
  logic                        clk_l2h;
  logic                        rstn_l2h;

  // Data MEM interface to higher power domain
  logic                        data_mem_en;
  logic [DATA_ADDR_WIDTH-1:0]  data_mem_addr;
  logic                        data_mem_we;
  logic [AXI_DATA_WIDTH/8-1:0] data_mem_be;
  logic [AXI_DATA_WIDTH-1:0]   data_mem_rdata;
  logic [AXI_DATA_WIDTH-1:0]   data_mem_wdata;

  // Instruction MEM interface to higher power domain
  logic                        instr_mem_en;
  logic [INSTR_ADDR_WIDTH-1:0] instr_mem_addr;
  logic                        instr_mem_we;
  logic [AXI_DATA_WIDTH/8-1:0] instr_mem_be;
  logic [AXI_DATA_WIDTH-1:0]   instr_mem_rdata;
  logic [AXI_DATA_WIDTH-1:0]   instr_mem_wdata;

  pulpino_core #(
    .AXI_ADDR_WIDTH       (  AXI_ADDR_WIDTH      ),
    .AXI_DATA_WIDTH       (  AXI_DATA_WIDTH      ),
    .AXI_ID_MASTER_WIDTH  (  AXI_ID_MASTER_WIDTH ),
    .AXI_ID_SLAVE_WIDTH   (  AXI_ID_SLAVE_WIDTH  ),
    .AXI_USER_WIDTH       (  AXI_USER_WIDTH      ),
    .USE_ZERO_RISCY       (  USE_ZERO_RISCY      ),
    .RISCY_RV32F          (  RISCY_RV32F         ),
    .ZERO_RV32M           (  ZERO_RV32M          ),
    .ZERO_RV32E           (  ZERO_RV32E          )
  ) u_core (
    .clk                  (  clk                 ),
    .rst_n                (  rst_n               ),
    .clk_sel_i            (  clk_sel_i           ),
    .clk_standalone_i     (  clk_standalone_i    ),
    .testmode_i           (  testmode_i          ),
    .fetch_enable_i       (  fetch_enable_i      ),
    .scan_enable_i        (  scan_enable_i       ),
    .spi_clk_i            (  spi_clk_i           ),
    .spi_cs_i             (  spi_cs_i            ),
    .spi_mode_o           (  spi_mode_o          ),
    .spi_sdo0_o           (  spi_sdo0_o          ),
    .spi_sdo1_o           (  spi_sdo1_o          ),
    .spi_sdo2_o           (  spi_sdo2_o          ),
    .spi_sdo3_o           (  spi_sdo3_o          ),
    .spi_sdi0_i           (  spi_sdi0_i          ),
    .spi_sdi1_i           (  spi_sdi1_i          ),
    .spi_sdi2_i           (  spi_sdi2_i          ),
    .spi_sdi3_i           (  spi_sdi3_i          ),
    .spi_master_clk_o     (  spi_master_clk_o    ),
    .spi_master_csn0_o    (  spi_master_csn0_o   ),
    .spi_master_csn1_o    (  spi_master_csn1_o   ),
    .spi_master_csn2_o    (  spi_master_csn2_o   ),
    .spi_master_csn3_o    (  spi_master_csn3_o   ),
    .spi_master_mode_o    (  spi_master_mode_o   ),
    .spi_master_sdo0_o    (  spi_master_sdo0_o   ),
    .spi_master_sdo1_o    (  spi_master_sdo1_o   ),
    .spi_master_sdo2_o    (  spi_master_sdo2_o   ),
    .spi_master_sdo3_o    (  spi_master_sdo3_o   ),
    .spi_master_sdi0_i    (  spi_master_sdi0_i   ),
    .spi_master_sdi1_i    (  spi_master_sdi1_i   ),
    .spi_master_sdi2_i    (  spi_master_sdi2_i   ),
    .spi_master_sdi3_i    (  spi_master_sdi3_i   ),
    .scl_pad_i            (  scl_pad_i           ),
    .scl_pad_o            (  scl_pad_o           ),
    .scl_padoen_o         (  scl_padoen_o        ),
    .sda_pad_i            (  sda_pad_i           ),
    .sda_pad_o            (  sda_pad_o           ),
    .sda_padoen_o         (  sda_padoen_o        ),
    .uart_tx              (  uart_tx             ),
    .uart_rx              (  uart_rx             ),
    .uart_rts             (  uart_rts            ),
    .uart_dtr             (  uart_dtr            ),
    .uart_cts             (  uart_cts            ),
    .uart_dsr             (  uart_dsr            ),
    .gpio_in              (  gpio_in             ),
    .gpio_out             (  gpio_out            ),
    .gpio_dir             (  gpio_dir            ),
    .gpio_padcfg          (  gpio_padcfg         ),
    .tck_i                (  tck_i               ),
    .trstn_i              (  trstn_i             ),
    .tms_i                (  tms_i               ),
    .tdi_i                (  tdi_i               ),
    .tdo_o                (  tdo_o               ),
    .pad_cfg_o            (  pad_cfg_o           ),
    .pad_mux_o            (  pad_mux_o           ),
    .clk_l2h              (  clk_l2h             ),
    .rstn_l2h             (  rstn_l2h            ),
    .data_mem_en          (  data_mem_en         ),
    .data_mem_addr        (  data_mem_addr       ),
    .data_mem_we          (  data_mem_we         ),
    .data_mem_be          (  data_mem_be         ),
    .data_mem_rdata       (  data_mem_rdata      ),
    .data_mem_wdata       (  data_mem_wdata      ),
    .instr_mem_en         (  instr_mem_en        ),
    .instr_mem_addr       (  instr_mem_addr      ),
    .instr_mem_we         (  instr_mem_we        ),
    .instr_mem_be         (  instr_mem_be        ),
    .instr_mem_rdata      (  instr_mem_rdata     ),
    .instr_mem_wdata      (  instr_mem_wdata     )
  );


  pulpino_mem #(
    .AXI_ADDR_WIDTH       (  AXI_ADDR_WIDTH      ),
    .AXI_DATA_WIDTH       (  AXI_DATA_WIDTH      ),
    .AXI_ID_MASTER_WIDTH  (  AXI_ID_MASTER_WIDTH ),
    .AXI_ID_SLAVE_WIDTH   (  AXI_ID_SLAVE_WIDTH  ),
    .AXI_USER_WIDTH       (  AXI_USER_WIDTH      )
  ) u_mem (
    .testmode_i           (  testmode_i          ),
    .clk_l2h              (  clk_l2h             ),
    .rstn_l2h             (  rstn_l2h            ),
    .data_mem_en          (  data_mem_en         ),
    .data_mem_addr        (  data_mem_addr       ),
    .data_mem_we          (  data_mem_we         ),
    .data_mem_be          (  data_mem_be         ),
    .data_mem_rdata       (  data_mem_rdata      ),
    .data_mem_wdata       (  data_mem_wdata      ),
    .instr_mem_en         (  instr_mem_en        ),
    .instr_mem_addr       (  instr_mem_addr      ),
    .instr_mem_we         (  instr_mem_we        ),
    .instr_mem_be         (  instr_mem_be        ),
    .instr_mem_rdata      (  instr_mem_rdata     ),
    .instr_mem_wdata      (  instr_mem_wdata     )
  );

endmodule : pulpino_top
