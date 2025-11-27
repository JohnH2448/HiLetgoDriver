module renderer (
    input wire clock,
    output reg start,
    input wire busy,
    output reg [8:0] writeAddress,
    input wire [15:0] writeData,
    output reg writeEnable,
    input wire [8:0] yCoord
);

    reg [24:0] delayCount;
    reg delayDone;
    reg [1:0] rowWrite;
    reg [8:0] xCoord;
    wire [8:0] xLowerVertex1;
    wire [8:0] yLowerVertex1;
    wire [8:0] xUpperVertex1;
    wire [8:0] yUpperVertex1;

    // Line Vertex Memory
    reg [17:0] mem [9:0];
    assign xLowerVertex1 = mem[0][8:0];
    assign yLowerVertex1 = mem[0][17:9];
    assign xUpperVertex1 = mem[1][8:0];
    assign yUpperVertex1 = mem[1][17:9];

    // dx, dy (direction)
    wire signed [9:0] dx;
    wire signed [9:0] dy;

    // offsets
    wire signed [9:0] rx;
    wire signed [9:0] ry;

    // implicit line function
    wire signed [19:0] F;
    wire signed [19:0] Fabs;

    // bounding box
    wire inside_box;

    // final pixel indicator
    wire linePixel;

    assign dx = xUpperVertex1 - xLowerVertex1;
    assign dy = yUpperVertex1 - yLowerVertex1;

    assign rx = xCoord - xLowerVertex1;
    assign ry = yCoord - yLowerVertex1;

    assign F = dy * rx - dx * ry;
    assign Fabs = (F < 0) ? -F : F;

    assign inside_box =
        (xCoord >= (xLowerVertex1 < xUpperVertex1 ? xLowerVertex1 : xUpperVertex1)) &&
        (xCoord <= (xLowerVertex1 > xUpperVertex1 ? xLowerVertex1 : xUpperVertex1)) &&
        (yCoord >= (yLowerVertex1 < yUpperVertex1 ? yLowerVertex1 : yUpperVertex1)) &&
        (yCoord <= (yLowerVertex1 > yUpperVertex1 ? yLowerVertex1 : yUpperVertex1));

    assign linePixel = inside_box && (Fabs <= 20'd8);

    initial begin
        delayCount = 25'd0;
        delayDone = 1'd0;
        start = 1'd0;
        writeAddress = 9'd0;
        writeEnable = 1'd0;
        rowWrite = 2'd0;
    end

    always @(posedge clock) begin
        if (!delayDone) begin
            delayCount <= delayCount + 25'd1;
            if (delayCount == 25'd26999999) begin
                delayDone <= 1;
            end
        end else begin
            case (rowWrite)
                2'd0: begin
                    start <= 1'd1;
                    rowWrite <= 2'd1;
                end
                2'd1: begin
                    start <= 1'd0;
                    rowWrite <= 2'd2;
                end
                2'd2: begin
                    rowWrite <= 2'd3;
                end
            endcase
        end
    end

endmodule