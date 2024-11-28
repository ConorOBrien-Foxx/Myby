module myby.gui;

import std.algorithm.iteration;
import std.array;
import std.datetime.systime;
import std.file : exists;
import std.json;
import std.process;
import std.stdio;
import std.string : strip, startsWith;

import myby.debugger;
import myby.instructions;
import myby.interpreter;
import myby.literate;
import myby.nibble;
import myby.speech;
import myby.token;

string getTimeId() {
    SysTime now = Clock.currTime();
    return "[D@" ~ now.toString ~ "]";
}

void warn(A...)(A a) {
    stderr.writeln(getTimeId(), ": ", a);
}

void debugWarn(A...)(A a) {
    if(Debugger.enabled) {
        warn(a);
    }
}

struct ReconstructedASTNode {
    string head;
    string type;
    ReconstructedASTNode[] children;

    JSONValue asJSON() {
        JSONValue hash = [
            "head": JSONValue(head),
            "type": JSONValue(type),
            "children": JSONValue(children.map!(child => child.asJSON).array),
        ];
        return hash;
    }
}

ReconstructedASTNode reconstructAST(Verb v) {
    ReconstructedASTNode result;
    // writeln(v);
    if(v.display == Verb.ForkRepresentation) {
        result.head = v.display;
    }
    else {
        result.head = v.token.toRepresentation;
    }
    if(v.children.length > 0) {
        if(v.token.isInitialized) {
            auto info = v.token.name in Info;
            if(info != null) {
                auto partOfSpeech = info.speech;
                switch(partOfSpeech) {
                    case SpeechPart.Adjective:
                        result.type = "adjective";
                        break;
                    case SpeechPart.Conjunction:
                        result.type = "conjunction";
                        break;
                    case SpeechPart.MultiConjunction:
                        result.type = "multiConjunction";
                        break;
                    default:
                        stderr.writeln("How does this " ~ v.token.toString ~ " have children?!");
                        result.type = "genericContainer";
                }
            }
            else {
                stderr.writeln("What is this " ~ v.token.toString ~ " even?!");
                result.type = "genericContainer";
            }
        }
        // the implicit constructions require special cases
        else if(v.display == Verb.ForkRepresentation) {
            result.type = "implicitFork";
        }
        else if(v.display == Verb.ComposeRepresentation) {
            result.type = "implicitCompose";
        }
        else if(v.display == Verb.BindRepresentation) {
            result.type = "implicitBind";
        }
        else {
            stderr.writeln("What is this un-tokened " ~ v.toString ~ " even?!");
            result.type = "genericContainer";
        }
        
        // writeln(v.children.length, " children");
        foreach(child; v.children) {
            // writeln("Child: ", child);
            ReconstructedASTNode val = reconstructAST(child);
            result.children ~= val;
        }
    }
    else {
        result.type = "leaf";
        // writeln("leaf.");
    }

    return result;
}

int startGui() {
    string serverPath = environment.get("MYBY_NODE_SERVER", "./src/gui/main.js");
    writeln("server path: ", serverPath);
    assert(exists(serverPath),
        "Could not find server at " ~ serverPath ~ "; did you mean to set a custom " ~ 
        "MYBY_NODE_SERVER environment variable pointing to the appropriate server?"
    );

    // TODO: fully qualified path for node executable? e.g. /usr/bin/node or whatever
    auto pipes = pipeProcess(["node", serverPath], Redirect.stdin | Redirect.stdout);
    scope(exit) wait(pipes.pid);

    while(true) {
        auto line = pipes.stdout.readln();
        if(line is null || line.strip == "quit") {
            debugWarn("Quiting...");
            break;
        }
        debugWarn("Line received: ", line.strip);
        // TODO: verify successful JSON parse
        try {
            JSONValue j = parseJSON(line);
            string action = j["action"].str;

            debugWarn("Action: ", action);

            JSONValue response = [
                "id": j["id"],
                "error": JSONValue(false),
            ];
            if(action == "tokenize") {
                Nibble[] nibs = parseLiterate(j["code"].str);
                Token[] tokens = nibs.tokenize;
                auto sections = toLiterateAlignedBuilder(nibs, tokens);

                response["tokens"] = sections.map!(section => JSONValue([
                    "reps": section.reps,
                    "nibbles": section.nibbles,
                ])).array;
            }
            else if(action == "nibbleCount") {
                try {
                    Nibble[] nibs = parseLiterate(j["code"].str);
                    response["nibbleCount"] = nibs.length;
                }
                catch(Throwable t) {
                    response["error"] = true;
                    warn("Error while trying to count nibbles of ", j["code"].str, ":\n", t);
                }
            }
            else if(action == "evaluate") {
                string code = j["code"].str;
                // TODO: multiple inputs
                string x = j["x"].str;
                string y = j["y"].str;
                debugWarn("Code: ", code, "; x: ", x, "; y: ", y);
                Interpreter i = new Interpreter(code);
                i.shunt;
                Verb[] chains = i.condense;
                if(chains.length == 0) {
                    // TODO: implement empty program no-op behavior
                }
                else {
                    Verb mainVerb = chains[$ - 1];
                    Atom result;
                    try {
                        Atom[] verbArgs;
                        if(x.length != 0) {
                            verbArgs ~= Interpreter.evaluate(x ~ " @.");
                        }
                        if(y.length != 0) {
                            verbArgs ~= Interpreter.evaluate(y ~ " @.");
                        }
                        verbChildValueRetainer.enable();
                        verbChildValueRetainer.begin();
                        result = mainVerb(verbArgs);
                        verbChildValueRetainer.end();
                    }
                    catch(Throwable t) {
                        // TODO: we should probably be using custom errors
                        response["error"] = true;
                    }
                    if(!response["error"].boolean) {
                        // store the AST
                        response["ast"] = reconstructAST(mainVerb).asJSON;
                        // value flow
                        response["flow"] = verbChildValueRetainer
                            .values
                            .byPair
                            .map!(pair => [
                                JSONValue(pair.key),
                                JSONValue(pair.value.map!(atom => atom.as!JSONValue).array)
                            ])
                            .array;
                        verbChildValueRetainer.disable();
                        response["value"] = result.as!JSONValue;
                        response["repr"] = result.atomToString;
                    }
                }
            }
            else {
                response["error"] = true;
                warn("Unknown action " ~ action ~ " from " ~ line);
                break;
            }
            debugWarn("Writing: ", response.toString);
            pipes.stdin.writeln(response.toString);
            pipes.stdin.flush();
        }
        catch(Throwable t) {
            warn("Uncaught exception during main loop:\n", t);
        }
    }
    pipes.stdin.close();

    /*
    int i = 0;
    while(true) {
        i++;
        import std.conv : to;
        pipes.stdin.writeln("here's a test message " ~ i.to!string);
        pipes.stdin.flush();
        auto line = pipes.stdout.readln();
        writeln(">>>> WE GOT A LINE BACK!? ", line);
        if(line is null || line == "quit\n") {
            writeln("Breaking...");
            break;
        }
    }
    pipes.stdin.close();
    writeln("End of loop");
    */

    /*
    auto pid = spawnProcess(
        ["node", serverPath],
        stdin,
        stdout,
        stderr,
    );
    scope(exit) wait(pid);

    // pipes.stdin.flush();
    // auto line = pipes.stdout.readln();
    // writeln("Out: ", line.idup);
    // pipes.stdin.close();
*/
    

    // foreach (line; pipes.stdout.byLine) writeln("Out: ", line.idup);
    // foreach (line; pipes.stderr.byLine) writeln("Err: ", line.idup);
    return 0;
}
