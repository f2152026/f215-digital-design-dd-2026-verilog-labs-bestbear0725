// and_beh_before.v
// Procedural block with the delay BEFORE the assignment.
// Each time a or b changes, a new process is spawned that waits 5
// units and THEN reads a and b -- using whatever their values are
// 5 units later, not their values at the moment of the trigger.
// With fast toggling (faster than 5 units), this reads stale/wrong
// operand values and can race with other pending processes writing y.
module and_beh_before (
  input  a, b,
  output reg y
);
  always @(a or b) begin
    #5;
    y = a & b;
  end
endmodule
