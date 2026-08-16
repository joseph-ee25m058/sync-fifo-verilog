module fifo_sync #(
    parameter fifo_depth = 8,
    parameter data_width = 16
)(
    input clk,
    input rst_n,
    input cs,
    input rd_en,
    input wr_en,
    input [data_width-1:0] d_in,
    output reg [data_width-1:0] d_out,
    output empty,
    output full
);

localparam pointer_width = $clog2(fifo_depth);

reg [data_width-1:0] fifo [fifo_depth-1:0];

reg [pointer_width:0] wr_ptr;
reg [pointer_width:0] rd_ptr;


// WRITE
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        wr_ptr <= 0;
    else if (cs && wr_en && !full) begin
        fifo[wr_ptr[pointer_width-1:0]] <= d_in;
        wr_ptr <= wr_ptr + 1'b1;
    end
end


// READ
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        rd_ptr <= 0;
    else if (cs && rd_en && !empty) begin
        d_out <= fifo[rd_ptr[pointer_width-1:0]];
        rd_ptr <= rd_ptr + 1'b1;
    end
end


// STATUS
assign empty = (wr_ptr == rd_ptr);

assign full = (wr_ptr == {
    ~rd_ptr[pointer_width],
    rd_ptr[pointer_width-1:0]
});

endmodule