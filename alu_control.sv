//-----------------------------------------------------------------------------
// ALU Operation Selector
//
// Based on the ALUOp signal from the control unit and the instruction's funct3
// and funct7 fields, this module determines which operation the ALU should perform.
// It outputs a 4-bit alu_control signal that selects between arithmetic, logical,
// and shift operations in the Execute stage.
//
// Used In: Execute
//
// File Contributor(s): 
//-----------------------------------------------------------------------------
