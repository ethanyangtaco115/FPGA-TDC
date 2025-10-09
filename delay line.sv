`include "CARRY4_delay_cell.sv"

module delay_line #(
    parameter int MAX_LENGTH = 2048  // maximum number of delay cells
)(
    input  logic clk_input,
    input  logic async_event,         // asynchronous start trigger
    input  int   _length,             // runtime number of active cells
    output logic [4*MAX_LENGTH-1:0] tap_output  // all taps (flattened)
);

    logic [3:0] delay_taps [0:MAX_LENGTH-1];

    
    genvar i;
    generate;
        for (i =0; i <= MAX_LENGTH; i++) begin : delay_cells
            CARRY4_delay_cell delay_cell_inst(
                .start(i == 0 ? async_event : delay_taps[i-1][3]),
                .delay_taps(delay_taps[i])
            );
        end
    endgenerate

    
//propogate start signal for delay, with shift registers
    integer j;
    always_ff @(posedge clk_input) begin
        tap_output <= '0;

        // Copy only _length active cells
        for (j = 0; j < _length; j=j+1) begin
            tap_output[4*j +: 4] <= delay_taps[j];
        end
    end

endmodule