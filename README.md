# HiLetgoDriver
## ILI9486 FPGA Display Controller + Parallel Rasterizer
### Features:
- ILI9486 LCD display controller in Verilog by reverse-engineering protocols from microcontroller C in absence of FPGA-based reference design
- 72 stage init, command/data handling, and full pixel stream
- 6.8 MB/s throughput, 4x higher than optimized microcontroller drivers
- Row framebuffer strategies and parallel, memory-mapped rasterization cut expected BRAM usage by 32x from typical framebuffer systems
