`timescale 1ns / 1ps

module top(
    // These signal names are for the nexys A7. 
    // Check your constraint file to get the right names
    input  CLK100MHZ,
    input [7:0] SW,
    input BTNC,
    input BTNR,
    output AUD_PWM, 
    output AUD_SD,
    output [1:0] LED
    );
    
    //integer n;
    // Toggle arpeggiator enabled/disabled
    wire arp_switch;
    wire arp_switch1;
    Debounce change_state (CLK100MHZ, BTNC, arp_switch); // ensure your button choice is correct
    Debounce change_state1 (CLK100MHZ, BTNR, arp_switch1); // ensure your button choice is correct
    
    // Memory IO
    reg ena = 1;
    reg wea = 0;
    reg [7:0] addra=0;
    reg [10:0] dina=0; //We're not putting data in, so we can leave this unassigned
    wire [10:0] douta;
    
         
    // Instantiate block memory here
    // Copy from the instantiation template and change signal names to the ones under "MemoryIO"
    blk_mem_gen bram ( CLK100MHZ, ena, wea, addra, dina, douta);

    //PWM Out - this gets tied to the BRAM
    reg [10:0] PWM;
    
    // Instantiate the PWM module
    // PWM should take in the clock, the data from memory
    // PWM should output to AUD_PWM (or whatever the constraints file uses for the audio out.
    pwm_module pwm_obj (CLK100MHZ, douta, AUD_PWM);
    
    // Devide our clock down
    reg [12:0] clkdiv = 0;
    reg state;
    
    // keep track of variables for implementation
    reg [26:0] note_switch = 0;
    reg [1:0] note = 0;
    reg [8:0] f_base = 0;
    
always @(posedge CLK100MHZ) begin   
    PWM <= douta; // tie memory output to the PWM input
    
    f_base[8:0] = 1493 + SW[7:0]; // get the "base" frequency to work from 
   // clkdiv <= clkdiv + 1;
   
   if (arp_switch == 1'b1)begin
        state=1;
   end
   
   else if (arp_switch1 == 1'b1) begin
        state=0;
   end
    
   
  // Loop to change the output note IF we're in the arp state
  if (state == 1) begin
 
   //for(n = 0; n < 10000000; n = n+1)begin
           note_switch = note_switch + 1;
            if (note_switch == 50000000) 
            begin
                note = note +1;
                note_switch = 0;
            end 
            
            
            clkdiv <= clkdiv + 1;
    
            // FSM to switch between notes, otherwise just output the base note.
            case(note)
            
                0: begin // base note
                    if (clkdiv >= f_base) begin
                        clkdiv[12:0] <= 0;
                        addra <= addra +1;
                    end
                   end
                   
                1: begin // 1.25 faster
                    if (clkdiv >= f_base*5/4) begin
                        clkdiv[12:0] <= 0;
                        addra <= addra +1;
                    end
                   end
                   
                2: begin //1.5 times faster
                    if (clkdiv >= f_base*3/2) begin
                        clkdiv[12:0] <= 0;
                        addra <= addra +1;
                    end
                   end
                   
                3: begin //2 times faster
                    if (clkdiv >= f_base*2) begin
                        clkdiv[12:0] <= 0;
                        addra <= addra +1;
                    end
                   end
                
                default: begin // Don't know what's happening, just output middle C
                    if (clkdiv >= 1493) begin
                        clkdiv[12:0] <= 0;
                        addra <= addra +1;
                    end
                   end
             endcase;
   //end
   end
   
   
        
   else if(state==0) begin   
       note = 0;
       clkdiv <= clkdiv + 1;
       if (clkdiv >= f_base) begin
               clkdiv[12:0] <= 0;
               addra <= addra +1;
       end
   end
        
     
    
end


assign AUD_SD = 1'b1;  // Enable audio out
assign LED[1:0] = note[1:0]; // Tie FRM state to LEDs so we can see and hear changes


endmodule
