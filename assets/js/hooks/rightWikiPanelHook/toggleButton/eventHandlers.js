// @ts-check

import infoPanel from "../infoPanel/infoPanel";

export default function enableToggleButtonEventHandlers(selection) {
    selection.on("click" , handleClick);
}

function handleClick(event) {
    event.preventDefault();
    infoPanel.toggleVisibility();
}