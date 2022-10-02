module myby.nibble;

alias Nibble = ushort;

enum HEX_DIGITS = "0123456789ABCDEF";
string nibbleFmt(Nibble[] arr) {
    string res = "[ ";
    foreach(i, nibble; arr) {
        res ~= "0x" ~ HEX_DIGITS[nibble] ~ " ";
    }
    res ~= "]";
    return res;
}
string basicNibbleFmt(Nibble[] arr, string joinWith=" ") {
    import std.algorithm : map;
    import std.array : join, array;
    return arr.map!(a => HEX_DIGITS[a..a+1])
        .array
        .join(joinWith);
}
string byteNibbleFmt(Nibble[] arr) {
    import std.algorithm : map;
    import std.array : join, array;
    import std.range : chunks;
    import std.conv : to;
    return arr.map!(a => HEX_DIGITS[a])
        .array
        .chunks(2)
        .map!(to!string)
        .join(" ");
}
string byteNibbleDecimalFmt(Nibble[] arr) {
    import std.algorithm : map;
    import std.array : join, array;
    import std.range : chunks;
    import std.conv : to;
    auto hex = arr.map!(a => HEX_DIGITS[a])
        .array
        .chunks(2)
        .map!(to!string)
        .join(" ");
    auto dec = arr
        .chunks(2)
        .map!(chunk => to!string(chunk.length == 1 ? chunk[0] : chunk[0] * 16 + chunk[1]) ~ 'd')
        .join(" ");
    
    return hex ~ " (" ~ dec ~ ")";
}

Nibble[] getNibbles(string str) {
    Nibble[] nibs;
    foreach(ch; str) {
        nibs ~= ch / 16;
        nibs ~= ch % 16;
    }
    return nibs;
}

Nibble[] toBase16(T)(T n) {
    import std.algorithm.mutation : reverse;
    Nibble[] digits = [];
    while(n != 0) {
        digits ~= cast(Nibble)(n % 16);
        n /= 16;
    }
    return digits.reverse;
}

int[] nibbleToCharCodes(Nibble[] arr) {
    import std.range : chunks;
    int[] result = [];
    foreach(pair; arr.chunks(2)) {
        int sum = pair[0] * 16;
        sum += pair.length == 1 ? 0xB : pair[1];
        result ~= sum;
    }
    return result;
}