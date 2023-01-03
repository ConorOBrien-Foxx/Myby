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

const handleTableOfContents = (content, para) => {
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
                gc = gc?.cloneNode(true) ?? gc;
                // strip top level links
                if(gc.tagName === "A") {
                    gc = document.createTextNode(gc.textContent);
                }
                a.appendChild(gc);
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
};

const scrapeByteCount = str => parseFloat(str.match(/\d+(?:.\d+)?/)[0]);

const handleCompare = (content, para) => {
    let langs = [...
        new Set(
            [...document.querySelectorAll("tbody td:first-child")]
                .map(e => e.textContent)
        )
    ];
    langs.sort();
    
    const widget = document.createElement("div");
    
    const div = document.createElement("div");
    const firstLangInput = document.createElement("select");
    const secondLangInput = document.createElement("select");
    const theWorldButton = document.createElement("button");
    theWorldButton.textContent = "vs. the World";
    
    const result = document.createElement("div");
    const firstLangCapture = document.createElement("span");
    const firstLangWins = document.createElement("span");
    const langTies = document.createElement("span");
    const secondLangCapture = document.createElement("span");
    const secondLangWins = document.createElement("span");
    
    const longResult = document.createElement("div");
    longResult.style.display = "none";
    
    div.appendChild(document.createTextNode("Compare "));
    div.appendChild(firstLangInput);
    div.appendChild(document.createTextNode(" to "));
    div.appendChild(secondLangInput);
    div.appendChild(document.createTextNode("! Or: "));
    div.appendChild(theWorldButton);

    // e.g. Myby wins (#D) Tie (#D) Jelly wins (#D)
    result.appendChild(firstLangCapture);
    result.appendChild(document.createTextNode(" wins ("));
    result.appendChild(firstLangWins);
    result.appendChild(document.createTextNode(") · Tie ("));
    result.appendChild(langTies);
    result.appendChild(document.createTextNode(") · "));
    result.appendChild(secondLangCapture);
    result.appendChild(document.createTextNode(" wins ("));
    result.appendChild(secondLangWins);
    result.appendChild(document.createTextNode(")"));
    
    widget.appendChild(div);
    widget.appendChild(result);
    widget.appendChild(longResult);
    
    for(let lang of langs) {
        let opt1 = document.createElement("option");
        let opt2 = document.createElement("option");
        opt1.textContent = opt2.textContent = lang;
        firstLangInput.appendChild(opt1);
        secondLangInput.appendChild(opt2);
    }
    firstLangInput.value = "Myby";
    secondLangInput.value = "Jelly";
    
    theWorldButton.addEventListener("click", function () {
        longResult.style.display = "block";
        result.style.display = "none";
        let first = firstLangInput.value;
        
        let collected = {};
        
        let tables = document.querySelectorAll("table");
        for(let table of tables) {
            let rows = [...table.querySelectorAll("tbody tr")];
            let firstRow = rows.find(row => row.children[0].textContent === first);
            if(!firstRow) {
                continue;
            }
            let firstBytes = scrapeByteCount(firstRow.children[2].textContent);
            for(let row of rows) {
                let lang = row.children[0].textContent;
                let score = row.children[2].textContent;
                if(lang !== first) {
                    let bytes = scrapeByteCount(score);
                    collected[lang] ??= { wins: 0, ties: 0, losses: 0 };
                    if     (firstBytes  <  bytes) collected[lang].wins++;
                    else if(firstBytes === bytes) collected[lang].ties++;
                    else if(firstBytes  >  bytes) collected[lang].losses++;
                }
            }
        }
        
        let lines = [];
        let pairs = Object.entries(collected);
        pairs.sort(([aLanguage, aDistr], [bLanguage, bDistr]) =>
            bDistr.wins - aDistr.wins
            || bDistr.losses - aDistr.losses
            || bDistr.ties - aDistr.ties
            || aLanguage.localeCompare(bLanguage, undefined, {sensitivity: "base"})
        );
        for(let [ lang, distr ] of pairs) {
            let line = `${first} wins (${distr.wins}) · Tie (${distr.ties}) · ${lang} wins (${distr.losses})`;
            lines.push(line);
        }
        let text = document.createElement("p");
        text.style.whiteSpace = "pre-wrap";
        text.textContent = lines.join("\n");
        longResult.appendChild(text);
    });
    
    const handleChange = () => {
        longResult.style.display = "none";
        result.style.display = "block";
        let first = firstLangInput.value;
        let second = secondLangInput.value;
        if(first === second) {
            // TODO: error
            return;
        }
        
        firstLangCapture.textContent = first;
        secondLangCapture.textContent = second;
        let tables = document.querySelectorAll("table");
        let firstWins = 0;
        let ties = 0;
        let secondWins = 0;
        for(let table of tables) {
            let rows = table.querySelectorAll("tbody tr");
            let firstBytes = null, secondBytes = null;
            for(let row of rows) {
                let lang = row.children[0].textContent;
                let score = row.children[2].textContent;
                if(lang === "Jelly" || lang === "Myby") {
                    console.log(lang, row.children[3].textContent, scrapeByteCount(score));
                }
                if(lang === first && firstBytes === null) {
                    firstBytes  = scrapeByteCount(score);
                }
                else if(lang === second && secondBytes === null) {
                    secondBytes = scrapeByteCount(score);
                }
            }
            console.log(firstBytes, ";", secondBytes);
            if(firstBytes !== null && secondBytes !== null) {
                if     (firstBytes  <  secondBytes) firstWins++;
                else if(firstBytes === secondBytes) ties++;
                else if(firstBytes  >  secondBytes) secondWins++;
            }
        }
        firstLangWins.textContent = firstWins;
        langTies.textContent = ties;
        secondLangWins.textContent = secondWins;
    };
    
    firstLangInput.addEventListener("change", handleChange);
    secondLangInput.addEventListener("change", handleChange);
    
    para.removeChild(para.firstChild);
    para.appendChild(widget);
    handleChange();
};

window.addEventListener("load", async function () {
    let file = await fetch(window.content);
    let text = await file.text();
    text = text.replace(/\{% (end)?raw %\}/g, "");
    // console.log(text);
    const content = document.getElementById("content");
    content.innerHTML = marked.parse(text);
    // handle tables of contents
    for(let para of content.querySelectorAll("p")) {
        if(para.textContent === "{COMPARE}") {
            handleCompare(content, para);
        }
        else if(para.textContent === "{TOC}") {
            handleTableOfContents(content, para);
        }
    }
});
