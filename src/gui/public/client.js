const clearChildren = el => {
    while(el.firstChild) {
        el.removeChild(el.firstChild);
    }
};

window.addEventListener("load", function () {
    const code = document.getElementById("code");
    const button = document.getElementById("submit");
    const output = document.getElementById("output");
    const byteCount = document.getElementById("byteCount");

    const showTokens = (tokens, error) => {
        clearChildren(output);
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
            output.appendChild(table);
        }
    };

    const updateByteCount = (nibbleCount, error) => {
        byteCount.textContent = error
            ? byteCount.textContent
            : `${nibbleCount / 2} byte(s) (${nibbleCount} nibble(s))`;
    };

    const actionMap = {
        tokenize: showTokens,
        nibbleCount: updateByteCount,
    }

    const wsProtocol = new URL("ws_myby_serv", window.location.toString().replace("http", "ws")).href;
    console.log("Connecting to ", wsProtocol);
    const mybySocket = new WebSocket(wsProtocol);
    mybySocket.onmessage = event => {
        let data = JSON.parse(event.data);
        let action = actionMap[data.action];
        if(action) {
            action(data.payload, data.error ?? false);
        }
        else {
            console.log("Idk what to do with ", data.action);
        }
    };
    mybySocket.onopen = event => {
        console.log("Socket opened:", mybySocket);
        button.addEventListener("click", () => {
            mybySocket.send(JSON.stringify({
                action: "tokenize",
                payload: code.value,
            }));
        });
        
        const requestUpdatedByteCount = () => {
            mybySocket.send(JSON.stringify({
                action: "nibbleCount",
                payload: code.value,
            }));
        };
        code.addEventListener("input", requestUpdatedByteCount);
        requestUpdatedByteCount();
    };
    mybySocket.onclose = event => {
        // TODO: check if connection unsuccessful first
        console.error("Connection with websocket lost. Please refresh.");
    };
});
