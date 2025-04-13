//-----------------------------------------------------------------------------
// Main Control Unit
//
// Implements a finite state machine (FSM) that sequences the processor through
// the multicycle stages: Fetch, Decode, Execute, Memory, and Writeback. Based
// on the 7-bit opcode from the decoded instruction and the current state,
// this module generates the control signals that guide the datapath — including
// register file writes, ALU source selection, memory access, and PC updates.
//
// Used In: All stages
//
// File Contributor(s): 
//-----------------------------------------------------------------------------

module control_unit (
    

    input  logic [31:0] instruction,
    input  logic [31:0] rs1,
    input  logic [31:0] immediate,
    input  logic [31:0] pc,
    input  logic [31:0] rs2,
    input  logic [31:0] memory_read_value,

    input  logic branch_taken, // Input for Branch Logic

    output logic register_write_en, // Enable for Write in Register File
    output logic [3:0] pc_control, // Control Signal for Program Counter
    output logic [1:0] ir_control, // Control Signal for Instruction Register
    output logic [3:0] alu_control, // Control Signal for ALU
    output logic [31:0] op2, // Second Input for the ALU

    output logic [31:0] memory_write,
    output logic memory_write_en,
    output logic [31:0] memory_write_address,
    output logic [31:0] memory_read_address,
    output logic [31:0] register_file_write

);(

    enum logic[1:0] {EXECUTE, FETCH, PC_UPDATE} current_state;

    always_comb begin 
        case(state)

            'b01:
                pc_control = 'b0100
                ir_control = 'b00
                alu_control = 'b0000
                register_write_en = 'b0
                memory_write_en = 'b0

                memory_write = 32'b0
                memory_write_address = 32'b0
                memory_read_addreass = 32'b0
                op2 = 32'b0

        endcase
    end

)
endmodule
