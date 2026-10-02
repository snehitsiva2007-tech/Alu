`timescale 1ns/1ps

module full_adder(
    input A,
    input B,
    input Cin,
    output Sum,
    output Cout
);

wire w1, w2, w3;

xor (w1, A, B);
xor (Sum, w1, Cin);
and (w2, A, B);
and (w3, w1, Cin);
or (Cout, w2, w3);

endmodule


module adder_4bit(
    input [3:0] A,
    input [3:0] B,
    output [3:0] Sum,
    output Carry
);

wire c1, c2, c3;

full_adder fa0(A[0], B[0], 1'b0, Sum[0], c1);
full_adder fa1(A[1], B[1], c1, Sum[1], c2);
full_adder fa2(A[2], B[2], c2, Sum[2], c3);
full_adder fa3(A[3], B[3], c3, Sum[3], Carry);

endmodule


module multiplier_4bit(
    input [3:0] A,
    input [3:0] B,
    output [7:0] Product
);

wire [7:0] pp0;
wire [7:0] pp1;
wire [7:0] pp2;
wire [7:0] pp3;

wire [7:0] s1;
wire [7:0] s2;

assign pp0 = B[0] ? {4'b0000, A}       : 8'b00000000;
assign pp1 = B[1] ? {3'b000, A, 1'b0}  : 8'b00000000;
assign pp2 = B[2] ? {2'b00, A, 2'b00}  : 8'b00000000;
assign pp3 = B[3] ? {1'b0, A, 3'b000}  : 8'b00000000;

assign s1 = pp0 + pp1;
assign s2 = s1 + pp2;
assign Product = s2 + pp3;

endmodule


module divider_4bit(
    input [3:0] A,
    input [3:0] B,
    output reg [3:0] Quotient
);

reg [3:0] remainder;
reg [3:0] quotient;
integer i;

always @(*) begin

    remainder = A;
    quotient = 4'b0000;

    if (B != 4'b0000) begin

        for (i = 0; i < 4; i = i + 1) begin

            if (remainder >= B) begin
                remainder = remainder - B;
                quotient = quotient + 1'b1;
            end

        end

    end

    Quotient = quotient;

end

endmodule


module alu_struct_model(
    input [3:0] A,
    input [3:0] B,
    input [2:0] Sel,
    output [3:0] Result,
    output Carry,
    output Zero
);

wire [3:0] add_result;
wire [3:0] sub_result;
wire [3:0] and_result;
wire [3:0] or_result;

wire [7:0] mul_result;
wire [3:0] div_result;

wire add_carry;
wire sub_borrow;

adder_4bit ADD(
    .A(A),
    .B(B),
    .Sum(add_result),
    .Carry(add_carry)
);

assign sub_result = A - B;
assign sub_borrow = (A < B);

assign and_result = A & B;
assign or_result = A | B;

multiplier_4bit MUL(
    .A(A),
    .B(B),
    .Product(mul_result)
);

divider_4bit DIV(
    .A(A),
    .B(B),
    .Quotient(div_result)
);

assign Result =
    (Sel == 3'b000) ? add_result      :
    (Sel == 3'b001) ? sub_result      :
    (Sel == 3'b010) ? and_result      :
    (Sel == 3'b011) ? or_result       :
    (Sel == 3'b100) ? div_result      :
    (Sel == 3'b101) ? mul_result[3:0] :
    (Sel == 3'b110) ? (A << 1)        :
    (Sel == 3'b111) ? (A >> 1)        :
                       4'b0000;

assign Carry =
    (Sel == 3'b000) ? add_carry :
    (Sel == 3'b001) ? sub_borrow :
                       1'b0;

assign Zero = (Result == 4'b0000);

endmodule
