`timescale 1ns / 1ps


module uart_recevier
(
input clk,
input reset,
input sample_tick,
input rx,
output reg rx_done,
output [7:0] dout  // 8 bits of data 
);

parameter [1:0] idle = 2'b00,
                start = 2'b01,
                data = 2'b10,
                stop = 2'b11;
 reg [1:0] next,current ; 
 reg [3:0] bits;
 reg [3:0] no_ticks;
 reg  srt,data_sgn,stop_sgn,rx_done_next;
 reg [7:0]data_reg;
              
                
always@(posedge clk or posedge reset) 
begin
    if(reset) begin
            current <= idle;
            rx_done <= 0;
    end
    else begin
    current <= next;
    rx_done<=rx_done_next;
    end
end


always@(*)
begin
 next = current;
 rx_done_next = 0;
case(current)
idle : if(rx == 0)
        next = start;
        else
        next = idle;
start : if(srt)
        next = data;
        else
        next = start;       
data : if(data_sgn)
       next = stop;
       else
       next = data;
stop :
    if(stop_sgn)begin
        next = idle;
        if(rx)
        rx_done_next = 1;
        end
    else
        next = stop;
default : next = idle;
endcase
end         

always@(posedge clk or posedge reset) begin
if(reset)
    begin
        bits <= 0;
        no_ticks <= 0;
        srt <= 0;
        data_sgn <= 0;
        stop_sgn <= 0;
        data_reg <= 0;
    end
    
else if( sample_tick)
begin
case (current)
        idle : begin
                srt <= 0;
                data_sgn <= 0;
                stop_sgn <= 0;
                bits <= 0;
                no_ticks <= 0;
                end
        start : begin
                data_sgn <= 0;
                stop_sgn <= 0;
                if(no_ticks == 7)
                begin
                no_ticks <= 0;
                if(rx == 0)
                srt <= 1;
                else
                srt <= 0;
                end
                else
                no_ticks <= no_ticks + 1 ;
                end
        data :
                begin
                srt <= 0;
                if(no_ticks == 15)
                begin
                no_ticks <= 0;
                data_reg[bits] <= rx;
                if(bits == 7)
                begin
                 data_sgn <= 1;
                end
                else
                bits <= bits + 1;
                end
                else
                no_ticks <= no_ticks + 1;
                end
        stop : begin
                if(no_ticks == 15)
                begin
                if(rx)
                begin
                stop_sgn <= 1;
                end
                else
                stop_sgn <= 0;
                no_ticks <= 0;
                end
                else
                no_ticks <= no_ticks + 1;
                end
        default : no_ticks <= 0;
endcase
end    
end

       
assign dout = data_reg;    

endmodule
