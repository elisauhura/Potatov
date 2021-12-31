#!/bin/zsh

#  build.sh
#  Module Builder
#
#  Created by Elisa Silva on 07/10/21.
#  Copyright © 2021 Uhura. All rights reserved.

echo "Programs Builder"

echo "Building from: " `pwd`

if [ `uname -m` = "arm64" ]; then
    export RISCV="/opt/homebrew/Cellar/riscv-gnu-toolchain/master/bin/riscv64-unknown-elf-"
else
    export RISCV="/usr/local/Cellar/riscv-gnu-toolchain/master/bin/riscv64-unknown-elf-"
fi

make SAMPLE.bin &&
make LUI.bin
