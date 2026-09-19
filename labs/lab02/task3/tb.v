// tb_comp2.v
module tb_comp2;

  reg  [1:0] A, B;
  wire GT, LT, EQ;
  integer i, j;
  integer errors = 0;

  comp2 DUT (.A(A), .B(B), .GT(GT), .LT(LT), .EQ(EQ));

  initial begin
    for (i = 0; i < 4; i = i + 1) begin
      for (j = 0; j < 4; j = j + 1) begin
        A = i; B = j;
        #1;

        if ((GT + LT + EQ) != 1) begin
          $display("FAIL: A=%0d B=%0d -> GT=%b LT=%b EQ=%b (expected exactly one high)",
                    A, B, GT, LT, EQ);
          errors = errors + 1;
        end

        if (GT !== (A > B)) $display("  -> GT wrong: expected %b, got %b", (A > B), GT);
        if (LT !== (A < B)) $display("  -> LT wrong: expected %b, got %b", (A < B), LT);
        if (EQ !== (A == B)) $display("  -> EQ wrong: expected %b, got %b", (A == B), EQ);
      end
    end

    if (errors == 0)
      $display("ALL TESTS PASSED");
    else
      $display("%0d FAILURES", errors);

    $finish;
  end

endmodule
