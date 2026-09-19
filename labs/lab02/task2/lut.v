// lut.v
// A small parameterized ROM (lookup table): DEPTH words, each WIDTH bits
// wide. dout continuously reflects mem[sel].

module lut #(
  parameter WIDTH = 8,
  parameter DEPTH = 4
) (
  input      [$clog2(DEPTH)-1:0] sel,
  output reg [WIDTH-1:0]         dout
);

  reg [WIDTH-1:0] mem [0:DEPTH-1];
  integer i;

  // Initialize ROM contents: runs once, at time 0, before anything reads
  // from mem -- exactly what a fixed set of ROM contents needs.
  initial begin
    for (i = 0; i < DEPTH; i = i + 1) begin
      mem[i] = i * i;
    end
  end

  // Combinational read: dout tracks mem[sel] any time sel (or mem)
  // changes.
  always @(*) begin
    dout = mem[sel];
  end

endmodule
