import React from "react";
import ReactDOM from "react-dom";
import { ModalComponent } from "./ModalComponent/ModalComponent";

function mounted(this: any) {
    ReactDOM.render(
        <React.StrictMode>
            <ModalComponent msg="Hey there" />
        </React.StrictMode>,
        this.el
    );
}

function update() {}

const reactTestHook = {
    mounted,
    update,
};

export default reactTestHook;


