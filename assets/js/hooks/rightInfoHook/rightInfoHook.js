import * as d3 from "d3";
let rightInfoConn;
const base_url = "https://en.wikipedia.org/w/api.php";


function getPageText(page_id) {
	const query = base_url + `?action=parse&format=json&pageid=${page_id}&prop=text`
	console.log({ query });
	return fetch(query, {mode: "no-cors"}).then(res => res)
}

async function renderRightInfo(conn) {
	const phxElement = conn.el;
	const page_id = JSON.parse(phxElement.dataset.page_id);
	const text = await getPageText(page_id);

	d3.select(phxElement)
		.text(text)
}

function mounted() {
	rightInfoConn = this;
	renderRightInfo(this);
}

function updated() {
	rightInfoConn = this;
	renderRightInfo(this);
}

const rightInfoHook = {
	mounted,
	updated
}

export default rightInfoHook;