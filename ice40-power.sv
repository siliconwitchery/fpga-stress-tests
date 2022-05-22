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

module top (
    // Reset input on popout board
    input logic D4,
    
    // LED on S1 popout
    output logic D3
);

    // Assign the reset pin to a global net
    logic reset;
    assign reset = ~D4;

    // Create a global oscillator net
    logic osc;

    // Configure internal HS oscillator as 6MHz
    SB_HFOSC #(
        .CLKHF_DIV("0b11")
    ) hf_osc (
        .CLKHFEN(1'b1), // enable
        .CLKHFPU(1'b1), // power up
        .CLKHF(osc)     // output to sysclk
    ) /* synthesis ROUTE_THROUGH_FABRIC=0 */ ;

    // TODO configure the PLLs to full speed
    logic clk;
    assign clk = osc;

    // Toggle a lot og flip flops
    always_ff @(posedge clk) begin

        if (reset) begin
            counter <= counter + 1;
        end

        else begin
            counter <= 0;
        end

    end


endmodule