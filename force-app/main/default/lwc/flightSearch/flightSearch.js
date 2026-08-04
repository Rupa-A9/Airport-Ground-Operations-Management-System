import { LightningElement, track } from 'lwc';
import searchFlights from '@salesforce/apex/AirportService.searchFlights';

const COLUMNS = [
    { label: 'Flight Number', fieldName: 'Flight_Number__c' },
    { label: 'Airline', fieldName: 'Airline__c' },
    { label: 'Status', fieldName: 'Status__c' },
    { label: 'Terminal', fieldName: 'Terminal__c' },
    { label: 'Passenger Count', fieldName: 'Passenger_Count__c', type: 'number' }
];

export default class FlightSearch extends LightningElement {

    searchKey = '';
    @track flights = [];
    columns = COLUMNS;

    handleChange(event) {
        this.searchKey = event.target.value;
    }

    handleSearch() {
        searchFlights({ flightNumber: this.searchKey })
            .then(result => {
                this.flights = result;
            })
            .catch(error => {
                console.error(error);
            });
    }
}