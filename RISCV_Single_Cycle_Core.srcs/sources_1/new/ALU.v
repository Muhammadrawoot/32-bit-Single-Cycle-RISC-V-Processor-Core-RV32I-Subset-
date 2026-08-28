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


module ALU(
    input wire [31:0] A,
    input wire [31:0] B,
    input wire [3:0] ALUControl,
    output reg [31:0] Result,
    output wire Zero
);

    always @(*) begin
        case(ALUControl)
            4'b0000: Result = A & B;               // AND
            4'b0001: Result = A | B;               // OR
            4'b0010: Result = A + B;               // ADD
            4'b0110: Result = A - B;               // SUB
            4'b0111: Result = ($signed(A) < $signed(B)) ? 32'd1 : 32'd0; // SLT (Set Less Than)
            4'b0011: Result = A ^ B;               // XOR
            4'b0100: Result = A << B[4:0];         // SLL (Shift Left Logical)
            4'b0101: Result = A >> B[4:0];         // SRL (Shift Right Logical)
            4'b1000: Result = $signed(A) >>> B[4:0]; // SRA (Shift Right Arithmetic)
            default: Result = 32'h00000000;
        endcase
    end

    // The Zero flag is 1 if the Result is exactly 0
    assign Zero = (Result == 32'h00000000);

endmodule
