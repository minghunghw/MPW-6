// Copyright 2017 ETH Zurich and University of Bologna.
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the “License”); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an “AS IS” BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.

module sp_ram
  #(
    parameter ADDR_WIDTH = 15,
    parameter DATA_WIDTH = 32,
    parameter NUM_WORDS  = 32768
  )(
    // Clock and Reset
    input  logic                    clk,
    input  logic                    rst_n,
    input  logic                    en_i,
    input  logic [ADDR_WIDTH-1:0]   addr_i,
    input  logic [DATA_WIDTH-1:0]   wdata_i,
    output logic [DATA_WIDTH-1:0]   rdata_o,
    input  logic                    we_i,
    input  logic [DATA_WIDTH/8-1:0] be_i
  );

  localparam SRAM_ROW        = 2;
  localparam SRAM_COL        = 4;
  localparam SRAM_ADDR_WIDTH = 12;

  logic [SRAM_ROW-1:0][SRAM_COL-1:0]      we;
  logic [SRAM_ROW-1:0][SRAM_COL-1:0][7:0] rdata, wdata;
  logic [SRAM_ADDR_WIDTH-1:0]             addr;
  logic rdata_sel;

  assign en    = en_i;
  assign addr  = addr_i[ (ADDR_WIDTH - 1 - $clog2(SRAM_ROW)) -:SRAM_ADDR_WIDTH];

  for (genvar gr=0; gr<SRAM_ROW; gr++) begin
    for (genvar gc=0; gc<SRAM_COL; gc++) begin
      assign we[gr][gc] = be_i[gc] & we_i & (addr_i[ADDR_WIDTH-1] == gr);
    end
    assign wdata[gr] = wdata_i;
  end

  for (genvar gr=0; gr<SRAM_ROW; gr++) begin
    for (genvar gc=0; gc<SRAM_COL; gc++) begin
      RA1SHD RA1SHD_i (
        .CLK   (clk),
        .CEN   (~en),
        .WEN   (~we[gr][gc]),
        .A     (addr),
        .D     (wdata[gr][gc]),
        .Q     (rdata[gr][gc])
      );
    end
  end

  assign rdata_o = rdata[rdata_sel];

  always_ff @(posedge clk) begin
    if (!rst_n) begin
      rdata_sel <= 1'b0;
    end
    else begin
      rdata_sel <= addr_i[ADDR_WIDTH-1];
    end
  end

  // localparam words = NUM_WORDS/(DATA_WIDTH/8);

  // logic [DATA_WIDTH/8-1:0][7:0] mem[words];
  // logic [DATA_WIDTH/8-1:0][7:0] wdata;
  // logic [ADDR_WIDTH-1-$clog2(DATA_WIDTH/8):0] addr;

  // integer i;


  // assign addr = addr_i[ADDR_WIDTH-1:$clog2(DATA_WIDTH/8)];


  // always @(posedge clk)
  // begin
  //   if (en_i && we_i)
  //   begin
  //     for (i = 0; i < DATA_WIDTH/8; i++) begin
  //       if (be_i[i])
  //         mem[addr][i] <= wdata[i];
  //     end
  //   end

  //   rdata_o <= mem[addr];
  // end

  // genvar w;
  // generate for(w = 0; w < DATA_WIDTH/8; w++)
  //   begin
  //     assign wdata[w] = wdata_i[(w+1)*8-1:w*8];
  //   end
  // endgenerate
endmodule
