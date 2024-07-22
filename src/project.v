/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none
`define IDLE           3'b000
`define SET_AWAITING   3'b001
`define OPENED         3'b010
`define ALARM          3'b011
`define INPUT_PASSWORD 3'b100
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
  reg [6:0] password;
  always @(negedge rst_n)
    currentState <= `IDLE;
  
  counter clock_counter(
    .currentCount({count}),
    .clk(clk),
    .rst_n(rst_n)
  );
  
  blinker blink(
    .currentCount({count}),
    .blink_wire(uo_out[0]),
    .offset({16'd100})
  );

  //STATE HANDLING

  //set_password button
  always @(negedge ui_in[0]):
    if (currentState == `OPENED) begin
      currentState <= `SET_AWAITING;
    end else if (currentState == `INPUT_PASSWORD) begin
      password <= ui_in[6:0];
      currentState <= `IDLE;
    end

  always @(negedge uio_in[0]):
    if (currentState == `IDLE) begin
      currentState <= `INPUT_PASSWORD;
    end else if (currentState == `INPUT_PASSWORD) begin
      //CHECK PASSWORD HERE
    end else if (currentState == `OPENED || currentState == `ALARM || currentState == `SET_AWAITING) begin
      currentState <= `IDLE;
    end
  

  assign uo_out[0] = currentState == `OPENED ? 1 : 0;
  

  // All output pins must be assigned. If not used, assign to 0.
  assign uo_out[7:1] = 0;
  assign uio_oe  = 8'b01111111;
  assign uio_out[0] = 8'b11111111;
  // List all unused inputs to prevent warnings
  wire _unused = &{ena, ui_in[7:0], uio_in[7:0], 1'b0};

endmodule
