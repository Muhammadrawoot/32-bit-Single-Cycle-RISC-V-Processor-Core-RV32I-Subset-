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

module Register_File (
    input wire clk,
    input wire reset,
    input wire RegWrite,
    input wire [4:0] Read_Reg_1,
    input wire [4:0] Read_Reg_2,
    input wire [4:0] Write_Reg,
    input wire [31:0] Write_Data,
    output wire [31:0] Read_Data_1,
    output wire [31:0] Read_Data_2
);

    reg [31:0] registers [0:31];
    integer i;

    // Synchronous write (x0 is hardwired to 0)
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 32; i = i + 1) begin
                registers[i] <= 32'h00000000;
            end
        end else if (RegWrite && (Write_Reg != 5'd0)) begin
            registers[Write_Reg] <= Write_Data;
        end
    end

    // Combinational read
    assign Read_Data_1 = (Read_Reg_1 == 5'd0) ? 32'h00000000 : registers[Read_Reg_1];
    assign Read_Data_2 = (Read_Reg_2 == 5'd0) ? 32'h00000000 : registers[Read_Reg_2];

endmodule