//-----------------------------------------------------------------------------
// Main Control Unit
//
// This module implements a finite state machine (FSM) that cycles through three
// stages: EXECUTE, FETCH, and PC_UPDATE. It generates all control signals
// needed to operate the processor datapath for one instruction at a time,
// including ALU operation selection, register file writes, program counter
// updates, memory read/write control, and instruction register loading.
// It also sets the memory_funct3 signal to 3'b010 during instruction fetches,
// and to the instruction's funct3 value during memory accesses. This unit is
// responsible for orchestrating each stage of the multicycle RV32I processor
// based on the opcode, funct3, and funct7 fields of the instruction.
//
// Used In: All stages
//
// File Contributor(s): Ertug Umsur
//-----------------------------------------------------------------------------

module control_unit (
    input logic clk,
    input  logic [6:0] opcode,       // Operation code
    input  logic [4:0] rd_address,           // Destination register
    input  logic [2:0] funct3,       // Function 3 bits
    input  logic [4:0] rs1_address,          // Source register 1
    input  logic [4:0] rs2_address,          // Source register 2
    input  logic [6:0] funct7,        // Function 7 bits (upper 7 bits)

    input  logic [31:0] alu_result,
    input  logic [31:0] rs1,
    input  logic [31:0] immediate,
    input  logic [31:0] pc,
    input  logic [31:0] rs2,
    input  logic [31:0] memory_read_value,

    input  logic branch_taken, // Input for Branch Logic

    output logic [3:0] pc_control, // Control Signal for Program Counter
    output logic [1:0] ir_control, // Control Signal for Instruction Register
    output logic [3:0] alu_control, // Control Signal for ALU

    output logic register_write_en, // Enable for Write in Register File
    output logic memory_write_en,

    output logic memory_write,
    output logic [31:0] memory_write_address,
    output logic [31:0] memory_read_address,
    output logic [31:0] register_file_write,
    output logic [31:0] op2, // Second Input for the ALU
    output logic [2:0] memory_funct3
);

    typedef enum logic[1:0] {
        EXECUTE,
        FETCH,
        PC_UPDATE
    } fsm_state_t;

    fsm_state_t next_state_flag;
    fsm_state_t current_state = FETCH;

    always begin
        // default assignments
        #1 pc_control = 4'b0000;
        ir_control = 2'b00;
        memory_funct3 = 3'b000;
        alu_control = 4'b0000;
        register_write_en = 1'b0;
        memory_write_en = 1'b0;
        memory_write = 32'b0;
        memory_write_address = 32'b0;
        memory_read_address = 32'b0;
        register_file_write = 32'b0;
        op2 = 32'b0;
        next_state_flag = current_state;

        case (current_state)
            PC_UPDATE: begin
                pc_control           = 4'b0100;
                ir_control           = 2'b00;
                alu_control          = 4'b0000;

                register_write_en    = 1'b0;
                memory_write_en      = 1'b0;

                memory_write         = 32'b0;
                memory_write_address = 32'b0;
                memory_read_address  = 32'b0;
                register_file_write  = 32'b0;
                op2                  = 32'b0;

                next_state_flag      = FETCH;
            end
            
            FETCH: begin
                pc_control = 4'b0000;
                ir_control = 2'b01;
                memory_funct3 = 3'b010;
                alu_control = 4'b0000;

                register_write_en = 1'b0;
                memory_write_en = 1'b0;

                memory_write = 32'b0;
                memory_write_address = 32'b0;
                memory_read_address = pc;
                register_file_write = 32'b0;
                op2 = 32'b0;

                next_state_flag = EXECUTE;
            end

            EXECUTE: begin
                case(opcode) 

                    7'b0110011: begin // R-Type
                        memory_funct3 = funct3;
                        pc_control = 4'b0000;
                        ir_control = 2'b00;

                        register_write_en = 1'b1;
                        memory_write_en = 1'b0;

                        memory_write = 32'b0;
                        memory_write_address = 32'b0;
                        memory_read_address = 32'b0;
                        register_file_write = alu_result;
                        op2 = rs2;

                        if (funct7 == 7'b0000000) begin
                            case(funct3)
                                3'b000: alu_control = 4'b0000; // ADD
                                3'b100: alu_control = 4'b0100; // XOR
                                3'b110: alu_control = 4'b0011; // OR
                                3'b111: alu_control = 4'b0010; // AND
                                3'b001: alu_control = 4'b0111; // SLL
                                3'b101: alu_control = 4'b1000; // SRL
                                3'b010: alu_control = 4'b0101; // SLT
                                3'b011: alu_control = 4'b0110; // SLTU
                            endcase
                        end else if (funct7 == 7'b0100000) begin
                            case(funct3)
                                3'b000: alu_control = 4'b0001; // SUB
                                3'b101: alu_control = 4'b1001; // SRA
                            endcase
                        end

                        next_state_flag = PC_UPDATE;
                    end

                    7'b0010011: begin // I-Type ALU Immediate
                        pc_control = 4'b0000;
                        ir_control = 2'b00;

                        register_write_en = 1'b1;
                        memory_write_en = 1'b0;

                        memory_write = 32'b0;
                        memory_write_address = 32'b0;
                        memory_read_address = 32'b0;
                        register_file_write = alu_result;
                        op2 = immediate;

                        case(funct3)
                            3'b000: alu_control = 4'b0000; // ADDI
                            3'b100: alu_control = 4'b0100; // XORI
                            3'b110: alu_control = 4'b0011; // ORI
                            3'b111: alu_control = 4'b0010; // ANDI
                            3'b001: if(immediate[11:5] == 7'b0000000) begin alu_control = 4'b0111; end
                            3'b101: if(immediate[11:5] == 7'b0000000) begin alu_control = 4'b1000; end else if (immediate[11:5] == 7'b0100000) begin alu_control = 4'b1001; end
                            3'b010: alu_control = 4'b0101; // SLTI
                            3'b011: alu_control = 4'b0110; // SLTIU
                        endcase

                        next_state_flag = PC_UPDATE;
                    end

                    7'b0000011: begin // I-Type Load
                        pc_control = 4'b0000;
                        ir_control = 2'b00;
                        alu_control = 4'b0000;

                        register_write_en = 1'b1;
                        memory_write_en = 1'b0;

                        memory_write = 32'b0;
                        memory_write_address = 32'b0;
                        memory_read_address = alu_result;
                        op2 = immediate;

                        case(funct3)
                            3'b000: register_file_write = {{24{memory_read_value[7]}}, memory_read_value[7:0]}; // LB
                            3'b001: register_file_write = {{16{memory_read_value[15]}}, memory_read_value[15:0]}; // LH
                            3'b010: register_file_write = memory_read_value; // LW
                            3'b100: register_file_write = {24'b0, memory_read_value[7:0]}; // LBU
                            3'b101: register_file_write = {16'b0, memory_read_value[15:0]}; // LHU
                        endcase

                        next_state_flag = PC_UPDATE;
                    end

                    7'b0100011: begin // S-Type Store
                        pc_control = 4'b0000;
                        ir_control = 2'b00;
                        alu_control = 4'b0000;

                        register_write_en = 1'b0;
                        memory_write_en = 1'b1;

                        memory_write_address = alu_result;
                        memory_read_address = 32'b0;
                        register_file_write = 32'b0;
                        op2 = immediate;

                        case(funct3)
                            3'b000: memory_write = {{24{rs2[7]}}, rs2[7:0]}; // SB
                            3'b001: memory_write = {{16{rs2[15]}}, rs2[15:0]}; // SH
                            3'b010: memory_write = rs2; // SW
                        endcase

                        next_state_flag = PC_UPDATE;
                    end

                    7'b1100011: begin // B-Type Branch
                        if (branch_taken) begin
                            pc_control = 4'b0110;
                            ir_control = 2'b10;
                            alu_control = 4'b0000;

                            register_write_en = 1'b0;
                            memory_write_en = 1'b0;

                            memory_write = 32'b0;
                            memory_write_address = 32'b0;
                            memory_read_address = 32'b0;
                            register_file_write = 32'b0;
                            op2 = 32'b0;

                            next_state_flag = FETCH;
                        end else begin
                            pc_control = 4'b0000;
                            ir_control = 2'b00;
                            alu_control = 4'b0000;

                            register_write_en = 1'b0;
                            memory_write_en = 1'b0;

                            memory_write = 32'b0;
                            memory_write_address = 32'b0;
                            memory_read_address = 32'b0;
                            register_file_write = 32'b0;
                            op2 = 32'b0;

                            next_state_flag = PC_UPDATE;
                        end
                    end

                    7'b1101111: begin // JAL
                        pc_control = 4'b0110;
                        ir_control = 2'b00;
                        alu_control = 4'b0000;

                        register_write_en = 1'b1;
                        memory_write_en = 1'b0;

                        memory_write = 32'b0;
                        memory_write_address = 32'b0;
                        memory_read_address = 32'b0;
                        register_file_write = pc + 3'b100;
                        op2 = 32'b0;

                        next_state_flag = FETCH;
                    end
                        
                    7'b1100111: begin // JALR
                        pc_control = 4'b0101;
                        ir_control = 2'b00;
                        alu_control = 4'b0000;

                        register_write_en = 1'b1;
                        memory_write_en = 1'b0;

                        memory_write = 32'b0;
                        memory_write_address = 32'b0;
                        memory_read_address = 32'b0;
                        register_file_write = pc + 3'b100;
                        op2 = 32'b0;

                        next_state_flag = FETCH;
                    end

                    7'b0110111: begin // LUI
                        pc_control = 4'b0000;
                        ir_control = 2'b00;
                        alu_control = 4'b0000;

                        register_write_en = 1'b1;
                        memory_write_en = 1'b0;

                        memory_write = 32'b0;
                        memory_write_address = 32'b0;
                        memory_read_address = 32'b0;
                        register_file_write = immediate;
                        op2 = 32'b0;

                        next_state_flag = PC_UPDATE;
                    end

                    7'b0010111: begin // AUIPC
                        pc_control = 4'b0000;
                        ir_control = 2'b00;
                        alu_control = 4'b0000;

                        register_write_en = 1'b1;
                        memory_write_en = 1'b0;

                        memory_write = 32'b0;
                        memory_write_address = 32'b0;
                        memory_read_address = 32'b0;
                        register_file_write = pc + immediate;
                        op2 = 32'b0;

                        next_state_flag = PC_UPDATE;
                    end
                endcase
            end
        endcase
    end

    always_ff @(posedge clk) begin
        current_state <= next_state_flag;
    end

endmodule
