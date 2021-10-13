//  ModuleDispatch.v
//
//  Created by Elisa Silva on 08/10/21.
//  Copyright © 2021 Uhura. All rights reserved.

`ifndef MODULE_DISPATCH_V
`define MODULE_DISPATCH_V

import "DPI-C" function int UHRModuleDispatch(int source, int request, int arg0, int arg1, int arg2);

`define DispatchMemoryInterfaceGetDelayFor 1
`define DispatchMemoryInterfaceDoOperation 2

`endif
