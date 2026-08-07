public with sharing class FlightBatchJob
implements Database.Batchable<SObject> {

    public Database.QueryLocator start(
        Database.BatchableContext bc
    ) {

        return Database.getQueryLocator([
            SELECT Id,
                   Flight_Number__c,
                   Status__c
            FROM Flight__c
            WHERE Status__c = 'Departed'
        ]);
    }

    public void execute(
        Database.BatchableContext bc,
        List<Flight__c> scope
    ) {

        for (Flight__c flight : scope) {

            System.debug(
                'Processing Flight: ' +
                flight.Flight_Number__c
            );

            // Example background work
            // Update analytics
            // Archive records
            // Send reports
        }
    }

    public void finish(
        Database.BatchableContext bc
    ) {

        System.debug(
            'Flight Batch Job Completed Successfully.'
        );
    }
}