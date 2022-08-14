module myby.debugger;

import std.stdio;

struct DebuggerContainer {
    bool enabled = false;
    bool silenced = false;
    
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
    void silence() {
        silenced = true;
    }
    void unsilence() {
        silenced = false;
    }
}

static DebuggerContainer Debugger;
