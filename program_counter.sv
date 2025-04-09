//-----------------------------------------------------------------------------
// Program Counter
//
// The Program Counter (PC) stores the address of the current instruction.
// In the Fetch stage, the top-level module uses this address to retrieve the
// instruction from memory. After the instruction is decoded and executed,
// the PC is updated — usually to PC + 4, or to a new address if the instruction
// is a branch or jump — so that it points to the next instruction to execute.
//
// Used In: Fetch, Execute, Writeback
//
// File Contributor(s): Ishan Porwal
//-----------------------------------------------------------------------------

module program_counter (
    input  logic clk,
    input  logic reset,
    input  logic pc_src,                // 1 for branch or JAL
    input  logic jalr,                  // 1 for JALR
    input  logic [31:0] immediate,       
    input  logic [31:0] jump_target,    // target for JALR
    output logic [31:0] pc              
);
    always_ff @(posedge clk) begin
        if (reset) begin
            pc <= 32'd0;
        end
        else if (jalr) begin
            // for a JALR, use the jump target computed by the ALU
            pc <= jump_target;
        end
        else if (pc_src) begin
            // for branch or JAL (PC-relative), update PC relative to current PC
            pc <= pc + immediate;
        end
        else begin
            // normally increment pc by 4
            pc <= pc + 32'd4;
        end
    end
endmodule
