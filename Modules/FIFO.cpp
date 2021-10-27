//
//  FIFO.cpp
//  PotatoChip
//
//  Created by Elisa Silva on 25/10/21.
//  Copyright © 2021 Uhura. All rights reserved.
//

extern "C" {
    #include "UHRModuleFIFOInterface.h"
}

#include "obj_dir/VFIFO.h"
#include <verilated_vcd_c.h>

namespace UHR {
    class FIFO {
    public:
        VFIFO *top;
        VerilatedVcdC *trace;
        
        FIFO();
        ~FIFO();
        void eval(uint32_t tick);
    };

    FIFO::FIFO()
    {
        Verilated::traceEverOn(true);
        
        trace = new VerilatedVcdC;
        top = new VFIFO;
        top->trace(trace, 99);
        trace->open("/tmp/trace.vcd");
        this->eval(0);
    }

    FIFO::~FIFO()
    {
        trace->flush();
        trace->close();
        delete top;
        delete trace;
    }

    void FIFO::eval(uint32_t tick) {
        top->eval();
        trace->dump(tick);
    }
}

void * UHRMakeFIFO() {
    return new UHR::FIFO;
}

void UHRDestroyFIFO(void * module) {
    if(module == NULL) return;
    delete (UHR::FIFO *)module;
}

void UHRPokeFIFO(void * _module, int signal, uint32_t value) {
    if(_module == NULL) return;
    UHR::FIFO * module = (UHR::FIFO *)_module;
    
    switch (signal) {
        case UHRModuleFIFOSignalCByte:
            module->top->cByte = value;
            break;
        case UHRModuleFIFOSignalCPush:
            module->top->cPush = value;
            break;
        case UHRModuleFIFOSignalCPop:
            module->top->cPop = value;
            break;
        case UHRModuleFIFOSignalReset:
            module->top->reset = value;
            break;
        case UHRModuleFIFOSignalClock:
            module->top->clock = value;
            break;
    }
}

uint32_t UHRPeekFIFO(void *_module, int signal) {
    if(_module == NULL) return 0;
    UHR::FIFO * module = (UHR::FIFO *)_module;
    
    switch (signal) {
        case UHRModuleFIFOSignalHByte:
            return (uint32_t)module->top->hByte;
        case UHRModuleFIFOSignalHFull:
            return (uint32_t)module->top->hFull;
        case UHRModuleFIFOSignalHEmpty:
            return (uint32_t)module->top->hEmpty;
    }
    
    return 0;
}

void UHREvalFIFO(void *module, uint32_t tick) {
    if(module == NULL) return;
    ((UHR::FIFO *)module)->eval(tick);
}
