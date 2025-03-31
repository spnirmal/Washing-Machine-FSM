module washingmachine(
    input clk,reset,start,pause,door_open,power_cut,
    output reg[2:0] state,
    output reg motor,valve,drain_pump,spin_motor
);

parameter IDLE = 3'b000;
parameter FILL_WATER = 3'b001;
parameter WASH = 3'b010;
parameter DRAIN = 3'b011;
parameter RINSE = 3'b100;
parameter SPIN = 3'b101;
parameter DONE = 3'b110;

reg[2:0] next_state;
reg[31:0] timer;

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

always @(*) begin
    case(state)
        IDLE: next_state = (start)?FILL_WATER:IDLE;
        FILL_WATER : next_state =(timer >= 5)?WASH:FILL_WATER;
        WASH : next_state=(timer >= 10)? DRAIN:WASH;
        DRAIN:      next_state = (timer >= 5) ? RINSE : DRAIN;
        RINSE:      next_state = (timer >= 7) ? SPIN : RINSE;
        SPIN:       next_state = (timer >= 8) ? DONE : SPIN;
        DONE:       next_state = IDLE;
        default:    next_state = IDLE; 
    endcase    
end

always @(posedge clk) begin
    if (state != next_state) 
        timer <= 0;
    else
        timer <= timer + 1;
end

always @(state) begin
    // Default off
    motor = 0;
    valve = 0;
    drain_pump = 0;
    spin_motor = 0;
    
    case (state)
        FILL_WATER: valve = 1;
        WASH: motor = 1;
        DRAIN: drain_pump = 1;
        RINSE:begin motor=1; valve = 1;
        end
        SPIN: spin_motor = 1;
        DONE: ; // No action needed
    endcase
end
endmodule