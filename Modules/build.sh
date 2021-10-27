#!/bin/zsh

#  build.sh
#  Module Builder
#
#  Created by Elisa Silva on 07/10/21.
#  Copyright © 2021 Uhura. All rights reserved.

echo "Module Builder"

echo "Building from: " `pwd`

make Counter.dylib &&
make SoftMemory.dylib &&
make Registers.dylib &&
make ALU.dylib &&
make Core.dylib &&
make SoftPackage.dylib &&
make FIFO.dylib &&
# always last
make verilator.dylib
