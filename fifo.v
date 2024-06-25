`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/25/2024 08:04:30 PM
// Design Name: 
// Module Name: fifo
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


module fifo(
	clk, rst, buf_in, buf_out, wr_en, rd_en, buf_empty, buf_full, fifo_counter
    );
input rst, clk, wr_en, rd_en;
input [7:0] buf_in;
output reg [7:0] buf_out;
output reg buf_empty, buf_full;
output reg [7:0] fifo_counter;

reg [5:0] rd_ptr, wr_ptr;
reg [7:0] buf_mem[63:0];

always @(fifo_counter) begin
	buf_empty = (fifo_counter==0);
	buf_full  = (fifo_counter==64);
end
 
always @(posedge clk) begin 
	 if (rst)
	 	fifo_counter <= 0;
	 else if( (wr_en && !buf_full) && (rd_en && !buf_empty))
	 	fifo_counter <= fifo_counter;
	 else if(wr_en && !buf_full)
	 	fifo_counter <= fifo_counter + 1;
	 else if (rd_en && !buf_empty)
	 	fifo_counter <= fifo_counter - 1;
	 else
	 	fifo_counter <= fifo_counter;
end

always @(posedge clk) begin
	if(rst)
		buf_out <= 0;
	else if(rd_en && !buf_empty)
		buf_out <= buf_mem[rd_ptr];
	else
		buf_out <= buf_out;
end

always @(posedge clk) begin
	if(wr_en && !buf_full)
		buf_mem[wr_ptr] <= buf_in;
	else
		buf_mem[wr_ptr] <= buf_mem[wr_ptr];
end

always @(posedge clk) begin 
	if(rst) begin
		rd_ptr <= 0;
		wr_ptr <= 0;
	end
	else begin
		if(wr_en && !buf_full)
			wr_ptr <= wr_ptr + 1;
		if(rd_en && !buf_empty)
			rd_ptr <= rd_ptr + 1;
	end
end
endmodule
