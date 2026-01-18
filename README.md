# Quantum Emulato (QEMU)
### FPGA- Based Emulator for Quantum Processing Systems
## Overview
This project focuses on the design and implementation of and FPGA-based emulator for quantum processing systems, targeting classical emulation of quantum algorithms through custom digital hardware.

The emulator is intended to execute quantum algorithms described in a custom C/C++ program, which is loaded into the FPGA via JTAG, and then interpreted and executed by dedicated hardware modules designed in VHDL.

This work is developed as part of a Master's degree research thesis, with and emphasis on hardware architectures, numerical representations, and scalable linerar algebra operations relevant to quantum computation.
## Objectives
*General: * Design an emulator for a quantum processing system based on an FPGA,
capable of executing and verifying basic quantum algorithms, with a high-level interface for C/C++ programmers.

1. Design the architecture of the quantum processing system that allows the representation and manipulation of quantum states.
2. Integrate the quantum processor and control system to execute the control flow, configure and synthesize the quantum circuits, and store the results.
3. Develop a C/C++ library that allows the description of quantum circuits and algorithms.
4. Evaluate design metrics, such as latency, throughput, and area resource utilization, for different quantum circuits and the number of qubits.

## Target Platform
* FPGA: Altera/ Intel Cyclone IV
  * Device: EP4CE115F29C7
* Toolchain: Quartus Prime 18.0
* Language: VHDL
* Programming Interface: JTAG (for loading C/C++ programs)

## Project Scope
This repository currently focuses on the numerical and arithmetic foundations of the emulator, which are critical for efficient quantum state evolution

Higher-level components such as:
* Instruction decoding
* Quantum gate Scheduling
* Memory hierarchy
* and full algoritm execution
Are out of scope for the current stage and will be developed incrementally.

## Current status
Stage: Early development/foundational libraries

Implemented so far:
* Custom extended integer numeric format
* Complex number arithmetic library
* Hardware modules for:
  * Complex multiplication
  * vector-vector multiplication
  * matrix-vector multiplication
Some testbenches are still incomplete and under active development

## Repository structure
```text
libraries/
├── cmpx_lib/
│   ├── src/
│   │   ├── cmpx_dot_mult.vhd
│   │   ├── cmpx_mult.vhd
│   │   ├── cmpx_pkg.vhd
│   │   └── mult_mtx_vect.vhd
│   └── tests/
│       └── tbmult_mtx_vect.vhd   (incomplete)
│
└── int_ext_lib/
    ├── src/
    │   ├── int_ext_mult.vhd
    │   └── int_ext_pkg.vhd
```

## Design Philosop[hy
* Modularity: All arithmetic blocks are implemented as reusable VHDL libraries
* Explicit numeric control: Custom number formats are preferred over floating-point to allow deterministic behavior and architectural exploration.
* Scalability: The design targets future extension toward larger quantum systems and more complex linear algebra operations.
* Research-oriented: Readability, traceability, and correctness are prioritized over aggressive optimization at this stage

## Intended Audience
* Researchers and students interested in quantum computing emulation
* FPGA and digital design engineers
* Graduate-level academic evaluators
* Recruiters seeking experience in:
  * VHDL
  * hardware arithmetic
  * FPGA-based system design

## Future work
Planned extensions include:
* Completition of verification testbenchs
* Instruction set definition for quantum algorithm execution
* C/C++ to hardware interface over JTAG
* Control unit and execution pipeline
* Performance and resource utilization analysis
