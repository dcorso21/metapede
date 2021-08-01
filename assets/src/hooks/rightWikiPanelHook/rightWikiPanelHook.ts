// @ts-check

import infoPanel from "./infoPanel/infoPanel";
import toggleButton from "./toggleButton/toggleButton";

let rightWikiPanelConn:any;

const selector = "#right_panel_wrap"

function getConn() {
	rightWikiPanelConn.sendEvent =
		(event:string, payload:any) => rightWikiPanelConn.pushEventTo(selector, event, payload);

	return rightWikiPanelConn;
}

function initAllElements() {
	toggleButton.create();
	infoPanel.create();
}

function initState() {
	window.sessionStorage.setItem("open", "false");
	window.sessionStorage.setItem("selectedPageId", rightWikiPanelConn.el.dataset.page_id);
}

function mounted(this:any) {
	rightWikiPanelConn = this;
	initAllElements();
	initState();
	console.log("side panel mounted");
}

function updated(this:any) {
	rightWikiPanelConn = this;
}

const rightWikiPanelHook = {
	mounted,
	updated,
	getConn
}

export default rightWikiPanelHook;