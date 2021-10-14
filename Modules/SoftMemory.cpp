//
//  SoftMemory.cpp
//  PotatoChip
//
//  Created by Elisa Silva on 11/10/21.
//  Copyright © 2021 Uhura. All rights reserved.
//

extern "C" {
    #include "UHRModuleSoftMemoryInterface.h"
}

#include "obj_dir/VSoftMemory.h"
#include "obj_dir/VSoftMemory_SoftMemory.h"
#include <verilated_vcd_c.h>

namespace UHR {
    class SoftMemory {
    public:
        VSoftMemory *top;
        VerilatedVcdC *trace;
        
        SoftMemory();
        ~SoftMemory();
        void eval(uint32_t tick);
    };

    SoftMemory::SoftMemory()
    {
        Verilated::traceEverOn(true);
        
        trace = new VerilatedVcdC;
        top = new VSoftMemory;
        top->trace(trace, 99);
        trace->open("/tmp/trace.vcd");
        this->eval(0);
    }

    SoftMemory::~SoftMemory()
    {
        trace->flush();
        trace->close();
        delete top;
        delete trace;
    }

    void SoftMemory::eval(uint32_t tick) {
        top->eval();
        trace->dump(tick);
    }
}

void * UHRMakeSoftMemory() {
    return new UHR::SoftMemory;
}

void UHRDestroySoftMemory(void * module) {
    if(module == NULL) return;
    delete (UHR::SoftMemory *)module;
}

void UHRPokeSoftMemory(void * _module, int signal, uint32_t value) {
    if(_module == NULL) return;
    UHR::SoftMemory * module = (UHR::SoftMemory *)_module;
    
    switch (signal) {
        case UHRModuleSoftMemorySignalCCommand:
            module->top->cCommand = value;
            break;
        case UHRModuleSoftMemorySignalCAddress:
            module->top->cAddress = value;
            break;
        case UHRModuleSoftMemorySignalCData:
            module->top->cData = value;
            break;
        case UHRModuleSoftMemorySignalReset:
            module->top->reset = value;
            break;
        case UHRModuleSoftMemorySignalClock:
            module->top->clock = value;
            break;
        case UHRModuleSoftMemorySignalID:
            module->top->SoftMemory->ID = value;
            break;
    }
}

uint32_t UHRPeekSoftMemory(void *_module, int signal) {
    if(_module == NULL) return 0;
    UHR::SoftMemory * module = (UHR::SoftMemory *)_module;
    
    switch (signal) {
        case UHRModuleSoftMemorySignalHReady:
            return (uint32_t)module->top->hReady;
        case UHRModuleSoftMemorySignalHSignal:
            return (uint32_t)module->top->hSignal;
        case UHRModuleSoftMemorySignalHData:
            return (uint32_t)module->top->hData;
        case UHRModuleSoftMemorySignalReset:
            return (uint32_t)module->top->reset;
        case UHRModuleSoftMemorySignalClock:
            return (uint32_t)module->top->clock;
    }
    
    return 0;
}

void UHREvalSoftMemory(void *module, uint32_t tick) {
    if(module == NULL) return;
    ((UHR::SoftMemory *)module)->eval(tick);
}
