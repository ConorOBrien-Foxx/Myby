module myby.main;

import std.algorithm.iteration : map;
import std.algorithm.searching : canFind;
import std.array;
import std.bigint;
import std.file : read, FileException, write, exists, getcwd;
import std.getopt;
import std.path : buildPath, dirName;
import std.process : spawnProcess, wait;
import std.range : lockstep;
import std.stdio;
import std.sumtype;

import core.exception : AssertError;

import myby.debugger;
import myby.instructions;
import myby.interpreter;
import myby.json : atomToJson;
import myby.literate;
import myby.nibble;
import myby.speech;
import myby.repl : runMybyREPL;

auto getoptSafeError(T...)(ref string[] args, T opts) {
    try {
        return getopt(args, opts);
    }
    catch(GetOptException e) {
        stderr.writeln(e.message);
        stderr.writeln("Use the --help flag to see correct usage.");
        return GetoptResult();
    }
}

void debugChains(Verb[] chains) {
    foreach(chainIndex, v; chains) {
        stderr.writeln("Chain ", chainIndex, ":");
        stderr.writeln("  MA=", v.markedArity, " Niladic=", v.niladic);
        stderr.writeln(v.treeDisplay());
    }
}

string[] ScriptAliases = [
    "know",
    "runner",
    "distr"
];
int main(string[] args) {
    // script aliases - do before processing args
    if(args.length >= 2 && ScriptAliases.canFind(args[1])) {
        auto scriptSource = buildPath(
            getcwd(),
            args[0].dirName,
            "example",
            "golf",
            args[1] ~ ".rb"
        );
        auto pid = spawnProcess(["ruby", scriptSource] ~ args[2..$]);
        return wait(pid);
    }
    
    bool compile;
    bool literate;
    bool useDebug, useRuntimeDebug;
    bool dispTree;
    bool jsonOutput;
    bool decompile, decompileAlign;
    bool noCode;
    // bool scriptKnow, scriptRunner, scriptDistribution;
    bool forceTruthy;
    bool measureSize;
    bool useRepl;
    string outfile;
    string fpath;
    string code;
    string fValue, gValue, hValue;
    bool temp;//todo:remove
    auto info = getoptSafeError(
        args,
        std.getopt.config.bundling,
        std.getopt.config.caseSensitive,
        "repl|r", "Uses REPL to interactively write Myby code", &useRepl,
        "tree|t", "Display tree-form", &dispTree,
        "jsonout|j", "Outputs data in a JSON friendly format", &jsonOutput,
        "compile|c", "Compile literate program", &compile,
        "uncompile|u", "Uncompile (decompile) compiled program", &decompile,
        "alignuncompile|a", "Uncompile (decompile) and aligns compiled program", &decompileAlign,
        "outfile|o", "Outputs relevant data to specified file", &outfile,
        "literate|l", "Input source is a literate program", &literate,
        "file|i", "Uses named file", &fpath,
        "execute|e", "Executes provided code", &code,
        // TODO: levels of debug information?
        "debug|d", "Prints debug information", &useDebug,
        "rundebug|D", "Runtime debug information", &useRuntimeDebug,
        "nocode|x", "Prevents program execution", &noCode,
        "truthy|y", "Coalesces the return value to truthy/falsey", &forceTruthy,
        "size|s", "Measures the size of the program", &measureSize,
        "F", "Sets verb F:", &fValue,
        "G", "Sets verb G:", &gValue,
        "H", "Sets verb H:", &hValue,
        // quick aliases for other commands
        // "K", "know.rb", &scriptKnow,
        // "R", "runner.rb", &scriptRunner,
        // "D", "distr.rb", &scriptDistribution,
        //todo:remove
        "z", "temp", &temp,
    );
    
    void writelnResult(Atom a) {
        if(forceTruthy) {
            a = Atom(a.truthiness);
        }
        if(jsonOutput) {
            writeln(a.atomToJson);
        }
        else {
            writeln(a.atomToString);
        }
    }
    
    if(useDebug) {
        Debugger.enable();
    }
    Debugger.print("args: ", args);

    if(useRepl) {
        return runMybyREPL();
    }
    
    int help() {
        defaultGetoptPrinter(
            "Usage: " ~ args[0] ~ " [flags] file-name",
            info.options
        );
        return 1;
    }
    
    if(!info.options) {
        return 3;
    }
    
    bool codeProvided = false;
    string fileName = fpath;
    
    if(code) {
        codeProvided = true;
    }
    else {
        if(!fileName && args.length >= 2) {
            fileName = args[1];
        }
        
        if(fileName) {
            try {
                code = cast(string)(read(fileName));
                codeProvided = true;
            }
            catch(FileException) {
                stderr.writeln("Error: Could not read file at ", fileName);
                return 2;
            }
        }
    }
    
    if(info.helpWanted) {
        return help();
    }
    if(!codeProvided) {
        stderr.writeln("Error: Expected an input file.");
        return help();
    }
    // if(outfile && !exists(outfile)) {
        // stderr.writeln("Error: Output file ", outfile, " does not exist.");
        // return help();
    // }
    
    void output(T...)(T args) {
        if(outfile) {
            write(outfile, args);
        }
        else {
            stdout.write(args);
        }
    }
    void outputln(T...)(T args) {
        if(outfile) {
            writeln(outfile, args);
        }
        else {
            stdout.writeln(args);
        }
    }
    
    if(temp) {
        auto a = parseLiterateOld(code).byteNibbleFmt;
        auto b = parseLiterate(code).byteNibbleFmt;
        stderr.writeln("Original: ", a);
        stderr.writeln("New:      ", b);
        return a == b ? 0 : 1;
    }
    
    if(measureSize) {
        Nibble[] nibs;
        if(literate) {
            nibs = parseLiterate(code);
        }
        else {
            nibs = getNibbles(code);
        }
        writeln(nibs.length / 2.0);
    }
    
    if(compile) {
        auto nibs = parseLiterate(code);
        int[] chars = nibbleToCharCodes(nibs);
        string res;
        foreach(i; chars) {
            res ~= cast(char)(i);
        }
        stderr.writeln("Converted bytes: ", nibs.byteNibbleFmt);
        if(dispTree) {
            Interpreter i = new Interpreter(nibs);
            i.shunt;
            debugChains(i.condense);
        }
        output(res);
        return 0;
    }
    
    if(decompile) {
        Nibble[] nibs;
        if(literate) {
            nibs = parseLiterate(code);
        }
        else {
            nibs = getNibbles(code);
        }
        writeln(toLiterate(nibs));
        return 0;
    }
    
    if(decompileAlign) {
        Nibble[] nibs;
        if(literate) {
            nibs = parseLiterate(code);
        }
        else {
            nibs = getNibbles(code);
        }
        writeln(toLiterateAligned(nibs));
    }
    
    if(noCode) {
        return 0;
    }
    
    foreach(fv, fname; [fValue, gValue, hValue].lockstep([InsName.F, InsName.G, InsName.H])) {
        if(fv) {
            Interpreter fInt = new Interpreter(fv);
            // ensure initialized
            getVerb(fname);
            // set definition
            fInt.shunt;
            Verb[] chains = fInt.condense;
            verbs[fname] = chains[$ - 1];
        }
    }
    
    Interpreter i;
    if(literate) {
        i = new Interpreter(code);
        stderr.writeln("Nibbles: ", i.code.byteNibbleFmt);
        stderr.writeln(i.code.length, " nibbles, ", i.code.length/2.0, " bytes");
    }
    else {
        Nibble[] nibs = getNibbles(code);
        i = new Interpreter(nibs);
    }
    i.shunt;
    Verb[] chains = i.condense;
    
    if(chains.length == 0) {
        // empty program is a no-op
        return 0;
    }
    
    Verb mainVerb = chains[$ - 1];
    
    /*
    void debugInfo(Verb v, int index = 0) {
        string rep="";foreach(i;0..index)rep~=' ';
        writeln(rep,v.inlineDisplay, "'s info:");
        writeln(rep,v.info);
        foreach(child; v.children) {
            debugInfo(child, index + 4);
        }
    }
    */
    if(Debugger.printing || dispTree) {
        debugChains(chains);
    }
    
    if(useRuntimeDebug) {
        Debugger.enable();
    }
    
    Atom[] verbArgs = args[fileName ? 2 : 1..$]
        .map!(arg => Interpreter.evaluate(arg ~ " @."))
        .array;
    Debugger.print("Verb args: ", verbArgs.map!"a.toString()");
    
    try {
        if(verbArgs.length > 0) {
            writelnResult(mainVerb(verbArgs));
        }
        else {
            //TODO: For now, just call it without arguments.
            //In the future, probably read from STDIN
            writelnResult(mainVerb());
        }
    }
    catch(AssertError e) {
        if(Debugger.printing) {
            Debugger.print(e);
        }
        else {
            stderr.writeln(
                "AssertError@", e.file, "(", e.line, ")", ": ",
                e.msg
            );
        }
        return 1;
    }
    
    return 0;
}
