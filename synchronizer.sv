module synchronizer #(
    parameter int flip_flops = 2;
) (
    input logic clk_input,
    input logic reset,
    input int _length,
    input logic async_event,
    output logic event_sync
);
    logic [flip_flops-1:0] register_sync;

    always_ff @(posedge clk_input or posedge reset) begin
        if (reset)
            register_sync <= '0;
        else begin 
            register_sync[0] <= async_event;
            for (int i = 1; i < flip_flops; i++) begin
                register_sync[i] <= register_sync[i-1];
            end
        end
    end

    assign event_sync = (_length <= flip_flops && _length > 0) ? register_sync[_length-1] : register_sync[flip_flops-1];
endmodule