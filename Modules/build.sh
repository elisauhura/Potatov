#!/bin/zsh

#  build.sh
#  Module Builder
#
#  Created by Elisa Silva on 07/10/21.
#  Copyright © 2021 Uhura. All rights reserved.

echo "Module Builder"

echo "Building from: " `pwd`

if [ `uname -m` = "arm64" ]; then
    export VERILATOR="/opt/homebrew/bin/verilator"
    export VERILATOR_PATH="/opt/homebrew/Cellar/verilator/4.200/share/verilator/include"
else
    export VERILATOR="/usr/local/bin/verilator"
    export VERILATOR_PATH="/usr/local/Cellar/verilator/4.200/share/verilator/include"
fi

make Counter.dylib &&
make SoftMemory.dylib &&
make Registers.dylib &&
make ALU.dylib &&
make Core.dylib &&
make SoftPackage.dylib &&
make FIFO.dylib &&
make UART.dylib &&

# always last
make verilator.dylib
