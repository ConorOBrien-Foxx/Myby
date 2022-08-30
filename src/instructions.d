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
import myby.interpreter : Interpreter;
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
    LessEqual,              //AA
    GreaterEqual,           //AD
    OpenParen,              //B
    Test,                   //BC
    CloseParen,             //C
    Compose,                //D
    Under,                  //DA
    MonadChain,             //DD
    Range,                  //E
    Modulus,                //F0
    FirstChain,             //F10
    SecondChain,            //F11
    ThirdChain,             //F12
    FourthChain,            //F13
    NthChain,               //F14
    Minimum,                //F17
    Maximum,                //F18
    OnLeft,                 //F19
    OnRight,                //F1A
    Generate,               //F1B
    Inverse,                //F1C
    Power,                  //F1D
    Print,                  //F1E
    Scan,                   //F1F
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
    Empty,                  //FE40
    Ascii,                  //FE41
    Alpha,                  //FE42
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
enum SpeechPart { Verb, Adjective, Conjunction, MultiConjunction, Syntax }

struct InsInfo {
    string name;
    int code;
    Nibble[] nibs;
    SpeechPart speech;

    this(string n, int c, SpeechPart s) {
        name = n;
        code = c;
        speech = s;
        while(c) {
            nibs = [cast(Nibble)(c % 16)] ~ nibs;
            c /= 16;
        }
    }
}

// Unassigned *AND* Unimplemented: Initial ) at start of program.
enum InsInfo[InsName] Info = [
    // Integer: 0
    // String: 1
    InsName.Filter:                 InsInfo("\\",      0x2,       SpeechPart.Adjective),
    InsName.Map:                    InsInfo("\"",      0x3,       SpeechPart.Adjective),
    InsName.Add:                    InsInfo("+",       0x4,       SpeechPart.Verb),
    InsName.Subtract:               InsInfo("-",       0x5,       SpeechPart.Verb),
    InsName.Multiply:               InsInfo("*",       0x6,       SpeechPart.Verb),
    InsName.Divide:                 InsInfo("/",       0x7,       SpeechPart.Verb),
    InsName.Exponentiate:           InsInfo("^",       0x8,       SpeechPart.Verb),
    InsName.Identity:               InsInfo("#",       0x9,       SpeechPart.Verb),
    InsName.Bond:                   InsInfo("&",       0xA,       SpeechPart.Conjunction),
    // Unassigned: AC       NB: `&)` has no meaning
    InsName.LessEqual:              InsInfo("<:",      0xAA,      SpeechPart.Verb),
    InsName.GreaterEqual:           InsInfo(">:",      0xAD,      SpeechPart.Verb),
    // Unassigned: AAA, AAD, ADA, ADD, AAAA, ...etc.
    InsName.OpenParen:              InsInfo("(",       0xB,       SpeechPart.Syntax),
    // Unassigned: BA       NB: `(&` has no meaning
    // Unassigned: BC       NB: `()` has no meaning
    InsName.Test:                   InsInfo("test",    0XBC,      SpeechPart.Verb),
    // Unassigned: BD       NB: `(@` has no meaning
    InsName.CloseParen:             InsInfo(")",       0xC,       SpeechPart.Syntax),
    InsName.Compose:                InsInfo("@",       0xD,       SpeechPart.Conjunction),
    InsName.Under:                  InsInfo("&.",      0xDA,      SpeechPart.Conjunction),
    // Unassigned: DC       NB: `@)` has no meaning
    InsName.MonadChain:             InsInfo("@.",      0xDD,      SpeechPart.MultiConjunction),
    // Unassigned: DAA, DAD, DDA, DDD, DAAA, ...etc.
    InsName.Range:                  InsInfo("R",       0xE,       SpeechPart.Verb),
    InsName.Modulus:                InsInfo("%",       0xF0,      SpeechPart.Verb),
    InsName.FirstChain:             InsInfo("$1",      0xF10,     SpeechPart.Verb),
    InsName.FirstChain:             InsInfo("$",       0xF10,     SpeechPart.Verb),
    InsName.SecondChain:            InsInfo("$2",      0xF11,     SpeechPart.Verb),
    InsName.ThirdChain:             InsInfo("$3",      0xF12,     SpeechPart.Verb),
    InsName.FourthChain:            InsInfo("$4",      0xF13,     SpeechPart.Verb),
    InsName.NthChain:               InsInfo("$N",      0xF14,     SpeechPart.Verb),
    // Unassigned: F15
    // Unassigned: F16
    InsName.Minimum:                InsInfo("<.",      0xF17,     SpeechPart.Verb),
    InsName.Maximum:                InsInfo(">.",      0xF18,     SpeechPart.Verb),
    InsName.OnLeft:                 InsInfo("[",       0xF19,     SpeechPart.Adjective),
    InsName.OnRight:                InsInfo("]",       0xF1A,     SpeechPart.Adjective),
    InsName.Generate:               InsInfo("G",       0xF1B,     SpeechPart.Adjective),
    InsName.Inverse:                InsInfo("!.",      0xF1C,     SpeechPart.Adjective),
    InsName.Power:                  InsInfo("^:",      0xF1D,     SpeechPart.Conjunction),
    InsName.Print:                  InsInfo("echo",    0xF1E,     SpeechPart.Verb),
    InsName.Scan:                   InsInfo("\\:",     0xF1F,     SpeechPart.Conjunction),
    InsName.Pair:                   InsInfo(";",       0xF2,      SpeechPart.Verb),
    InsName.Binomial:               InsInfo("!",       0xF3,      SpeechPart.Verb),
    InsName.Equality:               InsInfo("=",       0xF4,      SpeechPart.Verb),
    InsName.LessThan:               InsInfo("<",       0xF5,      SpeechPart.Verb),
    InsName.GreaterThan:            InsInfo(">",       0xF6,      SpeechPart.Verb),
    InsName.ArityForce:             InsInfo("`",       0xF7,      SpeechPart.Adjective),
    InsName.First:                  InsInfo("{",       0xF8,      SpeechPart.Verb),
    InsName.Last:                   InsInfo("}",       0xF9,      SpeechPart.Verb),
    InsName.OnPrefixes:             InsInfo("\\.",     0xFA,      SpeechPart.Adjective),
    // 0xFB
    InsName.SplitCompose:           InsInfo("O",       0xFC,      SpeechPart.MultiConjunction),
    InsName.Reflex:                 InsInfo("~",       0xFD,      SpeechPart.Adjective),
    InsName.Exit:                   InsInfo("exit",    0xFE00,    SpeechPart.Verb),
    InsName.Empty:                  InsInfo("E",       0xFE40,    SpeechPart.Verb),
    InsName.Ascii:                  InsInfo("A",       0xFE41,    SpeechPart.Verb),
    InsName.Alpha:                  InsInfo("L",       0xFE42,    SpeechPart.Verb),
    InsName.NthPrime:               InsInfo("primn",   0xFE70,    SpeechPart.Verb),
    InsName.IsPrime:                InsInfo("primq",   0xFE71,    SpeechPart.Verb),
    InsName.PrimeFactors:           InsInfo("primf",   0xFE72,    SpeechPart.Verb),
    InsName.PrimeFactorsCount:      InsInfo("primo",   0xFE73,    SpeechPart.Verb),
    InsName.UniqPrimeFactors:       InsInfo("primfd",  0xFE74,    SpeechPart.Verb),
    InsName.UniqPrimeFactorsCount:  InsInfo("primod",  0xFE75,    SpeechPart.Verb),
    InsName.PreviousPrime:          InsInfo("prevp",   0xFE76,    SpeechPart.Verb),
    InsName.NextPrime:              InsInfo("nextp",   0xFE77,    SpeechPart.Verb),
    InsName.FirstNPrimes:           InsInfo("prims",   0xFE78,    SpeechPart.Verb),
    InsName.Break:                  InsInfo("\n",      0xFF,      SpeechPart.Syntax),
];

alias LiterateInfo = Tuple!(Nibble[], "nibs", SpeechPart, "speech");
enum InstructionMap = Info.mapKeyValue!(LiterateInfo[string],
    (ref hash, k, v) => hash[v.name] = LiterateInfo(v.nibs, v.speech)
);

alias NameInfo = Tuple!(SpeechPart, "speech", InsName, "name");
enum NameMap = Info.mapKeyValue!(NameInfo[int], 
    (ref hash, k, v) => hash[v.code] = NameInfo(v.speech, k)
);

Verb getVerb(InsName name) {
    static Verb[InsName] verbs;
    
    if(!verbs) {
        // TODO: this looks awful. clean it.
        // maybe: setMonad, setDyad?
        
        // Addition
        verbs[InsName.Add] = new Verb("+")
            // Absolute value/Length
            .setMonad((Atom a) => a.match!(
                b => atomFor(b < 0 ? -b : b),
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
            .setMarkedArity(2);
        
        verbs[InsName.Multiply] = new Verb("*")
            .setMonad((Atom a) => a.match!(
                // Flatten
                (Atom[] a) => Atom(flatten(a)),
                // Sign
                (BigInt b) => Atom(BigInt(b < 0 ? -1 : b == 0 ? 0 : 1)),
                _ => Nil.nilAtom,
            ))
            .setDyad((Atom a, Atom b) => a * b)
            .setMarkedArity(2)
            .setIdentity(Atom(BigInt(1)))
            .setRangeStart(BigInt(1));
        
        verbs[InsName.Divide] = new Verb("/")
            .setMonad((Atom a) => a.match!(
                // Characters
                (string a) => Atom(a.atomChars),
                // Unique
                (Atom[] a) => Atom(a.nub.array),
                _ => Nil.nilAtom,
            ))
            .setDyad((Atom a, Atom b) => a / b)
            .setMarkedArity(2);
        
        verbs[InsName.Exponentiate] = new Verb("^")
            // OneRange
            .setMonad((Atom a) => a.match!(
                (BigInt a) =>
                    verbs[InsName.Range](BigInt(1), a),
                _ => Nil.nilAtom,
            ))
            // Exponentiation
            .setDyad((Atom a, Atom b) => a ^^ b)
            .setMarkedArity(2);
        
        verbs[InsName.Modulus] = new Verb("%")
            .setMonad((Atom a) => a.match!(
                // Sort
                (Atom[] a) => Atom(a.sort.array),
                _ => Nil.nilAtom,
            ))
            .setDyad((Atom a, Atom b) => a % b)
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
                (Atom[] a, Atom[] b) => Atom(arrayRange(a, b).map!Atom.array),
                (string a, string b) => Atom(
                    arrayRange(a.atomOrds, b.atomOrds)
                    .map!atomUnords
                    .map!Atom
                    .array
                ),
                (_1, _2) => Nil.nilAtom,
            )(l, r))
            .setMarkedArity(1);
        
        verbs[InsName.Pair] = new Verb(";")
            // Wrap
            .setMonad(a => Atom([a]))
            // Pair
            .setDyad((a, b) => a.linkWith(b))
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
            .setDyad((l, r) => match!(
                // Binomial
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
            // ToString
            .setMonad(a => Atom(a.as!string))
            // Inverse: Evaluate
            .setInverse(new Verb("< inv")
                .setMonad(a => a.match!(
                    (string a) => Interpreter.evaluate(a),
                    _ => Nil.nilAtom,
                ))
                .setDyad((_1, _2) => Nil.nilAtom)
                .setMarkedArity(1)
            )
            // Less than
            .setDyad((l, r) => match!(
                (a, b) => Atom(a < b),
                (_1, _2) => Nil.nilAtom,
            )(l, r))
            .setMarkedArity(2);
        
        verbs[InsName.GreaterThan] = new Verb(">")
            // Single Join
            .setMonad(a => a.match!(
                (Atom[] a) => Atom(a.joinToString),
                _ => Nil.nilAtom,
            ))
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
        
        verbs[InsName.Empty] = Verb.nilad(Atom(cast(Atom[])[]));
        verbs[InsName.Empty].display = "E";
        
        verbs[InsName.Ascii] = Verb.nilad(Atom(
            iota(128).map!(a => Atom("" ~ cast(char)a)).array
        ));
        verbs[InsName.Ascii].display = "A";
        
        verbs[InsName.Alpha] = Verb.nilad(Atom("abcdefghijklmnopqrstuvwxyz"));
        verbs[InsName.Alpha].display = "L";
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
        
        // Inverse
        adjectives[InsName.Inverse] = new Adjective(
            (Verb v) {
                assert(v.invertable(), "Cannot invert " ~ v.display);
                return new Verb("!.")
                    .setMonad(a => v.inverse(a))
                    .setDyad((_1, _2) => Nil.nilAtom)
                    .setInverse(v)
                    .setMarkedArity(1)
                    .setChildren([v]);
            }
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
        
        conjunctions[InsName.Under] = new Conjunction(
            (Verb f, Verb g) {
                assert(g.invertable(), "Cannot invert " ~ g.display);
                return new Verb("&.")
                    .setMonad(a => g.inverse(f(g(a))))
                    .setDyad((_1, _2) => Nil.nilAtom)
                    .setMarkedArity(1)
                    .setChildren([f, g]);
            }
        );
        
        conjunctions[InsName.Scan] = new Conjunction(
            (Verb f, Verb seedFn) => new Verb("\\:")
                .setMonad(a => a.match!(
                    (Atom[] arr) {
                        // TODO: relegate a specific atom for
                        // using f's identity as seed?
                        Atom seed = seedFn(a);
                        return Atom(arr.scanThrough(f, seed));
                    },
                    _ => Nil.nilAtom,
                ))
                .setDyad((_1, _2) => Nil.nilAtom)
                .setMarkedArity(1)
                .setChildren([f, seedFn])
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