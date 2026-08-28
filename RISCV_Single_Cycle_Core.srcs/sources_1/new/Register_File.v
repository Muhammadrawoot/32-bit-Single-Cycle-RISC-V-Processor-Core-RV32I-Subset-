`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/28/2026 09:09:21 PM
// Design Name: 
// Module Name: Register_File
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

module Register_File(
    input wire clk,
    input wire reset,
    input wire RegWrite,
    input wire [4:0] rs1,           // Source Register 1 index
    input wire [4:0] rs2,           // Source Register 2 index
    input wire [4:0] rd,            // Destination Register index
    input wire [31:0] Write_Data,    // Data to write into rd
    output wire [31:0] Read_Data_1,  // Output value from rs1
    output wire [31:0] Read_Data_2   // Output value from rs2
);

    // 32 registers, each 32 bits wide
    reg [31:0] registers [0:31];

    // Synchronous Write Logic
    integer i;
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 32; i = i + 1) begin
                registers[i] <= 32'h00000000;
            end
        end else if (RegWrite && (rd != 5'b00000)) begin
            registers[rd] <= Write_Data;
        end
    end

    // Asynchronous Read Logic (x0 is hardwired to 0)
    assign Read_Data_1 = (rs1 == 5'b00000) ? 32'h00000000 : registers[rs1];
    assign Read_Data_2 = (rs2 == 5'b00000) ? 32'h00000000 : registers[rs2];

endmodule
