
function enableEventHandlers(_selection) {
    enableClickout()
}

function clickOutHandler(e) {
    let context = d3.select("#periodContext");
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