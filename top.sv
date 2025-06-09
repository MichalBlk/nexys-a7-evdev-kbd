module top(
  input  logic       CLK100MHZ,
  input  logic       CPU_RESETN,

  output logic       CA,
  output logic       CB,
  output logic       CC,
  output logic       CD,
  output logic       CE,
  output logic       CF,
  output logic       CG,
  output logic       DP,
  output logic [7:0] AN,

  input  logic       PS2_CLK,
  input  logic       PS2_DATA
);
  logic [31:0] data, data_r;

  /*
   * Read events
   */
  logic [31:0] kbd_data;
  logic        kbd_done;

  kbd KBD(
    .clk_100mhz (CLK100MHZ),
    .kbd_clk    (PS2_CLK),
    .nrst       (CPU_RESETN),
    .kbd_data   (PS2_DATA),
    .data       (kbd_data),
    .done       (kbd_done)
  );

  always_comb begin
    data = data_r;

    if (kbd_done)
      data = kbd_data;
  end

  always_ff @(posedge CLK100MHZ, negedge CPU_RESETN)
    if (!CPU_RESETN)
      data_r <= 0;
    else
      data_r <= data;

  /*
   * Display events
   */
  seven_seg SEVEN_SEG(
    .clk_100mhz (CLK100MHZ),
    .nrst       (CPU_RESETN),
    .ca         (CA),
    .cb         (CB),
    .cc         (CC),
    .cd         (CD),
    .ce         (CE),
    .cf         (CF),
    .cg         (CG),
    .dp         (DP),
    .an         (AN),
    .val        (data_r)
  );
endmodule
