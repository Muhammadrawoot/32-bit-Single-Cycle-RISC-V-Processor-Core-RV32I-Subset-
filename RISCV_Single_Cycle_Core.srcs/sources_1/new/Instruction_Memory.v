`timescale 1ns / 1ps

module Instruction_Memory(
    input wire [31:0] Read_Address,
    output wire [31:0] Instruction
);

    // Create a bookshelf of 256 slots (32-bit words)
    reg [31:0] memory [0:255];

    // Load machine code from hex file
integer i;
initial begin
    for (i = 0; i < 256; i = i + 1) begin
        memory[i] = 32'h00000000;
    end
    $readmemh("ALL_Instr_Test.hex", memory);
end

    // Continuously read instruction (word-aligned)
    assign Instruction = memory[Read_Address[31:2]];

endmodule