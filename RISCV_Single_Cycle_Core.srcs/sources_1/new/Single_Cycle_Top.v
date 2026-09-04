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


module Single_Cycle_Top (
    input wire clk,
    input wire reset
);

    // Datapath Interconnect Wires
    wire [31:0] PC, PC_Next, PC_Plus_4, PC_Target;
    wire [31:0] Instruction;
    wire [31:0] Read_Data_1, Read_Data_2;
    wire [31:0] Write_Data;
    wire [31:0] Imm_Out;
    wire [31:0] SrcB;
    wire [31:0] ALU_Result;
    wire [31:0] Read_Data_Mem;
    wire [31:0] MAC_Result;
    wire Zero;

    // Control Unit Output Wires
    wire RegWrite, ALUSrc, MemWrite, MemRead, MemToReg, Branch, MAC_Enable;
    wire [3:0] ALUControl;
    wire PCSrc;

    // ------------------------------------------------------------------
    // 1. Program Counter Register & Fetch Circuitry
    // ------------------------------------------------------------------
    reg [31:0] PC_reg;
    always @(posedge clk or posedge reset) begin
        if (reset)
            PC_reg <= 32'h00000000;
        else
            PC_reg <= PC_Next;
    end
    assign PC = PC_reg;

    assign PC_Plus_4 = PC + 32'd4;
    assign PC_Target = PC + Imm_Out;
    assign PCSrc     = Branch & Zero;
    assign PC_Next   = PCSrc ? PC_Target : PC_Plus_4;

    // ------------------------------------------------------------------
    // 2. Submodule Instantiations
    // ------------------------------------------------------------------
    Instruction_Memory inst_mem (
        .Read_Address(PC),
        .Instruction(Instruction)
    );

    Control_Unit control_unit (
        .Opcode(Instruction[6:0]),
        .Funct3(Instruction[14:12]),
        .Funct7(Instruction[31:25]),
        .RegWrite(RegWrite),
        .ALUSrc(ALUSrc),
        .MemWrite(MemWrite),
        .MemRead(MemRead),
        .MemToReg(MemToReg),
        .Branch(Branch),
        .ALUControl(ALUControl),
        .MAC_Enable(MAC_Enable)
    );

    Register_File reg_file (
        .clk(clk),
        .reset(reset),
        .RegWrite(RegWrite),
        .Read_Reg_1(Instruction[19:15]),
        .Read_Reg_2(Instruction[24:20]),
        .Write_Reg(Instruction[11:7]),
        .Write_Data(Write_Data),
        .Read_Data_1(Read_Data_1),
        .Read_Data_2(Read_Data_2)
    );

    Imm_Gen imm_gen (
        .Instr(Instruction),
        .Imm_Out(Imm_Out)
    );

    // ALU Input B Selection Multiplexer
    assign SrcB = ALUSrc ? Imm_Out : Read_Data_2;

    ALU alu (
        .SrcA(Read_Data_1),
        .SrcB(SrcB),
        .ALUControl(ALUControl),
        .ALU_Result(ALU_Result),
        .Zero(Zero)
    );

    Data_Memory data_mem (
        .clk(clk),
        .MemWrite(MemWrite),
        .MemRead(MemRead),
        .Address(ALU_Result),
        .Write_Data(Read_Data_2),
        .Read_Data(Read_Data_Mem)
    );

    MAC_Unit mac_unit (
        .SrcA(Read_Data_1),
        .SrcB(Read_Data_2),
        .Accumulator(32'h00000000), // Default zero accumulation
        .MAC_Enable(MAC_Enable),
        .MAC_Out(MAC_Result)
    );

    // ------------------------------------------------------------------
    // 3. Register Write-Back Mux (MAC_Result vs Data_Mem vs ALU_Result)
    // ------------------------------------------------------------------
    assign Write_Data = MAC_Enable ? MAC_Result :
                        MemToReg   ? Read_Data_Mem : 
                                     ALU_Result;

endmodule