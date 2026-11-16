# Verification and reproducibility

The submitted `.v` files are unchanged; [SHA-256 hashes](source-sha256.json) record this archive. The PDF copy removes the student ID and replaces document metadata. The technical results remain those documented in the original course report.

## What the evidence establishes

| Evidence | Scope |
| :--- | :--- |
| RTL and original testbench | Implementation and simulation setup available for inspection |
| Course report | Historical design rationale, waveforms, and synthesis results |
| [Compile check](compile-check.md) | Source files compile with ModelSim/Questa; not a functional correctness or PPA result |

## Compile

```sh
python tools/compile.py --modelsim-bin /path/to/modelsim/bin
```

On Windows, use the directory containing `vlib.exe` and `vlog.exe`. Python 3 is required. Libraries and logs are written to the ignored `build/` directory. Simulation models and synthesis-only files are kept separate. No synthesis tool or cell library is bundled.

## Repeating the original experiments

The original testbench requires `vec_a.txt`, `vec_b.txt`, and `vec_c.txt`. These reference-vector files are not included. Historical waveform/reference comparisons are documented in the course report; they have not been independently reproduced for this release.

## Verification limitations

The controller advances its write counter by comparing `mat_C` with accumulator values. Equal or zero lane results can make this data-dependent sequencing ambiguous. Arbitrary-input correctness is not claimed. A counter/valid-based sequencer and directed tests for repeated, zero, maximum-value, and restart cases are next steps.

The submitted testbench uses delayed nonblocking assignments for comparisons and the non-X-sensitive `!=` operator. It should be strengthened before being used as an automated pass/fail regression.

## Synthesis interpretation

- The simulation controller and synthesis variant both define `top_controller`; they must not be compiled together.
- The report's synthesis target is the controller variant and FF-boundary wrapper in `synth/`, with SRAM excluded.
- Cell area and power depend on the original library and constraints, which are not bundled.
- The 6.3 ns clock constraint result is a synthesis result, not post-layout signoff or a silicon measurement.
