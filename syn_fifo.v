`timescale 1ns / 1ps

module fifo
(
input clk,
input reset,
input [7:0] write_data,
input wr,
input read_enable,
output full,
output empty,
output reg [7:0] read_data
);

reg [7:0] mem [0:15];
reg [4:0] pointer;
reg [3:0] wr_pointer,rd_pointer;

assign full = (pointer==16);
assign empty = (pointer==0);

always @(posedge clk)
begin
if(reset) begin
read_data  <= 0;
pointer    <= 0;
wr_pointer <= 0;
rd_pointer <= 0;
end
else
begin
case ({wr && !full, read_enable && !empty})
2'b10:  begin
        mem[wr_pointer] <= write_data;
        wr_pointer <= wr_pointer + 1;
        pointer <= pointer + 1;
        end
2'b01:  begin
        read_data <= mem[rd_pointer];
        rd_pointer <= rd_pointer + 1;
        pointer <= pointer - 1;
        end
2'b11: begin
       mem[wr_pointer] <= write_data;
       wr_pointer <= wr_pointer + 1;
       read_data <= mem[rd_pointer];
       rd_pointer <= rd_pointer + 1;
       pointer <= pointer;
       end
default: ;
endcase
end
end

endmodule
