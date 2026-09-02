# AES-128 Implementation

An implementation and verification suite for the **AES-128** (Advanced Encryption Standard) algorithm, covering both software prototyping/testing and hardware description logic.

---

## Project Structure

### `AES_Python`
Contains the Jupyter Notebook implementation of the AES-128 algorithm.  
* **Purpose:** Used as a reference model to test AES-128 against standard sample inputs and generate expected outputs (test vectors) for verification.

### `AES_RTL`
Contains the Register-Transfer Level (RTL) code for the AES-128 architecture.  
* **Purpose:** Hardware implementation (Verilog/SystemVerilog/VHDL) designed for synthesis and FPGA/ASIC simulation.

---

## Getting Started

1. **Software Verification:** Navigate to `AES_Python/` and open the notebook to run standard test vectors.
2. **Hardware Simulation:** Compile and simulate the files inside `AES_RTL/` using your preferred EDA tool or simulator.