RISCV=/usr/local/Cellar/riscv-gnu-toolchain/master/bin/riscv64-unknown-elf-

%.bin: %.raw.S
	$(RISCV)as -march=rv32i $< -o $@.elf
	$(RISCV)objcopy -I elf32-littleriscv -O binary $@.elf $@
	rm $@.elf
