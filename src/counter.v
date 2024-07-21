/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module counter (
    output reg[15:0]   currentCount, 
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  always @(posedge clk)
    currentCount <= rst_n ? currentCount + 1 : 0;
  
endmodule
