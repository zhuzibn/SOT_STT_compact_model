# Environment

This repository has two evidence-backed execution contexts: MATLAB for local
post-processing of exported ViVA sweep data, and Cadence Virtuoso on the EDA
cluster for Verilog-A simulation. `README.md` is the source for the simulator,
library, cell, and benchmark locations. No automated Cadence validation command
or tool-version constraint is currently documented.

## Required local plotting environment

- MATLAB is required for `main_plot.m` and `vivaFinalVsParam.m`. No minimum
  MATLAB release or add-on toolbox is documented.
- The three tracked ViVA exports are inputs:
  `SOT_sweepJc_mz+1.matlab`, `SOT_sweepJc_mz-1.matlab`, and
  `SOT_sweep_hx.matlab`.
- No local package manifest, hardware requirement, environment variable, or
  secret is documented.

Run the existing plotting workflow from the repository root:

```bash
matlab -batch "run('main_plot.m'); close all force"
```

This reads the tracked sweep exports and exercises the parsing and plotting
helper without writing project files.

## Required Verilog-A simulation environment

- Cadence Virtuoso with Verilog-A support is required on the EDA cluster. No
  minimum Virtuoso version or local WSL installation is documented.
- The documented cluster project is `/home/zhuzhf/code/project/MRAM2`.
- Compile `STT_SOT_COSMAL.va` in the `MRAM` library's `SOT-zf` cell.
- Run the documented `MTJzf_tb` verification cell and compare its sweep output
  with the MATLAB plots described in `README.md`.

Cadence licensing, the cluster connection, the remote library, and the testbench
cannot be validated from this local folder. Verify them manually on the EDA
cluster before changing or relying on Verilog-A simulation results.

## Read-only local verification

```bash
matlab -batch "fprintf('%s\n', version)"
matlab -batch "run('main_plot.m'); close all force"
git diff --check
```

The environment-doctor profile also performs a static check that the Verilog-A
source contains the required `disciplines.vams` and `constants.vams` includes
and balanced `module`/`endmodule` delimiters. This is not a substitute for a
Cadence compile and simulation.
