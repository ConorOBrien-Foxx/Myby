module myby.token;

import std.algorithm.iteration : map;
import std.array : join;
import std.bigint;
import std.conv : to;

import myby.instructions;
import myby.nibble;

struct Token {
    SpeechPart speech;
    InsName name = InsName.None;
    union {
        BigInt   big;
        string   str;
        real     dec;
        BigInt[] arr;
    };
    int index = -1;

    @property
    bool isInitialized() {
        return hasIndex && hasName;
    }

    @property
    bool hasName() {
        return name != InsName.None;
    }

    @property
    bool hasIndex() {
        return index != -1;
    }
    
    bool isNilad() {
        return name == InsName.Integer
            || name == InsName.String
            || name == InsName.Real
            || name == InsName.ListLiteral;
    }
    
    string toString() {
        string addendum;
        switch(name) {
            case InsName.Integer:
            case InsName.CloseParen:
                addendum = to!string(big);
                break;
            case InsName.String:
                addendum = str;
                break;
            case InsName.ListLiteral:
                addendum = arr.map!(to!string).join(", ");
                break;
            case InsName.Real:
                addendum = to!string(dec);
                break;
            case InsName.DefinedAlias:
                addendum = big.toBase16.basicNibbleFmt;
                break;
            default:
                break;
        }
        if(addendum) {
            addendum = ' ' ~ addendum;
        }
        return "Token(" ~ to!string(speech)
            ~ " `" ~ to!string(name) ~ "`"
            ~ addendum
            ~ " @" ~ to!string(index)
            ~ ")";
    }

    string toRepresentation() {
        if(!isInitialized) {
            return "(empty)";
        }
        switch(name) {
            case InsName.Integer:
                return big.to!string;
            case InsName.String:
                // TODO: unescape properly
                return "'" ~ str ~ "'";
            case InsName.ListLiteral:
                return arr.map!(to!string).join(" ");
            case InsName.Real:
                return dec.to!string;
            case InsName.DefinedAlias:
                // TODO: use alias listing
                return big.toBase16.basicNibbleFmt;
            default:
                break;
        }
        auto info = name in Info;
        if(info != null) {
            return info.name;
        }
        return "(unknown: " ~ toString ~ ")";
    }
    
    bool opEquals(Token other) {
        return other.speech == speech && other.name == name && (
            big == other.big || str == other.str
        );
    }
    
    static Token Break = Token(SpeechPart.Syntax, InsName.Break);
}
