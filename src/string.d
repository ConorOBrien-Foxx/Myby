module myby.string;

import std.string;

import myby.nibble;

/*
 * String encoding (0b000yzxxx...)
 *  String type (y=1)
 *  If z=0, then we pull from a few character constants, using xxx:
 *   | xxx | Corresponding value |
 *   | 0 | Empty String |
 *   | 1 | Space |
 *   | 2 | Newline |
 *   | 3 | Tab |
 *   | 4 | A |
 *   | 5 | a |
 *   | 6 | 0 |
 *   | 7 | Use next byte to encode character constant |
 * If z=1, then we have a string literal. We have a few options,
 * depending on the value of xxx.
 *  | xxx | Corresponding behavior |
 *  | 0 | Read bytes until matching 00 byte
 *  | 1 | Read bytes until matching FF byte
 *  | 2 | Read bytes until matching F0 byte
 *  | 3 | Read bytes until matching 0F byte
 *  | 4 | Overridden: [
 *  | 5 | Overridden: ]
 *  | 6 | Read bytes until the first bit of a byte is 1 (including ngraphs)
 *  | 7 | Read bytes until the first bit of a byte is 1
 */
 
enum StringConstants = [
    "",
    " ",
    "\n",
    "\t",
    "A",
    "a",
    "0"
];

void appendNibble(ref Nibble[] result, char ch) {
    assert(0 <= ch && ch < 256);
    result ~= ch / 16;
    result ~= ch % 16;
}

enum char[] ValidTerminators = [ 0x00, 0xFF, 0xF0, 0x0F ];
Nibble[] stringToNibblesNaive(string str) {
    import std.algorithm.searching : countUntil;
    import std.stdio;
    
    int index = -1;
    foreach(i, term; ValidTerminators) {
        index = i;
        foreach(ch; str) {
            if(ch == term) {
                index = -1;
                break;
            }
        }
        
        if(index != -1) break;
    }
    
    // we cannot proceed if both terminators exist in the string
    if(index < 0) {
        return [];
    }
    auto term = ValidTerminators[index];
    
    Nibble[] result;
    
    result ~= 0b0001;
    result ~= cast(Nibble)(0b1000 + index);
    
    foreach(ch; str) {
        result.appendNibble(ch);
    }
    result.appendNibble(term);
    
    return result;
}

Nibble[] stringToNibblesASCII(string str) {
    // we use the high bit here to signify EOS, so we cannot encode
    // anything with a native high bit
    foreach(ch; str) {
        if(ch >= 0x80) {
            return [];
        }
    }
    
    Nibble[] result;
    
    result ~= 0b0001;
    result ~= 0b1111;
    
    foreach(ch; str) {
        result.appendNibble(ch);
    }
    
    // mark end of string
    result[$-2] |= 0b1000;
    
    return result;
}

struct EncodingTreeNode {
    EncodingTreeNode[char] children;
    char value = '\0';
    
    this(char v) {
        value = v;
    }
    this(EncodingTreeNode[char] c) {
        children = c;
    }
    
    // auto opBinary(string op : "in")(char rhs) {
        // return rhs in children;
    // }
}

// starting at 0x60, since 0x5F corresponds to '~'
enum NGraphTree = EncodingTreeNode([
    'a': EncodingTreeNode([
        'n': EncodingTreeNode(0x6D),
        't': EncodingTreeNode(0x70),
    ]),
    'c': EncodingTreeNode([
        'c': EncodingTreeNode(0x60),
    ]),
    'e': EncodingTreeNode([
        'a': EncodingTreeNode(0x7B),
        'd': EncodingTreeNode(0x77),
        'e': EncodingTreeNode(0x61),
        'n': EncodingTreeNode(0x76),
        'r': EncodingTreeNode(0x6C),
        's': EncodingTreeNode(0x74),
    ]),
    'f': EncodingTreeNode([
        'f': EncodingTreeNode(0x62),
    ]),
    'h': EncodingTreeNode([
        'a': EncodingTreeNode(0x73),
        'e': EncodingTreeNode(0x6A),
        'i': EncodingTreeNode(0x7C),
    ]),
    'i': EncodingTreeNode([
        'n': EncodingTreeNode(0x6B),
        's': EncodingTreeNode(0x7D),
        't': EncodingTreeNode(0x79),
    ]),
    'l': EncodingTreeNode([
        'l': EncodingTreeNode(0x63),
    ]),
    'n': EncodingTreeNode([
        'd': EncodingTreeNode(0x6F),
        't': EncodingTreeNode(0x72),
    ]),
    'o': EncodingTreeNode([
        'n': EncodingTreeNode(0x71),
        'o': EncodingTreeNode(0x64),
        'r': EncodingTreeNode(0x7E),
        'u': EncodingTreeNode(0x7A),
    ]),
    'p': EncodingTreeNode([
        'p': EncodingTreeNode(0x65),
    ]),
    'r': EncodingTreeNode([
        'e': EncodingTreeNode(0x6E),
        'r': EncodingTreeNode(0x66),
    ]),
    's': EncodingTreeNode([
        's': EncodingTreeNode(0x67),
        't': EncodingTreeNode(0x75),
    ]),
    't': EncodingTreeNode([
        'h': EncodingTreeNode(0x69),
        'i': EncodingTreeNode(0x7F),
        'o': EncodingTreeNode(0x78),
        't': EncodingTreeNode(0x68),
    ]),
]);
enum NGraphLookup = [
    0x60: "cc",     0x61: "ee",     0x62: "ff",     0x63: "ll",
    0x64: "oo",     0x65: "pp",     0x66: "rr",     0x67: "ss",
    0x68: "tt",     0x69: "th",     0x6A: "he",     0x6B: "in",
    0x6C: "er",     0x6D: "an",     0x6E: "re",     0x6F: "nd",
    0x70: "at",     0x71: "on",     0x72: "nt",     0x73: "ha",
    0x74: "es",     0x75: "st",     0x76: "en",     0x77: "ed",
    0x78: "to",     0x79: "it",     0x7A: "ou",     0x7B: "ea",
    0x7C: "hi",     0x7D: "is",     0x7E: "or",     0x7F: "ti",
];

string nibblesToString(Nibble[] nibbles, ref uint i) {
    assert(nibbles[i] == 0x1, "Trying to parse a non-integer as an integer");
    i++;
    string result = "";
    
    // if z == 0
    uint half = nibbles[i] % 8;
    uint z = nibbles[i] >> 3;
    import std.stdio;
    
    if(z == 0) {
        if(half == 7) {
            result ~= nibbles[++i] * 16 + nibbles[++i];
        }
        else {
            result ~= StringConstants[half];
        }
    }
    // if z == 1 and xxx <= 3
    else if(half < ValidTerminators.length) {
        auto term = ValidTerminators[half];
        auto t1 = term / 16;
        auto t2 = term % 16;
        i++;
        while(i + 1 < nibbles.length) {
            if(nibbles[i] == t1 && nibbles[i + 1] == t2) {
                break;
            }
            result ~= nibbles[i] * 16 + nibbles[i+1];
            i += 2;
        }
        i += 2;
    }
    else if(half <= 5) {
        assert(0, "Overridden bytes (not in string)");
    }
    else if(half <= 7) {
        bool usesNGraphs = half == 6;
        while(i + 2 < nibbles.length) {
            uint d1 = nibbles[++i];
            uint d2 = nibbles[++i];
            // zero out highest nibble bit of d1
            uint c = (d1 % 8) * 16 + d2;
            if(!usesNGraphs) {
                result ~= c;
            }
            else if(c < 0x60) {
                result ~= c + 32;
            }
            else {
                result ~= NGraphLookup[c];
            }
            if(d1 >> 3 == 1) {
                break;
            }
        }
    }
    else {
        assert(0, "Malformed string half");
    }
    
    i++;
    
    return result;
}

Nibble[] stringToNibblesNGraphCompress(string str) {
    // we use the high bit here to signify EOS
    // only encodes ASCII, since we smash ngraphs into
    // the other slots
    foreach(ch; str) {
        if(ch < ' ' || ch > '~') {
            return [];
        }
    }
    
    Nibble[] result;
    
    result ~= 0b0001;
    result ~= 0b1110;
    
    for(uint i = 0; i < str.length; i++) {
        char val = cast(char)(str[i] - ' ');
        auto node = str[i] in NGraphTree.children;
        if(node) {
            uint j = i + 1;
            while(j < str.length && node) {
                if(node.value) break;
                node = str[j] in node.children;
            }
            if(node && node.value) {
                val = node.value;
                i = j;
            }
        }
        result.appendNibble(val);
    }
    // mark end of string
    result[$-2] |= 0b1000;
        
    return result;
}

// TODO: make use of the original unused encoding of the
// members of StringConstants
enum CandidateFunctions = [
    &stringToNibblesNaive,
    &stringToNibblesASCII,
    &stringToNibblesNGraphCompress,
];
Nibble[] stringToNibbles(string str) {
    import std.algorithm.searching : countUntil;
    
    if(str.length == 0) {
        return [ 0b0001, 0b0000 ];
    }
    else if(str.length == 1) {
        auto index = StringConstants.countUntil(str);
        if(index >= 0) {
            return [ 0b0001, cast(Nibble)(index) ];
        }
        else {
            // TODO: we don't actually ever need to encode ASCII
            // characters using this scheme.
            auto ch = str[0];
            return [ 0b0001, 0b0111, ch / 16, ch % 16 ];
        }
    }

    // compare methods and select most optimal
    Nibble[] result;
    
    foreach(candidate; CandidateFunctions) {
        Nibble[] test = candidate(str);
        // import std.stdio;
        // writeln("Candidate: ", candidate);
        // writeln("---> ", test);
        if(test.length != 0) {
            if(test.length < result.length || result.length == 0) {
                result = test;
            }
        }
    }
    
    return result;
}
