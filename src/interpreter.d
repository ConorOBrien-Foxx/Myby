module myby.interpreter;

import std.bigint;
import std.conv : to;
import std.range : back, popBack, popBackN;

import myby.condense;
import myby.debugger;
import myby.instructions;
import myby.integer;
import myby.literate : NiladParseState, UseFilterSeparators;
import myby.nibble;
import myby.speech;
import myby.string;
import myby.token;

enum ConjunctionNibbles = [0xA, 0xD];
enum TwoNibbleOverrides = [0xAC, 0xDC, 0xBA, 0xBC, 0xBD];
Token[] tokenize(Nibble[] code) {
    import std.algorithm.searching : canFind;
    Debugger.print("Tokenizing:");
    Debugger.print("    ", code);
    uint i = 0;
    Token[] tokens;
    bool lastWasNilad = false;
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
                // capping because constructs like <:@x create ambiguity
                uint max = 1;
                while(max && i + 1 < code.length && ConjunctionNibbles.canFind(code[i + 1])) {
                    appendNibble;
                    max--;
                }
            }
            Debugger.print("Parsing instruction ", name.toBase16.nibbleFmt);
            auto indexName = name;
            if(indexName / 256 == 0xFE) {
                auto secondHalf = indexName % 256;
                auto hex3 = secondHalf / 16;
                auto hex4 = secondHalf % 16;
                if(0xA <= hex3 && hex3 <= 0xB) {
                    indexName = 0xFEA0;
                }
                token.big = name;
            }
            auto tup = indexName in NameMap;
            assert(tup, "Cannot find instruction corresponding to "
                ~ name.toBase16.nibbleFmt);
            token.name = tup.name;
            token.speech = tup.speech;
            i++;
        }
        
        if(UseFilterSeparators && lastWasNilad && token.name == InsName.Filter) {
            Token* lastToken = &tokens[$ - 1];
            if(lastToken.name != InsName.ListLiteral) {
                Token copy = *lastToken;
                lastToken.arr = [copy];
                lastToken.name = InsName.ListLiteral;
            }
            // we do not push this token, since it is just a literal
        }
        else if(lastWasNilad && token.isNilad) {
            tokens[$ - 1].arr ~= token;
        }
        else {
            lastWasNilad = token.isNilad;
            tokens ~= token;
        }
    }
    // list condensation step
    // Debugger.print(tokens);
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

class Interpreter {
    Nibble[] code;
    Token[] stack;
    this(Nibble[] c) {
        code = c;
    }
    this(T)(T str) {
        import myby.literate : parseLiterate;
        this(str.parseLiterate);
    }
    
    void shunt() {
        Token[] opStack;
        uint[] parenStackArity = [0];
        SpeechPart previousSpeech = SpeechPart.Syntax;
        InsName previousName = InsName.None;
        bool previousWasNilad = false;
        
        void flushOpStack() {
            while(opStack.length && opStack[$-1].name != InsName.OpenParen) {
                stack ~= opStack.back;
                opStack.popBack;
            }
        }
        
        bool[BigInt] seenAliases;
        
        foreach(i, token; code.tokenize.autoCompleteParentheses) {
            bool thisIsNilad = false;
            Debugger.print("Token[", i , "]: ", token);
            Debugger.print("Before:");
            Debugger.print("  Paren stack: ", parenStackArity);
            Debugger.print("  opStack:     ", opStack);
            
            // handle case of first alias defining
            if(token.name == InsName.DefinedAlias && token.big !in seenAliases) {
                token.name = InsName.InitialAlias;
                token.speech = SpeechPart.Syntax;
                seenAliases[token.big] = true;
            }
            
            /*
            |=Barriers. V=Verb, A=Adjective, C=Conjunction.
                )|(
                V|(
                A|(
                )|V
                V|V
                A|V
            */
            // flush opStack if at barrier
            // TODO: maybe there's a more sane to write the below line
            if(token.speech == SpeechPart.Verb || token.name == InsName.OpenParen) {
                if(previousSpeech == SpeechPart.Verb || previousSpeech == SpeechPart.Adjective || previousName == InsName.CloseParen) {
                    flushOpStack();
                }
            }
            
            final switch(token.speech) {
                case SpeechPart.Verb:
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
                    uint valence = getMultiConjunction(token.name).valence;
                    if(valence == 0) {
                        // reduces all items in context to a single verb
                        token.big = parenStackArity[$-1];
                        parenStackArity[$-1] = 1;
                    }
                    else {
                        token.big = valence;
                        parenStackArity[$-1] -= valence - 1;
                    }
                    stack ~= token;
                    break;
                case SpeechPart.Syntax:
                    switch(token.name) {
                        case InsName.OpenParen:
                            // flush if at barrier
                            if(previousSpeech == SpeechPart.Verb) {
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
                            flushOpStack();
                            parenStackArity = [0];
                            stack ~= token;
                            break;
                        
                        case InsName.InitialAlias:
                            stack ~= token;
                            break;
                        
                        default:
                            //TODO: error
                            assert(false, "Received invalid Syntax part");
                    }
                    break;
            }
            
            previousSpeech = token.speech;
            previousName = token.name;
            previousWasNilad = thisIsNilad;
            
            Debugger.print("After:");
            Debugger.print("  Paren stack: ", parenStackArity);
            Debugger.print("  opStack:     ", opStack);
            Debugger.print("");
        }
        
        flushOpStack();
        
        // writeln("Shunted : ", stack);
    }
    
    Verb[] condense() {
        import std.range : split;
        import std.algorithm.iteration : each;
        
        Debugger.print("Initial stack:");
        Debugger.print(stack);
        Condenser c;
        stack
            .split(Token.Break)
            .each!(chain => c.condense(chain));
        
        c.assignLinkInfo();
        
        return c.chains;
    }
    
    static Atom evaluate(string str, Atom[] args = []) {
        // TODO: add another debugging level for interior evaluate
        Debugger.silence();
        auto temp = new Interpreter(str);
        temp.shunt;
        auto value = temp.condense()[0](args);
        Debugger.unsilence();
        return value;
    }
}
