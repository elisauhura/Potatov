//  MemoryInterface.v
//
//  Created by Elisa Silva on 08/10/21.
//  Copyright © 2021 Uhura. All rights reserved.

`ifndef MEMORY_INTERFACE_V
`define MEMORY_INTERFACE_V

`define MemoryInterfaceCommandNOP 'b0000
`define MemoryInterfaceCommandRBA 'b0001
`define MemoryInterfaceCommandRSA 'b0010
`define MemoryInterfaceCommandRWA 'b0011
`define MemoryInterfaceCommandDRA 'b0100
`define MemoryInterfaceCommandWBA 'b0101
`define MemoryInterfaceCommandWSA 'b0110
`define MemoryInterfaceCommandWWA 'b0111
`define MemoryInterfaceCommandHAW 'b1000
`define MemoryInterfaceCommandRBB 'b1001
`define MemoryInterfaceCommandRSB 'b1010
`define MemoryInterfaceCommandRWB 'b1011
`define MemoryInterfaceCommandDRB 'b1100
`define MemoryInterfaceCommandWBB 'b1101
`define MemoryInterfaceCommandWSB 'b1110
`define MemoryInterfaceCommandWWB 'b1111

`define MemoryInterfaceCommandRB  'b?001
`define MemoryInterfaceCommandRS  'b?010
`define MemoryInterfaceCommandRW  'b?011
`define MemoryInterfaceCommandDR  'b?100
`define MemoryInterfaceCommandWB  'b?101
`define MemoryInterfaceCommandWS  'b?110
`define MemoryInterfaceCommandWW  'b?111

`endif
