module myby.integer;

import std.bigint;
import std.algorithm.searching : maxElement;

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
 *    | 6 | 6
 *    | 7 | 7
 *    | 8 | 8
 *    | 9 | 9
 *    | a | 10
 *    | b | A real number encoded using the next two integers
 *    | cw | A special constant encoded using the next nibble
 *    | c0 | 1000
 *    | c1 | 16
 *    | c2 | 32
 *    | c3 | 64
 *    | c4 | 128
 *    | c5 | 256
 *    | c6 | 512
 *    | c7 | 1024
 *    | c8 | 100
 *    | c9 | 255
 *    | ca | 65
 *    | cb | 97
 *    | cc | 1000000
 *    | cd | 48
 *    | ce | -2
 *    | cf | -1
 *    | dww | A number encoded using the next two nibbles
 *    |     | (The first 256 integers not otherwise encoded above)
 *    | eqw* | A negative number encoding the next q nibbles
 *    | fqw* | A positive number encoding the next q nibbles (otherwise not encoded above)
 */

enum BaseConstants = [
    0, 1, 2, 3,
    4, 5, 6, 7,
    8, 9, 10
];

enum OneMillionPlaceholder = -3; // limits inferred cache size
enum OneMillion = 1000000;
enum ExtraConstants = [
    1000, 16, 32, 64,
    128, 256, 512, 1024,
    100, 255, 65, 97,
    OneMillionPlaceholder, 48, -2, -1
];
enum HIGHEST_NEGATIVE = -3;

static uint[256] extraCacheLower;
static BigInt[ExtraConstants.maxElement - extraCacheLower.length] extraCacheUpper;
static uint firstFreeOffset;
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

Nibble[] integerToNibbles(T)(T n) {
    import std.algorithm.searching : countUntil;
    // import std.stdio;
    
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
        if(n <= HIGHEST_NEGATIVE) {
            targetIndex = HIGHEST_NEGATIVE - BigInt(n);
            arr ~= 0xE;
        }
        else {
            if(n <= extraCacheUpper[$ - 1]) {
                targetIndex = extraCacheUpper[].countUntil(n);
            }
            else {
                // TODO: figure out what this constant 0x119(281) is
                // TODO: really actually do this, it depends on BaseConstants.length
                // somehow. constant changed to 0x118(280).
                targetIndex = n - 0x118;
                if(n > OneMillion) targetIndex--;
            }
            arr ~= 0xF;
        }
        Nibble[] targetDigits = toBase16(targetIndex);
        
        // encode the length
        for(int i = 0; i < targetDigits.length / 15; i++) {
            arr ~= 0xF;
        }
        arr ~= cast(Nibble)(targetDigits.length % 15);
        arr ~= targetDigits;
    }
    return arr;
}

enum REPEAT_FLAG = BigInt("0xFFFFFFFFFFFFFFF");
BigInt nibblesToInteger(Nibble[] nibbles, ref uint i, bool isExtra = false) {
    // import std.stdio;
    if(!isExtra) {
        assert(nibbles[i] == 0x0, "Trying to parse a non-integer as an integer");

        i++;
    }
    
    BigInt res = BigInt("0");
    if(nibbles[i] < BaseConstants.length) {
        res = BaseConstants[nibbles[i]];
    }
    else if(nibbles[i] == 0xB) {
        assert(isExtra, "Cannot parse a real as an integer");
    }
    else if(nibbles[i] == 0xC) {
        res = ExtraConstants[nibbles[++i]];
        if(res == OneMillionPlaceholder) res = OneMillion;
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

Nibble[] realToNibbles(BigInt num, BigInt den)
out(r; r.length >= 4, "Must return 0x0B and at least 1 nibble for each part")
{
    return cast(Nibble[]) [0x0, 0xB]
        ~ integerToNibbles(num)[1..$]
        ~ integerToNibbles(den)[1..$];
}

real nibblesToReal(Nibble[] nibbles, ref uint i) {
    import std.range : retro;
    
    i += 2;
    BigInt ip = nibblesToInteger(nibbles, i, true);
    BigInt fp = nibblesToInteger(nibbles, i, true);
    assert(fp > 0, "Fraction part cannot be negative");
    
    string fpStr = fp.toDecimalString();
    real fpSize = fpStr.length;
    BigInt fpRev = BigInt(fpStr.retro);
    
    real first = cast(real)ip;
    real second = cast(real)fpRev * 10.0^^-fpSize;
    
    // match signs so addition is concatenation
    if(first < 0) second *= -1;
    
    return first + second;
}