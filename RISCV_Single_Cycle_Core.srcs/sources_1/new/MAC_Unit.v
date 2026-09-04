`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/04/2026 09:16:54 PM
// Design Name: 
// Module Name: MAC_Unit
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


module MAC_Unit (
    input wire [31:0] SrcA,        // Packed vector 1: [A3, A2, A1, A0]
    input wire [31:0] SrcB,        // Packed vector 2: [B3, B2, B1, B0]
    input wire [31:0] Accumulator, // Previous accumulated total
    input wire        MAC_Enable,  // High when executing MMAC instruction
    output wire [31:0] MAC_Out     // 32-bit MAC output
);

    // Unpack 32-bit inputs into 8-bit signed values
    wire signed [7:0] a0 = SrcA[7:0];
    wire signed [7:0] a1 = SrcA[15:8];
    wire signed [7:0] a2 = SrcA[23:16];
    wire signed [7:0] a3 = SrcA[31:24];

    wire signed [7:0] b0 = SrcB[7:0];
    wire signed [7:0] b1 = SrcB[15:8];
    wire signed [7:0] b2 = SrcB[23:16];
    wire signed [7:0] b3 = SrcB[31:24];

    // Parallel 8x8 multiplication (16-bit intermediate results)
    wire signed [15:0] prod0 = a0 * b0;
    wire signed [15:0] prod1 = a1 * b1;
    wire signed [15:0] prod2 = a2 * b2;
    wire signed [15:0] prod3 = a3 * b3;

    // Sum of products
    wire signed [31:0] dot_product = prod0 + prod1 + prod2 + prod3;

    // Output selection
    assign MAC_Out = MAC_Enable ? (dot_product + Accumulator) : 32'h00000000;

endmodule
