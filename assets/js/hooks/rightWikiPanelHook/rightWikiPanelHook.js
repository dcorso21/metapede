// @ts-check

import infoPanel from "./infoPanel/infoPanel";
import toggleButton from "./toggleButton/toggleButton";

let rightWikiPanelConn;

const selector = "#right_panel_wrap"

function getConn() {
	rightWikiPanelConn.sendEvent =
		(event, payload) => rightWikiPanelConn.pushEventTo(selector, event, payload);

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

function mounted() {
	rightWikiPanelConn = this;
	initAllElements();
	initState();
}

function updated() {
	rightWikiPanelConn = this;
}

const rightWikiPanelHook = {
	mounted,
	updated,
	getConn
}

export default rightWikiPanelHook;