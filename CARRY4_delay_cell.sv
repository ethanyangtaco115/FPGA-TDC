module CARRY4_delay_cell (
    input logic start,
    output logic [3:0] delay_taps
);
    logic [3:0] carry_out;

    CARRY4 carry_inst (
        .CI(1'b0),
        .CYINT(start),
        .DI(4'b0000),
        .S(4'b1111),
        .O(),
        .CO(carry_out)

    assign delay_taps = carry_out;
    );


endmodule