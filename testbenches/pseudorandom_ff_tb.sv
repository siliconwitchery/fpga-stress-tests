/*
 * This file is part of the FPGA Stress Tests project: 
 * https://github.com/siliconwitchery/fpga-stress-tests
 *
 * ISC Licence
 *
 * Copyright (c) 2022 Raj Nakarja (Twitter @siliconwitch) of Silicon Witchery AB
 *
 * Permission to use, copy, modify, and/or distribute this software for any 
 * purpose with or without fee is hereby granted, provided that the above 
 * copyright notice and this permission notice appear in all copies.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH 
 * REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY 
 * AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, 
 * INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM 
 * LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR 
 * OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR 
 * PERFORMANCE OF THIS SOFTWARE.
 */

// This gives us a 500MHz clock
`timescale 1ns / 1ns

// Include the pseudorandom module
`include "pseudorandom_ff.sv"

module pseudorandom_ff_tb;
    
    // This is where the simulation output file is saved
    initial begin
        $dumpfile(".sim/pseudorandom_ff_tb.lxt");
        $dumpvars(0, pseudorandom_ff_tb);  
    end

    // Local clock, reset and dummy signals
    logic clk = 1;
    logic dummy;
    logic [15:0] dummy_address;
    logic [15:0] dummy_data;

    // Generate a clock signal
    initial begin
        forever #1 clk <= ~clk;
    end

    // Connect the pseudorandom module with 32 LUTs
    pseudorandom_ff #(
        .NUM_CELLS(60)
    ) pseudorandom_ff (
        .*
    );

    // Run the simulation
    initial begin
        # 10000
        $finish;
    end

endmodule