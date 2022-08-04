module myby.instructions;

import std.typecons;
import std.sumtype;
import std.bigint;
import std.range;
import std.algorithm.iteration;
import std.algorithm.searching;
import std.conv : to;

import myby.nibble;

enum InsName {
    Integer,        //0
    String,         //1
    Filter,         //2
    Map,            //3
    Add,            //4
    Subtract,       //5
    Multiply,       //6
    Divide,         //7
    Exponentiate,   //8
    Identity,       //9
    Bond,           //A
    OpenParen,      //B
    CloseParen,     //C
    Compose,        //D
    Range,          //E
    Modulus,        //F0
    FirstChain,     //F10
    SecondChain,    //F11
    ThirdChain,     //F12
    FourthChain,    //F13
    NthChain,       //F14
    GreaterEqual,   //F15
    LessEqual,      //F16
    Print,          //F1E
    Pair,           //F2
    Binomial,       //F3
    Equality,       //F4
    LessThan,       //F5
    GreaterThan,    //F6
    ArityForce,     //F7
    First,          //F8
    Last,           //F9
    OnLeft,         //FA
    OnRight,        //FB
    SplitCompose,   //FC
    Reflex,         //FD
    Exit,           //FE00
    Break,          //FF
}

// + -> [4] -> Add

enum Nibble[][string] InstructionMap = [
    "\\": [0x2],
    "\"": [0x3],
    "+": [0x4],
    "-": [0x5],
    "*": [0x6],
    "/": [0x7],
    "^": [0x8],
    "#": [0x9],
    "&": [0xA],
    "(": [0xB],
    ")": [0xC],
    "@": [0xD],
    "R": [0xE],
    "%": [0xF, 0x0],
    "$": [0xF, 0x1, 0x0],
    "$1": [0xF, 0x1, 0x0],
    "$2": [0xF, 0x1, 0x1],
    "$3": [0xF, 0x1, 0x2],
    "$4": [0xF, 0x1, 0x3],
    "$N": [0xF, 0x1, 0x4],
    "<:": [0xF, 0x1, 0x5],
    ">:": [0xF, 0x1, 0x6],
    //...
    "p.": [0xF, 0x1, 0xE],
    ";": [0xF, 0x2],
    "!": [0xF, 0x3],
    "=": [0xF, 0x4],
    "<": [0xF, 0x5],
    ">": [0xF, 0x6],
    "`": [0xF, 0x7],
    "{": [0xF, 0x8],
    "}": [0xF, 0x9],
    "[": [0xF, 0xA],
    "]": [0xF, 0xB],
    "O": [0xF, 0xC],
    "~": [0xF, 0xD],
    "x:": [0xF, 0xE, 0x0, 0x0],
    "\n": [0xF, 0xF],
];
enum SpeechPart { Verb, Adjective, Conjunction, MultiConjunction, Syntax }

alias NameInfo = Tuple!(SpeechPart, "speech", InsName, "name");

enum NameInfo[int] NameMap = [
    0x0:    NameInfo(SpeechPart.Verb,             InsName.Integer),
    0x1:    NameInfo(SpeechPart.Verb,             InsName.String),
    0x2:    NameInfo(SpeechPart.Adjective,        InsName.Filter),
    0x3:    NameInfo(SpeechPart.Adjective,        InsName.Map),
    0x4:    NameInfo(SpeechPart.Verb,             InsName.Add),
    0x5:    NameInfo(SpeechPart.Verb,             InsName.Subtract),
    0x6:    NameInfo(SpeechPart.Verb,             InsName.Multiply),
    0x7:    NameInfo(SpeechPart.Verb,             InsName.Divide),
    0x8:    NameInfo(SpeechPart.Verb,             InsName.Exponentiate),
    0x9:    NameInfo(SpeechPart.Verb,             InsName.Identity),
    0xA:    NameInfo(SpeechPart.Conjunction,      InsName.Bond),
    0xB:    NameInfo(SpeechPart.Syntax,           InsName.OpenParen),
    0xC:    NameInfo(SpeechPart.Syntax,           InsName.CloseParen),
    0xD:    NameInfo(SpeechPart.Conjunction,      InsName.Compose),
    0xE:    NameInfo(SpeechPart.Verb,             InsName.Range),
    0xF0:   NameInfo(SpeechPart.Verb,             InsName.Modulus),
    0xF10:  NameInfo(SpeechPart.Verb,             InsName.FirstChain),
    0xF11:  NameInfo(SpeechPart.Verb,             InsName.SecondChain),
    0xF12:  NameInfo(SpeechPart.Verb,             InsName.ThirdChain),
    0xF13:  NameInfo(SpeechPart.Verb,             InsName.FourthChain),
    //TODO: should this(v) be a conjunction?
    0xF14:  NameInfo(SpeechPart.Verb,             InsName.NthChain),
    0xF15:  NameInfo(SpeechPart.Verb,             InsName.LessEqual),
    0xF16:  NameInfo(SpeechPart.Verb,             InsName.GreaterEqual),
    0xF1E:  NameInfo(SpeechPart.Verb,             InsName.Print),
    0xF2:   NameInfo(SpeechPart.Verb,             InsName.Pair),
    0xF3:   NameInfo(SpeechPart.Verb,             InsName.Binomial),
    0xF4:   NameInfo(SpeechPart.Verb,             InsName.Equality),
    0xF5:   NameInfo(SpeechPart.Verb,             InsName.LessThan),
    0xF6:   NameInfo(SpeechPart.Verb,             InsName.GreaterThan),
    0xF7:   NameInfo(SpeechPart.Adjective,        InsName.ArityForce),
    0xF8:   NameInfo(SpeechPart.Verb,             InsName.First),
    0xF9:   NameInfo(SpeechPart.Verb,             InsName.Last),
    0xFA:   NameInfo(SpeechPart.Adjective,        InsName.OnLeft),
    0xFB:   NameInfo(SpeechPart.Adjective,        InsName.OnRight),
    0xFC:   NameInfo(SpeechPart.MultiConjunction, InsName.SplitCompose),
    0xFD:   NameInfo(SpeechPart.Adjective,        InsName.Reflex),
    0xFE00: NameInfo(SpeechPart.Verb,             InsName.Exit),
    0xFF:   NameInfo(SpeechPart.Syntax,           InsName.Break),
];

class Nil {
    this() {
        
    }
    
    override string toString() {
        return "nil";
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
alias Atom = SumType!(Nil, BigInt, string, bool, This[]);
alias VerbMonad = Atom delegate(Atom);
alias VerbDyad = Atom delegate(Atom, Atom);
alias AdjectiveMonad = Verb delegate(Verb);
alias ConjunctionDyad = Verb delegate(Verb, Verb);
alias MultiConjunctionFunction = Verb delegate(Verb[]);

bool isNil(T)(T a) {
    return a == Nil.nilAtom;
}

class Verb {
    string display;
    VerbMonad monad;
    VerbDyad dyad;
    
    uint markedArity = 2;
    bool niladic = false;
    BigInt rangeStart = BigInt(0);
    Atom identity;
    
    this(string di) {
        display = di;
        identity = Nil.nilAtom;
    }
    
    Verb setMonad(VerbMonad m) {
        monad = m;
        return this;
    }
    
    Verb setDyad(VerbDyad d) {
        dyad = d;
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
    
    Atom evaluate(Atom l, Atom r) {
        assert(initialized, "Cannot call uninitialized Verb " ~ display);
        return dyad(l, r);
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
                import std.stdio : writeln;
                writeln("no such argument arity ", arguments.length);
                return Nil.nilAtom;
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
        return new Verb(f.display ~ " " ~ g.display ~ " " ~ h.display)
            .setMonad(a => g(f(a), h(a)))
            .setDyad((a, b) => g(f(a, b), h(a, b)))
            .setMarkedArity(f.niladic || h.niladic ? 1 : 2);
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
    Atom[] res;
    foreach(ch; str) {
        res ~= Atom(ch ~ "");
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

bool truthiness(Atom a) {
    return a.match!(
        (BigInt a) => a != 0,
        a => a.length != 0,
        (bool a) => a,
        (Nil a) => false,
    );
}

string enclosed(string a) {
    if(a.canFind(' ')) {
        return '(' ~ a ~ ')';
    }
    else {
        return a;
    }
}

BigInt pow(BigInt a, BigInt b) {
    BigInt res = 1;
    for(BigInt i = 0; i < b; i++) {
        res *= a;
    }
    return a;
}

Atom exit(BigInt code = 0) {
    import core.stdc.stdlib;
    core.stdc.stdlib.exit(to!uint(code));
}

Verb getVerb(InsName name) {
    static Verb[InsName] verbs;
    
    if(!verbs) {
        // TODO: this looks awful. clean it.
        // maybe: setMonad, setDyad?
        
        // Addition
        verbs[InsName.Add] = new Verb("+")
            // Absolute value/Length
            .setMonad((Atom a) => a.match!(
                (BigInt b) => Atom(b < 0 ? -b : b),
                s => Atom(BigInt(s.length)),
                _ => Nil.nilAtom,
            ))
            // Addition
            .setDyad((Atom l, Atom r) => match!(
                (BigInt a, BigInt b) => Atom(a + b),
                (_1, _2) => Nil.nilAtom,
            )(l, r))
            .setMarkedArity(2)
            .setIdentity(Atom(BigInt(0)));
        
        verbs[InsName.Subtract] = new Verb("-")
            // Negate/Reverse
            .setMonad((Atom a) => a.match!(
                (BigInt n) => Atom(-n),
                (Atom[] a) => Atom(a.retro.array),
                _ => Nil.nilAtom,
            ))
            // Subtraction
            .setDyad((Atom l, Atom r) => match!(
                (BigInt a, BigInt b) => Atom(a - b),
                (_1, _2) => Nil.nilAtom,
            )(l, r))
            .setMarkedArity(2);
        
        verbs[InsName.Multiply] = new Verb("*")
            .setMonad((Atom a) => a.match!(
                (Atom[] a) => Atom(flatten(a)),
                _ => Nil.nilAtom,
            ))
            // Multiplication
            .setDyad((Atom l, Atom r) => match!(
                (BigInt a, BigInt b) => Atom(a * b),
                (_1, _2) => Nil.nilAtom,
            )(l, r))
            .setMarkedArity(2)
            .setIdentity(Atom(BigInt(1)))
            .setRangeStart(BigInt(1));
        //TODO: setIdentity per cased function
        
        verbs[InsName.Divide] = new Verb("/")
            .setMonad((Atom a) => Nil.nilAtom)
            // Division
            .setDyad((Atom l, Atom r) => match!(
                (Atom[] a, BigInt b) =>
                    Atom(a.chunks(to!size_t(b))
                    .map!Atom
                    .array),
                (BigInt a, BigInt b) => Atom(a / b),
                (string a, string b) =>
                    Atom(a.split(b).map!Atom.array),
                (_1, _2) => Nil.nilAtom,
            )(l, r))
            .setMarkedArity(2);
        
        verbs[InsName.Exponentiate] = new Verb("^")
            // OneRange
            .setMonad((Atom a) => a.match!(
                (BigInt a) =>
                    Atom(iota(BigInt(1), a + 1).map!Atom.array),
                _ => Nil.nilAtom,
            ))
            // Exponentiation
            .setDyad((Atom l, Atom r) => match!(
                (BigInt a, BigInt b) => Atom(pow(a, b)),
                (_1, _2) => Nil.nilAtom,
            )(l, r))
            .setMarkedArity(2);
        
        // Modulus
        verbs[InsName.Modulus] = new Verb("%")
            .setMonad((Atom a) => Nil.nilAtom)
            .setDyad((Atom l, Atom r) => match!(
                (BigInt a, BigInt b) => Atom(a % b),
                (_1, _2) => Nil.nilAtom,
            )(l, r))
            .setMarkedArity(2);
        
        // Identity/Reshape
        verbs[InsName.Identity] = new Verb("#")
            .setMonad(_ => _)
            .setDyad((a, b) => match!(
                (Atom[] a, BigInt b) => Atom(reshape(a, b)),
                (BigInt a, Atom[] b) => Atom(reshape(b, a)),
                (string a, BigInt b) => Atom(reshape(a.atomChars, b).joinToString),
                (BigInt a, string b) => Atom(reshape(b.atomChars, a).joinToString),
                (_1, _2) => Nil.nilAtom,
            )(a, b))
            .setMarkedArity(1);
        
        // Range (indices)
        verbs[InsName.Range] = new Verb("R")
            .setMonad(a => a.match!(
                (BigInt n) => Atom(
                    n < 0
                        ? iota(-n).map!(a => Atom(-n - 1 - a)).array
                        : iota(n).map!Atom.array
                ),
                _ => Nil.nilAtom
            ))
            .setDyad((l, r) => match!(
                (BigInt a, BigInt b) => Atom(iota(a, b + 1).map!Atom.array),
                (_1, _2) => Nil.nilAtom,
            )(l, r))
            .setMarkedArity(1);
        
        verbs[InsName.Pair] = new Verb(";")
            // Wrap
            .setMonad(a => Atom([a]))
            // Pair
            .setDyad((a, b) => Atom([a, b]))
            .setMarkedArity(2);
        
        verbs[InsName.Binomial] = new Verb("!")
            // Enumerate
            .setMonad(a => a.match!(
                (Atom[] a) =>
                    Atom(a.enumerate()
                    .map!(t => Atom([Atom(BigInt(t[0])), t[1]]))
                    .array),
                _ => Nil.nilAtom,
            ))
            // Binomial
            .setDyad((l, r) => match!(
                (BigInt a, BigInt b) =>
                    Atom(a > b
                        ? BigInt(0)
                        : productOver(iota(a + 2, b + 1)) / productOver(iota(BigInt(1), a + 1))
                    ),
                (_1, _2) => Nil.nilAtom,
            )(l, r))
            .setMarkedArity(2);
        
        verbs[InsName.First] = new Verb("{")
            // First element
            .setMonad(a => a.match!(
                (Atom[] a) => a[0],
                _ => Nil.nilAtom,
            ))
            // Index
            .setDyad((l, r) => match!(
                (Atom[] a, BigInt b) => a[to!uint(b) % a.length],
                (_1, _2) => Nil.nilAtom,
            )(l, r))
            .setMarkedArity(2);
        
        verbs[InsName.Last] = new Verb("}")
            // Last element
            .setMonad(a => a.match!(
                (Atom[] a) => a[$-1],
                _ => Nil.nilAtom,
            ))
            .setDyad((l, r) => match!(
                (_1, _2) => Nil.nilAtom,
            )(l, r))
            .setMarkedArity(1);
        
        verbs[InsName.Equality] = new Verb("=")
            .setMonad(_ => Nil.nilAtom)
            // Equal to
            .setDyad((l, r) => match!(
                (a, b) => Atom(a == b),
                (_1, _2) => Nil.nilAtom,
            )(l, r))
            .setMarkedArity(2);
        
        verbs[InsName.LessThan] = new Verb("<")
            .setMonad(_ => Nil.nilAtom)
            // Less than
            .setDyad((l, r) => match!(
                (BigInt a, BigInt b) => Atom(a < b),
                (_1, _2) => Nil.nilAtom,
            )(l, r))
            .setMarkedArity(2);
        
        verbs[InsName.GreaterThan] = new Verb(">")
            .setMonad(_ => Nil.nilAtom)
            // Greater than
            .setDyad((l, r) => match!(
                (BigInt a, BigInt b) => Atom(a > b),
                (_1, _2) => Nil.nilAtom,
            )(l, r))
            .setMarkedArity(2);
        
        verbs[InsName.LessEqual] = new Verb("<:")
            .setMonad(_ => Nil.nilAtom)
            // Less than or equal to
            .setDyad((l, r) => match!(
                (BigInt a, BigInt b) => Atom(a <= b),
                (_1, _2) => Nil.nilAtom,
            )(l, r))
            .setMarkedArity(2);
        
        verbs[InsName.GreaterEqual] = new Verb(">:")
            .setMonad(_ => Nil.nilAtom)
            // Greater than or equal to
            .setDyad((l, r) => match!(
                (BigInt a, BigInt b) => Atom(a >= b),
                (_1, _2) => Nil.nilAtom,
            )(l, r))
            .setMarkedArity(2);
        
        verbs[InsName.Print] = new Verb("p.")
            // Print
            .setMonad((a) {
                import std.stdio;
                writeln(a);
                return a;
            })
            .setDyad((_1, _2) => Nil.nilAtom)
            .setMarkedArity(1);
        
        verbs[InsName.Exit] = new Verb("x:")
            // Exit
            .setMonad(a => a.match!(
                (BigInt a) => exit(a),
                _ => exit(),
            ))
            .setDyad((_1, _2) => exit())
            .setMarkedArity(1);
    }
    
    Verb* verb = name in verbs;
    assert(verb, "No such verb: " ~ to!string(name));
    return *verb;
}

Verb filterFor(Verb v) {
    return new Verb(v.display ~ "₁\\")
        .setMonad(a => a.match!(
            (Atom[] a) => Atom(a.filter!(a => v(a).truthiness).array),
            _ => Nil.nilAtom,
        ))
        .setDyad((a, b) => Nil.nilAtom)
        .setMarkedArity(1);
}

Verb foldFor(Verb v) {
    Atom reduc(T)(T arr) {
        // TODO: I don't like that this conditional is checked every time
        // find a way to eliminate it
        return v.identity.isNil
            ? arr.reduce!v
            : reduce!v(v.identity, arr);
    }
    return new Verb(v.display ~ "₂\\")
        .setMonad(a => a.match!(
            (Atom[] arr) => reduc(arr),
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
        .setMarkedArity(1);
}

Adjective getAdjective(InsName name) {
    static Adjective[InsName] adjectives;
    
    if(!adjectives) {
        import std.algorithm.iteration : reduce;
        // Filter/Fold
        adjectives[InsName.Filter] = new Adjective(
            (Verb v) {
                import std.stdio;
                // writeln("Verb v: ", v);
                // writeln("Verb v's identity: ", v.identity.toString());
                // writeln(" ^^is nil?: ", v.identity.isNil);
                
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
            (Verb v) => new Verb(v.display.enclosed ~ '"')
                // map
                .setMonad(a => a.match!(
                    (Atom[] arr) => Atom(arr.map!v.array),
                    _ => Nil.nilAtom,
                ))
                // zip
                .setDyad((a, b) => match!(
                    (Atom[] a, Atom[] b) => Atom(zip(a, b).map!(t => v(t[0], t[1])).array),
                    // TODO: maybe don't call Atom every iteration?
                    (Atom[] a, b) => Atom(a.map!(t => v(t, Atom(b))).array),
                    (a, Atom[] b) => Atom(b.map!(t => v(Atom(a), t)).array),
                    (_1, _2) => Nil.nilAtom,
                )(a, b))
                .setMarkedArity(v.markedArity)
        );
        
        // OnLeft
        adjectives[InsName.OnLeft] = new Adjective(
            (Verb v) => new Verb(v.display.enclosed ~ '[')
                .setMonad(a => v(a))
                .setDyad((a, b) => v(a))
                .setMarkedArity(2)
        );
        
        // OnRight
        adjectives[InsName.OnRight] = new Adjective(
            (Verb v) => new Verb(v.display.enclosed ~ ']')
                .setMonad(a => v(a))
                .setDyad((a, b) => v(b))
                .setMarkedArity(2)
        );
        
        // Reflex
        adjectives[InsName.Reflex] = new Adjective(
            (Verb v) => new Verb(v.display.enclosed ~ '~')
                .setMonad(a => v(a, a))
                .setDyad((x, y) => v(y, x))
                .setMarkedArity(2)
        );
    }
    
    Adjective* adjective = name in adjectives;
    assert(adjective, "No such adjective: " ~ to!string(name));
    return *adjective;
}

Conjunction getConjunction(InsName name) {
    static Conjunction[InsName] conjunctions;
    
    if(!conjunctions) {
         conjunctions[InsName.Bond] = new Conjunction(
            (Verb f, Verb g) => new Verb(f.display.enclosed ~ "&" ~ g.display.enclosed)
                .setMonad(a => 
                    f.niladic
                        ? g(f(), a)
                        : g.niladic
                            ? f(a, g())
                            : f(g(a)))
                // TODO: niladic as per above
                .setDyad((a, b) =>
                    f(g(a), g(b)))
                .setMarkedArity(
                    f.niladic || g.niladic
                        ? 1
                        : g.markedArity)
        );
        
        conjunctions[InsName.Compose] = new Conjunction(
            (Verb f, Verb g) => new Verb(f.display.enclosed ~ "@" ~ g.display.enclosed)
                .setMonad(a => f(g(a)))
                .setDyad((a, b) => f(g(a, b)))
                .setMarkedArity(g.markedArity)
        );
    }
    
    Conjunction* conjunction = name in conjunctions;
    assert(conjunction, "No such conjunction: " ~ to!string(name));
    return *conjunction;
}

MultiConjunction getMultiConjunction(InsName name) {
    static MultiConjunction[InsName] multiConjunctions;
    
    if(!multiConjunctions) {
        // https://aplwiki.com/wiki/Split-compose
        // x (f g h O) y <-> (f x) g (h y)
        multiConjunctions[InsName.SplitCompose] = new MultiConjunction(
            3,
            (Verb[] verbs) {
                Verb f = verbs[0];
                Verb g = verbs[1];
                Verb h = verbs[2];
                return new Verb("(" ~ verbs.map!(a => a.display.enclosed).join(" ") ~ " O)")
                    .setMonad(_ => Nil.nilAtom)
                    .setDyad((x, y) => g(f(x), h(y)))
                    .setMarkedArity(f.niladic || h.niladic ? 1 : 2);
            }
         );
    }
    
    MultiConjunction* multiConjunction = name in multiConjunctions;
    assert(multiConjunction, "No such multi-conjunction: " ~ to!string(name));
    return *multiConjunction;
}

Verb compose(Verb f, Verb g) {
    return getConjunction(InsName.Compose)
        .transform(f, g);
}