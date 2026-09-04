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


module Control_Unit (
    input wire [6:0] Opcode,
    input wire [2:0] Funct3,
    input wire [6:0] Funct7,
    output reg       RegWrite,
    output reg       ALUSrc,
    output reg       MemWrite,
    output reg       MemRead,
    output reg       MemToReg,
    output reg       Branch,
    output reg [3:0] ALUControl,
    output reg       MAC_Enable
);

    always @(*) begin
        // Default values to prevent accidental latches
        RegWrite   = 1'b0;
        ALUSrc     = 1'b0;
        MemWrite   = 1'b0;
        MemRead    = 1'b0;
        MemToReg   = 1'b0;
        Branch     = 1'b0;
        ALUControl = 4'b0000;
        MAC_Enable = 1'b0;

        case (Opcode)
            // R-Type Instructions (add, sub, and, or, slt)
            7'b0110011: begin
                RegWrite = 1'b1;
                if (Funct7 == 7'b0100000)
                    ALUControl = 4'b0110; // SUB
                else begin
                    case (Funct3)
                        3'b000: ALUControl = 4'b0010; // ADD
                        3'b111: ALUControl = 4'b0000; // AND
                        3'b110: ALUControl = 4'b0001; // OR
                        3'b010: ALUControl = 4'b0111; // SLT
                        default: ALUControl = 4'b0010;
                    endcase
                end
            end

            // I-Type Instruction (addi)
            7'b0010011: begin
                RegWrite   = 1'b1;
                ALUSrc     = 1'b1;
                ALUControl = 4'b0010; // ADD
            end

            // Load Word (lw)
            7'b0000011: begin
                RegWrite   = 1'b1;
                ALUSrc     = 1'b1;
                MemRead    = 1'b1;
                MemToReg   = 1'b1;
                ALUControl = 4'b0010; // ADD (Calculate address)
            end

            // Store Word (sw)
            7'b0100011: begin
                ALUSrc     = 1'b1;
                MemWrite   = 1'b1;
                ALUControl = 4'b0010; // ADD (Calculate address)
            end

            // Branch If Equal (beq)
            7'b1100011: begin
                Branch     = 1'b1;
                ALUControl = 4'b0110; // SUB (For comparison)
            end

            // Custom Matrix MAC Instruction (mmac)
            7'b0001011: begin
                RegWrite   = 1'b1;   // Save MAC result into rd register
                MAC_Enable = 1'b1;   // Route calculation through MAC hardware unit
            end

            default: ; // Keep defaults for unhandled opcodes
        endcase
    end

endmodule