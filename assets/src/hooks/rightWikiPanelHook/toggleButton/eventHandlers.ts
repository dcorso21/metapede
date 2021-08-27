import infoPanel from "../infoPanel/infoPanel";

export default function enableToggleButtonEventHandlers(
    selection: d3.Selection<HTMLDivElement, unknown, HTMLElement, any>
) {
    selection.on("click", handleClick);
}

function handleClick(e: MouseEvent) {
    e.preventDefault();
    console.log("clicked");
    infoPanel.toggleVisibility();
}
