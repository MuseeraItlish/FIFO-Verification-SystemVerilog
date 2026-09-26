`timescale 1ns/100ps

module top ;
parameter DEPTH=8;
parameter DATA_WIDTH=8;

logic clk;
logic rst_n;

always #5 clk=~clk;

initial begin 
    clk=0;
    rst_n=0;

    #20;
    rst_n=1;
end

fifo_interface #(DEPTH,DATA_WIDTH) fif(clk,rst_n);
//synchronous_fifo #(DEPTH,DATA_WIDTH) dut(fif);
// synchronous_fifo #(
//     .DEPTH(DEPTH),
//     .DATA_WIDTH(DATA_WIDTH)
// ) dut (
//     .clk      (fif.clk),
//     .rst_n    (fif.rst_n),
//     .w_en     (fif.w_en),
//     .r_en     (fif.r_en),
//     .data_in  (fif.data_in),
//     .data_out (fif.data_out),
//     .full     (fif.full),
//     .empty    (fif.empty)
// );
fifo_test #(DEPTH,DATA_WIDTH) test(fif);

endmodule