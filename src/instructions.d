module myby.instructions;

import std.algorithm.comparison;
import std.algorithm.iteration;
import std.algorithm.searching;
import std.algorithm.sorting;
import std.bigint;
import std.conv : to;
import std.range;
import std.sumtype;
import std.typecons;

import myby.debugger;
import myby.manip;
import myby.nibble;
import myby.prime;
import myby.speech;

enum InsName {
    Integer,                //0
    Real,                   //0B
    String,                 //1
    Filter,                 //2
    Map,                    //3
    Add,                    //4
    Subtract,               //5
    Multiply,               //6
    Divide,                 //7
    Exponentiate,           //8
    Identity,               //9
    Bond,                   //A
    OpenParen,              //B
    CloseParen,             //C
    Compose,                //D
    Range,                  //E
    Modulus,                //F0
    FirstChain,             //F10
    SecondChain,            //F11
    ThirdChain,             //F12
    FourthChain,            //F13
    NthChain,               //F14
    GreaterEqual,           //F15
    LessEqual,              //F16
    Minimum,                //F17
    Maximum,                //F18
    OnLeft,                 //F19
    OnRight,                //F1A
    Generate,               //F1B
    Power,                  //F1D
    Print,                  //F1E
    MonadChain,             //F1F
    Pair,                   //F2
    Binomial,               //F3
    Equality,               //F4
    LessThan,               //F5
    GreaterThan,            //F6
    ArityForce,             //F7
    First,                  //F8
    Last,                   //F9
    OnPrefixes,             //FA
    SplitCompose,           //FC
    Reflex,                 //FD
    Exit,                   //FE00
    NthPrime,               //FE70
    IsPrime,                //FE71
    PrimeFactors,           //FE72
    PrimeFactorsCount,      //FE73
    UniqPrimeFactors,       //FE74
    UniqPrimeFactorsCount,  //FE75
    PreviousPrime,          //FE76
    NextPrime,              //FE77
    FirstNPrimes,           //FE78
    Break,                  //FF
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
    "<.": [0xF, 0x1, 0x7],
    ">.": [0xF, 0x1, 0x8],
    "[": [0xF, 0x1, 0x9],
    "]": [0xF, 0x1, 0xA],
    "G": [0xF, 0x1, 0xB],
    //...
    "^:": [0xF, 0x1, 0xD],
    "echo": [0xF, 0x1, 0xE],
    "@.": [0xF, 0x1, 0xF],
    "primn": [0xF, 0xE, 0x7, 0x0],
    "primq": [0xF, 0xE, 0x7, 0x1],
    "primf": [0xF, 0xE, 0x7, 0x2],
    "primo": [0xF, 0xE, 0x7, 0x3],
    "primfd": [0xF, 0xE, 0x7, 0x4],
    "primod": [0xF, 0xE, 0x7, 0x5],
    "prevp": [0xF, 0xE, 0x7, 0x6],
    "nextp": [0xF, 0xE, 0x7, 0x7],
    "prims": [0xF, 0xE, 0x7, 0x8],
    ";": [0xF, 0x2],
    "!": [0xF, 0x3],
    "=": [0xF, 0x4],
    "<": [0xF, 0x5],
    ">": [0xF, 0x6],
    "`": [0xF, 0x7],
    "{": [0xF, 0x8],
    "}": [0xF, 0x9],
    "\\.": [0xF, 0xA],
    "O": [0xF, 0xC],
    "~": [0xF, 0xD],
    "exit": [0xF, 0xE, 0x0, 0x0],
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
    0xF17:  NameInfo(SpeechPart.Verb,             InsName.Minimum),
    0xF18:  NameInfo(SpeechPart.Verb,             InsName.Maximum),
    0xF19:  NameInfo(SpeechPart.Adjective,        InsName.OnLeft),
    0xF1A:  NameInfo(SpeechPart.Adjective,        InsName.OnRight),
    0xF1B:  NameInfo(SpeechPart.Adjective,        InsName.Generate),
    // 0xF1C
    0xF1D:  NameInfo(SpeechPart.Conjunction,      InsName.Power),
    0xF1E:  NameInfo(SpeechPart.Verb,             InsName.Print),
    0xF1F:  NameInfo(SpeechPart.MultiConjunction, InsName.MonadChain),
    0xF2:   NameInfo(SpeechPart.Verb,             InsName.Pair),
    0xF3:   NameInfo(SpeechPart.Verb,             InsName.Binomial),
    0xF4:   NameInfo(SpeechPart.Verb,             InsName.Equality),
    0xF5:   NameInfo(SpeechPart.Verb,             InsName.LessThan),
    0xF6:   NameInfo(SpeechPart.Verb,             InsName.GreaterThan),
    0xF7:   NameInfo(SpeechPart.Adjective,        InsName.ArityForce),
    0xF8:   NameInfo(SpeechPart.Verb,             InsName.First),
    0xF9:   NameInfo(SpeechPart.Verb,             InsName.Last),
    0xFA:   NameInfo(SpeechPart.Adjective,        InsName.OnPrefixes),
    0xFC:   NameInfo(SpeechPart.MultiConjunction, InsName.SplitCompose),
    0xFD:   NameInfo(SpeechPart.Adjective,        InsName.Reflex),
    0xFE00: NameInfo(SpeechPart.Verb,             InsName.Exit),
    0xFE70: NameInfo(SpeechPart.Verb,             InsName.NthPrime),
    0xFE71: NameInfo(SpeechPart.Verb,             InsName.IsPrime),
    0xFE72: NameInfo(SpeechPart.Verb,             InsName.PrimeFactors),
    0xFE73: NameInfo(SpeechPart.Verb,             InsName.PrimeFactorsCount),
    0xFE74: NameInfo(SpeechPart.Verb,             InsName.UniqPrimeFactors),
    0xFE75: NameInfo(SpeechPart.Verb,             InsName.UniqPrimeFactorsCount),
    0xFE76: NameInfo(SpeechPart.Verb,             InsName.PreviousPrime),
    0xFE77: NameInfo(SpeechPart.Verb,             InsName.NextPrime),
    0xFE78: NameInfo(SpeechPart.Verb,             InsName.FirstNPrimes),
    0xFF:   NameInfo(SpeechPart.Syntax,           InsName.Break),
];

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
            .setDyad((Atom a, Atom b) => a + b)
            .setMarkedArity(2)
            .setIdentity(Atom(BigInt(0)));
        
        verbs[InsName.Subtract] = new Verb("-")
            .setMonad((Atom a) => a.match!(
                // Negate
                (BigInt n) => Atom(-n),
                // Reverse
                (Atom[] a) => Atom(a.retro.array),
                // Negate
                (bool b) => Atom(!b),
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
                // Flatten
                (Atom[] a) => Atom(flatten(a)),
                // Sign
                (BigInt b) => Atom(BigInt(b < 0 ? -1 : b == 0 ? 0 : 1)),
                _ => Nil.nilAtom,
            ))
            .setDyad((Atom l, Atom r) => match!(
                // Multiplication
                (BigInt a, BigInt b) => Atom(a * b),
                // Join by
                (Atom[] a, string b) => Atom(a.map!(to!string).join(b)),
                (_1, _2) => Nil.nilAtom,
            )(l, r))
            .setMarkedArity(2)
            .setIdentity(Atom(BigInt(1)))
            .setRangeStart(BigInt(1));
        
        verbs[InsName.Divide] = new Verb("/")
            .setMonad((Atom a) => a.match!(
                // Characters
                (string a) => Atom(a.map!(to!string).map!Atom.array),
                // Unique
                (Atom[] a) => Atom(a.nub.array),
                _ => Nil.nilAtom,
            ))
            .setDyad((Atom l, Atom r) => match!(
                // Chunk
                (Atom[] a, BigInt b) =>
                    Atom(a.chunks(to!size_t(b))
                    .map!Atom
                    .array),
                (string a, BigInt b) =>
                    verbs[InsName.Divide](verbs[InsName.Divide](a), b),
                // Division
                (BigInt a, BigInt b) => Atom(a / b),
                // Split on
                (string a, string b) =>
                    Atom(a.split(b).map!Atom.array),
                (_1, _2) => Nil.nilAtom,
            )(l, r))
            .setMarkedArity(2);
        
        verbs[InsName.Exponentiate] = new Verb("^")
            // OneRange
            .setMonad((Atom a) => a.match!(
                (BigInt a) =>
                    verbs[InsName.Range](BigInt(1), a),
                _ => Nil.nilAtom,
            ))
            // Exponentiation
            .setDyad((Atom l, Atom r) => match!(
                (BigInt a, BigInt b) => Atom(pow(a, b)),
                (_1, _2) => Nil.nilAtom,
            )(l, r))
            .setMarkedArity(2);
        
        verbs[InsName.Modulus] = new Verb("%")
            .setMonad((Atom a) => a.match!(
                // Sort
                (Atom[] a) => Atom(a.sort.array),
                _ => Nil.nilAtom,
            ))
            .setDyad((Atom l, Atom r) => match!(
                // Modulus
                (BigInt a, BigInt b) => Atom(positiveMod(a, b)),
                // Intersection, a la APL
                (Atom[] a, Atom[] b) => Atom(a.filter!(e => b.canFind(e)).array),
                (Atom[] a, b) => Atom(a.filter!(e => e == atomFor(b)).array),
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
                // TODO: Atom[], Atom[] to filter by
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
            .setMonad(a => verbs[InsName.First](a, atomFor(BigInt(0))))
            // Index
            .setDyad((l, r) => match!(
                (BigInt b, Atom[] a) =>
                    a[moldIndex(b, a.length)],
                (BigInt b, string a) =>
                    Atom(to!string(a[moldIndex(b, a.length)])),
                (_1, _2) => Nil.nilAtom,
            )(l, r))
            .setMarkedArity(2);
        
        verbs[InsName.Last] = new Verb("}")
            // Last element
            .setMonad(a => verbs[InsName.First](
                atomFor(a),
                Atom(BigInt(-1))
            ))
            .setDyad((l, r) => match!(
                (_1, _2) => Nil.nilAtom,
            )(l, r))
            .setMarkedArity(1);
        
        verbs[InsName.Equality] = new Verb("=")
            .setMonad(a => a.match!(
                (BigInt b) => Atom(eye(b)),
                (Atom[] a) => Atom(selfClassify(a)),
                _ => Nil.nilAtom,
            ))
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
                (a, b) => Atom(a < b),
                (_1, _2) => Nil.nilAtom,
            )(l, r))
            .setMarkedArity(2);
        
        verbs[InsName.GreaterThan] = new Verb(">")
            .setMonad(_ => Nil.nilAtom)
            // Greater than
            .setDyad((l, r) => match!(
                (a, b) => Atom(a > b),
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
        
        verbs[InsName.Minimum] = new Verb("<.")
            // Minimum
            .setMonad(a => a.match!(
                (Atom[] a) => foldFor(verbs[InsName.Minimum])(Atom(a)),
                _ => Nil.nilAtom,
            ))
            // Lesser of 2
            .setDyad((l, r) => min(l, r))
            // .setDyad((a, b) => match!(
                // (a, b) => a < b ? atomFor(a) : atomFor(b),
                // (_1, _2) => assert(0, "Cannot compare")
            // )(a, b))
            // .setDyad((l, r) => match!(
                // (a, b) => Atom(min(a, b)),
                // (_1, _2) => Nil.nilAtom,
            // )(l, r))
            .setIdentity(Infinity.positiveAtom)
            .setMarkedArity(2);
        
        verbs[InsName.Maximum] = new Verb(">.")
            .setMonad(a => a.match!(
                (Atom[] a) => foldFor(verbs[InsName.Maximum])(Atom(a)),
                _ => Nil.nilAtom,
            ))
            // Greater of 2
            .setDyad((l, r) => max(l, r))
            // .setDyad((a, b) => match!(
                // (a, b) => a < b ? atomFor(b) : atomFor(a),
                // (_1, _2) => assert(0, "Cannot compare")
            // )(a, b))
            // .setDyad((l, r) => match!(
                // (a, b) => Atom(max(a, b)),
                // (_1, _2) => Nil.nilAtom,
            // )(l, r))
            .setIdentity(Infinity.negativeAtom)
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
        
        verbs[InsName.Exit] = new Verb("exit")
            // Exit
            .setMonad(a => a.match!(
                (BigInt a) => exit(a),
                _ => exit(),
            ))
            .setDyad((_1, _2) => exit())
            .setMarkedArity(1);
            
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
    }
    
    Verb* verb = name in verbs;
    assert(verb, "No such verb: " ~ to!string(name));
    return *verb;
}

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
                .setChildren([v])
        );
        
        // ArityForce
        adjectives[InsName.ArityForce] = new Adjective(
            (Verb v) => new Verb("`")
                .setMonad(a => v(a))
                .setDyad((a, b) => v(a, b))
                .setMarkedArity(v.markedArity == 2 ? 1 : 2)
                .setChildren([v])
        );
        
        // OnLeft
        adjectives[InsName.OnLeft] = new Adjective(
            (Verb v) => new Verb("[")
                .setMonad(a => v(a))
                .setDyad((a, b) => v(a))
                .setMarkedArity(2)
                .setChildren([v])
        );
        
        // OnRight
        adjectives[InsName.OnRight] = new Adjective(
            (Verb v) => new Verb("]")
                .setMonad(a => v(a))
                .setDyad((a, b) => v(b))
                .setMarkedArity(2)
                .setChildren([v])
        );
        
        // OnPrefixes
        adjectives[InsName.OnPrefixes] = new Adjective(
            (Verb v) => new Verb("\\.")
                .setMonad(a => a.match!(
                    (Atom[] a) => Atom(
                        iota(a.length)
                            .map!(i => a[0..i + 1])
                            .map!Atom
                            .map!v
                            .array
                    ),
                    _ => Nil.nilAtom,
                ))
                .setDyad((_1, _2) => Nil.nilAtom)
                .setMarkedArity(1)
                .setChildren([v])
        );
        
        // Reflex
        adjectives[InsName.Reflex] = new Adjective(
            (Verb v) => new Verb("~")
                .setMonad(a => v(a, a))
                .setDyad((x, y) => v(y, x))
                .setMarkedArity(2)
                .setChildren([v])
        );
        
        // Generate
        adjectives[InsName.Generate] = new Adjective(
            (Verb v) => new Verb("G")
                .setMonad((a) {
                    auto ind = BigInt(0);
                    while(!v(a, Atom(ind)).truthiness) {
                        ind++;
                    }
                    return Atom(ind);
                })
                .setDyad((_1, _2) => Nil.nilAtom)
                .setMarkedArity(1)
                .setChildren([v])
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
            (Verb f, Verb g) => new Verb("&")
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
                .setChildren([f, g])
        );
        
        conjunctions[InsName.Compose] = new Conjunction(
            (Verb f, Verb g) => new Verb("@")
                .setMonad(a => f(g(a)))
                .setDyad((a, b) => f(g(a, b)))
                .setMarkedArity(g.markedArity)
                .setChildren([f, g])
        );
        
        conjunctions[InsName.Power] = new Conjunction(
            (Verb f, Verb g) => new Verb("^:")
                .setMonad(_ => Nil.nilAtom)
                .setDyad((_1, _2) => Nil.nilAtom)
                .setMarkedArity(f.markedArity)
                .setChildren([f, g])
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
                return new Verb("O")
                    .setMonad(_ => Nil.nilAtom)
                    .setDyad((x, y) => g(f(x), h(y)))
                    .setMarkedArity(f.niladic || h.niladic ? 1 : 2)
                    .setChildren([f, g, h]);
            }
         );
         
         multiConjunctions[InsName.MonadChain] = new MultiConjunction(
            0, // greedy
            (Verb[] verbs) {
                if(verbs.length == 1) {
                    return verbs[0];
                }
                assert(verbs.length > 1, "Cannot multi-compose with this many verbs");
                // so that we fold from right to left
                import std.algorithm.mutation : reverse;
                verbs.reverse;
                return new Verb("@.")
                    .setMonad(y => reduce!((atom, v) => v(atom))(y, verbs))
                    .setDyad((_1, _2) => Nil.nilAtom)
                    .setMarkedArity(1)
                    .setChildren(verbs);
            }
         );
    }
    
    MultiConjunction* multiConjunction = name in multiConjunctions;
    assert(multiConjunction, "No such multi-conjunction: " ~ to!string(name));
    return *multiConjunction;
}

Verb bind(Verb f, Verb g) {
    return getConjunction(InsName.Bond)
        .transform(f, g);
}

Verb compose(Verb f, Verb g) {
    return getConjunction(InsName.Compose)
        .transform(f, g);
}