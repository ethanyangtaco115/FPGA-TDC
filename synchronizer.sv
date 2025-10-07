module synchronizer #(
    parameter int flip_flops = 2;
) (
    input logic clk_input,
    input logic reset,
    input logic async_event,
    output logic event_sync
);
    logic [flip_flops-1:0] register_sync;

    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            register_sync <= '0;
        else begin 
            register_sync[0] <= async_event;
            for (int i = 1; i < length; i += 1) begin
                register_sync[i] <= register_sync[i-1];
            end
        end
    end

    assign event_sync = register_sync[length-1];
endmodule