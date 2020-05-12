`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.05.2020 04:32:27
// Design Name: 
// Module Name: bram_tb
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


module bram_tb;



    reg clk;
    reg [0:0]w_en;
    reg [7:0] addr;
    

    reg [11:0] dina;     // data in

    // Outputs
    wire [11:0] douta;          // data out

    // Instantiate the Unit Under Test (UUT)
    blk_mem_gen uut (
        .clka(clk),
        .ena(1'b1), 
        .wea(w_en), 
        .addra(addr), 
        .dina(dina), 
        .douta(douta)
    );

    always begin
        #5 clk =~clk;
    end

    integer counter;
    initial begin
        // Initialize Inputs
        clk = 0;
        addr = 0;
        counter = 0;
        dina = 0;
        w_en = 0;
   end

    always @(posedge clk)begin
           addr <= addr+1;  
           counter <= counter+1; 
           dina <= counter;           
    end

endmodule





















