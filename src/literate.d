module myby.literate;

import std.ascii : isDigit;
import std.bigint;
import std.conv : to;
import std.range : popFrontN, popBackN, retro;
import std.stdio : writeln;
import std.string : strip;

import myby.debugger;
import myby.instructions;
import myby.integer;
import myby.nibble;
import myby.string;

enum UseFilterSeparators = false;

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
    str = str.strip;
    Nibble[] code;
    Nibble[][string] aliases;
    
    Nibble[] aliasFor(uint index) {
        // FEA0-FEBF
        Nibble[] res = [0xF, 0xE, 0x0, 0x0];
        res[2] = cast(Nibble)(0xA + index / 16);
        res[3] = cast(Nibble)(index % 16);
        assert(res[2] <= 0xB, "Out of room for aliases");
        return res;
    }
    
    uint finalParenCount = 0;
    uint initialParenCount = 0;
    uint i = 0;
    
    void readAlphabetic(ref string name) {
        while(i < str.length && 'a' <= str[i] && str[i] <= 'z') {
            name ~= str[i++];
        }
    }
    
    Debugger.print("Parsing input literate code: <", str, ">");
    NiladParseState state = NiladParseState.None;
    bool lastWasConjunction = false;
    bool isLineStart = true;
    string lastConjunction;
    while(i < str.length) {
        bool thisIsConjuction = false;
        Debugger.print("i=", i, ": ", str[i]);
        Debugger.print("code: ", code);
        NiladParseState nextState = NiladParseState.None;
        
        bool isComment = i + 3 < str.length && str[i..i+3] == "NB.";
        
        bool isNumber = str[i].isDigit;
        if(str[i] == '_' && i + 1 < str.length && str[i+1].isDigit) {
            isNumber = true;
        }
        
        if(isComment) {
            while(i < str.length && str[i] != '\n') {
                i++;
            }
        }
        else if(isNumber) {
            Debugger.print("---> Number");
            if(state == NiladParseState.LastWasNiladSeparator) {
                code ~= 0x2;
                assert(UseFilterSeparators, "Adjacent numbers forming a list is disabled.");
            }
            BigInt parseNumber(bool reverse=false) {
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
                string rep = str[start..i];
                return sign * BigInt(reverse ? to!string(rep.retro) : rep);
            }
            
            BigInt head = parseNumber();
            if(i < str.length && str[i] == '.') {
                i++;
                BigInt tail = parseNumber(true);
                Debugger.print("Float: <", head, ".rev ", tail, ">");
                code ~= realToNibbles(head, tail);
            }
            else {
                Debugger.print("Integer: <", head, ">");
                code ~= integerToNibbles(head);
            }
            Debugger.print("Code after append: ", code);
            nextState = NiladParseState.LastWasNilad;
        }
        else if(str[i] == '\'') {
            Debugger.print("---> String");
            // TODO: a separator might not be necessary, since 
            // what else could two adjacent nilads indicate?
            if(state == NiladParseState.LastWasNiladSeparator) {
                code ~= 0x2;
                assert(UseFilterSeparators, "Adjacent numbers forming a list is disabled.");
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
        // access keys: $.key
        else if(str[i] == '$' && i + 1 < str.length && str[i + 1] == '.') {
            i += 2;
            string name;
            readAlphabetic(name);
            // ( name & { )
            code ~= Info[InsName.OpenParen].nibs;
            code ~= stringToNibbles(name);
            code ~= Info[InsName.Bond].nibs;
            code ~= Info[InsName.First].nibs;
            code ~= Info[InsName.CloseParen].nibs;
        }
        else {
            char head = str[i];
            string name;
            readAlphabetic(name);
            if(name.length == 0) {
                name ~= str[i];
            }
            else {
                i--;
            }
            bool hasNext = i + 1 < str.length;
            if(hasNext) {
                i++;
                if(head == '$') {
                    name ~= str[i];
                }
                else if(str[i] == '.' || str[i] == ':') {
                    while(i < str.length && (str[i] == '.' || str[i] == ':')) {
                        name ~= str[i++];
                    }
                    i--;
                }
                else {
                    i--;
                }
            }
            Debugger.print("Parsed name: ", name);
            auto r = name in InstructionMap;
            auto aCode = name in aliases;
            if(r !is null) {
                Debugger.print("---> Operator");
                
                if(name == "\n") {
                    isLineStart = true;
                }
                if(code.length || name != "\n") {
                    code ~= r.nibs;
                }
                thisIsConjuction = r.speech == SpeechPart.Conjunction;
                // TODO: throw an actual syntax error.
                assert(
                    !(lastWasConjunction && thisIsConjuction),
                    "Syntax error: Two consecutive conjunctions `"
                        ~ lastConjunction ~ '`'
                        ~ " and `" ~ name ~ '`'
                );
                lastConjunction = name;
            }
            else if(aCode !is null) {
                Debugger.print("Outputting known alias:", name, " -> ", (*aCode).basicNibbleFmt);
                code ~= *aCode;
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
                    // aliases end with :
                    if(name[$-1] == ':') {
                        string finalName = name[0..$-1];
                        uint index = aliases.length;
                        Nibble[] aliasCode = aliasFor(index);
                        aliases[finalName] = aliasCode;
                        code ~= aliasCode;
                    }
                    else {
                        assert(0, "Unhandled instruction: " ~ name);
                    }
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
        lastWasConjunction = thisIsConjuction;
    }
    
    Debugger.print("Final paren count: ", finalParenCount);
    code.popFrontN(initialParenCount);
    code.popBackN(finalParenCount);
    return code;
}