# Washing Machine Finite State Machine (FSM) - Documentation

## Introduction
This project implements a washing machine controller using a Finite State Machine (FSM) in Verilog. The FSM governs the operation of the washing machine, managing different states like filling water, washing, rinsing, and spinning. The system is tested and visualized using GTKWave.

## Mealy vs. Moore Machines
A **Mealy Machine** produces outputs based on both the current state and inputs, whereas a **Moore Machine** generates outputs solely based on the current state. This washing machine controller follows the **Moore Machine** model, as its outputs (motor, valve, drain pump, spin motor) depend only on the current state and not on immediate input changes.

## FSM States
The FSM consists of seven states, each represented by a unique 3-bit binary value:

- **IDLE (000):** Waiting for the start signal.
- **FILL_WATER (001):** Water fills the drum before washing starts.
- **WASH (010):** The washing cycle begins.
- **DRAIN (011):** Water is drained after washing.
- **RINSE (100):** Clothes are rinsed with fresh water.
- **SPIN (101):** Water is removed by spinning the drum.
- **DONE (110):** Washing cycle completes and resets to idle.

## FSM State Diagram
The state diagram of the FSM is provided in the file **state_diagram.svg**.

## Verilog Implementation
The washing machine FSM is implemented in `washingmachine.v`. Below is a breakdown of the important sections of the code:

### State Transition Logic
```verilog
always @(posedge clk or posedge reset) begin
  if(reset) begin
    state <= IDLE;
    timer <= 0;
  end
  else if(power_cut) begin
    state <= state;
  end 
  else if(door_open) begin
    state <= IDLE;
  end
  else if(pause) begin
    state <= state;
  end
  else begin
    state <= next_state;
  end
end
```
This block ensures:
- The FSM resets to `IDLE` when `reset` is activated.
- The system remains in the current state if `power_cut` or `pause` is triggered.
- If `door_open` is detected, the machine returns to `IDLE`.
- Otherwise, the FSM transitions to the `next_state`.

![State Transition Logic Screenshot](![image](https://github.com/user-attachments/assets/15b394b5-2886-4dcf-9e2b-50e19b5c5e7f)
)

### Next State Logic
```verilog
always @(*) begin
    case(state)
        IDLE: next_state = (start)?FILL_WATER:IDLE;
        FILL_WATER: next_state = (timer >= 5) ? WASH : FILL_WATER;
        WASH: next_state = (timer >= 10) ? DRAIN : WASH;
        DRAIN: next_state = (timer >= 5) ? RINSE : DRAIN;
        RINSE: next_state = (timer >= 7) ? SPIN : RINSE;
        SPIN: next_state = (timer >= 8) ? DONE : SPIN;
        DONE: next_state = IDLE;
        default: next_state = IDLE; 
    endcase    
end
```
This ensures:
- The machine progresses through its cycle based on a `timer`.
- The `timer` thresholds define how long each phase lasts.
- The `DONE` state transitions back to `IDLE`, ready for the next cycle.

### Output Control Logic
```verilog
always @(state) begin
    motor = 0;
    valve = 0;
    drain_pump = 0;
    spin_motor = 0;
    
    case (state)
        FILL_WATER: valve = 1;
        WASH: motor = 1;
        DRAIN: drain_pump = 1;
        RINSE: begin motor = 1; valve = 1; end
        SPIN: spin_motor = 1;
        DONE: ; // No action needed
    endcase
end
```
This ensures:
- **Valve opens in `FILL_WATER` state.**
- **Motor operates in `WASH` and `RINSE` states.**
- **Drain pump activates in `DRAIN` state.**
- **Spin motor activates in `SPIN` state.**

  

## Testbench (`washingmachine_tb.v`)
A testbench is used to verify the FSM behavior. Below are key parts of the testbench:

### Clock and Reset
```verilog
always #5 clk = ~clk;  // 10ns period (100MHz clock)

initial begin
    $dumpfile("washingmachine_tb.vcd");
    $dumpvars(0, washingmachine_tb);

    clk = 0;
    reset = 1; #10;  // Reset system
    reset = 0;
```
This initializes the clock signal and generates a waveform output for GTKWave.

### Test Scenarios
```verilog
    start = 1;

    #50;
    if (state != uut.FILL_WATER) $display("ERROR: Expected FILL_WATER but got %b", state);

    #100;
    if (state != uut.WASH) $display("ERROR: Expected WASH but got %b", state);

    #50;
    if (state != uut.DRAIN) $display("ERROR: Expected DRAIN but got %b", state);
```
This checks if the FSM correctly transitions through the states with expected delays.

### Simulation Output
```verilog
    $monitor("Time=%0t | State=%b | Motor=%b | Valve=%b | Drain=%b | Spin=%b",
             $time, state, motor, valve, drain_pump, spin_motor);
    
    $finish;
end
```
This monitors the FSM state and output signals in real-time.

### Explaining the operation using waveforms generated from GTKWave
![State Transition gtkwave Screenshot](![image](https://github.com/user-attachments/assets/b8079eda-ca13-4af0-b29e-1d6da376f7e9)
)

#### Understanding the Signals

-clk (Clock): This is the master clock signal. The transitions (rising edges) of the clock signal trigger state changes in the FSM.
-state[2:0]: This represents the current state of the washing machine FSM. It's a 3-bit value, meaning it can represent 2^3 = 8 different states (000 to 111).
-motor: Controls the washing motor.
-drain_pump: Controls the drain pump.
-spin_motor: Controls the spin motor.
-valve: Controls the water inlet valve.
-timer[31:0]: A 32-bit timer, likely used to control the duration of each state.

#### Analyzing the Waveform

Let's break down the waveform's behavior at specific time points:

**0 ns:**

state[2:0] = 000 (Let's assume this is the initial state).
valve is low.
motor, drain_pump, and spin_motor are low.
timer starts counting up.

**15 ns:**

This is the first marker.
state[2:0] is still 001.
valve is high.
motor, drain_pump, and spin_motor are still low.
The timer has incremented.

**75 ns:**

state[2:0] is still 010.
motor is high.
valve, drain_pump, and spin_motor are low.
The timer continues to increment.

**185 ns:**

This is where a significant change occurs.
state[2:0] transitions to 011 .
motor goes low.
drain_pump goes high.
valve and spin_motor remain low.
The timer continues counting from its current value.

**245 ns:**

state[2:0] transitions to 100.
drain_pump goes low.
motor and valve goes high.
spin_motor remains low.

**325 ns:**

state[2:0] transitions to 101.
spin_motor goes high.
motor and drain_pump are low.
valve goes low.

## Running the Simulation
1. Compile the files:
   ```sh
   iverilog -o washingmachine_tb washingmachine.v washingmachine_tb.v
   ```
2. Run the testbench:
   ```sh
   vvp washingmachine_tb
   ```
3. Open GTKWave to view the state transitions:
   ```sh
   gtkwave washingmachine_tb.vcd
   ```

## Future Enhancements
- **LCD Display Integration**: Simulate an LCD showing the washing progress.
- **Configurable Timing**: Allow users to set custom wash/rinse durations.
- **Power Failure Recovery**: Resume from the last state after a power cut.
- **Error Handling**: Add fault detection for abnormal conditions.

---
This documentation provides a comprehensive understanding of the FSM-based washing machine project, from theory to implementation. Further improvements and optimizations can be explored for a more robust design.

