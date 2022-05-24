clean:
	rm -r .build .sim

ice40_power:
	mkdir -p .build
	iverilog -Wall -g2012 -o .build/ice40_power.out -i ice40/ice40_power.sv
	yosys -p "synth_ice40 -json .build/ice40_power.json" ice40/ice40_power.sv
	nextpnr-ice40 --up5k --package uwg30 --json .build/ice40_power.json --asc .build/ice40_power.asc --pcf ice40/s1.pcf
	icepack .build/ice40_power.asc .build/ice40_power.bin
	cd .build && xxd -i ice40_power.bin ice40_power_temp.h
	sed '1s/^/const /' .build/ice40_power_temp.h > .build/ice40_power.h

crosslink_power:
	mkdir -p .build
	iverilog -Wall -g2012 -o .build/crosslink_power.out -i crosslink/crosslink_power.sv
	yosys -p "synth_nexus -json .build/crosslink_power.json" crosslink/crosslink_power.sv
	nextpnr-nexus --device LIFCL-40-8BG400 --pdc crosslink/vip.pdc --json .build/crosslink_power.json --fasm .build/crosslink_power.fasm
	prjoxide pack .build/crosslink_power.fasm .build/crosslink_power.bit
	openFPGALoader -m .build/crosslink_power.bit

sim_pseudorandom_ff:
	mkdir -p .sim
	iverilog -Wall -g2012 -o .sim/pseudorandom_ff_tb.out -i testbenches/pseudorandom_ff_tb.sv
	vvp .sim/pseudorandom_ff_tb.out -lxt2
	gtkwave .sim/pseudorandom_ff_tb.lxt testbenches/pseudorandom_ff_tb.gtkw