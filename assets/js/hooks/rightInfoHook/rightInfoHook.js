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


function addFloating(open, text) {
	if (open == "true") {
		removeFloating();

		d3.select(".container")
			.append("div")
			.attr("class", "floating_info")
			.style("width", "35%")
			.style("transform", "translateY(5px)")
			.style("opacity", "0")
			.html(text)
	}
}

function showFloating(open) {
	if (open == "true") {
		d3.select(".floating_info")
			.transition()
			.duration(500)
			.style("transform", "translateY(0px)")
			.style("opacity", "1")
	}
}

function removeFloating() {
	d3.selectAll(".floating_info")
		.transition()
		.duration(500)
		.style("transform", "translateY(5px)")
		.style("opacity", "0")
		.on("end", select => select.remove())
}

async function renderRightInfo(conn) {
	rightInfoConn = conn;
	const phxElement = conn.el;
	const page_id = phxElement.dataset.page_id;
	const open = phxElement.dataset.open;
	const text = await getPageText(page_id);

	if (open != "true") {
		removeFloating();
	}

	addFloating(open, text);


	d3.select(phxElement)
		.transition()
		.duration(200)
		.ease(d3.easeBackIn)
		.style("width", open == "true" ? "40%" : "0vw")
		.on("end", () => showFloating(open))
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