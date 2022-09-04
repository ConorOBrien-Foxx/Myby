module myby.main;

import std.algorithm.iteration : map;
import std.array;
import std.bigint;
import std.getopt;
import std.stdio;
import std.sumtype;

// TODO: remove superfluous headers
import myby.debugger;
import myby.format;
import myby.instructions;
import myby.integer;
import myby.interpreter;
import myby.literate;
import myby.nibble;
import myby.speech;
import myby.string;

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

int main(string[] args) {
    import std.file : read, FileException, write, exists;
    import core.exception : AssertError;
    
    bool compile;
    bool literate;
    bool useDebug;
    string outfile;
    string fpath;
    string code;
    auto info = getoptSafeError(
        args,
        "compile|c", "Compile literate program", &compile,
        "outfile|o", "Outputs relevant data to specified file", &outfile,
        "literate|l", "Input source is a literate program", &literate,
        "file|f", "Uses named file", &fpath,
        "execute|e", "Executes provided code", &code,
        "debug|d", "Prints debug information", &useDebug,
    );
    
    if(useDebug) {
        Debugger.enable();
    }
    Debugger.print("args: ", args);
    
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
    
    if(compile) {
        auto nibs = parseLiterate(code);
        int[] chars = nibbleToCharCodes(nibs);
        string res;
        foreach(i; chars) {
            res ~= cast(char)(i);
        }
        stderr.writeln("Converted bytes: ", nibs.byteNibbleFmt);
        output(res);
        return 0;
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
    
    if(Debugger.printing) {
        foreach(chainIndex, v; chains) {
            writeln("Chain ", chainIndex, ":");
            writeln(treeToBoxedString(v));
        }
    }
    
    Atom[] verbArgs = args[fileName ? 2 : 1..$]
        .map!(arg => Interpreter.evaluate(arg ~ " @."))
        .array;
    Debugger.print("Verb args: ", verbArgs.map!"a.toString()");
    
    try {
        if(verbArgs.length > 0) {
            writeln(mainVerb(verbArgs).atomToString());
        }
        else {
            //TODO: For now, just call it without arguments.
            //In the future, probably read from STDIN
            writeln(mainVerb().atomToString());
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