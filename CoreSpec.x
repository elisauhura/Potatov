!Type: StateSpec
!Machine: Potatov
!Author: Elisa Uhura

context {
    PC
    Instruction
    Clock
    Mem
}
 
initial Init

state Init {
    PC <- 0x8000
    Mem:cCommand <- Mem:CommandNOP
    goto Fetch
}

state Fetch {
    if(Mem)
    :mem:Read32(PC) -> Instruction;
    :int:Decode(Instruction) -> (OPCode, F3, F7, IMM, R1, R2, RD, SHAMT, isValid)
    goto Execute
}

state Execute {
    -/-
}

state ReadWriteHandle {
    -/-
}

state TrapHandle {
    -/-
}

state Stall {
    -/-
}

// global events
state any {
    // [condition] [-=](PriorityGroup Priority)> { block }
    // - for events that can run async
    // = for events that if triggered, blocks lower priority
    
    [input.reset] =(A 1)> {
        goto Init
    }
    
    // no condition
    [*] -(A 0)> {
        Clock <- Clock + 1
    }
}
