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
// File Contributor(s): Ertug Umsur, Ishan Porwal
//-----------------------------------------------------------------------------

module program_counter (
    input  logic clk,
    input  logic [3:0] pc_control,
    input  logic [31:0] immediate,       
    input  logic [31:0] rs1,            // rs1 value for JALR calculation
    output logic [31:0] pc              
);

    logic reset, enable, pc_src, jalr;

    initial begin
        pc <= 32'b0;
    end

    always begin
        reset = pc_control[3];
        enable = pc_control[2];
        pc_src = pc_control[1];
        #1 jalr = pc_control[0];
    end

    always_ff @(posedge clk or posedge reset) begin

        if (reset) begin
                pc <= 32'd0;
        end

        if (enable) begin
            if (jalr) begin
                // for a JALR, use the jump target computed by the ALU
                pc <= rs1 + immediate;
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
    end
endmodule
