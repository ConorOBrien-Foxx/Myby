module myby.instructions;

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
import myby.interpreter : Interpreter;
import myby.json;
import myby.manip;
import myby.nibble;
import myby.prime;
import myby.speech;

enum InsName {
    Integer, ListLiteral, Real, String, Filter, Map, Add, Subtract, Multiply,
    Divide, Exponentiate, Identity, Bond, OnPrefixes, OnSuffixes, MinMax,
    SplitCompose, OpenParen, ArityForce, Vectorize, Reflex, CloseParen,
    Compose, Under, Hook, MonadChain, Range, Modulus, LastChain, ThisChain,
    Link, Diagonal, Oblique, Ternary, Minimum, Maximum, OnLeft, OnRight,
    Generate, Inverse, Power, Print, Scan, Pad, Binomial, Equality, LessThan,
    GreaterThan, MemberIn, First, Last, LessEqual, GreaterEqual, Inequality,
    Pair, NextChain, NthChain, Exit, Put, Putch, Getch, Empty, Ascii, Alpha,
    ToJSON, FromJSON, ReadFile, WriteFile, DigitRange, Place, Hash, NthPrime,
    IsPrime, PrimeFactors, PrimeFactorsCount, UniqPrimeFactors, Divisors,
    UniqPrimeFactorsCount, PreviousPrime, NextPrime, FirstNPrimes, ApplyAt,
    PrimesBelow, PrimesBelowCount, Benil, Memoize, Keep, Loop, BLoop, While,
    Time, InitialAlias, DefinedAlias, VerbDiagnostic, F, G, H, U, V, C, D,
    Break, Gerund, LineFeed, PrimeTotient, IsAlpha, IsNumeric, IsAlphaNumeric,
    IsUppercase, IsLowercase, IsBlank, KeepAlpha, KeepNumeric, DotProduct,
    KeepAlphaNumeric, KeepUppercase, KeepLowercase, KeepBlank, Palindromize,
    Inside, ChunkBy, Left, Right, FromBase, ToBase, LeftMap, SysTime, Year,
    Month, Day, Hour, Minute, Second, Vowels, Consonants, Random,
    Subset, Subseteq, Superset, Superseteq, FactorExponents,
    FactorExponentPairs, FactorExponentsPos, FactorExponentPairsPos,
    Invariant, Variant,
    None,
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
// Note on "no meaning": This arises due to the fact that conjunctions
// and adjectives can only appear in specific places; therefore such
// extensions must continue to be adjectives/conjunctions, else they
// create ambiguity. e.g., if AA was a noun K, then the sequence (K)
// would be parsed as BAAC <=> (BA)(AC) <=> `:\: which is wrong.
// However, if AA was an adjective K, then the sequence (K) would never
// appear in code for the same reason (& never appears in code.
enum InsInfo[InsName] Info = [
    // Integer: 0
    InsName.Random:                 InsInfo("?.",      0x09,      SpeechPart.Verb),
    // String: 1
    InsName.LineFeed:               InsInfo("lf",      0x12,      SpeechPart.Verb),
    InsName.LeftMap:                InsInfo("\":" ,    0x19,      SpeechPart.Adjective),
    InsName.FromBase:               InsInfo("#." ,     0x1A,      SpeechPart.Verb),
    InsName.ToBase:                 InsInfo("#:",      0x1B,      SpeechPart.Verb),
    InsName.Left:                   InsInfo("[" ,      0x1C,      SpeechPart.Verb),
    InsName.Right:                  InsInfo("]",       0x1D,      SpeechPart.Verb),
    // Instructions: 2-F
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
    // AC: `&)` has no meaning
    InsName.OnSuffixes:             InsInfo("\\:",     0xAC,      SpeechPart.Adjective),
    // AD: `&@` has no meaning
    InsName.SplitCompose:           InsInfo("O",       0xAD,      SpeechPart.MultiConjunction),
    // Unassigned (maybe): ADAD/ACAC/etc
    InsName.OpenParen:              InsInfo("(",       0xB,       SpeechPart.Syntax),
    // B2: `(\` has no meaning
    InsName.Gerund:                 InsInfo("`",       0xB2,      SpeechPart.Conjunction),
    // B3: `("` has no meaning
    InsName.DotProduct:             InsInfo(".",       0xB3,      SpeechPart.Conjunction),
    // BA: `(` followed by A... (A `&` AA `\.` AC `\:` AD `O`) has no meaning
    InsName.ArityForce:             InsInfo("`:",      0xBA,      SpeechPart.Adjective),
    // BC: `()` has no meaning
    InsName.Vectorize:              InsInfo("V",       0xBC,      SpeechPart.Adjective),
    // BD: `(` followed by D... (D `@` DA `&.` DC `H` DD `@.`) has no meaning
    InsName.Reflex:                 InsInfo("~",       0xBD,      SpeechPart.Adjective),
    InsName.CloseParen:             InsInfo(")",       0xC,       SpeechPart.Syntax),
    InsName.Compose:                InsInfo("@",       0xD,       SpeechPart.Conjunction),
    // psuedo command sequence - sugar for `@[` and `@]` respectively
    InsName.OnLeft:                 InsInfo("[.",      0xD1C,     SpeechPart.Adjective),
    InsName.OnRight:                InsInfo("].",      0xD1D,     SpeechPart.Adjective),
    // DA: `@&` has no meaning
    InsName.Under:                  InsInfo("&.",      0xDA,      SpeechPart.Conjunction),
    // DC: `@)` has no meaning
    InsName.Hook:                   InsInfo("H",       0xDC,      SpeechPart.MultiConjunction),
    // DD: `@@` has no meaning
    InsName.MonadChain:             InsInfo("@.",      0xDD,      SpeechPart.MultiConjunction),
    InsName.Range:                  InsInfo("R",       0xE,       SpeechPart.Verb),
    InsName.Modulus:                InsInfo("%",       0xF0,      SpeechPart.Verb),
    InsName.LastChain:              InsInfo("$^",      0xF10,     SpeechPart.Verb),
    InsName.ThisChain:              InsInfo("$:",      0xF11,     SpeechPart.Verb),
    InsName.ChunkBy:                InsInfo("C",       0xF12,     SpeechPart.Adjective),
    InsName.Divisors:               InsInfo("D",       0xF13,     SpeechPart.Verb),
    InsName.Diagonal:               InsInfo("/:",      0xF14,     SpeechPart.Adjective),
    InsName.Oblique:                InsInfo("/.",      0xF15,     SpeechPart.Adjective),
    InsName.Ternary:                InsInfo("?",       0xF16,     SpeechPart.MultiConjunction),
    InsName.Minimum:                InsInfo("<.",      0xF17,     SpeechPart.Verb),
    InsName.Maximum:                InsInfo(">.",      0xF18,     SpeechPart.Verb),
    InsName.ApplyAt:                InsInfo("@:",      0xF19,     SpeechPart.Conjunction),
    //F1A
    InsName.Generate:               InsInfo("G",       0xF1B,     SpeechPart.Adjective),
    InsName.Inverse:                InsInfo("!.",      0xF1C,     SpeechPart.Adjective),
    InsName.Power:                  InsInfo("^:",      0xF1D,     SpeechPart.Conjunction),
    InsName.Print:                  InsInfo("echo",    0xF1E,     SpeechPart.Verb),
    InsName.Scan:                   InsInfo("\\..",    0xF1F,     SpeechPart.Conjunction),
    InsName.Pad:                    InsInfo("P",       0xF2,      SpeechPart.Verb),
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
    ////FE0* - I/O////
    InsName.Exit:                   InsInfo("exit",    0xFE00,    SpeechPart.Verb),
    InsName.Put:                    InsInfo("put",     0xFE01,    SpeechPart.Verb),
    InsName.Putch:                  InsInfo("putch",   0xFE02,    SpeechPart.Verb),
    InsName.Getch:                  InsInfo("getch",   0xFE03,    SpeechPart.Verb),
    InsName.ToJSON:                 InsInfo("json",    0xFE04,    SpeechPart.Verb),
    InsName.FromJSON:               InsInfo("unjson",  0xFE05,    SpeechPart.Verb),
    InsName.ReadFile:               InsInfo("read",    0xFE06,    SpeechPart.Verb),
    InsName.WriteFile:              InsInfo("write",   0xFE07,    SpeechPart.Verb),
    ////FE1* - reflection////
    InsName.NextChain:              InsInfo("$v",      0xFE10,    SpeechPart.Verb),
    InsName.NthChain:               InsInfo("$N",      0xFE11,    SpeechPart.Adjective),
    ////FE2* - string////
    InsName.Palindromize:           InsInfo("enpal",   0xFE20,    SpeechPart.Verb),
    InsName.Inside:                 InsInfo("inner",   0xFE21,    SpeechPart.Verb),
    // InsName.MatchCase:              InsInfo("mcase",   0xFE22,    SpeechPart.Verb),
    ////FE3* - class tests////
    InsName.IsAlpha:                InsInfo("alq",     0xFE30,    SpeechPart.Verb),
    InsName.IsNumeric:              InsInfo("numq",    0xFE31,    SpeechPart.Verb),
    InsName.IsAlphaNumeric:         InsInfo("alnumq",  0xFE32,    SpeechPart.Verb),
    InsName.IsUppercase:            InsInfo("upq",     0xFE33,    SpeechPart.Verb),
    InsName.IsLowercase:            InsInfo("downq",   0xFE34,    SpeechPart.Verb),
    InsName.IsBlank:                InsInfo("blankq",  0xFE35,    SpeechPart.Verb),
    InsName.KeepAlpha:              InsInfo("alk",     0xFE38,    SpeechPart.Verb),
    InsName.KeepNumeric:            InsInfo("numk",    0xFE39,    SpeechPart.Verb),
    InsName.KeepAlphaNumeric:       InsInfo("alnumk",  0xFE3A,    SpeechPart.Verb),
    InsName.KeepUppercase:          InsInfo("upk",     0xFE3B,    SpeechPart.Verb),
    InsName.KeepLowercase:          InsInfo("downk",   0xFE3C,    SpeechPart.Verb),
    InsName.KeepBlank:              InsInfo("blankk",  0xFE3D,    SpeechPart.Verb),
    ////FE4* - constants////
    InsName.Empty:                  InsInfo("E",       0xFE40,    SpeechPart.Verb),
    InsName.Ascii:                  InsInfo("A",       0xFE41,    SpeechPart.Verb),
    InsName.Alpha:                  InsInfo("L",       0xFE42,    SpeechPart.Verb),
    InsName.Vowels:                 InsInfo("vow",     0xFE43,    SpeechPart.Verb),
    InsName.Consonants:             InsInfo("con",     0xFE44,    SpeechPart.Verb),
    ////FE5* - time////
    InsName.SysTime:                InsInfo("time",    0xFE50,    SpeechPart.Verb),
    InsName.Year:                   InsInfo("yr"  ,    0xFE51,    SpeechPart.Verb),
    InsName.Month:                  InsInfo("mo",      0xFE52,    SpeechPart.Verb),
    InsName.Day:                    InsInfo("dy",      0xFE53,    SpeechPart.Verb),
    InsName.Hour:                   InsInfo("hr",      0xFE54,    SpeechPart.Verb),
    InsName.Minute:                 InsInfo("mn",      0xFE55,    SpeechPart.Verb),
    InsName.Second:                 InsInfo("sc",      0xFE56,    SpeechPart.Verb),
    ////FE6* - range////
    InsName.DigitRange:             InsInfo("R:",      0xFE60,    SpeechPart.Verb),
    InsName.Place:                  InsInfo("place",   0xFE61,    SpeechPart.Verb),
    InsName.Hash:                   InsInfo("hash",    0xFE62,    SpeechPart.Verb),
    InsName.Subset:                 InsInfo("(.",      0xFE63,    SpeechPart.Verb),
    InsName.Subseteq:               InsInfo("(..",     0xFE64,    SpeechPart.Verb),
    InsName.Superset:               InsInfo(").",      0xFE65,    SpeechPart.Verb),
    InsName.Superseteq:             InsInfo(")..",     0xFE66,    SpeechPart.Verb),
    InsName.MinMax:                 InsInfo("minmax",  0xFE67,    SpeechPart.Verb),
    ////FE7* - primes
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
    InsName.PrimeTotient:           InsInfo("primt",   0xFE7B,    SpeechPart.Verb),
    InsName.FactorExponents:        InsInfo("pfe",     0xFE7C,    SpeechPart.Verb),
    InsName.FactorExponentPairs:    InsInfo("pfeb",    0xFE7D,    SpeechPart.Verb),
    InsName.FactorExponentsPos:     InsInfo("pfep",    0xFE7E,    SpeechPart.Verb),
    InsName.FactorExponentPairsPos: InsInfo("pfebp",   0xFE7F,    SpeechPart.Verb),
    ////FE8* - advanced adj/conj////
    InsName.Benil:                  InsInfo("benil",   0xFE80,    SpeechPart.Adjective),
    InsName.Memoize:                InsInfo("M.",      0xFE81,    SpeechPart.Adjective),
    InsName.Keep:                   InsInfo("keep",    0xFE82,    SpeechPart.Adjective),
    InsName.Loop:                   InsInfo("loop",    0xFE83,    SpeechPart.Adjective),
    InsName.BLoop:                  InsInfo("bloop",   0xFE84,    SpeechPart.Conjunction),
    InsName.While:                  InsInfo("while",   0xFE85,    SpeechPart.Conjunction),
    InsName.Time:                   InsInfo("T.",      0xFE86,    SpeechPart.Adjective),
    InsName.VerbDiagnostic:         InsInfo("?:",      0xFE87,    SpeechPart.Adjective),
    InsName.Invariant:              InsInfo("I",       0xFE88,    SpeechPart.Adjective),
    InsName.Variant:                InsInfo("I.",      0xFE89,    SpeechPart.Adjective),
    ////FE9* - list manipulation////
    InsName.Link:                   InsInfo(";",       0xFE90,    SpeechPart.Verb),
    ////FEA* - reserved for aliases////
    ////FEB* - reserved for aliases////
    //TODO: Conjunction/Adjective aliases?
    InsName.DefinedAlias:           InsInfo("(n/a)",   0xFEA0,    SpeechPart.Verb),
    ////FEC* - unassigned////
    ////FED* - high order I/O////
    InsName.F:                      InsInfo("F:",      0xFED0,    SpeechPart.Verb),
    InsName.G:                      InsInfo("G:",      0xFED1,    SpeechPart.Verb),
    InsName.H:                      InsInfo("H:",      0xFED2,    SpeechPart.Verb),
    //FED3: maybe "n-th" verb
    InsName.U:                      InsInfo("U:",      0xFED4,    SpeechPart.Adjective),
    InsName.V:                      InsInfo("V:",      0xFED5,    SpeechPart.Adjective),
    //FED6: maybe "n-th" adjective
    InsName.C:                      InsInfo("C:",      0xFED7,    SpeechPart.Conjunction),
    InsName.D:                      InsInfo("D:",      0xFED8,    SpeechPart.Conjunction),
    ////FEE* - unassigned////
    ////FEF* - miscellaneous////
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

static Verb[InsName] verbs;
public import myby.verbs;
public import myby.adjectives;
public import myby.conjunctions;

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
        
        //   (f g H) a <-> a f (g a)
        // x (f g H) y <-> x f (g y)
        multiConjunctions[InsName.Hook] = new MultiConjunction(
            2,
            (Verb[] verbs) {
                return new Verb("H")
                    .setMonad((Verb[] verbs, a) => verbs[0](a, verbs[1](a)))
                    .setDyad((Verb[] verbs, x, y) =>
                        verbs[0](x, verbs[1](y))
                        // verbs[0](x, verbs[1].markedArity == 1 ? verbs[1](y) : verbs[1](x, y))
                    )
                    .setMarkedArity(2)
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
                    .setNiladic(verbs[$ - 1].niladic)
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