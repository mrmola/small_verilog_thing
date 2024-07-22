/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module blinker (
    output wire       blink_wire,   // Dedicated outputs
    input  wire[15:0]  currentCount,
    input  wire[15:0] mask          //MAKE THIS A POWER OF TWO OR YOU WILL BE VERY SAD 
);
    
    reg[15:0] currentCountShifted;
    assign currentCountShifted = currentCount;
    assign blink_wire = (currentCount & mask) == mask ? 1 : 0;

endmodule
