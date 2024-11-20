const clearChildren = el => {
    while(el.firstChild) {
        el.removeChild(el.firstChild);
    }
};

window.addEventListener("load", function () {
    const code = document.getElementById("code");
    const button = document.getElementById("submit");
    const output = document.getElementById("output");

    const wsProtocol = new URL("echo", window.location.toString().replace("http", "ws")).href;
    console.log("Connecting to ", wsProtocol);
    const mybySocket = new WebSocket(wsProtocol);
    mybySocket.onmessage = event => {
        let data = JSON.parse(event.data);
        if(data.action === "tokenize") {
            clearChildren(output);
            for(let { nibbles, reps } of data.payload) {
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

        // mybySocket.send("This is a test.");
    };
    mybySocket.onclose = event => {
        alert("Connection with websocket lost. Please refresh.");
    };
});
