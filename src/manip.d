module myby.manip;

import std.algorithm.comparison;
import std.algorithm.iteration;
import std.algorithm.searching;
import std.algorithm.sorting;
import std.array;
import std.bigint;
import std.conv : to, ConvOverflowException;
import std.range;
import std.sumtype;
import std.traits;

import myby.speech;

template mapKeyValue(ReturnHash, alias fun) {
    auto mapKeyValue(Hash)(Hash a) if(isAssociativeArray!Hash) {
        ReturnHash res;
        foreach(k, v; a) {
            fun(res, k, v);
        }
        return res;
    }
}

auto productOver(T)(T arr) {
    return reduce!"a * b"(BigInt(1), arr);
}

Atom[] flatten(Atom[] arr) {
    Atom[] res;
    foreach(atom; arr) {
        atom.match!(
            (Atom[] sub) => res ~= flatten(sub),
            _ =>            res ~= Atom(_),
        );
    }
    return res;
}

Atom[] reshape(Number)(Atom[] arr, Number n) {
    assert(arr.length > 0, "Cannot reshape empty array");
    Atom[] res;
    for(Number i = 0; i < n; i++) {
        auto index = cast(uint)(i % arr.length);
        res ~= arr[index];
    }
    return res;
}

Atom[] atomChars(string str) {
    // return str.map!(to!string).map!Atom.array
    Atom[] res;
    foreach(ch; str) {
        res ~= Atom(ch ~ "");
    }
    return res;
}

Atom[] atomOrds(string str) {
    return str.map!(to!uint).map!BigInt.map!Atom.array;
}

string atomUnords(Atom[] ords) {
    string res;
    foreach(o; ords) {
        res ~= o.as!dchar;
    }
    return res;
}

string joinToString(Atom[] arr) {
    string res;
    foreach(atom; arr) {
        res ~= to!string(atom);
    }
    return res;
}

BigInt pow(BigInt base, BigInt exp) {
    if(exp == 0) return BigInt("1");
    try {
        return base ^^ cast(ulong) exp;
    }
    catch(ConvOverflowException) {
        // thanks to @betseg
        // technically not necessary but it's nice to have
        // if we ever get computers beefy enough, i guess
        BigInt acc = 1;
        while(exp > 1) {
            if(exp % 2 == 1) {
                acc *= base;
            }
            exp /= 2;
            base *= base;
        }
        return acc * base;
    }
}

auto positiveMod(S, T)(S a, T b) {
    auto mod = a % b;
    if(mod < 0) mod += b;
    return mod;
}

uint moldIndex(S, T)(S index, T max) {
    assert(max > 0, "Cannot index from a non-positive length");
    return to!uint(positiveMod(index, max));
}

Atom exit(BigInt code = 0) {
    import core.stdc.stdlib;
    core.stdc.stdlib.exit(to!uint(code));
}

Verb filterFor(Verb v) {
    return new Verb("₁\\")
        .setMonad(a => a.match!(
            (Atom[] a) => Atom(a.filter!(a => v(a).truthiness).array),
            _ => Nil.nilAtom,
        ))
        .setDyad((a, b) => Nil.nilAtom)
        .setMarkedArity(1)
        .setChildren([v]);
}

Verb foldFor(Verb v) {
    Atom reduc(T)(T arr) {
        // TODO: I don't like that this conditional is checked every time
        // find a way to eliminate it
        return v.identity.isNil
            ? arr.reduce!v
            : reduce!v(v.identity, arr);
    }
    import myby.debugger;
    return new Verb("₂\\")
        .setMonad(a => a.match!(
            (Atom[] arr) {
                Debugger.print("Fold for  ", v);
                Debugger.print("Identity: ", v.identity);
                Debugger.print("Array:    ", arr);
                return reduc(arr);
            },
            (BigInt n) => reduc(iota(v.rangeStart, n + 1).map!Atom),
            _ => Nil.nilAtom,
        ))
        .setDyad((a, b) => match!(
            (BigInt a, BigInt b) => Atom(BigInt("234")),
            // table
            (Atom[] a, Atom[] b) =>
                Atom(a.map!(l => Atom(b.map!(r => v(l, r)).array)).array),
            (_1, _2) => Nil.nilAtom,
        )(a, b))
        .setMarkedArity(1)
        .setChildren([v]);
}

Verb powerFor(Verb f, Verb g) {
    return new Verb("^:")
        .setMonad((a) {
            Atom times = g(a);
            return times.match!(
                (Infinity i) => assert(0, "TODO: Fixpoint"),
                (n) {
                    assert(n >= 0, "TODO: Negative (inverse) repetition");
                    for(typeof(n) i = 0; i < n; i++) {
                        a = f(a);
                    }
                    return a;
                },
                _ => Nil.nilAtom,
            );
        })
        .setDyad((_1, _2) => Nil.nilAtom)
        .setMarkedArity(1)
        .setChildren([f, g]);
}

Atom[] nub(Atom[] a) {
    Atom[] res;
    foreach(x; a) {
        if(!res.canFind(x)) {
            res ~= x;
        }
    }
    return res;
}

Atom[] eye(BigInt b) {
    if(b <= 0) {
        return [Atom(cast(Atom[]) [])];
    }
    Atom[] rows;
    for(BigInt i = 0; i < b; i++) {
        Atom[] row;
        for(BigInt j = 0; j < b; j++) {
            row ~= Atom(BigInt(i == j ? 1 : 0));
        }
        rows ~= Atom(row);
    }
    return rows;
}

Atom[] selfClassify(Atom[] a) {
    Atom[] rows;
    foreach(u; a.nub) {
        Atom[] row;
        foreach(x; a) {
            row ~= Atom(BigInt(u == x ? 1 : 0));
        }
        rows ~= Atom(row);
    }
    return rows;
}

Atom succ(Atom n) {
    return n.match!(
        (bool b) => Atom(!b),
        (real r) => Atom(r + 1.0),
        (BigInt b) => Atom(b + 1),
        _ => Nil.nilAtom,
    );
}

bool arraySucc(ref Atom[] base, Atom[] start, Atom[] max) {
    for(uint i = 1; i <= base.length; i++) {
        base[$-i] = succ(base[$-i]);
        if(base[$-i] > max[$-i]) {
            base[$-i] = start[$-i];
        }
        else {
            return true;
        }
    }
    return false;
}

Atom[][] arrayRange(Atom[] start, Atom[] end) {
    Atom[][] res;
    Atom[] i = start.dup;
    import std.stdio;
    while(i <= end) {
        res ~= i.dup;
        if(!i.arraySucc(start, end)) {
            break;
        }
    }
    return res;
}

Atom[] scanThrough(Atom[] base, Verb fn, Atom seed) {
    Atom[] res;
    foreach(el; base) {
        el.match!(
            (Atom[] next) {
                res ~= Atom(scanThrough(next, fn, seed));
            },
            (a) {
                seed = fn(seed, a);
                res ~= seed;
            },
        );
    }
    return res;
}
