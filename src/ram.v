module ramLine (
    input wire clock,
    input wire [8:0] readAddress,
    output reg  [15:0] readData,
    input wire [8:0]  writeAddress,
    input wire [15:0] writeData,
    input wire writeEnable
);

    reg [15:0] mem [0:479];

    always @(posedge clock) begin
        if (writeEnable)
            mem[writeAddress] <= writeData;
    end

    always @(posedge clock) begin
        readData <= mem[readAddress];
    end

endmodule