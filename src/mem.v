`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.11.2025 23:52:26
// Design Name: 
// Module Name: mem
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


module mem #(
  parameter M=15,
  parameter N=15,
  parameter N_EXP=1
  
)(
  input wire clk,
  input wire rst,
  input wire reset,
  input wire signed [M:0] Vin,
  input wire signed [8:0] Vth,
  input wire V_valid,
  input wire [2:0] c,
  input wire signed [N:0] Ginit,
  output reg signed [N:0] G,
  output reg signed [M+N+4:0] I
);

  wire signed [8:0] negVth = -Vth;
  wire signed [M:0] absVin = (Vin < 0) ? -Vin : Vin;
  
  reg signed [2*M:0] Pow_val;
  always @(*) begin
    case(N_EXP)
      2: Pow_val = absVin * absVin;
      3: Pow_val = absVin * absVin * absVin;
      4: Pow_val = (absVin * absVin) * (absVin * absVin);
      default: Pow_val = absVin;  // N_EXP=1 uses linear |Vin|
    endcase
  end
  
  reg signed [N+8:0] next_G_temp;
  //reg signed [N:0] next_G;
  
  always @(posedge clk or negedge rst) begin
    if (!rst) begin
      G <= Ginit;
      I <= 0;
    end else if (V_valid) begin
      if (reset) begin
        next_G_temp = Ginit;
      end else if (Vin >= Vth) begin
        next_G_temp = G + (c * Pow_val);
      end else if (Vin <= negVth) begin
        next_G_temp = G - (c * Pow_val);
      end else begin
        next_G_temp = G;
      end
      
      I <= Vin * next_G_temp;
    end
    //else begin
      //I <= I;  // ← HOLD OUTPUT, DON'T LET X PROPAGATE
    //end
  end
endmodule
