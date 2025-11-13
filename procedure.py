#!/usr/bin/env python3
import re
from textwrap import indent

# ========= CONFIG =========
CLK_HZ = 27_000_000        # FPGA clock frequency (edit if needed)
STAGE_BITS = 7             # bootStage width (reg [STAGE_BITS-1:0] bootStage)
START_STAGE = 2           # first stage index to use
OUTPUT_FILE = "init_sequence.vh"
DELAY_COUNTER_WIDTH = 22   # width of 'delay' register in HDL
# ==========================

# Raw command script exactly as given
INIT_SCRIPT = r"""
writecommand(0x01);
writedata(0x00);
delay(50);

writecommand(0x28);
writedata(0x00);

writecommand(0xC0);        // Power Control 1
writedata(0x0d);
writedata(0x0d);

writecommand(0xC1);        // Power Control 2
writedata(0x43);
writedata(0x00);

writecommand(0xC2);        // Power Control 3
writedata(0x00);

writecommand(0xC5);        // VCOM Control
writedata(0x00);
writedata(0x48);

writecommand(0xB6);        // Display Function Control
writedata(0x00);
writedata(0x22);           // 0x42 = Rotate display 180 deg.
writedata(0x3B);

writecommand(0xE0);        // PGAMCTRL (Positive Gamma Control)
writedata(0x0f);
writedata(0x24);
writedata(0x1c);
writedata(0x0a);
writedata(0x0f);
writedata(0x08);
writedata(0x43);
writedata(0x88);
writedata(0x32);
writedata(0x0f);
writedata(0x10);
writedata(0x06);
writedata(0x0f);
writedata(0x07);
writedata(0x00);

writecommand(0xE1);        // NGAMCTRL (Negative Gamma Control)
writedata(0x0F);
writedata(0x38);
writedata(0x30);
writedata(0x09);
writedata(0x0f);
writedata(0x0f);
writedata(0x4e);
writedata(0x77);
writedata(0x3c);
writedata(0x07);
writedata(0x10);
writedata(0x05);
writedata(0x23);
writedata(0x1b);
writedata(0x00); 

writecommand(0x20);        // Display Inversion OFF, 0x21 = ON

writecommand(0x36);        // Memory Access Control
writedata(0x0A);

writecommand(0x3A);        // Interface Pixel Format
writedata(0x55); 

writecommand(0x11);

delay(150);

writecommand(0x29);
delay(25);
"""

def parse_init_script(src: str):
    """
    Parse the text into a list of events:
    ("cmd",  value, original_line)
    ("data", value, original_line)
    ("delay", ms,  original_line)
    """
    events = []
    for raw in src.splitlines():
        line = raw.strip()
        if not line or line.startswith("//"):
            continue

        if line.startswith("writecommand"):
            m = re.search(r"0x([0-9A-Fa-f]+)", line)
            if not m:
                continue
            val = int(m.group(1), 16)
            events.append(("cmd", val, raw.rstrip()))
        elif line.startswith("writedata"):
            m = re.search(r"0x([0-9A-Fa-f]+)", line)
            if not m:
                continue
            val = int(m.group(1), 16)
            events.append(("data", val, raw.rstrip()))
        elif line.startswith("delay"):
            m = re.search(r"\((\d+)\)", line)
            if not m:
                continue
            ms = int(m.group(1))
            events.append(("delay", ms, raw.rstrip()))
        else:
            # ignore anything else
            continue
    return events

def hex16_low_byte(value: int) -> str:
    """
    Return a Verilog 16-bit hex literal with the byte
    in the *lower* 8 bits: 16'h00XX.
    """
    b = value & 0xFF
    return f"16'h00{b:02X}"

def delay_cycles_from_ms(ms: int) -> int:
    """
    Convert milliseconds to clock cycles, as an int.
    """
    return int(round(CLK_HZ * (ms / 1000.0)))


def emit_write_stage(stage_idx: int, kind: str, value: int, src_line: str) -> str:
    """
    Emit a bootStage block for a single write (command or data),
    using an 8-state writeCycle sequence.

    kind: "cmd" or "data"
    """
    stage_bits = STAGE_BITS
    stage_const = f"{stage_bits}'b{stage_idx:0{stage_bits}b}"
    data_literal = hex16_low_byte(value)
    is_command = (kind == "cmd")
    cmd_bit = "1'd0" if is_command else "1'd1"
    comment = f"// {src_line.strip()}"

    body = f"""
{stage_const}: begin  {comment}
    case (writeCycle)
        3'b000: begin
            writeCycle <= writeCycle + 3'd1;
            command   <= {cmd_bit};
            dataBus   <= {data_literal};
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
        3'b106: begin
            writeCycle <= writeCycle + 3'd1;
        end
        3'b111: begin
            writeCycle <= 3'd0;
            bootStage  <= bootStage + {stage_bits}'d1;
        end
    endcase
end
"""
    body = body.replace("3'b106", "3'b110")
    return body


def emit_delay_stage(stage_idx: int, ms: int, src_line: str) -> str:
    """
    Emit a bootStage block that waits for 'delay' to reach
    the needed number of cycles, then advances bootStage.
    """
    stage_bits = STAGE_BITS
    stage_const = f"{stage_bits}'b{stage_idx:0{stage_bits}b}"
    cycles = delay_cycles_from_ms(ms)

    # Fit into the chosen DELAY_COUNTER_WIDTH
    max_count = (1 << DELAY_COUNTER_WIDTH) - 1
    if cycles > max_count:
        print(f"WARNING: delay({ms} ms) = {cycles} cycles does not fit "
              f"in {DELAY_COUNTER_WIDTH} bits (max {max_count}). "
              f"It will be truncated.")
        cycles = max_count

    comment = f"// {src_line.strip()}  (~{ms} ms)"

    body = f"""
{stage_const}: begin  {comment}
    if (delay < {DELAY_COUNTER_WIDTH}'d{cycles}) begin
        delay <= delay + {DELAY_COUNTER_WIDTH}'d1;
    end else begin
        delay <= {DELAY_COUNTER_WIDTH}'d0;
        bootStage <= bootStage + {{ {stage_bits}{{1'b0}} }} + {stage_bits}'d1;
    end
end
"""
    return body


def main():
    events = parse_init_script(INIT_SCRIPT)

    stage_idx = START_STAGE
    blocks = []

    for kind, val, src in events:
        if kind in ("cmd", "data"):
            blocks.append(emit_write_stage(stage_idx, kind, val, src))
            stage_idx += 1
        elif kind == "delay":
            blocks.append(emit_delay_stage(stage_idx, val, src))
            stage_idx += 1

    header = f"""// Auto-generated init sequence
// Clock: {CLK_HZ} Hz
// bootStage bits: {STAGE_BITS} (reg [{STAGE_BITS-1}:0] bootStage)
// delay counter bits: {DELAY_COUNTER_WIDTH} (reg [{DELAY_COUNTER_WIDTH-1}:0] delay)
// Generated from INIT_SCRIPT by this Python script.

case (bootStage)
"""

    footer = """
    default: begin
        // stay here or handle error
    end
endcase
"""

    full_text = header + "".join(blocks) + footer

    with open(OUTPUT_FILE, "w") as f:
        f.write(full_text)

    print(f"Wrote {stage_idx - START_STAGE} stages to {OUTPUT_FILE}")


if __name__ == "__main__":
    main()
