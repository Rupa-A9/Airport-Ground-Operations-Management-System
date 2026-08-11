public with sharing class FlightOperationsSyncJob implements Queueable, Database.AllowsCallouts {

    private Set<Id> flightIds;

    public FlightOperationsSyncJob(Set<Id> flightIds) {
        this.flightIds = flightIds;
    }

    public void execute(QueueableContext context) {

        List<Flight__c> flights = [
            SELECT Id,
                   Flight_Number__c,
                   Status__c
            FROM Flight__c
            WHERE Id IN :flightIds
        ];

        for (Flight__c flight : flights) {

            if (String.isBlank(flight.Flight_Number__c)) {
                continue;
            }

            System.debug(
                'Synchronizing Flight: ' +
                flight.Flight_Number__c
            );

            FlightOperationsApiService.syncFlight(
                flight.Flight_Number__c
            );
        }

        System.debug(
            'Flight Operations synchronization completed.'
        );
    }
}