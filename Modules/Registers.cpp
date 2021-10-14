//
//  Registers.cpp
//  PotatoChip
//
//  Created by Elisa Silva on 14/10/21.
//  Copyright © 2021 Uhura. All rights reserved.
//

extern "C" {
    #include "UHRModuleRegistersInterface.h"
}

#include "obj_dir/VRegisters.h"
#include "obj_dir/VRegisters_Registers.h"
#include <verilated_vcd_c.h>

namespace UHR {
    class Registers {
    public:
        VRegisters *top;
        VerilatedVcdC *trace;
        
        Registers();
        ~Registers();
        void eval(uint32_t tick);
    };

    Registers::Registers()
    {
        Verilated::traceEverOn(true);
        
        trace = new VerilatedVcdC;
        top = new VRegisters;
        top->trace(trace, 99);
        trace->open("/tmp/trace.vcd");
        this->eval(0);
    }

    Registers::~Registers()
    {
        trace->flush();
        trace->close();
        delete top;
        delete trace;
    }

    void Registers::eval(uint32_t tick) {
        top->eval();
        trace->dump(tick);
    }
}

void * UHRMakeRegisters() {
    return new UHR::Registers;
}

void UHRDestroyRegisters(void * module) {
    if(module == NULL) return;
    delete (UHR::Registers *)module;
}

void UHRPokeRegisters(void * _module, int signal, uint32_t value) {
    if(_module == NULL) return;
    UHR::Registers * module = (UHR::Registers *)_module;
    
    if(signal >= UHRModuleRegistersSignalReg1 &&
       signal <= UHRModuleRegistersSignalReg31) {
        module->top->Registers->registers[signal-UHRModuleRegistersSignalReg] = value;
    }
    
    switch (signal) {
        case UHRModuleRegistersSignalCReg1Address:
            module->top->cReg1Address = value;
            break;
        case UHRModuleRegistersSignalCReg2Address:
            module->top->cReg2Address = value;
            break;
        case UHRModuleRegistersSignalCRegDAddress:
            module->top->cRegDAddress = value;
            break;
        case UHRModuleRegistersSignalCRegDData:
            module->top->cRegDData = value;
            break;
        case UHRModuleRegistersSignalReset:
            module->top->reset = value;
            break;
        case UHRModuleRegistersSignalClock:
            module->top->clock = value;
            break;
    }
}

uint32_t UHRPeekRegisters(void *_module, int signal) {
    if(_module == NULL) return 0;
    UHR::Registers * module = (UHR::Registers *)_module;
    
    if(signal >= UHRModuleRegistersSignalReg1 &&
       signal <= UHRModuleRegistersSignalReg31) {
        return (uint32_t)module->top->Registers->registers[signal-UHRModuleRegistersSignalReg];
    }
    
    switch (signal) {
        case UHRModuleRegistersSignalHReg1Data:
            return (uint32_t)module->top->hReg1Data;
        case UHRModuleRegistersSignalHReg2Data:
            return (uint32_t)module->top->hReg2Data;
        case UHRModuleRegistersSignalReset:
            return (uint32_t)module->top->reset;
        case UHRModuleRegistersSignalClock:
            return (uint32_t)module->top->clock;
    }
    
    return 0;
}

void UHREvalRegisters(void *module, uint32_t tick) {
    if(module == NULL) return;
    ((UHR::Registers *)module)->eval(tick);
}

