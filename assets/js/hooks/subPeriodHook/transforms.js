// @ts-check


import moment from "moment";

function flatten(periods) {
	let to_add = periods.map((p) => {
		if (p.expand && Array.isArray(p.sub_time_periods)) {
			return this.flatten(p.sub_time_periods);
		}
		return [];
	});

	let subs = to_add.reduce((a, b) => [...a, ...b], []);
	return [...periods, ...subs];
}

function transform(data) {
	if (!data.length) return data;

	data = flatten(data);

	let with_times = data.map((d) => {
		d.start = moment(d.start_datetime, moment.ISO_8601);
		d.end = moment(d.end_datetime, moment.ISO_8601);
		return d;
	});

	let beginning = with_times.reduce((a, b) => {
		return a.start < b.start ? a : b;
	}).start;

	let ending = with_times.reduce((a, b) => {
		return a.end > b.end ? a : b;
	}).end;

	let denom = moment(ending).diff(beginning);

	let periods = with_times.map((p) => {
		p.width = (moment(p.end).diff(p.start) / denom) * 100 + "%";
		p.ml = (moment(p.start).diff(beginning) / denom) * 100 + "%";
		return p;
	})

	return periods.sort((a, b) => {
		return a.start.unix() - b.start.unix();
	});
}

const subPeriodTransforms = {
	transform
}

export default subPeriodTransforms;