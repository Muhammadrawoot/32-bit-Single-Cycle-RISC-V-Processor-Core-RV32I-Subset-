`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/28/2026 11:39:12 PM
// Design Name: 
// Module Name: Data_Memory
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



module Data_Memory(
    input wire clk,
    input wire MemWrite,
    input wire MemRead,
    input wire [31:0] Address,
    input wire [31:0] Write_Data,
    output wire [31:0] Read_Data
);

    // Create a memory block of 256 words (each 32 bits wide)
    reg [31:0] memory [0:255];

    // Synchronous Write Logic
    always @(posedge clk) begin
        if (MemWrite) begin
            // Address[31:2] enforces word-alignment
            memory[Address[31:2]] <= Write_Data;
        end
    end

    // Asynchronous Read Logic
    assign Read_Data = (MemRead) ? memory[Address[31:2]] : 32'h00000000;

endmodule
