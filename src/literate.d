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

enum LiterateType {
    Unknown,
    Comment,
    Integer,
    Real,
    String,
    KeyAccess,
    Identifier,
    Whitespace,
    Alias,
    AliasDefine,
}
struct LiterateToken {
    LiterateType type;
    union {
        struct { BigInt head; BigInt tail; }
        string str;
        LiterateInfo info; 
    }
    
    string toString() {
        final switch(type) {
            case LiterateType.Unknown:
                return "LiterateToken(<Unknown>)";
                
            case LiterateType.Comment:
                return "LiterateToken(Comment)";
                
            case LiterateType.Integer:
                return "LiterateToken(Integer, "
                     ~ to!string(head) ~ ")";
                     
            case LiterateType.Real:
                return "LiterateToken(Integer, "
                     ~ to!string(head) ~ ".rev"
                     ~ to!string(tail) ~ ")";
                     
            case LiterateType.String:
                return "LiterateToken(String, '"
                     ~ to!string(str) ~ "')";
                     
            case LiterateType.KeyAccess:
                return "LiterateToken(KeyAccess, $."
                     ~ to!string(str) ~ ")";
                     
            case LiterateType.Identifier:
                return "LiterateToken(Identifier, "
                     ~ to!string(info.nibs) ~ " "
                     ~ to!string(info.speech) ~ ")";
                     
            case LiterateType.Alias:
                return "LiterateToken(Alias, "
                     ~ to!string(str) ~ ")";
                     
            case LiterateType.AliasDefine:
                return "LiterateToken(AliasDefine, "
                     ~ to!string(str) ~ ":)";
                
            case LiterateType.Whitespace:
                return "LiterateToken(Whitespace)";
        }
    }
}

enum IdentifierPostfixes = [ '.', ':' ];
enum IdentifierPrefixes = [ '$' ];
enum MaxAliasCount = 32;
LiterateToken[] tokenizeLiterate(T)(T str) {
    import std.algorithm.searching : canFind;
    /* 1. definitions */
    LiterateToken[] tokens;
    string[] aliases;
    
    uint i = 0;
    
    bool hasIndex(uint ip) {
        return ip < str.length;
    }
    
    bool hasAhead(T)(T needle) {
        static if(is(T == string)) {
            if(needle.length == 0) {
                return true;
            }
            return hasIndex(i + needle.length - 1)
                && str[i..i+needle.length] == needle;
        }
        static if(is(T == char)) {
            return hasIndex(i + 1)
                && str[i + 1] == needle;
        }
    }
    
    bool hasAheadFn(alias fn)() {
        return hasIndex(i + 1)
            && fn(str[i + 1]);
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
    
    string readAlphabetic() {
        string name;
        while(i < str.length && 'a' <= str[i] && str[i] <= 'z') {
            name ~= str[i++];
        }
        return name;
    }
    
    /* 2. tokenization */
    while(i < str.length) {
        LiterateToken token;
        if(hasAhead("NB.")) {
            // Comment
            while(i < str.length && str[i] != '\n') {
                i++;
            }
            token.type = LiterateType.Comment;
        }
        else if(str[i].isDigit || str[i] == '_' && hasAheadFn!isDigit) {
            // Integer or Real
            token.head = parseNumber();
            if(i < str.length && str[i] == '.') {
                i++;
                token.tail = parseNumber(true);
                token.type = LiterateType.Real;
            }
            else {
                token.type = LiterateType.Integer;
            }
        }
        else if(str[i] == '\'') {
            // String
            string build = "";
            i++;
            while(i < str.length) {
                // termination condition
                if(str[i] == '\'') {
                    // doubling up on '' is another way to escape a quote
                    if(hasAhead('\'')) {
                        build ~= str[++i];
                    }
                    else {
                        break;
                    }
                }
                else if(str[i] == '\\' && i + 1 < str.length) {
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
            token.str = build;
            token.type = LiterateType.String;
        }
        else if(hasAhead("$.")) {
            // Access Key
            i += 2;
            token.str = readAlphabetic();
            token.type = LiterateType.KeyAccess;
        }
        else {
            char head = str[i];
            string name = readAlphabetic();
            if(name.length == 0) {
                name ~= str[i];
            }
            else {
                i--;
            }
            if(hasIndex(i + 1)) {
                i++;
                // dollar prefix joins to a single command
                if(IdentifierPrefixes.canFind(head)) {
                    name ~= str[i];
                }
                else if(IdentifierPostfixes.canFind(str[i])) {
                    while(hasIndex(i) && IdentifierPostfixes.canFind(str[i])) {
                        name ~= str[i++];
                    }
                    i--;
                }
                else {
                    i--;
                }
            }
            
            auto r = name in InstructionMap;
            if(r !is null) {
                token.info = *r;
                token.type = LiterateType.Identifier;
            }
            else if(aliases.canFind(name)) {
                token.type = LiterateType.Alias;
                token.str = name;
            }
            else if(head == ' ' || head == '\r') {
                // ignore
                token.type = LiterateType.Whitespace;
            }
            else if(name[$-1] == ':') {
                // TODO: check for redefined alias
                token.type = LiterateType.AliasDefine;
                string finalName = name[0..$-1];
                aliases ~= finalName;
                token.str = finalName;
            }
            else {
                assert(0, "Unhandled instruction: " ~ name);
            }
            i++;
        }

        assert(token.type != LiterateType.Unknown, "Malformed token");
        if(token.type != LiterateType.Whitespace
        && token.type != LiterateType.Comment) {
            tokens ~= token;
        }
    }
    
    return tokens;
}

Nibble[] parseLiterate(T)(T str) {
    import std.algorithm.mutation : strip, stripLeft, stripRight;
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
    
    import std.stdio;
    Debugger.print("===== TOKENIZE DEBUG =====");
    auto tokens = tokenizeLiterate(str)
        // remove leading and trailing breaks
        .strip!(a => a.type == LiterateType.Identifier && a.info.nibs == Info[InsName.Break].nibs)
        // remove leading open parentheses
        .stripLeft!(a => a.type == LiterateType.Identifier && a.info.nibs == Info[InsName.OpenParen].nibs)
        // remove trailnig close parentheses
        .stripRight!(a => a.type == LiterateType.Identifier && a.info.nibs == Info[InsName.CloseParen].nibs);
        
    foreach(i, tok; tokens) {
        Debugger.print(i, ": ", tok);
        final switch(tok.type) {
            case LiterateType.Integer:
                code ~= integerToNibbles(tok.head);
                break;
            
            case LiterateType.Real:
                code ~= realToNibbles(tok.head, tok.tail);
                break;
            
            case LiterateType.String:
                code ~= stringToNibbles(tok.str);
                break;
            
            case LiterateType.KeyAccess:
                code ~= Info[InsName.OpenParen].nibs;
                code ~= stringToNibbles(tok.str);
                code ~= Info[InsName.Bond].nibs;
                code ~= Info[InsName.First].nibs;
                code ~= Info[InsName.CloseParen].nibs;
                break;
                
            case LiterateType.Identifier:
                code ~= tok.info.nibs;
                // TODO: assert two consecutive conjunctions do not exist
                break;
                
            case LiterateType.Alias:
                assert(tok.str in aliases, "Undefined alias: " ~ tok.str);
                code ~= aliases[tok.str];
                break;
            
            case LiterateType.AliasDefine:
                uint index = aliases.length;
                Nibble[] aliasCode = aliasFor(index);
                aliases[tok.str] = aliasCode;
                code ~= aliasCode;
                break;
            
            case LiterateType.Unknown:
            case LiterateType.Comment:
            case LiterateType.Whitespace:
                assert(0, "Unexpected token type passed through: " ~ tok.type.to!string);
        }
    }
    Debugger.print("Nibbles: ", code.byteNibbleFmt);
    Debugger.print("===== / TOKENIZE DEBUG =====");
    return code;
}

// gonna keep this around for a bit, despite not being called
// TODO: remove
Nibble[] parseLiterateOld(T)(T str) {
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
                assert(0, "Adjacent numbers forming a list is disabled.");
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
                assert(0, "Adjacent numbers forming a list is disabled.");
            }
            string build = "";
            i++;
            while(i < str.length) {
                // termination condition
                if(str[i] == '\'') {
                    // doubling up on '' is another way to escape a quote
                    if(i + 1 < str.length && str[i + 1] == '\'') {
                        build ~= str[++i];
                    }
                    else {
                        break;
                    }
                }
                else if(str[i] == '\\' && i + 1 < str.length) {
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
