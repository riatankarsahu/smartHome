`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// University: Silesian University of Technology 
// Engineer: Ritankar Sahu
// 
// Create Date: 04/19/2022 08:58:03 PM
// Design Name: SPI Communication Unit
// Module Name: SPI
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


module SPI #(parameter CLK_DIV = 2)(input clock, input reset, input miso, output mosi, output sck, input start, 
                                    input[7:0] data_in, output[7:0] data_out, output busy, output new_data);
localparam STATE_SIZE = 2;
localparam IDLE = 2'd0, WAIT_HALF = 2'd1, TRANSFER = 2'd2;
reg [STATE_SIZE - 1:0] state_d, state_q;
reg [7:0] data_d, data_q;
reg [CLK_DIV-1:0] sck_d, sck_q;
reg mosi_d, mosi_q;
reg [2:0] ctr_d, ctr_q;
reg new_data_d, new_data_q;
reg [7:0] data_out_d, data_out_q;

assign mosi = mosi_q;
assign sck = (~sck_q[CLK_DIV-1]) & (state_q == TRANSFER);
assign busy = state_q != IDLE;
assign data_out = data_out_q;
assign new_data = new_data_q;

    always @(*)
    begin
        sck_d = sck_q;
        data_d = data_q;
        mosi_d = mosi_q;
        ctr_d = ctr_q;
        new_data_d = 1'b0;
        data_out_d = data_out_q;
        state_d = state_q;
        
        case(state_q)
            IDLE: begin
                sck_d = 4'b0;              // reset clock counter
                ctr_d = 3'b0;              // reset bit counter
                if (start == 1'b1) begin   // if start command
                    data_d = data_in;        // copy data to send
                    state_d = WAIT_HALF;     // change state
                end
            end
        endcase
    end
endmodule
