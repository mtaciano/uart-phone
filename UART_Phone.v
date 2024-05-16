module UART_Phone #(
    // Phone states
    parameter STANDBY = 3'd0,
    parameter CALLING = 3'd1,
    parameter BEING_CALLED = 3'd2,
    parameter IN_CALL = 3'd3,
    parameter PHONE_NUMBER = 8'b10101000,
    parameter CALL_ACCEPT = 8'b11111111,
    parameter CALL_REJECT = 8'b00000000
)(
    // Clock
    input CLK50MHz,

    // PS/2
    input data_ps2,
    input clk_ps2,

    // LCD & 7-segment
    output [6:0] hex0,
    output [6:0] hex1,
    output end_scan,
    output LCD_RS,
    output LCD_E,
    output LCD_RW,
    output [7:0] LCD_DATA,
    output LCD_ON,
    output LCD_BLON,
    output espera,

    // UART
    input rx_keyboard,
    output tx_keyboard,
    input rx_phone,
    output tx_phone,
    input rx_blue,

    // Buzzer
    output reg buzzer
);

// Phone state machine
reg [2:0] phone_state;
reg can_talk;
reg [7:0] send_number;
reg send_state;
reg prev_send_state;
reg [7:0] recv_number;

// Keep the LCD on
assign LCD_BLON = 1'b1;
assign LCD_ON = 1'b1;

// PS/2 transmission data
wire [7:0] scan;
wire finish_ps2;
assign end_scan = finish_ps2;

// LCD commands from PS/2
wire [7:0] comando;
wire num_comando;

// UART Bluetooth
wire [7:0] rx_message_blue;
wire o_Rx_DV_blue;

// Bluetooth transmission data
wire [11:0] switches;
wire [3:0] buttons;

// UART Rx
wire o_Rx_DV_keyboard;
wire [7:0] rx_message_keyboard;

wire o_Rx_DV_phone;
wire [7:0] rx_message_phone;

// UART Tx
wire i_Tx_DV_keyboard;
wire o_Tx_Active_keyboard; // NOTE: Not used
wire o_Tx_Done_keyboard; // NOTE: Not used
wire [7:0] tx_message_keyboard;
assign tx_message_keyboard = scan;
assign i_Tx_DV_keyboard = can_talk & finish_ps2;

wire i_Tx_DV_phone;
reg i_Tx_DV_phone_r;
wire o_Tx_Active_phone; // NOTE: Not used
wire o_Tx_Done_phone; // NOTE: Not used
wire [7:0] tx_message_phone;
reg [7:0] tx_message_phone_r;
assign i_Tx_DV_phone = i_Tx_DV_phone_r;
assign tx_message_phone = tx_message_phone_r;

initial begin
    phone_state = STANDBY;
    can_talk = 1'b0;
    send_number = 8'b0;
    send_state = 1'b0;
    prev_send_state = 1'b0;
    recv_number = 8'b0;
    buzzer = 1'b1;
end

always @(posedge buttons[0]) begin
    send_number <= switches[7:0];
    send_state <= ~send_state;
end

// Represent the phone states in a state machine
always @(posedge CLK50MHz) begin
    case (phone_state)
        STANDBY: begin
            i_Tx_DV_phone_r <= 1'b0;

            if (send_state != prev_send_state) begin
                prev_send_state <= send_state;
                tx_message_phone_r <= send_number;
                i_Tx_DV_phone_r <= 1'b1;
                phone_state <= CALLING;
            end

            if (o_Rx_DV_phone == 1'b1) begin
                recv_number <= rx_message_phone;
                if (recv_number == PHONE_NUMBER) begin
                    phone_state <= BEING_CALLED;
                end else begin
                    tx_message_phone_r <= CALL_REJECT;
                    i_Tx_DV_phone_r <= 1'b1;
                end
            end
        end

        CALLING: begin
            i_Tx_DV_phone_r <= 1'b0;

            if (o_Rx_DV_phone == 1'b1) begin
                recv_number <= rx_message_phone;
                if (recv_number == CALL_ACCEPT) begin
                    phone_state <= IN_CALL;
                end else begin
                    phone_state <= STANDBY;
                end
            end
        end

        BEING_CALLED: begin
            buzzer <= 1'b0;

            if (buttons[2] == 1'b1) begin
                buzzer <= 1'b1;
                tx_message_phone_r <= CALL_ACCEPT;
                i_Tx_DV_phone_r <= 1'b1;
                phone_state <= IN_CALL;
            end else if (buttons[3] == 1'b1) begin
                buzzer <= 1'b1;
                tx_message_phone_r <= CALL_REJECT;
                i_Tx_DV_phone_r <= 1'b1;
                phone_state <= STANDBY;
            end
        end

        IN_CALL: begin
            i_Tx_DV_phone_r <= 1'b0;
            can_talk <= 1'b1;

            if (o_Rx_DV_phone == 1'b1) begin
                recv_number <= rx_message_phone;
                if (recv_number == CALL_REJECT) begin
                    can_talk <= 1'b0;
                    phone_state <= STANDBY;
                end
            end else if (buttons[3] == 1'b1) begin
                can_talk <= 1'b0;
                tx_message_phone_r <= CALL_REJECT;
                i_Tx_DV_phone_r <= 1'b1;
                phone_state <= STANDBY;
            end
        end

        default: begin
            phone_state <= STANDBY;
        end
    endcase
end

uart_rx urx_blue (
    .i_Clock(CLK50MHz),
    .i_Rx_Serial(rx_blue),
    .o_Rx_DV(o_Rx_DV_blue),
    .o_Rx_Byte(rx_message_blue)
);

Decoder dec (
    .new_data(o_Rx_DV_blue),
    .ascii_code(rx_message_blue),
    .switches(switches),
    .buttons(buttons)
);

leitorPS2 lps2 (
    .clk_ps2(clk_ps2),
    .data(data_ps2),
    .scan_code(scan),
    .end_scan(finish_ps2)
);

PS2_to_LCD ps2tolcd (
    .scancode(rx_message_keyboard),
    .finish_ps2(o_Rx_DV_keyboard),
    .comando(comando),
    .num_comando(num_comando)
);

hexto7segment display0 (
    .bin(LCD_DATA[3:0]),
    .hex(hex0)
);

hexto7segment display1 (
    .bin(LCD_DATA[7:4]),
    .hex(hex1)
);

displayLCD dlcd (
    .CLK50MHz(CLK50MHz),
    .num_comando(num_comando),
    .comando(comando),
    .LCD_RS(LCD_RS),
    .LCD_E(LCD_E),
    .LCD_RW(LCD_RW),
    .LCD_DATA(LCD_DATA),
    .espera(espera)
);

uart_rx urx_keyboard (
   .i_Clock(CLK50MHz),
   .i_Rx_Serial(rx_keyboard),
   .o_Rx_DV(o_Rx_DV_keyboard),
   .o_Rx_Byte(rx_message_keyboard)
);

uart_tx utx_keyboard (
   .i_Clock(CLK50MHz),
   .i_Tx_DV(i_Tx_DV_keyboard),
   .i_Tx_Byte(tx_message_keyboard),
   .o_Tx_Active(o_Tx_Active_keyboard),
   .o_Tx_Serial(tx_keyboard),
   .o_Tx_Done(o_Tx_Done_keyboard)
);

uart_rx urx_phone (
   .i_Clock(CLK50MHz),
   .i_Rx_Serial(rx_phone),
   .o_Rx_DV(o_Rx_DV_phone),
   .o_Rx_Byte(rx_message_phone)
);

uart_tx utx_phone (
   .i_Clock(CLK50MHz),
   .i_Tx_DV(i_Tx_DV_phone),
   .i_Tx_Byte(tx_message_phone),
   .o_Tx_Active(o_Tx_Active_phone),
   .o_Tx_Serial(tx_phone),
   .o_Tx_Done(o_Tx_Done_phone)
);

endmodule
