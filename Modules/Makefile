#  Makefile
#  Module Builder
#
#  Created by Elisa Silva on 07/10/21.
#  Copyright © 2021 Uhura. All rights reserved.

VERILATOR=/usr/local/bin/verilator
VERILATOR_PATH=/usr/local/Cellar/verilator/4.200/share/verilator/include
CCPP=clang++

%.a: %.v %.cpp
	$(VERILATOR) --cc --trace $<
	cd obj_dir && \
	$(MAKE) -j -f V$(basename $@).mk V$(basename $@)__ALL.cpp && \
	$(CCPP) -g -lc++ -I. -MMD -I$(VERILATOR_PATH) -I$(VERILATOR_PATH)/vltstd \
	-DVM_COVERAGE=0 -DVM_SC=0 -DVM_TRACE=0 -DVM_TRACE_FST=0 -faligned-new \
	-fbracket-depth=4096 -fcf-protection=none -Qunused-arguments \
	-Wno-bool-operation -Wno-tautological-bitwise-compare -Wno-parentheses-equality \
	-Wno-sign-compare -Wno-uninitialized -Wno-unused-parameter -Wno-unused-variable -Wno-shadow \
	-c -std=gnu++14 -O0 $(VERILATOR_PATH)/verilated.cpp $(VERILATOR_PATH)/verilated_dpi.cpp \
	$(VERILATOR_PATH)/verilated_vcd_c.cpp \
	V$(basename $@)__ALL.cpp ../$(basename $@).cpp && \
	libtool -static -o $@ V$(basename $@)__ALL.o $(basename $@).o verilated.o verilated_dpi.o verilated_vcd_c.o
	mv obj_dir/$@ ./$@

%.dylib: %.v %.cpp
	$(VERILATOR) --cc --trace $<
	cd obj_dir && \
	$(MAKE) -j -f V$(basename $@).mk V$(basename $@)__ALL.cpp && \
	$(CCPP) -g -lc++ -undefined dynamic_lookup -I. -MMD -I$(VERILATOR_PATH) -I$(VERILATOR_PATH)/vltstd \
	-DVM_COVERAGE=0 -DVM_SC=0 -DVM_TRACE=0 -DVM_TRACE_FST=0 -faligned-new \
	-fbracket-depth=4096 -fcf-protection=none -Qunused-arguments \
	-Wno-bool-operation -Wno-tautological-bitwise-compare -Wno-parentheses-equality \
	-Wno-sign-compare -Wno-uninitialized -Wno-unused-parameter -Wno-unused-variable -Wno-shadow \
	-dynamiclib -std=gnu++14 -O0 \
	V$(basename $@)__ALL.cpp ../$(basename $@).cpp -o $@
	mv obj_dir/$@ ./$@

verilator.dylib:
	cd obj_dir && \
	$(CCPP) -g -lc++ -I. -MMD -I$(VERILATOR_PATH) -I$(VERILATOR_PATH)/vltstd \
	-DVM_COVERAGE=0 -DVM_SC=0 -DVM_TRACE=0 -DVM_TRACE_FST=0 -faligned-new \
	-fbracket-depth=4096 -fcf-protection=none -Qunused-arguments \
	-Wno-bool-operation -Wno-tautological-bitwise-compare -Wno-parentheses-equality \
	-Wno-sign-compare -Wno-uninitialized -Wno-unused-parameter -Wno-unused-variable -Wno-shadow \
	-dynamiclib -std=gnu++14 -O0 $(VERILATOR_PATH)/verilated.cpp $(VERILATOR_PATH)/verilated_dpi.cpp \
	$(VERILATOR_PATH)/verilated_vcd_c.cpp -o $@
	mv obj_dir/$@ ./$@
