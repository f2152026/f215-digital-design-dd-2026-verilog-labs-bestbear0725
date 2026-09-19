// and_beh_intra.v
// Procedural block with an intra-assignment delay.
// a & b is evaluated immediately when the block triggers (same
// instant a or b changes), exactly like the dataflow version; only
// the assignment to y is scheduled 5 units later. Correct, and
// matches and_df's behavior at the moment of each triggering event.
module and_beh_intra (
  input  a, b,
  output reg y
);
  always @(a or b)
    y = #5 (a & b);
endmodule
