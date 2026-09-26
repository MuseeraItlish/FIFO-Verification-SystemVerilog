# FIFO-Verification-SystemVerilog
# Synchronous FIFO Verification using SystemVerilog
## Overview

This project focuses on the functional verification of three synchronous FIFO implementations using SystemVerilog. A reusable verification environment was developed to test FIFO data integrity, FIFO ordering, reset behavior, and read/write functionality across different FIFO configurations.

The verification environment uses a reference queue (scoreboard) to maintain the expected sequence of data and compare it against the actual FIFO output.

## Verification Features
Reusable SystemVerilog verification environment
Reference queue for expected-data checking
Directed and randomized testing
FIFO reset verification
Data integrity and ordering verification
Read-after-write testing
Empty and full condition handling
Parameterized FIFO depth and data width
Multiple FIFO implementations tested

## Test Cases

The following test cases were implemented:

## Test Case	and their Purpose
Clearing Memory	Verifies basic write/read operation using zero data and checks FIFO empty behavior
Data = Index	Writes sequential index values and verifies the same sequence is returned
Read After Write	Writes random data and immediately reads it back to verify data integrity
Random Test	Performs repeated random write/read operations to exercise FIFO functionality

## Verification Methodology

The testbench maintains a reference queue called expected_fifo.

During a write operation:

FIFO Write → Store expected data in reference queue

During a read operation:

FIFO Read → Compare output with oldest value in reference queue

If the FIFO output matches the expected value, the transaction passes. A mismatch indicates a potential functional issue in the FIFO implementation.

## Tools & Technologies
-SystemVerilog
-Cadence Xcelium
