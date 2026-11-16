# Compile check

Checked on 2026-11-16 using ModelSim - Intel FPGA Edition `vlog 2020.1` (2020.02).

| Source set | Result |
| :--- | :--- |
| Simulation sources, memory models, and original testbench | PASS |
| Synthesis source set | PASS |

Command: `python tools/compile.py --modelsim-bin <local ModelSim binary directory>`

The two source sets are compiled into separate libraries. This is a compilation check only; it does not establish functional correctness, timing, power, area, or PSNR. See [reproducibility](reproducibility.md).
