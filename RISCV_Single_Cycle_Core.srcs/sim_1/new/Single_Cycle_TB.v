`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/28/2026 11:49:20 PM
// Design Name: 
// Module Name: Single_Cycle_TB
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



module Single_Cycle_TB();

    reg clk;
    reg reset;

    // Instantiate Unit Under Test (UUT)
    Single_Cycle_Top uut (
        .clk(clk),
        .reset(reset)
    );

    // 100 MHz Clock Generation (10ns Period)
    always #5 clk = ~clk;

    initial begin
        // Initialize Inputs
        clk = 0;
        reset = 1;

        // Hold Reset active for 20ns to clear PC registers
        #20;
        reset = 0;

        // Allow program execution for 500ns
        #300;
        $finish;
    end

endmodule
