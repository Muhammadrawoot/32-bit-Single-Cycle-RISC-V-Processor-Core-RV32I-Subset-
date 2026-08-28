

\# rv32i-single-cycle-core



A 32-bit single-cycle RISC-V processor core implementing the base RV32I Instruction Set Architecture (ISA). Designed and functionally verified in Verilog using AMD Xilinx Vivado.



\---



\## 📌 Architecture Overview



This core processes one instruction per clock cycle using a single-cycle datapath layout connecting instruction fetch, decode, execution, memory access, and register write-back logic.









\---



\## 🎯 Supported Instruction Set



| Instruction Type | Mnemonic | Opcode | Function Description |

| :--- | :--- | :--- | :--- |

| \*\*R-Type\*\* | `add`, `sub`, `and`, `or`, `slt` | `7'b0110011` | Register-register arithmetic and logical operations |

| \*\*I-Type\*\* | `addi` | `7'b0010011` | Sign-extended immediate addition |

| \*\*I-Type\*\* | `lw` | `7'b0000011` | Load 32-bit word from Data Memory |

| \*\*S-Type\*\* | `sw` | `7'b0100011` | Store 32-bit word to Data Memory |

| \*\*B-Type\*\* | `beq` | `7'b1100011` | Branch to PC-relative target if registers are equal |



\---



\## 📁 Core Hardware Modules



\* \*\*`Single\_Cycle\_Top.v`\*\*: Top-level structural module binding control and datapath components.

\* \*\*`PC\_Module.v`\*\*: D-flip-flop register storing the 32-bit Program Counter value.

\* \*\*`PC\_Adder.v`\*\*: Combinational 32-bit adder for `PC + 4` incrementing and branch target offsets.

\* \*\*`Instruction\_Memory.v`\*\*: Word-aligned ROM populated with hex code via `$readmemh`. Pre-initialized with `NOP` (`32'h00000000`) instructions to prevent uninitialized state (`X`) propagation.

\* \*\*`Control\_Unit.v`\*\*: Instruction decoder mapping opcode bits to execution multiplexer logic.

\* \*\*`Register\_File.v`\*\*: Dual-read, single-write 32x32-bit register file with zero-register `x0` locked to `0`.

\* \*\*`Imm\_Gen.v`\*\*: Immediate generator extracting and sign-extending instruction payloads.

\* \*\*`ALU.v`\*\*: Core arithmetic unit handling mathematical logic and zero-flag evaluation.

\* \*\*`Data\_Memory.v`\*\*: Synchronous RAM for single-cycle memory operations.

\* \*\*`Single\_Cycle\_TB.v`\*\*: Testbench providing system clock generation and reset sequences.



\---



\## 🧪 Simulation \& Verification



Verified using \*\*Vivado Simulator (XSim)\*\* across a complete program sequence in `ALL\_Instr\_Test.hex`.



\* \*\*Sequential Execution\*\*: Verified continuous PC increments of `+4` through memory slots.

\* \*\*Control Unit Response\*\*: Dynamic toggling of control flags (`RegWrite`, `ALUSrc`, `MemWrite`, `MemToReg`).

\* \*\*Branch Logic\*\*: Accurate evaluation of equal values driving `PCSrc` high during `BEQ` operations.



\---



\## 🚀 How to Run in Xilinx Vivado



1\. \*\*Clone the Repository:\*\*

&#x20;  ```bash

&#x20;  git clone \[https://github.com/YOUR\_USERNAME/rv32i-single-cycle-core.git](https://github.com/YOUR\_USERNAME/rv32i-single-cycle-core.git)



```



2\. \*\*Setup Vivado Project:\*\*

\* Create a new RTL Project in Vivado.

\* Add all `.v` files into \*\*Design Sources\*\*.

\* Add `Single\_Cycle\_TB.v` into \*\*Simulation Sources\*\*.





3\. \*\*Link Machine Code:\*\*

\* Copy `ALL\_Instr\_Test.hex` into your active simulation folder:

`.../<Project\_Name>.sim/sim\_1/behav/xsim/`





4\. \*\*Run Simulation:\*\*

\* Launch \*\*Behavioral Simulation\*\* and run for `300 ns`.









