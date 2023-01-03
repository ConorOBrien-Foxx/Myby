module myby.adjectives;

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

Adjective getAdjective(InsName name) {
    static Adjective[InsName] adjectives;
    
    if(!adjectives) {
        import std.algorithm.iteration : reduce;
        // Filter/Fold
        adjectives[InsName.Filter] = new Adjective(
            (Verb v) {
                // filter 
                if(v.markedArity == 1) {
                    return filterFor(v);
                }
                // fold
                else {
                    return foldFor(v);
                }
            },
        );
        
        // Map
        adjectives[InsName.Map] = new Adjective(
            (Verb v) => new Verb("\"")
                // map
                .setMonad((Verb v, a) => a.match!(
                    (Atom[] arr) => Atom(mapVerb(v, arr)),
                    (string str) => Atom(mapVerb(v, str.atomChars).joinToString),
                    _ => Nil.nilAtom,
                ))
                // zip
                .setDyad((Verb v, a, b) => match!(
                    (Atom[] a, Atom[] b) => Atom(zip(a, b).map!(t => v(t[0], t[1])).array),
                    (string a, string b) => Atom(
                        zip(a, b).map!(t => v(t[0].to!string, t[1].to!string)).joinToString
                    ),
                    (Atom[] a, _) => Atom(a.map!(t => v(t, b)).array),
                    // (string a, b) => Atom(a.map!(t => v(t.to!string, Atom(b))).joinToString),
                    (_, Atom[] b) => Atom(b.map!(t => v(a, t)).array),
                    // (a, string b) => Atom(b.map!(t => v(Atom(a), t.to!string)).joinToString),
                    (_1, _2) => Nil.nilAtom,
                )(a, b))
                .setInverseMutual(new Verb("\"!.")
                    .setMonadSelf((Verb v, a) {
                        Debugger.print("v: ", v);
                        // Debugger.print("children: ", v.children);
                        // Debugger.print("inverse: ", v.f.invert());
                        Debugger.print("v's inverse: ", v.inverse);
                        Debugger.print("v's monad: ", v.inverse.monad);
                        return v.inverse.monad.match!(
                        t => t(v.f.invert(), a),
                        _ => assert(0, "Improperly initialized `\"` Verb")
                    );})
                    .setDyad((_1, _2) => Nil.nilAtom)
                    .setMarkedArity(1)
                    .setChildren([v])
                )
                .setMarkedArity(v.markedArity)
                .setChildren([v])
        );
        
        adjectives[InsName.LeftMap] = new Adjective(
            (Verb v) => new Verb("\":")
                // map
                .setMonad((Verb v, a) => a.match!(
                    (Atom[] arr) => Atom(mapVerb(v, arr)),
                    (string str) => Atom(mapVerb(v, str.atomChars).joinToString),
                    _ => Nil.nilAtom,
                ))
                // zip
                .setDyad((Verb v, a, b) => match!(
                    (Atom[] a, _) => Atom(a.map!(t => v(t, b)).array),
                    (_, Atom[] b) => Atom(b.map!(t => v(a, t)).array),
                    (_1, _2) => Nil.nilAtom,
                )(a, b))
                // TODO: inverse
                .setMarkedArity(v.markedArity)
                .setChildren([v])
        );
        
        // ArityForce
        adjectives[InsName.ArityForce] = new Adjective(
            // TODO: copy better, e.g. inverse
            (Verb v) => new Verb("`:")
                .setMonad((Verb v, a) => v(a))
                .setDyad((Verb v, a, b) => v(a, b))
                .setMarkedArity(v.markedArity == 2 ? 1 : 2)
                .setInverse(Verb.unimplemented)
                .setChildren([v])
        );
        
        // OnLeft
        adjectives[InsName.OnLeft] = new Adjective(
            (Verb v) => new Verb("[.")
                .setMonad((Verb v, a) => v(a))
                .setDyad((Verb v, a, b) => v(a))
                .setMarkedArity(2)
                .setChildren([v])
        );
        
        // OnRight
        adjectives[InsName.OnRight] = new Adjective(
            (Verb v) => new Verb("].")
                .setMonad((Verb v, a) => v(a))
                .setDyad((Verb v, a, b) => v(b))
                .setMarkedArity(2)
                .setChildren([v])
        );
        
        // OnPrefixes
        adjectives[InsName.OnPrefixes] = new Adjective(
            (Verb v) => new Verb("\\.")
                .setMonad((Verb v, a) => a.match!(
                    a => Atom(
                        iota(a.length)
                            .map!(i => a[0..i + 1])
                            .map!Atom
                            .map!v
                            .array
                    ),
                    _ => Nil.nilAtom,
                ))
                .setDyad((Verb v, a, b) => match!(
                    // slices
                    (BigInt a, Atom[] arr) => Atom(slicesOf(v, a, arr)),
                    (BigInt a, string s) => Atom(
                        slicesOf(v, a, s.atomChars)
                            .map!(slice => slice.match!(
                                a => a.joinToString,
                                x => to!string(x),
                            ))
                            .map!Atom
                            .array
                        ),
                    (_1, _2) => Nil.nilAtom,
                )(a, b))
                .setMarkedArity(1)
                .setChildren([v])
        );
        
        // OnSuffixes
        adjectives[InsName.OnSuffixes] = new Adjective(
            (Verb v) => new Verb("\\:")
                .setMonad((Verb v, a) => a.match!(
                    (Atom[] a) => Atom(
                        iota(a.length)
                            .map!(i => a[i..$])
                            .map!Atom
                            .map!v
                            .array
                        ),
                    _ => Nil.nilAtom,
                ))
                .setDyad((Verb v, a, b) => Nil.nilAtom)
                .setMarkedArity(1)
                .setChildren([v])
        );
        
        // Reflex
        adjectives[InsName.Reflex] = new Adjective(
            (Verb v) => new Verb("~")
                .setMonad((Verb v, a) => v(a, a))
                .setDyad((Verb v, x, y) => v(y, x))
                .setMarkedArity(2)
                .setChildren([v])
        );
        
        adjectives[InsName.Invariant] = new Adjective(
            (Verb v) => new Verb("I")
                .setMonad((Verb v, a) => Atom(v(a) == a))
                .setDyad((Verb v, a, b) => Nil.nilAtom)
                .setMarkedArity(1)
                .setChildren([v])
        );
        
        adjectives[InsName.Variant] = new Adjective(
            (Verb v) => new Verb("I.")
                .setMonad((Verb v, a) => Atom(v(a) != a))
                .setDyad((Verb v, a, b) => Nil.nilAtom)
                .setMarkedArity(1)
                .setChildren([v])
        );
        
        adjectives[InsName.Generate] = new Adjective(
            (Verb v) => new Verb("G")
                .setMonad((Verb v, a) => a.match!(
                    // Sort By
                    (Atom[] a) {
                        import std.algorithm.mutation : SwapStrategy;
                        Atom[] d = a.dup;
                        if(v.markedArity == 2) {
                            d.sort!((a, b) => v(a, b).truthiness, SwapStrategy.stable);
                        }
                        else {
                            // TODO: more efficient sort by algorithm
                            d.sort!((a, b) => v(a) < v(b), SwapStrategy.stable);
                        }
                        return Atom(d);
                    },
                    // Generate
                    _ => generate(v, a)
                ))
                .setDyad((Verb v, a, n) => generate(v, a, n))
                .setMarkedArity(1)
                .setChildren([v])
        );
        
        // Inverse
        adjectives[InsName.Inverse] = new Adjective(
            (Verb v) => v.invert()
        );
        
        // Benil
        adjectives[InsName.Benil] = new Adjective(
            (Verb v) => new Verb("benil")
                .setMonad((Verb v, a) {
                    if(a.isNil) {
                        return v(a);
                    }
                    else {
                        return a;
                    }
                })
                .setDyad((Verb v, _1, _2) => Nil.nilAtom)
                .setMarkedArity(1)
                .setChildren([v])
        );
        
        // Memoize
        adjectives[InsName.Memoize] = new Adjective(
            (Verb v) {
                import myby.memo;
                // TODO: customize for size
                FixedMemo!(Atom[Atom], 600) unaryMemo;
                return new Verb("M.")
                    .setMonad((Verb v, a) {
                        auto mem = a in unaryMemo;
                        if(mem !is null) {
                            return *mem;
                        }
                        else {
                            return unaryMemo[a] = v(a);
                        }
                    })
                    .setDyad((Verb v, _1, _2) => Nil.nilAtom)
                    .setMarkedArity(1)
                    .setChildren([v]);
            }
        );
        
        adjectives[InsName.Time] = new Adjective(
            (Verb v) {
                import std.datetime.stopwatch : AutoStart, StopWatch;
                return new Verb("T.")
                    .setMonad((Verb v, a) {
                        auto sw = StopWatch(AutoStart.yes);
                        Atom res = v(a);
                        sw.stop();
                        auto dur = sw.peek();
                        return Atom([ Atom(dur), res ]);
                    })
                    .setDyad((Verb v, a, b) {
                        auto sw = StopWatch(AutoStart.yes);
                        Atom res = v(a, b);
                        sw.stop();
                        auto dur = sw.peek();
                        return Atom([ Atom(dur), res ]);
                    })
                    .setMarkedArity(v.markedArity)
                    .setChildren([v]);
            }
        );
        
        // Vectorize
        adjectives[InsName.Vectorize] = new Adjective(
            (Verb v) => new Verb("V")
                .setMonad((Verb v, a) => vectorAt(v, a))
                .setDyad((Verb v, a, b) => vectorAt(v, a, b))
                .setInverseMutual(new Verb("V!.")
                    .setMonadSelf((Verb v, a) => v.inverse.monad.match!(
                        t => t(v.f.invert(), a),
                        _ => assert(0, "Improperly initialized `V` Verb")
                    ))
                    .setDyad((_1, _2) => Nil.nilAtom)
                    .setMarkedArity(1)
                    .setChildren([v])
                )
                .setMarkedArity(v.markedArity)
                .setChildren([v])
        );
        
        // NthChain
        adjectives[InsName.NthChain] = new Adjective(
            (Verb v) => new Verb("$N")
                .setMonad((Verb v, a) {
                    auto info = v.info;
                    auto chainNumberBig = v(a).as!BigInt;
                    uint index = moldIndex(chainNumberBig, v.info.chains.length);
                    Verb res = v.info.chains[index];
                    return res(a);
                })
                .setDyad((_1, _2) => Nil.nilAtom)
                .setChildren([v])
                //TODO: adopt marked arity
                .setMarkedArity(1)
        );
        
        // Diagonal
        adjectives[InsName.Diagonal] = new Adjective(
            (Verb v) => new Verb("/:")
                .setMonad((Verb v, a) => a.match!(
                    (Atom[] a) {
                        Atom[][] mat = matrixFor(a);
                        /*
                          1   2   3   4        \ 1\ 2\3\4
                          5   6   7   8   => \ 5\ 6\ 7\8\
                          9  10  11  12      9\10\11\12\
                          [[4], [3, 8], [2, 7, 12], [1, 6, 11], [5, 10], [9]]
                        */

                        uint upper = mat.length + mat[0].length - 1;
                        Atom[] result;
                        // int for signed arithmetic below
                        int width = mat[0].length;
                        for(int o = 0; o < upper; o++) {
                            Atom[] oblique;
                            int j = max(0, width - 1 - o);
                            int i = max(0, o - width + 1);
                            while(j < width && i < mat.length) {
                                oblique ~= mat[i][j];
                                i++;
                                j++;
                            }
                            result ~= v(Atom(oblique));
                        }
                        if(!result.length) {
                            result ~= Atom(cast(Atom[])[]);
                        }
                        return Atom(result);
                    },
                    (string s) => assert(0, "TODO: Diagonal lines of string"),
                    _ => Nil.nilAtom,
                ))
                .setDyad((_1, _2) => Nil.nilAtom)
                .setInverse(new Verb("/:!.")
                    .setMonad((Verb v, a) => a.match!(
                        (Atom[] arr) {
                            auto vInv = v.invert();
                            Atom[][] mat;
                            auto widthArr = arr.map!(a => a.match!(
                                a => a.length,
                                _ => 0,
                            ));
                            int width = zip(widthArr.dropBackOne(), widthArr.dropOne())
                                .countUntil!"a[0] > a[1]";
                            if(width < 0) {
                                width = 1;
                            }
                            else {
                                width++;
                            }
                            foreach(d, diagonal; arr) {
                                int j = max(0, width - 1 - cast(int)d);
                                int i = max(0, cast(int)d - width + 1);
                                vInv(diagonal).match!(
                                    (Atom[] diagonal) {
                                        foreach(k, cell; diagonal) {
                                            setFill(mat, i + k);
                                            setFill(mat[i + k], j + k);
                                            mat[i + k][j + k] = cell;
                                        }
                                    },
                                    _ => assert(0, "Cannot reconstruct matrix with non-array elements"),
                                );
                            }
                            if(!mat.length) {
                                mat ~= [[]];
                            }
                            return Atom(mat.map!Atom.array);
                        },
                        (string s) => assert(0, "TODO: Un-Diagonal liens of string"),
                        _ => Nil.nilAtom,
                    ))
                    .setDyad((_1, _2) => Nil.nilAtom)
                    .setChildren([v])
                    .setMarkedArity(1)
                )
                .setChildren([v])
                .setMarkedArity(1)
        );
        
        // Oblique
        adjectives[InsName.Oblique] = new Adjective(
            (Verb v) => new Verb("/.")
                .setMonad((Verb v, a) => a.match!(
                    (Atom[] a) {
                        Atom[][] mat = matrixFor(a);
                        // TODO: handle ragged arrays better
                        /*
                          1   2   3   4       1/2/3/ 4/ 8/12/
                          5   6   7   8   =>  /5/6/ 7/11/
                          9  10  11  12        /9/10/
                        */
                        uint upper = mat.length + mat[0].length - 1;
                        Atom[] result;
                        for(uint o = 0; o < upper; o++) {
                            Atom[] oblique;
                            int j = min(o, mat[0].length - 1);
                            int i = max(0, o - j);
                            while(i < mat.length && j >= 0) {
                                oblique ~= mat[i][j];
                                i++;
                                j--;
                            }
                            result ~= v(Atom(oblique));
                        }
                        if(!result.length) {
                            result ~= Atom(cast(Atom[])[]);
                        }
                        return Atom(result);
                    },
                    (string s) => assert(0, "TODO: Oblique lines of string"),
                    _ => Nil.nilAtom,
                ))
                .setDyad((_1, _2) => Nil.nilAtom)
                .setInverse(new Verb("/.!.")
                    .setMonad((Verb v, a) => a.match!(
                        (Atom[] arr) {
                            auto vInv = v.invert();
                            Atom[][] mat;
                            auto widthArr = arr.map!(a => a.match!(
                                a => a.length,
                                _ => 0,
                            ));
                            auto width = zip(widthArr.dropBackOne(), widthArr.dropOne())
                                .countUntil!"a[0] > a[1]"
                                + 1;
                            foreach(d, oblique; arr) {
                                int j = min(d, width - 1);
                                int i = max(d - j, 0);
                                vInv(oblique).match!(
                                    (Atom[] oblique) {
                                        foreach(k, cell; oblique) {
                                            setFill(mat, i + k);
                                            setFill(mat[i + k], j - k);
                                            mat[i + k][j - k] = cell;
                                        }
                                    },
                                    _ => assert(0, "Cannot reconstruct matrix with non-array elements"),
                                );
                            }
                            if(!mat.length) {
                                mat ~= [[]];
                            }
                            return Atom(mat.map!Atom.array);
                        },
                        (string s) => assert(0, "TODO: Un-Oblique lines of string"),
                        _ => Nil.nilAtom,
                    ))
                    .setDyad((_1, _2) => Nil.nilAtom)
                    .setChildren([v])
                    .setMarkedArity(1)
                )
                .setChildren([v])
                .setMarkedArity(1)
        );
        
        // Keep
        adjectives[InsName.Keep] = new Adjective(
            (Verb v) => new Verb("keep")
                .setMonad((Verb v, a) => a.match!(
                    (Atom[] a) =>
                        Atom(a.atomFilter!v.array),
                    _ => Nil.nilAtom,
                ))
                .setDyad((Verb v, a, b) => match!(
                    (Atom[] a, b) =>
                        Atom(a.atomFilter!(t => v(t) == atomFor(b)).array),
                    (a, Atom[] b) =>
                        Atom(b.atomFilter!(t => atomFor(a) == v(t)).array),
                    (_1, _2) => Nil.nilAtom,
                )(a, b))
                .setMarkedArity(2)
                .setChildren([v])
        );
        
        // Loop
        adjectives[InsName.Loop] = new Adjective(
            (Verb v) => new Verb("loop")
                .setMonad((Verb v, a) {
                    while((a = v(a)).truthiness) {
                    }
                    return a;
                })
                .setDyad((_1, _2) => Nil.nilAtom)
                .setMarkedArity(1)
                .setChildren([v])
        );
        
        adjectives[InsName.ChunkBy] = new Adjective(
            (Verb v) => new Verb("C")
                .setMonad((Verb v, a) => chunkVerb(v, a))
                .setDyad((_1, _2) => Nil.nilAtom)
                .setMarkedArity(1)
                .setChildren([v])
        );
        
        // Verb Diagnostic
        adjectives[InsName.VerbDiagnostic] = new Adjective(
            (Verb v) => new Verb("?:")
                .setMonad((Verb v, a) {
                    AVHash data;
                    data[_AtomValue("ma")] = BigInt(v.markedArity);
                    data[_AtomValue("disp")] = v.display;
                    data[_AtomValue("rep")] = v.treeDisplay;
                    data[_AtomValue("inv")] = !!v.inverse;
                    data[_AtomValue("nilad")] = v.niladic;
                    data[_AtomValue("rs")] = v.rangeStart.value;
                    data[_AtomValue("id")] = v.identity.value;
                    return Atom(data);
                })
                // TODO: set dyadic case
                .setDyad((Verb v, x, y) => Nil.nilAtom)
                .setMarkedArity(1)
                .setChildren([v])
        );
    }
    
    Adjective* adjective = name in adjectives;
    assert(adjective, "No such adjective: " ~ to!string(name));
    return *adjective;
}