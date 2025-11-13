module top (
    input wire clock,
    output wire [15:0] data,
    output reg command,
    output reg select,
    output reg reset,
    output reg write
);

    reg [15:0] dataBus;
    assign data = dataBus;
    reg boot;
    reg [4:0] bootStage;
    reg [21:0] delay;
    reg [2:0] writeCycle;
    reg frameStarted;
    reg [17:0] pixels;

    initial begin
        boot = 1'd1;
        bootStage = 5'd0;
        delay = 22'd0;
        reset = 1'd0;
        command = 1'd0;
        writeCycle = 3'd0;
        write = 1'd1;
        frameStarted = 1'd0;
        pixels = 18'd0;
        select = 1'b0;
    end

    always @(posedge clock) begin
        if (boot) begin
            case (bootStage)
                5'b00000: begin  // Toggles Reset Line
                    if (delay < 22'd3500000) begin // ~130ms
                            delay <= delay + 22'd1;
                            select <= 1'd0;
                    end else begin
                            bootStage <= bootStage+1;
                            delay <= 22'd0;
                            reset <= 1'd1;
                    end
                end
                5'b00001: begin // delay after reset
                    if (delay < 22'd3500000) begin // ~130ms
                            delay <= delay + 22'd1;
                    end else begin
                            bootStage <= bootStage+1;
                            delay <= 22'd0;
                    end
                end
                5'b00010: begin // Software Reset
                    if (delay < 22'd8) begin
                        case (writeCycle)
                            3'b000: begin
                                writeCycle <= writeCycle + 3'd1;
                                dataBus <= 16'h0100;
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
                            end
                        endcase
                    end
                    if (delay < 22'd300000) begin // ~11ms
                            delay <= delay + 22'd1;
                    end else begin
                            bootStage <= bootStage+1;
                            delay <= 22'd0;
                    end
                end
                5'b00011: begin // Sleep Out
                    if (delay < 22'd8) begin
                        case (writeCycle)
                            3'b000: begin
                                writeCycle <= writeCycle + 3'd1;
                                dataBus <= 16'h1100;
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
                            end
                        endcase
                    end
                    if (delay < 22'd3500000) begin // ~130ms
                            delay <= delay + 22'd1;
                    end else begin
                            bootStage <= bootStage+1;
                            delay <= 22'd0;
                    end
                end
                5'b00100: begin // Pixel Format Set
                    case (writeCycle)
                        3'b000: begin
                            writeCycle <= writeCycle + 3'd1;
                            dataBus <= 16'h3A00;
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
                            bootStage <= bootStage+1;
                            writeCycle <= 3'd0;
                            command <= 1'd1;
                        end
                    endcase
                end
                5'b00101: begin // 16-Bit Pixel Set
                    case (writeCycle)
                        3'b000: begin
                            writeCycle <= writeCycle + 3'd1;
                            dataBus <= 16'h5500;
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
                5'b00110: begin // Column Address Command
                    case (writeCycle)
                        3'b000: begin
                            writeCycle <= writeCycle + 3'd1;
                            dataBus <= 16'h2A00;
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
                5'b00111: begin // Column Address High Byte
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
                5'b01000: begin // Column Address Low Byte
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
                5'b01001: begin // Column Address End High Byte
                    case (writeCycle)
                        3'b000: begin
                            writeCycle <= writeCycle + 3'd1;
                            dataBus <= 16'h0100;
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
                5'b01010: begin // Column Address End Low Byte
                    case (writeCycle)
                        3'b000: begin
                            writeCycle <= writeCycle + 3'd1;
                            dataBus <= 16'hDF00;
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
                5'b01011: begin // Row Address Command
                    case (writeCycle)
                        3'b000: begin
                            writeCycle <= writeCycle + 3'd1;
                            dataBus <= 16'h2B00;
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
                5'b01100: begin // Row Address High Byte
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
                5'b01101: begin // Row Address Low Byte
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
                5'b01110: begin // Row Address End High Byte
                    case (writeCycle)
                        3'b000: begin
                            writeCycle <= writeCycle + 3'd1;
                            dataBus <= 16'h0100;
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
                5'b01111: begin // Row Address End Low Byte
                    case (writeCycle)
                        3'b000: begin
                            writeCycle <= writeCycle + 3'd1;
                            dataBus <= 16'h3F00;
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
                5'b10000: begin // MADCTL Command
                    case (writeCycle)
                        3'b000: begin
                            writeCycle <= writeCycle + 3'd1;
                            dataBus <= 16'h3600;
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
                5'b10001: begin // MADCTL Oriention
                    case (writeCycle)
                        3'b000: begin
                            writeCycle <= writeCycle + 3'd1;
                            dataBus <= 16'h2800;
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
                5'b10010: begin // Display On
                    if (delay < 22'd8) begin
                        case (writeCycle)
                            3'b000: begin
                                writeCycle <= writeCycle + 3'd1;
                                dataBus <= 16'h2900;
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
                            end
                        endcase
                    end
                    if (delay < 22'd300000) begin // ~11ms
                            delay <= delay + 22'd1;
                    end else begin
                            bootStage <= bootStage+1;
                            delay <= 22'd0;
                            boot <= 1'd0;
                    end
                end
            endcase
        end else begin
            if (!frameStarted) begin
                case (writeCycle) // Write Command
                    3'b000: begin
                        writeCycle <= writeCycle + 3'd1;
                        dataBus <= 16'h2C00;
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