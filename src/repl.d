module myby.repl;

import std.algorithm : find;
import std.array : join;
import std.stdio : readln, write, writeln;
import std.string : chomp;

import myby.interpreter;
import myby.speech : Atom, Verb, atomToString;

const string REPL_HEAD = "::: ";
const string REPL_CONTINUE_HEAD = "... ";
// TODO: accept parameters from command line (e.g. useRuntimeDebug)
int runMybyREPL() {
    string[] codeLines;
    while(true) {
        write(REPL_HEAD);
        codeLines ~= readln().chomp;
        Interpreter i = new Interpreter(codeLines.join("\n"));
        i.shunt;
        Verb[] chains = i.condense;
        if(chains.length == 0) {
            // empty program is a no-op
            continue;
        }

        bool isAlias = i.condenser.chainAliases.values.find(codeLines.length - 1).length != 0;
        
        // TODO: intelligently invoke as monadic chain since there are never any args in this context
        // e.g.: `> 'main'` should know it's monadic invocation (ends with a noun, maybe?)
        Verb mainVerb = chains[$ - 1];
        Atom[] verbArgs = [];
        Atom result;
        if(mainVerb.niladic || isAlias) {
            // we need no extra args here
        }
        else if(mainVerb.markedArity == 1) {
            write(REPL_CONTINUE_HEAD, "input(1/1): ");
            string arg1 = readln().chomp;
            if(arg1.length == 0) {
                writeln("NB. skipping input(1/1)");
            }
            else {
               verbArgs ~= Interpreter.evaluate(arg1);
            }
            result = mainVerb(verbArgs);
        }
        else if(mainVerb.markedArity == 2) {
            write(REPL_CONTINUE_HEAD, "input(1/2): ");
            string arg1 = readln().chomp;
            // TODO: don't hardcode this if/else structure?
            if(arg1.length == 0) {
                writeln("NB. skipping input(1/2)");
                writeln("NB. skipping input(2/2)");
            }
            else {
                verbArgs ~= Interpreter.evaluate(arg1);
                write(REPL_CONTINUE_HEAD, "input(2/2): ");
                string arg2 = readln().chomp;
                if(arg2.length == 0) {
                    writeln("NB. skipping input(2/2)");
                }
                else {
                    verbArgs ~= Interpreter.evaluate(arg2);
                }
            }
        }
        else {
            writeln("[PLEASE REPORT!] Unexpected verb configuration (neither niladic, nor MA=1, nor MA=2):\n", mainVerb, " ; ", mainVerb.markedArity, " ; ", mainVerb.niladic);
            return 1;
        }
        if(!isAlias) {
            result = mainVerb(verbArgs);
            writeln(result.atomToString);
        }
    }

    return 0;
}
