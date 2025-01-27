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
  //reg [7:0] output_main;
  //reg [7:0] output_secondary;
  wire blink_wire;
  //assign uio_out = output_secondary;
  //assign uo_out  = output_main;

  
  counter clock_counter(
    .currentCount({count}),
    .clk(clk),
    .rst_n(rst_n)
  );
  
  blinker blink(
    .currentCount({count}),
    .blink_wire(blink_wire),
    .mask(16'b0000000100000000)
  );

  //STATE HANDLING
  always @(posedge clk)
    if(rst_n == 0) begin
      currentState <= `IDLE;
    end else if(uio_in[0] == 1) begin
      if (currentState == `OPENED) begin
        currentState <= `SET_AWAITING;
      end else if (currentState == `INPUT_PASSWORD) begin
        currentState <= `IDLE;
      end else if (currentState == `SET_AWAITING) begin
        currentState <= `IDLE;
        password <= ui_in[6:0];
      end
    end else if(ui_in[0] == 1) begin
      if (currentState == `IDLE) begin
        currentState <= `INPUT_PASSWORD;
      end else if (currentState == `INPUT_PASSWORD) begin
        if ( ui_in[7:1] == password ) begin
          currentState <= `OPENED;
        end else begin
          currentState <= `ALARM;
        end;
      end else if (currentState == `OPENED || currentState == `ALARM || currentState == `SET_AWAITING) begin
        currentState <= `IDLE;
      end
    end
  //check_password button (THE GOAT)
  
  //Handle all display logic
  /*always @(negedge clk)
    case (currentState)
      `IDLE: begin
        
      end
      `INPUT_PASSWORD: begin

      end
      `SET_AWAITING: begin

      end
      `OPENED: begin

      end 
      `ALARM: begin

      end
      `INPUT_PASSWORD: begin
        
      end
    endcase*/

  // All output pins must be assigned. If not used, assign to 0.
  assign uo_out[7:2] = 0;
  assign uo_out[0] = currentState == `OPENED ? 1 : 0;
  assign uo_out[1] = currentState == `ALARM  ? blink_wire : 0;
  assign uio_oe  = 8'b01111111;
  assign uio_out[2:0] = currentState;
  assign uio_out[7:3] = 5'b00000;
  // List all unused inputs to prevent warnings
  wire _unused = &{ena, ui_in[7:1], uio_in[7:1], 1'b0};

endmodule
