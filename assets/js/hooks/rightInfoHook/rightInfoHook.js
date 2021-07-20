import * as d3 from "d3";
let rightInfoConn;
const base_url = "https://en.wikipedia.org/w/api.php";


function getPageText(page_id) {
	var myHeaders = new Headers();
	myHeaders.append("Cookie", "GeoIP=US:FL:Ocala:29.00:-82.19:v4; WMF-Last-Access-Global=20-Jul-2021; WMF-Last-Access=20-Jul-2021");

	const baseURL = "https://en.wikipedia.org/w/api.php?origin=*&format=json&";
    const queryParams = "action=parse&prop=text&pageid=";

	var requestOptions = {
		method: 'GET',
		headers: myHeaders,
		redirect: 'follow'
	};

	return fetch(baseURL+queryParams+page_id, requestOptions)
        .then((res) => res.json())
        .then(res => res.parse.text["*"]);
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