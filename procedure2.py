commands = [
    "writecommand(0x01)",   # Software reset
    "writedata(0x00)",      # Extra ignored byte (SWRESET has no params)
    "delay(50)",            # Wait for internal reset
    "writecommand(0x28)",   # Display OFF
    "writedata(0x00)",      # Ignored param
    "writecommand(0xC0)",   # Power Control 1
    "writedata(0x0d)",      # VRH (reference voltage setting)
    "writedata(0x0d)",      # VRL (reference voltage setting)
    "writecommand(0xC1)",   # Power Control 2
    "writedata(0x43)",      # VGH/VGL ratio / step-up factors
    "writedata(0x00)",      # Additional power tweaks
    "writecommand(0xC2)",   # Power Control 3 (Normal mode)
    "writedata(0x00)",      # Default op-amp current
    "writecommand(0xC5)",   # VCOM Control
    "writedata(0x00)",      # VCOM offset
    "writedata(0x48)",      # VCOM amplitude (prevents flicker)
    "writecommand(0xB6)",   # Display Function Control (scan timings)
    "writedata(0x00)",      # Scan mode / RGB interface
    "writedata(0x22)",      # Porch control / line inversion
    "writedata(0x3B)",      # More porch + timing options
    "writecommand(0xE0)",   # Positive Gamma Correction
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
    "writedata(0x00)",      # End of gamma curve
    "writecommand(0xE1)",   # Negative Gamma Correction
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
    "writedata(0x00)",      # End gamma curve
    "writecommand(0x20)",   # Display inversion OFF (normal polarity)
    "writecommand(0x36)",   # MADCTL: memory access (rotation, RGB/BGR)
    "writedata(0x28)",      # Sets BGR + scan direction
    "writecommand(0x3A)",   # COLMOD: pixel format
    "writedata(0x55)",      # 16-bit RGB565
    "writecommand(0x11)",   # Exit Sleep mode
    "delay(150)",           # Power circuits stabilize
    "writecommand(0x29)",   # Display ON
    "delay(25)",            # Allow first frame timing
    "writecommand(0x2A)",   # CASET (column address set)
    "writedata(0x00)",      # Start column high byte
    "writedata(0x00)",      # Start column low byte = 0
    "writedata(0x01)",      # End column high byte
    "writedata(0xDF)",      # End column low byte = 479 (0x1DF)
    "writecommand(0x2B)",   # PASET (row/page address set)
    "writedata(0x00)",      # Start row high byte
    "writedata(0x00)",      # Start row low byte = 0
    "writedata(0x01)",      # End row high byte
    "writedata(0x3F)",      # End row low byte = 319 (0x13F)
    "delay(150)"            # Stabilize before drawing
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
            f.write("end\n")
        state += 1
