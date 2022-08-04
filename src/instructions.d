module myby.instructions;

import std.typecons;
import std.sumtype;
import std.bigint;
import std.range;
import std.algorithm.iteration;
import std.algorithm.searching;
import std.conv : to;

import myby.nibble;

enum InstructionName {
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

alias SpeechNamePair = Tuple!(SpeechPart, "speech", InstructionName, "name");

enum SpeechNamePair[int] NameMap = [
    0x0:    SpeechNamePair(SpeechPart.Verb,             InstructionName.Integer),
    0x1:    SpeechNamePair(SpeechPart.Verb,             InstructionName.String),
    0x2:    SpeechNamePair(SpeechPart.Adjective,        InstructionName.Filter),
    0x3:    SpeechNamePair(SpeechPart.Adjective,        InstructionName.Map),
    0x4:    SpeechNamePair(SpeechPart.Verb,             InstructionName.Add),
    0x5:    SpeechNamePair(SpeechPart.Verb,             InstructionName.Subtract),
    0x6:    SpeechNamePair(SpeechPart.Verb,             InstructionName.Multiply),
    0x7:    SpeechNamePair(SpeechPart.Verb,             InstructionName.Divide),
    0x8:    SpeechNamePair(SpeechPart.Verb,             InstructionName.Exponentiate),
    0x9:    SpeechNamePair(SpeechPart.Verb,             InstructionName.Identity),
    0xA:    SpeechNamePair(SpeechPart.Conjunction,      InstructionName.Bond),
    0xB:    SpeechNamePair(SpeechPart.Syntax,           InstructionName.OpenParen),
    0xC:    SpeechNamePair(SpeechPart.Syntax,           InstructionName.CloseParen),
    0xD:    SpeechNamePair(SpeechPart.Conjunction,      InstructionName.Compose),
    0xE:    SpeechNamePair(SpeechPart.Verb,             InstructionName.Range),
    0xF0:   SpeechNamePair(SpeechPart.Verb,             InstructionName.Modulus),
    0xF10:  SpeechNamePair(SpeechPart.Verb,             InstructionName.FirstChain),
    0xF11:  SpeechNamePair(SpeechPart.Verb,             InstructionName.SecondChain),
    0xF12:  SpeechNamePair(SpeechPart.Verb,             InstructionName.ThirdChain),
    0xF13:  SpeechNamePair(SpeechPart.Verb,             InstructionName.FourthChain),
    //TODO: should this(v) be a conjunction?
    0xF14:  SpeechNamePair(SpeechPart.Verb,             InstructionName.NthChain),
    0xF15:  SpeechNamePair(SpeechPart.Verb,             InstructionName.LessEqual),
    0xF16:  SpeechNamePair(SpeechPart.Verb,             InstructionName.GreaterEqual),
    0xF1E:  SpeechNamePair(SpeechPart.Verb,             InstructionName.Print),
    0xF2:   SpeechNamePair(SpeechPart.Verb,             InstructionName.Pair),
    0xF3:   SpeechNamePair(SpeechPart.Verb,             InstructionName.Binomial),
    0xF4:   SpeechNamePair(SpeechPart.Verb,             InstructionName.Equality),
    0xF5:   SpeechNamePair(SpeechPart.Verb,             InstructionName.LessThan),
    0xF6:   SpeechNamePair(SpeechPart.Verb,             InstructionName.GreaterThan),
    0xF7:   SpeechNamePair(SpeechPart.Adjective,        InstructionName.ArityForce),
    0xF8:   SpeechNamePair(SpeechPart.Verb,             InstructionName.First),
    0xF9:   SpeechNamePair(SpeechPart.Verb,             InstructionName.Last),
    0xFA:   SpeechNamePair(SpeechPart.Adjective,        InstructionName.OnLeft),
    0xFB:   SpeechNamePair(SpeechPart.Adjective,        InstructionName.OnRight),
    0xFC:   SpeechNamePair(SpeechPart.MultiConjunction, InstructionName.SplitCompose),
    0xFD:   SpeechNamePair(SpeechPart.Adjective,        InstructionName.Reflex),
    0xFE00: SpeechNamePair(SpeechPart.Verb,             InstructionName.Exit),
    0xFF:   SpeechNamePair(SpeechPart.Syntax,           InstructionName.Break),
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
    uint markedArity = 2;
    VerbMonad monad;
    VerbDyad dyad;
    bool niladic = false;
    Atom identity;
    BigInt rangeStart = BigInt(0);
    
    this(string di, VerbMonad m, VerbDyad d) {
        display = di;
        monad = m;
        dyad = d;
        identity = Nil.nilAtom;
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
        return this;
    }
    Verb setRangeStart(BigInt rs) {
        rangeStart = rs;
        return this;
    }
    
    Atom evaluate() {
        return monad(Nil.nilAtom);
    }
    
    Atom evaluate(Atom a) {
        return monad(a);
    }
    
    Atom evaluate(Atom l, Atom r) {
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
        return new Verb(
            to!string(constant),
            _ => constant,
            (_1, _2) => constant
        )
        .setNiladic(true);
    }
    
    static Verb fork(Verb f, Verb g, Verb h) {
        return new Verb(
            f.display ~ " " ~ g.display ~ " " ~ h.display,
            a => g(f(a), h(a)),
            (a, b) => g(f(a, b), h(a, b))
        )
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

Verb getVerb(InstructionName name) {
    static Verb[InstructionName] verbs;
    
    if(!verbs) {
        // TODO: this looks awful. clean it.
        // maybe: setMonad, setDyad?
        
        // Addition
        verbs[InstructionName.Add] = new Verb(
            "+",
            (Atom a) => a.match!(
                (BigInt b) => Atom(b < 0 ? -b : b),
                s => Atom(BigInt(s.length)),
                _ => Nil.nilAtom,
            ),
            (Atom l, Atom r) => match!(
                (BigInt a, BigInt b) => Atom(a + b),
                (_1, _2) => Nil.nilAtom,
            )(l, r)
        )
        .setMarkedArity(2)
        .setIdentity(Atom(BigInt(0)));
        
        // Subtraction
        verbs[InstructionName.Subtract] = new Verb(
            "-",
            (Atom a) => a.match!(
                (BigInt n) => Atom(-n),
                (Atom[] a) => Atom(a.retro.array),
                _ => Nil.nilAtom,
            ),
            (Atom l, Atom r) => match!(
                (BigInt a, BigInt b) => Atom(a - b),
                (_1, _2) => Nil.nilAtom,
            )(l, r)
        ).setMarkedArity(2);
        
        // Multiplication
        verbs[InstructionName.Multiply] = new Verb(
            "*",
            (Atom a) => a.match!(
                (Atom[] a) => Atom(flatten(a)),
                _ => Nil.nilAtom,
            ),
            (Atom l, Atom r) => match!(
                (BigInt a, BigInt b) => Atom(a * b),
                (_1, _2) => Nil.nilAtom,
            )(l, r)
        )
        .setMarkedArity(2)
        .setIdentity(Atom(BigInt(1)))
        .setRangeStart(BigInt(1));
        //TODO: setIdentity per cased function
        
        // Division
        verbs[InstructionName.Divide] = new Verb(
            "/",
            (Atom a) => Nil.nilAtom,
            (Atom l, Atom r) => match!(
                (Atom[] a, BigInt b) =>
                    Atom(a.chunks(to!size_t(b))
                    .map!Atom
                    .array),
                (BigInt a, BigInt b) => Atom(a / b),
                (string a, string b) =>
                    Atom(a.split(b).map!Atom.array),
                (_1, _2) => Nil.nilAtom,
            )(l, r)
        ).setMarkedArity(2);
        
        verbs[InstructionName.Exponentiate] = new Verb(
            "^",
            // OneRange
            (Atom a) => a.match!(
                (BigInt a) =>
                    Atom(iota(BigInt(1), a + 1).map!Atom.array),
                _ => Nil.nilAtom,
            ),
            // Exponentiation
            (Atom l, Atom r) => match!(
                (BigInt a, BigInt b) => Atom(pow(a, b)),
                (_1, _2) => Nil.nilAtom,
            )(l, r)
        ).setMarkedArity(2);
        
        // Modulus
        verbs[InstructionName.Modulus] = new Verb(
            "%",
            (Atom a) => Nil.nilAtom,
            (Atom l, Atom r) => match!(
                (BigInt a, BigInt b) => Atom(a % b),
                (_1, _2) => Nil.nilAtom,
            )(l, r)
        ).setMarkedArity(2);
        
        // Identity/Reshape
        verbs[InstructionName.Identity] = new Verb(
            "#",
            _ => _,
            (a, b) => match!(
                (Atom[] a, BigInt b) => Atom(reshape(a, b)),
                (BigInt a, Atom[] b) => Atom(reshape(b, a)),
                (string a, BigInt b) => Atom(reshape(a.atomChars, b).joinToString),
                (BigInt a, string b) => Atom(reshape(b.atomChars, a).joinToString),
                (_1, _2) => Nil.nilAtom,
            )(a, b),
        ).setMarkedArity(1);
        
        // Range (indices)
        verbs[InstructionName.Range] = new Verb(
            "R",
            a => a.match!(
                (BigInt n) => Atom(
                    n < 0
                        ? iota(-n).map!(a => Atom(-n - 1 - a)).array
                        : iota(n).map!Atom.array
                ),
                _ => Nil.nilAtom
            ),
            (l, r) => match!(
                (BigInt a, BigInt b) => Atom(iota(a, b + 1).map!Atom.array),
                (_1, _2) => Nil.nilAtom,
            )(l, r)
        ).setMarkedArity(1);
        
        // Pair
        verbs[InstructionName.Pair] = new Verb(
            ";",
            a => Atom([a]),
            (a, b) => Atom([a, b])
        ).setMarkedArity(2);
        
        // Binomial
        verbs[InstructionName.Binomial] = new Verb(
            "!",
            // Enumerate
            a => a.match!(
                (Atom[] a) =>
                    Atom(a.enumerate()
                    .map!(t => Atom([Atom(BigInt(t[0])), t[1]]))
                    .array),
                _ => Nil.nilAtom,
            ),
            (l, r) => match!(
                (BigInt a, BigInt b) =>
                    Atom(a > b
                        ? BigInt(0)
                        : productOver(iota(a + 2, b + 1)) / productOver(iota(BigInt(1), a + 1))
                    ),
                (_1, _2) => Nil.nilAtom,
            )(l, r),
        ).setMarkedArity(2);
        
        // First element
        verbs[InstructionName.First] = new Verb(
            "{",
            a => a.match!(
                (Atom[] a) => a[0],
                _ => Nil.nilAtom,
            ),
            // Index
            (l, r) => match!(
                (Atom[] a, BigInt b) => a[to!uint(b) % a.length],
                (_1, _2) => Nil.nilAtom,
            )(l, r),
        ).setMarkedArity(2);
        
        // Last element
        verbs[InstructionName.Last] = new Verb(
            "}",
            a => a.match!(
                (Atom[] a) => a[$-1],
                _ => Nil.nilAtom,
            ),
            (l, r) => match!(
                (_1, _2) => Nil.nilAtom,
            )(l, r),
        ).setMarkedArity(1);
        
        // Equal to
        verbs[InstructionName.Equality] = new Verb(
            "=",
            _ => Nil.nilAtom,
            (l, r) => match!(
                (a, b) => Atom(a == b),
                (_1, _2) => Nil.nilAtom,
            )(l, r),
        ).setMarkedArity(2);
        
        // Less than
        verbs[InstructionName.LessThan] = new Verb(
            "<",
            _ => Nil.nilAtom,
            (l, r) => match!(
                (BigInt a, BigInt b) => Atom(a < b),
                (_1, _2) => Nil.nilAtom,
            )(l, r),
        ).setMarkedArity(2);
        
        // Greater than
        verbs[InstructionName.GreaterThan] = new Verb(
            ">",
            _ => Nil.nilAtom,
            (l, r) => match!(
                (BigInt a, BigInt b) => Atom(a > b),
                (_1, _2) => Nil.nilAtom,
            )(l, r),
        ).setMarkedArity(2);
        
        // Less than or equal to
        verbs[InstructionName.LessEqual] = new Verb(
            "<:",
            _ => Nil.nilAtom,
            (l, r) => match!(
                (BigInt a, BigInt b) => Atom(a <= b),
                (_1, _2) => Nil.nilAtom,
            )(l, r),
        ).setMarkedArity(2);
        
        // Greater than or equal to
        verbs[InstructionName.GreaterEqual] = new Verb(
            ">:",
            _ => Nil.nilAtom,
            (l, r) => match!(
                (BigInt a, BigInt b) => Atom(a >= b),
                (_1, _2) => Nil.nilAtom,
            )(l, r),
        ).setMarkedArity(2);
        
        // Print
        verbs[InstructionName.Print] = new Verb(
            "p.",
            (a) { import std.stdio; writeln(a); return a; },
            (_1, _2) => Nil.nilAtom,
        );
        
        // Exit
        verbs[InstructionName.Exit] = new Verb(
            "x:",
            a => a.match!(
                (BigInt a) => exit(a),
                _ => exit(),
            ),
            (_1, _2) => exit(),
        ).setMarkedArity(1);
    }
    
    Verb* verb = name in verbs;
    assert(verb, "No such verb: " ~ to!string(name));
    return *verb;
}

Verb filterFor(Verb v) {
    return new Verb(
        v.display ~ "₁\\",
        a => a.match!(
            (Atom[] a) => Atom(a.filter!(a => v(a).truthiness).array),
            _ => Nil.nilAtom,
        ),
        (a, b) => Nil.nilAtom,
    ).setMarkedArity(1);
}

Verb foldFor(Verb v) {
    Atom reduc(T)(T arr) {
        // TODO: I don't like that this conditional is checked every time
        // find a way to eliminate it
        return v.identity.isNil
            ? arr.reduce!v
            : reduce!v(v.identity, arr);
    }
    return new Verb(
        v.display ~ "₂\\",
        a => a.match!(
            (Atom[] arr) => reduc(arr),
            (BigInt n) => reduc(iota(v.rangeStart, n + 1).map!Atom),
            _ => Nil.nilAtom,
        ),
        (a, b) => match!(
            (BigInt a, BigInt b) => Atom(BigInt("234")),
            // table
            (Atom[] a, Atom[] b) =>
                Atom(a.map!(l => Atom(b.map!(r => v(l, r)).array)).array),
            (_1, _2) => Nil.nilAtom,
        )(a, b),
    ).setMarkedArity(1);
}

Adjective getAdjective(InstructionName name) {
    static Adjective[InstructionName] adjectives;
    
    if(!adjectives) {
        import std.algorithm.iteration : reduce;
        // Filter/Fold
        adjectives[InstructionName.Filter] = new Adjective(
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
        adjectives[InstructionName.Map] = new Adjective(
            (Verb v) => new Verb(
                v.display.enclosed ~ '"',
                // map
                a => a.match!(
                    (Atom[] arr) => Atom(arr.map!v.array),
                    _ => Nil.nilAtom,
                ),
                // zip
                (a, b) => match!(
                    (Atom[] a, Atom[] b) => Atom(zip(a, b).map!(t => v(t[0], t[1])).array),
                    // TODO: maybe don't call Atom every iteration?
                    (Atom[] a, b) => Atom(a.map!(t => v(t, Atom(b))).array),
                    (a, Atom[] b) => Atom(b.map!(t => v(Atom(a), t)).array),
                    (_1, _2) => Nil.nilAtom,
                )(a, b),
            ).setMarkedArity(v.markedArity)
        );
        
        // OnLeft
        adjectives[InstructionName.OnLeft] = new Adjective(
            (Verb v) => new Verb(
                v.display.enclosed ~ '[',
                a => v(a),
                (a, b) => v(a),
            ).setMarkedArity(2)
        );
        
        // OnRight
        adjectives[InstructionName.OnRight] = new Adjective(
            (Verb v) => new Verb(
                v.display.enclosed ~ ']',
                a => v(a),
                (a, b) => v(b),
            ).setMarkedArity(2)
        );
        
        // Reflex
        adjectives[InstructionName.Reflex] = new Adjective(
            (Verb v) => new Verb(
                v.display.enclosed ~ '~',
                a => v(a, a),
                (x, y) => v(y, x),
            ).setMarkedArity(2)
        );
    }
    
    Adjective* adjective = name in adjectives;
    assert(adjective, "No such adjective: " ~ to!string(name));
    return *adjective;
}

Conjunction getConjunction(InstructionName name) {
    static Conjunction[InstructionName] conjunctions;
    
    if(!conjunctions) {
         conjunctions[InstructionName.Bond] = new Conjunction(
            (Verb f, Verb g) => new Verb(
                f.display.enclosed ~ "&" ~ g.display.enclosed,
                a => 
                    f.niladic
                        ? g(f(), a)
                        : g.niladic
                            ? f(a, g())
                            : f(g(a)),
                // TODO: niladic
                (a, b) =>
                    f(g(a), g(b))
            )
            .setMarkedArity(f.niladic || g.niladic ? 1 : g.markedArity)
        );
        
        conjunctions[InstructionName.Compose] = new Conjunction(
            (Verb f, Verb g) => new Verb(
                f.display.enclosed ~ "@" ~ g.display.enclosed,
                a => f(g(a)),
                (a, b) => f(g(a, b))
            ).setMarkedArity(g.markedArity),
        );
    }
    
    Conjunction* conjunction = name in conjunctions;
    assert(conjunction, "No such conjunction: " ~ to!string(name));
    return *conjunction;
}

MultiConjunction getMultiConjunction(InstructionName name) {
    static MultiConjunction[InstructionName] multiConjunctions;
    
    if(!multiConjunctions) {
        // https://aplwiki.com/wiki/Split-compose
        // x (f g h O) y <-> (f x) g (h y)
        multiConjunctions[InstructionName.SplitCompose] = new MultiConjunction(
            3,
            (Verb[] verbs) {
                Verb f = verbs[0];
                Verb g = verbs[1];
                Verb h = verbs[2];
                return new Verb(
                    "(" ~ verbs.map!(a => a.display.enclosed).join(" ") ~ " O)",
                    _ => Nil.nilAtom,
                    (x, y) => g(f(x), h(y)),
                )
                .setMarkedArity(f.niladic || h.niladic ? 1 : 2);
            }
         );
    }
    
    MultiConjunction* multiConjunction = name in multiConjunctions;
    assert(multiConjunction, "No such multi-conjunction: " ~ to!string(name));
    return *multiConjunction;
}

Verb compose(Verb f, Verb g) {
    return getConjunction(InstructionName.Compose)
        .transform(f, g);
}