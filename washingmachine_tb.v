`timescale 1ns/1ps
`include "washingmachine.v"

module washingmachine_tb;
    reg clk, reset, start, pause, door_open, power_cut;
    wire motor, valve, drain_pump, spin_motor;
    wire [2:0] state;

    washingmachine uut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .pause(pause),
        .door_open(door_open),
        .power_cut(power_cut),
        .state(state),
        .motor(motor),
        .valve(valve),
        .drain_pump(drain_pump),
        .spin_motor(spin_motor)
    );

    always #5 clk = ~clk;  // 10ns period (100MHz clock)

    initial begin
        $dumpfile("washingmachine_tb.vcd");
        $dumpvars(0, washingmachine_tb);

        clk = 0;
        reset = 1; #10;  // Reset system
        reset=0;
        // Start washing machine
        start = 1;

        // Wait for FILL_WATER (5 cycles)
        #50;
        if (state != uut.FILL_WATER) $display("ERROR: Expected FILL_WATER but got %b", state);

        // Wait for WASH (10 cycles)
        #100;
        if (state != uut.WASH) $display("ERROR: Expected WASH but got %b", state);

        // Wait for DRAIN (5 cycles)
        #50;
        if (state != uut.DRAIN) $display("ERROR: Expected DRAIN but got %b", state);

        // Wait for RINSE (7 cycles)
        #70;
        if (state != uut.RINSE) $display("ERROR: Expected RINSE but got %b", state);

        // Wait for SPIN (8 cycles)
        #80;
        if (state != uut.SPIN) $display("ERROR: Expected SPIN but got %b", state);

        // Wait for DONE
        #10;
        if (state != uut.DONE) $display("ERROR: Expected DONE but got %b", state);
        
        // End test
        $display("✅ Test completed successfully!");
        $finish;
    end

    initial begin
        $monitor("Time=%0t | State=%b | Motor=%b | Valve=%b | Drain=%b | Spin=%b",
                 $time, state, motor, valve, drain_pump, spin_motor);
    end

endmodule
