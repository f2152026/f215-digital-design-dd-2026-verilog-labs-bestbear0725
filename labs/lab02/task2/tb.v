// tb.v
// Self-checking testbench for lut.v.
// Instantiates the LUT with a parameter override different from the
// module's own defaults, sweeps every valid address, and checks dout
// against the i*i value the module is supposed to hold at each address.

`timescale 1ns/1ps
module tb;

  // Address wide enough for the largest DEPTH we test (DEPTH=8 -> 3 bits).
  reg  [2:0] t_sel;
  wire [7:0] t_dout;

  integer errors;
  integer i;
  integer expected;

  lut #(.WIDTH(8), .DEPTH(8)) U1 (
    .sel  (t_sel),
    .dout (t_dout)
  );

  initial begin
    errors = 0;

    for (i = 0; i < 8; i = i + 1) begin
      t_sel = i[2:0];
      #1;
      expected = i * i;
      if (t_dout !== expected[7:0]) begin
        errors = errors + 1;
        $display("FAIL: sel=%0d -> dout=%0d (%b), expected=%0d (%b)",
                  i, t_dout, t_dout, expected, expected[7:0]);
      end
    end

    if (errors == 0)
      $display("ALL TESTS PASSED (DEPTH=8, WIDTH=8, 8/8 addresses correct)");
    else
      $display("TESTS FAILED: %0d error(s) found", errors);

    $finish;
  end

endmodule
