`timescale 1ns/1ps

module fifo_sync_tb;

    parameter fifo_depth = 8;
    parameter data_width = 16;

    reg clk;
    reg rst_n;
    reg cs;
    reg rd_en;
    reg wr_en;
    reg [data_width-1:0] d_in;

    wire [data_width-1:0] d_out;
    wire empty;
    wire full;

    reg all_pass;
    reg test_pass;


    // DUT
    fifo_sync #(
        .fifo_depth(fifo_depth),
        .data_width(data_width)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .cs(cs),
        .rd_en(rd_en),
        .wr_en(wr_en),
        .d_in(d_in),
        .d_out(d_out),
        .empty(empty),
        .full(full)
    );
  // VCD waveform generation
    initial begin
        $dumpfile("fifo_sync.vcd");
        $dumpvars(0, fifo_sync_tb);
    end


    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end


    // Test sequence
    initial begin

        all_pass = 1'b1;
        test_pass = 1'b1;

        rst_n = 0;
        cs    = 0;
        rd_en = 0;
        wr_en = 0;
        d_in  = 0;


        // TEST 1: RESET

        #12;

        rst_n = 1;
        cs = 1;

        #10;

        if (empty == 1'b1 && full == 1'b0)
            $display("TEST 1: Reset - PASS");
        else begin
            $display("TEST 1: Reset - FAIL");
            all_pass = 1'b0;
        end


        // TEST 2: WRITE ONE VALUE

        wr_en = 1;
        d_in = 16'h0010;

        #10;

        wr_en = 0;

        if (empty == 1'b0)
            $display("TEST 2: Write one value - PASS");
        else begin
            $display("TEST 2: Write one value - FAIL");
            all_pass = 1'b0;
        end


        // TEST 3: READ ONE VALUE

        rd_en = 1;

        #10;

        rd_en = 0;

        if (d_out == 16'h0010 && empty == 1'b1)
            $display("TEST 3: Read one value - PASS");
        else begin
            $display("TEST 3: Read one value - FAIL");
            all_pass = 1'b0;
        end


        // TEST 4: WRITE MULTIPLE VALUES

        wr_en = 1;

        d_in = 16'h0001;
        #10;

        d_in = 16'h0002;
        #10;

        d_in = 16'h0003;
        #10;

        d_in = 16'h0004;
        #10;

        wr_en = 0;

        if (empty == 1'b0)
            $display("TEST 4: Multiple writes - PASS");
        else begin
            $display("TEST 4: Multiple writes - FAIL");
            all_pass = 1'b0;
        end


        // TEST 5: FIFO ORDER

        test_pass = 1'b1;

        rd_en = 1;

        #10;
        if (d_out != 16'h0001)
            test_pass = 1'b0;

        #10;
        if (d_out != 16'h0002)
            test_pass = 1'b0;

        #10;
        if (d_out != 16'h0003)
            test_pass = 1'b0;

        #10;
        if (d_out != 16'h0004)
            test_pass = 1'b0;

        rd_en = 0;

        if (test_pass)
            $display("TEST 5: FIFO order - PASS");
        else begin
            $display("TEST 5: FIFO order - FAIL");
            all_pass = 1'b0;
        end


        // TEST 6: FILL FIFO

        wr_en = 1;

        d_in = 16'h0001;
        #10;

        d_in = 16'h0002;
        #10;

        d_in = 16'h0003;
        #10;

        d_in = 16'h0004;
        #10;

        d_in = 16'h0005;
        #10;

        d_in = 16'h0006;
        #10;

        d_in = 16'h0007;
        #10;

        d_in = 16'h0008;
        #10;

        wr_en = 0;

        if (full == 1'b1 && empty == 1'b0)
            $display("TEST 6: Fill FIFO - PASS");
        else begin
            $display("TEST 6: Fill FIFO - FAIL");
            all_pass = 1'b0;
        end


        // TEST 7: WRITE WHEN FULL

        wr_en = 1;
        d_in = 16'h1234;

        #10;

        wr_en = 0;

        if (full == 1'b1)
            $display("TEST 7: Write when full - PASS");
        else begin
            $display("TEST 7: Write when full - FAIL");
            all_pass = 1'b0;
        end


        // TEST 8: READ FROM FULL FIFO

        rd_en = 1;

        #10;

        if (d_out == 16'h0001 && full == 1'b0)
            $display("TEST 8: Read from full FIFO - PASS");
        else begin
            $display("TEST 8: Read from full FIFO - FAIL");
            all_pass = 1'b0;
        end

        rd_en = 0;


        // TEST 9: READ UNTIL EMPTY

        test_pass = 1'b1;

        rd_en = 1;

        #10;
        if (d_out != 16'h0002)
            test_pass = 1'b0;

        #10;
        if (d_out != 16'h0003)
            test_pass = 1'b0;

        #10;
        if (d_out != 16'h0004)
            test_pass = 1'b0;

        #10;
        if (d_out != 16'h0005)
            test_pass = 1'b0;

        #10;
        if (d_out != 16'h0006)
            test_pass = 1'b0;

        #10;
        if (d_out != 16'h0007)
            test_pass = 1'b0;

        #10;
        if (d_out != 16'h0008)
            test_pass = 1'b0;

        rd_en = 0;

        if (empty != 1'b1)
            test_pass = 1'b0;

        if (test_pass)
            $display("TEST 9: Read until empty - PASS");
        else begin
            $display("TEST 9: Read until empty - FAIL");
            all_pass = 1'b0;
        end


        // TEST 10: READ WHEN EMPTY

        rd_en = 1;

        #10;

        rd_en = 0;

        if (empty == 1'b1)
            $display("TEST 10: Read when empty - PASS");
        else begin
            $display("TEST 10: Read when empty - FAIL");
            all_pass = 1'b0;
        end


        // TEST 11: SIMULTANEOUS READ + WRITE

        wr_en = 1;
        d_in = 16'h0010;

        #10;

        wr_en = 0;

        #10;

        wr_en = 1;
        rd_en = 1;
        d_in = 16'h0020;

        #10;

        if (d_out == 16'h0010)
            $display("TEST 11: Simultaneous read/write - PASS");
        else begin
            $display("TEST 11: Simultaneous read/write - FAIL");
            all_pass = 1'b0;
        end

        wr_en = 0;
        rd_en = 0;


        // TEST 12: RESET WHILE FIFO HAS DATA

        wr_en = 1;
        d_in = 16'h1234;

        #10;

        wr_en = 0;

        rst_n = 0;

        #10;

        rst_n = 1;

        #10;

        if (empty == 1'b1 && full == 1'b0)
            $display("TEST 12: Reset with data - PASS");
        else begin
            $display("TEST 12: Reset with data - FAIL");
            all_pass = 1'b0;
        end


        // FINAL RESULT

        #10;

        if (all_pass == 1'b1)
            $display("ALL TESTS PASSED");
        else
            $display("SOME TESTS FAILED");

        $finish;

    end

endmodule