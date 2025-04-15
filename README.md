# 32-bit RISC-V Processor (Miniproject 4)

This project implements a multi-cycle, unpipelined 32-bit RISC-V processor using SystemVerilog and the OSS CAD Suite. It was developed as part of the Computer Architecture course at Olin College of Engineering (Spring 2025) by Ahan Trivedi, Ishan Porwal, Nividh Singh, and Ertug Umsur.

## Overview

- **Instruction Set:** RV32I base integer instruction set (excluding system and atomic instructions)
- **Architecture:** Multi-cycle, unpipelined processor with Von Neumann memory
- **Peripherals:** Supports memory-mapped I/O
- **Target Platform:** iceBlinkPico FPGA board
- **Verification:** Functional simulation and execution of RISC-V programs, including LED blinking

## Repository Structure

```
├── alu.sv                  # ALU logic for arithmetic and logic operations
├── alu_tb.sv               # ALU testbench
├── branch_logic.sv         # Branch decision logic
├── control_unit.sv         # FSM control logic for the datapath
├── immediate_generator.sv  # Sign-extension and immediate decoding
├── instruction_decode.sv   # Instruction decoding and operand forwarding
├── instruction_register.sv # Holds the current instruction
├── memory.sv               # Unified instruction/data memory with memory-mapped I/O
├── program_counter.sv      # PC logic with jump and branch support
├── program_counter_tb.sv   # PC testbench
├── register_file.sv        # 32x32-bit register file
├── testbench.sv            # Top-level testbench to simulate processor behavior
├── top.sv                  # Processor top-level module integrating all components
├── initial_full_test.txt   # Initial test program (hex format)
├── final_full_test.txt     # Final test program used for verification
└── README.md               # Project documentation
```

## How to Simulate

1. **Install OSS CAD Suite** (https://github.com/YosysHQ/oss-cad-suite-build)
2. **Run simulation:**

```bash
iverilog -g2012 -o testbench.vvp testbench.sv
vvp testbench.vvp
```

3. **Optional waveform generation:**

```bash
gtkwave dump.vcd
```

## RISC-V Programs

The processor was tested using two RISC-V machine code programs in hexadecimal:
- `initial_full_test.txt`: Initial verification test
- `final_full_test.txt`: Functional final test with arithmetic, memory, and branch instructions

## Hardware Demo

On the iceBlinkPico board, a compiled version of the `final_full_test.txt` was loaded via the onboard memory. The program successfully blinked an LED using memory-mapped I/O, demonstrating real hardware execution.

## Authors

- Ahan Trivedi
- Ishan Porwal
- Nividh Singh
- Ertug Umsur

## License

This project is intended for educational purposes and is released without a specific license.
