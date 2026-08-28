`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/28/2026 11:46:23 PM
// Design Name: 
// Module Name: Single_Cycle_Top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////



module Single_Cycle_Top(
    input wire clk,
    input wire reset
);

    // Internal Wires
    wire [31:0] PC, PC_Next, PC_Plus_4, PC_Target;
    wire [31:0] Instr;
    wire [31:0] Read_Data_1, Read_Data_2, Write_Data_Reg;
    wire [31:0] Imm_Out;
    wire [31:0] SrcB;
    wire [31:0] ALU_Result;
    wire [31:0] Read_Data_Mem;
    wire Zero;
    
    // Control Signals
    wire RegWrite, ALUSrc, MemWrite, MemRead, MemToReg, Branch;
    wire [3:0] ALUControl;
    wire PCSrc;

    // 1. Fetch Stage
    PC_Module pc_mod (
        .clk(clk),
        .reset(reset),
        .PC_Next(PC_Next),
        .PC(PC)
    );

    PC_Adder pc_add_4 (
        .a(PC),
        .b(32'd4),
        .sum(PC_Plus_4)
    );

    Instruction_Memory inst_mem (
        .Read_Address(PC),
        .Instruction(Instr)
    );

    // 2. Decode Stage
    Control_Unit control (
        .Opcode(Instr[6:0]),
        .Funct3(Instr[14:12]),
        .Funct7(Instr[30]),
        .RegWrite(RegWrite),
        .ALUSrc(ALUSrc),
        .MemWrite(MemWrite),
        .MemRead(MemRead),
        .MemToReg(MemToReg),
        .Branch(Branch),
        .ALUControl(ALUControl)
    );

    Register_File reg_file (
        .clk(clk),
        .reset(reset),
        .RegWrite(RegWrite),
        .rs1(Instr[19:15]),
        .rs2(Instr[24:20]),
        .rd(Instr[11:7]),
        .Write_Data(Write_Data_Reg),
        .Read_Data_1(Read_Data_1),
        .Read_Data_2(Read_Data_2)
    );

    Imm_Gen imm_gen (
        .Instr(Instr),
        .Imm_Out(Imm_Out)
    );

    // 3. Execute Stage
    assign SrcB = (ALUSrc) ? Imm_Out : Read_Data_2;

    ALU alu (
        .A(Read_Data_1),
        .B(SrcB),
        .ALUControl(ALUControl),
        .Result(ALU_Result),
        .Zero(Zero)
    );

    PC_Adder pc_add_target (
        .a(PC),
        .b(Imm_Out),
        .sum(PC_Target)
    );

    // Branch Decision Logic
    assign PCSrc = Branch & Zero;
    assign PC_Next = (PCSrc) ? PC_Target : PC_Plus_4;

    // 4. Memory Stage
    Data_Memory data_mem (
        .clk(clk),
        .MemWrite(MemWrite),
        .MemRead(MemRead),
        .Address(ALU_Result),
        .Write_Data(Read_Data_2),
        .Read_Data(Read_Data_Mem)
    );

    // 5. Writeback Stage
    assign Write_Data_Reg = (MemToReg) ? Read_Data_Mem : ALU_Result;

endmodule
