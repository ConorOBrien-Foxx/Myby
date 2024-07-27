module myby.repl;

import std.stdio : readln, write, writeln;

import myby.interpreter;
import myby.speech : Verb, atomToString;

const string REPL_HEAD = "::: ";
// TODO: accept parameters from command line (e.g. useRuntimeDebug)
int runMybyREPL() {
    while(true) {
        write(REPL_HEAD);
        string inputLine = readln();
        Interpreter i = new Interpreter(inputLine);
        i.shunt;
        Verb[] chains = i.condense;
        if(chains.length == 0) {
            // empty program is a no-op
            continue;
        }
        
        // TODO: intelligently invoke as monadic chain since there are never any args in this context
        // e.g.: `> 'main'` should know it's monadic invocation (ends with a noun, maybe?)
        Verb mainVerb = chains[$ - 1];
        writeln(mainVerb().atomToString);
    }

    return 0;
}
