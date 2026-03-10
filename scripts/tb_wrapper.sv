`timescale 1ns/1ps

module tb_wrapper;

  `TOP_TB tb();

  initial begin
    $dumpfile(`VCD_FILE);
    $dumpvars(0, tb);
  end

endmodule
