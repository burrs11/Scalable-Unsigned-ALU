`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/11/2025 06:15:19 PM
// Design Name: 
// Module Name: tb_alu
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_alu();
    parameter WIDTH = 4;
    parameter CLK_PERIOD = 10;
    reg clk; reg [3:0] opcode; reg reset; reg set; reg [WIDTH-1:0] A; reg [WIDTH-1:0] B; logic [WIDTH-1:0] out; logic overflow; logic underflow; integer tb_test_num; string  tb_test_case;
    logic [WIDTH-1:0] expected_val; // declare at the top of your testbench
    
    alu #(.WIDTH(WIDTH))dut(clk, opcode, reset, set, A, B, out, overflow, underflow);
    
    task reset_dut;
    begin
        reset = 1'b1;
        @(negedge clk);
        @(negedge clk);
        reset = 1'b0;
        @(negedge clk);
    end
    endtask
    
    task set_dut;
    begin
        set = 1'b1;
        @(negedge clk);
        @(negedge clk);
        set = 1'b0;
        @(negedge clk);
    end
    endtask
    
    always
    begin: CLK_GEN
        clk = 1'b0;
        #(CLK_PERIOD/2);
        clk = 1'b1;
        #(CLK_PERIOD/2);
    end
    
    initial begin
        //Initialize 
        tb_test_num = -1;
		tb_test_case = "TB init";
        opcode = 4'd0;
        reset = 1'b0;
        set = 1'b0;
        A = 4'd0;
        B = 4'd0;
        
        //test case 0: Reset
        tb_test_num += 1;
        tb_test_case = "Reset";
        reset_dut;
        
        #(0.1);
        
        //test case 1: Test Add
        tb_test_num += 1;
        tb_test_case = "Test Add Functionality";
        opcode = 4'd0;
        A = 4'd5;
        B = 4'd4;
        expected_val = 4'd9;
        set_dut;
        
        $display("Test %0d: %s | A = %b, B = %b, Out = %b, OF = %b, UF = %b",
          tb_test_num, tb_test_case, A, B, out, overflow, underflow);

        if (out !== expected_val) begin
            $display("Mismatch on test %0d (%s): expected %b, got %b", tb_test_num, tb_test_case, expected_val, out);
        end else begin 
            $display("Passed test %0d (%s)", tb_test_num, tb_test_case);
        end
        
        #(0.1);
        
        //test case 2: Test Add
        tb_test_num += 1;
        tb_test_case = "Test Overflow";
        opcode = 4'd0;
        A = 4'd15;
        B = 4'd4;
        set_dut;
        
        #(0.1);
        
        //test case 3: Test Sub
        tb_test_num += 1;
        tb_test_case = "Test A - B";
        opcode = 4'd1;
        A = 4'd5;
        B = 4'd5;
        set_dut;
        
        #(0.1);
        
        //test case 4: Test Underflow
        tb_test_num += 1;
        tb_test_case = "Test Underflow";
        opcode = 4'd1;
        A = 4'd5;
        B = 4'd6;
        set_dut;
        
        #(0.1);
        
        //test case 5: Test Increment A
        tb_test_num += 1;
        tb_test_case = "Test Increment A";
        opcode = 4'd2;
        A = 4'd5;
        set_dut;
        
        #(0.1);
        
        //test case 6: Test Increment A Overflow
        tb_test_num += 1;
        tb_test_case = "Test Increment A Overflow";
        opcode = 4'd2;
        A = 4'd15;
        set_dut;
        
        #(0.1);
        
        //test case 7: Test Decrement A
        tb_test_num += 1;
        tb_test_case = "Test Decrement A";
        opcode = 4'd3;
        A = 4'd5;
        set_dut;
        
        #(0.1);
        
        //test case 8: Test Decrement A Underflow
        tb_test_num += 1;
        tb_test_case = "Test Decrement A Underflow";
        opcode = 4'd3;
        A = 4'd0;
        set_dut;
        
        #(0.1);
        
        //test case 9: Test Clear A
        tb_test_num += 1;
        tb_test_case = "Test Clear A";
        opcode = 4'd4;
        A = 4'd10;
        set_dut;
        
        #(0.1);
        
        //test case 10: Test A & B #1
        tb_test_num += 1;
        tb_test_case = "Test A & B #1";
        opcode = 4'd5;
        A = 4'd15;
        B = 4'd15;
        set_dut;
        
        //test case 11: Test A & B #2
        tb_test_num += 1;
        tb_test_case = "Test A & B #2";
        opcode = 4'd5;
        A = 4'b1100;
        B = 4'b0011;
        set_dut;
        
        //test case 12: A | B
        tb_test_num += 1;
        tb_test_case = "Test A | B";
        opcode = 4'd6;
        A = 4'b1100;
        B = 4'b0011;
        set_dut;
        
        //test case 13: A ^ B #1
        tb_test_num += 1;
        tb_test_case = "Test A ^ B #1";
        opcode = 4'd7;
        A = 4'b1100;
        B = 4'b0011;
        set_dut;
        
        //test case 14: A ^ B #2
        tb_test_num += 1;
        tb_test_case = "Test A ^ B #2";
        opcode = 4'd7;
        A = 4'd1;
        B = 4'd0;
        set_dut;
        
        //test case 15: ~A #1`
        tb_test_num += 1;
        tb_test_case = "Test ~A";
        opcode = 4'd8;
        A = 4'd0;
        set_dut;
        
        //test case 16: ~A #2`
        tb_test_num += 1;
        tb_test_case = "Test ~A";
        opcode = 4'd8;
        A = 4'd15;
        set_dut;
        
        //test case 17: ~(A | B) #1`
        tb_test_num += 1;
        tb_test_case = "Test ~(A | B) #1";
        opcode = 4'd9;
        A = 4'd15;
        B = 4'd0;
        set_dut;
        
        //test case 18: ~(A | B) #2`
        tb_test_num += 1;
        tb_test_case = "Test ~(A | B) #2";
        opcode = 4'd9;
        A = 4'd8;
        B = 4'd4;
        set_dut;
        
        //test case 19: Shift A << 1 #1
        tb_test_num += 1;
        tb_test_case = "Test A << 1 #1";
        opcode = 4'd10;
        A = 4'd8;
        set_dut;
        
        //test case 20: Shift A << 1 #2
        tb_test_num += 1;
        tb_test_case = "Test A << 1 #2";
        opcode = 4'd10;
        A = 4'd1;
        set_dut;
        
        //test case 21: Shift A >> 1 #1
        tb_test_num += 1;
        tb_test_case = "Test A >> 1 #1";
        opcode = 4'd11;
        A = 4'd8;
        set_dut;
        
        //test case 22: Shift A >> 1 #2
        tb_test_num += 1;
        tb_test_case = "Test A >> 1 #2";
        opcode = 4'd11;
        A = 4'd1;
        set_dut;
        
        //test case 23: Shift A >> 1 #1
        tb_test_num += 1;
        tb_test_case = "Test A >> 1 #1";
        opcode = 4'd11;
        A = 4'd8;
        set_dut;
        
        //test case 24: Rotate A to the Left
        tb_test_num += 1;
        tb_test_case = "Test A Rotate to the left";
        opcode = 4'd12;
        A = 4'd11;
        set_dut;
        
        //test case 25: Rotate A to the Right
        tb_test_num += 1;
        tb_test_case = "Test A Rotate to the Right";
        opcode = 4'd13;
        A = 4'd11;
        set_dut;
        
    end
    
endmodule
