function transpose(matrix) {
  return matrix[0].map((col, i) => matrix.map(row => row[i]));
}
const cumulativeSum = (sum => value => sum += value)(0);

const node = (head, ...children) => ({ head, children });

// const HORIZONTAL = "─";
// const LEFT_DOWN = "┌";
// const MID_DOWN = "┬";
// const RIGHT_DOWN = "┐";

// const BOX_CHARS = [LEFT_DOWN, MID_DOWN, RIGHT_DOWN];
// const LEFT_PADS = [" ", HORIZONTAL, HORIZONTAL];
// const RIGHT_PADS = [HORIZONTAL, HORIZONTAL, " "];

const BOX_CHARS = ["┌", "├", "└"];

const box = (tineIndex, lines) => {
    let maxSize = Math.max(...lines.map(e => e.length));
    return {
        tineIndex,
        lines: lines.map(line => line.padEnd(maxSize))
    };
};

// returns list of lines
const boxTreeRec = (tree) => {
    if(tree.children.length === 0) {
        return box(0, ["─ " + tree.head]);
    }
    
    let size = tree.head.length;
    let prepend = `─ ${tree.head} ─`;
    let pad = " ".repeat(prepend.length);
    
    let childBoxes = tree.children.map(child => boxTreeRec(child));
    // let middleIndex = Math.floor(childBoxes.length / 2);
    // let myTine = childBoxes[middleIndex].tineIndex;
    
    let walkingTine = 0;
    // let tines = [];
    let lines = [];
    let metFirst = false;
    let metLast = false;
    childBoxes.forEach((b, i) => {
        let startTine = walkingTine;
        let relativeTine = walkingTine + b.tineIndex;
        // tines.push(relativeTine);
        b.lines.forEach((line, j) => {
            let build = "";
            if(walkingTine === relativeTine) {
                if(childBoxes.length === 1) {
                    build += "─";
                }
                else if(i === 0) {
                    build += "┌";
                    metFirst = true;
                }
                else if(i === childBoxes.length - 1) {
                    metLast = true;
                    build += "└";
                }
                else {
                    build += "│";
                }
            }
            else {
                build += metLast || !metFirst ? " " : "│";
                // build += "?";
            }
            // build += walkingTine.toString(16) + ":" + relativeTine.toString(16);
            build += line;
            lines.push(build);
            walkingTine++;
        });
        if(walkingTine - startTine > 1 && i + 1 !== childBoxes.length) {
            lines.push("│");
            walkingTine++;
        }
    });
    myTine = Math.floor(lines.length / 2);
    lines = lines.map((line, i) => {
        line = (i === myTine ? prepend : pad) + line
        return line
            .replace(/─│─/g, "─┼─")
            .replace(/│─/g, "├─")
            .replace(/─┌/g, "─┬")
            .replace(/─│/g, "─┤")
            .replace(/─└/g, "─┴")
    });
    
    // console.log("tines =", tines);
    let resultTine = myTine;
    
    let res = box(resultTine, lines);
    console.log("resulting box =",res);
    return res;
};
const boxTree = (tree) => {
    // console.log(tree);
    return boxTreeRec(tree).lines.join("\n");
};

let trees = [
    node('"', node("+")),
    node('"', node("Ψ",
        node("left"),
        node("mid"),
        node("right"),
    )),
    node("@", node("1354"), node("196")),
    node("@",
        node("+", node("2"), node("3")),
        node("/", node("9"), node("5"))
    ),
    node("@",
        node('"',
            node("@",
                node("1"),
                node("@",
                    node("2"),
                    node("3")
                )
            )
        ),
        node("4")
    ),
    // (0<<.)#%(#*#)O"\(#;2&R)@.
    node("@.",
        node("Ψ",
            node("0"),
            node("<"),
            node("<."),
        ),
        node("/", node('"', node("O",
            node("#"),
            node("%"),
            node("Ψ", node("#"), node("*"), node("#")),
        ))),
        node("Ψ",
            node("#"),
            node(";"),
            node("&", node("2"), node("R")),
        )
    ),
];

for(let tree of trees) {
    console.log(boxTree(tree));
    console.log("=".repeat(30));
}
