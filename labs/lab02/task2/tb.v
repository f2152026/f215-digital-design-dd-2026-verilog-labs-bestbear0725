// tb.v
// Starter testbench template -- YOU complete this file.

// tb.v
// Testbench for mux_beh

module tb;

  // Inputs to DUT
  reg t_i0;
  reg t_i1;
  reg t_s;

  // Output from DUT
  wire t_y;

  // Instantiate DUT
  mux_beh DUT (
    .I0(t_i0),
    .I1(t_i1),
    .S(t_s),
    .Y(t_y)
  );

  // Waveform dump configuration (DO NOT CHANGE)
  string vcd_file;

  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, DUT);
    end
  end

  // Apply different input combinations
  initial begin
    t_i0 = 0; t_i1 = 0; t_s = 0;
    #10;

    t_i0 = 0; t_i1 = 1; t_s = 0;
    #10;

    t_i0 = 0; t_i1 = 1; t_s = 1;
    #10;

    t_i0 = 1; t_i1 = 0; t_s = 0;
    #10;

    t_i0 = 1; t_i1 = 0; t_s = 1;
    #10;

    t_i0 = 1; t_i1 = 1; t_s = 0;
    #10;

    t_i0 = 1; t_i1 = 1; t_s = 1;
    #10;

    $finish;
  end

  initial
    $monitor($time, " I0=%b I1=%b S=%b | Y=%b",
             t_i0, t_i1, t_s, t_y);

endmodule

  // TODO: declare the inputs and outputs

  // TODO: instantiate DUT here

  // Waveform dump configuration (DO NOT CHANGE)
  
