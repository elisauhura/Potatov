//
//  Core.cpp
//  PotatoChip
//
//  Created by Elisa Silva on 14/10/21.
//  Copyright © 2021 Uhura. All rights reserved.
//

extern "C" {
    #include "UHRModuleCoreInterface.h"
}

#include "obj_dir/VCore.h"
#include "obj_dir/VCore_Core.h"
#include "obj_dir/VCore_Registers.h"
#include <verilated_vcd_c.h>

namespace UHR {
    class Core {
    public:
        VCore *top;
        VerilatedVcdC *trace;
        
        Core();
        ~Core();
        void eval(uint32_t tick);
    };

    Core::Core()
    {
        Verilated::traceEverOn(true);
        
        trace = new VerilatedVcdC;
        top = new VCore;
        top->trace(trace, 0);
        trace->open("/tmp/trace.vcd");
        this->eval(0);
    }

    Core::~Core()
    {
        trace->flush();
        trace->close();
        delete top;
        delete trace;
    }

    void Core::eval(uint32_t tick) {
        top->eval();
        trace->dump(tick);
    }
}

void * UHRMakeCore() {
    return new UHR::Core;
}

void UHRDestroyCore(void * module) {
    if(module == NULL) return;
    delete (UHR::Core *)module;
}

void UHRPokeCore(void * _module, int signal, uint32_t value) {
    if(_module == NULL) return;
    UHR::Core * module = (UHR::Core *)_module;
    
    switch (signal) {
        case UHRModuleCoreSignalHReady:
            module->top->hReady = value;
            break;
        case UHRModuleCoreSignalHSignal:
            module->top->hSignal = value;
            break;
        case UHRModuleCoreSignalHData:
            module->top->hData = value;
            break;
        case UHRModuleCoreSignalReset:
            module->top->reset = value;
            break;
        case UHRModuleCoreSignalClock:
            module->top->clock = value;
            break;
    }
}

uint32_t UHRPeekCore(void *_module, int signal) {
    if(_module == NULL) return 0;
    UHR::Core * module = (UHR::Core *)_module;
    
    if(signal >= UHRModuleCoreSignalReg1 &&
       signal <= UHRModuleCoreSignalReg31) {
        return (uint32_t)module->top->Core->registers->registers[signal-UHRModuleCoreSignalReg1];
    }
    
    switch (signal) {
        case UHRModuleCoreSignalCCommand:
            return (uint32_t)module->top->cCommand;
        case UHRModuleCoreSignalCAddress:
            return (uint32_t)module->top->cAddress;
        case UHRModuleCoreSignalCData:
            return (uint32_t)module->top->cData;
        case UHRModuleCoreSignalReset:
            return (uint32_t)module->top->reset;
        case UHRModuleCoreSignalClock:
            return (uint32_t)module->top->clock;
        case UHRModuleCoreSignalPC:
            return (uint32_t)module->top->Core->PC;
        case UHRModuleCoreSignalState:
            return (uint32_t)module->top->Core->state;
        case UHRModuleCoreSignalInstruction:
            return (uint32_t)module->top->Core->Instruction;
    }
    
    return 0;
}

void UHREvalCore(void *module, uint32_t tick) {
    if(module == NULL) return;
    ((UHR::Core *)module)->eval(tick);
}
