module myby.interpreter;

import std.bigint;
import std.conv : to;
import std.range : back, popBack, popBackN;

import myby.debugger;
import myby.instructions;
import myby.integer;
import myby.literate : NiladParseState;
import myby.nibble;
import myby.speech;
import myby.string;

struct Token {
    SpeechPart speech;
    InsName name;
    union {
        BigInt big;
        string str;
        real   dec;
    };
    int index = -1;
    
    bool isNilad() {
        return name == InsName.Integer || name == InsName.String;
    }
    
    string toString() {
        string addendum;
        switch(name) {
            case InsName.Integer:
            case InsName.CloseParen:
                addendum = to!string(big);
                break;
            case InsName.String:
                addendum = str;
                break;
            case InsName.Real:
                addendum = to!string(dec);
                break;
            default:
                break;
        }
        if(addendum) {
            addendum = ' ' ~ addendum;
        }
        return "Token(" ~ to!string(speech)
            ~ " `" ~ to!string(name) ~ "`"
            ~ addendum
            ~ " @" ~ to!string(index)
            ~ ")";
    }
    
    bool opEquals(Token other) {
        return other.speech == speech && other.name == name && (
            big == other.big || str == other.str
        );
    }
    
    static Token Break = Token(SpeechPart.Syntax, InsName.Break);
}

enum ConjunctionNibbles = [0xA, 0xD];
enum TwoNibbleOverrides = [0xAC, 0xDC, 0xBA, 0xBC, 0xBD];
Token[] tokenize(Nibble[] code) {
    import std.algorithm.searching : canFind;
    Debugger.print("Tokenizing:");
    Debugger.print("    ", code);
    uint i = 0;
    Token[] tokens;
    while(i < code.length) {
        Token token;
        token.index = i;
        Nibble nib = code[i];
        // reminder that nouns are just niladic verbs 
        if(nib == 0x0) {
            // distinguish between doubles and ints
            if(i + 1 < code.length && code[i + 1] == 0xB) {
                token.speech = SpeechPart.Verb;
                token.name = InsName.Real;
                token.dec = nibblesToReal(code, i);
            }
            else {
                token.speech = SpeechPart.Verb;
                token.name = InsName.Integer;
                token.big = nibblesToInteger(code, i);
            }
        }
        else if(nib == 0x1) {
            token.speech = SpeechPart.Verb;
            token.name = InsName.String;
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
            // extended characters
            if(i + 1 < code.length && TwoNibbleOverrides.canFind(name * 16 + code[i + 1])) {
                appendNibble;
            }
            else if(nib == 0xF) {
                appendNibble;
                if(nib == 0x1) {
                    appendNibble;
                }
                else if(nib == 0xE) {
                    appendNibble;
                    appendNibble;
                }
            }
            // consecutive conjunctions mean something else
            else if(ConjunctionNibbles.canFind(nib)) {
                while(i + 1 < code.length && ConjunctionNibbles.canFind(code[i + 1])) {
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
        if(token.name == InsName.OpenParen) {
            balance++;
        }
        else if(token.name == InsName.CloseParen) {
            balance--;
        }
        if(balance == -1) {
            Token open;
            open.name = InsName.OpenParen;
            open.speech = SpeechPart.Syntax;
            balance++;
            openMatch++;
        }
    }
    Token[] head;
    if(openMatch > 0) {
        head = new Token[openMatch];
        foreach(ref tok; head) {
            tok.name = InsName.OpenParen;
            tok.speech = SpeechPart.Syntax;
        }
    }
    Token[] tail;
    if(balance > 0) {
        tail = new Token[balance];
        foreach(ref tok; tail) {
            tok.name = InsName.CloseParen;
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
        bool previousWasNilad = false;
        
        void flushOpStack() {
            while(opStack.length && opStack[$-1].name != InsName.OpenParen) {
                stack ~= opStack.back;
                opStack.popBack;
            }
        }
        
        foreach(i, token; code.tokenize.autoCompleteParentheses) {
            bool thisIsNilad = false;
            Debugger.print("Token[", i , "]: ", token);
            Debugger.print("Paren stack: ", parenStackArity);
            Debugger.print("opStack:     ", opStack);
            Debugger.print();
            
            final switch(token.speech) {
                case SpeechPart.Verb:
                    // flush opStack if at barrier
                    if(previous == SpeechPart.Verb || previous == SpeechPart.Adjective) {
                        flushOpStack();
                    }
                    thisIsNilad = token.isNilad;
                    stack ~= token;
                    parenStackArity[$-1]++;
                    break;
                case SpeechPart.Adjective:
                    flushOpStack();
                    if(token.name == InsName.Filter && previousWasNilad) {
                        // the next verb is a FAKE verb, and should not affect
                        // the count of actual verbs
                        parenStackArity[$-1]--;
                    }
                    stack ~= token;
                    break;
                case SpeechPart.Conjunction:
                    // this is where precedence handling would go
                    flushOpStack();
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
                        case InsName.OpenParen:
                            // flush if at barrier
                            if(previous == SpeechPart.Verb) {
                                flushOpStack();
                            }
                            opStack ~= token;
                            parenStackArity ~= 0;
                            break;
                            
                        case InsName.CloseParen:
                            // TODO: exploit behavior?
                            assert(parenStackArity.length, "Close parenthesis without open parenthesis");
                            uint count = parenStackArity.back;
                            parenStackArity.popBack;
                            flushOpStack();
                            opStack.popBack; // pop `(`
                            stack ~= Token(
                                SpeechPart.Syntax,
                                InsName.CloseParen,
                                BigInt(count)
                            );
                            parenStackArity[$-1]++;
                            break;
                            
                        case InsName.Break:
                            stack ~= token;
                            break;
                        
                        default:
                            //TODO: error
                            assert(false, "Received invalid Syntax part");
                    }
                    break;
            }
            
            previous = token.speech;
            previousWasNilad = thisIsNilad;
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
                if(g.niladic && f.markedArity == 2 || f.niladic && g.markedArity == 2) {
                    Debugger.print("Atop redirected to Bind");
                    verbs[$-1] = bind(f, g);
                }
                else {
                    verbs[$-1] = compose(f, g);
                }
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
                    if(token.name == InsName.Integer) {
                        addNilad(token.big);
                        nextState = NiladParseState.LastWasNilad;
                    }
                    else if(token.name == InsName.String) {
                        addNilad(token.str);
                        nextState = NiladParseState.LastWasNilad;
                    }
                    else if(token.name == InsName.Real) {
                        addNilad(token.dec);
                        nextState = NiladParseState.LastWasNilad;
                    }
                    else {
                        finishListBuild;
                        verbs ~= getVerb(token.name);
                    }
                    break;
                    
                case SpeechPart.Adjective:
                    if(state == NiladParseState.LastWasNilad && token.name == InsName.Filter) {
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
                    verbs.popBackN(valence);
                    // we cannot replace the back of the array,
                    // since this would replace the front of args,
                    // causing circular referencing
                    verbs ~= mc.transform(args);
                    break;
                    
                case SpeechPart.Syntax:
                    // writeln("Unhandled: ", token);
                    assert(token.name == InsName.CloseParen);
                    // TODO: handle more syntax?
                    auto amount = to!int(token.big);
                    finishListBuild;
                    writeln("amount: ", amount);
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
            if(chain.length == 0) continue;
            Debugger.print("CHAIN:");
            Debugger.print("   ",chain);
            Verb chainVerb = condenseTokenChain(chain);
            chains ~= chainVerb;
        }
        // TODO: empty program
        return chains[0];
    }
    
    static Atom evaluate(string str, Atom[] args = []) {
        // TODO: add another debugging level for interior evaluate
        Debugger.silence();
        auto temp = new Interpreter(str);
        temp.shunt;
        auto value = temp.condense()(args);
        Debugger.unsilence();
        return value;
    }
}
