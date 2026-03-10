`timescale 1ns/1ps

module add_tb;

  parameter width_p = 8;

  logic [width_p-1:0] A;
  logic [width_p-1:0] B;
  logic [width_p:0]   C;

  // DUT
  add #(.width_p(width_p)) dut (
      .A(A),
      .B(B),
      .C(C)
  );

  initial begin


    A = 0; B = 0; #10;
    //$display("A=%0d B=%0d C=%0d", A, B, C);

    A = 5; B = 3; #10;
    //$display("A=%0d B=%0d C=%0d", A, B, C);

    A = 8'hFF; B = 1; #10;
    //$display("A=%0d B=%0d C=%0d", A, B, C);

    A = 100; B = 50; #10;
    //$display("A=%0d B=%0d C=%0d", A, B, C);

    $finish;

  end

endmodule
