`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/28/2026 11:44:25 PM
// Design Name: 
// Module Name: Control_Unit
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


module Control_Unit(
    input wire [6:0] Opcode,
    input wire [2:0] Funct3,
    input wire Funct7,              // Bit 30 of instruction (Instr[30])
    output reg RegWrite,
    output reg ALUSrc,
    output reg MemWrite,
    output reg MemRead,
    output reg MemToReg,
    output reg Branch,
    output reg [3:0] ALUControl
);

    // 1. Main Decoder: Toggles control signals based on Instruction Type
    always @(*) begin
        case(Opcode)
            // R-Type (e.g., add, sub, and, or, slt)
            7'b0110011: begin
                RegWrite = 1'b1;
                ALUSrc   = 1'b0; // ALU second input is Register 2
                MemWrite = 1'b0;
                MemRead  = 1'b0;
                MemToReg = 1'b0; // Write back ALU result to Register
                Branch   = 1'b0;
            end
            
            // I-Type Immediate ALU (e.g., addi, andi, ori)
            7'b0010011: begin
                RegWrite = 1'b1;
                ALUSrc   = 1'b1; // ALU second input is Sign-Extended Immediate
                MemWrite = 1'b0;
                MemRead  = 1'b0;
                MemToReg = 1'b0;
                Branch   = 1'b0;
            end
            
            // I-Type Load (e.g., lw)
            7'b0000011: begin
                RegWrite = 1'b1;
                ALUSrc   = 1'b1; // Calculate memory offset using Immediate
                MemWrite = 1'b0;
                MemRead  = 1'b1;
                MemToReg = 1'b1; // Write back loaded Memory Data to Register
                Branch   = 1'b0;
            end
            
            // S-Type Store (e.g., sw)
            7'b0100011: begin
                RegWrite = 1'b0;
                ALUSrc   = 1'b1; // Calculate memory offset using Immediate
                MemWrite = 1'b1;
                MemRead  = 1'b0;
                MemToReg = 1'b0;
                Branch   = 1'b0;
            end
            
            // B-Type Branch (e.g., beq)
            7'b1100011: begin
                RegWrite = 1'b0;
                ALUSrc   = 1'b0; // Compare Register 1 and Register 2
                MemWrite = 1'b0;
                MemRead  = 1'b0;
                MemToReg = 1'b0;
                Branch   = 1'b1;
            end
            
            default: begin
                RegWrite = 1'b0;
                ALUSrc   = 1'b0;
                MemWrite = 1'b0;
                MemRead  = 1'b0;
                MemToReg = 1'b0;
                Branch   = 1'b0;
            end
        endcase
    end

    // 2. ALU Decoder: Generates 4-bit ALUControl signal
    always @(*) begin
        case(Opcode)
            7'b0110011: begin // R-Type
                case(Funct3)
                    3'b000: ALUControl = (Funct7) ? 4'b0110 : 4'b0010; // SUB or ADD
                    3'b001: ALUControl = 4'b0100; // SLL
                    3'b010: ALUControl = 4'b0111; // SLT
                    3'b100: ALUControl = 4'b0011; // XOR
                    3'b101: ALUControl = (Funct7) ? 4'b1000 : 4'b0101; // SRA or SRL
                    3'b110: ALUControl = 4'b0001; // OR
                    3'b111: ALUControl = 4'b0000; // AND
                    default: ALUControl = 4'b0010;
                endcase
            end
            
            7'b0010011: begin // I-Type ALU
                case(Funct3)
                    3'b000: ALUControl = 4'b0010; // ADDI
                    3'b001: ALUControl = 4'b0100; // SLLI
                    3'b010: ALUControl = 4'b0111; // SLTI
                    3'b100: ALUControl = 4'b0011; // XORI
                    3'b101: ALUControl = (Funct7) ? 4'b1000 : 4'b0101; // SRAI / SRLI
                    3'b110: ALUControl = 4'b0001; // ORI
                    3'b111: ALUControl = 4'b0000; // ANDI
                    default: ALUControl = 4'b0010;
                endcase
            end
            
            7'b0000011, 7'b0100011: ALUControl = 4'b0010; // Load/Store address calculation (ADD)
            7'b1100011:             ALUControl = 4'b0110; // Branch evaluation (SUB)
            default:                ALUControl = 4'b0010;
        endcase
    end

endmodule
