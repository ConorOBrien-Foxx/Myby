module myby.condense;

import std.bigint;
import std.conv : to;
import std.range : back, popBack, popBackN;

import myby.debugger;
import myby.instructions;
import myby.literate : NiladParseState;
import myby.speech;
import myby.token;

struct CondenserState {
    Atom[] listBuild;
    NiladParseState parseState = NiladParseState.None;
    NiladParseState nextParseState;
    void finishListBuild(ref Verb[] verbs) {
        if(listBuild.length == 0) return;
        
        Debugger.print("Pushing list build: ", listBuild);
        verbs ~= Verb.nilad(Atom(listBuild));
        listBuild = [];
    }
    
    void addNilad(T)(ref Verb[] verbs, T n) {
        Debugger.print("Adding nilad to verb chain");
        auto v = Verb.nilad(n);
        verbs ~= v;
    }
}

struct Condenser {
    Verb[] chains;
    Verb[] verbs;
    uint index;
    uint[BigInt] chainAliases;
    CondenserState state;
    
    void condense(Token[] chain) {
        if(chain.length == 0) return;
        Debugger.print("CHAIN:");
        Debugger.print("   ",chain);
        Verb chainVerb = condenseTokenChain(chain);
        chains ~= chainVerb.dup;
    }
    
    void assignLinkInfo() {
        foreach(i, ref chain; chains) {
            Debugger.print("=== ", i, " ===");
            auto info = ChainInfo(i, chains);
            chain.setChains(info);
        }
    }
    
    Atom handleVerb(Token token, bool mustBeNilad = false) {
        assert(!mustBeNilad || token.isNilad, "Expected a nilad when forced");
        
        import std.algorithm.iteration : map;
        import std.array : array;
        
        if(token.isNilad) {
            state.nextParseState = NiladParseState.LastWasNilad;
            Atom result;
            switch(token.name) {
                // TODO: instruction name to atom function instead of
                // this wacky recursive function
                case InsName.Integer:
                    result = token.big;
                    break;
                
                case InsName.String:
                    result = token.str;
                    break;
                
                case InsName.Real:
                    result = token.dec;
                    break;
                
                case InsName.ListLiteral:
                    result = token.arr.map!(a => handleVerb(a, true)).array;
                    break;
                
                default:
                    assert(0, "Unhandled nilad " ~ to!string(token.name));
            }
            if(mustBeNilad) {
                return result;
            }
            else {
                state.addNilad(verbs, result);
            }
        }
        else {
            state.finishListBuild(verbs);
            if(token.name == InsName.DefinedAlias) {
                Debugger.print("Aliases: ", chainAliases);
                auto aliasIndex = chainAliases[token.big];
                // TODO: command line flag for debugging aliases
                verbs ~= new Verb("Alias#" ~ token.big.to!string)
                    .setMonad((Verb v, a) {
                        return v.info.chains[aliasIndex](a);
                    })
                    .setDyad((Verb v, a, b) {
                        return v.info.chains[aliasIndex](a, b);
                    })
                    // TODO: ephemeral children for display purposes (╴╴a)
                    // .setChildren([ v??? ], true)
                    // TODO: copy marked arity
                    .setMarkedArity(1);
            }
            else {
                verbs ~= getVerb(token.name);
            }
        }
        return Nil.nilAtom;
    }
    
    void handleAdjective(Token token) {
        // TODO: using filter as a separator is fundamentally flawed
        // e.g.: =&2\ 0&;
        if(state.parseState == NiladParseState.LastWasNilad && token.name == InsName.Filter) {
            Debugger.print("Nilad separator!");
            if(state.listBuild.length == 0) {
                Debugger.print("Initializing with top (niladic) verb");
                state.addNilad(verbs, verbs[$-1]());
                verbs.popBack;
            }
            state.nextParseState = NiladParseState.LastWasNiladSeparator;
        }
        else {
            assert(verbs.length >= 1, "Expected a verb for adjective "
                ~ to!string(token.name));
            Adjective adj = getAdjective(token.name);
            state.finishListBuild(verbs);
            Verb u = verbs[$-1];
            verbs.popBack;
            verbs ~= adj.transform(u);
        }
    }
    
    void handleConjunction(Token token) {
        assert(verbs.length >= 2, "Expected two verbs for conjunction "
            ~ to!string(token.name));
        Conjunction con = getConjunction(token.name);
        state.finishListBuild(verbs);
        Verb f = verbs[$-2];
        Verb g = verbs[$-1];
        verbs.popBackN(2);
        verbs ~= con.transform(f, g);
    }
    
    void handleMultiConjunction(Token token) {
        MultiConjunction mc = getMultiConjunction(token.name);
        state.finishListBuild(verbs);
        Verb[] args;
        uint valence = to!uint(token.big);
        assert(valence, "Expected non-zero final valence for MultiConjunction");
        /*
        if(mc.valence == 0) {
            valence = verbs.length;
        }
        else {
            valence = mc.valence;
        }
        */
        assert(verbs.length >= valence,
            "Expected " ~ to!string(valence) ~ " verbs for multi-conjunction "
            ~ to!string(token.name));
        
        args = verbs[$-valence..$];
        verbs.popBackN(valence);
        // we cannot replace the back of the array,
        // since this would replace the front of args,
        // causing circular referencing
        verbs ~= mc.transform(args);
    }
    
    void handleSyntax(Token token) {
        switch(token.name) {
            case InsName.CloseParen:
                auto amount = to!int(token.big);
                state.finishListBuild(verbs);
                auto last = verbs[$-amount..$];
                verbs.popBackN(amount);
                condenseVerbChain(last);
                verbs ~= last[$-1];
                break;
            
            // TODO: allow aliases to be defined in the middle of the sentence
            case InsName.InitialAlias:
                chainAliases[token.big] = index;
                break;
            
            default:
                assert(0, "Unexpected syntax part: " ~ to!string(token.name));
        }
    }

    Verb condenseTokenChain(T)(T chain) {
        // first, produce a list of verbs
        index = chains.length;
        verbs = [];
        state = CondenserState();
        foreach(token; chain) {
            state.nextParseState = NiladParseState.None;
            Debugger.print("==== step ====");
            Debugger.print("state: ", state);
            Debugger.print("token: ", token);
            final switch(token.speech) {
                case SpeechPart.Verb:
                    handleVerb(token);
                    break;
                    
                case SpeechPart.Adjective:
                    handleAdjective(token);
                    break;
                
                case SpeechPart.Conjunction:
                    handleConjunction(token);
                    break;
                
                case SpeechPart.MultiConjunction:
                    handleMultiConjunction(token);
                    break;
                    
                case SpeechPart.Syntax:
                    handleSyntax(token);
                    break;
            }
            state.parseState = state.nextParseState;
            Debugger.print("Verbs: ", verbs);
            Debugger.print("");
        }
        Debugger.print("Final condensation:");
        state.finishListBuild(verbs);
        // second, condense the train down to a single verb
        Debugger.print("Resulting verbs: ", verbs);
        condenseVerbChain(verbs);
        return verbs[0];
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
                verbs.popBackN(3);
                verbs ~= Verb.fork(f, g, h);
            }
            else if(verbs.length == 2) {
                Debugger.print("Atop");
                // remove the two train, an atop
                Verb f, g;
                f = verbs[$-2];
                g = verbs[$-1];
                verbs.popBackN(2);
                if(g.niladic && f.markedArity == 2 || f.niladic && g.markedArity == 2) {
                    Debugger.print("Atop redirected to Bind");
                    verbs ~= bind(f, g);
                }
                else {
                    verbs ~= compose(f, g);
                }
            }
            else {
                assert(0, "Invalid verb condense count: " ~ verbs.length.to!string);
            }
        }
    }
}