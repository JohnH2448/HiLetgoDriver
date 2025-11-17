module top (
    input wire clock,
    output wire [15:0] data,
    output reg command,
    output reg select,
    output reg reset,
    output reg write,
    output wire bootStatus,
    output wire clockEdge,
    output reg extraStatus
);

    reg [15:0] dataBus;
    reg [7:0] xCoord;
    reg [7:0] yCoord;
    reg [8:0] realXCoord;
    reg [8:0] realYCoord;
    reg [17:0] pixelIndex;
    assign data = dataBus;
    reg boot;
    reg [6:0] bootStage;
    reg [21:0] delay;
    reg [2:0] writeCycle;
    reg frameStarted;
    reg [26:0] divider;
    wire slowClock;
    assign slowClock = divider[20];
    assign bootStatus = !boot;
    assign clockEdge = divider[20]; 
    wire [5:0] boxX = realXCoord - 9'd210;  // 0..59
    wire [5:0] boxY = realYCoord - 9'd130;  // 0..59
    wire [11:0] boxIndex = boxY * 7'd60 + boxX;
    reg [15:0] boxMem [0:3599];

    wire inBox =
        (realXCoord >= 9'd210 && realXCoord < 9'd270 &&
        realYCoord >= 9'd130 && realYCoord < 9'd190);

    // Extra
    reg [5:0]  fb_x;
    reg [5:0]  fb_y;
    wire [11:0] fb_index = fb_y * 7'd60 + fb_x;
    reg [5:0]  animPhase;
    reg [23:0] animTick;
 
    initial begin
        boot = 1'd1;
        bootStage = 7'b1111111;
        delay = 22'd0;
        reset = 1'd1;
        command = 1'd0;
        writeCycle = 3'd0;
        write = 1'd1;
        frameStarted = 1'd0;
        select = 1'b1;
        divider = 27'd0;
        extraStatus = 1'd1;
        pixelIndex = 18'd0;
        realXCoord = 9'd0;
        realYCoord = 9'd0;
        fb_x      = 6'd0;
        fb_y      = 6'd0;
        animPhase = 6'd0;
        animTick  = 24'd0;
    end

    always @(posedge clock) begin
        divider <= divider + 27'd1;
    end

    always @(posedge clock) begin
        if (boot) begin
            case (bootStage)
                7'b1111111: begin // Startup Delay
                    if (delay < 22'd1400000) begin // ~50ms
                        delay <= delay + 22'd1;
                        reset <= 1'd1;
                    end else begin
                        bootStage <= 7'd0;
                        delay <= 22'd0;
                    end
                end
                7'b0000000: begin  // Lowers Reset Line
                    if (delay < 22'd297000) begin // ~11ms
                        delay <= delay + 22'd1;
                        reset <= 1'd0;
                    end else begin
                        bootStage <= bootStage+7'd1;
                        delay <= 22'd0;
                    end
                end
                7'b0000001: begin // Raises Reset Line
                    if (delay < 22'd3500000) begin // ~130ms
                        delay <= delay + 22'd1;
                        reset <= 1'd1;
                    end else begin
                        bootStage <= bootStage+7'd1;
                        delay <= 22'd0;
                    end
                end
                7'b0000100: begin // Delay 1
                    if (delay < 22'd1400000) begin // ~50ms
                        delay <= delay + 22'd1;
                    end else begin
                        bootStage <= bootStage+7'd1;
                        delay <= 22'd0;
                    end
                end
                7'b0111100: begin // Delay 2
                    if (delay < 22'd4100000) begin // ~150ms
                        delay <= delay + 22'd1;
                    end else begin
                        bootStage <= bootStage+7'd1;
                        delay <= 22'd0;
                    end
                end
                7'b0111110: begin // Delay 3
                    if (delay < 22'd700000) begin // ~25ms
                        delay <= delay + 22'd1;
                    end else begin
                        bootStage <= bootStage+7'd1;
                        delay <= 22'd0;
                    end
                end
                7'b1001001: begin // Delay 4
                    if (delay < 22'd4100000) begin // ~150ms
                        delay <= delay + 22'd1;
                    end else begin
                        bootStage <= bootStage+7'd1;
                        delay <= 22'd0;
                        boot <= 1'd0;
                    end
                end
            endcase
            if (bootStage != 7'b1111111 && bootStage != 7'b0000100 && bootStage != 7'b0111100 && bootStage != 7'b0111110 && bootStage != 7'b1001001 && bootStage != 7'b0000000 && bootStage != 7'b0000001) begin 
                case (writeCycle)
                    3'b000: begin
                        case (bootStage)
                            7'b0000010: begin
                                command <= 1'd0;
                                dataBus <= 16'h01;
                            end

                            7'b0000011: begin
                                command <= 1'd1;
                                dataBus <= 16'h00;
                            end

                            7'b0000101: begin
                                command <= 1'd0;
                                dataBus <= 16'h28;
                            end

                            7'b0000110: begin
                                command <= 1'd1;
                                dataBus <= 16'h00;
                            end

                            7'b0000111: begin
                                command <= 1'd0;
                                dataBus <= 16'hC0;
                            end

                            7'b0001000: begin
                                command <= 1'd1;
                                dataBus <= 16'h0d;
                            end

                            7'b0001001: begin
                                command <= 1'd1;
                                dataBus <= 16'h0d;
                            end

                            7'b0001010: begin
                                command <= 1'd0;
                                dataBus <= 16'hC1;
                            end

                            7'b0001011: begin
                                command <= 1'd1;
                                dataBus <= 16'h43;
                            end

                            7'b0001100: begin
                                command <= 1'd1;
                                dataBus <= 16'h00;
                            end

                            7'b0001101: begin
                                command <= 1'd0;
                                dataBus <= 16'hC2;
                            end

                            7'b0001110: begin
                                command <= 1'd1;
                                dataBus <= 16'h00;
                            end

                            7'b0001111: begin
                                command <= 1'd0;
                                dataBus <= 16'hC5;
                            end

                            7'b0010000: begin
                                command <= 1'd1;
                                dataBus <= 16'h00;
                            end

                            7'b0010001: begin
                                command <= 1'd1;
                                dataBus <= 16'h48;
                            end

                            7'b0010010: begin
                                command <= 1'd0;
                                dataBus <= 16'hB6;
                            end

                            7'b0010011: begin
                                command <= 1'd1;
                                dataBus <= 16'h00;
                            end

                            7'b0010100: begin
                                command <= 1'd1;
                                dataBus <= 16'h22;
                            end

                            7'b0010101: begin
                                command <= 1'd1;
                                dataBus <= 16'h3B;
                            end

                            7'b0010110: begin
                                command <= 1'd0;
                                dataBus <= 16'hE0;
                            end

                            7'b0010111: begin
                                command <= 1'd1;
                                dataBus <= 16'h0f;
                            end

                            7'b0011000: begin
                                command <= 1'd1;
                                dataBus <= 16'h24;
                            end

                            7'b0011001: begin
                                command <= 1'd1;
                                dataBus <= 16'h1c;
                            end

                            7'b0011010: begin
                                command <= 1'd1;
                                dataBus <= 16'h0a;
                            end

                            7'b0011011: begin
                                command <= 1'd1;
                                dataBus <= 16'h0f;
                            end

                            7'b0011100: begin
                                command <= 1'd1;
                                dataBus <= 16'h08;
                            end

                            7'b0011101: begin
                                command <= 1'd1;
                                dataBus <= 16'h43;
                            end

                            7'b0011110: begin
                                command <= 1'd1;
                                dataBus <= 16'h88;
                            end

                            7'b0011111: begin
                                command <= 1'd1;
                                dataBus <= 16'h32;
                            end

                            7'b0100000: begin
                                command <= 1'd1;
                                dataBus <= 16'h0f;
                            end

                            7'b0100001: begin
                                command <= 1'd1;
                                dataBus <= 16'h10;
                            end

                            7'b0100010: begin
                                command <= 1'd1;
                                dataBus <= 16'h06;
                            end

                            7'b0100011: begin
                                command <= 1'd1;
                                dataBus <= 16'h0f;
                            end

                            7'b0100100: begin
                                command <= 1'd1;
                                dataBus <= 16'h07;
                            end

                            7'b0100101: begin
                                command <= 1'd1;
                                dataBus <= 16'h00;
                            end

                            7'b0100110: begin
                                command <= 1'd0;
                                dataBus <= 16'hE1;
                            end

                            7'b0100111: begin
                                command <= 1'd1;
                                dataBus <= 16'h0F;
                            end

                            7'b0101000: begin
                                command <= 1'd1;
                                dataBus <= 16'h38;
                            end

                            7'b0101001: begin
                                command <= 1'd1;
                                dataBus <= 16'h30;
                            end

                            7'b0101010: begin
                                command <= 1'd1;
                                dataBus <= 16'h09;
                            end

                            7'b0101011: begin
                                command <= 1'd1;
                                dataBus <= 16'h0f;
                            end

                            7'b0101100: begin
                                command <= 1'd1;
                                dataBus <= 16'h0f;
                            end

                            7'b0101101: begin
                                command <= 1'd1;
                                dataBus <= 16'h4e;
                            end

                            7'b0101110: begin
                                command <= 1'd1;
                                dataBus <= 16'h77;
                            end

                            7'b0101111: begin
                                command <= 1'd1;
                                dataBus <= 16'h3c;
                            end

                            7'b0110000: begin
                                command <= 1'd1;
                                dataBus <= 16'h07;
                            end

                            7'b0110001: begin
                                command <= 1'd1;
                                dataBus <= 16'h10;
                            end

                            7'b0110010: begin
                                command <= 1'd1;
                                dataBus <= 16'h05;
                            end

                            7'b0110011: begin
                                command <= 1'd1;
                                dataBus <= 16'h23;
                            end

                            7'b0110100: begin
                                command <= 1'd1;
                                dataBus <= 16'h1b;
                            end

                            7'b0110101: begin
                                command <= 1'd1;
                                dataBus <= 16'h00;
                            end

                            7'b0110110: begin
                                command <= 1'd0;
                                dataBus <= 16'h20;
                            end

                            7'b0110111: begin
                                command <= 1'd0;
                                dataBus <= 16'h36;
                            end

                            7'b0111000: begin
                                command <= 1'd1;
                                dataBus <= 16'h0A;
                            end

                            7'b0111001: begin
                                command <= 1'd0;
                                dataBus <= 16'h3A;
                            end

                            7'b0111010: begin
                                command <= 1'd1;
                                dataBus <= 16'h55;
                            end

                            7'b0111011: begin
                                command <= 1'd0;
                                dataBus <= 16'h11;
                            end

                            7'b0111101: begin
                                command <= 1'd0;
                                dataBus <= 16'h29;
                            end

                            7'b0111111: begin
                                command <= 1'd0;
                                dataBus <= 16'h2A;
                            end

                            7'b1000000: begin
                                command <= 1'd1;
                                dataBus <= 16'h00;
                            end

                            7'b1000001: begin
                                command <= 1'd1;
                                dataBus <= 16'h00;
                            end

                            7'b1000010: begin
                                command <= 1'd1;
                                dataBus <= 16'h01; // Y high
                            end

                            7'b1000011: begin
                                command <= 1'd1;
                                dataBus <= 16'h3F; // Y low
                            end

                            7'b1000100: begin
                                command <= 1'd0;
                                dataBus <= 16'h2B;
                            end

                            7'b1000101: begin
                                command <= 1'd1;
                                dataBus <= 16'h00;
                            end

                            7'b1000110: begin
                                command <= 1'd1;
                                dataBus <= 16'h00;
                            end

                            7'b1000111: begin
                                command <= 1'd1;
                                dataBus <= 16'h01; // X high
                            end

                            7'b1001000: begin
                                command <= 1'd1;
                                dataBus <= 16'hDF; // X low
                            end
                        endcase 
                        writeCycle <= writeCycle + 3'd1;
                        select <= 1'd0;
                    end
                    3'b001: begin
                        writeCycle <= writeCycle + 3'd1;
                    end
                    3'b010: begin
                        write      <= 1'd0;
                        writeCycle <= writeCycle + 3'd1;
                    end
                    3'b011: begin
                        writeCycle <= writeCycle + 3'd1;
                    end
                    3'b100: begin
                        writeCycle <= writeCycle + 3'd1;
                    end
                    3'b101: begin
                        write      <= 1'd1;
                        writeCycle <= writeCycle + 3'd1;
                    end
                    3'b110: begin
                        writeCycle <= writeCycle + 3'd1;
                        select <= 1'd1;
                    end
                    3'b111: begin
                        writeCycle <= 3'd0;
                        bootStage  <= bootStage + 7'd1;
                    end
                endcase
            end
        end else begin
            if (!frameStarted) begin
                case (writeCycle) // Write Command
                    3'b000: begin
                        command   <= 1'd0;
                        writeCycle <= writeCycle + 3'd1;
                        dataBus <= 16'h002C;
                        select <= 1'd0;
                    end
                    3'b001: begin
                        writeCycle <= writeCycle + 3'd1;
                    end
                    3'b010: begin
                        write <= 1'd0;
                        writeCycle <= writeCycle + 3'd1;
                    end
                    3'b011: begin 
                        writeCycle <= writeCycle + 3'd1;
                    end
                    3'b100: begin
                        writeCycle <= writeCycle + 3'd1;
                    end
                    3'b101: begin
                        write <= 1'd1;
                        writeCycle <= writeCycle + 3'd1;
                    end
                    3'b110: begin
                        writeCycle <= writeCycle + 3'd1;
                        select <= 1'd1;
                    end
                    3'b111: begin
                        writeCycle <= 3'd0;
                        frameStarted <= 1'd1;
                    end
                endcase
            end else begin
                if (realXCoord < 9'd480) begin
                    if (realYCoord < 9'd320) begin
                        case (writeCycle)
                            3'b000: begin
                                extraStatus <= 1'd0;
                                command     <= 1'd1;
                                writeCycle  <= writeCycle + 3'd1;
                                if (inBox) begin
                                    dataBus <= boxMem[boxIndex];   // pixel from 200x200 buffer
                                end else begin
                                    dataBus <= 16'h0000;           // black outside box
                                end
                                select <= 1'd0;
                            end
                            3'b001: begin
                                writeCycle <= writeCycle + 3'd1;
                            end
                            3'b010: begin
                                write <= 1'd0;
                                writeCycle <= writeCycle + 3'd1;
                            end
                            3'b011: begin 
                                writeCycle <= writeCycle + 3'd1;
                            end
                            3'b100: begin
                                writeCycle <= writeCycle + 3'd1;
                            end
                            3'b101: begin
                                write <= 1'd1;
                                writeCycle <= writeCycle + 3'd1;
                            end
                            3'b110: begin
                                writeCycle <= writeCycle + 3'd1;
                                select <= 1'd1;
                            end
                            3'b111: begin
                                writeCycle <= 3'd0;
                                pixelIndex <= pixelIndex + 18'd1;
                                realYCoord <= realYCoord + 9'd1;
                            end
                        endcase
                    end else begin
                        realYCoord <= 9'd0;
                        realXCoord <= realXCoord + 9'd1;
                    end
                end else begin
                    realXCoord <= 9'd0;
                    pixelIndex <= 18'd0;
                end
            end
            // calcs
            if (fb_x == 6'd0 || fb_x == 6'd59 || fb_y == 6'd0 || fb_y == 6'd59)
                boxMem[fb_index] <= 16'hF800;   // red border
            else if (fb_x >= animPhase && fb_x < animPhase + 6'd4 && fb_x < 6'd60)
                boxMem[fb_index] <= 16'h07E0;   // green bar 4px wide
            else
                boxMem[fb_index] <= 16'h0000;   // black inside

            if (fb_x == 6'd59) begin
                fb_x <= 6'd0;
                if (fb_y == 6'd59)
                    fb_y <= 6'd0;
                else
                    fb_y <= fb_y + 6'd1;
            end else begin
                fb_x <= fb_x + 6'd1;
            end

            // slow animation step
            animTick <= animTick + 24'd1;
            if (animTick == 24'd20000) begin  // smaller number = faster sweep
                animTick <= 24'd0;

                if (animPhase >= 6'd56)
                    animPhase <= 6'd0;
                else
                    animPhase <= animPhase + 6'd1;
            end
        end
    end
endmodule

