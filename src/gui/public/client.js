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
    const byteCountEl = document.getElementById("byteCount");

    let mybySocket = new SocketResolver(wsProtocol);
    mybySocket.connect();

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
    codeEl.addEventListener("input", requestUpdatedByteCount);
    mybySocket.waitForReady().then(requestUpdatedByteCount);

    submitEl.addEventListener("click", () => {
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
            })
            .catch(err => {
                console.error(err);
                // TODO: proper error handling
            })
    });

    console.log("Connecting to ", wsProtocol);
});
