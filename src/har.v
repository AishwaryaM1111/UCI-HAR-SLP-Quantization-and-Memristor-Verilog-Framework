`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.11.2025 23:51:48
// Design Name: 
// Module Name: har
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module har #(
  parameter IMG_SIZE    = 95,
  parameter NUM_CLASSES = 6,
  parameter M = 15,
  parameter N = 15
)(
  input wire clk,
  input wire rst,
  input wire V_valid,
  input wire signed [M:0] image [0:IMG_SIZE-1],
  input wire signed [N:0] weights_flat [0:NUM_CLASSES*IMG_SIZE-1],
  input wire signed [8:0] Vth,  // Added
  input wire reset,  // Added
  output reg signed [31:0] scores [0:NUM_CLASSES-1],
  output reg [3:0] predicted_class
);

  integer i, j;
  wire signed [N:0] G [0:NUM_CLASSES-1][0:IMG_SIZE-1];
  wire signed [M+N+4:0] I [0:NUM_CLASSES-1][0:IMG_SIZE-1];

  genvar gi, gj;
  generate
    for (gj = 0; gj < NUM_CLASSES; gj = gj + 1) begin: CLASS_LOOP
      for (gi = 0; gi < IMG_SIZE; gi = gi + 1) begin: PIXEL_LOOP
        mem #(M, N) mem_inst (
          .clk(clk),
          .rst(rst),
          .Vin(image[gi]),
          .Vth(Vth),  // Use input Vth
          .V_valid(V_valid),
          .c(3'b1),
          .Ginit(weights_flat[gj*IMG_SIZE + gi]),
          .G(G[gj][gi]),
          .I(I[gj][gi]),
          .reset(reset)  // Pass reset
        );
      end
    end
  endgenerate

  reg signed [31:0] sum;
  always @(posedge clk or negedge rst) begin
    if (!rst) begin
      for (j = 0; j < NUM_CLASSES; j = j + 1)
        scores[j] <= 0;
      predicted_class <= 0;
    end else if (V_valid) begin
      for (j = 0; j < NUM_CLASSES; j = j + 1) begin
        sum = 0;
        for (i = 0; i < IMG_SIZE; i = i + 1) begin
          sum = sum + I[j][i];
        end
        scores[j] <= sum;
      end
      begin
        reg signed [31:0] max_score;
        max_score = scores[0];
        predicted_class = 0;
        for (i = 1; i < NUM_CLASSES; i = i + 1) begin
          if (scores[i] > max_score) begin
            max_score = scores[i];
            predicted_class = i;
          end
        end
      end
    end
  end
endmodule
