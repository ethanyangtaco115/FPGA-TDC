module fine_delay_capture (
    input logic async_event,
    input logic clk_input,
    input logic rst,
    input logic [ ] taps,
    output logic [$clog2($bits(taps))-1:0] fine_encoded,
    output logic valid
);
    
    
endmodule