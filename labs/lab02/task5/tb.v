// tb.v
// Self-checking testbench for alu.v (1-bit opcode, 4-bit operands).
// op = 0: add (result = a + b)
// op = 1: sub (result = a + (~b + 1))   -- two's complement subtraction
//
// Assumed port list (update if alu.v's header differs):
//   module alu (
//     input  [3:0] a,
//     input  [3:0] b,
//     input        op,
//     output [3:0] result
//   );
//
// Strategy, per the assignment:
//  1. Fixed operand pair, toggle op both ways -- catches the
//     sensitivity-list bug (result failing to respond to an op change
//     with a and b held constant).
//  2. Changing operand pairs under each op -- catches the
//     blocking/non-blocking chain bug in the subtract path (b_inv ->
//     b_twos -> result all needing to see each other's freshly
//     computed values within the same evaluation).
//  Every check compares against a value computed independently in the
//  testbench (plain 4-bit wraparound arithmetic), not against the DUT's
//  own internals.

`timescale 1ns/1ps
module tb;

  reg  [3:0] a, b;
  reg        op;
  wire [3:0] result;

  integer errors;
  reg  [3:0] expected;

  alu dut (
    .a(a),
    .b(b),
    .op(op),
    .result(result)
  );

  // Compute the expected 4-bit result independently of the DUT.
  function [3:0] expected_result;
    input [3:0] a_in, b_in;
    input       op_in;
    begin
      if (op_in == 1'b0)
        expected_result = a_in + b_in;          // add, wraps mod 16
      else
        expected_result = a_in + (~b_in + 4'b1); // sub via two's complement, wraps mod 16
    end
  endfunction

  task check;
    input [3:0] a_in, b_in;
    input       op_in;
    begin
      a  = a_in;
      b  = b_in;
      op = op_in;
      #1;
      expected = expected_result(a_in, b_in, op_in);
      if (result !== expected) begin
        errors = errors + 1;
        $display("FAIL: a=%0d b=%0d op=%0d -> result=%0d (%b), expected=%0d (%b)",
                  a_in, b_in, op_in, result, result, expected, expected);
      end
    end
  endtask

  integer i, j;

  initial begin
    errors = 0;

    // --- Part 1: fixed operand pair, toggle op both ways ---
    // Catches: result not updating when only op changes (sensitivity-list bug).
    $display("-- Fixed operands, toggling op --");
    a = 4'd9; b = 4'd3;
    op = 0; #1;
    expected = expected_result(a, b, op);
    if (result !== expected) begin
      errors = errors + 1;
      $display("FAIL: a=%0d b=%0d op=%0d -> result=%0d, expected=%0d",
                a, b, op, result, expected);
    end

    op = 1; #1;   // ONLY op changes here -- a/b untouched
    expected = expected_result(a, b, op);
    if (result !== expected) begin
      errors = errors + 1;
      $display("FAIL (op-only change): a=%0d b=%0d op=%0d -> result=%0d, expected=%0d",
                a, b, op, result, expected);
    end

    op = 0; #1;   // switch back, again with a/b untouched
    expected = expected_result(a, b, op);
    if (result !== expected) begin
      errors = errors + 1;
      $display("FAIL (op-only change back): a=%0d b=%0d op=%0d -> result=%0d, expected=%0d",
                a, b, op, result, expected);
    end

    // --- Part 2: addition, changing operand pairs ---
    $display("-- Addition, varying operands --");
    for (i = 0; i < 16; i = i + 1) begin
      for (j = 0; j < 16; j = j + 4) begin // sample, not fully exhaustive on b
        check(i[3:0], j[3:0], 1'b0);
      end
    end

    // --- Part 3: subtraction, changing operand pairs ---
    // Catches: blocking/non-blocking chain bug (b_inv -> b_twos -> result).
    // Deliberately includes a/b flipping every iteration, so the DUT can't
    // coast on stale internal values from a previous evaluation.
    $display("-- Subtraction, varying operands --");
    for (i = 0; i < 16; i = i + 1) begin
      for (j = 0; j < 16; j = j + 4) begin
        check(i[3:0], j[3:0], 1'b1);
      end
    end

    // A few explicit, easy-to-hand-check subtraction cases up front,
    // since the assignment notes this bug should show on essentially
    // any subtraction test.
    $display("-- Explicit hand-checkable subtraction cases --");
    check(4'd5, 4'd3, 1'b1);   // 5-3=2
    check(4'd3, 4'd5, 1'b1);   // 3-5=-2 -> wraps to 14 (4'b1110)
    check(4'd0, 4'd1, 1'b1);   // 0-1=-1 -> wraps to 15
    check(4'd15, 4'd15, 1'b1); // 15-15=0
    check(4'd8, 4'd8, 1'b1);   // 8-8=0

    if (errors == 0)
      $display("ALL TESTS PASSED");
    else
      $display("TESTS FAILED: %0d error(s) found", errors);

    $finish;
  end

endmodule


