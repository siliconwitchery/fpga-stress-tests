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

// Include the pseudorandom module
`include "pseudorandom_ff.sv"

module top (
    // Dummy output for the pseudorandom generator
    output logic D1,

    // Dummy outputs for the SPRAM
    output logic D2,
    output logic D3,
    output logic D4,
    output logic D5
);
    // Create a global oscillator net
    logic osc;

    // Configure internal HS oscillator as 48MHz
    SB_HFOSC #(
        .CLKHF_DIV("0b00")
    ) hf_osc (
        .CLKHFEN(1'b1), // enable
        .CLKHFPU(1'b1), // power up
        .CLKHF(osc)     // output to sysclk
    ) /* synthesis ROUTE_THROUGH_FABRIC=0 */ ;

    // Configure the PLL to drive the system at 115MHz
    logic clk;
    // assign clk = osc;
    SB_PLL40_CORE #(
        .FEEDBACK_PATH("SIMPLE"),
        .PLLOUT_SELECT("GENCLK"),
        .DIVR(4'b0010),
        .DIVF(7'b0110001),
        .DIVQ(3'b011),
        .FILTER_RANGE(3'b001)
    ) SB_PLL40_CORE_inst (
        .RESETB(1'b1),
        .BYPASS(1'b0),
        .PLLOUTCORE(clk),
        .REFERENCECLK(osc)
    );

    // Wires which will connect the RAM
    logic [15:0] dummy_address;
    logic [15:0] dummy_data;
    logic dummy;

    // Output the dummy signal to avoid optimization
    assign D1 = dummy;

    // Connect the random data generator and use up all the LUTs
    pseudorandom_ff #(
        .NUM_CELLS(5270)
    ) pseudorandom_ff (
        .*
    );

    // Connect all 4 RAM blocks
    SB_SPRAM256KA sp_ram_1 (
        .ADDRESS(dummy_address[13:0]),
        .DATAIN(dummy_data),
        .DATAOUT(D2),
        .WREN(dummy),
        .CHIPSELECT(1),
        .CLOCK(clk)
    );

    SB_SPRAM256KA sp_ram_2 (
        .ADDRESS(dummy_address[13:0]),
        .DATAIN(dummy_data),
        .DATAOUT(D3),
        .WREN(dummy),
        .CHIPSELECT(1),
        .CLOCK(clk)
    );

    SB_SPRAM256KA sp_ram_3 (
        .ADDRESS(dummy_address[13:0]),
        .DATAIN(dummy_data),
        .DATAOUT(D4),
        .WREN(dummy),
        .CHIPSELECT(1),
        .CLOCK(clk)
    );

    SB_SPRAM256KA sp_ram_4 (
        .ADDRESS(dummy_address[13:0]),
        .DATAIN(dummy_data),
        .DATAOUT(D5),
        .WREN(dummy),
        .CHIPSELECT(1),
        .CLOCK(clk)
    );

endmodule