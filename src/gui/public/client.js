const ForkRepresentation = "Ψ";

const clearChildren = el => {
    while(el.firstChild) {
        el.removeChild(el.firstChild);
    }
};

class SocketResolver {
    constructor(protocol) {
        this.socket = null;
        this.protocol = protocol;
        this.ready = false;
        this.requestIdCounter = 0;
        this.promiseResolutionCache = {};
        this.readyPromises = [];
    }

    getNewRequestId() {
        return this.requestIdCounter++;
    }

    waitForReady() {
        return new Promise((resolve, reject) => {
            if(this.ready) {
                resolve(true);
            }
            else {
                this.readyPromises.push({ resolve, reject });
            }
        });
    }

    markReady() {
        if(this.ready) {
            return;
        }
        this.ready = true;
        this.readyPromises.splice(0).forEach(({ resolve }) => resolve(true));
    }
    
    connect() {
        this.socket = new WebSocket(this.protocol);
        this.socket.onmessage = event => {
            this.handleMessage(event);
        };
        this.socket.onopen = event => {
            console.log("Socket opened:", this.socket);
            this.markReady();
        };
        this.socket.onclose = event => {
            // TODO: check if connection unsuccessful first
            console.error("Connection with websocket lost. Please refresh.");
        };
    }

    handleMessage(event) {
        console.log("Message returned:", event);
        let data = JSON.parse(event.data);
        let { resolve, reject } = this.promiseResolutionCache[data.id];
        let dataObject = {
            error: false,
            ...data,
        };
        if(dataObject.error) {
            reject(dataObject);
        }
        else {
            resolve(dataObject);
        }
    }

    requestAction(action, payload) {
        return new Promise((resolve, reject) => {
            let id = this.getNewRequestId();
            this.promiseResolutionCache[id] = { resolve, reject };
            this.socket.send(JSON.stringify({ id, action, payload }));
        });
    }

};

window.addEventListener("load", function () {
    const wsProtocol = new URL("ws_myby_serv", window.location.toString().replace("http", "ws")).href;

    const codeEl = document.getElementById("code");
    const inputXEl = document.getElementById("inputX");
    const inputYEl = document.getElementById("inputY");
    const submitEl = document.getElementById("submit");
    const outputEl = document.getElementById("output");
    const tokensEl = document.getElementById("tokens");
    const interactiveEl = document.getElementById("interactive");
    const byteCountEl = document.getElementById("byteCount");

    outputEl.value = "";

    let mybySocket = new SocketResolver(wsProtocol);
    mybySocket.connect();

    /*
    const showTokens = (tokens, error) => {
        clearChildren(tokensEl);
        for(let { nibbles, reps } of tokens) {
            let table = document.createElement("table");
            let repsEl = document.createElement("tr");
            for(let token of reps) {
                let td = document.createElement("td");
                let code = document.createElement("code");
                code.textContent = token;
                td.appendChild(code);
                repsEl.appendChild(td);
            }
            let nibblesEl = document.createElement("tr");
            for(let token of nibbles) {
                let td = document.createElement("td");
                let code = document.createElement("code");
                code.textContent = token;
                td.appendChild(code);
                nibblesEl.appendChild(td);
            }
            table.appendChild(repsEl);
            table.appendChild(nibblesEl);
            tokensEl.appendChild(table);
        }
    };*/
    const implicitNamedMap = {
        implicitFork: "Fork",
        implicitCompose: "Compose",
        implicitBind: "Bind",
    }

    const generateAST = (ast) => {
        let container = document.createElement("span");
        if(ast.head === ForkRepresentation) {
            container.classList.add("ast-fork");
        }
        if(ast.children.length === 0) {
            let leaf = document.createElement("span");
            leaf.classList.add("ast-leaf");
            leaf.textContent = ast.head;
            return leaf;
        }
        else {
            container.classList.add("ast-container");
            container.classList.add(`ast-type-${ast.type}`);
            let headEl = document.createElement("span");
            headEl.textContent = ast.head;
            headEl.classList.add("ast-container-head");

            let includeInlineLabel = true;
            if(ast.type.startsWith("implicit")) {
                includeInlineLabel = false;
                let title = document.createElement("div");
                title.classList.add("ast-label");
                title.textContent = implicitNamedMap[ast.type];
                container.appendChild(title);
            }

            let childrenContainer = document.createElement("span");
            childrenContainer.classList.add("ast-children");
            container.appendChild(childrenContainer);

            let insertAfterIndex = ast.type === "conjunction"
                ? 0
                : ast.children.length - 1;
            // container
            ast.children.forEach((child, idx) => {
                let subAST = generateAST(child);
                childrenContainer.appendChild(subAST);
                if(includeInlineLabel && idx === insertAfterIndex) {
                    childrenContainer.appendChild(headEl);
                }
            });
            return container;
        }
    };
    const showAST = (ast) => {
        clearChildren(interactiveEl);
        interactiveEl.classList.add("ast");
        interactiveEl.appendChild(generateAST(ast));
    };

    const requestUpdatedByteCount = async () => {
        let codeString = codeEl.value;
        mybySocket.requestAction("nibbleCount", codeString)
            .then(data => {
                let { nibbleCount } = data;
                byteCountEl.textContent = `${nibbleCount / 2} byte(s) (${nibbleCount} nibble(s))`;
            })
            .catch(err => {
                // console.log("Error:", err);
                // ignore error, it just means malformed content
            })
    };

    const runCode = () => {
        let codeString = codeEl.value;
        let xString = inputXEl.value;
        let yString = inputYEl.value;
        mybySocket.requestAction("evaluate", {
            code: codeString,
            x: xString,
            y: yString,
        })
            .then(data => {
                outputEl.value = data.repr;
                showAST(data.ast);
            })
            .catch(err => {
                console.error(err);
                // TODO: proper error handling
            });
    };

    codeEl.addEventListener("input", requestUpdatedByteCount);
    for(let el of [ codeEl, inputXEl, inputYEl ]) {
        el.addEventListener("keydown", ev => {
            if(ev.key === "Enter" && ev.ctrlKey) {
                runCode();
            }
        });
    }
    mybySocket.waitForReady().then(requestUpdatedByteCount);

    submitEl.addEventListener("click", runCode);

    console.log("Connecting to ", wsProtocol);
});
