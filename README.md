ILI9486 FPGA Driver

A fully custom 16-bit 8080-style parallel LCD controller for the ILI9486 display, written entirely in Verilog. This project reverse-engineers the initialization sequence, command set, and bus timing from microcontroller libraries due to the absence of FPGA-based implementations.

Features

Complete ILI9486 initialization pipeline (reset, power-up, timing, register configuration)

16-bit parallel data interface with safe write-cycle timing

Command/data mode control (DCX), chip-select handling, and deterministic WR strobes

Continuous pixel-stream renderer for full-frame updates

Parameterized state machines for boot, command dispatch, and pixel output

Verified at ~6.8 MB/s sustained throughput (≈3–6× faster than MCU drivers on the same bus)

Architecture Overview

The design consists of:

Boot/Init FSM — performs reset handling and sequentially issues all ILI9486 initialization commands

Command/Data Engine — handles DCX, CSX, WRX timing and 8080 write formatting

Pixel Pipeline — streams pixel data continuously during memory-write mode

Data Bus Module — 16-bit output register mapped to FPGA pins via constraints

The controller targets ~27 MHz fabric clock with an 8-cycle write unit, providing stable timing closure on low-cost FPGAs.

Hardware Requirements

FPGA board with at least 20–22 GPIO pins

3.3V logic compatibility

ILI9486 LCD (parallel 8080 interface variant)
