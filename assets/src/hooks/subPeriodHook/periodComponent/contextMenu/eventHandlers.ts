import periodContextMenu from "./contextMenu";

function enableEventHandlers(_selection) {
    enableClickout()
}

function clickOutHandler(e) {
    let context = periodContextMenu.selectEl();
    if (!context.node()) {
        document.removeEventListener("click", clickOutHandler, true)
        return;
    }
    // @ts-ignore
    if (!context.node().contains(e.target)) {
        context.remove();
    }
}

function enableClickout() {
    document.addEventListener("click", clickOutHandler, true)
}

const periodContextMenuEventHandlers = {
    enableEventHandlers
}

export default periodContextMenuEventHandlers;