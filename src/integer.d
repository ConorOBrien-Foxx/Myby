module myby.integer;

import std.bigint;
import std.algorithm.searching : maxElement;
import std.traits : isUnsigned;

import myby.nibble;

/*
 * Integer encoding (0b000yxxxx...)
 *  Integer type (y=0):
 *    | xxxx | corresponding value
 *    | 0 | 0
 *    | 1 | 1
 *    | 2 | 2
 *    | 3 | 3
 *    | 4 | 4
 *    | 5 | 5
 *    | 6 | -2 (USED TO BE 8)
 *    | 7 | -1 (USED TO BE 9)
 *    | 8 | 10
 *    | 9 | Overridden: ?.
 *    | a | A pair of numbers
 *    | b | A real number x.y encoded using the next two integers (x and y)
 *    | cw | A special constant encoded using the next nibble
 *    | c0 | 6
 *    | c1 | 1000
 *    | c2 | 16
 *    | c3 | 32
 *    | c4 | 64
 *    | c5 | 128
 *    | c6 | 256
 *    | c7 | 15
 *    | c8 | 1024
 *    | c9 | 100
 *    | ca | 255
 *    | cb | 1000000
 *    | cc | 8 (USED TO BE -2)
 *    | cd | 9 (USED TO BE -1)
 *    | ce | A triple of numbers
 *    | cfq* | A series of q numbers in a row
 *    | dww  | A number encoded using the next two nibbles
 *    |      | (The first 256 integers not otherwise encoded above)
 *    | eqw* | A negative number encoding the next q nibbles
 *    | fqw* | A positive number encoding the next q nibbles (otherwise not encoded above)
 */

enum BaseConstants = [
    0, 1, 2, 3, 4,
    5, -2, -1, 10
];

enum OneMillionPlaceholder = -3; // limits inferred cache size
enum OneMillion = 1000000;
enum ExtraConstants = [
    6, 1000, 16, 32, 64,
    128, 256, 15, 1024,
    100, 255,
    OneMillionPlaceholder, 8, 9
];
enum HIGHEST_NEGATIVE = -3;

static uint[256] extraCacheLower;
static BigInt[ExtraConstants.maxElement - extraCacheLower.length] extraCacheUpper;
static ulong firstFreeOffset;
void initializeExtraCache() {
    import std.algorithm.searching : canFind;
    
    if(extraCacheLower[0] != 0) {
        // the cache is already initialized
        return;
    }
    
    uint counter = 0;
    void nextCounter() {
        // increment counter to avoid clashes
        do {
            counter++;
        } while(BaseConstants.canFind(counter) || ExtraConstants.canFind(counter));
    }
    
    for(uint i = 0; i < extraCacheLower.length; i++) {
        nextCounter();
        extraCacheLower[i] = counter;
    }
    for(uint i = 0; i < extraCacheUpper.length; i++) {
        nextCounter();
        extraCacheUpper[i] = counter;
    }
    firstFreeOffset = counter - extraCacheUpper.length + 1;
}
uint getExtraCacheLower(T)(T n) {
    initializeExtraCache();
    return extraCacheLower[n];
}
BigInt getExtraCacheUpper(T)(T n) {
    initializeExtraCache();
    if(n < extraCacheUpper.length) {
        return extraCacheUpper[cast(uint)n];
    }
    else {
        auto res = BigInt(firstFreeOffset + n);
        // to account for the number not technically in our cache
        if(res >= OneMillion) res++;
        return res;
    }
}

// TODO: specific function for integerToNibbles[1..$]
Nibble[] numberListToNibbles(T)(T[] ns) {
    Nibble[] arr = [0x0];
    if(ns.length == 2) {
        arr ~= 0xA;
        static foreach(i; 0 .. 2) {
            arr ~= integerToNibbles(ns[i])[1..$];
        }
    }
    else if(ns.length == 3) {
        arr ~= [0xC, 0xE];
        static foreach(i; 0 .. 3) {
            arr ~= integerToNibbles(ns[i])[1..$];
        }
    }
    else {
        arr ~= [0xC, 0xF];
        arr ~= integerToNibbles(BigInt(ns.length))[1..$];
        foreach(n; ns) {
            arr ~= integerToNibbles(n)[1..$];
        }
    }
    return arr;
}

BigInt[] nibblesToNumberList(Nibble[] nibbles, ref uint i) {
    // TODO: mixed list of numbers and reals
    import std.range : retro;
    
    assert(nibbles[i] == 0x0, "Trying to parse non-list as list");
    
    i++;
    BigInt[] result;
    
    if(nibbles[i] == 0xA) {
        i++;
        result ~= nibblesToInteger(nibbles, i, true);
        result ~= nibblesToInteger(nibbles, i, true);
    }
    else if(nibbles[i] == 0xC && nibbles[i + 1] == 0xE) {
        i += 2;
        result ~= nibblesToInteger(nibbles, i, true);
        result ~= nibblesToInteger(nibbles, i, true);
        result ~= nibblesToInteger(nibbles, i, true);
    }
    else if(nibbles[i] == 0xC && nibbles[i + 1] == 0xF) {
        i += 2;
        BigInt count = nibblesToInteger(nibbles, i, true);
        while(count > 0) {
            count--;
            result ~= nibblesToInteger(nibbles, i, true);
        }
    }
    else {
        assert(0, "Trying to parse non-list as list");
    }
    
    return result;
}

Nibble[] integerToNibbles(T)(T n)
if(!isUnsigned!T) {
    import std.algorithm.searching : countUntil;
    import std.conv : to;
    // import std.stdio;
    // import myby.debugger;
    // Debugger.print("Encoding integer: ", n);
    
    initializeExtraCache();
    
    Nibble[] arr = [0x0];
    ptrdiff_t index;
    if((index = BaseConstants.countUntil(n)) >= 0) {
        arr ~= cast(Nibble)index;
    }
    else if((index = ExtraConstants.countUntil(n)) >= 0 && n != OneMillionPlaceholder) {
        arr ~= [0xC, cast(Nibble)index];
    }
    else if(n == OneMillion) {
        arr ~= [0xC, cast(Nibble)ExtraConstants.countUntil(OneMillionPlaceholder)];
    }
    else if((index = extraCacheLower[].countUntil(n)) >= 0) {
        arr ~= 0xD;
        auto targetDigits = toBase16(index);
        for(uint i = 0; i < 2 - targetDigits.length; i++) {
            arr ~= 0x0;
        }
        arr ~= targetDigits;
    }
    else {
        BigInt targetIndex;
        // Debugger.print(typeid(n), " ", n, " ", n <= HIGHEST_NEGATIVE);
        if(n <= HIGHEST_NEGATIVE) {
            // Debugger.print("Encoding negative ", n);
            targetIndex = HIGHEST_NEGATIVE - BigInt(n);
            arr ~= 0xE;
        }
        else {
            if(n <= extraCacheUpper[$ - 1]) {
                // Debugger.print("Should find ", n, " in upper cache");
                targetIndex = extraCacheUpper[].countUntil(n);
            }
            else {
                // Debugger.print("Should find ", n, " beyond upper cache");
                // TODO: figure out what this constant 0x119(281) is
                // TODO: really actually do this, it depends on BaseConstants.length
                // somehow. constant changed to 0x118(280).
                // i guess i'll never do this. constant changed again to 0x115(277).
                // post overridden, changed to 0x114(276)
                targetIndex = n - 0x114;
                if(n > OneMillion) targetIndex--;
            }
            arr ~= 0xF;
        }
        assert(targetIndex >= 0, "Could not find " ~ n.to!string ~ " in cache");
        Nibble[] targetDigits = toBase16(targetIndex);
        // Debugger.print("Target index: ", targetIndex);
        // Debugger.print("Target digits: ", targetDigits);
        
        // encode the length
        for(int i = 0; i < targetDigits.length / 15; i++) {
            arr ~= 0xF;
        }
        arr ~= cast(Nibble)(targetDigits.length % 15);
        arr ~= targetDigits;
    }
    
    // Debugger.print("Result of ", n, " = ", arr);
    return arr;
}

enum REPEAT_FLAG = BigInt("0xFFFFFFFFFFFFFFF");
BigInt nibblesToInteger(Nibble[] nibbles, ref uint i, bool isExtra = false) {
    // TODO: only modify i after successful parse.
    // right now, the current behavior is, on a failed assertion,
    // the program will crash. trying to recover from this crash
    // will leave i modified. this is undesirable for a theoretical
    // smart recovery.
    
    if(!isExtra) {
        assert(nibbles[i] == 0x0, "Trying to parse a non-integer as an integer");

        i++;
    }
    
    BigInt res = BigInt("0");
    if(nibbles[i] < BaseConstants.length) {
        res = BaseConstants[nibbles[i]];
    }
    else if(nibbles[i] == 0xA) {
        assert(isExtra, "Cannot parse a list as an integer");
    }
    else if(nibbles[i] == 0xB) {
        assert(isExtra, "Cannot parse a real as an integer");
    }
    else if(nibbles[i] == 0xC) {
        auto next = nibbles[++i];
        if(next < ExtraConstants.length) {
            res = ExtraConstants[next];
            if(res == OneMillionPlaceholder) res = OneMillion;
        }
        else if(next == 0xE || next == 0xF) {
            assert(isExtra, "Cannot parse a list as an integer");
        }
    }
    else if(nibbles[i] == 0xD) {
        int index = nibbles[++i] * 16 + nibbles[++i];
        res = getExtraCacheLower(index);
    }
    else {
        bool isNegative = nibbles[i] == 0xE;
        
        int count = 0;
        do {
            count += nibbles[++i];
        } while(nibbles[i] == 15);
        
        BigInt index = BigInt("0");
        for(int j = 0; j < count; j++) {
            index *= 16;
            index += nibbles[++i];
        }
        
        if(isNegative) {
            // negative integers, "starting" with -3
            res = HIGHEST_NEGATIVE - index;
        }
        else {
            res = getExtraCacheUpper(index);
        }
    }
    i++;
    
    return res;
}
BigInt nibblesToInteger(Nibble[] nibbles) {
    uint i = 0;
    return nibblesToInteger(nibbles, i);
}

unittest {
    import myby.test : assertEqual;
    import std.algorithm : each, substitute;
    // don't test for underyling representation, just test for correctness in encode/decode
    void assertCorrectEncodeDecode(T)(T n) {
        BigInt big = n;
        Nibble[] encoded = integerToNibbles(big);
        BigInt decoded = nibblesToInteger(encoded);
        assertEqual(big, decoded);
    }
    
    assertCorrectEncodeDecode(BaseConstants[0]);

    BaseConstants.each!(n => assertCorrectEncodeDecode(n));
    ExtraConstants
        .substitute(OneMillionPlaceholder, OneMillion)
        .each!(n => assertCorrectEncodeDecode(n));
}

Nibble[] realToNibbles(BigInt iPart, BigInt fPart)
out(r; r.length >= 4, "Must return 0x0B and at least 1 nibble for each part")
{
    return cast(Nibble[]) [0x0, 0xB]
        ~ integerToNibbles(iPart)[1..$]
        ~ integerToNibbles(fPart)[1..$];
}

real nibblesToReal(Nibble[] nibbles, ref uint i) {
    import std.range : retro;
    
    assert(nibbles[i] == 0x0 && nibbles[i + 1] == 0xB, "Trying to parse non-real as real");
    // skip over the two nibbles in the indicator 0x0B
    i += 2;
    BigInt ip = nibblesToInteger(nibbles, i, true);
    BigInt fp = nibblesToInteger(nibbles, i, true);
    real sign = 1.0;

    if(ip == 0 && fp < 0) {
        // exchange signs: allow `0.-3` to represent `-0.3`, because `-0` isn't a thing
        sign = -1.0;
        fp = -fp;
    }

    assert(fp >= 0, "Fraction part cannot be negative");
    
    string fpStr = fp.toDecimalString();
    real fpSize = fpStr.length;
    BigInt fpRev = BigInt(fpStr.retro);
    
    real first = cast(real)ip;
    real second = cast(real)fpRev * 10.0^^-fpSize;
    
    // match signs so addition is concatenation
    if(first < 0) second *= -1;
    
    return sign * (first + second);
}

// tests handled in the Ruby script
