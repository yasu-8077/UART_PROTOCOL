module Baud_rate
(
input clk,
input reset,
output  sample_tick
);

parameter  M = 54; // M = 100000000/(9600 *16) baud rate 9600bps
reg [7:0] count;

always@(posedge clk or posedge reset)
begin
if(reset)
count <= 10'd0;
else if(count == M-1)
count <= 0;
else
count <= count + 1;
end

assign sample_tick = (count== M-1) ? 1 : 0 ;

endmodule
