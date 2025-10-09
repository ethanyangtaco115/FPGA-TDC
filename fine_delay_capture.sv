`include "synchronizer.sv"
`include "delay line.sv"

module fine_delay_capture #(
    parameter int MAX_LENGTH = 2048
) (
    input  logic async_event,
    input  logic clk_input,
    input  logic reset,
    input  logic [4*MAX_LENGTH-1:0] taps,  // 4-bit-per-cell flattened
    input  int   _length,                   // runtime number of active taps
    output logic [$clog2(MAX_LENGTH)-1:0] fine_encoded, //which tap activated, sequentially, this is what it outputs
    output logic valid, //did actually tap fire
    output logic [_length-1:0] phases //outputs phases, for more tapping :3
);
    
    logic sync_event;
    synchronizer #(.flip_flops(2)) sync_inst (
        .clk_input(clk_input),
        .reset(reset),
        .async_event(async_event),
        .event_sync(sync_event)
    ); 

    logic [4*MAX_LENGTH-1:0] taps_reg;
    always_ff @(posedge clk_input or posedge reset) begin
        if (reset) begin
            taps_reg <= '0;
            fine_encoded <= '0;
            valid <= 0;
            phases <= '0;
        end else if (sync_event) begin
            taps_reg <= taps;
        end
    end

    always_comb begin
        fine_encoded = '0;
        valid = 0;
        phases = '0;
        for (int i = 0; i < _length; i++) begin
            // OR the 4 bits of each CARRY4 cell to get a single tap firing
            logic tap_active = |taps_reg[4*i +: 4];
            phases[i] = tap_active;
            if (tap_active && valid == 0) begin
                fine_encoded = i;
                valid = 1;
            end
        end
    end
endmodule