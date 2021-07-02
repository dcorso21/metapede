// import DateRangePicker from 'vanillajs-datepicker/DateRangePicker';
import DateRangePicker from "vanillajs-datepicker/js/DateRangePicker";
// import DateRangePicker from "path/to/node_modules/vanillajs-datepicker/js/DateRangePicker.js";



export default {
	mounted() {

		// console.log("Hello");
		new DateRangePicker(this.el)
	}
}