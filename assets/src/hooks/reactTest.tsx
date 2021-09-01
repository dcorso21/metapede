import React from "react";
import ReactDOM from "react-dom";

function ReactTest() {
    return <div>Hello There</div>;
}

function mounted(this:any) {
    ReactDOM.render(
        <React.StrictMode>
            <ReactTest />
        </React.StrictMode>,
        this.el
    );
}

function update() {}

const reactTestHook = {
    mounted,
    update,
};

export default reactTestHook
