interface fifo_interface #(parameter DEPTH=8, DATA_WIDTH=8) (
  input logic clk,
  input logic rst_n
);
  logic w_en, r_en;
  logic [DATA_WIDTH-1:0] data_in;
  logic [DATA_WIDTH-1:0] data_out;
  logic full, empty;
endinterface : fifo_interface
