import { LightningElement, wire } from 'lwc';
import getAllFlights from '@salesforce/apex/AirportService.getAllFlights';

const COLUMNS = [
    { label: 'Flight Number', fieldName: 'Flight_Number__c', type: 'text' },
    { label: 'Airline', fieldName: 'Airline__c', type: 'text' },
    { label: 'Status', fieldName: 'Status__c', type: 'text' },
    { label: 'Terminal', fieldName: 'Terminal__c', type: 'text' },
    { label: 'Passenger Count', fieldName: 'Passenger_Count__c', type: 'number' }
];

export default class FlightDashboard extends LightningElement {

    columns = COLUMNS;
    flights;
    error;

    @wire(getAllFlights)
    wiredFlights({ error, data }) {
        if (data) {
            this.flights = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.flights = undefined;
        }
    }
}