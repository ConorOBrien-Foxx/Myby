const express = require("express");
const path = require("path");
const readline = require("readline");

// TODO: read from environment variable
const PORT = 8080;

const assert = (value, msg) => {
    if(!value) {
        throw new Error(msg);
    }
};

const getTimeId = () => `[node.js@${new Date().toLocaleString()}]`;

const warn = (...args) => {
    console.warn(getTimeId(), ...args);
};

const error = (...args) => {
    console.error(getTimeId(), ...args);
};

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
            const message = JSON.stringify({ id, action, ...params });
            // warn("Sending message:", message);
            console.log(message);
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
            // warn("We got a line back from the D server:", line);
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

    nibbleCount(code) {
        return this.request("nibbleCount", { code });
    }
});

const app = express();
const expressWs = require("express-ws")(app);

app.use(express.static(path.join(__dirname, "public")));


const coordinatorMap = {
    tokenize: "tokenize",
    nibbleCount: "nibbleCount",
};

app.ws("/ws_myby_serv", function(ws, req) {
    ws.on("message", function(msg) {
        let input;
        try {
            input = JSON.parse(msg);
        }
        catch {
            error("Could not parse user input as JSON.");
            error(msg);
            ws.send(JSON.stringify({ type: "error", reason: "malformed JSON" }));
            return;
        }

        let targetAction = coordinatorMap[input.action];
        if(targetAction) {
            Coordinator[targetAction](input.payload).then(output => {
                ws.send(JSON.stringify({
                    ...output,
                    action: output.action, // or is it supposed to be `targetAction`?
                    id: input.id,
                }));
            });
        }
        else {
            warn("Could not handle action from server:", msg);
        }
    });
});

// this line must happen before we start listening
Coordinator.initReadline();

warn("Listening on port:", PORT);
app.listen(PORT);
