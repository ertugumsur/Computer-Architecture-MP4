`timescale 10ns/10ns
`include "../program_counter.sv"

module program_counter_tb;
    logic clk = 0;
    logic reset;
    logic pc_src;
    logic jalr;
    logic [31:0] immediate;
    logic [31:0] jump_target;
    logic [31:0] pc;

    program_counter uut (
        .clk(clk),
        .reset(reset),
        .pc_src(pc_src),
        .jalr(jalr),
        .immediate(immediate),
        .jump_target(jump_target),
        .pc(pc)
    );

    always begin
        #4 clk = ~clk;
    end

    initial begin
        $dumpfile("pc.vcd");
        $dumpvars(0, program_counter_tb);
        reset = 0;
        pc_src = 0;
        jalr = 0;
        immediate = 0;
        jump_target = 0;

        // Test 1: Reset Test - PC should initialize to 0
        $display("Resetting");
        reset = 1;
        #8;
        reset = 0;
        #4;
        if (pc !== 0)
            $display("FAIL: Reset failed, PC = %0d (expected 0)", pc);
        else
            $display("PASS: Reset successful, PC = %0d", pc);

        // Test 2: Normal Increment Test (PC = PC + 4 every cycle)
        $display("Testing normal increment");
        #24; 
        $display("After 3 cycles with normal increment, PC = %0d (expected 12)", pc);

        // Test 3: Immediate (PC-relative) Jump Test (PC = PC + immediate)
        $display("Testing immediate jump (PC-relative)");
        pc_src = 1;
        immediate = 32'd20;
        #8;
        $display("After immediate jump, PC = %0d (expected 32)", pc);
        pc_src = 0;
        immediate = 0;

        // Test 4: Normal Increment After Immediate Jump Test
        $display("Testing normal increment after immediate jump...");
        #16;
        $display("After 2 more cycles with normal increment, PC = %0d (expected 40)", pc);

        // Test 5: JALR Test
        $display("Testing JALR");
        jalr = 1;
        jump_target = 32'd100;
        #8;
        $display("After JALR, PC = %0d (expected 100)", pc);
        jalr = 0; 
        jump_target = 0;

        // Test 6: Normal Increment After JALR Jump Test
        $display("Testing normal increment after JALR jump...");
        #16;
        $display("After 2 more cycles with normal increment, PC = %0d (expected 108)", pc);

        $finish;
    end

endmodule
