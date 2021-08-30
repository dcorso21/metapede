import infoPanel from "./infoPanel/infoPanel";
// import toggleButton from "./toggleButton/toggleButton";

let rightWikiPanelConn: any;

const selector = "#right_panel_wrap";

function getConn() {
    rightWikiPanelConn.sendEvent = (event: string, payload: any) =>
        rightWikiPanelConn.pushEventTo(selector, event, payload);

    rightWikiPanelConn.getVar = (variable_name: string) =>
        rightWikiPanelConn.el.dataset[variable_name];

    rightWikiPanelConn.handleEvent("ensure_open", (_props: any) => {
        infoPanel.show();
    });

    return rightWikiPanelConn;
}

function mounted(this: any) {
    rightWikiPanelConn = this;
    infoPanel.create();
    let pid = getConn().getVar("page_id");
    if (!!pid && infoPanel.isOpen()) {
        infoPanel.show();
    } else {
        infoPanel.hide();
    }

    this.handleEvent("ensure_open", ({ page_id }: any) => {
        console.log({ page_id });
        infoPanel.show();
    });
}

function updated(this: any) {
    rightWikiPanelConn = this;
    infoPanel.show();
}

const rightWikiPanelHook = {
    mounted,
    updated,
    getConn,
};

export default rightWikiPanelHook;
