//  MemoryInterface.v
//
//  Created by Elisa Silva on 08/10/21.
//  Copyright © 2021 Uhura. All rights reserved.

`ifndef MEMORY_INTERFACE_V
`define MEMORY_INTERFACE_V

`define MemoryInterfaceCommandNOP        'b000
`define MemoryInterfaceCommandReadByte   'b001
`define MemoryInterfaceCommandReadShort  'b010
`define MemoryInterfaceCommandReadWord   'b011
`define MemoryInterfaceCommandWait       'b100
`define MemoryInterfaceCommandWriteByte  'b101
`define MemoryInterfaceCommandWriteShort 'b110
`define MemoryInterfaceCommandWriteWord  'b111

`endif
