module myby.debugger;

import std.stdio;

struct DebuggerContainer {
    bool enabled = false;
    int silenced = 0;
    
    bool printing() {
        return enabled && !silenced;
    }
    
    void print(T...)(T args) {
        if(!printing) return;
        writeln("\x1B[90mDebug:\x1B[0m ", args);
    }
    void enable() {
        enabled = true;
    }
    void disable() {
        enabled = false;
    }
    // works in steps, so it works when nested
    void silence() {
        silenced++;
    }
    void unsilence() {
        if(silenced) {
            silenced--;
        }
    }
}

static DebuggerContainer Debugger;
