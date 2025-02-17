`timescale 1s / 1ms
module tb_traffic_signal_controller;

// Testbench signals
reg clk;            // Clock signal
reg reset;          // Reset signal
reg x;              // Input to control state transitions
wire [1:0] Hwy;     // Main Highway signal (2-bit output)
wire [1:0] Cnrty;   // Cross Road signal (2-bit output)

// Instantiate the Traffic Signal Controller
traffic_signal_controller uut (
    .clk(clk),
    .reset(reset),
    .x(x),
    .Hwy(Hwy),
    .Cnrty(Cnrty)
);

// Clock generation (50 MHz clock)
always begin
    clk = 0;
    #10 clk = 1; // Clock period: 20 time units (50 MHz clock)
    #10;
end

// Stimulus block
initial begin
    // Initialize signals
    reset = 0;
    x = 0;

    // Apply reset to start the simulation
    $display("Applying Reset...");
    reset = 1;  // Assert reset
    #20;
    reset = 0;  // De-assert reset
    #20;

    // Test sequence (x controls state transitions)
    $display("Starting test sequence...");
    
    // Test sequence 1: S0 -> S1 -> S2 -> S3 -> S4 -> S0
    x = 0;  // Initial state: S0 (Main Hwy Green, Cross Road Red)
    #20;
    $display("State: S0, Hwy: %b, Cnrty: %b", Hwy, Cnrty);
    
    // Transition to S1
    x = 1;  // Transition to S1 (Main Hwy Yellow, Cross Road Red)
    #20;
    $display("State: S1, Hwy: %b, Cnrty: %b", Hwy, Cnrty);
    
    // Transition to S2
    x = 0;  // Transition to S2 (Main Hwy Red, Cross Road Red)
    #20;
    $display("State: S2, Hwy: %b, Cnrty: %b", Hwy, Cnrty);
    
    // Transition to S3
    x = 0;  // Transition to S3 (Main Hwy Red, Cross Road Green)
    #20;
    $display("State: S3, Hwy: %b, Cnrty: %b", Hwy, Cnrty);
    
    // Stay in S3 (x = 1)
    x = 1;  // Stay in S3 (Main Hwy Red, Cross Road Green)
    #20;
    $display("State: S3 (stay), Hwy: %b, Cnrty: %b", Hwy, Cnrty);
    
    // Transition to S4
    x = 0;  // Transition to S4 (Main Hwy Red, Cross Road Yellow)
    #20;
    $display("State: S4, Hwy: %b, Cnrty: %b", Hwy, Cnrty);
    
    // Transition back to S0
    x = 0;  // Transition back to S0 (Main Hwy Green, Cross Road Red)
    #20;
    $display("State: S0, Hwy: %b, Cnrty: %b", Hwy, Cnrty);

    // End of simulation
    $finish;
end

endmodule


