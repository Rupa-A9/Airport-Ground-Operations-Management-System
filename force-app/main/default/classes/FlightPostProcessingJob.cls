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

        // Background Task 1
        System.debug('Sending notification to Airport Operations');

        // Background Task 2
        System.debug('Creating audit records');

        // Background Task 3
        System.debug('Sending flight information to external airport system');

        // Background Task 4
        System.debug('Updating analytics');
    }
}