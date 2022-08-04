module myby.literate;

import std.stdio : writeln;
import std.ascii : isDigit;
import std.conv : to;
import std.string : stripRight;
import std.range : popFrontN, popBackN;
import std.bigint;

import myby.nibble;
import myby.integer;
import myby.string;
import myby.instructions;
import myby.debugger;

enum NiladParseState {
    None,
    LastWasNilad,
    LastWasNiladSeparator,
}

int toHexDigit(char c) {
    if('0' <= c && c <= '9') return c - '0';
    else if('a' <= c && c <= 'f') return c - 'a' + 10;
    else if('A' <= c && c <= 'F') return c - 'A' + 10;
    else assert(0, "cannot convert '" ~ c ~ "' to a hex digit");
}

Nibble[] parseLiterate(T)(T str) {
    str = str.stripRight;
    Nibble[] code;
    uint finalParenCount = 0;
    uint initialParenCount = 0;
    uint i = 0;
    Debugger.print("Parsing input literate code: <", str, ">");
    NiladParseState state = NiladParseState.None;
    while(i < str.length) {
        Debugger.print("i=", i, ": ", str[i]);
        Debugger.print("code: ", code);
        NiladParseState nextState = NiladParseState.None;
        bool isNumber = str[i].isDigit;
        if(str[i] == '_' && i + 1 < str.length && str[i+1].isDigit) {
            isNumber = true;
        }
        if(isNumber) {
            Debugger.print("---> Number");
            if(state == NiladParseState.LastWasNiladSeparator) {
                code ~= 0x2;
            }
            int sign = 1;
            auto start = i;
            if(str[start] == '_') {
                sign = -1;
                start++;
                i++;
            }
            while(i < str.length && str[i].isDigit) {
                i++;
            }
            Debugger.print("Integer: <", str[start..i], ">");
            code ~= integerToNibbles(sign * BigInt(str[start..i]));
            Debugger.print("Code after append: ", code);
            nextState = NiladParseState.LastWasNilad;
        }
        else if(str[i] == '\'') {
            Debugger.print("---> String");
            if(state == NiladParseState.LastWasNiladSeparator) {
                code ~= 0x2;
            }
            string build = "";
            i++;
            while(i < str.length && str[i] != '\'') {
                if(str[i] == '\\' && i + 1 < str.length) {
                    switch(str[++i]) {
                        case 'n':  build ~= '\n'; break;
                        case 't':  build ~= '\t'; break;
                        case '0':  build ~= '\0'; break;
                        case '\'': build ~= '\''; break;
                        case '\\': build ~= '\\'; break;
                        case 'x':
                            uint d1 = toHexDigit(str[++i]);
                            uint d2 = toHexDigit(str[++i]);
                            build ~= cast(char)(d1 * 16 + d2);
                            break;
                        default:
                            assert(0, "Unknown escape: \\" ~ str[i]);
                    }
                }
                else {
                    build ~= str[i];
                }
                i++;
            }
            i++; // skip past last '
            Debugger.print("String to convert: <", build, ">");
            code ~= stringToNibbles(build);
            nextState = NiladParseState.LastWasNilad;
        }
        else {
            char head = str[i];
            string name = "" ~ head;
            bool hasNext = i + 1 < str.length;
            if(hasNext) {
                char next = str[i + 1];
                bool isDollarCompound = head == '$' && '1' <= next && next <= '4';
                bool isPartial = next == '.' || next == ':';
                
                if(isDollarCompound || isPartial) {
                    name ~= next;
                    i++;
                }
            }
            auto r = name in InstructionMap;
            if(r !is null) {
                Debugger.print("---> Operator");
                code ~= *r;
            }
            else switch(head) {
                case ' ':
                    if(state == NiladParseState.LastWasNilad) {
                        nextState = NiladParseState.LastWasNiladSeparator;
                    }
                    // ignore otherwise
                    break;
                case '\r':
                    // ignore
                    break;
                default:
                    writeln("Unhandled instruction: " ~ str[i]);
                    break;
            }
            if(head == ')') {
                finalParenCount++;
            }
            else {
                finalParenCount = 0;
            }
            if(head == '(' && i == initialParenCount) {
                initialParenCount++;
            }
            i++;
        }
        state = nextState;
    }
    
    Debugger.print("Final paren count: ", finalParenCount);
    code.popFrontN(initialParenCount);
    code.popBackN(finalParenCount);
    return code;
}