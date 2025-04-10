`timescale 1ns/1ns
`include "../alu.sv"

module alu_tb;
    logic [31:0] operand_a;
    logic [31:0] operand_b;
    logic [3:0]  alu_control;
    logic [31:0] result;
    logic        zero;

    // Instantiate the ALU
    alu uut (
        .operand_a(operand_a),
        .operand_b(operand_b),
        .alu_control(alu_control),
        .result(result),
        .zero(zero)
    );

    initial begin
        $display("Starting ALU tests...\n");
        $dumpfile("alu.vcd");
        $dumpvars(0, alu_tb);

        // ------------------------
        // Test 1: ADD (5 + 3 = 8)
        // ------------------------
        operand_a = 32'd5;
        operand_b = 32'd3;
        alu_control = 4'b0000; // ADD
        #1;
        $display("ADD: %0d + %0d = %0d (Expected 8)", operand_a, operand_b, result);

        // ------------------------
        // Test 2: SUB (9 - 4 = 5)
        // ------------------------
        operand_a = 32'd9;
        operand_b = 32'd4;
        alu_control = 4'b0001; // SUB
        #1;
        $display("SUB: %0d - %0d = %0d (Expected 5)", operand_a, operand_b, result);

        // ------------------------
        // Test 3: AND (6 & 3 = 2)
        // ------------------------
        operand_a = 32'd6;
        operand_b = 32'd3;
        alu_control = 4'b0010; // AND
        #1;
        $display("AND: %b & %b = %b", operand_a, operand_b, result);

        // ------------------------
        // Test 4: SLT (-1 < 5 = true)
        // ------------------------
        operand_a = -1;
        operand_b = 32'd5;
        alu_control = 4'b0101; // SLT
        #1;
        $display("SLT: %0d < %0d = %0d (Expected 1)", operand_a, operand_b, result);

        // ------------------------
        // Test 5: SRL (16 >> 2 = 4)
        // ------------------------
        operand_a = 32'd16;
        operand_b = 32'd2;
        alu_control = 4'b1000; // SRL
        #1;
        $display("SRL: %0d >> %0d = %0d (Expected 4)", operand_a, operand_b, result);

        // ------------------------
        // Test 6: Zero flag (3 - 3 = 0)
        // ------------------------
        operand_a = 32'd3;
        operand_b = 32'd3;
        alu_control = 4'b0001; // SUB
        #1;
        $display("Zero flag test: %0d - %0d = %0d, Zero = %b (Expected 1)", operand_a, operand_b, result, zero);

        $display("\nALU testbench complete.");
        $finish;
    end
endmodule
