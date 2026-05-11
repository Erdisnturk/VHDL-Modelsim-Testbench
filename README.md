# VHDL-Modelsim-Testbench

## Overview

This project demonstrates the implementation and simulation of a VHDL datapath architecture using a custom testbench in Vivado/ModelSim.

The design includes:
- Arithmetic Logic Unit (ALU)
- Register modules
- Multiplexer
- Structural datapath
- VHDL testbench for functional verification

---

## Features

- 100 MHz clock generation
- Active-high reset signal
- Opcode interpreter
- ALU operation testing
- Jump instruction handling
- Behavioral simulation in Vivado

---

## Implemented Instructions

| Opcode | Operation |
|--------|------------|
| 0000 | ADD |
| 0001 | SUB |
| 0010 | OR |
| 0011 | AND |
| 0100 | XOR |
| 0101 | NOT |
| 0110 | SHR |
| 0111 | SHL |
| 1000 | LD1 |
| 1001 | LD2 |
| 1010 | JMP |

---

## Simulation

The testbench:
- generates a 100 MHz clock,
- applies reset for the first 100 ns,
- loads instructions from a predefined instruction array,
- drives the datapath control signals,
- verifies ALU functionality through waveform analysis.

---

## Tools

- Vivado 2025.2
- VHDL
- ModelSim/XSim simulation

---

## Author

Erdi Şentürk
Karlsruhe Institute of Technology (KIT)
