`timescale 1ns / 1ps

module uart_top
(
input clk,
input reset,
input rx,
input cpu_wr,
input cpu_rd,
input [7:0] cpu_in,
output [7:0] cpu_out,
output tx
); 
wire tick,rx_full,rx_empty,rx_fifo_wr,rx_fifo_rd,tx_fifo_wr,tx_fifo_rd,tx_empty,tx_full,tx_start;
wire [7:0] tx_fifo_out,tx_fifo_in,rx_fifo_out,rx_fifo_in,tx_data;
wire tx_done;



Baud_rate U1
(
 .clk(clk), 
 .reset(reset),
 .sample_tick(tick)
);

uart_recevier U2
(
 .clk(clk),
    .reset(reset),
    .sample_tick(tick),
    .rx(rx),
    .rx_done(rx_fifo_wr),
    .dout(rx_fifo_in)
);

fifo rx_fifo
(
    .clk(clk),
    .reset(reset),
    .write_data(rx_fifo_in),
    .wr(rx_fifo_wr),
    .read_enable(rx_fifo_rd),
    .full(rx_full),
    .empty(rx_empty),
    .read_data(rx_fifo_out)
);

uart_interface IC 
(
  .clk(clk),
  .reset(reset),
  .cpu_din(cpu_in),
  .cpu_wr(cpu_wr),
  .cpu_rd(cpu_rd),
  .cpu_dout(cpu_out),
  .tx_fifo_din(tx_fifo_in),
  .tx_fifo_wr(tx_fifo_wr),
  .tx_fifo_full(tx_full),
  .rx_fifo_dout(rx_fifo_out),
  .rx_fifo_rd(rx_fifo_rd),
  .rx_fifo_empty(rx_empty)
);




fifo tx_fifo
(
    .clk(clk),
    .reset(reset),
    .write_data(tx_fifo_in),
    .wr(tx_fifo_wr),
    .read_enable(tx_fifo_rd),
    .full(tx_full),
    .empty(tx_empty),
    .read_data(tx_fifo_out)
);

                                   
tx_controller U5                   
(                                  
    .clk(clk),                     
    .reset(reset),                 
    .tx_empty(tx_empty),           
    .tx_done(tx_done),             
    .tx_fifo_out(tx_fifo_out),     
    .tx_fifo_rd(tx_fifo_rd),       
    .tx_start(tx_start),           
    .tx_data(tx_data)              
);                                 
                                   
                                   
                                   
uart_tx U4
(
    .clk(clk),
    .reset(reset),
    .sample_tick(tick),
    .din(tx_data),
    .tx_start(tx_start),
    .tx_done(tx_done),
    .tx(tx)
);

endmodule
