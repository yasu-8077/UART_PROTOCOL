`timescale 1ns / 1ps

module tx_controller
(
    input clk,
    input reset,

    input tx_empty,
    input tx_done,

    input [7:0] tx_fifo_out,

    output reg tx_fifo_rd,
    output reg tx_start,

    output reg [7:0] tx_data
);

parameter IDLE      = 3'd0,
          READ_FIFO = 3'd1,
          LOAD_DATA = 3'd2,
          START_TX  = 3'd3,
          WAIT_DONE = 3'd4;

reg [2:0] state;

always @(posedge clk or posedge reset)
begin
    if(reset)
    begin
        state      <= IDLE;
        tx_fifo_rd <= 1'b0;
        tx_start   <= 1'b0;
        tx_data    <= 8'h00;
    end
    else
    begin
       
        tx_fifo_rd <= 1'b0;
        tx_start   <= 1'b0;

        case(state)

        IDLE:
        begin
            if(!tx_empty)
            begin
                tx_fifo_rd <= 1'b1;
                state <= READ_FIFO;
            end
        end
        READ_FIFO:
        begin
            state <= LOAD_DATA;
        end

        LOAD_DATA:
        begin
            tx_data <= tx_fifo_out;
            state <= START_TX;
        end

        START_TX:
        begin
            tx_start <= 1'b1;
            state <= WAIT_DONE;
        end

        WAIT_DONE:
        begin
            if(tx_done)
                state <= IDLE;
        end

        default:
        begin
            state <= IDLE;
        end

        endcase
    end
end

endmodule
