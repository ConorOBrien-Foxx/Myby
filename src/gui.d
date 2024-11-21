module myby.gui;

import std.algorithm.iteration;
import std.array;
import std.file : exists;
import std.json;
import std.process;
import std.stdio;
import std.string : strip, startsWith;

import myby.interpreter;
import myby.literate;
import myby.nibble;
import myby.token;

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
            break;
        }
        // TODO: verify successful JSON parse
        JSONValue j = parseJSON(line);
        string action = j["action"].str;

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
                stderr.writeln("Error while trying to count nibbles of ", j["code"].str, ":");
                stderr.writeln(t);
                data["error"] = true;
            }
            pipes.stdin.writeln(data.toString);
            pipes.stdin.flush();
        }
        else {
            stderr.writeln("Unknown action " ~ action ~ " from " ~ line);
            break;
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
