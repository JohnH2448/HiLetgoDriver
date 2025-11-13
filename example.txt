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
    assign data = dataBus;
    reg boot;
    reg [6:0] bootStage;
    reg [21:0] delay;
    reg [2:0] writeCycle;
    reg frameStarted;
    reg [17:0] pixels;
    reg [26:0] divider;
    wire slowClock;
    assign slowClock = divider[20];
    assign bootStatus = !boot;
    assign clockEdge = divider[20];

    initial begin
        boot = 1'd1;
        bootStage = 7'd0;
        delay = 22'd0;
        reset = 1'd0;
        command = 1'd0;
        writeCycle = 3'd0;
        write = 1'd1;
        frameStarted = 1'd0;
        pixels = 18'd0;
        select = 1'b0;
        divider = 27'd0;
        extraStatus = 1'd1;
    end

    always @(posedge clock) begin
        divider <= divider + 27'd1;
    end

    always @(posedge slowClock) begin
        if (boot) begin
            case (bootStage)
                7'b0000000: begin  // Toggles Reset Line
                    if (delay < 22'd35) begin // ~130ms changed 3500000
                            delay <= delay + 22'd1;
                            select <= 1'd0;
                    end else begin
                            bootStage <= bootStage+1;
                            delay <= 22'd0;
                            reset <= 1'd1;
                    end
                end
                7'b0000001: begin // delay after reset
                    if (delay < 22'd35) begin // ~130ms changed 3500000
                            delay <= delay + 22'd1;
                    end else begin
                            bootStage <= bootStage+1;
                            delay <= 22'd0;
                    end
                end
                7'b0000010: begin  // writecommand(0x01);
                    case (writeCycle)
                        3'b000: begin
                            writeCycle <= writeCycle + 3'd1;
                            command   <= 1'd0;
                            dataBus   <= 16'h0001;
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
                        end
                        3'b111: begin
                            writeCycle <= 3'd0;
                            bootStage  <= bootStage + 7'd1;
                        end
                    endcase
                end

                7'b0000011: begin  // writedata(0x00);
                    case (writeCycle)
                        3'b000: begin
                            writeCycle <= writeCycle + 3'd1;
                            command   <= 1'd1;
                            dataBus   <= 16'h0000;
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
                        end
                        3'b111: begin
                            writeCycle <= 3'd0;
                            bootStage  <= bootStage + 7'd1;
                        end
                    endcase
                end

                7'b0000100: begin  // delay(50);  (~50 ms)
                    if (delay < 22'd135) begin // change 1350000
                        delay <= delay + 22'd1;
                    end else begin
                        delay <= 22'd0;
                        bootStage <= bootStage + { 7{1'b0} } + 7'd1;
                    end
                end

                7'b0000101: begin  // writecommand(0x28);
                    case (writeCycle)
                        3'b000: begin
                            writeCycle <= writeCycle + 3'd1;
                            command   <= 1'd0;
                            dataBus   <= 16'h0028;
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
                        end
                        3'b111: begin
                            writeCycle <= 3'd0;
                            bootStage  <= bootStage + 7'd1;
                        end
                    endcase
                end

                7'b0000110: begin  // writedata(0x00);
                    case (writeCycle)
                        3'b000: begin
                            writeCycle <= writeCycle + 3'd1;
                            command   <= 1'd1;
                            dataBus   <= 16'h0000;
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
                        end
                        3'b111: begin
                            writeCycle <= 3'd0;
                            bootStage  <= bootStage + 7'd1;
                        end
                    endcase
                end

                7'b0000111: begin  // writecommand(0xC0);        // Power Control 1
                    case (writeCycle)
                        3'b000: begin
                            writeCycle <= writeCycle + 3'd1;
                            command   <= 1'd0;
                            dataBus   <= 16'h00C0;
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
                        end
                        3'b111: begin
                            writeCycle <= 3'd0;
                            bootStage  <= bootStage + 7'd1;
                        end
                    endcase
                end

                7'b0001000: begin  // writedata(0x0d);
                    case (writeCycle)
                        3'b000: begin
                            writeCycle <= writeCycle + 3'd1;
                            command   <= 1'd1;
                            dataBus   <= 16'h000D;
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
                        end
                        3'b111: begin
                            writeCycle <= 3'd0;
                            bootStage  <= bootStage + 7'd1;
                        end
                    endcase
                end

                7'b0001001: begin  // writedata(0x0d);
                    case (writeCycle)
                        3'b000: begin
                            writeCycle <= writeCycle + 3'd1;
                            command   <= 1'd1;
                            dataBus   <= 16'h000D;
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
                        end
                        3'b111: begin
                            writeCycle <= 3'd0;
                            bootStage  <= bootStage + 7'd1;
                        end
                    endcase
                end

                7'b0001010: begin  // writecommand(0xC1);        // Power Control 2
                    case (writeCycle)
                        3'b000: begin
                            writeCycle <= writeCycle + 3'd1;
                            command   <= 1'd0;
                            dataBus   <= 16'h00C1;
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
                        end
                        3'b111: begin
                            writeCycle <= 3'd0;
                            bootStage  <= bootStage + 7'd1;
                        end
                    endcase
                end

                7'b0001011: begin  // writedata(0x43);
                    case (writeCycle)
                        3'b000: begin
                            writeCycle <= writeCycle + 3'd1;
                            command   <= 1'd1;
                            dataBus   <= 16'h0043;
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
                        end
                        3'b111: begin
                            writeCycle <= 3'd0;
                            bootStage  <= bootStage + 7'd1;
                        end
                    endcase
                end

                7'b0001100: begin  // writedata(0x00);
                    case (writeCycle)
                        3'b000: begin
                            writeCycle <= writeCycle + 3'd1;
                            command   <= 1'd1;
                            dataBus   <= 16'h0000;
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
                        end
                        3'b111: begin
                            writeCycle <= 3'd0;
                            bootStage  <= bootStage + 7'd1;
                        end
                    endcase
                end

                7'b0001101: begin  // writecommand(0xC2);        // Power Control 3
                    case (writeCycle)
                        3'b000: begin
                            writeCycle <= writeCycle + 3'd1;
                            command   <= 1'd0;
                            dataBus   <= 16'h00C2;
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
                        end
                        3'b111: begin
                            writeCycle <= 3'd0;
                            bootStage  <= bootStage + 7'd1;
                        end
                    endcase
                end

                7'b0001110: begin  // writedata(0x00);
                    case (writeCycle)
                        3'b000: begin
                            writeCycle <= writeCycle + 3'd1;
                            command   <= 1'd1;
                            dataBus   <= 16'h0000;
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
                        end
                        3'b111: begin
                            writeCycle <= 3'd0;
                            bootStage  <= bootStage + 7'd1;
                        end
                    endcase
                end

                7'b0001111: begin  // writecommand(0xC5);        // VCOM Control
                    case (writeCycle)
                        3'b000: begin
                            writeCycle <= writeCycle + 3'd1;
                            command   <= 1'd0;
                            dataBus   <= 16'h00C5;
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
                        end
                        3'b111: begin
                            writeCycle <= 3'd0;
                            bootStage  <= bootStage + 7'd1;
                        end
                    endcase
                end

                7'b0010000: begin  // writedata(0x00);
                    case (writeCycle)
                        3'b000: begin
                            writeCycle <= writeCycle + 3'd1;
                            command   <= 1'd1;
                            dataBus   <= 16'h0000;
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
                        end
                        3'b111: begin
                            writeCycle <= 3'd0;
                            bootStage  <= bootStage + 7'd1;
                        end
                    endcase
                end

                7'b0010001: begin  // writedata(0x48);
                    case (writeCycle)
                        3'b000: begin
                            writeCycle <= writeCycle + 3'd1;
                            command   <= 1'd1;
                            dataBus   <= 16'h0048;
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
                        end
                        3'b111: begin
                            writeCycle <= 3'd0;
                            bootStage  <= bootStage + 7'd1;
                        end
                    endcase
                end

                7'b0010010: begin  // writecommand(0xB6);        // Display Function Control
                    case (writeCycle)
                        3'b000: begin
                            writeCycle <= writeCycle + 3'd1;
                            command   <= 1'd0;
                            dataBus   <= 16'h00B6;
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
                        end
                        3'b111: begin
                            writeCycle <= 3'd0;
                            bootStage  <= bootStage + 7'd1;
                        end
                    endcase
                end

                7'b0010011: begin  // writedata(0x00);
                    case (writeCycle)
                        3'b000: begin
                            writeCycle <= writeCycle + 3'd1;
                            command   <= 1'd1;
                            dataBus   <= 16'h0000;
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
                        end
                        3'b111: begin
                            writeCycle <= 3'd0;
                            bootStage  <= bootStage + 7'd1;
                        end
                    endcase
                end

                7'b0010100: begin  // writedata(0x22);           // 0x42 = Rotate display 180 deg.
                    case (writeCycle)
                        3'b000: begin
                            writeCycle <= writeCycle + 3'd1;
                            command   <= 1'd1;
                            dataBus   <= 16'h0022;
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
                        end
                        3'b111: begin
                            writeCycle <= 3'd0;
                            bootStage  <= bootStage + 7'd1;
                        end
                    endcase
                end

                7'b0010101: begin  // writedata(0x3B);
                    case (writeCycle)
                        3'b000: begin
                            writeCycle <= writeCycle + 3'd1;
                            command   <= 1'd1;
                            dataBus   <= 16'h003B;
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
                        end
                        3'b111: begin
                            writeCycle <= 3'd0;
                            bootStage  <= bootStage + 7'd1;
                        end
                    endcase
                end

                7'b0010110: begin  // writecommand(0xE0);        // PGAMCTRL (Positive Gamma Control)
                    case (writeCycle)
                        3'b000: begin
                            writeCycle <= writeCycle + 3'd1;
                            command   <= 1'd0;
                            dataBus   <= 16'h00E0;
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
                        end
                        3'b111: begin
                            writeCycle <= 3'd0;
                            bootStage  <= bootStage + 7'd1;
                        end
                    endcase
                end

                7'b0010111: begin  // writedata(0x0f);
                    case (writeCycle)
                        3'b000: begin
                            writeCycle <= writeCycle + 3'd1;
                            command   <= 1'd1;
                            dataBus   <= 16'h000F;
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
                        end
                        3'b111: begin
                            writeCycle <= 3'd0;
                            bootStage  <= bootStage + 7'd1;
                        end
                    endcase
                end

                7'b0011000: begin  // writedata(0x24);
                    case (writeCycle)
                        3'b000: begin
                            writeCycle <= writeCycle + 3'd1;
                            command   <= 1'd1;
                            dataBus   <= 16'h0024;
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
                        end
                        3'b111: begin
                            writeCycle <= 3'd0;
                            bootStage  <= bootStage + 7'd1;
                        end
                    endcase
                end

                7'b0011001: begin  // writedata(0x1c);
                    case (writeCycle)
                        3'b000: begin
                            writeCycle <= writeCycle + 3'd1;
                            command   <= 1'd1;
                            dataBus   <= 16'h001C;
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
                        end
                        3'b111: begin
                            writeCycle <= 3'd0;
                            bootStage  <= bootStage + 7'd1;
                        end
                    endcase
                end

                7'b0011010: begin  // writedata(0x0a);
                    case (writeCycle)
                        3'b000: begin
                            writeCycle <= writeCycle + 3'd1;
                            command   <= 1'd1;
                            dataBus   <= 16'h000A;
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
                        end
                        3'b111: begin
                            writeCycle <= 3'd0;
                            bootStage  <= bootStage + 7'd1;
                        end
                    endcase
                end

                7'b0011011: begin  // writedata(0x0f);
                    case (writeCycle)
                        3'b000: begin
                            writeCycle <= writeCycle + 3'd1;
                            command   <= 1'd1;
                            dataBus   <= 16'h000F;
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
                        end
                        3'b111: begin
                            writeCycle <= 3'd0;
                            bootStage  <= bootStage + 7'd1;
                        end
                    endcase
                end

                7'b0011100: begin  // writedata(0x08);
                    case (writeCycle)
                        3'b000: begin
                            writeCycle <= writeCycle + 3'd1;
                            command   <= 1'd1;
                            dataBus   <= 16'h0008;
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
                        end
                        3'b111: begin
                            writeCycle <= 3'd0;
                            bootStage  <= bootStage + 7'd1;
                        end
                    endcase
                end

                7'b0011101: begin  // writedata(0x43);
                    case (writeCycle)
                        3'b000: begin
                            writeCycle <= writeCycle + 3'd1;
                            command   <= 1'd1;
                            dataBus   <= 16'h0043;
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
                        end
                        3'b111: begin
                            writeCycle <= 3'd0;
                            bootStage  <= bootStage + 7'd1;
                        end
                    endcase
                end

                7'b0011110: begin  // writedata(0x88);
                    case (writeCycle)
                        3'b000: begin
                            writeCycle <= writeCycle + 3'd1;
                            command   <= 1'd1;
                            dataBus   <= 16'h0088;
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
                        end
                        3'b111: begin
                            writeCycle <= 3'd0;
                            bootStage  <= bootStage + 7'd1;
                        end
                    endcase
                end

                7'b0011111: begin  // writedata(0x32);
                    case (writeCycle)
                        3'b000: begin
                            writeCycle <= writeCycle + 3'd1;
                            command   <= 1'd1;
                            dataBus   <= 16'h0032;
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
                        end
                        3'b111: begin
                            writeCycle <= 3'd0;
                            bootStage  <= bootStage + 7'd1;
                        end
                    endcase
                end

                7'b0100000: begin  // writedata(0x0f);
                    case (writeCycle)
                        3'b000: begin
                            writeCycle <= writeCycle + 3'd1;
                            command   <= 1'd1;
                            dataBus   <= 16'h000F;
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
                        end
                        3'b111: begin
                            writeCycle <= 3'd0;
                            bootStage  <= bootStage + 7'd1;
                        end
                    endcase
                end

                7'b0100001: begin  // writedata(0x10);
                    case (writeCycle)
                        3'b000: begin
                            writeCycle <= writeCycle + 3'd1;
                            command   <= 1'd1;
                            dataBus   <= 16'h0010;
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
                        end
                        3'b111: begin
                            writeCycle <= 3'd0;
                            bootStage  <= bootStage + 7'd1;
                        end
                    endcase
                end

                7'b0100010: begin  // writedata(0x06);
                    case (writeCycle)
                        3'b000: begin
                            writeCycle <= writeCycle + 3'd1;
                            command   <= 1'd1;
                            dataBus   <= 16'h0006;
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
                        end
                        3'b111: begin
                            writeCycle <= 3'd0;
                            bootStage  <= bootStage + 7'd1;
                        end
                    endcase
                end

                7'b0100011: begin  // writedata(0x0f);
                    case (writeCycle)
                        3'b000: begin
                            writeCycle <= writeCycle + 3'd1;
                            command   <= 1'd1;
                            dataBus   <= 16'h000F;
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
                        end
                        3'b111: begin
                            writeCycle <= 3'd0;
                            bootStage  <= bootStage + 7'd1;
                        end
                    endcase
                end

                7'b0100100: begin  // writedata(0x07);
                    case (writeCycle)
                        3'b000: begin
                            writeCycle <= writeCycle + 3'd1;
                            command   <= 1'd1;
                            dataBus   <= 16'h0007;
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
                        end
                        3'b111: begin
                            writeCycle <= 3'd0;
                            bootStage  <= bootStage + 7'd1;
                        end
                    endcase
                end

                7'b0100101: begin  // writedata(0x00);
                    case (writeCycle)
                        3'b000: begin
                            writeCycle <= writeCycle + 3'd1;
                            command   <= 1'd1;
                            dataBus   <= 16'h0000;
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
                        end
                        3'b111: begin
                            writeCycle <= 3'd0;
                            bootStage  <= bootStage + 7'd1;
                        end
                    endcase
                end

                7'b0100110: begin  // writecommand(0xE1);        // NGAMCTRL (Negative Gamma Control)
                    case (writeCycle)
                        3'b000: begin
                            writeCycle <= writeCycle + 3'd1;
                            command   <= 1'd0;
                            dataBus   <= 16'h00E1;
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
                        end
                        3'b111: begin
                            writeCycle <= 3'd0;
                            bootStage  <= bootStage + 7'd1;
                        end
                    endcase
                end

                7'b0100111: begin  // writedata(0x0F);
                    case (writeCycle)
                        3'b000: begin
                            writeCycle <= writeCycle + 3'd1;
                            command   <= 1'd1;
                            dataBus   <= 16'h000F;
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
                        end
                        3'b111: begin
                            writeCycle <= 3'd0;
                            bootStage  <= bootStage + 7'd1;
                        end
                    endcase
                end

                7'b0101000: begin  // writedata(0x38);
                    case (writeCycle)
                        3'b000: begin
                            writeCycle <= writeCycle + 3'd1;
                            command   <= 1'd1;
                            dataBus   <= 16'h0038;
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
                        end
                        3'b111: begin
                            writeCycle <= 3'd0;
                            bootStage  <= bootStage + 7'd1;
                        end
                    endcase
                end

                7'b0101001: begin  // writedata(0x30);
                    case (writeCycle)
                        3'b000: begin
                            writeCycle <= writeCycle + 3'd1;
                            command   <= 1'd1;
                            dataBus   <= 16'h0030;
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
                        end
                        3'b111: begin
                            writeCycle <= 3'd0;
                            bootStage  <= bootStage + 7'd1;
                        end
                    endcase
                end

                7'b0101010: begin  // writedata(0x09);
                    case (writeCycle)
                        3'b000: begin
                            writeCycle <= writeCycle + 3'd1;
                            command   <= 1'd1;
                            dataBus   <= 16'h0009;
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
                        end
                        3'b111: begin
                            writeCycle <= 3'd0;
                            bootStage  <= bootStage + 7'd1;
                        end
                    endcase
                end

                7'b0101011: begin  // writedata(0x0f);
                    case (writeCycle)
                        3'b000: begin
                            writeCycle <= writeCycle + 3'd1;
                            command   <= 1'd1;
                            dataBus   <= 16'h000F;
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
                        end
                        3'b111: begin
                            writeCycle <= 3'd0;
                            bootStage  <= bootStage + 7'd1;
                        end
                    endcase
                end

                7'b0101100: begin  // writedata(0x0f);
                    case (writeCycle)
                        3'b000: begin
                            writeCycle <= writeCycle + 3'd1;
                            command   <= 1'd1;
                            dataBus   <= 16'h000F;
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
                        end
                        3'b111: begin
                            writeCycle <= 3'd0;
                            bootStage  <= bootStage + 7'd1;
                        end
                    endcase
                end

                7'b0101101: begin  // writedata(0x4e);
                    case (writeCycle)
                        3'b000: begin
                            writeCycle <= writeCycle + 3'd1;
                            command   <= 1'd1;
                            dataBus   <= 16'h004E;
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
                        end
                        3'b111: begin
                            writeCycle <= 3'd0;
                            bootStage  <= bootStage + 7'd1;
                        end
                    endcase
                end

                7'b0101110: begin  // writedata(0x77);
                    case (writeCycle)
                        3'b000: begin
                            writeCycle <= writeCycle + 3'd1;
                            command   <= 1'd1;
                            dataBus   <= 16'h0077;
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
                        end
                        3'b111: begin
                            writeCycle <= 3'd0;
                            bootStage  <= bootStage + 7'd1;
                        end
                    endcase
                end

                7'b0101111: begin  // writedata(0x3c);
                    case (writeCycle)
                        3'b000: begin
                            writeCycle <= writeCycle + 3'd1;
                            command   <= 1'd1;
                            dataBus   <= 16'h003C;
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
                        end
                        3'b111: begin
                            writeCycle <= 3'd0;
                            bootStage  <= bootStage + 7'd1;
                        end
                    endcase
                end

                7'b0110000: begin  // writedata(0x07);
                    case (writeCycle)
                        3'b000: begin
                            writeCycle <= writeCycle + 3'd1;
                            command   <= 1'd1;
                            dataBus   <= 16'h0007;
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
                        end
                        3'b111: begin
                            writeCycle <= 3'd0;
                            bootStage  <= bootStage + 7'd1;
                        end
                    endcase
                end

                7'b0110001: begin  // writedata(0x10);
                    case (writeCycle)
                        3'b000: begin
                            writeCycle <= writeCycle + 3'd1;
                            command   <= 1'd1;
                            dataBus   <= 16'h0010;
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
                        end
                        3'b111: begin
                            writeCycle <= 3'd0;
                            bootStage  <= bootStage + 7'd1;
                        end
                    endcase
                end

                7'b0110010: begin  // writedata(0x05);
                    case (writeCycle)
                        3'b000: begin
                            writeCycle <= writeCycle + 3'd1;
                            command   <= 1'd1;
                            dataBus   <= 16'h0005;
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
                        end
                        3'b111: begin
                            writeCycle <= 3'd0;
                            bootStage  <= bootStage + 7'd1;
                        end
                    endcase
                end

                7'b0110011: begin  // writedata(0x23);
                    case (writeCycle)
                        3'b000: begin
                            writeCycle <= writeCycle + 3'd1;
                            command   <= 1'd1;
                            dataBus   <= 16'h0023;
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
                        end
                        3'b111: begin
                            writeCycle <= 3'd0;
                            bootStage  <= bootStage + 7'd1;
                        end
                    endcase
                end

                7'b0110100: begin  // writedata(0x1b);
                    case (writeCycle)
                        3'b000: begin
                            writeCycle <= writeCycle + 3'd1;
                            command   <= 1'd1;
                            dataBus   <= 16'h001B;
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
                        end
                        3'b111: begin
                            writeCycle <= 3'd0;
                            bootStage  <= bootStage + 7'd1;
                        end
                    endcase
                end

                7'b0110101: begin  // writedata(0x00);
                    case (writeCycle)
                        3'b000: begin
                            writeCycle <= writeCycle + 3'd1;
                            command   <= 1'd1;
                            dataBus   <= 16'h0000;
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
                        end
                        3'b111: begin
                            writeCycle <= 3'd0;
                            bootStage  <= bootStage + 7'd1;
                        end
                    endcase
                end

                7'b0110110: begin  // writecommand(0x20);        // Display Inversion OFF, 0x21 = ON
                    case (writeCycle)
                        3'b000: begin
                            writeCycle <= writeCycle + 3'd1;
                            command   <= 1'd0;
                            dataBus   <= 16'h0020;
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
                        end
                        3'b111: begin
                            writeCycle <= 3'd0;
                            bootStage  <= bootStage + 7'd1;
                        end
                    endcase
                end

                7'b0110111: begin  // writecommand(0x36);        // Memory Access Control
                    case (writeCycle)
                        3'b000: begin
                            writeCycle <= writeCycle + 3'd1;
                            command   <= 1'd0;
                            dataBus   <= 16'h0036;
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
                        end
                        3'b111: begin
                            writeCycle <= 3'd0;
                            bootStage  <= bootStage + 7'd1;
                        end
                    endcase
                end

                7'b0111000: begin  // writedata(0x0A);
                    case (writeCycle)
                        3'b000: begin
                            writeCycle <= writeCycle + 3'd1;
                            command   <= 1'd1;
                            dataBus   <= 16'h000A;
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
                        end
                        3'b111: begin
                            writeCycle <= 3'd0;
                            bootStage  <= bootStage + 7'd1;
                        end
                    endcase
                end

                7'b0111001: begin  // writecommand(0x3A);        // Interface Pixel Format
                    case (writeCycle)
                        3'b000: begin
                            writeCycle <= writeCycle + 3'd1;
                            command   <= 1'd0;
                            dataBus   <= 16'h003A;
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
                        end
                        3'b111: begin
                            writeCycle <= 3'd0;
                            bootStage  <= bootStage + 7'd1;
                        end
                    endcase
                end

                7'b0111010: begin  // writedata(0x55);
                    case (writeCycle)
                        3'b000: begin
                            writeCycle <= writeCycle + 3'd1;
                            command   <= 1'd1;
                            dataBus   <= 16'h0055;
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
                        end
                        3'b111: begin
                            writeCycle <= 3'd0;
                            bootStage  <= bootStage + 7'd1;
                        end
                    endcase
                end

                7'b0111011: begin  // writecommand(0x11);
                    case (writeCycle)
                        3'b000: begin
                            writeCycle <= writeCycle + 3'd1;
                            command   <= 1'd0;
                            dataBus   <= 16'h0011;
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
                        end
                        3'b111: begin
                            writeCycle <= 3'd0;
                            bootStage  <= bootStage + 7'd1;
                        end
                    endcase
                end

                7'b0111100: begin  // delay(150);  (~150 ms)
                    if (delay < 22'd40) begin // changed 4050000
                        delay <= delay + 22'd1;
                    end else begin
                        delay <= 22'd0;
                        bootStage <= bootStage + { 7{1'b0} } + 7'd1;
                    end
                end

                7'b0111101: begin  // writecommand(0x29);
                    case (writeCycle)
                        3'b000: begin
                            writeCycle <= writeCycle + 3'd1;
                            command   <= 1'd0;
                            dataBus   <= 16'h0029;
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
                        end
                        3'b111: begin
                            writeCycle <= 3'd0;
                            bootStage  <= bootStage + 7'd1;
                        end
                    endcase
                end
                7'b0111110: begin // Column Address Command
                    case (writeCycle)
                        3'b000: begin
                            command   <= 1'd0;
                            writeCycle <= writeCycle + 3'd1;
                            dataBus <= 16'h002A;
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
                        end
                        3'b111: begin
                            writeCycle <= 3'd0;
                            bootStage <= bootStage+1;
                            command <= 1'd1;
                        end
                    endcase
                end
                7'b0111111: begin // Column Address High Byte
                    case (writeCycle)
                        3'b000: begin
                            command   <= 1'd1;
                            writeCycle <= writeCycle + 3'd1;
                            dataBus <= 16'h0000;
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
                        end
                        3'b111: begin
                            writeCycle <= 3'd0;
                            bootStage <= bootStage+1;
                        end
                    endcase
                end
                7'b1000000: begin // Column Address Low Byte
                    case (writeCycle)
                        3'b000: begin
                            writeCycle <= writeCycle + 3'd1;
                            dataBus <= 16'h0000;
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
                        end
                        3'b111: begin
                            writeCycle <= 3'd0;
                            bootStage <= bootStage+1;
                        end
                    endcase
                end
                7'b1000001: begin // Column Address End High Byte
                    case (writeCycle)
                        3'b000: begin
                            writeCycle <= writeCycle + 3'd1;
                            dataBus <= 16'h0001;
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
                        end
                        3'b111: begin
                            writeCycle <= 3'd0;
                            bootStage <= bootStage+1;
                        end
                    endcase
                end
                7'b1000010: begin // Column Address End Low Byte
                    case (writeCycle)
                        3'b000: begin
                            writeCycle <= writeCycle + 3'd1;
                            dataBus <= 16'h00DF;
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
                        end
                        3'b111: begin
                            writeCycle <= 3'd0;
                            bootStage <= bootStage+1;
                            command <= 1'd0;
                        end
                    endcase
                end
                7'b1000011: begin // Row Address Command
                    case (writeCycle)
                        3'b000: begin
                            command   <= 1'd0;
                            writeCycle <= writeCycle + 3'd1;
                            dataBus <= 16'h002B;
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
                        end
                        3'b111: begin
                            writeCycle <= 3'd0;
                            bootStage <= bootStage+1;
                            command <= 1'd1;
                        end
                    endcase
                end
                7'b1000100: begin // Row Address High Byte
                    case (writeCycle)
                        3'b000: begin
                            command   <= 1'd1;
                            writeCycle <= writeCycle + 3'd1;
                            dataBus <= 16'h0000;
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
                        end
                        3'b111: begin
                            writeCycle <= 3'd0;
                            bootStage <= bootStage+1;
                        end
                    endcase
                end
                7'b1000101: begin // Row Address Low Byte
                    case (writeCycle)
                        3'b000: begin
                            writeCycle <= writeCycle + 3'd1;
                            dataBus <= 16'h0000;
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
                        end
                        3'b111: begin
                            writeCycle <= 3'd0;
                            bootStage <= bootStage+1;
                        end
                    endcase
                end
                7'b1000110: begin // Row Address End High Byte
                    case (writeCycle)
                        3'b000: begin
                            writeCycle <= writeCycle + 3'd1;
                            dataBus <= 16'h0001;
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
                        end
                        3'b111: begin
                            writeCycle <= 3'd0;
                            bootStage <= bootStage+1;
                        end
                    endcase
                end
                7'b1000111: begin // Row Address End Low Byte
                    case (writeCycle)
                        3'b000: begin
                            writeCycle <= writeCycle + 3'd1;
                            dataBus <= 16'h003F;
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
                        end
                        3'b111: begin
                            writeCycle <= 3'd0;
                            bootStage <= bootStage+1;
                            command <= 1'd0;
                        end
                    endcase
                end
                7'b1001000: begin  // delay(25);  (~25 ms)
                    if (delay < 22'd67) begin // changed 675000
                        delay <= delay + 22'd1;
                    end else begin
                        delay <= 22'd0;
                        bootStage <= bootStage + { 7{1'b0} } + 7'd1;
                        boot <= 1'd0;
                    end
                end
            endcase
        end else begin
            if (!frameStarted) begin
                case (writeCycle) // Write Command
                    3'b000: begin
                        command   <= 1'd0;
                        writeCycle <= writeCycle + 3'd1;
                        dataBus <= 16'h002C;
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
                    end
                    3'b111: begin
                        writeCycle <= 3'd0;
                        frameStarted <= 1'd1;
                        command <= 1'd1;
                    end
                endcase
            end else begin
                if (pixels < 18'd153600) begin
                    case (writeCycle)
                        3'b000: begin
                            extraStatus <= 1'd0;
                            command <= 1'd1;
                            writeCycle <= writeCycle + 1;
                            dataBus <= 16'hF800;
                        end
                        3'b001: begin
                            writeCycle <= writeCycle + 1;
                        end
                        3'b010: begin
                            write <= 1'd0;
                            writeCycle <= writeCycle + 1;
                        end
                        3'b011: begin 
                            writeCycle <= writeCycle + 1;
                        end
                        3'b100: begin
                            writeCycle <= writeCycle + 1;
                        end
                        3'b101: begin
                            write <= 1'd1;
                            writeCycle <= writeCycle + 1;
                        end
                        3'b110: begin
                            writeCycle <= writeCycle + 1;
                        end
                        3'b111: begin
                            pixels <= pixels + 18'd1;
                            writeCycle <= 3'd0;
                        end
                    endcase
                end
            end
        end
    end
endmodule