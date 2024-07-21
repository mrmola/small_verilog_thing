/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module blinker (
    output wire       blink_wire,   // Dedicated outputs
    input  wire[15:0]  currentCount, 
    input  wire       clk      // clock, disable to disable blinking (NO JANK HERE)
);
    assign blink_wire <= wire[8] & wire[8];
  

endmodule
