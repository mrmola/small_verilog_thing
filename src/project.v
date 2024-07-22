/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_mrmola (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);
  wire [15:0] count;
  reg [2:0] currentState;
  
  counter clock_counter(
    .currentCount({count}),
    .clk(clk),
    .rst_n(rst_n)
  );
  
  blinker blink(
    .currentCount({count}),
    .blink_wire(uo_out[0]),
    .offset({100})
  );

  





  // All output pins must be assigned. If not used, assign to 0.
  assign uo_out[7:1] = 0;
  assign uio_oe  = 8'b11111111;

  // List all unused inputs to prevent warnings
  wire _unused = &{ena, ui_in[7:0], uio_in[7:0], 1'b0};

endmodule
