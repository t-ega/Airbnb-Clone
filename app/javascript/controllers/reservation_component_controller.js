import {Controller} from '@hotwired/stimulus'
import AirDatePicker from "air-datepicker"

export default class extends Controller {
    static targets = ["checkin", "checkout", "propertyPrice", "nightsCount"]
    localeEn = {
        days: ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'],
        daysShort: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
        daysMin: ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'],
        months: ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'],
        monthsShort: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
        today: 'Today',
        clear: 'Clear',
        dateFormat: 'MM/dd/yyyy',
        timeFormat: 'hh:mm aa',
        firstDay: 0
    };
    connect(){
        console.log("Inside the reservation component", this.buildSubmitUrl("/reservation/"))
        let dpMin, dpMax;


        dpMin = new AirDatePicker(this.checkinTarget, {
            onSelect: ({date}) => {
                const minDate = date.getDate() + 1
                dpMax.update({
                    minDate: date.setDate(minDate)
                })

                this.updatePropertyPrice()
            },
            locale: this.localeEn
        })

        dpMax = new AirDatePicker(this.checkoutTarget, {
            onSelect: ({date}) => {
                const maxDate = date.getDate() - 1
                dpMin.update({
                    maxDate: date.setDate(maxDate)
                })
                this.updatePropertyPrice()
            },
            locale: this.localeEn
        })

    }

    calculateDaysCount() {
        const checkinDate = new Date(this.checkinTarget.value)
        const checkoutDate = new Date(this.checkoutTarget.value)
        if (!checkinDate || !checkoutDate) return 1

        const differenceInMilliseconds = checkoutDate.getTime() - checkinDate.getTime();
        const days= Math.floor(differenceInMilliseconds / (1000 * 60 * 60 * 24)) || 1
        this.nightsCountTarget.innerText = days;
        return days
    }

    calculateTotal(){
        let price = this.element.dataset.unitPrice;
        const days = this.calculateDaysCount();
        return price * days;
    }

    updatePropertyPrice(){
        const amount = this.calculateTotal();
        this.propertyPriceTarget.innerText = `$${amount}`
    }

    buildQueryParams(){
        const params = {
            checkin_date: this.checkinTarget.value,
            checkout_date: this.checkoutTarget.value,
        }
        return new URLSearchParams(params).toString();
    }

    buildSubmitUrl(url){
        const queryParams = this.buildQueryParams();
        return `${url}?${queryParams}`
    }

    submitReservation(e) {
        const url = e.target.dataset.submitUrl;
        e.preventDefault()
        Turbo.visit(this.buildSubmitUrl(url));
    }

}