// and_df.v
// Pure dataflow, intra-assignment delay on a continuous assign.
// The RHS (a & b) is evaluated the instant a or b changes; only the
// act of driving y onto the net is delayed by 5 time units. Because
// continuous-assignment delays are INERTIAL, any pulse on the RHS
// narrower than the delay is filtered out entirely -- just like a
// real gate's propagation delay. Correct.
module and_df (
  input  a, b,
  output y
);
  assign #5 y = a & b;
endmodule