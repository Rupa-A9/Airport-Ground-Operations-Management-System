import { LightningElement, track } from 'lwc';
import searchFlights from '@salesforce/apex/AirportService.searchFlights';
import syncFlightFromExternalSystem from '@salesforce/apex/AirportService.syncFlightFromExternalSystem';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const COLUMNS = [
    {
        label: 'Flight Number',
        fieldName: 'Flight_Number__c'
    },
    {
        label: 'Airline',
        fieldName: 'Airline__c'
    },
    {
        label: 'Status',
        fieldName: 'Status__c'
    },
    {
        label: 'Terminal',
        fieldName: 'Terminal__c'
    },
    {
        label: 'Passenger Count',
        fieldName: 'Passenger_Count__c',
        type: 'number'
    }
];

export default class FlightSearch extends LightningElement {

    searchKey = '';
    @track flights = [];
    columns = COLUMNS;
    isSyncing = false;

    handleChange(event) {
        this.searchKey = event.target.value;
    }

    handleSearch() {

        if (!this.searchKey) {
            this.showToast(
                'Error',
                'Please enter a flight number.',
                'error'
            );
            return;
        }

        searchFlights({
            flightNumber: this.searchKey
        })
        .then(result => {
            this.flights = result;
        })
        .catch(error => {

            this.flights = [];

            this.showToast(
                'Error',
                this.getErrorMessage(error),
                'error'
            );
        });
    }

    handleSync() {

        if (!this.searchKey) {
            this.showToast(
                'Error',
                'Please enter a flight number.',
                'error'
            );
            return;
        }

        this.isSyncing = true;

        syncFlightFromExternalSystem({
            flightNumber: this.searchKey
        })
        .then(result => {

            this.showToast(
                'Synchronization Started',
                result,
                'success'
            );

            // Search again after starting synchronization
            this.handleSearch();
        })
        .catch(error => {

            this.showToast(
                'Synchronization Failed',
                this.getErrorMessage(error),
                'error'
            );
        })
        .finally(() => {
            this.isSyncing = false;
        });
    }

    getErrorMessage(error) {

        if (
            error &&
            error.body &&
            error.body.message
        ) {
            return error.body.message;
        }

        return 'An unexpected error occurred.';
    }

    showToast(title, message, variant) {

        this.dispatchEvent(
            new ShowToastEvent({
                title: title,
                message: message,
                variant: variant
            })
        );
    }
}