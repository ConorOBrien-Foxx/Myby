module myby.format;

import std.algorithm.iteration : map;
import std.algorithm.searching : maxElement;
import std.array;
import std.conv : to;
import std.range : padRight, repeat;
import std.stdio;

struct BoxedString {
    ulong tineIndex;
    dstring[] lines;
    
    this(T)(ulong ti, T[] li) {
        auto unicodeLines = li.map!(to!dstring);
        tineIndex = ti;
        ulong maxSize = unicodeLines.map!"a.length".maxElement;
        lines = unicodeLines
            .map!(a => a.padRight(dchar(' '), maxSize))
            .map!(to!dstring)
            .array;
    }
}

// tree has .children (list of T) and .head (string)
auto treeToBoxedStringHelper(T)(T tree) {
    if(tree.children.length == 0) {
        return BoxedString(0, ["─ " ~ tree.head]);
    }
    
    ulong size = tree.head.length;
    dstring prepend = "─ " ~ to!dstring(tree.head) ~ " ─";
    dstring pad = to!dstring(repeat(' ', prepend.length));
    
    // auto childBoxes = tree.children.map!treeToBoxedStringHelper;
    
    uint walkingTine = 0;
    dstring[] lines;
    bool metFirst = false, metLast = false;
    foreach(i, child; tree.children) {
        auto box = treeToBoxedStringHelper(child);
        auto startTine = walkingTine;
        auto relativeTine = walkingTine + box.tineIndex;
        bool isLastChild = i + 1 == tree.children.length;
        foreach(j, line; box.lines) {
            dstring build = "";
            if(walkingTine == relativeTine) {
                if(tree.children.length == 1) {
                    build ~= "─";
                }
                else if(i == 0) {
                    build ~= "┌";
                    metFirst = true;
                }
                else if(isLastChild) {
                    build ~= "└";
                    metLast = true;
                }
                else {
                    build ~= "│";
                }
            }
            else {
                build ~= metLast || !metFirst ? " " : "│";
            }
            build ~= line;
            lines ~= build;
            walkingTine++;
        }
        // if the difference between walkingTine and startTine is more than 1
        if(walkingTine > startTine + 1 && !isLastChild) {
            lines ~= "│";
            walkingTine++;
        }
    }
    
    ulong myTine = lines.length / 2;
    foreach(i, ref line; lines) {
        line = (i == myTine ? prepend : pad) ~ line;
        line = line
            .replace("─│─"d, "─┼─"d)
            .replace("│─"d, "├─"d)
            .replace("─┌"d, "─┬"d)
            .replace("─│"d, "─┤"d)
            .replace("─└"d, "─┴"d);
    }
    
    return BoxedString(myTine, lines);
}

string treeToBoxedString(T)(T tree) {
    BoxedString bs = treeToBoxedStringHelper(tree);
    return to!string(bs.lines.join("\n"));
}