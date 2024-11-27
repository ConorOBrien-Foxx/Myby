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
import myby.interpreter;
import myby.literate;
import myby.nibble;
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

            if(action == "tokenize") {
                Nibble[] nibs = parseLiterate(j["code"].str);
                Token[] tokens = nibs.tokenize;
                auto sections = toLiterateAlignedBuilder(nibs, tokens);

                JSONValue data = [
                    "id": j["id"],
                    // sad JSONValue cannot automatically convert structs to JSON
                    "tokens": JSONValue(sections.map!(section => JSONValue([
                        "reps": section.reps,
                        "nibbles": section.nibbles,
                    ])).array),
                ];
                pipes.stdin.writeln(data.toString);
                pipes.stdin.flush();
            }
            else if(action == "nibbleCount") {
                JSONValue data = [
                    "id": j["id"],
                    "error": JSONValue(false),
                ];
                try {
                    Nibble[] nibs = parseLiterate(j["code"].str);
                    data["nibbleCount"] = nibs.length;
                }
                catch(Throwable t) {
                    warn("Error while trying to count nibbles of ", j["code"].str, ":\n", t);
                    data["error"] = true;
                }
                debugWarn("Writing: ", data.toString);
                pipes.stdin.writeln(data.toString);
                pipes.stdin.flush();
            }
            else {
                warn("Unknown action " ~ action ~ " from " ~ line);
                break;
            }
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
