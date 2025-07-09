`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/05/2025 07:38:42 PM
// Design Name: 
// Module Name: alu
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//   Scalable, parameterized unsigned ALU supporting unsigned operations only.
//   Add, Sub, Inc, Dec, Logic Ops, Shifts, Rotates.
//   Overflow and underflow detected for unsigned arithmetic.
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module alu #(
    parameter WIDTH = 4
)(
    input clk,
    input [3:0] opcode,
    input reset,
    input set,
    input [WIDTH-1:0] A,
    input [WIDTH-1:0] B,
    output reg [WIDTH-1:0] out,
    output reg overflow,
    output reg underflow
    );
    
    localparam OP_ADD = 4'd0,
               OP_SUB = 4'd1,
               OP_INC = 4'd2,
               OP_DEC = 4'd3,
               OP_ZERO = 4'd4,
               OP_AND = 4'd5,
               OP_OR = 4'd6,
               OP_XOR = 4'd7,
               OP_INV = 4'd8,
               OP_NOR = 4'd9,
               OP_SL = 4'd10,
               OP_SR = 4'd11,
               OP_RL = 4'd12,
               OP_RR = 4'd13;   
               
    
    reg [WIDTH:0] next_out;
    
    always_comb begin
        case(opcode)
            OP_ADD: next_out = {1'b0, A} + {1'b0, B}; //add two registers
            OP_SUB: next_out = {1'b0, A} - {1'b0, B}; //subtract two registers
            OP_INC: next_out = {1'b0, A} + 1'b1; //increment register by 1
            OP_DEC: next_out = {1'b0, A} - 1'b1; //decrement register by 1
            OP_ZERO: next_out = {(WIDTH+1){1'b0}}; //set to zero
            OP_AND: next_out = {1'b0, A & B}; //and two registers
            OP_OR: next_out = {1'b0, A | B}; //or two registers
            OP_XOR: next_out = {1'b0, A ^ B}; //xor two registers
            OP_INV: next_out = {1'b0, ~A}; //invert register
            OP_NOR: next_out = {1'b0, ~(A | B)}; //NOR two registers
            OP_SL: next_out = {1'b0, A << 1}; //shift register to the left
            OP_SR: next_out = {1'b0, A >> 1}; //shift register to the right
            OP_RL: next_out = {1'b0, A[WIDTH-2:0], A[WIDTH-1]}; //rotate register ro the left
            OP_RR: next_out = {1'b0, A[0], A[WIDTH-1:1]}; //rotate register to the right
        endcase
    end
    
    always_ff @(posedge clk) begin
        if (reset == 1) begin
            out <= 4'd0;
            overflow <= 1'b0;
            underflow <= 1'b0;
        end
        
        else if (set == 1) begin
            out <= next_out[WIDTH-1:0];
            
            case (opcode)
                4'd0, 4'd2: begin
                    overflow <= next_out[WIDTH];
                    underflow <= 1'b0;
                end 
                4'd1, 4'd3: begin
                    underflow <= next_out[WIDTH];
                    overflow <= 1'b0;
                end 
                default: begin
                    underflow <= 1'b0;
                    overflow <= 1'b0;
                end
            endcase
        end
    end
    
endmodule
