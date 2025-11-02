# ComputerArchitechtureProject1
first project of computer architechture

## Part 1: Single-threaded Matrix Multiply

This project reads two 1000x1000 matrices of doubles from binary files, multiplies them, writes the result to a binary file, prints a few elements for verification, and reports the multiply time.

### Files
- Input 1: `data/data1/data1` (1000x1000 doubles, row-major, 8,000,000 bytes)
- Input 2: `data/data2/data2` (1000x1000 doubles, row-major, 8,000,000 bytes)
- Output: `data3` (1000x1000 doubles, row-major)

### Build

Build into `build\matmul.exe` using one of:

- PowerShell helper:
  - `powershell -ExecutionPolicy Bypass -File .\build.ps1`

- CMD batch helper:
  - `build.bat`

- Manual (MSVC Developer Command Prompt):
  - `cl /O2 /W4 /nologo /Fe:build\matmul.exe "src\progamming assignment part 1.c"`

- Manual (MinGW-w64 GCC):
  - `gcc -O3 -Wall -Wextra -std=c11 -o build\matmul.exe "src/progamming assignment part 1.c"`

### Run

Defaults to the provided data paths and writes `build\\data3`:

```
build\matmul.exe
```

Or specify explicit paths: `matmul.exe <data1> <data2> <output>`

```
build\matmul.exe data\data1\data1 data\data2\data2 build\data3
```

Program output:
- Line to stdout: `mat3[6][0] mat3[5][3] mat3[5][4] mat3[901][7]`
- Multiply wall time to stderr: `Multiply time: <seconds>`

Note: The naive O(N^3) multiply for 1000x1000 may take noticeable time on some machines.

### Clean

To remove generated artifacts (.exe files and the matrix output `build\data3`):

- PowerShell (with optional dry run):
  - `powershell -ExecutionPolicy Bypass -File .\clean.ps1`  
  - `powershell -ExecutionPolicy Bypass -File .\clean.ps1 -DryRun`

- CMD batch:
  - `clean.bat`

### Debug printing

Verbose printing of matrices and steps is controlled by the `DEBUG` macro. By default it is disabled (`DEBUG=0`). Enable it at compile time to print all steps and full matrices (very large output for 1000x1000):

- MSVC: `cl /O2 /W4 /nologo /DDEBUG=1 /Fe:build\matmul.exe "src\progamming assignment part 1.c"`
- GCC: `gcc -O3 -Wall -Wextra -std=c11 -DDEBUG=1 -o build\matmul.exe "src/progamming assignment part 1.c"`

The final required stdout verification line always prints regardless of `DEBUG`.
