module myby.speech;

import std.algorithm.comparison;
import std.algorithm.iteration;
import std.algorithm.searching;
import std.algorithm.sorting;
import std.array;
import std.bigint;
import std.conv : to;
import std.datetime;
import std.meta : AliasSeq;
import std.range;
import std.sumtype;

import myby.debugger;
import myby.format;
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
    
    override size_t toHash() const {
        return 0;
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
    
    override size_t toHash() const {
        return isPositive;
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

alias _AtomValue = SumType!(
    Nil, BigInt, real, Duration, Infinity, string, bool, Atom[], This[This]
);
alias AVHash = _AtomValue[_AtomValue];
string readableTypeName(_AtomValue value) {
    return value.match!(
        (Nil _) => "nil",
        (bool _) => "bool",
        (real _) => "real",
        (Duration _) => "dur",
        (BigInt _) => "int",
        (Infinity _) => "inf",
        (string _) => "str",
        (Atom[] _) => "arr",
        (AVHash _) => "hash",
    );
}
string readableTypeName(T)(T value) {
    return readableTypeName(atomFor(value));
}
string readableTypeName(T, S)(T a, S b) {
    return readableTypeName(a) ~ " and " ~ readableTypeName(b);
}

alias exactly(T, alias fun) = function (arg)
{
    static assert(is(typeof(arg) == T));
    return fun(arg);
};

struct Atom {
    _AtomValue value;
    this(T)(T v) {
        value = v;
    }
    this(bool v) {
        value = v;
    }
    this(real v) {
        if(v == real.infinity) {
            value = Infinity.positive;
        }
        else if(v == -real.infinity) {
            value = Infinity.negative;
        }
        else {
            value = v;
        }
    }
    
    ref Atom opAssign(T)(T rhs) {
        value = rhs;
        return this;
    }
    
    bool isType(Type)() {
        return value.match!(
            exactly!(Type, _ => true),
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
    
    real as(Type : real)() {
        return value.match!(
            (a) => cast(real) a,
            (Duration d) {
                // seconds, with fractional seconds
                enum Units = AliasSeq!("seconds", "msecs", "usecs", "hnsecs");
                auto ds = d.split!Units;
                real r = 0;
                static foreach(unit; Units) {
                    r += ds.secondsFraction!unit;
                }
                return r;
            },
            // _ => 0.0,
            (a) => assert(0, "Cannot convert " ~ readableTypeName(a) ~ " to " ~ typeid(Type).toString()),
        );
    }
    
    dchar as(Type : dchar)() {
        return value.match!(
            (a) => cast(dchar) a,
            (a) => assert(0, "Cannot convert " ~ readableTypeName(a) ~ " to " ~ typeid(Type).toString()),
        );
    }
    
    string as(Type : string)() {
        return value.match!(
            (a) => a.toString(),
            (a) => to!string(a),
        );
    }
    
    BigInt as(Type : BigInt)() {
        return value.match!(
            (a) => BigInt(a),
            (bool b) => BigInt(b ? "1" : "0"),
            (a) => assert(0, "Cannot convert " ~ readableTypeName(a) ~ " to " ~ typeid(Type).toString()),
        );
    }
    
    size_t as(Type : size_t)() {
        return value.match!(
            (a) => a.to!size_t,
            (a) => assert(0, "Cannot convert " ~ readableTypeName(a) ~ " to " ~ typeid(Type).toString()),
        );
    }
    
    bool as(Type : bool)() {
        return this.truthiness;
    }
    
    Atom opBinary(string op, T)(T rhs)
    if(!is(T == Atom) && op != "in") {
        return opBinary!op(Atom(rhs));
    }
    
    Atom increment() {
        return value.match!(
            (a) => Atom(a + cast(typeof(a))1),
            // behead
            (a) => Atom(a[1..$]),
            _ => Nil.nilAtom,
        );
    }
    
    Atom decrement() {
        return value.match!(
            (a) => Atom(a - cast(typeof(a))1),
            // betail
            (a) => Atom(a[0..$-1]),
            _ => Nil.nilAtom,
        );
    }
    
    alias IntegralTypes = AliasSeq!(real, BigInt, bool);
    
    enum mathOps = ["+", "-", "/", "*", "%", "^^"];
    Atom opBinary(string op)(Atom rhs)
    if(mathOps.canFind(op)) {
        if(isNumeric && rhs.isNumeric) {
            // real casts all args to real
            static foreach(Type; IntegralTypes) {
                if(isType!Type || rhs.isType!Type
                || op == "/" && is(Type == real) && this % rhs != Atom(0)) {
                    Type a = this.as!Type;
                    Type b = rhs.as!Type;
                    static if(op == "%") {
                        return Atom(positiveMod(a, b));
                    }
                    // TODO: what an ugly hack.
                    else static if(!is(Type == BigInt) || op != "^^") {
                        return Atom(mixin("a " ~ op ~ " b"));
                    }
                }
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
            (Atom[] a, Atom[] b) => Atom(a ~ b),
            (string a, b) => Atom(a ~ rhs.atomToString),
            (a, string b) => Atom(value.atomToString ~ b),
            (_1, _2) => Nil.nilAtom,
        )(this, rhs);
    }
    Atom binaryFallback(string op : "-")(Atom rhs) {
        return match!(
            // setwise difference
            (Atom[] a, Atom[] b) => Atom(
                a.filter!(e => !b.canFind(e)).array
            ),
            // remove from
            (Atom[] a, b) => Atom(
                a.filter!(e => e != atomFor(b)).array
            ),
            (a, Atom[] b) => Atom(
                b.filter!(e => e != atomFor(a)).array
            ),
            (_1, _2) => Nil.nilAtom,
        )(this, rhs);
    }
    Atom binaryFallback(string op : "*")(Atom rhs) {
        return match!(
            (Atom[] a, string b) => Atom(a.map!(to!string).join(b)),
            (string b, Atom[] a) => Atom(a.map!(to!string).join(b)),
            (string a, n) => Atom(a.repeat(rhs.as!size_t).joinToString),
            (n, string a) => Atom(a.repeat(this.as!size_t).joinToString),
            (_1, _2) => Nil.nilAtom,
        )(this, rhs);
    }
    Atom binaryFallback(string op : "/")(Atom rhs) {
        return match!(
            // Chunk
            (Atom[] a, b) =>
                Atom(a.chunks(to!size_t(b))
                .map!Atom
                .array),
            (string a, b) {
                static assert(!is(typeof(b) == string));
                return Atom(a.atomChars) / Atom(b);
            },
            // Split on
            (string a, string b) =>
                Atom(a.split(b).map!Atom.array),
            (_1, _2) => Nil.nilAtom,
        )(this, rhs);
    }
    Atom binaryFallback(string op : "^^")(Atom rhs) {
        import std.algorithm.searching : countUntil;
        return match!(
            (BigInt a, BigInt b) => Atom(pow(a, b)),
            // index of 
            (Atom[] a, b) => Atom(BigInt(a.countUntil(atomFor(b)))),
            (string a, string b) => Atom(BigInt(a.countUntil(b))),
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
        Debugger.print("Operator fallback not implemented: " ~ op);
        return Nil.nilAtom;
    }
    
    Atom linkWith(Atom o) {
        return Atom(o.match!(
            (Atom[] arr) => [this] ~ arr,
            _ => [this, o]
        ));
    }
    
    int opCmp(Atom other) {
        int relComp(S, T)(S a, T b) {
            return a < b ? -1 : a > b ? 1 : 0;
        }
        static foreach(Type; IntegralTypes) {
            if(isType!Type && other.isNumeric
            || other.isType!Type && isNumeric) {
                Type a = this.as!Type;
                Type b = other.as!Type;
                return relComp(a, b);
            }
        }
        return match!(
            (a, b) => relComp(a, b),
            (a, b) => assert(0, "Cannot compare " ~ readableTypeName(a, b)),
        )(value, other.value);
    }
    
    bool opEquals(Atom other) {
        import core.exception : AssertError;
        return match!(
            (a, b) => a == b,
            (a, b) {
                try {
                    return this.opCmp(other) == 0;
                }
                catch(AssertError) {
                    // if no comparison features succeed, they cannot be equal
                    assert(0, "Cannot compare " ~ readableTypeName(a, b));
                }
            },
        )(value, other.value);
    }
    
    // below two methods for hashes
    bool opEquals(ref const Atom other) const {
        return match!(
            (a, b) => a == b,
            (_1, _2) => false,
        )(value, other.value);
    }
    
    size_t toHash() const nothrow @safe {
        return value.match!(
            a => a.toHash(),
            (real r) => r.hashOf(),
            (string s) => s.hashOf(),
            (Duration d) => d.toString().hashOf(),
            (const Atom[] a) => a.map!"a.toHash".sum,
            (const _AtomValue[const _AtomValue] h) =>
                h.keys.map!"a.toHash".sum + h.values.map!"a.toHash".sum,
        );
    }
    
    // trick learned from https://stackoverflow.com/a/73351663/4119004
    alias value this;
}

alias VerbMonadSimple = Atom delegate(Atom);
alias VerbMonadSelf = Atom delegate(Verb, Atom);
alias VerbMonadConjunction = Atom delegate(Verb, Verb, Atom);
alias VerbMonadMultiConjunction = Atom delegate(Verb[], Atom);
alias VerbMonad = SumType!(
    VerbMonadSimple, VerbMonadSelf, VerbMonadConjunction, VerbMonadMultiConjunction
);

alias VerbDyadSimple = Atom delegate(Atom, Atom);
alias VerbDyadSelf = Atom delegate(Verb, Atom, Atom);
alias VerbDyadConjunction = Atom delegate(Verb, Verb, Atom, Atom);
alias VerbDyadMultiConjunction = Atom delegate(Verb[], Atom, Atom);
alias VerbDyad = SumType!(
    VerbDyadSimple, VerbDyadSelf, VerbDyadConjunction, VerbDyadMultiConjunction
);

alias AdjectiveMonad = Verb delegate(Verb);
alias ConjunctionDyad = Verb delegate(Verb, Verb);
alias MultiConjunctionFunction = Verb delegate(Verb[]);

struct ChainInfo {
    size_t index;
    Verb last;
    Verb next;
    Verb self;
    Verb[] chains;
    
    this(T)(T index, Verb[] chains) {
        assert(index < chains.length, "Must be constructed from an existing chain");
        this.index = index;
        // TODO: circular?
        if(index > 0) {
            last = chains[index - 1];
        }
        self = chains[index];
        if(index + 1 < chains.length) {
            next = chains[index + 1];
        }
        this.chains = chains;
    }
}

class Verb {
    //!!!! NOTE: ADD ANY PROPERTY ADDED TO .dup !!!!
    string display;
    // TODO: display niladic as repr (e.g. "asdf" not asdf)
    VerbMonad monad;
    VerbDyad dyad;
    VerbDyadSelf dyadSelf;
    Verb inverse; // TODO: figure this out idfk
    ChainInfo info;
    
    uint markedArity = 2;
    bool niladic = false;
    bool inferSelf = true;
    bool hasIdentityFn = false;
    bool isGerund = false;
    Atom rangeStart = BigInt(0);
    Atom identity;
    VerbMonad identityFn;
    Verb[] children;
    //!!!! NOTE: ADD ANY PROPERTY ADDED TO .dup !!!!
    
    this(string di) {
        display = di;
        identity = Nil.nilAtom;
    }
    
    Verb dup() {
        Verb res = new Verb(display);
        res.monad = monad;
        res.dyad = dyad;
        res.dyadSelf = dyadSelf;
        res.inverse = inverse;
        res.info = info;
        res.niladic = niladic;
        res.inferSelf = inferSelf;
        res.markedArity = markedArity;
        res.hasIdentityFn = hasIdentityFn;
        res.isGerund = isGerund;
        res.rangeStart = rangeStart;
        res.identity = identity;
        res.identityFn = identityFn;
        // TODO: this might need to be called recursively
        res.children = children.map!(a => a.dup).array;
        // res.setChains(info);
        return res;
    }
    
    @property Verb f() {
        return children[0];
    }
    
    @property Verb g() {
        return children[1];
    }
    
    @property Verb h() {
        return children[2];
    }
    
    void setChains(ChainInfo i) {
        if(info == i) {
            Debugger.print("Already set info.");
            return;
        }
        Debugger.print("Setting ", display, " info:");
        Debugger.print("  Info: ", i);
        info = i;
        foreach(ref v; children) {
            Debugger.print("Child ", v.display, ":");
            v.setChains(i);
        }
        if(inverse) {
            inverse.setChains(i);
        }
    }
    
    string treeDisplay() {
        return treeToBoxedString(this);
    }
    
    string postDisplay() {
        return display[0] == ':' || display[0] == '.' ? ' ' ~ display : display;
    }
    
    string inlineDisplay() {
        switch(children.length) {
            case 0:
                return display;
            case 1:
                return children[0].inlineDisplay ~ postDisplay;
            case 2:
                return children[0].inlineDisplay ~ postDisplay ~ children[1].inlineDisplay;
            default:
                return children.map!(a => a.inlineDisplay).join(" ") ~ display;
        }
    }
    
    bool invertable() {
        return inverse !is null;
    }
    
    string head() {
        return display;
    }
    
    Verb setGerund(bool g) {
        isGerund = g;
        return this;
    }
    
    // Note: Below cannot be setMonad(T)(T m)
    // I'm not sure why, something to do with the fact that
    // the arguments are deduced to be functions.
    // This fact cannot be fixed by an appropriate call to
    // toDelegate, and I'm also not sure why.
    // Also applies to setDyad
    Verb setMonad(VerbMonadSimple m) {
        monad = m;
        return this;
    }
    
    Verb setMonad(VerbMonadSelf m) {
        monad = m;
        inferSelf = true;
        return this;
    }
    
    Verb setMonadSelf(VerbMonadSelf m) {
        monad = m;
        inferSelf = false;
        return this;
    }
    
    Verb setMonad(VerbMonadConjunction m) {
        monad = m;
        return this;
    }
    
    Verb setMonad(VerbMonadMultiConjunction m) {
        monad = m;
        return this;
    }
    
    Verb setDyad(VerbDyadSimple d) {
        dyad = d;
        return this;
    }
    
    Verb setDyad(VerbDyadSelf d) {
        dyad = d;
        return this;
    }
    
    Verb setDyad(VerbDyadConjunction d) {
        dyad = d;
        return this;
    }
    
    Verb setDyad(VerbDyadMultiConjunction d) {
        dyad = d;
        return this;
    }
    
    Verb setInverse(Verb i) {
        inverse = i;
        return this;
    }
    
    Verb setInverseMutual(Verb i) {
        inverse = i;
        i.inverse = this;
        return this;
    }
    
    Verb setChildren(Verb[] c) {
        children = c;
        return this;
    }
    
    @property bool initialized() {
        return monad.match!(v => v !is null)
            && dyad.match!(v => v !is null);
    }
    
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
        hasIdentityFn = false;
        return this;
    }
    Verb setIdentity(VerbMonadSimple vms) {
        identityFn = vms;
        hasIdentityFn = true;
        return this;
    }
    Verb setRangeStart(T)(T rs) {
        rangeStart = rs;
        return this;
    }
    
    Verb invert() {
        assert(invertable(), "Cannot invert " ~ display);
        // return inverse;
        // /*
        return new Verb("!.")
            .setMonad((Verb v, a) => v.inverse(a))
            .setDyad((Verb v, a, b) => v.inverse(a, b))
            .setInverse(this)
            .setMarkedArity(1)
            .setNiladic(niladic)
            .setChildren([this]);
        // */
    }
    
    Atom executeMonadic(VerbMonad m, Atom a) {
        return m.match!(
            f => f(children, a),
            f => f(children[0], children[1], a),
            f => children.length && inferSelf
                ? f(children[0], a)
                : f(this, a),
            f => f(a)
        );
    }
    
    Atom getIdentity(Atom a) {
        if(isGerund) {
            return children[0].getIdentity(a);
        }
        else if(hasIdentityFn) {
            return executeMonadic(identityFn, a);
        }
        else {
            return identity;
        }
    }
    
    Atom getIdentity(T)(T arr) {
        return getIdentity(arr.empty ? Nil.nilAtom : arr.front);
    }
    
    Atom monadic(Atom a) {
        return executeMonadic(monad, a);
    }
    
    Atom dyadic(Atom a, Atom b) {
        return dyad.match!(
            f => f(children, a, b),
            f => f(children[0], children[1], a, b),
            f => children.length && inferSelf
                ? f(children[0], a, b)
                : f(this, a, b),
            f => f(a, b)
        );
    }
    
    Atom evaluate() {
        assert(initialized, "Cannot call uninitialized Verb " ~ display);
        Debugger.print();
        Debugger.print("Calling ", inlineDisplay);
        Debugger.print("with 0 args: nil");
        return monadic(Nil.nilAtom);
    }
    
    Atom evaluate(Atom a) {
        assert(initialized, "Cannot call uninitialized Verb " ~ display);
        Debugger.print();
        Debugger.print("Calling ", inlineDisplay);
        Debugger.print("with 1 arg: ", a, "(", a.readableTypeName, ")");
        return monadic(a);
    }
    Atom evaluate(T)(T a)
    if(!is(T == Atom)) {
        return evaluate(Atom(a));
    }
    
    Atom evaluate(Atom l, Atom r) {
        assert(initialized, "Cannot call uninitialized Verb " ~ display);
        Debugger.print();
        Debugger.print("Calling ", inlineDisplay);
        Debugger.print("with 2 args: ", l, "(", l.readableTypeName, ") and ", r, "(", r.readableTypeName, ")");
        return dyadic(l, r);
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
    
    Atom gerund(T...)(uint index, T arguments) {
        index %= children.length;
        return children[index](arguments);
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
        auto res = new Verb(to!string(constant))
            .setMonad(_ => constant)
            .setDyad((_1, _2) => constant)
            .setNiladic(true);
        res.setInverse(res);
        return res;
    }
    
    static Verb fork(Verb f, Verb g, Verb h) {
        return new Verb("Ψ")
            .setMonad((Verb[] verbs, a) {
                Verb f = verbs[0];
                Verb g = verbs[1];
                Verb h = verbs[2];
                return g(f(a), h(a));
            })
            .setDyad((Verb[] verbs, a, b) {
                // TODO: use markedArity for calls to f/h?
                Verb f = verbs[0];
                Verb g = verbs[1];
                Verb h = verbs[2];
                return g(f(a, b), h(a, b));
            })
            .setMarkedArity(f.niladic || h.niladic || (f.markedArity == 1 && h.markedArity == 1) ? 1 : 2)
            .setNiladic(f.niladic && h.niladic || g.niladic)
            .setChildren([f, g, h]);
    }
    
    static Verb nilad(T)(T t) {
        return Verb.nilad(Atom(t));
    }
    
    @property static Verb unimplemented() {
        Verb un;
        if(!un) {
            enum msg = "Unimplemented behavior";
            un = new Verb("!unimplemented!")
                .setMonad(a => assert(0, msg))
                .setDyad((a, b) => assert(0, msg))
                .setMarkedArity(1);
            un.setInverse(un);
        }
        return un;
    }
    
    static Verb gerund(Verb f, Verb g) {
        Verb[] nextChildren;
        if(f.isGerund) {
            nextChildren ~= f.children;
        }
        else {
            nextChildren ~= f;
        }
        if(g.isGerund) {
            nextChildren ~= g.children;
        }
        else {
            nextChildren ~= g;
        }
        return new Verb(":")
            .setMonad((Verb[] verbs, a) =>
                Atom(verbs.map!(v => v(a)).array)
            )
            .setDyad((Verb[] verbs, x, y) =>
                Atom(verbs.map!(v => v(x, y)).array)
            )
            .setMarkedArity(2)
            .setChildren(nextChildren)
            .setRangeStart(nextChildren[0].rangeStart)
            .setGerund(true);
    }
    
    static Verb compose(Verb f, Verb g) {
        if(f.isGerund) {
            return f.dup
                .setChildren(f.children.map!(child => Verb.compose(child, g)).array);
        }
        else if(g.isGerund) {
            return g.dup
                .setChildren(g.children.map!(child => Verb.compose(f, child)).array);
        }
        return new Verb("@")
            .setMonad((f, g, a) => f(g(a)))
            .setDyad((f, g, a, b) => f(g(a, b)))
            .setMarkedArity(g.markedArity)
            .setNiladic(f.niladic || g.niladic)
            .setInverse(new Verb("!.")
                // (f@g)!. <=> g!.@(f!.)
                .setMonad((f, g, a) {
                    auto gInv = g.invert();
                    auto fInv = f.invert();
                    return gInv(fInv(a));
                })
                .setDyad((f, g, _1, _2) => Nil.nilAtom)
                .setMarkedArity(g.markedArity)
                .setChildren([f, g])
            )
            .setChildren([f, g]);
    }
    
    static Verb power(Verb f, Verb g) {
        return new Verb("^:")
            .setMonad((f, g, a) {
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
            .setDyad((f, g, _1, _2) => Nil.nilAtom)
            .setMarkedArity(1)
            .setChildren([f, g]);
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
        Verb result = transformer(l, r);
        //todo: assert correct monad/dyad
        // assert(result.monad.match!(), "Must have a conjunction monad handler");
        return result;
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

// TODO: assert array rows do not consist of arrays
bool is2DArray(Atom[] x) {
    return x.all!isArray;
}

string arrayToString(Atom[] x, bool forceLinear=false) {
    if(forceLinear || !x.is2DArray) {
        string inner = x.map!(a => a.atomToString(true))
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

string hashToString(AVHash x) {
    return "[" ~ x.keys.map!(key =>
        Atom(key).atomToString() ~ ": " ~ Atom(x[key]).atomToString()
    ).join(", ") ~ "]";
}

string atomToString(_AtomValue a, bool forceLinear=false) {
    return a.match!(
        (Nil x) => x.toString(),
        (Infinity x) => x.toString(),
        (BigInt x) => to!string(x),
        (bool x) => x ? "1b" : "0b",
        (real x) => to!string(x),
        (Duration x) => x.toString(),
        (string x) => x,
        (Atom[] x) => arrayToString(x, forceLinear),
        (AVHash x) => hashToString(x),
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
