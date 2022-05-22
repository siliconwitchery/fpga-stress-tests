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

/*
 * The original implementation of this test can be found here:
 * https://github.com/stnolting/fpga_torture
 */

module pseudorandom_ff #(
    parameter NUM_CELLS = 60
) (
    // Input clock
    input logic clk,

    // Dummy output
    output logic dummy,

    // Dummy registers which can be used to drive busses
    output logic [15:0] dummy_address,
    output logic [15:0] dummy_data
);

// A toggle signal which drives the first element
logic toggle_gen = 0;

// Chain together a number of blocks
logic chain [NUM_CELLS - 1 : 0];

// Assign the dummy output to the last item in the chain
assign dummy = chain[0];

// // Assign dummy address and data to some wires of the chain
assign dummy_address[15:0] = {chain[15], chain[14], chain[13], chain[12], chain[11], chain[10], chain[9], chain[8], chain[7], chain[6], chain[5], chain[4], chain[3], chain[2], chain[1], chain[0]};
assign dummy_data[15:0] = {chain[31], chain[30], chain[29], chain[28], chain[27], chain[26], chain[25], chain[24], chain[23], chain[22], chain[21], chain[20], chain[19], chain[18], chain[17], chain[16]};

// Just for testing
initial begin
    // Use the existing dumpfile
    $dumpfile(".sim/pseudorandom_ff_tb.lxt");

    // Clear the array to start with
    for (integer i = 0; i < NUM_CELLS; i++) begin
        chain[i] = 0;
    end

    // Dump the full array
    for (integer i = 0; i < NUM_CELLS; i = i + 1) begin
        $dumpvars(0, chain[i]);
    end
end

// Run the chain
always_ff @( posedge clk ) begin
    
    // Toggle on every positive clock edge
    toggle_gen <= ~toggle_gen;

    // For all elements in the chain
    for (integer i = 0; i < NUM_CELLS; i++) begin
        
        case (i)

            0: chain[i] <= toggle_gen ^ chain[NUM_CELLS-1] ^ chain[NUM_CELLS-2];            
            
            1: chain[i] <= chain[0] ^ toggle_gen ^ chain[NUM_CELLS-1];
            
            2: chain[i] <= chain[1] ^ chain[0] ^ toggle_gen;

            default: chain[i] <= chain[i-1] ^ chain[i-2] ^ chain[i-3];

        endcase

    end

end
    
endmodule