# CSE 369 Local Verilog Simulation Tools

Simulate and test your SystemVerilog designs locally on **Apple Silicon Macs** using a pre-built [Icarus Verilog](https://steveicarus.github.io/iverilog/) toolchain no Homebrew or system-wide install required.

## Prerequisites

- macOS on Apple Silicon (M1/M2/M3/M4)
- [Visual Studio Code](https://code.visualstudio.com/)
- `make` (included with Xcode Command Line Tools — run `xcode-select --install` if you don't have it, but you probably do)

## Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/aadithyamanoj/cse369_tools.git
cd cse369_tools
```

### 2. Run the Setup Script

This downloads and extracts a pre-compiled Icarus Verilog binary into the `tools/` directory. It also removes macOS quarantine flags so the binaries can run without Gatekeeper warnings.

```bash
bash scripts/setup_icarus.sh
```

If the setup was successful, you will see:

```
Setup Complete!
run make test to confirm
```

> **Note:** If you see `Icarus already installed in ...`, the tools are already set up and you're good to go.

### 3. Run the Test Project

Navigate to the `testProj/` directory and run the simulation to verify everything works:

```bash
cd testProj
make test
```

This will:

1. **Compile** the SystemVerilog source (`src/add.sv`) and testbench (`tb/add_tb.sv`) using `iverilog`.
2. **Run** the compiled simulation using `vvp`.
3. **Generate** a waveform dump file at `testProj/build/add.vcd`.

If the simulation completes without errors, your setup is working correctly.

### 4. View Waveforms with Surfer

To inspect the `.vcd` waveform output from your simulation:

1. Open **VS Code**.
2. Go to the **Extensions** panel (`Cmd+Shift+X`).
3. Search for **"Surfer"** and install the extension by **surfer-project**.
4. Open the generated `.vcd` file (e.g., `testProj/build/add.vcd`) in VS Code — Surfer will automatically render the waveform viewer.
5. Use the sidebar to add signals (like `A`, `B`, `C`) to the waveform display by clicking on them.

<video src="docs/surfer_demo.mp4" width="600" controls></video>

## Using These Tools in Your Own Labs

Each lab or project needs only a short `Makefile` that sets the module to be simulated includes the shared build rules:

```makefile
MODULE := your_module_name
include ../scripts/common.mk
```

Then organize your files like this:

```
your_lab/
├── Makefile          # The two-line Makefile above
├── src/
│   └── your_module.sv   # Your RTL design source(s)
└── tb/
    └── your_module_tb.sv  # Your testbench
```

### Testbench Naming Convention

Your testbench module **must** be named `<MODULE>_tb`. For example, if `MODULE := add`, the testbench module must be `module add_tb;`. This is required because the build system uses a wrapper (`scripts/tb_wrapper.sv`) that instantiates your testbench by this name and handles VCD file dumping automatically. You do **not** need to add `$dumpfile`/`$dumpvars` calls in your own testbench.

### Make Targets

Run these from inside your project directory:

| Command        | Description                                  |
| -------------- | -------------------------------------------- |
| `make test`    | Compile and run the simulation (most common) |
| `make compile` | Compile only (no simulation run)             |
| `make run`     | Compile and run                              |
| `make clean`   | Delete the `build/` directory                |

### Customizable Variables

These can be overridden in your `Makefile` before the `include` line if needed:

| Variable    | Default | Description                          |
| ----------- | ------- | ------------------------------------ |
| `RTL_DIR`   | `src`   | Directory containing RTL sources     |
| `TB_DIR`    | `tb`    | Directory containing testbench files |
| `BUILD_DIR` | `build` | Output directory for build artifacts |

## Troubleshooting

- **`Permission denied` when running setup:** Make the script executable first: `chmod +x scripts/setup_icarus.sh`
- **`Missing local iverilog` error on `make test`:** You haven't run the setup script yet. Go back to step 2.
- **`MODULE is not set` error:** Your `Makefile` is missing the `MODULE := ...` line before the `include`.
- **macOS blocks the binary ("unidentified developer"):** Re-run the setup script, it clears quarantine flags automatically. If the issue persists, manually run: `xattr -dr com.apple.quarantine tools/icarus/`
- **No `.vcd` file generated:** Make sure your testbench calls `$finish;`at the end of the `initial` block so the simulation terminates and flushes the waveform data. (This differs from the Modelsim testbenches, as they commonly use `$stop;`)
