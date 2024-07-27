module myby.verbs;

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

Verb getVerb(InsName name) {
    if(!verbs) {
        // TODO: this looks awful. clean it.
        // maybe: setMonad, setDyad?
        
        // Addition
        verbs[InsName.Add] = new Verb("+")
            // Absolute value/Length
            .setMonad((Atom a) => a.match!(
                b => atomFor(b < 0 ? -b : b),
                b => atomFor(b.isNegative ? -b : b),
                s => Atom(BigInt(s.length)),
                _ => Nil.nilAtom,
            ))
            // Addition
            .setDyad((Atom a, Atom b) => a + b)
            .setInverse(new Verb("+!.")
                .setMonad(b => Nil.nilAtom)
                .setDyad((a, b) => a - b)
                .setMarkedArity(2) // TODO: check if this is a bad idea
            )
            .setIdentity(a => a.match!(
                (Atom[] _) => Atom(cast(Atom[]) []),
                (string _) => Atom(""),
                _ => Atom(BigInt(0))
            ))
            .setMarkedArity(2);
        
        verbs[InsName.Subtract] = new Verb("-")
            .setMonad((Atom a) => a.match!(
                // Negate
                (BigInt n) => Atom(-n),
                (bool b) => Atom(!b),
                (real n) => Atom(-n),
                // Reverse
                (Atom[] a) => Atom(a.retro.array),
                // Reverse
                (string a) => Atom(a.retro.to!string),
                // Negate
                _ => Nil.nilAtom,
            ))
            // Subtraction
            .setDyad((Atom a, Atom b) => a - b)
            .setInverseMutual(new Verb("-!.")
                // Self Inverse
                .setMonad((Verb v, a) => v.inverse(a))
                .setDyad((a, b) => a + b)
                .setMarkedArity(1)
            )
            .setIdentity(Atom(BigInt(0)))
            .setMarkedArity(2);
        
        import std.uni : isUpper, isLower;
        verbs[InsName.Multiply] = new Verb("*")
            .setMonad((Atom a) => a.match!(
                // Flatten
                (Atom[] a) => Atom(flatten(a)),
                // Sign
                (BigInt b) => Atom(BigInt(b < 0 ? -1 : b == 0 ? 0 : 1)),
                // Cases of
                (string s) => Atom(s
                    .map!(chr => chr.isUpper ? 1 : chr.isLower ? -1 : 0)
                    .map!BigInt
                    .map!Atom
                    .array
                ),
                _ => Nil.nilAtom,
            ))
            .setDyad((Atom a, Atom b) => a * b)
            .setMarkedArity(2)
            .setInverse(new Verb("*!.")
                .setMonad(a => Nil.nilAtom)
                .setDyad((a, b) => a / b)
                .setMarkedArity(2)
            )
            .setIdentity(Atom(BigInt(1)))
            .setRangeStart(BigInt(1));
        
        verbs[InsName.Divide] = new Verb("/")
            .setMonad((Atom a) => a.match!(
                // Characters
                (string a) => Atom(a.atomChars),
                // Unique
                (Atom[] a) => Atom(a.nub.array),
                // Reciprocal
                n => Atom(1 / cast(real)n),
                _ => Nil.nilAtom,
            ))
            .setDyad((Atom a, Atom b) => a / b)
            .setMarkedArity(2)
            .setInverse(new Verb("/!.")
                .setMonad(a => a.match!(
                    // Un-Characters (join)
                    (Atom[] a) => Atom(a.joinToString),
                    // Reciprocal (self inverse)
                    n => Atom(1 / cast(real)n),
                    _ => Nil.nilAtom,
                ))
                .setDyad((a, b) => a * b)
                .setMarkedArity(1)
            )
            .setIdentity(Atom(BigInt(1)))
            .setRangeStart(BigInt(1));
        
        verbs[InsName.Exponentiate] = new Verb("^")
            .setMonad((Atom a) => a.match!(
                // Duration to Real
                (Duration _) => Atom(a.as!real),
                // OneRange
                (a) =>
                    verbs[InsName.Range](cast(typeof(a)) 1, a),
                // Transpose
                (Atom[] a) => Atom(matrixFor(a).transposed.map!array.map!Atom.array),
                // Uppercase
                (string s) => Atom(s.map!toUpper.joinToString),
                _ => Nil.nilAtom,
            ))
            // Exponentiation
            .setDyad((Atom a, Atom b) => a ^^ b)
            .setIdentity(Atom(BigInt(1)))
            .setRangeStart(BigInt(2))
            // TODO: inverse (real to duration; last of onerange; lowercase?)
            .setMarkedArity(2);
        
        verbs[InsName.Modulus] = new Verb("%")
            .setMonad((Atom a) => a.match!(
                // Sort
                (Atom[] a) => Atom(a.dup.sort.array),
                // Ord
                (string s) => Atom(BigInt(cast(long) s[0])),
                // Chr
                (BigInt b) => Atom(a.as!dchar.to!string),
                (real r) => Atom(a.as!dchar.to!string),
                _ => Nil.nilAtom,
            ))
            .setDyad((Atom a, Atom b) => a % b)
            .setInverseMutual(new Verb("!.")
                .setMonadSelf((Verb v, a) => v.inverse(a))
                .setDyad((_1, _2) => Nil.nilAtom)
                .setMarkedArity(1)
            )
            .setMarkedArity(2);
        
        // Identity/Reshape
        verbs[InsName.Identity] = new Verb("#")
            .setMonad(_ => _)
            .setDyad((a, b) => match!(
                (Atom[] a, b) => Atom(reshape(a, b)),
                (a, Atom[] b) => Atom(reshape(b, a)),
                (string a, b) => Atom(reshape(a.atomChars, b).joinToString),
                (a, string b) => Atom(reshape(b.atomChars, a).joinToString),
                (Atom[] as, Atom[] bs) {
                    Atom[] res;
                    foreach(a, b; as.lockstep(bs)) {
                        res ~= a.repeat(b.as!uint).array;
                    }
                    return Atom(res);
                },
                (string as, Atom[] bs) {
                    string res;
                    foreach(a, b; as.lockstep(bs)) {
                        res ~= a.repeat(b.as!uint).joinToString;
                    }
                    return Atom(res);
                },
                /*
                (Atom[] a, Atom[] b) => Atom(
                    zip(a, b)
                        .filter!(t => t[1].truthiness)
                        .map!(t => t[0])
                        .array
                ),*/
                (a, b) => Atom(reshape([atomFor(b)], a)),
                (_1, _2) => Nil.nilAtom,
            )(a, b))
            .setInverse(new Verb("#!.")
                .setMonad(_ => _)
                .setDyad((a, b) => b)
                .setMarkedArity(1)
            )
            .setMarkedArity(1);
        
        verbs[InsName.Left] = new Verb("[")
            // Grade Up / argsort
            .setMonad(a => a.match!(
                (Atom[] a) => Atom(a.gradeUp.map!BigInt.map!Atom.array),
                (string a) => Atom(a.atomChars.gradeUp.map!BigInt.map!Atom.array),
                // wrap non-list
                _ => Atom([ a ]),
            ))
            // Left
            .setDyad((a, b) => a)
            .setMarkedArity(2);
        
        verbs[InsName.Right] = new Verb("]")
            // Grade Down
            .setMonad(a => a.match!(
                (Atom[] a) => Atom(a.gradeDown.map!BigInt.map!Atom.array),
                (string a) => Atom(a.atomChars.gradeDown.map!BigInt.map!Atom.array),
                // pair non-list
                _ => Atom([a, a]),
            ))
            // Right
            .setDyad((a, b) => b)
            .setMarkedArity(2);
        
        // Range (indices)
        verbs[InsName.Range] = new Verb("R")
            .setMonad(a => a.match!(
                (n) => Atom(
                    n < 0
                        ? iota(-n).map!(a => Atom(-n - 1 - a)).array
                        : iota(n).map!Atom.array
                ),
                (Atom[] a) => integers(a),
                // Lowercase
                (string s) => Atom(s.map!toLower.joinToString),
                _ => Nil.nilAtom
            ))
            .setDyad((l, r) => match!(
                (a, b) => Atom(iota(a, b + 1).map!Atom.array),
                // one-based index
                (Atom[] _1, _2) => Atom(BigInt(1)) + l ^^ r,
                (string _1, _2) => Atom(BigInt(1)) + l ^^ r,
                (_1, _2) => Nil.nilAtom,
            )(l, r))
            .setMarkedArity(1);
        
        verbs[InsName.Divisors] = new Verb("D")
            // Divisors (including input)
            .setMonad(a => a.match!(
                (BigInt b) => Atom(
                    iota(BigInt(1), b + 1)
                        .filter!(n => b % n == 0)
                        .map!Atom
                        .array
                    ),
                _ => Nil.nilAtom,
            ))
            .setDyad((_1, _2) => Nil.nilAtom)
            .setMarkedArity(1);
            
        verbs[InsName.Pad] = new Verb("P")
            .setMonad(a => a.match!(
                (Atom[] a) {
                    ulong longest = a.map!(e => e.match!(c => c.length, _ => 0u)).maxElement;
                    return Atom(a.map!(
                        row => verbs[InsName.Pad](row, longest)
                    ).array);
                },
                _ => Nil.nilAtom,
            ))
            .setDyad((a, b) => match!(
                // mold
                (Atom[] to, Atom[] by) => moldToShape(to, Atom(by)),
                // pad left/right by amount 
                (a, Atom[] b) => Atom(padLeftInfer(b, atomFor(a))),
                (Atom[] a, b) => Atom(padRightInfer(a, atomFor(b))),
                (a, string b) => Atom(padLeftInfer(b.atomChars, atomFor(a)).joinToString),
                (string a, b) => Atom(padRightInfer(a.atomChars, atomFor(b)).joinToString),
                (_1, _2) => Nil.nilAtom
            )(a, b));
        
        verbs[InsName.Link] = new Verb(";")
            // Wrap
            .setMonad(a => Atom([a]))
            // Link
            .setDyad((a, b) => a.linkWith(b))
            .setMarkedArity(2);
        
        verbs[InsName.Random] = new Verb("?.")
            .setMonad(a => a.match!(
                // sample
                (Atom[] list) => list.choice(),
                (string s) => Atom(s.atomChars.choice()),
                // uniform random [0,n) - bigints not natively supported here
                (BigInt n) => Atom(uniform(0, n.to!ulong)),
                _ => Nil.nilAtom,
            ))
            .setDyad((_1, _2) => Nil.nilAtom)
            .setMarkedArity(1);
        
        verbs[InsName.FromBase] = new Verb("#.")
            // From binary
            .setMonad(a => fromBase(a, 2))
            // From base
            .setDyad((a, b) => a.match!(
                (BigInt a) => fromBase(b, a),
                // TODO: mixed base
                _ => assert(0, "Invalid base: " ~ a.atomToString),
            ))
            .setInverseMutual(new Verb("#.!.")
                .setMonad(a => verbs[InsName.ToBase](a))
                .setDyad((a, b) => verbs[InsName.ToBase](a, b))
                .setMarkedArity(1)
            )
            .setMarkedArity(1);
        
        verbs[InsName.ToBase] = new Verb("#:")
            // To binary
            .setMonad(a => a.match!(
                (BigInt a) => Atom(a.toBase(2).map!Atom.array),
                (Atom[] a) {
                    Atom[] list = a.map!(n => verbs[InsName.ToBase](n)).array;
                    ulong longest = list.map!(e => e.match!(c => c.length, _ => 0u)).maxElement;
                    return Atom(list.map!(
                        row => verbs[InsName.Pad](longest, row)
                    ).array);
                },
                _ => Nil.nilAtom,
            ))
            // To base
            .setDyad((a, b) => match!(
                // TODO: mixed base
                (BigInt a, BigInt b) => Atom(b.toBase(a).map!Atom.array),
                (_1, _2) => Nil.nilAtom,
            )(a, b))
            .setInverseMutual(new Verb("#:!.")
                .setMonad(a => verbs[InsName.FromBase](a))
                .setDyad((a, b) => verbs[InsName.FromBase](a, b))
                .setMarkedArity(1)
            )
            .setMarkedArity(1);
        // TODO: inverse
        
        verbs[InsName.Pair] = new Verb(",")
            .setMonad(a => a.match!(
                // Evaluate
                (string s) => Interpreter.evaluate(s),
                // Nub Sieve
                (Atom[] a) => Atom(nubSieve(a.map!"a.value").map!Atom.array),
                _ => Nil.nilAtom,
            ))
            // Pair
            .setDyad((a, b) => Atom([a, b]))
            .setMarkedArity(2);
        
        verbs[InsName.Binomial] = new Verb("!")
            .setMonad(a => a.match!(
                // Enumerate
                (Atom[] a) =>
                    Atom(a.enumerate()
                    .map!(t => Atom([Atom(BigInt(t[0])), t[1]]))
                    .array),
                // Square
                (a) => atomFor(a * a),
                _ => Nil.nilAtom,
            ))
            .setDyad((l, r) => match!(
                // duplicate each
                (Atom[] as, Atom[] bs) => Atom(duplicateEachArray(bs, as)),
                (Atom[] as, string b) => Atom(duplicateEachArray(b.atomChars, as).joinToString),
                (string a, Atom[] bs) => Atom(duplicateEachArray(a.atomChars, bs).joinToString),
                (a, Atom[] b) => Atom(duplicateEach(b, a)),
                (Atom[] a, b) => Atom(duplicateEach(a, b)),
                (a, string b) => Atom(duplicateEach(b.atomChars, a).joinToString),
                (string a, b) => Atom(duplicateEach(a.atomChars, b).joinToString),
                // Binomial
                (a, b) => Atom(binomial(a, b)),
                (_1, _2) => Nil.nilAtom,
            )(l, r))
            .setInverse(new Verb("!!.")
                .setMonad(a => a.match!(
                    (Atom[] a) => Atom(a.map!(c => c.match!(c => atomFor(c[1]), _ => c)).array),
                    _ => Nil.nilAtom,
                ))
                .setDyad((_1, _2) => Nil.nilAtom)
                .setMarkedArity(1)
            )
            .setMarkedArity(2);
        
        verbs[InsName.First] = new Verb("{")
            // First element
            .setMonad(a => a.match!(
                (Atom[] _) => verbs[InsName.First](Atom(BigInt(0)), a),
                (string _) => verbs[InsName.First](Atom(BigInt(0)), a),
                // idempotent for non-array/strings
                _ => a,
            ))
            // Index
            .setDyad((l, r) {
                try {
                    return match!(
                        // TODO: index by real?
                        (bool b, Atom[] a) => !b || a.length <= 1
                            ? a[0]
                            : a[1],
                        (BigInt b, Atom[] a) => a.length
                            ? a[moldIndex(b, a.length)]
                            : Nil.nilAtom,
                        (BigInt b, string a) =>
                            Atom(to!string(a[moldIndex(b, a.length)])),
                        (Atom[] b, string a) {
                            Atom[] result = b.map!(e => verbs[InsName.First](e, a)).array;
                            if(b.any!isArray) {
                                return Atom(result);
                            }
                            else {
                                // only coalesce to string if we were at the lowest level
                                return Atom(result.joinToString);
                            }
                        },
                        (Atom[] b, a) =>
                            Atom(b.map!(e => verbs[InsName.First](e, a)).array),
                        (b, AVHash h) => Atom(h[_AtomValue(b)]),
                        (_1, _2) => Nil.nilAtom,
                    )(l, r);
                }
                catch(RangeError) {
                    assert(0, "Runtime Error: Invalid index `" ~ l.atomToString() ~ "` into `" ~ r.atomToString() ~ "`");
                }
            })
            .setMarkedArity(2);
        
        verbs[InsName.Last] = new Verb("}")
            // Last element
            .setMonad(a => a.match!(
                (Atom[] _) => verbs[InsName.First](Atom(BigInt(-1)), a),
                (string _) => verbs[InsName.First](Atom(BigInt(-1)), a),
                // idempotent for non-array/strings
                _ => a,
            ))
            .setDyad((l, r) => match!(
                // multiset subtraction
                (Atom[] a, Atom[] b) => Atom(multisetDifference(a, b)),
                (string a, string b) => Atom(multisetDifference(a, b)),
                (_1, _2) => Nil.nilAtom,
            )(l, r))
            .setMarkedArity(1);
        
        verbs[InsName.Equality] = new Verb("=")
            .setMonad(a => a.match!(
                (b) => Atom(eye(b)),
                (Atom[] a) => Atom(selfClassify(a)),
                _ => Nil.nilAtom,
            ))
            // Equal to
            .setDyad((a, b) => Atom(a == b))
            .setMarkedArity(2);
        
        verbs[InsName.Inequality] = new Verb("~:")
            // Halve
            .setMonad(a => a / Atom(BigInt(2)))
            // Not equal to
            .setDyad((a, b) => Atom(a != b))
            .setMarkedArity(2);
        
        verbs[InsName.LessThan] = new Verb("<")
            // ToString
            .setMonad(a => Atom(a.as!string))
            // Inverse: Evaluate
            .setInverse(new Verb("<!.")
                .setMonad(a => a.match!(
                    (string a) => Interpreter.evaluate(a),
                    _ => Nil.nilAtom,
                ))
                .setDyad((_1, _2) => Nil.nilAtom)
                .setMarkedArity(1)
            )
            // Less than
            .setDyad((a, b) => Atom(a < b))
            .setMarkedArity(2);
        
        verbs[InsName.GreaterThan] = new Verb(">")
            // Single Join
            .setMonad(a => a.match!(
                (Atom[] a) => Atom(a.joinToString),
                // Ords
                (string s) => Atom(s.map!(e => Atom(BigInt(cast(long) e))).array),
                _ => Nil.nilAtom,
            ))
            // Greater than
            .setDyad((a, b) => Atom(a > b))
            .setInverse(new Verb(">!.")
                .setMonad(a => a.match!(
                    (Atom[] o) => Atom(o.map!(a => a.as!dchar).to!string),
                    (n) => Atom((cast(dchar) n).to!string),
                    _ => Nil.nilAtom
                ))
                .setDyad((_1, _2) => Nil.nilAtom)
                .setMarkedArity(1)
            )
            .setMarkedArity(2);
        
        verbs[InsName.LessEqual] = new Verb("<:")
            // Decrement
            .setMonad(a => a.decrement())
            // Less than or equal to
            .setDyad((a, b) => Atom(a <= b))
            .setMarkedArity(2);
        
        verbs[InsName.GreaterEqual] = new Verb(">:")
            // Increment. TODO: Successor
            .setMonad(a => a.increment())
            // Greater than or equal to
            .setDyad((a, b) => Atom(a >= b))
            .setMarkedArity(2);
        
        import std.math.rounding;
        verbs[InsName.Minimum] = new Verb("<.")
            .setMonad(a => a.match!(
                // Minimum
                (Atom[] a) => foldFor(verbs[InsName.Minimum])(Atom(a)),
                // Floor
                (BigInt a) => Atom(a),
                (bool a) => Atom(a),
                (a) => Atom(BigInt(a.floor.to!string)),
                _ => Nil.nilAtom,
            ))
            .setDyad((l, r) {
                import core.exception : AssertError;
                // Lesser of 2
                try {
                    return min(l, r);
                }
                catch(AssertError e) {
                    return match!(
                        // and
                        (bool a, _) => Atom(a && r.truthiness),
                        (_, bool b) => Atom(l.truthiness && b),
                        (_1, _2) {
                            throw e;
                            return Nil.nilAtom;
                        }
                    )(l, r);
                }
            })
            .setIdentity(Infinity.positiveAtom)
            .setMarkedArity(2);
        
        verbs[InsName.Maximum] = new Verb(">.")
            .setMonad(a => a.match!(
                // Maximum
                (Atom[] a) => foldFor(verbs[InsName.Maximum])(Atom(a)),
                // Ceiling
                (BigInt a) => Atom(a),
                (bool a) => Atom(a),
                (a) => Atom(BigInt(a.ceil.to!string)),
                _ => Nil.nilAtom,
            ))
            .setDyad((l, r) {
                import core.exception : AssertError;
                // Greater of 2
                try {
                    return max(l, r);
                }
                catch(AssertError e) {
                    return match!(
                        // or
                        (bool a, _) => Atom(a || r.truthiness),
                        (_, bool b) => Atom(l.truthiness || b),
                        // rotate right
                        (BigInt i, Atom[] a) => Atom(rotate(a, i)),
                        (Atom[] a, BigInt i) => Atom(rotate(a, i)),
                        (BigInt i, string s) => Atom(rotate(s, i)),
                        (string s, BigInt i) => Atom(rotate(s, i)),
                        (_1, _2) {
                            throw e;
                            return Nil.nilAtom;
                        }
                    )(l, r);
                }
            })
            .setIdentity(Infinity.negativeAtom)
            .setMarkedArity(2);
        
        verbs[InsName.MemberIn] = new Verb("e.")
            .setMonad(a => a.match!(
                // All same
                (Atom[] a) => Atom(a.nub.length <= 1),
                _ => Nil.nilAtom,
            ))
            .setDyad((a, b) => match!(
                (a, Atom[] b) => Atom(b.canFind(atomFor(a))),
                (a, string b) => Atom(b.canFind(a)),
                (_1, _2) => Nil.nilAtom,
            )(a, b))
            .setMarkedArity(2);
        
        verbs[InsName.Print] = new Verb("echo")
            // Print
            .setMonad((a) {
                import std.stdio;
                writeln(a.atomToString());
                return a;
            })
            .setDyad((_1, _2) => Nil.nilAtom)
            .setMarkedArity(1);
        
        verbs[InsName.Put] = new Verb("put")
            // Put
            .setMonad((a) {
                import std.stdio;
                write(a.atomToString());
                return a;
            })
            .setDyad((_1, _2) => Nil.nilAtom)
            .setMarkedArity(1);
        
        verbs[InsName.Putch] = new Verb("putch")
            // Putch
            .setMonad(a => Atom(putch(a)))
            .setDyad((_1, _2) => Nil.nilAtom)
            .setMarkedArity(1);
        
        verbs[InsName.Exit] = new Verb("exit")
            // Exit
            .setMonad(a => a.match!(
                (BigInt a) => exit(a),
                _ => exit(),
            ))
            .setDyad((_1, _2) => exit())
            .setMarkedArity(1);
        
        verbs[InsName.Place] = new Verb("place")
            .setMonad(_ => Nil.nilAtom)
            .setDyad((a, b) => match!(
                // Place
                (Atom[] arr, Atom[] keyValue) {
                    Atom[] copy = arr.dup;
                    for(size_t i = 0; i < keyValue.length; i += 2) {
                        assert(i + 1 < keyValue.length, "Expected adjacent pairs");
                        Atom key = keyValue[i];
                        Atom value = keyValue[i + 1];
                        uint intKey = moldIndex(key.as!BigInt, arr.length);
                        copy[intKey] = value;
                    }
                    return Atom(copy);
                },
                (AVHash hash, Atom[] keyValue) {
                    AVHash copy = hash.dup;
                    for(size_t i = 0; i < keyValue.length; i += 2) {
                        assert(i + 1 < keyValue.length, "Expected adjacent pairs");
                        Atom key = keyValue[i];
                        Atom value = keyValue[i + 1];
                        try {
                            copy[key.value] = value.value;
                        }
                        catch(RangeError) {
                            assert(0, "Cannot insert `" ~ key.atomToString ~ "` into `" ~ a.atomToString ~ "`");
                        }
                    }
                    return Atom(copy);
                },
                (_1, _2) => Nil.nilAtom,
            )(a, b))
            .setMarkedArity(2);
            
        verbs[InsName.NthPrime] = new Verb("primn")
            // Nth prime
            .setMonad(a => a.match!(
                (BigInt a) => Atom(nthPrime(a)),
                _ => Nil.nilAtom,
            ))
            .setDyad((_1, _2) => Nil.nilAtom)
            .setMarkedArity(1);
        
        verbs[InsName.IsPrime] = new Verb("primq")
            // Is Prime
            .setMonad(a => a.match!(
                (BigInt a) => Atom(isPrime(a)),
                _ => Nil.nilAtom,
            ))
            .setDyad((_1, _2) => Nil.nilAtom)
            .setMarkedArity(1);
        
        verbs[InsName.PrimeFactors] = new Verb("primf")
            // Prime Factorization
            .setMonad(a => a.match!(
                (BigInt a) => Atom(primeFactors(a).map!Atom.array),
                _ => Nil.nilAtom,
            ))
            // Inverse: Product
            .setInverse(new Verb("primf!.")
                .setMonad(a => foldFor(verbs[InsName.Multiply])(a))
                .setDyad((_1, _2) => Nil.nilAtom)
                .setMarkedArity(1)
            )
            .setDyad((_1, _2) => Nil.nilAtom)
            .setMarkedArity(1);
        
        verbs[InsName.PrimeFactorsCount] = new Verb("primo")
            // Big Omega (prime factor count)
            .setMonad(a => a.match!(
                (BigInt a) => Atom(BigInt(primeFactors(a).length)),
                _ => Nil.nilAtom,
            ))
            .setDyad((_1, _2) => Nil.nilAtom)
            .setMarkedArity(1);
        
        verbs[InsName.UniqPrimeFactors] = new Verb("primfd")
            // Prime Factorization (no duplicates)
            .setMonad(a => a.match!(
                (BigInt a) => Atom(primeFactorsUnique(a).map!Atom.array),
                _ => Nil.nilAtom,
            ))
            .setDyad((_1, _2) => Nil.nilAtom)
            .setMarkedArity(1);
        
        verbs[InsName.UniqPrimeFactorsCount] = new Verb("primod")
            // Distinct prime factor count
            .setMonad(a => a.match!(
                (BigInt a) => Atom(BigInt(primeFactorsUnique(a).length)),
                _ => Nil.nilAtom,
            ))
            .setDyad((_1, _2) => Nil.nilAtom)
            .setMarkedArity(1);
        
        verbs[InsName.FirstNPrimes] = new Verb("prims")
            // First N Primes
            .setMonad(a => a.match!(
                (BigInt a) => Atom(firstNPrimes(a).map!Atom.array),
                _ => Nil.nilAtom,
            ))
            .setDyad((_1, _2) => Nil.nilAtom)
            .setMarkedArity(1);
        
        // TODO: abstract prime object
        verbs[InsName.PrimesBelow] = new Verb("primb")
            // Primes below
            .setMonad(a => a.match!(
                (BigInt a) => Atom(primesBelow(a).map!Atom.array),
                _ => Nil.nilAtom,
            ))
            .setDyad((_1, _2) => Nil.nilAtom)
            .setMarkedArity(1);
        
        verbs[InsName.PrimesBelowCount] = new Verb("primbo")
            // Primes below count
            .setMonad(a => a.match!(
                (BigInt a) => Atom(primesBelowCount(a)),
                _ => Nil.nilAtom,
            ))
            .setDyad((_1, _2) => Nil.nilAtom)
            .setMarkedArity(1);
        
        verbs[InsName.PreviousPrime] = new Verb("prevp")
            // Next Prime After
            .setMonad(a => a.match!(
                (BigInt a) => Atom(previousPrime(a)),
                _ => Nil.nilAtom,
            ))
            .setDyad((_1, _2) => Nil.nilAtom)
            .setMarkedArity(1);
        
        verbs[InsName.NextPrime] = new Verb("nextp")
            // Next Prime After
            .setMonad(a => a.match!(
                (BigInt a) => Atom(nextPrime(a)),
                _ => Nil.nilAtom,
            ))
            .setDyad((_1, _2) => Nil.nilAtom)
            .setMarkedArity(1);
        
        verbs[InsName.PrimeTotient] = new Verb("primt")
            // Prime Totient
            .setMonad(a => a.match!(
                (BigInt a) {
                    auto f = primeFactors(a);
                    return Atom(zip(f, nubSieve(f))
                        .map!"a[0] - (a[1] ? 1 : 0)"
                        .productOver
                    );
                },
                _ => Nil.nilAtom,
            ))
            .setDyad((_1, _2) => Nil.nilAtom)
            .setMarkedArity(1);
        
        verbs[InsName.FactorExponents] = new Verb("pfe")
            // Prime Factor Exponents (only, with zeroes)
            .setMonad(a => a.match!(
                (BigInt a) => Atom(
                    a.primeFactorExponents(true)
                     .map!(a => Atom(a[1]))
                     .array
                ),
                _ => Nil.nilAtom,
            ))
            .setDyad((_1, _2) => Nil.nilAtom)
            .setMarkedArity(1);
        
        verbs[InsName.FactorExponentPairs] = new Verb("pfeb")
            // Prime Factor Exponents (paired with factors, with zeroes)
            .setMonad(a => a.match!(
                (BigInt a) => Atom(
                    a.primeFactorExponents(true)
                     .map!(a => Atom([Atom(a[0]), Atom(a[1])]))
                     .array
                ),
                _ => Nil.nilAtom,
            ))
            .setDyad((_1, _2) => Nil.nilAtom)
            .setMarkedArity(1);
        
        verbs[InsName.FactorExponentsPos] = new Verb("pfep")
            // Prime Factor Exponents (only, without zeroes)
            .setMonad(a => a.match!(
                (BigInt a) => Atom(
                    a.primeFactorExponents
                     .map!(a => Atom(a[1]))
                     .array
                ),
                _ => Nil.nilAtom,
            ))
            .setDyad((_1, _2) => Nil.nilAtom)
            .setMarkedArity(1);
        
        verbs[InsName.FactorExponentPairsPos] = new Verb("pfebp")
            // Prime Factor Exponents (paired with factors, without zeroes)
            .setMonad(a => a.match!(
                (BigInt a) => Atom(
                    a.primeFactorExponents
                     .map!(a => Atom([Atom(a[0]), Atom(a[1])]))
                     .array
                ),
                _ => Nil.nilAtom,
            ))
            .setDyad((_1, _2) => Nil.nilAtom)
            .setMarkedArity(1);
            
        verbs[InsName.LastChain] = new Verb("$^")
            // Last Chain
            .setMonad((Verb v, a) {
                Debugger.print("-- CALLING $^(1) --");
                Debugger.print("Info: ", v.info);
                Debugger.print("Last is self? ", v.info.last == v);
                if(v.info.index) {
                    Debugger.print("Last is correct? ", v.info.last == v.info.chains[v.info.index - 1]);
                    Debugger.print("Last: ", v.info.last);
                    Debugger.print("Last info: ", v.info.last.info);
                }
                return v.info.last(a);
            })
            .setDyad((Verb v, a, b) {
                Debugger.print("-- CALLING $^(2) --");
                Debugger.print("Info: ", v.info);
                Debugger.print("Last is self? ", v.info.last == v);
                if(v.info.index) {
                    Debugger.print("Last is correct? ", v.info.last == v.info.chains[v.info.index - 1]);
                }
                return v.info.last(a, b);
            })
            // TODO: copy last chains' marked arity
            .setMarkedArity(1);
            
        verbs[InsName.ThisChain] = new Verb("$:")
            // Self Chain
            .setMonad((Verb v, a) => v.info.self(a))
            .setDyad((Verb v, a, b) => v.info.self(a, b))
            // TODO: copy this chains' marked arity
            .setMarkedArity(1);
            
        verbs[InsName.NextChain] = new Verb("$v")
            // Next Chain
            .setMonad((Verb v, a) => v.info.next(a))
            .setDyad((Verb v, a, b) => v.info.next(a, b))
            // TODO: copy next chains' marked arity
            .setMarkedArity(1);
        
        verbs[InsName.DigitRange] = new Verb("R:")
            // Base 10 range
            .setMonad(a => a.match!(
                a => Atom(baseRange(a).map!Atom.array),
                _ => Nil.nilAtom,
            ))
            .setDyad((n, base) => match!(
                // Base Range
                (n, base) => Atom(baseRange(n, base).map!Atom.array),
                // Array Range
                (Atom[] a, Atom[] b) => Atom(arrayRange(a, b).map!Atom.array),
                (string a, string b) => Atom(
                    arrayRange(a.atomOrds, b.atomOrds)
                    .map!atomUnords
                    .map!Atom
                    .array
                ),
                (_1, _2) => Nil.nilAtom,
            )(n, base))
            .setMarkedArity(1);
            
        verbs[InsName.Hash] = new Verb("hash")
            .setMonad(a => a.match!(
                (Atom[] a) {
                    AVHash h;
                    
                    for(size_t i = 0; i < a.length; i += 2) {
                        assert(i + 1 < a.length, "Expected two adjacent elements");
                        Atom key = a[i];
                        Atom value = a[i + 1];
                        h[key.value] = value.value;
                    }
                    
                    return Atom(h);
                },
                (AVHash h) => Atom(h.dup),
                _ => Nil.nilAtom
            ))
            .setDyad((_1, _2) => Nil.nilAtom)
            .setMarkedArity(1);
        
        verbs[InsName.Subset] = new Verb("(.")
            .setMonad(_ => Nil.nilAtom)
            .setDyad((a, b) => match!(
                (a, b) => Atom(isStrictSubset(a, b)),
                (_1, _2) => Nil.nilAtom
            )(a, b))
            .setMarkedArity(2);
        
        verbs[InsName.Subseteq] = new Verb("(..")
            .setMonad(_ => Nil.nilAtom)
            .setDyad((a, b) => match!(
                (a, b) => Atom(isSubsetOrEqual(a, b)),
                (_1, _2) => Nil.nilAtom
            )(a, b))
            .setMarkedArity(2);
        
        verbs[InsName.Superset] = new Verb(").")
            .setMonad(_ => Nil.nilAtom)
            .setDyad((a, b) => match!(
                (a, b) => Atom(isStrictSuperset(a, b)),
                (_1, _2) => Nil.nilAtom
            )(a, b))
            .setMarkedArity(2);
        
        verbs[InsName.Superseteq] = new Verb(")..")
            .setMonad(_ => Nil.nilAtom)
            .setDyad((a, b) => match!(
                (a, b) => Atom(isSupersetOrEqual(a, b)),
                (_1, _2) => Nil.nilAtom
            )(a, b))
            .setMarkedArity(2);
        
        verbs[InsName.MinMax] = new Verb("minmax")
            .setMonad(a => verbs[InsName.Pair](
                verbs[InsName.Minimum](a),
                verbs[InsName.Maximum](a)
            ))
            .setDyad((a, b) => verbs[InsName.Pair](
                verbs[InsName.Minimum](a, b),
                verbs[InsName.Maximum](a, b)
            ))
            .setMarkedArity(1);
        
        verbs[InsName.FromJSON] = new Verb("unjson")
            .setMonad(a => a.match!(
                (string s) => jsonToAtom(s),
                _ => Nil.nilAtom,
            ))
            .setDyad((_1, _2) => Nil.nilAtom)
            .setInverse(new Verb("unjson!.")
                .setMonad(a => Atom(atomToJson(a)))
                .setDyad((_1, _2) => Nil.nilAtom)
                .setMarkedArity(1)
            )
            .setMarkedArity(1);
        
        verbs[InsName.ToJSON] = new Verb("json")
            .setMonad(a => Atom(atomToJson(a)))
            .setDyad((_1, _2) => Nil.nilAtom)
            .setInverse(new Verb("json!.")
                .setMonad(a => a.match!(
                    (string s) => jsonToAtom(s),
                    _ => Nil.nilAtom,
                ))
                .setDyad((_1, _2) => Nil.nilAtom)
                .setMarkedArity(1)
            )
            .setMarkedArity(1);
        
        verbs[InsName.ReadFile] = new Verb("read")
            .setMonad(a => a.match!(
                (string s) {
                    import std.file : read;
                    return Atom(cast(string)(read(s)));
                },
                _ => Nil.nilAtom,
            ))
            .setDyad((_1, _2) => Nil.nilAtom)
            .setMarkedArity(1);
        
        verbs[InsName.WriteFile] = new Verb("write")
            .setMonad(a => Nil.nilAtom)
            .setDyad((content, name) => match!(
                (c, string n) {
                    import std.file : write;
                    string ts = atomFor(c).atomToString;
                    write(n, ts);
                    // return Atom(ts);
                    return Atom(n);
                },
                (_1, _2) => Nil.nilAtom,
            )(name, content))
            .setMarkedArity(1);
        
        import std.ascii;
        verbs[InsName.IsAlpha] = new Verb("alq")
            .setMonad(a => a.match!(
                (string s) => Atom(s.all!isAlpha),
                _ => Nil.nilAtom
            ))
            .setDyad((_1, _2) => Nil.nilAtom)
            .setMarkedArity(1);
        
        verbs[InsName.IsNumeric] = new Verb("numq")
            .setMonad(a => a.match!(
                (string s) => Atom(s.all!isDigit),
                _ => Nil.nilAtom
            ))
            .setDyad((_1, _2) => Nil.nilAtom)
            .setMarkedArity(1);
        
        verbs[InsName.IsAlphaNumeric] = new Verb("alnumq")
            .setMonad(a => a.match!(
                (string s) => Atom(s.all!isAlphaNum),
                _ => Nil.nilAtom
            ))
            .setDyad((_1, _2) => Nil.nilAtom)
            .setMarkedArity(1);
        
        verbs[InsName.IsUppercase] = new Verb("upq")
            .setMonad(a => a.match!(
                (string s) => Atom(s.all!isUpper),
                _ => Nil.nilAtom
            ))
            .setDyad((_1, _2) => Nil.nilAtom)
            .setMarkedArity(1);
        
        verbs[InsName.IsLowercase] = new Verb("downq")
            .setMonad(a => a.match!(
                (string s) => Atom(s.all!isLower),
                _ => Nil.nilAtom
            ))
            .setDyad((_1, _2) => Nil.nilAtom)
            .setMarkedArity(1);
        
        verbs[InsName.IsBlank] = new Verb("blankq")
            .setMonad(a => a.match!(
                (string s) => Atom(s.all!isWhite),
                _ => Nil.nilAtom
            ))
            .setDyad((_1, _2) => Nil.nilAtom)
            .setMarkedArity(1);
        
        verbs[InsName.KeepAlpha] = new Verb("alk")
            .setMonad(a => a.match!(
                (string s) => Atom(s.filter!isAlpha.to!string),
                _ => Nil.nilAtom
            ))
            .setDyad((_1, _2) => Nil.nilAtom)
            .setMarkedArity(1);
        
        verbs[InsName.KeepNumeric] = new Verb("numk")
            .setMonad(a => a.match!(
                (string s) => Atom(s.filter!isDigit.to!string),
                _ => Nil.nilAtom
            ))
            .setDyad((_1, _2) => Nil.nilAtom)
            .setMarkedArity(1);
        
        verbs[InsName.KeepAlphaNumeric] = new Verb("alnumk")
            .setMonad(a => a.match!(
                (string s) => Atom(s.filter!isAlphaNum.to!string),
                _ => Nil.nilAtom
            ))
            .setDyad((_1, _2) => Nil.nilAtom)
            .setMarkedArity(1);
        
        verbs[InsName.KeepUppercase] = new Verb("upk")
            .setMonad(a => a.match!(
                (string s) => Atom(s.filter!isUpper.to!string),
                _ => Nil.nilAtom
            ))
            .setDyad((_1, _2) => Nil.nilAtom)
            .setMarkedArity(1);
        
        verbs[InsName.KeepLowercase] = new Verb("downk")
            .setMonad(a => a.match!(
                (string s) => Atom(s.filter!isLower.to!string),
                _ => Nil.nilAtom
            ))
            .setDyad((_1, _2) => Nil.nilAtom)
            .setMarkedArity(1);
        
        verbs[InsName.KeepBlank] = new Verb("blankk")
            .setMonad(a => a.match!(
                (string s) => Atom(s.filter!isWhite.to!string),
                _ => Nil.nilAtom
            ))
            .setDyad((_1, _2) => Nil.nilAtom)
            .setMarkedArity(1);
        
        verbs[InsName.Palindromize] = new Verb("enpal")
            .setMonad(a => a.match!(
                (s) => Atom(s ~ s.retro.array[1..$].to!(typeof(s))),
                _ => Nil.nilAtom,
            ))
            .setDyad((_1, _2) => Nil.nilAtom)
            .setMarkedArity(1);
        
        verbs[InsName.Inside] = new Verb("inner")
            .setMonad(a => a.match!(
                (s) => Atom(s.length <= 1 ? s[0..0] : s[1..$-1]),
                _ => Nil.nilAtom,
            ))
            .setDyad((_1, _2) => Nil.nilAtom)
            .setMarkedArity(1);
        
        // time
        verbs[InsName.SysTime] = new Verb("time")
            .setMonad((a) {
                SysTime today = Clock.currTime();
                AVHash data;
                data[_AtomValue("yr")] = BigInt(today.year);
                data[_AtomValue("mo")] = BigInt(today.month);
                data[_AtomValue("dy")] = BigInt(today.day);
                data[_AtomValue("hr")] = BigInt(today.hour);
                data[_AtomValue("mn")] = BigInt(today.minute);
                data[_AtomValue("sc")] = BigInt(today.second);
                return Atom(data);
            })
            .setDyad((_1, _2) => Nil.nilAtom)
            .setMarkedArity(1);
        
        verbs[InsName.Year] = new Verb("yr")
            .setMonad(a => a.match!(
                (AVHash data) => Atom(data[_AtomValue("yr")]),
                _ => Atom(BigInt(Clock.currTime().year))
            ))
            .setDyad((_1, _2) => Nil.nilAtom)
            .setMarkedArity(1);
        
        verbs[InsName.Month] = new Verb("mo")
            .setMonad(a => a.match!(
                (AVHash data) => Atom(data[_AtomValue("mo")]),
                _ => Atom(BigInt(Clock.currTime().month))
            ))
            .setDyad((_1, _2) => Nil.nilAtom)
            .setMarkedArity(1);
        
        verbs[InsName.Day] = new Verb("dy")
            .setMonad(a => a.match!(
                (AVHash data) => Atom(data[_AtomValue("dy")]),
                _ => Atom(BigInt(Clock.currTime().day))
            ))
            .setDyad((_1, _2) => Nil.nilAtom)
            .setMarkedArity(1);
        
        verbs[InsName.Hour] = new Verb("hr")
            .setMonad(a => a.match!(
                (AVHash data) => Atom(data[_AtomValue("hr")]),
                _ => Atom(BigInt(Clock.currTime().hour))
            ))
            .setDyad((_1, _2) => Nil.nilAtom)
            .setMarkedArity(1);
        
        verbs[InsName.Minute] = new Verb("mn")
            .setMonad(a => a.match!(
                (AVHash data) => Atom(data[_AtomValue("mn")]),
                _ => Atom(BigInt(Clock.currTime().minute))
            ))
            .setDyad((_1, _2) => Nil.nilAtom)
            .setMarkedArity(1);
        
        verbs[InsName.Second] = new Verb("sc")
            .setMonad(a => a.match!(
                (AVHash data) => Atom(data[_AtomValue("sc")]),
                _ => Atom(BigInt(Clock.currTime().second))
            ))
            .setDyad((_1, _2) => Nil.nilAtom)
            .setMarkedArity(1);
        
        // f
        verbs[InsName.F] = new Verb("F:")
            .setMonad(_ => Nil.nilAtom)
            .setDyad((_1, _2) => Nil.nilAtom)
            .setMarkedArity(1);
        // g
        verbs[InsName.G] = new Verb("G:")
            .setMonad(_ => Nil.nilAtom)
            .setDyad((_1, _2) => Nil.nilAtom)
            .setMarkedArity(1);
        // h
        verbs[InsName.H] = new Verb("H:")
            .setMonad(_ => Nil.nilAtom)
            .setDyad((_1, _2) => Nil.nilAtom)
            .setMarkedArity(1);
        
        // Nilads
        verbs[InsName.Empty] = Verb.nilad(Atom(cast(Atom[])[]));
        verbs[InsName.Empty].display = "E";
        
        verbs[InsName.Ascii] = Verb.nilad(Atom(
            iota(95).map!(a => Atom("" ~ cast(char)(32 + a))).array
        ));
        verbs[InsName.Ascii].display = "A";
        
        verbs[InsName.Alpha] = Verb.nilad(Atom("abcdefghijklmnopqrstuvwxyz"));
        verbs[InsName.Alpha].display = "L";
        
        verbs[InsName.Vowels] = Verb.nilad(Atom("aeiou"));
        verbs[InsName.Vowels].display = "vow";
        
        verbs[InsName.Consonants] = Verb.nilad(Atom("bcdfghjklmnpqrstvwxyz"));
        verbs[InsName.Consonants].display = "con";
        
        verbs[InsName.Getch] = new Verb("getch")
            .setMonad(_ => atomGetch())
            .setDyad((_1, _2) => atomGetch())
            .setNiladic(true);
    }
    
    Verb* verb = name in verbs;
    assert(verb, "No such verb: " ~ to!string(name));
    return *verb;
}
