module myby.test;

import std.conv : to;
import std.algorithm : map;
import std.array : array;
import std.functional : binaryFun;
import std.math.operations : isClose;

import myby.speech;

void assertEqual(alias pred = "a == b", T)(T a, T b, string msg = "") {
    alias eq = binaryFun!pred;
    assert(eq(a, b), (msg == "" ? msg : msg ~ "\n") ~ "Error: Expected " ~ a.to!string() ~ " to be equal to " ~ b.to!string());
}

void assertEqual(alias pred = "a == b", T)(Atom[] a, T[] b, string msg = "")
if(!is(T == Atom)) {
    assertEqual!pred(a, b.map!Atom.array, msg);
}
void assertEqual(alias pred = "a == b", T)(Atom[][] a, T[][] b, string msg = "")
if(!is(T == Atom)) {
    assertEqual!pred(a, b.map!(t => t.map!Atom.array).array, msg);
}

alias isVisuallyClose = (a, b) => isClose(a, b, 1e-2, 1e-5);