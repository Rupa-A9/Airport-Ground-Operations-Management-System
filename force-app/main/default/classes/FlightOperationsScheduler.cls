global with sharing class FlightOperationsScheduler implements Schedulable {

    global void execute(SchedulableContext sc) {

        List<Flight__c> flights = [
            SELECT Id, Flight_Number__c, Status__c
            FROM Flight__c
            WHERE Status__c NOT IN ('Departed', 'Cancelled')
            AND Flight_Number__c != null
        ];

        Set<Id> flightIds = new Set<Id>();

        for (Flight__c flight : flights) {
            flightIds.add(flight.Id);
        }

        if (!flightIds.isEmpty()) {
            System.enqueueJob(
                new FlightOperationsSyncJob(flightIds)
            );
        }
    }
}