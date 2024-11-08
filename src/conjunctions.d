module myby.conjunctions;

import core.exception;

import std.algorithm.comparison;
import std.algorithm.iteration;
import std.algorithm.searching;
import std.algorithm.sorting;
import std.bigint;
import std.conv : to;
import std.datetime;
import std.datetime.systime;
import std.random;
import std.range;
import std.sumtype;
import std.typecons;
import std.uni;

import myby.debugger;
import myby.instructions;
import myby.interpreter : Interpreter;
import myby.json;
import myby.manip;
import myby.nibble;
import myby.prime;
import myby.speech;

Conjunction getConjunction(InsName name) {
    static Conjunction[InsName] conjunctions;
    
    if(!conjunctions) {
         conjunctions[InsName.Bond] = new Conjunction(
            (Verb f, Verb g) {
                auto markedArity = 
                    f.niladic || g.niladic
                        ? 1
                        : g.markedArity;
                return new Verb("&")
                    .setMonad((f, g, a) =>
                        f.niladic
                            ? g(f(), a)
                            : g.niladic
                                ? f(a, g())
                                : f(g(a)))
                    // TODO: niladic as per above
                    .setDyad((f, g, a, b) =>
                        f(g(a), g(b)))
                    .setMarkedArity(markedArity)
                    .setInverseMutual(new Verb("!.")
                        // (f&n)!. => f!.&n
                        // (n&g)!. => n&(g!.)
                        .setMonadSelf((Verb v, a) {
                            return v.inverse.monad.match!(
                                t => t(v.f.invert(), v.g.invert(), a),
                                _ => assert(0, "Improperly initialized `&` Verb")
                            );
                        })
                        .setDyad((f, g, _1, _2) => Nil.nilAtom)
                        .setMarkedArity(markedArity)
                        .setChildren([f, g])
                    )
                    .setChildren([f, g]);
            }
        );
        
        conjunctions[InsName.Compose] = new Conjunction(
            (Verb f, Verb g) => Verb.compose(f, g)
        );
        
        conjunctions[InsName.Power] = new Conjunction(
            (Verb f, Verb g) => Verb.power(f, g),
        );
        
        conjunctions[InsName.Under] = new Conjunction(
            (Verb f, Verb g) {
                if(g.underInvertable()) {
                    assert(!g.invertable(), "Verb cannot have both inverse and under inverse, I think?" ~ g.display);
                    return new Verb("&.₂")
                        .setMonad(_ => Nil.nilAtom)
                        .setDyad((f, g, a, b) => g.underInverse(a, b, f(g(a, b))))
                        .setMarkedArity(2)
                        .setChildren([f, g]);
                }
                assert(g.invertable(), "Cannot invert " ~ g.display);
                return new Verb("&.")
                    .setMonad((f, g, a) => g.inverse(f(g(a))))
                    .setDyad((f, g, a, b) => g.inverse(f(g(a), g(b))))
                    .setMarkedArity(1)
                    .setChildren([f, g]);
            }
        );
        
        conjunctions[InsName.ApplyAt] = new Conjunction(
            (Verb src, Verb index) => new Verb("@:")
                // Like APL's @ - https://aplwiki.com/wiki/At
                .setMonad((src, index, a) => a.match!(
                    (Atom[] a) => Atom(applyAt(src, index, a)),
                    (string a) => Atom(applyAt(
                        src,
                        getAdjective(InsName.Map).transform(index),
                        a.atomChars
                    ).joinToString),
                    _ => Nil.nilAtom,
                ))
                // TODO: dyadic case
                .setDyad((src, index, _1, _2) => Nil.nilAtom)
                .setMarkedArity(1)
                .setChildren([src, index])
        );
        
        conjunctions[InsName.Scan] = new Conjunction(
            (Verb f, Verb seedFn) => new Verb("\\..")
                .setMonad((f, seedFn, a) => a.match!(
                    (Atom[] arr) {
                        // TODO: relegate a specific atom for
                        // using f's identity as seed?
                        Atom seed = seedFn(a);
                        return Atom(arr.scanThrough(f, seed));
                    },
                    _ => Nil.nilAtom,
                ))
                .setDyad((f, g, _1, _2) => Nil.nilAtom)
                .setMarkedArity(1)
                .setChildren([f, seedFn])
        );
        
        conjunctions[InsName.While] = new Conjunction(
            (Verb f, Verb g) => new Verb("while")
                .setMonad((exec, cond, a) {
                    while(cond(a).truthiness) {
                        a = exec(a);
                    }
                    return a;
                })
                .setDyad((exec, cond, a, b) {
                    while(cond(a, b).truthiness) {
                        a = exec(a, b);
                    }
                    return a;
                })
                .setMarkedArity(1)
                .setChildren([f, g])
        );
        
        // BLoop
        // aka: do while, but cute sounding
        // bloop!
        conjunctions[InsName.BLoop] = new Conjunction(
            (Verb f, Verb g) => new Verb("bloop")
                .setMonad((Verb v, Verb g, a) {
                    while(g(a = v(a)).truthiness) {
                        
                    }
                    return a;
                })
                .setDyad((_1, _2) => Nil.nilAtom)
                .setMarkedArity(1)
                .setChildren([f, g])
        );
        
        conjunctions[InsName.Gerund] = new Conjunction(
            (Verb f, Verb g) => Verb.gerund(f, g)
        );
        
        conjunctions[InsName.DotProduct] = new Conjunction(
            (Verb f, Verb g) => new Verb(".")
                .setMonad(a => Nil.nilAtom)
                .setDyad((_1, _2) => Nil.nilAtom)
                .setMarkedArity(1)
                .setChildren([f, g])
        );
    }
    
    Conjunction* conjunction = name in conjunctions;
    assert(conjunction, "No such conjunction: " ~ to!string(name));
    return *conjunction;
}
