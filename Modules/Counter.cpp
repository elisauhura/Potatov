//
//  UHRModuleCounter.cpp
//  PotatoChip
//
//  Created by Elisa Silva on 07/10/21.
//  Copyright © 2021 Uhura. All rights reserved.
//

extern "C" {
    #include "UHRModuleCounterInterface.h"
}

#include "obj_dir/VCounter.h"
#include <verilated_vcd_c.h>

namespace UHR {
    class Counter {
    public:
        VCounter *top;
        VerilatedVcdC *trace;
        
        Counter();
        ~Counter();
        void eval(uint32_t tick);
    };

    Counter::Counter()
    {
        Verilated::traceEverOn(true);
        
        trace = new VerilatedVcdC;
        top = new VCounter;
        top->trace(trace, 99);
        trace->open("/tmp/trace.vcd");
        this->eval(0);
    }

    Counter::~Counter()
    {
        trace->flush();
        trace->close();
        delete top;
        delete trace;
    }

    void Counter::eval(uint32_t tick) {
        top->eval();
        trace->dump(tick);
    }
}

void * UHRMakeCounter() {
    return new UHR::Counter;
}

void UHRDestroyCounter(void * module) {
    if(module == NULL) return;
    delete (UHR::Counter *)module;
}

void UHRPokeCounter(void * _module, int signal, uint32_t value) {
    if(_module == NULL) return;
    UHR::Counter * module = (UHR::Counter *)_module;
    
    switch (signal) {
        case UHRModuleCounterSignalCounter:
            module->top->counter = value;
            break;
        case UHRModuleCounterSignalReset:
            module->top->reset = value;
            break;
        case UHRModuleCounterSignalClock:
            module->top->clock = value;
            break;
    }
}

uint32_t UHRPeekCounter(void *_module, int signal) {
    if(_module == NULL) return 0;
    UHR::Counter * module = (UHR::Counter *)_module;
    
    switch (signal) {
        case UHRModuleCounterSignalCounter:
            return (uint32_t)module->top->counter;
        case UHRModuleCounterSignalReset:
            return (uint32_t)module->top->reset;
        case UHRModuleCounterSignalClock:
            return (uint32_t)module->top->clock;
    }
    
    return 0;
}

void UHREvalCounter(void *module, uint32_t tick) {
    if(module == NULL) return;
    ((UHR::Counter *)module)->eval(tick);
}
