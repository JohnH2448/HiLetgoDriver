commands = [
    "writecommand(0x01)",
    "writedata(0x00)",
    "delay(50)",
    "writecommand(0x28)",
    "writedata(0x00)",
    "writecommand(0xC0)",
    "writedata(0x0d)",
    "writedata(0x0d)",
    "writecommand(0xC1)",
    "writedata(0x43)",
    "writedata(0x00)",
    "writecommand(0xC2)",
    "writedata(0x00)",
    "writecommand(0xC5)",
    "writedata(0x00)",
    "writedata(0x48)",
    "writecommand(0xB6)",
    "writedata(0x00)",
    "writedata(0x22)",
    "writedata(0x3B)",
    "writecommand(0xE0)",
    "writedata(0x0f)",
    "writedata(0x24)",
    "writedata(0x1c)",
    "writedata(0x0a)",
    "writedata(0x0f)",
    "writedata(0x08)",
    "writedata(0x43)",
    "writedata(0x88)",
    "writedata(0x32)",
    "writedata(0x0f)",
    "writedata(0x10)",
    "writedata(0x06)",
    "writedata(0x0f)",
    "writedata(0x07)",
    "writedata(0x00)",
    "writecommand(0xE1)",
    "writedata(0x0F)",
    "writedata(0x38)",
    "writedata(0x30)",
    "writedata(0x09)",
    "writedata(0x0f)",
    "writedata(0x0f)",
    "writedata(0x4e)",
    "writedata(0x77)",
    "writedata(0x3c)",
    "writedata(0x07)",
    "writedata(0x10)",
    "writedata(0x05)",
    "writedata(0x23)",
    "writedata(0x1b)",
    "writedata(0x00)",
    "writecommand(0x20)",
    "writecommand(0x36)",
    "writedata(0x0A)",
    "writecommand(0x3A)",
    "writedata(0x55)",
    "writecommand(0x11)",
    "delay(150)",
    "writecommand(0x29)",
    "delay(25)",
    "writecommand(0x2A)",
    "writedata(0x00)",
    "writedata(0x00)",
    "writedata(0x01)",
    "writedata(0xDF)",
    "writecommand(0x2B)",
    "writedata(0x00)",
    "writedata(0x00)",
    "writedata(0x01)",
    "writedata(0x3F)",
    "delay(150)"
]
state = 0b0000010
delays = {}

with open("output.txt", "w") as f:
    for cmd in commands:
        s = format(state, "07b")
        if cmd.startswith("writecommand") or cmd.startswith("writedata"):
            f.write(f"7'b{s}: begin\n")

        if cmd.startswith("writecommand"):
            val = cmd[13:-1]     # extract 0xXX
            f.write("    command <= 1'd0;\n")
            f.write(f"    dataBus <= 16'h{val[2:]};\n")

        elif cmd.startswith("writedata"):
            val = cmd[10:-1]
            f.write("    command <= 1'd1;\n")
            f.write(f"    dataBus <= 16'h{val[2:]};\n")

        elif cmd.startswith("delay"):
            delays[f"7'b{s}"] = int(cmd[6:-1])

        if cmd.startswith("writecommand") or cmd.startswith("writedata"):
            f.write("end\n\n")
        state += 1
