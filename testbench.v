`timescale 1ns / 1ps

module uart_top_tb;

reg clk;
reg reset;
reg cpu_wr;
reg cpu_rd;
reg [7:0] cpu_in;
wire [7:0] cpu_out;
wire tx;
wire rx;

assign rx = tx;

uart_top DUT
(
    .clk(clk),
    .reset(reset),
    .rx(rx),
    .cpu_wr(cpu_wr),
    .cpu_rd(cpu_rd),
    .cpu_in(cpu_in),
    .cpu_out(cpu_out),
    .tx(tx)
);


initial
begin
    clk = 0;
    forever #5 clk = ~clk;
end
initial
begin
    reset  = 1;
    cpu_wr = 0;
    cpu_rd = 0;
    cpu_in = 8'h00;
    #100;
  reset = 0;
    @(posedge clk);
    cpu_in = 8'h55;
    cpu_wr = 1;
    @(posedge clk);
    cpu_wr = 0;
    #100;
    @(posedge clk);
    cpu_in = 8'hAA;
    cpu_wr = 1;
    @(posedge clk);
    cpu_wr = 0;
    #100;
    @(posedge clk);
    cpu_in = 8'hFF;
    cpu_wr = 1;
    @(posedge clk);
    cpu_wr = 0;
    #100;
    @(posedge clk);
    cpu_in = 8'h00;
    cpu_wr = 1;
    @(posedge clk);
    cpu_wr = 0;
    #300000;
    repeat(4)
    begin
        @(posedge clk);
        cpu_rd = 1;
        @(posedge clk);
        cpu_rd = 0;
        #100;
    end
    #1000;
    $finish;

end
endmodule
