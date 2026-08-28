`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/28/2026 09:40:20 PM
// Design Name: 
// Module Name: Imm_Gen
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



module Imm_Gen(
    input wire [31:0] Instr,
    output reg [31:0] Imm_Out
);

    // The last 7 bits of the instruction tell us the instruction type
    wire [6:0] opcode = Instr[6:0];

    always @(*) begin
        case(opcode)
            // I-Type (e.g., addi, load instructions)
            7'b0010011, 7'b0000011, 7'b1100111: 
                Imm_Out = {{20{Instr[31]}}, Instr[31:20]};
                
            // S-Type (e.g., store instructions like sw)
            7'b0100011: 
                Imm_Out = {{20{Instr[31]}}, Instr[31:25], Instr[11:7]};
                
            // B-Type (e.g., branch instructions like beq)
            7'b1100011: 
                Imm_Out = {{20{Instr[31]}}, Instr[7], Instr[30:25], Instr[11:8], 1'b0};
                
            // U-Type (e.g., lui, auipc)
            7'b0110111, 7'b0010111: 
                Imm_Out = {Instr[31:12], 12'b0};
                
            // J-Type (e.g., jump instructions like jal)
            7'b1101111: 
                Imm_Out = {{12{Instr[31]}}, Instr[19:12], Instr[20], Instr[30:21], 1'b0};
                
            default: 
                Imm_Out = 32'h00000000;
        endcase
    end

endmodule
