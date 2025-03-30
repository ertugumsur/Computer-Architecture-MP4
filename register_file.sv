//-----------------------------------------------------------------------------
// 32 Register Bank
//
// This module implements a 32x32-bit register file for the RV32I architecture.
// It supports two asynchronous read ports (rs1 and rs2) and one synchronous
// write port (rd). Register x0 is hardwired to 0 and cannot be modified.
// The register file is used to store temporary values and intermediate results
// during instruction execution.
//-----------------------------------------------------------------------------
