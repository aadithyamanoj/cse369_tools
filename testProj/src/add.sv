module add #( parameter int width_p = 8)
     (input logic [width_p-1:0] A
     ,input logic [width_p-1:0] B
     ,output logic [width_p:0] C
     );

    assign C = A + B;

endmodule
