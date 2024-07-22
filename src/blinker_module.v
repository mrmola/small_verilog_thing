/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module blinker (
    output wire       blink_wire,   // Dedicated outputs
    input  wire[15:0]  currentCount,
    input  wire[15:0] offset
);
    wire[15:0] currentCountShifted = currentCount + offset;
    assign blink_wire = currentCount[9] & currentCount[9];

    wire _unused = &{currentCount[15:9],currentCount[7:0],1'b0};
  

endmodule
