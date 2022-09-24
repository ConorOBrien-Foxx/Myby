module myby.json;

import std.algorithm.iteration : map;
import std.array;
import std.bigint;
import std.conv : to;
import std.datetime : Duration;
import std.json;
import std.sumtype;

import myby.speech;

Atom jsonToAtom(string s) {
    return s.parseJSON.jsonToAtom;
}

Atom jsonToAtom(JSONValue j) {
    final switch(j.type) {
        case JSONType.null_:
            return Nil.nilAtom;
        
        case JSONType.string:
            return Atom(j.str);
            
        case JSONType.integer:
            return Atom(BigInt(j.integer));
        
        case JSONType.uinteger:
            return Atom(BigInt(j.uinteger));
        
        case JSONType.float_:
            return Atom(cast(real)j.floating);
        
        case JSONType.array:
            return Atom(
                j.array().map!jsonToAtom.array
            );
            
        case JSONType.object:
            AVHash h;
            foreach(key, value; j.object().byPair) {
                Atom mappedKey = Atom(key);
                Atom mappedValue = jsonToAtom(value);
                h[mappedKey.value] = mappedValue.value;
            }
            return Atom(h);
        
        case JSONType.true_:
        case JSONType.false_:
            return Atom(j.boolean());
    }
}

JSONValue atomToJsonValue(Atom a) {
    JSONValue jj = a.match!(
        v => JSONValue(v),
        (Nil _) => JSONValue(null),
        (BigInt b) => JSONValue(b.to!long),
        (Duration d) => JSONValue(a.as!real),
        (Atom[] a) => JSONValue(a.map!atomToJsonValue.array),
        (AVHash h) {
            JSONValue[string] res;
            foreach(key, value; h.byPair) {
                res[key.atomToString] = atomToJsonValue(Atom(value));
            }
            return JSONValue(res);
        },
        (Infinity i) => assert(0, "Cannot encode infinity"),
    );
    return jj;
}

string atomToJson(Atom a) {
    return atomToJsonValue(a).toString;
}
