module traffic_signal_controller(
    input wire clk,        // Clock signal
    input wire reset,      // Reset signal
    input wire x,          // Input to control state transitions
    output reg [1:0] Hwy,  // Main Highway signal (2-bit: 00=Red, 01=Yellow, 10=Green)
    output reg [1:0] Cnrty // Cross Road signal (2-bit: 00=Red, 01=Yellow, 10=Green)
);

// State definitions
parameter S0 = 3'b000; // State 0: Main Highway Green, Cross Road Red
parameter S1 = 3'b001; // State 1: Main Highway Yellow, Cross Road Red
parameter S2 = 3'b010; // State 2: Main Highway Red, Cross Road Red
parameter S3 = 3'b011; // State 3: Main Highway Red, Cross Road Green
parameter S4 = 3'b100; // State 4: Main Highway Red, Cross Road Yellow

// Current state and next state variables
reg [2:0] state, next_state;

// State transition logic (combinational)
always @(*) begin
    case (state)
        S0: next_state = (x) ? S1 : S0;  // From S0 to S1 if x = 1
        S1: next_state = S2;              // From S1 to S2
        S2: next_state = S3;              // From S2 to S3
        S3: next_state = (x) ? S3 : S4;  // Stay in S3 if x = 1, else move to S4
        S4: next_state = S0;              // From S4 to S0
        default: next_state = S0;         // Default state
    endcase
end

// Output signal generation (based on state)
always @(*) begin
    case (state)
        S0: begin
            Hwy = 2'b10;    // Main Highway Green
            Cnrty = 2'b00;  // Cross Road Red
        end
        S1: begin
            Hwy = 2'b01;    // Main Highway Yellow
            Cnrty = 2'b00;  // Cross Road Red
        end
        S2: begin
            Hwy = 2'b00;    // Main Highway Red
            Cnrty = 2'b00;  // Cross Road Red
        end
        S3: begin
            Hwy = 2'b00;    // Main Highway Red
            Cnrty = 2'b10;  // Cross Road Green
        end
        S4: begin
            Hwy = 2'b00;    // Main Highway Red
            Cnrty = 2'b01;  // Cross Road Yellow
        end
        default: begin
            Hwy = 2'b00;    // Default: Main Highway Red
            Cnrty = 2'b00;  // Default: Cross Road Red
        end
    endcase
end

// State update logic (sequential)
always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= S0;  // Reset to initial state (S0)
    end else begin
        state <= next_state;  // Update state
    end
end

endmodule


