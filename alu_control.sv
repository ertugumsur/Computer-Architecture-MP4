//-----------------------------------------------------------------------------
// ALU Operation Selector
//
// Based on the ALUOp signal from the control unit and the instruction's 
// funct3 and funct7 fields, this module determines which operation the ALU 
// should perform. The operations are separated clearly by the instruction 
// type.
//
// Conventions for ALUOp (2-bit signal from the control unit):
//   00 : For load/store instructions (use ADD for address calculation)
//   01 : For branch instructions (use SUB for register comparison)
//   10 : For R-type and I-type arithmetic/logic instructions (further decode)
//   11 : For the JALR instruction (special JALR operation)
//
// Used In: Execute
//
// File Contributor(s): Ishan Porwal
//-----------------------------------------------------------------------------
module alu_control(
    input  logic [1:0] ALUOp,       // 2-bit ALU operation signal from control unit
    input  logic [6:0] funct7,      // funct7 from the instruction decode
    input  logic [2:0] funct3,      // funct3 from instruction decode
    output logic [3:0] alu_control  // 4-bit signal selecting ALU operation, sent to ALU
);

    always_comb begin

        case (ALUOp)
            // Load/Store Instructions: I-type loads and S-type stores
            2'b00: begin
                alu_control = 4'b0000; // ADD
            end

            // Branch Instructions: B-type branches 
            2'b01: begin
                alu_control = 4'b0001; // SUB
            end

            // Arithmetic/Logical Instructions: R-type and I-type arithmetic/logic
            2'b10: begin
                case (funct3)
                    3'b000: begin
                        if (funct7 == 7'b0100000)
                            alu_control = 4'b0001; // SUB
                        else
                            alu_control = 4'b0000; // ADD
                    end
                    3'b001: begin
                        alu_control = 4'b0111; // SLL
                    end
                    3'b010: begin
                        alu_control = 4'b0101; // SLT
                    end
                    3'b011: begin
                        alu_control = 4'b0110; // SLTU
                    end
                    3'b100: begin
                        alu_control = 4'b0100; // XOR
                    end
                    3'b101: begin
                        if (funct7 == 7'b0100000)
                            alu_control = 4'b1001; // SRA (arithmetic)
                        else
                            alu_control = 4'b1000; // SRL (logical)
                    end
                    3'b110: begin
                        alu_control = 4'b0011; // OR
                    end
                    3'b111: begin
                        alu_control = 4'b0010; // AND
                    end
                    default: begin
                        alu_control = 4'b0000; // Default to ADD
                    end
                endcase
            end

            2'b11: begin
                alu_control = 4'b1010; // JALR operation
            end

            // Default: Add
            default: begin
                alu_control = 4'b0000;
            end
        endcase
    end

endmodule
