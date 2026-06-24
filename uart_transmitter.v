`timescale 1ns / 1ps

module uart_tx
(
    input wire clk,
    input wire reset,
    input wire sample_tick,
    input wire [7:0] din,
    input wire tx_start,
    output reg tx_done,
    output reg tx  
);

    parameter [1:0] idle  = 2'b00,
                    start = 2'b01,
                    data  = 2'b10,
                    stop  = 2'b11;

    reg [1:0] current, next; 
    reg [2:0] bits;     
    reg [3:0] no_ticks;  
    reg [7:0] data_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current  <= idle;
            data_reg <= 8'b0;
        end else begin
            if (current == idle && tx_start) begin
                data_reg <= din;
                current  <= start; 
            end else if (sample_tick) begin
                current  <= next;
            end
        end
    end

always @(*) begin
next = current;
case (current)
idle: begin
    if (tx_start)
        next = start;
    else
        next = idle;
end

start: begin
    if (no_ticks == 15)
        next = data;
    else
        next = start;
end      
 
data: begin
    if (no_ticks == 15 && bits == 7)
        next = stop;
    else
        next = data;
end

stop: begin
    if (no_ticks == 15)
        next = idle;
    else
        next = stop;
end

default: next = idle;
endcase
end       
  
always @(posedge clk or posedge reset) begin
if (reset) begin
bits     <= 0;
no_ticks <= 0;
tx_done  <= 0;
tx       <= 1; 
end
else  
begin
case (current)
idle : begin
        tx       <= 1;
        tx_done  <= 0;
        bits     <= 0;
        no_ticks <= 0;
      end

start : begin
        tx <= 0;
        if (sample_tick) begin
        if (no_ticks == 15)
        no_ticks <= 0;
        else
        no_ticks <= no_ticks + 1;
        end
       end

data : begin
    tx <= data_reg[bits];
    if (sample_tick) begin
    if (no_ticks == 15) begin
    no_ticks <= 0;
    if (bits == 7)
    bits <= 0;
    else
    bits <= bits + 1;
    end else begin
    no_ticks <= no_ticks + 1;
    end
    end
    end

stop : begin
    tx <= 1; 
    if (sample_tick) begin
    if (no_ticks == 15) begin
    no_ticks <= 0;
    tx_done  <= 1; 
    end
    else 
    begin
    no_ticks <= no_ticks + 1;
    end
    end
    end

default: tx <= 1;
endcase
end
    end
    
endmodule


