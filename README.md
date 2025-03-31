# Verilog-Based Washing Machine Controller (FSM)

## Overview
This project implements a washing machine controller using a finite state machine (FSM) in Verilog. The design simulates the sequential operation of a washing machine, including washing, rinsing, and spinning cycles. The simulation is visualized using GTKWave.

## Files
- **washingmachine.v** - Verilog module for the washing machine FSM.
- **washingmachine_tb.v** - Testbench for simulating the washing machine.
- **washingmachine_tb.vcd** - Generated waveform file for GTKWave visualization.
- **state_diagram.svg** - State diagram illustrating the FSM transitions.

## Features
- Implements an FSM with different states for washing, rinsing, and spinning.
- Simulated in Icarus Verilog (iverilog) and visualized using GTKWave.
- Uses sequential logic to transition between states based on inputs.
- Supports different washing modes based on external inputs.
- Outputs signals to indicate the current operation phase.

## FSM States
- **IDLE (3'b000)** - The machine is in a waiting state before starting.
- **FILL_WATER (3'b001)** - The drum fills with water before washing begins.
- **WASH (3'b010)** - The main washing process occurs.
- **DRAIN (3'b011)** - The drum empties before rinsing.
- **RINSE (3'b100)** - The clothes are rinsed with fresh water.
- **SPIN (3'b101)** - The drum spins to remove excess water.
- **DONE (3'b110)** - The washing process ends and waits for the next cycle.

## Simulation
1. Compile the Verilog files:
   ```sh
   iverilog -o washingmachine_tb washingmachine.v washingmachine_tb.v
   ```
2. Run the simulation:
   ```sh
   vvp washingmachine_tb
   ```
3. Open the waveform in GTKWave:
   ```sh
   gtkwave washingmachine_tb.vcd
   ```

## How to Use
- Modify the input conditions in `washingmachine_tb.v` to test different cycles.
- Analyze the waveform in GTKWave to verify correct state transitions.
- Adjust timing parameters in `washingmachine.v` for real-world approximation.

## Future Enhancements
- Add an LCD display simulation to show cycle progress.
- Implement power failure recovery to resume from the last state.
- Introduce a configurable delay between state transitions.

