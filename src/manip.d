module myby.manip;

import std.algorithm.comparison;
import std.algorithm.iteration;
import std.algorithm.searching;
import std.algorithm.sorting;
import std.array;
import std.bigint;
import std.conv : to, ConvOverflowException;
import std.datetime;
import std.functional : binaryFun;
import std.range;
import std.sumtype;
import std.traits;

import myby.speech;
import myby.debugger;

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
    alias Base = ElementType!T;
    return reduce!"a * b"(cast(Base) 1, arr);
}

auto binomial(T, S)(T a, S b) {
    static if(is(T == real) || is(S == real)) {
        alias Return = real;
    }
    else static if(is(T == BigInt) || is(S == BigInt)) {
        alias Return = BigInt;
    }
    else {
        alias Return = T;
    }
    
    Return left = a;
    Return right = b;
    Return underMin = min(left, right - left);
    Return underMax = max(left, right - left);
    
    return a > b
        ? cast(Return) 0
        : productOver(iota(underMax + 1, right + 1)) / productOver(iota(cast(Return) 1, underMin + 1));
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

string joinToString(T)(T arr) {
    string res;
    foreach(atom; arr) {
        res ~= to!string(atom);
    }
    return res;
}

BigInt pow(BigInt base, BigInt exp) {
    if(exp == 0 && base < 0) assert(0, "TODO: negative infinity");
    // round down to 0
    if(exp < 0 && base > 1) return BigInt("0");
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

auto pow(T, S)(T a, S b)
if(__traits(compiles, a ^^ b)) {
    return a ^^ b;
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

auto atomFilter(alias fn, T)(T arr) {
    static if(is(ReturnType!fn == Atom)) {
        return arr.filter!(t => fn(t).truthiness);
    }
    else {
        return arr.filter!fn;
    }
}

Verb filterFor(Verb v) {
    return new Verb("₁\\")
        .setMonad((Verb v, a) => a.match!(
            (Atom[] a) =>
                Atom(a.atomFilter!v.array),
            _ => Nil.nilAtom,
        ))
        .setDyad((Verb v, a, b) => match!(
            (Atom[] a, b) => 
                Atom(a.filter!(t => v(t, b).truthiness).array),
            (a, Atom[] b) => 
                Atom(b.filter!(t => v(a, t).truthiness).array),
            (_1, _2) => Nil.nilAtom,
        )(a, b))
        .setMarkedArity(1)
        .setChildren([v]);
}

Verb foldFor(Verb v) {
    import myby.debugger;
    Atom reduceHelper(T)(Verb v, T arr) {
        // TODO: I don't like that this conditional is checked every time
        // find a way to eliminate it
        Debugger.print("Reducing: ", arr);
        
        Atom id = v.getIdentity(arr);
        if(v.isGerund) {
            Debugger.print("Gerund detected");
            auto en = arr.enumerate();
            alias IndexValue = typeof(en.front);
            return id.isNil
                ? en.reduce!((p, c) =>
                    IndexValue(p.index, v.gerund(c.index, p.value, c.value))
                ).value
                : reduce!((p, c) =>
                    v.gerund(c.index ? c.index - 1 : c.index, p, c.value)
                )(id, en);
        }
        else {
            return id.isNil
                ? arr.reduce!v
                : reduce!v(id, arr);
        }
    }
    return new Verb("₂\\")
        .setMonad((Verb v, a) => a.match!(
            (Atom[] arr) {
                Debugger.print("Fold for  ", v);
                Debugger.print("Identity: ", v.identity);
                Debugger.print("Head id:  ", v.getIdentity(arr));
                Debugger.print("Array:    ", arr);
                return reduceHelper(v, arr);
            },
            // TODO: it might be more useful to special case filter when called on integers
            // like, who's gonna use ^\ ????
            (n) {
                auto start = v.rangeStart.as!(typeof(n));
                if(start > n) {
                    // iota doesn't correctly handle reals creating an empty range
                    return reduceHelper(v, cast(Atom[]) []);
                }
                else {
                    return reduceHelper(v, iota(start, n + 1).map!Atom);
                }
            },
            _ => Nil.nilAtom,
        ))
        .setDyad((Verb v, a, b) => match!(
            // TODO:
            (BigInt a, BigInt b) => Atom(BigInt("234")),
            // table
            (Atom[] a, Atom[] b) =>
                Atom(a.map!(l => Atom(b.map!(r => v(l, r)).array)).array),
            (_1, _2) => Nil.nilAtom,
        )(a, b))
        .setMarkedArity(1)
        .setChildren([v]);
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

Atom[] eye(Number)(Number b) {
    if(b <= 0) {
        return [Atom(cast(Atom[]) [])];
    }
    Atom[] rows;
    for(Number i = 0; i < b; i++) {
        Atom[] row;
        for(Number j = 0; j < b; j++) {
            row ~= Atom(Number(i == j ? 1 : 0));
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

Atom vectorAt(Verb v, Atom a) {
    return a.match!(
        (Atom[] arr) => Atom(arr.map!(e => vectorAt(v, e)).array),
        a => v(a),
    );
}

Atom vectorAt(Verb v, Atom a, Atom b) {
    return match!(
        // TODO: replicate
        (Atom[] a, Atom[] b) => Atom(
            zip(a, b).map!(t => vectorAt(v, t[0], t[1])).array
        ),
        // TODO: maybe don't call atomFor each iteration
        (Atom[] a, b) => Atom(a.map!(t => vectorAt(v, t, atomFor(b))).array),
        (a, Atom[] b) => Atom(b.map!(t => vectorAt(v, atomFor(a), t)).array),
        (a, b) => v(a, b),
    )(a, b);
}

S[] toBase(S, T)(S a, T b) {
    // special case: "unary"
    if(b == 1) {
        return (a/a).repeat(a.to!uint).array;
    }
    // special case: zero
    if(a == 0) {
        return [a-a];
    }
    S[] res;
    while(a != 0) {
        S mod = a;
        mod %= b;
        res.insertInPlace(0, mod);
        a /= b;
    }
    return res;
}

Atom fromBase(B)(Atom a, B base) {
    return a.match!(
        (Atom[] a) => Atom(arrayFromBase(a, base)),
        (string a) => Atom(stringFromBase(a, base)),
        _ => Nil.nilAtom,
    );
}

Atom arrayFromBase(B)(Atom[] n, B base) {
    // TODO: floating point??
    BigInt sum;
    if(n.empty) return Atom(sum);
    bool isArrayArray = n[0].match!(
        (Atom[] _) => true,
        (string _) => true,
        _ => false
    );
    if(isArrayArray) {
        return Atom(n.map!(a => fromBase(a, base)).array);
    }
    // TODO: better approach to indexing an array nicely?
    foreach(i, e; zip(n.length.iota, n.retro)) {
        e.match!(
            (BigInt e) { sum += base^^i * e; },
            (bool b) { if(b) sum += base^^i; },
            _ => assert(0, "Invalid base digit: " ~ e.atomToString)
        );
    }
    return Atom(sum);
}

Atom[][] chunkVerb(Verb v, Atom[] list) {
    if(v.markedArity == 1) {
        return list.chunkBy!((a, b) => v(a) == v(b))
            .map!array
            // .map!Atom
            .array;
    }
    else {
        return list.splitWhen!((a, b) => !v(a, b).truthiness)
            .map!array
            // .map!Atom
            .array;
    }
}

Atom chunkVerb(Verb v, Atom a) {
    return a.match!(
        (Atom[] list) => Atom(chunkVerb(v, list).map!Atom.array),
        (string str) => Atom(chunkVerb(v, str.atomChars).map!joinToString.map!Atom.array),
        _ => Nil.nilAtom,
    );
}

string INSENSITIVE_ALPHABET = "0123456789abcdefghijklmnopqrstuvwxyz";
string SENSITIVE_ALPHABET = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
Atom stringFromBase(B)(string n, B base) {
    import std.string : toLower;
    
    string alphabet = SENSITIVE_ALPHABET;
    if(base <= INSENSITIVE_ALPHABET.length) {
        alphabet = INSENSITIVE_ALPHABET;
        n = n.toLower;
    }
    
    Atom[] result = n.map!((c) {
        auto index = alphabet.countUntil(c);

        assert(0 <= index && index < base,
            "Invalid base " ~ base.to!string ~ " digit: " ~ c.to!string);

        return Atom(BigInt(index));
    }).array;
    
    return arrayFromBase(result, base);
}

auto baseRange(S, T)(S n, T base) {
    S min = n == 0
        ? cast(S)1 // to make range empty
        : n == 1
            ? cast(S)0
            : pow(base, n - 1);
    S max = pow(base, n);
    return iota(min, max);
}

auto baseRange(S)(S n) {
    return baseRange(n, cast(S)10);
}

int getch() {
    import core.stdc.stdio;
    return fgetc(stdin);
}

Atom atomGetch() {
    return Atom(BigInt(getch));
}

bool putch(Atom a) {
    import std.stdio;
    return a.match!(
        (Atom[] arr) {
            foreach(a; arr) {
                if(!putch(a)) {
                    return false;
                }
            }
            return true;
        },
        (a) {
            //TODO: char
            if(a < 0) {
                return false;
            }
            char c = cast(char)a;
            write(c);
            return true;
        },
        (string s) {
            write(s);
            return true;
        },
        _ => false
    );
}

real secondsFraction(alias unit, T)(T ds) {
    enum sf = 1.seconds.total!unit;
    real res = mixin("ds." ~ unit);
    res /= sf;
    return res;
}

Atom integers(Atom[] dim) {
    uint counter = 0;
    Atom helper(Atom[] dim) {
        if(dim.empty) {
            return Atom(BigInt(counter++));
        }
        Atom[] res = [];
        uint max = dim[0].as!uint;
        for(uint i = 0; i < max; i++) {
            res ~= helper(dim[1..$]);
        }
        return Atom(res);
    }
    return helper(dim);
}

void setFill(T, N)(ref T[] arr, N index) {
    if(index >= arr.length) arr.length = index + 1;
}

Atom[][] matrixFor(Atom[] a) {
    return a.map!(e => e.match!(
        (Atom[] a) => a,
        _ => assert(0, "Cannot convert to matrix")
    )).array;
}

Atom[][] matrixFor(Atom a) {
    return a.match!(
        (Atom[] a) => matrixFor(a),
        _ => assert(0, "Cannot convert to array")
    );
}

Atom[] duplicateEach(T)(Atom[] arr, T by) {
    Atom[] res;
    foreach(el; arr) {
        foreach(i; by.iota) {
            res ~= el;
        }
    }
    return res;
}

T[] rotate(T, S)(T[] arr, S modBy) {
    if(arr.empty) {
        return [];
    }
    T[] res;
    uint by = moldIndex(modBy, arr.length);
    res ~= arr[by..$];
    res ~= arr[0..by];
    return res;
}

Atom blankFor(Atom a) {
    return a.match!(
        (Duration d) => Atom(d - d),
        (BigInt b) => Atom(b - b),
        (bool b) => Atom(false),
        (Infinity i) => Atom(0.0),
        (real r) => Atom(0.0),
        (string s) => Atom(" "),
        (Atom[] a) => a.length ? blankFor(a[0]) : Atom(BigInt(0)),
        (AVHash h) { AVHash r; return Atom(r); },
        (Nil n) => Nil.nilAtom,
    );
}

Atom[] padLeftInfer(Atom[] arr, Atom by) {
    Atom padWith = blankFor(atomFor(arr));
    uint max = by.as!uint;
    while(arr.length < max) {
        arr = [padWith] ~ arr;
    }
    return arr;
}

Atom[] padRightInfer(Atom[] arr, Atom by) {
    Atom padWith = blankFor(atomFor(arr));
    uint max = by.as!uint;
    while(arr.length < max) {
        arr ~= padWith;
    }
    return arr;
}

Atom[] multisetDifference(Atom[] as, Atom[] bs) {
    import std.bitmanip;
    BitArray amask, bmask;
    amask.length = as.length;
    bmask.length = bs.length;

    foreach(i, a; as) {
        foreach(j, b; bs) {
            if(a == b && !bmask[j]) {
                bmask[j] = amask[i] = true;
            }
        }
    }

    Atom[] res;
    res.length = amask.length - amask.count;
    uint i = 0;
    foreach(j, a; as) {
        if(!amask[j]) {
            res[i++] = a;
        }
    }
    
    return res;
}

Atom generate(Verb v, Atom a) {
    if(v.markedArity <= 1) {
        return generate(v, Nil.nilAtom, a);
    }
    else {
        return generate(v, a, Atom(BigInt(1)));
    }
}

Atom generate(Verb v, Atom x, Atom n) {
    Atom[] args = [Atom(BigInt(0))];
    if(v.markedArity >= 2) {
        args ~= x;
    }
    BigInt count = n.as!BigInt;
    while(count > 0) {
        if(v(args).truthiness) {
            count--;
        }
        if(count > 0) {
            args[0] = args[0].increment();
        }
    }
    return args[0];
}

Atom[] slicesOf(N)(Verb v, N a, Atom[] arr) {
    import std.math.rounding;
    bool discrete = a < 0;
    uint n = (discrete ? -a : a).to!uint;
    if(arr.length < n) {
        return [];
    }
    if(discrete) {
        uint size = 
            ceil(1.0 * arr.length / n).to!uint;
        return iota(size)
            .map!(i => i * n)
            .map!(i => arr[i..min($, i + n)])
            .map!Atom
            .map!v
            .array;
    }
    else {
        return iota(arr.length + 1 - n)
            .map!(i => arr[i..i + n])
            .map!Atom
            .map!v
            .array;
    }
}

Atom[] mapVerb(Verb v, Atom[] arr) {
    return v.isGerund
        ? arr.enumerate()
            .map!(t => v.gerund(t.index, t.value))
            .array
        : arr.map!v.array;
}

bool[] nubSieve(T)(T arr) {
    bool[] res;
    bool[typeof(arr.front)] unseen;
    foreach(e; arr) {
        if(e in unseen) {
            res ~= false;
        }
        else {
            res ~= unseen[e] = true;
        }
    }
    return res;
}

auto grade(alias Compare="a < b", T)(T[] arr) {
    alias fn = binaryFun!Compare;
    auto inds = arr.length.iota.array;
    inds.sort!((i, j) => fn(arr[i], arr[j]));
    return inds;
}

alias gradeUp = grade;
auto gradeDown(T)(T arr) {
    return arr.grade!"a > b";
}
