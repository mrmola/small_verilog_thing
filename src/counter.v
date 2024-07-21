/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module counter (
    output reg[7:0]   currentCount, 
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);
  always @(posedge clk)
    currentCount[0] <= rst_n ? 0 : ~currentCount[0];
  always @(posedge currentCount[0])
    currentCount[1] <= ~currentCount[1];
  always @(posedge currentCount[1])
    currentCount[2] <= ~currentCount[2];
  always @(posedge currentCount[2])
    currentCount[3] <= ~currentCount[3];
  always @(posedge currentCount[3])
    currentCount[4] <= ~currentCount[4];
  always @(posedge currentCount[4])
    currentCount[5] <= ~currentCount[5];
  always @(posedge currentCount[4])
    currentCount[5] <= ~currentCount[5];
  always @(posedge currentCount[4])
    currentCount[5] <= ~currentCount[5];
  always @(posedge currentCount[5])
    currentCount[6] <= ~currentCount[6];
  always @(posedge currentCount[6])
    currentCount[7] <= ~currentCount[7];
  always @(negedge rst_n)
    currentCount <= 8'b00000000;

endmodule
