module myby.instructions;

import core.exception;

import std.algorithm.comparison;
import std.algorithm.iteration;
import std.algorithm.searching;
import std.algorithm.sorting;
import std.bigint;
import std.conv : to;
import std.datetime;
import std.range;
import std.sumtype;
import std.typecons;
import std.uni;

import myby.debugger;
import myby.interpreter : Interpreter;
import myby.json;
import myby.manip;
import myby.nibble;
import myby.prime;
import myby.speech;

enum InsName {
    Integer,                //0
    Real,                   //0B
    String,                 //1
    ListLiteral,            //x2x
    Filter,                 //2
    Map,                    //3
    Add,                    //4
    Subtract,               //5
    Multiply,               //6
    Divide,                 //7
    Exponentiate,           //8
    Identity,               //9
    Bond,                   //A
    OnPrefixes,             //AA
    OnSuffixes,             //AC
    SplitCompose,           //AD
    OpenParen,              //B
    ArityForce,             //BA
    Vectorize,              //BC
    Reflex,                 //BD
    CloseParen,             //C
    Compose,                //D
    Under,                  //DA
    MonadChain,             //DD
    Range,                  //E
    Modulus,                //F0
    LastChain,              //F10
    ThisChain,              //F11
    NextChain,              //F12
    NthChain,               //F13
    Diagonal,               //F14
    Oblique,                //F15
    Ternary,                //F16
    Minimum,                //F17
    Maximum,                //F18
    OnLeft,                 //F19
    OnRight,                //F1A
    Generate,               //F1B
    Inverse,                //F1C
    Power,                  //F1D
    Print,                  //F1E
    Scan,                   //F1F
    Link,                   //F2
    Binomial,               //F3
    Equality,               //F4
    LessThan,               //F5
    GreaterThan,            //F6
    MemberIn,               //F7
    First,                  //F8
    Last,                   //F9
    LessEqual,              //FA
    GreaterEqual,           //FB
    Inequality,             //FC
    Pair,                   //FD
    Exit,                   //FE00
    Put,                    //FE01
    Putch,                  //FE02
    Getch,                  //FE03
    Empty,                  //FE40
    Ascii,                  //FE41
    Alpha,                  //FE42
    ToJSON,                 //FE50
    FromJSON,               //FE51
    ReadFile,               //FE52
    WriteFile,              //FE53
    DigitRange,             //FE60
    Place,                  //FE61
    Hash,                   //FE62
    NthPrime,               //FE70
    IsPrime,                //FE71
    PrimeFactors,           //FE72
    PrimeFactorsCount,      //FE73
    UniqPrimeFactors,       //FE74
    UniqPrimeFactorsCount,  //FE75
    PreviousPrime,          //FE76
    NextPrime,              //FE77
    FirstNPrimes,           //FE78
    PrimesBelow,            //FE79
    PrimesBelowCount,       //FE7A
    Benil,                  //FE80
    Memoize,                //FE81
    Keep,                   //FE82
    Loop,                   //FE83
    BLoop,                  //FE84
    While,                  //FE85
    Time,                   //FE86
    InitialAlias,           //----
    DefinedAlias,           //FEA0-FEBF
    Break,                  //FF
    None,                   //----
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
    // AA: `&&` has no meaning
    InsName.OnPrefixes:             InsInfo("\\.",     0xAA,      SpeechPart.Adjective),
    // AC: `&)` has no meanings
    InsName.OnSuffixes:             InsInfo("\\:",     0xAC,      SpeechPart.Adjective),
    // AD: `&D` has no meaning
    InsName.SplitCompose:           InsInfo("O",       0xAD,      SpeechPart.MultiConjunction),
    // Unassigned (maybe): ADAD/ACAC/etc
    InsName.OpenParen:              InsInfo("(",       0xB,       SpeechPart.Syntax),
    // BA: `(` followed by A... (A `&` AA `\.` AC `\: AD `O`) has no meaning
    InsName.ArityForce:             InsInfo("`",       0xBA,      SpeechPart.Adjective),
    // BC: `()` has no meaning
    InsName.Vectorize:              InsInfo("V",       0xBC,      SpeechPart.Adjective),
    // BD: `(` followed by D... (D `@` DA `&.` DD `@.`) has no meaning
    InsName.Reflex:                 InsInfo("~",       0xBD,      SpeechPart.Adjective),
    InsName.CloseParen:             InsInfo(")",       0xC,       SpeechPart.Syntax),
    InsName.Compose:                InsInfo("@",       0xD,       SpeechPart.Conjunction),
    // DA: `@&` has no meaning
    InsName.Under:                  InsInfo("&.",      0xDA,      SpeechPart.Conjunction),
    // Unassigned: DC: `@)` has no meaning
    // DD: `@@` has no meaning
    InsName.MonadChain:             InsInfo("@.",      0xDD,      SpeechPart.MultiConjunction),
    InsName.Range:                  InsInfo("R",       0xE,       SpeechPart.Verb),
    InsName.Modulus:                InsInfo("%",       0xF0,      SpeechPart.Verb),
    InsName.LastChain:              InsInfo("$^",      0xF10,     SpeechPart.Verb),
    InsName.ThisChain:              InsInfo("$:",      0xF11,     SpeechPart.Verb),
    InsName.NextChain:              InsInfo("$v",      0xF12,     SpeechPart.Verb),
    InsName.NthChain:               InsInfo("$N",      0xF13,     SpeechPart.Adjective),
    InsName.Diagonal:               InsInfo("/:",      0xF14,     SpeechPart.Adjective),
    InsName.Oblique:                InsInfo("/.",      0xF15,     SpeechPart.Adjective),
    InsName.Ternary:                InsInfo("?",       0xF16,     SpeechPart.MultiConjunction),
    InsName.Minimum:                InsInfo("<.",      0xF17,     SpeechPart.Verb),
    InsName.Maximum:                InsInfo(">.",      0xF18,     SpeechPart.Verb),
    InsName.OnLeft:                 InsInfo("[",       0xF19,     SpeechPart.Adjective),
    InsName.OnRight:                InsInfo("]",       0xF1A,     SpeechPart.Adjective),
    InsName.Generate:               InsInfo("G",       0xF1B,     SpeechPart.Adjective),
    InsName.Inverse:                InsInfo("!.",      0xF1C,     SpeechPart.Adjective),
    InsName.Power:                  InsInfo("^:",      0xF1D,     SpeechPart.Conjunction),
    InsName.Print:                  InsInfo("echo",    0xF1E,     SpeechPart.Verb),
    InsName.Scan:                   InsInfo("\\..",    0xF1F,     SpeechPart.Conjunction),
    InsName.Link:                   InsInfo(";",       0xF2,      SpeechPart.Verb),
    InsName.Binomial:               InsInfo("!",       0xF3,      SpeechPart.Verb),
    InsName.Equality:               InsInfo("=",       0xF4,      SpeechPart.Verb),
    InsName.LessThan:               InsInfo("<",       0xF5,      SpeechPart.Verb),
    InsName.GreaterThan:            InsInfo(">",       0xF6,      SpeechPart.Verb),
    InsName.MemberIn:               InsInfo("e.",      0xF7,      SpeechPart.Verb),
    InsName.First:                  InsInfo("{",       0xF8,      SpeechPart.Verb),
    InsName.Last:                   InsInfo("}",       0xF9,      SpeechPart.Verb),
    InsName.LessEqual:              InsInfo("<:",      0xFA,      SpeechPart.Verb),
    InsName.GreaterEqual:           InsInfo(">:",      0xFB,      SpeechPart.Verb),
    InsName.Inequality:             InsInfo("~:",      0xFC,      SpeechPart.Verb),
    InsName.Pair:                   InsInfo(",",       0xFD,      SpeechPart.Verb),
    InsName.Exit:                   InsInfo("exit",    0xFE00,    SpeechPart.Verb),
    InsName.Put:                    InsInfo("put",     0xFE01,    SpeechPart.Verb),
    InsName.Putch:                  InsInfo("putch",   0xFE02,    SpeechPart.Verb),
    InsName.Getch:                  InsInfo("getch",   0xFE03,    SpeechPart.Verb),
    InsName.Empty:                  InsInfo("E",       0xFE40,    SpeechPart.Verb),
    InsName.Ascii:                  InsInfo("A",       0xFE41,    SpeechPart.Verb),
    InsName.Alpha:                  InsInfo("L",       0xFE42,    SpeechPart.Verb),
    InsName.ToJSON:                 InsInfo("json",    0xFE50,    SpeechPart.Verb),
    InsName.FromJSON:               InsInfo("unjson",  0xFE51,    SpeechPart.Verb),
    InsName.ReadFile:               InsInfo("read",    0xFE52,    SpeechPart.Verb),
    InsName.WriteFile:              InsInfo("write",   0xFE53,    SpeechPart.Verb),
    InsName.DigitRange:             InsInfo("R:",      0xFE60,    SpeechPart.Verb),
    InsName.Place:                  InsInfo("place",   0xFE61,    SpeechPart.Verb),
    InsName.Hash:                   InsInfo("hash",    0xFE62,    SpeechPart.Verb),
    InsName.NthPrime:               InsInfo("primn",   0xFE70,    SpeechPart.Verb),
    InsName.IsPrime:                InsInfo("primq",   0xFE71,    SpeechPart.Verb),
    InsName.PrimeFactors:           InsInfo("primf",   0xFE72,    SpeechPart.Verb),
    InsName.PrimeFactorsCount:      InsInfo("primo",   0xFE73,    SpeechPart.Verb),
    InsName.UniqPrimeFactors:       InsInfo("primfd",  0xFE74,    SpeechPart.Verb),
    InsName.UniqPrimeFactorsCount:  InsInfo("primod",  0xFE75,    SpeechPart.Verb),
    InsName.PreviousPrime:          InsInfo("prevp",   0xFE76,    SpeechPart.Verb),
    InsName.NextPrime:              InsInfo("nextp",   0xFE77,    SpeechPart.Verb),
    InsName.FirstNPrimes:           InsInfo("prims",   0xFE78,    SpeechPart.Verb),
    InsName.PrimesBelow:            InsInfo("primb",   0xFE79,    SpeechPart.Verb),
    InsName.PrimesBelowCount:       InsInfo("primbo",  0xFE7A,    SpeechPart.Verb),
    InsName.Benil:                  InsInfo("benil",   0xFE80,    SpeechPart.Adjective),
    InsName.Memoize:                InsInfo("M.",      0xFE81,    SpeechPart.Adjective),
    InsName.Keep:                   InsInfo("keep",    0xFE82,    SpeechPart.Adjective),
    InsName.Loop:                   InsInfo("loop",    0xFE83,    SpeechPart.Adjective),
    InsName.BLoop:                  InsInfo("bloop",   0xFE84,    SpeechPart.Conjunction),
    InsName.While:                  InsInfo("while",   0xFE85,    SpeechPart.Conjunction),
    InsName.Time:                   InsInfo("T.",      0xFE86,    SpeechPart.Adjective),
    InsName.DefinedAlias:           InsInfo("(n/a)",   0xFEA0,    SpeechPart.Verb),
    //FEA0-FEBF reserved for aliases
    //TODO: Conjunction/Adjective aliases?
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
            .setIdentity(Atom(BigInt(0)))
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
                (Atom[] a) => Atom(a.sort.array),
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
                (Atom[] a, Atom[] b) => Atom(
                    zip(a, b)
                        .filter!(t => t[1].truthiness)
                        .map!(t => t[0])
                        .array
                ),
                (a, b) => Atom(reshape([atomFor(b)], a)),
                (_1, _2) => Nil.nilAtom,
            )(a, b))
            .setInverse(new Verb("#!.")
                .setMonad(_ => _)
                .setDyad((a, b) => b)
                .setMarkedArity(1)
            )
            .setMarkedArity(1);
        
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
                (Atom[] a, Atom[] b) => Atom(arrayRange(a, b).map!Atom.array),
                (a, Atom[] b) => Atom(duplicateEach(b, a)),
                (Atom[] a, b) => Atom(duplicateEach(a, b)),
                (string a, string b) => Atom(
                    arrayRange(a.atomOrds, b.atomOrds)
                    .map!atomUnords
                    .map!Atom
                    .array
                ),
                (_1, _2) => Nil.nilAtom,
            )(l, r))
            .setMarkedArity(1);
        
        verbs[InsName.Link] = new Verb(";")
            // Wrap
            .setMonad(a => Atom([a]))
            // Link
            .setDyad((a, b) => a.linkWith(b))
            .setMarkedArity(2);
        
        verbs[InsName.Pair] = new Verb(",")
            .setMonad(a => a.match!(
                // Evaluate
                (string s) => Interpreter.evaluate(s),
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
                // Binomial
                (a, b) => Atom(binomial(a, b)),
                (_1, _2) => Nil.nilAtom,
            )(l, r))
            .setMarkedArity(2);
        
        verbs[InsName.First] = new Verb("{")
            // First element
            .setMonad(a =>
                verbs[InsName.First](atomFor(BigInt(0)), a)
            )
            // Index
            .setDyad((l, r) {
                try {
                    return match!(
                        // TODO: index by real?
                        (BigInt b, Atom[] a) =>
                            a[moldIndex(b, a.length)],
                        (BigInt b, string a) =>
                            Atom(to!string(a[moldIndex(b, a.length)])),
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
                (BigInt a) => Atom(a.toBase(2).map!Atom.array),
                a => verbs[InsName.First](
                    Atom(BigInt(-1)),
                    atomFor(a)
                ),
            ))
            // Base conversion
            .setDyad((l, r) => match!(
                (a, b) => Atom(a.toBase(b).map!Atom.array),
                (_1, _2) => Nil.nilAtom,
            )(l, r))
            .setInverse(new Verb("}!.")
                .setMonad(a => a.match!(
                    (Atom[] a) => fromBase(a, 2),
                    _ => Nil.nilAtom,
                ))
                .setDyad((a, b) => match!(
                    (Atom[] a, b) => fromBase(a, b),
                    (_1, _2) => Nil.nilAtom,
                )(a, b))
                .setMarkedArity(1)
            )
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
                _ => Nil.nilAtom,
            ))
            // Greater than
            .setDyad((a, b) => Atom(a > b))
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
            // Lesser of 2
            .setDyad((l, r) => min(l, r))
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
            .setMonad(_ => Nil.nilAtom)
            .setDyad((a, b) => match!(
                (a, Atom[] b) => Atom(b.canFind(atomFor(a))),
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
            // Base Range
            .setDyad((n, base) => match!(
                (n, base) => Atom(baseRange(n, base).map!Atom.array),
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
        
        // Nilads
        verbs[InsName.Empty] = Verb.nilad(Atom(cast(Atom[])[]));
        verbs[InsName.Empty].display = "E";
        
        verbs[InsName.Ascii] = Verb.nilad(Atom(
            iota(95).map!(a => Atom("" ~ cast(char)(32 + a))).array
        ));
        verbs[InsName.Ascii].display = "A";
        
        verbs[InsName.Alpha] = Verb.nilad(Atom("abcdefghijklmnopqrstuvwxyz"));
        verbs[InsName.Alpha].display = "L";
        
        verbs[InsName.Getch] = new Verb("getch")
            .setMonad(_ => atomGetch())
            .setDyad((_1, _2) => atomGetch())
            .setNiladic(true);
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
                .setMonad((Verb v, a) => a.match!(
                    (Atom[] arr) => Atom(arr.map!v.array),
                    (string str) => Atom(
                        str.map!(to!string)
                           .map!Atom
                           .map!v
                           // .map!(a => a.match!(
                               // (Atom[] a) => a.joinToString,
                               // _ => a.as!string,
                           // ))
                           .joinToString
                    ),
                    _ => Nil.nilAtom,
                ))
                // zip
                .setDyad((Verb v, a, b) => match!(
                    (Atom[] a, Atom[] b) => Atom(zip(a, b).map!(t => v(t[0], t[1])).array),
                    (string a, string b) => Atom(
                        zip(a, b).map!(t => v(t[0].to!string, t[1].to!string)).joinToString
                    ),
                    // TODO: maybe don't call Atom every iteration?
                    (Atom[] a, b) => Atom(a.map!(t => v(t, Atom(b))).array),
                    (string a, b) => Atom(a.map!(t => v(t.to!string, Atom(b))).joinToString),
                    (a, Atom[] b) => Atom(b.map!(t => v(Atom(a), t)).array),
                    (a, string b) => Atom(b.map!(t => v(Atom(a), t.to!string)).joinToString),
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
        
        // ArityForce
        adjectives[InsName.ArityForce] = new Adjective(
            // TODO: copy better, e.g. inverse
            (Verb v) => new Verb("`")
                .setMonad((Verb v, a) => v(a))
                .setDyad((Verb v, a, b) => v(a, b))
                .setMarkedArity(v.markedArity == 2 ? 1 : 2)
                .setInverse(Verb.unimplemented)
                .setChildren([v])
        );
        
        // OnLeft
        adjectives[InsName.OnLeft] = new Adjective(
            (Verb v) => new Verb("[")
                .setMonad((Verb v, a) => v(a))
                .setDyad((Verb v, a, b) => v(a))
                .setMarkedArity(2)
                .setChildren([v])
        );
        
        // OnRight
        adjectives[InsName.OnRight] = new Adjective(
            (Verb v) => new Verb("]")
                .setMonad((Verb v, a) => v(a))
                .setDyad((Verb v, a, b) => v(b))
                .setMarkedArity(2)
                .setChildren([v])
        );
        
        // OnPrefixes
        adjectives[InsName.OnPrefixes] = new Adjective(
            (Verb v) => new Verb("\\.")
                .setMonad((Verb v, a) => a.match!(
                    (Atom[] a) => Atom(
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
                    (BigInt a, Atom[] arr) {
                        import std.math.rounding;
                        bool discrete = a < 0;
                        uint n = (discrete ? -a : a).to!uint;
                        if(discrete) {
                            uint size = 
                                ceil(1.0 * arr.length / n).to!uint;
                            return Atom(
                                iota(size)
                                    .map!(i => i * n)
                                    .map!(i => arr[i..min($, i + n)])
                                    .map!Atom
                                    .map!v
                                    .array
                            );
                        }
                        else {
                            return Atom(
                                iota(arr.length + 1 - n)
                                    .map!(i => arr[i..i + n])
                                    .map!Atom
                                    .map!v
                                    .array
                            );
                        }
                    },
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
        
        // Generate
        adjectives[InsName.Generate] = new Adjective(
            (Verb v) => new Verb("G")
                .setMonad((Verb v, a) {
                    auto ind = BigInt(0);
                    while(!v(Atom(ind), a).truthiness) {
                        ind++;
                    }
                    return Atom(ind);
                })
                .setDyad((Verb v, i, a) {
                    auto ind = i;
                    while(!v(ind, a).truthiness) {
                        ind = ind + 1;
                    }
                    return ind;
                })
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
    }
    
    Adjective* adjective = name in adjectives;
    assert(adjective, "No such adjective: " ~ to!string(name));
    return *adjective;
}

Conjunction getConjunction(InsName name) {
    static Conjunction[InsName] conjunctions;
    
    if(!conjunctions) {
         conjunctions[InsName.Bond] = new Conjunction(
            (Verb f, Verb g) {
                auto markedArity = 
                    f.niladic || g.niladic
                        ? 1
                        : g.markedArity;
                return new Verb("&")
                    .setMonad((f, g, a) =>
                        f.niladic
                            ? g(f(), a)
                            : g.niladic
                                ? f(a, g())
                                : f(g(a)))
                    // TODO: niladic as per above
                    .setDyad((f, g, a, b) =>
                        f(g(a), g(b)))
                    .setMarkedArity(markedArity)
                    .setInverseMutual(new Verb("!.")
                        // (f&n)!. => f!.&n
                        // (n&g)!. => n&(g!.)
                        .setMonadSelf((Verb v, a) {
                            return v.inverse.monad.match!(
                                t => t(v.f.invert(), v.g.invert(), a),
                                _ => assert(0, "Improperly initialized `&` Verb")
                            );
                        })
                        .setDyad((f, g, _1, _2) => Nil.nilAtom)
                        .setMarkedArity(markedArity)
                        .setChildren([f, g])
                    )
                    .setChildren([f, g]);
            }
        );
        
        conjunctions[InsName.Compose] = new Conjunction(
            (Verb f, Verb g) => new Verb("@")
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
                .setChildren([f, g])
        );
        
        conjunctions[InsName.Power] = new Conjunction(
            (Verb f, Verb g) => powerFor(f, g),
        );
        
        conjunctions[InsName.Under] = new Conjunction(
            (Verb f, Verb g) {
                assert(g.invertable(), "Cannot invert " ~ g.display);
                return new Verb("&.")
                    .setMonad((f, g, a) => g.inverse(f(g(a))))
                    .setDyad((f, g, a, b) => g.inverse(f(g(a), g(b))))
                    .setMarkedArity(1)
                    .setChildren([f, g]);
            }
        );
        
        conjunctions[InsName.Scan] = new Conjunction(
            (Verb f, Verb seedFn) => new Verb("\\..")
                .setMonad((f, g, a) => a.match!(
                    (Atom[] arr) {
                        // TODO: relegate a specific atom for
                        // using f's identity as seed?
                        Atom seed = seedFn(a);
                        return Atom(arr.scanThrough(f, seed));
                    },
                    _ => Nil.nilAtom,
                ))
                .setDyad((f, g, _1, _2) => Nil.nilAtom)
                .setMarkedArity(1)
                .setChildren([f, seedFn])
        );
        
        conjunctions[InsName.While] = new Conjunction(
            (Verb f, Verb g) => new Verb("while")
                .setMonad((exec, cond, a) {
                    while(cond(a).truthiness) {
                        a = exec(a);
                    }
                    return a;
                })
                .setDyad((exec, cond, a, b) {
                    while(cond(a, b).truthiness) {
                        a = exec(a, b);
                    }
                    return a;
                })
                .setMarkedArity(1)
                .setChildren([f, g])
        );
        
        // BLoop
        // aka: do while, but cute sounding
        // bloop!
        conjunctions[InsName.BLoop] = new Conjunction(
            (Verb f, Verb g) => new Verb("bloop")
                .setMonad((Verb v, Verb g, a) {
                    while(g(a = v(a)).truthiness) {
                        
                    }
                    return a;
                })
                .setDyad((_1, _2) => Nil.nilAtom)
                .setMarkedArity(1)
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
                return new Verb("O")
                    .setMonad(_ => Nil.nilAtom)
                    .setDyad((Verb[] verbs, x, y) {
                        Verb f = verbs[0];
                        Verb g = verbs[1];
                        Verb h = verbs[2];
                        return g(f(x), h(y));
                    })
                    .setMarkedArity(verbs[0].niladic || verbs[2].niladic ? 1 : 2)
                    .setChildren(verbs);
            }
        );
        
        multiConjunctions[InsName.MonadChain] = new MultiConjunction(
            0, // greedy
            (Verb[] verbs) {
                if(verbs.length == 1) {
                    // TODO: include information
                    return verbs[0];
                }
                assert(verbs.length > 1, "Cannot multi-compose with this many verbs");
                return new Verb("@.")
                    // reversed so that we fold from right to left
                    // TODO: just implement a reduceRight function instead of this chicanery
                    .setMonad((Verb[] verbs, y) => reduce!((atom, v) => v(atom))(y, verbs.retro.array))
                    .setDyad((Verb[] verbs, a, b) {
                        auto reversed = verbs.retro.array;
                        return reduce!((atom, v) => v(atom))(
                            reversed[0](a, b), reversed[1..$]
                        );
                    })
                    .setMarkedArity(1)
                    .setChildren(verbs);
            }
        );
         
        multiConjunctions[InsName.Ternary] = new MultiConjunction(
            3,
            (Verb[] verbs) {
                return new Verb("?")
                    .setMonad((Verb[] verbs, a) {
                        Verb ifTrue = verbs[0];
                        Verb ifFalse = verbs[1];
                        Verb condition = verbs[2];
                        return condition(a).truthiness
                            ? ifTrue(a)
                            : ifFalse(a);
                    })
                    .setDyad((Verb[] verbs, a, b) {
                        Verb ifTrue = verbs[0];
                        Verb ifFalse = verbs[1];
                        Verb condition = verbs[2];
                        return condition(a, b).truthiness
                            ? ifTrue(a, b)
                            : ifFalse(a, b);
                    })
                    .setMarkedArity(verbs[2].markedArity)
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