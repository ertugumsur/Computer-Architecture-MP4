//-----------------------------------------------------------------------------
// Testbench
//
// This testbench sets up and runs a simulation of the multicycle RV32I CPU.
// It generates the system clock and reset signals, instantiates the top-level
// processor module, and executes a loaded RISC-V program from memory.
// The testbench is used to verify correct instruction sequencing, register
// and memory behavior, and overall CPU functionality across multiple cycles.
//
// Used In: Simulation
//
// File Contributor(s): 
//-----------------------------------------------------------------------------

`timescale 10ns/10ns
`include "top.sv"

module testbench;

    logic clk = 0;
    logic reset = 1;

    always begin
        #4 clk = ~clk;
    end

    top dut (
        .clk(clk)
    );

    defparam testbench.dut.MEM.INIT_FILE = "test_files/final_full_test_2.txt";

    initial begin
        $dumpfile("processor.vcd");
        $dumpvars(0, testbench);
        $display("==== Starting Multicycle Processor Simulation ====");

        // Reset
        $display("[RESET]");
        reset = 1;
        #8;
        reset = 0;
        $display("Reset released\n");

        // Run long enough to execute program
        #2048;

        //$display("\n==== Final Register File Dump ====");
        for (int i = 0; i < 32; i++) begin
            $display("x%0d = 0x%08h", i, dut.REGFILE.regs[i]);
        end

        //$display("\n==== Simulation Complete ====");
        $finish;
    end

    // Per-instruction execution trace
    always_ff @(posedge clk) begin
        //$display("PC = 0x%08h | Instr = 0x%08h",
                 //dut.pc_out, dut.instruction);
    end

    // Register file write trace
    always_ff @(posedge clk) begin
        if (dut.register_write_en && dut.rd_address != 0) begin
            //$display("    >> x%-2d <= 0x%08h",
                     //dut.rd_address, dut.register_file_write);
        end
    end

    // Memory write trace
    always_ff @(posedge clk) begin
        if (dut.memory_write_en) begin
            //$display("    >> MEM[0x%08h] <= 0x%08h",
                     //dut.memory_write_address, dut.memory_write);
        end
    end

endmodule
