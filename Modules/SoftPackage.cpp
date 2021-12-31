//
//  SoftPackage.cpp
//  PotatoChip
//
//  Created by Elisa Silva on 15/10/21.
//  Copyright © 2021 Uhura. All rights reserved.
//

extern "C" {
    #include "UHRModuleSoftPackageInterface.h"
}

#include "obj_dir/VSoftPackage.h"
#include "obj_dir/VSoftPackage_SoftPackage.h"
#include "obj_dir/VSoftPackage_Core.h"
#include "obj_dir/VSoftPackage_Registers.h"
#include "obj_dir/VSoftPackage_SoftMemory.h"
#include <verilated_vcd_c.h>

namespace UHR {
    class SoftPackage {
    public:
        VSoftPackage *top;
        VerilatedVcdC *trace;
        
        SoftPackage();
        ~SoftPackage();
        void eval(uint32_t tick);
    };

    SoftPackage::SoftPackage()
    {
        Verilated::traceEverOn(true);
        
        trace = new VerilatedVcdC;
        top = new VSoftPackage;
        top->trace(trace, 0);
        trace->open("/tmp/trace.vcd");
        this->eval(0);
    }

    SoftPackage::~SoftPackage()
    {
        trace->flush();
        trace->close();
        delete top;
        delete trace;
    }

    void SoftPackage::eval(uint32_t tick) {
        top->eval();
        trace->dump(tick);
    }
}

void * UHRMakeSoftPackage() {
    return new UHR::SoftPackage;
}

void UHRDestroySoftPackage(void * module) {
    if(module == NULL) return;
    delete (UHR::SoftPackage *)module;
}

void UHRPokeSoftPackage(void * _module, int signal, uint32_t value) {
    if(_module == NULL) return;
    UHR::SoftPackage * module = (UHR::SoftPackage *)_module;
    
    switch (signal) {
        case UHRModuleSoftPackageSignalMemoryID:
            module->top->SoftPackage->memory->ID = value;
            break;
        case UHRModuleSoftPackageSignalReset:
            module->top->reset = value;
            break;
        case UHRModuleSoftPackageSignalClock:
            module->top->clock = value;
            break;
    }
    
    if(signal >= UHRModuleSoftPackageSignalReg1 &&
       signal <= UHRModuleSoftPackageSignalReg31) {
        module->top->SoftPackage->core->registers->registers[signal-UHRModuleSoftPackageSignalReg1] = value;
    }
}

uint32_t UHRPeekSoftPackage(void *_module, int signal) {
    if(_module == NULL) return 0;
    UHR::SoftPackage * module = (UHR::SoftPackage *)_module;
    
    if(signal >= UHRModuleSoftPackageSignalReg1 &&
       signal <= UHRModuleSoftPackageSignalReg31) {
        return (uint32_t)module->top->SoftPackage->core->registers->registers[signal-UHRModuleSoftPackageSignalReg1];
    }
    
    switch (signal) {
        case UHRModuleSoftPackageSignalCCommand:
            return (uint32_t)module->top->SoftPackage->cCommand;
        case UHRModuleSoftPackageSignalCAddress:
            return (uint32_t)module->top->SoftPackage->cAddress;
        case UHRModuleSoftPackageSignalCData:
            return (uint32_t)module->top->SoftPackage->cData;
        case UHRModuleSoftPackageSignalHReady:
            return (uint32_t)module->top->SoftPackage->hReady;
        case UHRModuleSoftPackageSignalHSignal:
            return (uint32_t)module->top->SoftPackage->hSignal;
        case UHRModuleSoftPackageSignalHData:
            return (uint32_t)module->top->SoftPackage->hData;
        case UHRModuleSoftPackageSignalReset:
            return (uint32_t)module->top->reset;
        case UHRModuleSoftPackageSignalClock:
            return (uint32_t)module->top->clock;
        case UHRModuleSoftPackageSignalPC:
            return (uint32_t)module->top->SoftPackage->core->PC;
        case UHRModuleSoftPackageSignalState:
            return (uint32_t)module->top->SoftPackage->core->state;
        case UHRModuleSoftPackageSignalInstruction:
            return (uint32_t)module->top->SoftPackage->core->Instruction;
        case UHRModuleSoftPackageSignalMemoryID:
            return (uint32_t)module->top->SoftPackage->memory->ID;
    }
    
    return 0;
}

void UHREvalSoftPackage(void *module, uint32_t tick) {
    if(module == NULL) return;
    ((UHR::SoftPackage *)module)->eval(tick);
}
