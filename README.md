#  Potato Chip I

A RISC-V RI32(I/E)AC core developed on a Mac. 

## Requirements

Those are the requirements to build the simulator: 
 - Xcode 13 
 - Verilator 4.200 (installed with Homebrew)

Those are the additional requirements to run the tests:
 - OCMock 3.X (installed at /Library/Frameworks)

Those are the additional requirements to synthetize to an FPGA: 
 - Ubuntu VM with Vivado 2018
 
Those are recommended programs:
 - Visual Studio Code (to edit verilog files)
 - Scansion by LogicPoet (buggy, but a greatn VCD viewer)
 - RISCV-Tools (installed with Homebrew, to compile RISC-V programs)

## Introduction

This project was developed using Xcode, so to do everything but sinthezise the hardware description you must first open the Xcode project.

## Testing

### Modules

Modules are tested using the Peeler Tests. Every module have a C interface that is wrapped by a module class and the module class has a test class inside the tests group under Peeler. Modules testing makes use of the `UHRTestBench` and `UHRTestBenchScript` classes.
