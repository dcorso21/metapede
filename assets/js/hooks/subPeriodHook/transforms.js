// @ts-check

import moment from "moment";

const subPeriodTransforms = {
	transform
}

export default subPeriodTransforms;


function transform(periods) {
	let flattened = [];

	let startTimes = [];
	let endTimes = [];

	makeRecords(periods);

	function sortByDateTime(periods) {
		let with_times = periods.map((d) => {
			d.start = moment(d.start_datetime, moment.ISO_8601).unix();
			d.end = moment(d.end_datetime, moment.ISO_8601).unix();

			startTimes.push(d.start)
			endTimes.push(d.end)
			return d;
		});

		return with_times.sort((a, b) => {
			return a.start - b.start;
		});
	}

	function makeRecords(periods) {
		let sorted = sortByDateTime(periods)
		sorted.map(p => {
			flattened.push(p)
			if (p.expand && Array.isArray(p.sub_time_periods)) {
				makeRecords(p.sub_time_periods)
			}
		})
	}

	let beginning = Math.min(...startTimes)
	let ending = Math.max(...endTimes)
	let denom = moment(ending).diff(beginning);
	return flattened.map(p => {
		p.width = (moment(p.end).diff(p.start) / denom) * 100 + "%";
		p.ml = (moment(p.start).diff(beginning) / denom) * 100 + "%";
		p.sub_time_periods = countSubPeriods(p)

		return p;
	})
}

function countSubPeriods(period) {
	const stps = period.sub_time_periods;
	const loaded = Array.isArray(stps)
	if (loaded && period.expand) return stps.length + 1;
	return 1;
}