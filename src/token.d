module myby.token;

import std.bigint;
import std.conv : to;

import myby.instructions;
import myby.nibble;

struct Token {
    SpeechPart speech;
    InsName name;
    union {
        BigInt   big;
        string   str;
        real     dec;
        BigInt[] arr;
    };
    int index = -1;
    
    bool isNilad() {
        return name == InsName.Integer
            || name == InsName.String
            || name == InsName.Real
            || name == InsName.ListLiteral;
    }
    
    string toString() {
        import std.algorithm.iteration : map;
        import std.array : join;
        
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
    
    bool opEquals(Token other) {
        return other.speech == speech && other.name == name && (
            big == other.big || str == other.str
        );
    }
    
    static Token Break = Token(SpeechPart.Syntax, InsName.Break);
}
