public with sharing class FlightPostProcessingJob implements Queueable {

    private Set<Id> flightIds;

    public FlightPostProcessingJob(Set<Id> flightIds) {
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

            System.debug('Creating audit for ' + flight.Flight_Number__c);
            System.debug('Updating analytics');
            System.debug('Sending data to external airport system');
        }

        // Queue the next Queueable
        System.enqueueJob(
            new FlightNotificationJob(flightIds)
        );
    }
}