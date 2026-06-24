`timescale 1ns / 1ps


module uart_interface
(
    input clk,
    input reset,

    input [7:0] cpu_din,
    input cpu_wr,
    input cpu_rd,

    output reg [7:0] cpu_dout,

    output [7:0] tx_fifo_din,
    output tx_fifo_wr,
    input tx_fifo_full,

    input [7:0] rx_fifo_dout,
    output rx_fifo_rd,
    input rx_fifo_empty
);

always@(posedge clk)begin
if(reset)
cpu_dout <= 0;
else
if(cpu_rd &&  !rx_fifo_empty)
cpu_dout <= rx_fifo_dout;
end

assign tx_fifo_din =  cpu_din;
assign tx_fifo_wr = cpu_wr && !tx_fifo_full;
assign rx_fifo_rd  =  !rx_fifo_empty && cpu_rd;

endmodule
