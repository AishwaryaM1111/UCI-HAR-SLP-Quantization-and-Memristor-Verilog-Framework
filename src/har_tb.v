`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.11.2025 23:54:54
// Design Name: 
// Module Name: har_tb
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


module har_tb();

  parameter IMG_SIZE  = 95;
  parameter NUM_CLASSES = 6;
  parameter M = 15;
  parameter N = 15;

  reg clk, rst, V_valid, reset;
  reg signed [M:0] image [0:IMG_SIZE-1];
  reg signed [N:0] weights_flat [0:NUM_CLASSES*IMG_SIZE-1];
  reg signed [8:0] Vth = 8'sd10;  // Initialize Vth
  wire signed [31:0] scores [0:NUM_CLASSES-1];
  wire [3:0] predicted_class;

  integer file, i, j;

  har #(IMG_SIZE, NUM_CLASSES, M, N) uut (
    .clk(clk),
    .rst(rst),
    .V_valid(V_valid),
    .image(image),
    .weights_flat(weights_flat),
    .scores(scores),
    .predicted_class(predicted_class),
    .Vth(Vth),  // Connect Vth
    .reset(reset)  // Connect reset
  );

  always #5 clk = ~clk;

  initial begin
    clk = 0;
    rst = 0;
    V_valid = 0;
    reset = 0;  // Initialize reset

    for (i = 0; i < IMG_SIZE; i = i + 1) image[i] = 0;
    for (j = 0; j < NUM_CLASSES*IMG_SIZE; j = j + 1) weights_flat[j] = 0;

    file = $fopen("C:/Users/Admin/Desktop/New folder (4)/X_test_row418.txt", "r");
    if (file == 0) begin
      $display("ERROR: cannot open X_test_row418.txt");
      //$finish;
    end else begin
      $display("Successfully opened X_test_row418.txt");
      for (i = 0; i < IMG_SIZE; i = i + 1) begin
        if ($fscanf(file, "%d\n", image[i]) == 0) begin
          $display("Warning: Failed to read image[%d]", i);
          image[i] = 0;
        end
      end
      $fclose(file);
    end

    file = $fopen("C:/Users/Admin/Desktop/weights_HAR_fixed1.txt", "r");
    if (file == 0) begin
      $display("ERROR: cannot open weights weights_HAR_fixed1.txt");
      //$finish;
    end else begin
      $display("Successfully opened weights weights_HAR_fixed1.txt");
      for (j = 0; j < NUM_CLASSES; j = j + 1) begin
        for (i = 0; i < IMG_SIZE; i = i + 1) begin
          if ($fscanf(file, "%d", weights_flat[j*IMG_SIZE + i]) == 0) begin
            $display("Warning: Failed to read weights_flat[%d]", j*IMG_SIZE + i);
            weights_flat[j*IMG_SIZE + i] = 0;
          end
        end
      end
      $fclose(file);
    end
    
    #10 rst = 1;
    #10 reset = 1;  // Pulse reset
    #10 reset = 0;
    #10 V_valid = 1;
    
    #2000;
    
    $display("Scores:");
    for (j = 0; j < NUM_CLASSES; j = j + 1) begin
      $display("  Class %0d Score = %d", j, scores[j]);
    end
    $display("Predicted Class: %d", predicted_class);
    
    //$finish;
  end

  initial begin
    $monitor("Time=%0t clk=%b rst=%b V_valid=%b reset=%b scores[0]=%d", $time, clk, rst, V_valid, reset, scores[0]);
  end
endmodule
