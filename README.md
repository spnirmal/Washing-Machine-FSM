# Verilog-Based Washing Machine Controller (FSM)

## Overview
This project implements a washing machine controller using a finite state machine (FSM) in Verilog. The design simulates the sequential operation of a washing machine, including washing, rinsing, and spinning cycles. The simulation is visualized using GTKWave.

## Files
- **washingmachine.v** - Verilog module for the washing machine FSM.
- **washingmachine_tb.v** - Testbench for simulating the washing machine.
- **washingmachine_tb.vcd** - Generated waveform file for GTKWave visualization.

## Features
- Implements an FSM with different states for washing, rinsing, and spinning.
- Simulated in Icarus Verilog (iverilog) and visualized using GTKWave.
- Uses sequential logic to transition between states based on inputs.

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



