`include "CARRY4_delay_cell.sv"

module delay_line #(
    parameter int length = 1024
) (
    input logic clk_input,
    input logic input,
    output logic [length-1:0] tap_output
);

    logic [length:0] current_taps, next_taps; //current taps, then next
    
    assign current_taps[0] = input;

    genvar i;
    generate;
        for (i =0; i <= length; i++) begin : delay_cells
            CARRY4_delay_cell delay_cell inst(
                .start(i == 0 ? start : current_taps[i-1]),
                .delay_taps(delay_taps[i])
            );
        end
    endgenerate
//propogate start signal for delay, with shift registers
    always_ff @(posedge clk_input) begin
        current_taps <= {delay_taps[length-1], current_taps[length-1:1]};
        next_taps <= current_taps;
        tap_output <= next_taps;
    end

endmodule