//
//  UART.cpp
//  PotatoChip
//
//  Created by Elisa Silva on 28/10/21.
//  Copyright © 2021 Uhura. All rights reserved.
//

extern "C" {
    #include "UHRModuleUARTInterface.h"
}

#include "obj_dir/VUART.h"
#include <verilated_vcd_c.h>

namespace UHR {
    class UART {
    public:
        VUART *top;
        VerilatedVcdC *trace;
        
        UART();
        ~UART();
        void eval(uint32_t tick);
    };

    UART::UART()
    {
        Verilated::traceEverOn(true);
        
        trace = new VerilatedVcdC;
        top = new VUART;
        top->trace(trace, 99);
        trace->open("/tmp/trace.vcd");
        this->eval(0);
    }

    UART::~UART()
    {
        trace->flush();
        trace->close();
        delete top;
        delete trace;
    }

    void UART::eval(uint32_t tick) {
        top->eval();
        trace->dump(tick);
    }
}

void * UHRMakeUART() {
    return new UHR::UART;
}

void UHRDestroyUART(void * module) {
    if(module == NULL) return;
    delete (UHR::UART *)module;
}

void UHRPokeUART(void * _module, int signal, uint32_t value) {
    if(_module == NULL) return;
    UHR::UART * module = (UHR::UART *)_module;
    
    switch (signal) {
        case UHRModuleUARTSignalCByte:
            module->top->cByte = value;
            break;
        case UHRModuleUARTSignalCRead:
            module->top->cRead = value;
            break;
        case UHRModuleUARTSignalCWrite:
            module->top->cWrite = value;
            break;
        case UHRModuleUARTSignalRX:
            module->top->rx = value;
            break;
        case UHRModuleUARTSignalReset:
            module->top->reset = value;
            break;
        case UHRModuleUARTSignalClock:
            module->top->clock = value;
            break;
    }
}

uint32_t UHRPeekUART(void *_module, int signal) {
    if(_module == NULL) return 0;
    UHR::UART * module = (UHR::UART *)_module;
    
    switch (signal) {
        case UHRModuleUARTSignalHByte:
            return (uint32_t)module->top->hByte;
        case UHRModuleUARTSignalHCanRead:
            return (uint32_t)module->top->hCanRead;
        case UHRModuleUARTSignalHCanWrite:
            return (uint32_t)module->top->hCanWrite;
        case UHRModuleUARTSignalTX:
            return (uint32_t)module->top->tx;
    }
    
    return 0;
}

void UHREvalUART(void *module, uint32_t tick) {
    if(module == NULL) return;
    ((UHR::UART *)module)->eval(tick);
}

