// from https://marked.js.org/using_advanced
marked.setOptions({
    renderer: new marked.Renderer(),
    highlight: function(code, lang) {
        const language = hljs.getLanguage(lang) ? lang : 'plaintext';
        return hljs.highlight(code, { language }).value;
    },
    langPrefix: 'hljs language-', // highlight.js css expects a top-level 'hljs' class.
    pedantic: false,
    gfm: true,
    breaks: false,
    sanitize: false,
    smartLists: true,
    smartypants: false,
    xhtml: false
});

hljs.registerLanguage("myby", (h) => {
    // const comment = {
        // className: "comment",
        // variants: Object.assign({}, h.C_LINE_COMMENT_MODE, { begin: "NB." }),
    // };
    return {
        name: "Myby",
        aliases: "myby",
        case_insensitive: false,
        unicodeRegex: true,
        contains: [
            {
                className: "comment",
                variants: [
                    { begin: /NB.<?=>/ },
                ],
                relevance: 10,
            },
            h.COMMENT(/NB\./, /$/, {
                relevance: 0,
                contains: [{
                    scope: "doctag",
                    begin: /[ ]*(?=(TODO|FIXME|NOTE|BUG|OPTIMIZE|HACK|XXX):)/,
                    end: /(TODO|FIXME|NOTE|BUG|OPTIMIZE|HACK|XXX):/,
                    excludeBegin: true,
                    relevance: 0,
                }],
            }),
            {
                className: "number",
                variants: [
                    { begin: `[01]+b` },
                    { begin: `_?[0-9]+(\\.[0-9]+)?(e[+-]?[0-9]+)?` },
                ],
                relevance: 0,
            },
            // Adjective
            // grep -E SpeechPart.Adjective src\instructions.d | ruby -e "puts STDIN.read.lines.map{|line|line.scan(/InsInfo.(.)(.+)\1/)[0]}.map{eval _1+_2+_1}.sort.sort_by.with_index{[-_1.size,_2]}.map{Regexp.escape(_1).gsub(?/,'\\\0')} * ?|"
            {
                className: "literal",
                variants: [
                    { begin: /^\s*[a-z]+:/ },
                    // { begin: /[!TM]\.|[\\][:.]|\\\.\.|\$N|[?\\G"\[\]]/ },
                    { begin: /benil|keep|loop|!\.|":|\$N|\0\.|\0:|\?:|M\.|T\.|U:|V:|\[\.|\\\.|\\:|\]\.|`:|"|C|G|V|\\|~/ },
                ],
                relevance: 0,
            },
            // Conjunction
            // grep -E SpeechPart.(Multi)?Conjunction src\instructions.d | ruby -e "puts STDIN.read.lines.map{|line|line.scan(/InsInfo.(.)(.+)\1/)[0]}.map{eval _1+_2+_1}.sort.sort_by.with_index{[-_1.size,_2]}.map{Regexp.escape(_1).gsub(?/,'\\\0')} * ?|"
            {
                className: "title",
                variants: [
                    // { begin: /while|b?loop|benil|[&@\\]\.|[&@O~]|^:/ },
                    { begin: /bloop|while|\\\.\.|&\.|@\.|C:|D:|\^:|&|\.|\?|@|H|O|`/ },
                ],
                relevance: 0,
            },
            {
                className: "string",
                variants: [
                    { begin: /'(?:[^']|'')+'/ },
                    { begin: /\$\.[a-zA-Z]+/ },
                ],
                relevance: 0,
            }
        ],
    };
});

const assert = (cond, ...msg) => {
    if(!cond) {
        throw new Error(msg.join(" "));
    }
}

window.addEventListener("load", async function () {
    let file = await fetch("./docs.md");
    let text = await file.text();
    const content = document.getElementById("content");
    content.innerHTML = marked.parse(text);
    // handle tables of contents
    for(let para of content.querySelectorAll("p")) {
        if(para.textContent !== "{TOC}") continue;
        let header = para.previousElementSibling;
        let tag = header.tagName;
        assert(tag[0] == "H", "Expected a header before {TOC}");
        let tagNumber = tag[1];
        let child = para;
        let contents = [];
        while(child && (child.tagName[0] !== "H" || child.tagName[1] > tagNumber)) {
            if(child.tagName[0] === "H") {
                let depth = child.tagName[1] - tagNumber;
                let a = document.createElement("a");
                for(let gc of child.childNodes) {
                    a.appendChild(gc?.cloneNode(true) ?? gc);
                }
                a.href = `#${child.id}`;
                contents.push({ depth, a });
            }
            child = child.nextElementSibling;
        }
        
        let lastDepth = 0;
        let ol = document.createElement("ol");
        let olStack = [];
        window.debug = [];
        for(let { depth, a } of contents) {
            let li = document.createElement("li");
            li.appendChild(a);
            
            if(lastDepth && lastDepth !== depth) {
                if(lastDepth < depth) {
                    olStack.push(ol);
                    let subOl = document.createElement("ol");
                    ol.lastChild.appendChild(subOl);
                    ol = subOl;
                    ol.appendChild(li);
                }
                else {
                    // for(let i = depth; i < lastDepth; i++) {
                        // ol = olStack.pop();
                    // }
                    ol = olStack.splice(depth - lastDepth)[0];
                    ol.appendChild(li);
                }
            }
            else {
                ol.appendChild(li);
            }
            lastDepth = depth;
        }
        ol = olStack[0] ?? ol;
        para.replaceWith(ol);
        
    }
});
