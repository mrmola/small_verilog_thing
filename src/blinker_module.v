/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module blinker (
    output wire       blink_wire,   // Dedicated outputs
    input  wire[15:0]  currentCount,
    input  wire[15:0] mask
);
    
    reg[15:0] currentCountShifted;
    assign currentCountShifted = currentCount;
    assign blink_wire = (currentCount & mask) == 1;

endmodule
