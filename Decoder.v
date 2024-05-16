module Decoder (
    input new_data,
    inout reg [7:0] ascii_code,
    output reg [11:0] switches,
    output reg [3:0] buttons
);


initial begin
    switches = 12'd0;
    buttons = 4'd0;
end

always @(posedge new_data) begin
    case (ascii_code)
        8'd33: switches[0] = ~switches[0];
        8'd34: switches[1] = ~switches[1];
        8'd35: switches[2] = ~switches[2];
        8'd36: switches[3] = ~switches[3];
        8'd37: switches[4] = ~switches[4];
        8'd38: switches[5] = ~switches[5];
        8'd39: switches[6] = ~switches[6];
        8'd40: switches[7] = ~switches[7];
        8'd41: switches[8] = ~switches[8];
        8'd42: switches[9] = ~switches[9];
        8'd43: switches[10] = ~switches[10];
        8'd44: switches[11] = ~switches[11];
        8'd45: buttons[0] = ~buttons[0];
        8'd46: buttons[1] = ~buttons[1];
        8'd47: buttons[2] = ~buttons[2];
        8'd48: buttons[3] = ~buttons[3];
    endcase
end
endmodule
