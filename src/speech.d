module myby.speech;

import std.algorithm.comparison;
import std.algorithm.iteration;
import std.algorithm.searching;
import std.algorithm.sorting;
import std.array;
import std.bigint;
import std.conv : to;
import std.range;
import std.sumtype;

import myby.debugger;
import myby.nibble;
import myby.manip;

class Nil {
    this() {
        
    }
    
    override string toString() {
        return "nil";
    }
    
    override bool opEquals(Object o) {
        // all Nils are equal
        Nil test = cast(Nil) o;
        return test !is null;
    }

    bool opEquals(T)(T o) {
        // only the Nil class can possibly be equal to a Nil
        return false;
    }
    
    static Nil nil() {
        static Nil n;
        
        if(!n) n = new Nil();
        
        return n;
    }
    
    static Atom nilAtom() {
        static Atom na;
        static bool initialized = false;
        
        if(!initialized) {
            na = Atom(nil);
            initialized = true;
        }
        
        return na;
    }
}

// this might be painful to integrate at this stage, but is necessary
// for identities such as lesser of
class Infinity {
    bool isPositive;
    this(bool p) {
        isPositive = p;
    }
    
    override string toString() {
        return isPositive ? "∞" : "-∞";
    }
    
    override int opCmp(Object o) {
        Infinity test = cast(Infinity) o;
        if(test is null) {
            return isPositive ? 1 : -1;
        }
        else {
            return isPositive == test.isPositive ? 0 : isPositive ? 1 : -1;
        }
    }
    
    int opCmp(T)(T o) {
        return isPositive ? 1 : -1;
    }
    
    override bool opEquals(Object o) {
        return opCmp(o) == 0;
    }

    bool opEquals(T)(T o) {
        return opCmp(o) == 0;
    }
    
    static Infinity positive() {
        static Infinity pos;
        
        if(!pos) pos = new Infinity(true);
        
        return pos;
    }
    static Infinity negative() {
        static Infinity neg;
        
        if(!neg) neg = new Infinity(false);
        
        return neg;
    }
    
    static Atom positiveAtom() {
        static Atom pos;
        static bool initialized = false;
        
        if(!initialized) {
            pos = Atom(positive);
            initialized = true;
        }
        
        return pos;
    }
    static Atom negativeAtom() {
        static Atom neg;
        static bool initialized = false;
        
        if(!initialized) {
            neg = Atom(negative);
            initialized = true;
        }
        
        return neg;
    }
}

alias _AtomValue = SumType!(Nil, BigInt, real, Infinity, string, bool, Atom[]);
string readableTypeName(_AtomValue value) {
    return value.match!(
        (Nil _) => "nil",
        (bool _) => "bool",
        (real _) => "real",
        (BigInt _) => "int",
        (Infinity _) => "inf",
        (string _) => "str",
        (Atom[] _) => "arr",
    );
}
string readableTypeName(T)(T value) {
    return readableTypeName(atomFor(value));
}
string readableTypeName(T, S)(T a, S b) {
    return readableTypeName(a) ~ " and " ~ readableTypeName(b);
}
struct Atom {
    _AtomValue value;
    this(T)(T v) {
        value = v;
    }
    
    ref Atom opAssign(T)(T rhs) {
        value = rhs;
        return this;
    }
    
    bool isType(Type)() {
        return value.match!(
            (Type _) => true,
            _ => false,
        );
    }
    
    bool isNumeric() {
        return value.match!(
            (bool _) => true,
            (real _) => true,
            (BigInt _) => true,
            (Infinity _) => true,
            _ => false,
        );
    }
    
    real as(Type)() if(is(Type == real)) {
        return value.match!(
            (a) => cast(real) a,
            // _ => 0.0,
            (a) => assert(0, "Cannot convert " ~ readableTypeName(a) ~ " to " ~ typeid(Type).toString()),
        );
    }
    
    enum mathOps = ["+", "-", "/", "*", "%", "^^"];
    Atom opBinary(string op)(Atom rhs)
    if(mathOps.canFind(op)) {
        if(isNumeric && rhs.isNumeric) {
            // real casts all args to real
            if(isType!real || rhs.isType!real) {
                double a = this.as!real;
                double b = rhs.as!real;
                return Atom(mixin("a " ~ op ~ " b"));
            }
        }
        return match!(
            (a, b) => atomFor(mixin("a " ~ op ~ " b")),
            (_1, _2) => binaryFallback!op(rhs),
        )(this, rhs);
    }
    
    Atom binaryFallback(string op : "+")(Atom rhs) {
        return match!(
            (string a, string b) => Atom(a ~ b),
            (_1, _2) => Nil.nilAtom,
        )(this, rhs);
    }
    Atom binaryFallback(string op : "*")(Atom rhs) {
        return match!(
            (Atom[] a, string b) => Atom(a.map!(to!string).join(b)),
            (_1, _2) => Nil.nilAtom,
        )(this, rhs);
    }
    Atom binaryFallback(string op : "/")(Atom rhs) {
        return match!(
            // Chunk
            (Atom[] a, BigInt b) =>
                Atom(a.chunks(to!size_t(b))
                .map!Atom
                .array),
            (string a, BigInt b) =>
                Atom(a.atomChars) / rhs,
            // Split on
            (string a, string b) =>
                Atom(a.split(b).map!Atom.array),
            (_1, _2) => Nil.nilAtom,
        )(this, rhs);
    }
    Atom binaryFallback(string op : "^^")(Atom rhs) {
        return match!(
            (BigInt a, BigInt b) => Atom(pow(a, b)),
            (_1, _2) => Nil.nilAtom,
        )(this, rhs);
    }
    Atom binaryFallback(string op : "%")(Atom rhs) {
        return match!(
            // Modulus
            (BigInt a, BigInt b) => Atom(positiveMod(a, b)),
            // Intersection, a la APL
            (Atom[] a, Atom[] b) => Atom(a.filter!(e => b.canFind(e)).array),
            (Atom[] a, b) => Atom(a.filter!(e => e == atomFor(b)).array),
            (_1, _2) => Nil.nilAtom,
        )(this, rhs);
    }
    
    // fall through
    Atom binaryFallback(string op)(Atom rhs) {
        return Nil.nilAtom;
    }
    
    int opCmp(Atom other) {
        return match!(
            (a, b) => a < b ? -1 : a > b ? 1 : 0,
            (a, b) => assert(0, "Cannot compare " ~ readableTypeName(a, b)),
        )(value, other.value);
    }
    
    bool opEquals(Atom other) {
        return match!(
            (a, b) => a == b,
            // if a == b does not compile for a and b, then they cannot be equal
            (_1, _2) => false,
        )(value, other.value);
    }
    
    // trick learned from https://stackoverflow.com/a/73351663/4119004
    alias value this;
}

alias VerbMonad = Atom delegate(Atom);
alias VerbDyad = Atom delegate(Atom, Atom);
alias AdjectiveMonad = Verb delegate(Verb);
alias ConjunctionDyad = Verb delegate(Verb, Verb);
alias MultiConjunctionFunction = Verb delegate(Verb[]);

class Verb {
    string display;
    // TODO: display niladic as repr (e.g. "asdf" not asdf)
    VerbMonad monad;
    VerbDyad dyad;
    
    uint markedArity = 2;
    bool niladic = false;
    BigInt rangeStart = BigInt(0);
    Atom identity;
    Verb[] children;
    
    this(string di) {
        display = di;
        identity = Nil.nilAtom;
    }
    
    string head() {
        return display;
    }
    
    Verb setMonad(VerbMonad m) {
        monad = m;
        return this;
    }
    
    Verb setDyad(VerbDyad d) {
        dyad = d;
        return this;
    }
    
    Verb setChildren(Verb[] c) {
        children = c;
        return this;
    }
    
    @property bool initialized() { return monad && dyad; }
    
    Verb setMarkedArity(uint ma) {
        markedArity = ma;
        return this;
    }
    Verb setNiladic(bool n) {
        niladic = n;
        return this;
    }
    Verb setIdentity(Atom i) {
        identity = i;//todo: clone?
        return this;
    }
    Verb setRangeStart(BigInt rs) {
        rangeStart = rs;
        return this;
    }
    
    Atom evaluate() {
        assert(initialized, "Cannot call uninitialized Verb " ~ display);
        return monad(Nil.nilAtom);
    }
    
    Atom evaluate(Atom a) {
        assert(initialized, "Cannot call uninitialized Verb " ~ display);
        return monad(a);
    }
    Atom evaluate(T)(T a)
    if(!is(T == Atom)) {
        return evaluate(Atom(a));
    }
    
    Atom evaluate(Atom l, Atom r) {
        assert(initialized, "Cannot call uninitialized Verb " ~ display);
        return dyad(l, r);
    }
    Atom evaluate(T, S)(T l, S r)
    if(!is(T == Atom) || !is(S == Atom)) {
        return evaluate(atomFor(l), atomFor(r));
    }
    
    Atom evaluate(Atom[] arguments) {
        switch(arguments.length) {
            case 0:
                return evaluate();
            case 1:
                return evaluate(arguments[0]);
            case 2:
                return evaluate(arguments[0], arguments[1]);
            default:
                import std.stdio;
                import myby.format;
                writeln("Problem verb:\n", treeToBoxedString(this));
                writeln(arguments);
                assert(0, "no such argument arity " ~ to!string(arguments.length));
        }
    }
    
    Atom opCall(T...)(T args) {
        return evaluate(args);
    }
    
    override string toString() {
        if(niladic) {
            return "VerbNilad(" ~ display ~ ")";
        }
        else {
            return "Verb(" ~ display ~ ")";
        }
    }
    
    static Verb nilad(Atom constant) {
        return new Verb(to!string(constant))
            .setMonad(_ => constant)
            .setDyad((_1, _2) => constant)
            .setNiladic(true);
    }
    
    static Verb fork(Verb f, Verb g, Verb h) {
        return new Verb("Ψ")
            .setMonad(a => g(f(a), h(a)))
            .setDyad((a, b) => g(f(a, b), h(a, b)))
            .setMarkedArity(f.niladic || h.niladic ? 1 : 2)
            .setChildren([f, g, h]);
    }
    
    static Verb nilad(T)(T t) {
        return Verb.nilad(Atom(t));
    }
}

class Adjective {
    AdjectiveMonad transformer;
    this(AdjectiveMonad t) {
        transformer = t;
    }
    
    Verb transform(Verb v) {
        return transformer(v);
    }
}

class Conjunction {
    ConjunctionDyad transformer;
    this(ConjunctionDyad t) {
        transformer = t;
    }
    
    Verb transform(Verb l, Verb r) {
        return transformer(l, r);
    }
}

class MultiConjunction {
    MultiConjunctionFunction transformer;
    uint valence;
    // valence 0 greedily consumes all verbs on stack
    this(uint v, MultiConjunctionFunction t) {
        valence = v;
        transformer = t;
    }
    
    Verb transform(Verb[] verbs) {
        if(valence != 0) {
            assert(verbs.length == valence, "Unexpected verb valence");
        }
        return transformer(verbs);
    }
}

// helper functions for deciding atoms
Atom atomFor(T)(T a) {
    static if(is(T == Atom)) {
        return a;
    }
    else {
        return Atom(a);
    }
}

bool isArray(Atom a) {
    return a.match!(
        (Atom[] x) => true,
        _ => false
    );
}

bool is2DArray(Atom[] x) {
    return x.all!isArray;
}

string arrayToString(Atom[] x, bool forceLinear=false) {
    if(forceLinear || !x.is2DArray) {
        string inner = x.map!(a => a.atomToString(forceLinear))
            .join(", ");
        return '[' ~ inner ~ ']';
    }
    
    // else, handle 2D arrays
    string[][] prepad;
    uint[] columnWidths;
    foreach(row; x) {
        bool success = row.tryMatch!((Atom[] row) {
            string[] prepadRow;
            foreach(i, atom; row) {
                // TODO: reject 2D array with multiline repr
                string repr = atomToString(atom);
                if(repr.canFind('\n')) {
                    return false;
                }
                prepadRow ~= repr;
                if(i == columnWidths.length) {
                    columnWidths ~= repr.length;
                }
                else {
                    columnWidths[i] = max(columnWidths[i], repr.length);
                }
            }
            prepad ~= prepadRow;
            return true;
        });
        if(!success) {
            return arrayToString(x, true);
        }
    }
    foreach(row; prepad) {
        foreach(i, ref cell; row) {
            cell = to!string(cell.padLeft(' ', columnWidths[i]));
        }
    }
    return prepad.map!(a => a.join(" ")).join("\n");
}

string atomToString(Atom a, bool forceLinear=false) {
    return a.match!(
        (Nil x) => x.toString(),
        (Infinity x) => x.toString(),
        (BigInt x) => to!string(x),
        (bool x) => x ? "1b" : "0b",
        (real x) => to!string(x),
        (string x) => x,
        (Atom[] x) => arrayToString(x, forceLinear),
    );
}

bool isNil(T)(T a) {
    return a == Nil.nilAtom;
}

bool truthiness(Atom a) {
    return a.match!(
        (BigInt a) => a != 0,
        a => a.length != 0,
        (bool a) => a,
        (Nil a) => false,
        (Infinity) => true,
    );
}

// TODO: enclose stuff that wouldn't parse (like f@(g@h))
string enclosed(string a) {
    // if(a.canFind(' ')) {
    if(a.length > 1) {
        return '(' ~ a ~ ')';
    }
    else {
        return a;
    }
}
