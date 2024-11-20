const express = require("express");
const path = require("path");
const readline = require("readline");

// TODO: read from environment variable
const PORT = 8080;

const assert = (value, msg) => {
    if(!value) {
        throw new Error(msg);
    }
}

const Coordinator = new (class {
    constructor() {
        this.rl = null;
        this.requestIdCounter = 0;
        this.promiseResolutionCache = {};
    }

    getNewRequestId() {
        return this.requestIdCounter++;
    }

    request(action, params = {}) {
        return new Promise((resolve, reject) => {
            const id = this.getNewRequestId();
            this.promiseResolutionCache[id] = { resolve, reject };
            console.log(JSON.stringify({ id, action, ...params }));
        });
    }

    initReadline() {
        assert(this.rl === null, "Cannot re-instantiate readline interface");
        // readline to communicate with the executable which invoked us
        this.rl = readline.createInterface({
            input: process.stdin,
            output: process.stdout,
            terminal: false,
        });

        this.rl.on("line", line => {
            let jsonData = JSON.parse(line);
            let { id } = jsonData;
            let { resolve, reject } = this.promiseResolutionCache[id];
            delete this.promiseResolutionCache[id]; // TODO: performance?
            resolve(jsonData);
        });

        this.rl.once("close", () => {
            // end of input
            console.warn("Connection terminated with invoking program. Closing...");
            process.exit(0);
        });
    }

    async tokenize(code) {
        const data = await this.request("tokenize", { code });
        return data.tokens;
    }
});

const app = express();
const expressWs = require("express-ws")(app);

app.use(express.static(path.join(__dirname, "public")));

app.ws("/echo", function(ws, req) {
    ws.on("message", function(msg) {
        let data;
        try {
            data = JSON.parse(msg);
        }
        catch {
            console.error("Could not parse user input as JSON.");
            console.error(msg);
            ws.send(JSON.stringify({ type: "error", reason: "malformed JSON" }));
            return;
        }
        
        if(data.action === "tokenize") {
            Coordinator.tokenize(data.payload).then(tokenized => {
                ws.send(JSON.stringify({
                    action: "tokenize",
                    payload: tokenized,
                }));
            });
            /*
            ws.send(JSON.stringify({
                message: "todo: tokenize " + data.payload,
            }));
            */
        }
    });
});

// this line must happen before we start listening
Coordinator.initReadline();

console.warn("Listening on port:", PORT);
app.listen(PORT);
