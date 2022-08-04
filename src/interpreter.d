module myby.interpreter;

import std.bigint;
import std.conv : to;
import std.range : back, popBack, popBackN;

import myby.nibble;
import myby.instructions;
import myby.integer;
import myby.string;
import myby.debugger;
import myby.literate : NiladParseState;

struct Token {
    SpeechPart speech;
    InstructionName name;
    union {
        BigInt big;
        string str;
    };
    
    string toString() {
        return "Token(" ~ to!string(speech)
            ~ " `" ~ to!string(name) ~ "`" ~ (
                name == InstructionName.Integer || name == InstructionName.CloseParen
                    ? ' ' ~ to!string(big)
                    : name == InstructionName.String
                        ? ' ' ~ str
                        : ""
            )
            ~ ")";
    }
    
    bool opEquals(Token other) {
        return other.speech == speech && other.name == name && (
            big == other.big || str == other.str
        );
    }
    
    static Token Break = Token(SpeechPart.Syntax, InstructionName.Break);
}

Token[] tokenize(Nibble[] code) {
    import std.stdio : writeln;
    Debugger.print("Tokenizing:");
    Debugger.print("    ", code);
    uint i = 0;
    Token[] tokens;
    while(i < code.length) {
        Token token;
        Nibble nib = code[i];
        if(nib == 0x0) {
            // reminder that nouns are just niladic verbs 
            token.speech = SpeechPart.Verb;
            token.name = InstructionName.Integer;
            token.big = nibblesToInteger(code, i);
        }
        else if(nib == 0x1) {
            token.speech = SpeechPart.Verb;
            token.name = InstructionName.String;
            token.str = nibblesToString(code, i);
        }
        else {
            // get name identifier using 1 or more nibbles
            int name = nib;
            void appendNibble() {
                name *= 16;
                nib = code[++i];
                name += nib;
            }
            if(nib == 0xF) {
                appendNibble;
                // extended characters
                if(nib == 0x1) {
                    appendNibble;
                }
                else if(nib == 0xE) {
                    appendNibble;
                    appendNibble;
                }
            }
            Debugger.print("Parsing instruction ", name.toBase16.nibbleFmt);
            auto tup = name in NameMap;
            assert(tup, "Cannot find instruction corresponding to "
                ~ name.toBase16.nibbleFmt);
            token.name = tup.name;
            token.speech = tup.speech;
            i++;
        }
        tokens ~= token;
    }
    return tokens;
}

bool isMain(SpeechPart speech) {
    return speech == SpeechPart.Verb || speech == SpeechPart.Adjective;
}

Token[] autoCompleteParentheses(Token[] tokens) {
    int balance = 0;
    int openMatch = 0;
    foreach(token; tokens) {
        if(token.name == InstructionName.OpenParen) {
            balance++;
        }
        else if(token.name == InstructionName.CloseParen) {
            balance--;
        }
        if(balance == -1) {
            Token open;
            open.name = InstructionName.OpenParen;
            open.speech = SpeechPart.Syntax;
            balance++;
            openMatch++;
        }
    }
    Token[] head;
    if(openMatch > 0) {
        head = new Token[openMatch];
        foreach(ref tok; head) {
            tok.name = InstructionName.OpenParen;
            tok.speech = SpeechPart.Syntax;
        }
    }
    Token[] tail;
    if(balance > 0) {
        tail = new Token[balance];
        foreach(ref tok; tail) {
            tok.name = InstructionName.CloseParen;
            tok.speech = SpeechPart.Syntax;
        }
    }
    return head ~ tokens ~ tail;
}

import std.stdio;
class Interpreter {
    Nibble[] code;
    Token[] stack;
    this(Nibble[] c) {
        code = c;
        // writeln(nibbleToCharCodes(code));
        // writeln(code.tokenize);
    }
    this(T)(T str) {
        import myby.literate : parseLiterate;
        this(str.parseLiterate);
    }
    
    void shunt() {
        Token[] opStack;
        uint[] parenStackArity = [0];
        SpeechPart previous = SpeechPart.Syntax;
        
        void flushOpStack() {
            while(opStack.length && opStack[$-1].name != InstructionName.OpenParen) {
                stack ~= opStack.back;
                opStack.popBack;
            }
        }
        
        foreach(i, token; code.tokenize.autoCompleteParentheses) {
            // writeln(i, ": ", token);
            // writeln(stack);
            
            final switch(token.speech) {
                case SpeechPart.Verb:
                    // flush opStack if at barrier
                    if(previous == SpeechPart.Verb || previous == SpeechPart.Adjective) {
                        flushOpStack();
                    }
                    stack ~= token;
                    parenStackArity[$-1]++;
                    break;
                case SpeechPart.Adjective:
                    flushOpStack();
                    stack ~= token;
                    break;
                case SpeechPart.Conjunction:
                    // this is where precedence handling would go
                    opStack ~= token;
                    parenStackArity[$-1]--;
                    break;
                case SpeechPart.MultiConjunction:
                    flushOpStack();
                    stack ~= token;
                    uint valence = getMultiConjunction(token.name).valence;
                    if(valence == 0) {
                        // reduces all items in context to a single verb
                        parenStackArity[$-1] = 1;
                    }
                    else {
                        parenStackArity[$-1] -= valence - 1;
                    }
                    break;
                case SpeechPart.Syntax:
                    switch(token.name) {
                        case InstructionName.OpenParen:
                            opStack ~= token;
                            parenStackArity ~= 0;
                            break;
                            
                        case InstructionName.CloseParen:
                            // TODO: exploit behavior?
                            assert(parenStackArity.length, "Close parenthesis without open parenthesis");
                            uint count = parenStackArity.back;
                            parenStackArity.popBack;
                            flushOpStack();
                            opStack.popBack; // pop `(`
                            stack ~= Token(
                                SpeechPart.Syntax,
                                InstructionName.CloseParen,
                                BigInt(count)
                            );
                            break;
                            
                        case InstructionName.Break:
                            stack ~= token;
                            break;
                        
                        default:
                            //TODO: error
                            assert(false, "Received invalid Syntax part");
                    }
                    break;
            }
            
            previous = token.speech;
        }
        
        flushOpStack();
        
        // writeln("Shunted : ", stack);
    }
    
    void condenseVerbChain(ref Verb[] verbs) {
        while(verbs.length != 1) {
            if(verbs.length >= 3) {
                Debugger.print("Fork");
                // remove a three train from the right
                // combines into a fork
                Verb f, g, h;
                f = verbs[$-3];
                g = verbs[$-2];
                h = verbs[$-1];
                verbs.popBackN(2);
                verbs[$-1] = Verb.fork(f, g, h);
            }
            else if(verbs.length == 2) {
                Debugger.print("Atop");
                // remove the two train, an atop
                Verb f, g;
                f = verbs[$-2];
                g = verbs[$-1];
                verbs.popBack;
                verbs[$-1] = compose(f, g);
            }
            else {
                // i don't know how we got here
                writeln("Huh? idk what to do with ", verbs.length, " verbs...");
                assert(false);
            }
        }
    }
    
    Verb condenseTokenChain(T)(T chain) {
        // first, produce a list of verbs
        Verb[] verbs;
        Atom[] listBuild;
        NiladParseState state = NiladParseState.None;
        NiladParseState nextState;
        void finishListBuild() {
            if(listBuild.length == 0) return;
            
            Debugger.print("Pushing list build: ", listBuild);
            verbs ~= Verb.nilad(Atom(listBuild));
            listBuild = [];
        }
        void addNilad(T)(T n) {
            Debugger.print("Adding nilad...");
            auto v = Verb.nilad(n);
            if(state == NiladParseState.LastWasNiladSeparator) {
                Debugger.print("...to list!");
                listBuild ~= v();
                Debugger.print("List: ", listBuild);
            }
            else {
                Debugger.print("...to verb chain!");
                verbs ~= v;
            }
        }
        foreach(token; chain) {
            nextState = NiladParseState.None;
            Debugger.print("==== step ====");
            Debugger.print("state: ", state);
            Debugger.print("token: ", token);
            final switch(token.speech) {
                case SpeechPart.Verb:
                    if(token.name == InstructionName.Integer) {
                        addNilad(token.big);
                        nextState = NiladParseState.LastWasNilad;
                    }
                    else if(token.name == InstructionName.String) {
                        addNilad(token.str);
                        nextState = NiladParseState.LastWasNilad;
                    }
                    else {
                        finishListBuild;
                        verbs ~= getVerb(token.name);
                    }
                    break;
                    
                case SpeechPart.Adjective:
                    if(state == NiladParseState.LastWasNilad && token.name == InstructionName.Filter) {
                        Debugger.print("Nilad separator!");
                        if(listBuild.length == 0) {
                            Debugger.print("Initializing with top (niladic) verb");
                            listBuild ~= verbs[$-1]();
                            verbs.popBack;
                        }
                        nextState = NiladParseState.LastWasNiladSeparator;
                    }
                    else {
                        assert(verbs.length >= 1, "Expected a verb for adjective "
                            ~ to!string(token.name));
                        Adjective adj = getAdjective(token.name);
                        finishListBuild;
                        verbs[$-1] = adj.transform(verbs[$-1]);
                    }
                    break;
                
                case SpeechPart.Conjunction:
                    assert(verbs.length >= 2, "Expected two verbs for conjunction "
                        ~ to!string(token.name));
                    Conjunction con = getConjunction(token.name);
                    finishListBuild;
                    Verb f = verbs[$-2];
                    Verb g = verbs[$-1];
                    verbs.popBack;
                    verbs[$-1] = con.transform(f, g);
                    break;
                
                case SpeechPart.MultiConjunction:
                    MultiConjunction mc = getMultiConjunction(token.name);
                    finishListBuild;
                    Verb[] args;
                    uint valence;
                    if(mc.valence == 0) {
                        valence = verbs.length;
                    }
                    else {
                        valence = mc.valence;
                    }
                    assert(verbs.length >= valence,
                        "Expected " ~ to!string(valence) ~ " verbs for multi-conjunction "
                        ~ to!string(token.name));
                    
                    args = verbs[$-valence..$];
                    verbs.popBackN(valence-1);
                    verbs[$-1] = mc.transform(args);
                    break;
                    
                case SpeechPart.Syntax:
                    // writeln("Unhandled: ", token);
                    assert(token.name == InstructionName.CloseParen);
                    // TODO: handle more syntax?
                    auto amount = to!int(token.big);
                    finishListBuild;
                    auto last = verbs[$-amount..$];
                    verbs.popBackN(amount-1);
                    condenseVerbChain(last);
                    verbs[$-1] = last[$-1];
                    break;
            }
            state = nextState;
            Debugger.print("Verbs: ", verbs);
            Debugger.print("");
        }
        Debugger.print("Final condensation:");
        finishListBuild;
        // second, condense the train down to a single verb
        Debugger.print("Resulting verbs: ", verbs);
        condenseVerbChain(verbs);
        return verbs[0];
    }
    
    Verb condense() {
        // import std.algorithm.iteration : splitter;
        import std.range : split;
        
        Debugger.print("Initial stack:");
        Debugger.print(stack);
        Verb[] chains;
        foreach(chain; stack.split(Token.Break)) {
            Debugger.print("CHAIN:");
            Debugger.print("   ",chain);
            Verb chainVerb = condenseTokenChain(chain);
            chains ~= chainVerb;
        }
        return chains[0];
    }
}
