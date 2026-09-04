`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/28/2026 10:33:38 PM
// Design Name: 
// Module Name: ALU
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



module ALU (
    input wire [31:0] SrcA,
    input wire [31:0] SrcB,
    input wire [3:0] ALUControl,
    output reg [31:0] ALU_Result,
    output wire Zero
);

    always @(*) begin
        case (ALUControl)
            4'b0000: ALU_Result = SrcA & SrcB;                    // AND
            4'b0001: ALU_Result = SrcA | SrcB;                    // OR
            4'b0010: ALU_Result = SrcA + SrcB;                    // ADD
            4'b0110: ALU_Result = SrcA - SrcB;                    // SUB
            4'b0111: ALU_Result = ($signed(SrcA) < $signed(SrcB)) ? 32'd1 : 32'd0; // SLT
            default: ALU_Result = 32'h00000000;
        endcase
    end

    // Zero flag set high when ALU output is 0 (used for BEQ branches)
    assign Zero = (ALU_Result == 32'h00000000) ? 1'b1 : 1'b0;

endmodule