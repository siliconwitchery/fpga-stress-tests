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
    // Four LEDs. Active low
    output logic [3:0] led
);
    // Create a global oscillator net
    logic osc;

// Internal oscillator
	OSC_CORE #(
		.HF_CLK_DIV("1")
	) hf_osc (
		.HFOUTEN(1'b1),
		.HFCLKOUT(osc)
	);

    // TODO Configure the PLL to drive the system at xxxMHz
    logic clk;
    assign clk = osc;

    // Wires which will connect the RAM
    logic [15:0] dummy_address;
    logic [15:0] dummy_data;
    logic dummy;

    // Output the dummy signal to avoid optimization
    assign led[0] = dummy;

    // Connect the random data generator and use up all the LUTs
    pseudorandom_ff #(
        .NUM_CELLS(13820)
    ) pseudorandom_ff (
        .*
    );

endmodule