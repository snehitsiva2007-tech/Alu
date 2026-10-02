`timescale 1ns/1ps

module alu_struct_model_tb;

reg [3:0] A;
reg [3:0] B;
reg [2:0] Sel;

wire [3:0] Result;
wire Carry;
wire Zero;

alu_struct  uut(
    .A(A),
    .B(B),
    .Sel(Sel),
    .Result(Result),
    .Carry(Carry),
    .Zero(Zero)
);

initial begin

    $dumpfile("alu_struct.vcd");
    $dumpvars(0, alu_struct_model_tb);

    $monitor("Time=%0t A=%d B=%d Sel=%b Result=%d Carry=%b Zero=%b",
             $time, A, B, Sel, Result, Carry, Zero);

    A = 4'd5;
    B = 4'd3;
    Sel = 3'b000;
    #10;

    A = 4'd8;
    B = 4'd2;
    Sel = 3'b001;
    #10;

    A = 4'b1100;
    B = 4'b1010;
    Sel = 3'b010;
    #10;

    A = 4'b1100;
    B = 4'b1010;
    Sel = 3'b011;
    #10;

    A = 4'd12;
    B = 4'd3;
    Sel = 3'b100;
    #10;

    A = 4'd3;
    B = 4'd4;
    Sel = 3'b101;
    #10;

    A = 4'b0011;
    B = 4'b0000;
    Sel = 3'b110;
    #10;

    A = 4'b1000;
    B = 4'b0000;
    Sel = 3'b111;
    #10;

    A = 4'd0;
    B = 4'd0;
    Sel = 3'b000;
    #10;

    A = 4'd10;
    B = 4'd0;
    Sel = 3'b100;
    #10;

    A = 4'd15;
    B = 4'd15;
    Sel = 3'b101;
    #10;

    A = 4'd15;
    B = 4'd4;
    Sel = 3'b100;
    #10;

    $finish;

end

endmodule
