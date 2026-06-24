# UART_PROTOCOL
This project implements a complete UART  communication subsystem in Verilog HDL. The design includes UART Transmitter, UART Receiver, FIFO buffers, Baud Rate Generator, Interface Circuit, and Transmission Controller. The system was verified using loopback testing, synthesized, implemented, and analyzed for timing closure using Xilinx Vivado. 

Features :

UART Transmitter (8-bit data, 1 start bit, 1 stop bit)
UART Receiver with 16x oversampling
Configurable Baud Rate Generator (9600 bps)
Transmit FIFO Buffer
Receive FIFO Buffer
UART Interface Circuit for CPU communication
TX Controller for automatic FIFO-to-UART transmission
Loopback Verification (tx connected to rx)
Synthesized and Implemented on Xilinx Spartan-7 FPGA
Static Timing Analysis (STA) with timing closure achieved

Architecture :

CPU Interface
      │
      ▼
  TX FIFO
      │
      ▼
TX Controller
      │
      ▼
 UART TX
      │
      ▼
 UART Channel
      │
      ▼
 UART RX
      │
      ▼
  RX FIFO
      │
      ▼
CPU Interface
Verification

The design was functionally verified using a loopback testbench where the transmitter output was connected directly to the receiver input.

Test Data:

0x55
0xAA
0xFF
0x00

Successfully Transmitted and Received:

0x55
0xAA
0xFF
0x00

Synthesis Results :

Target Device: Xilinx Spartan-7 (xc7s50csga324-1)

Resource Utilization:

LUTs       : 82
Registers  : 114
LUTRAM     : 16
Timing Results
Worst Negative Slack (WNS) : +5.223 ns
Total Negative Slack (TNS) : 0 ns
Failing Endpoints          : 0

The design successfully met timing requirements after implementation.

Tools Used :

Verilog HDL
Xilinx Vivado
Functional Simulation
Synthesis
Implementation
Static Timing Analysis (STA)

Learning Outcomes :

Finite State Machine (FSM) Design
UART Protocol Implementation
FIFO Design and Integration
RTL Verification and Debugging
FPGA Synthesis and Implementation Flow
Static Timing Analysis (STA)
Digital Design Methodology
Short GitHub Tagline
