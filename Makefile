# Output build directory.
OUT = .build

clean:
	rm -r .build

ice40-power:
	mkdir -p $(OUT)
	iverilog -Wall -g2012 -o $(OUT)/ice40-power.out -i ice40-power.sv
	yosys -p "synth_ice40 -json $(OUT)/ice40-power.json" ice40-power.sv
	nextpnr-ice40 --up5k --package uwg30 -q --json $(OUT)/ice40-power.json --asc $(OUT)/ice40-power.asc --pcf s1.pcf
	icepack $(OUT)/ice40-power.asc $(OUT)/ice40-power.bin

# Temporary conversion to header file
	# cd $(OUT) && xxd -i ice40-power.bin ice40-power.h
	# sed '1s/^/const /' $(OUT)/ice40-power.h > $(OUT)ice40-power.h