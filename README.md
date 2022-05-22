# FPGA Stress Tests

Test FPGA power and stability using these tests.

---

## iCE40 Tests

These tests are for the lattice iCE40 Ultra Plus family:

### iCE40 Power

This test drives all 5k LUTs, and RAM blocks of the iCE40 for maximum power consumption. The PLL is used to multiply an input clock signal and allow sweeping over a wide range of frequencies.

To build run

`make ice40_power`

---

## Crosslink-NX Tests

### LIFCL Power

This test drives all 17k gates and RAM blocks of the LIFCL-17 for maximum power consumption. The PLL is used to multiply an input clock signal and allow sweeping over a wide range of frequencies.

To build run

`make lifcl_power`