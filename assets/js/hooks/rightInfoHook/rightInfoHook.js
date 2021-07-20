import * as d3 from "d3";
let rightInfoConn;

function getPageText(page_id) {
	const baseURL = "https://en.wikipedia.org/w/api.php?origin=*&format=json&";
	const queryParams = "action=parse&prop=text&pageid=";

	var requestOptions = {
		method: 'GET',
		redirect: 'follow'
	};

	return fetch(baseURL + queryParams + page_id, requestOptions)
		.then((res) => res.json())
		.then(res => res.parse.text["*"]);
}

async function renderRightInfo(conn) {
	rightInfoConn = conn;
	const phxElement = conn.el;
	const page_id = phxElement.dataset.page_id;
	const open = phxElement.dataset.open;
	const text = await getPageText(page_id);

	d3.select(phxElement)
		.html(text)
		.style("width", open == "true" ? "35vw" : "0vw")
		.style("overflow", "hidden")
}

function mounted() {
	renderRightInfo(this);
}

function updated() {
	renderRightInfo(this);
}

const rightInfoHook = {
	mounted,
	updated
}

export default rightInfoHook;