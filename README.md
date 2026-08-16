# sync-fifo-verilog
# Synchronous FIFO

A parameterized synchronous FIFO implemented in Verilog RTL, with testbench verification, VCD waveform generation, Yosys synthesis, and SVG netlist visualization.

## Features

* 8-depth × 16-bit FIFO
* Synchronous read/write operation
* Read and write pointer management
* Full and empty flag generation
* Active-low reset
* Protection against read when empty and write when full

## Verification

The testbench verifies:

* Reset and initial FIFO status
* Single and multiple data writes
* Data readback and FIFO ordering
* Filling the FIFO to full
* Write attempt when FIFO is full
* Reading data from a full FIFO
* Reading until the FIFO becomes empty
* Read attempt when FIFO is empty
* Simultaneous read and write operation
* Reset while the FIFO contains data

The testbench reports **PASS/FAIL** for each test and generates a `fifo_sync.vcd` waveform for simulation analysis.

## Synthesis & Visualization

Yosys is used to synthesize the RTL and generate a JSON netlist. The design is also converted into an SVG representation for visualizing the synthesized logic.

### Files

* `fifo_sync.v` — FIFO RTL
* `fifo_sync_tb.v` — Testbench
* `fifo_sync.vcd` — Simulation waveform
* `fifo_sync.json` — Yosys netlist
* `fifo_sync.svg` — Netlist visualization
* `fifo_sim` — Simulation executable
* `svg commands` — SVG generation commands
