//
//  ALU.cpp
//  PotatoChip
//
//  Created by Elisa Silva on 14/10/21.
//  Copyright © 2021 Uhura. All rights reserved.
//

extern "C" {
    #include "UHRModuleALUInterface.h"
}

#include "obj_dir/VALU.h"
#include <verilated_vcd_c.h>

namespace UHR {
    class ALU {
    public:
        VALU *top;
        VerilatedVcdC *trace;
        
        ALU();
        ~ALU();
        void eval(uint32_t tick);
    };

    ALU::ALU()
    {
        Verilated::traceEverOn(true);
        
        trace = new VerilatedVcdC;
        top = new VALU;
        top->trace(trace, 99);
        trace->open("/tmp/trace.vcd");
        this->eval(0);
    }

    ALU::~ALU()
    {
        trace->flush();
        trace->close();
        delete top;
        delete trace;
    }

    void ALU::eval(uint32_t tick) {
        top->eval();
        trace->dump(tick);
    }
}

void * UHRMakeALU() {
    return new UHR::ALU;
}

void UHRDestroyALU(void * module) {
    if(module == NULL) return;
    delete (UHR::ALU *)module;
}

void UHRPokeALU(void * _module, int signal, uint32_t value) {
    if(_module == NULL) return;
    UHR::ALU * module = (UHR::ALU *)_module;
    
    switch (signal) {
        case UHRModuleALUSignalA:
            module->top->a = value;
            break;
        case UHRModuleALUSignalB:
            module->top->b = value;
            break;
        case UHRModuleALUSignalFunct3:
            module->top->funct3 = value;
            break;
        case UHRModuleALUSignalFunct7_5b:
            module->top->funct7_5b = value;
            break;
    }
}

uint32_t UHRPeekALU(void *_module, int signal) {
    if(_module == NULL) return 0;
    UHR::ALU * module = (UHR::ALU *)_module;
    
    switch (signal) {
        case UHRModuleALUSignalOut:
            return (uint32_t)module->top->out;
    }
    
    return 0;
}

void UHREvalALU(void *module, uint32_t tick) {
    if(module == NULL) return;
    ((UHR::ALU *)module)->eval(tick);
}
