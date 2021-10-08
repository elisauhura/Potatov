#!/bin/zsh

#  build.sh
#  Module Builder
#
#  Created by Elisa Silva on 07/10/21.
#  Copyright © 2021 Uhura. All rights reserved.

echo "Module Builder"

echo "Building from: " `pwd`

make verilator.dylib
make Counter.dylib
