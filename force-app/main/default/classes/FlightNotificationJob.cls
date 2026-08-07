public with sharing class FlightNotificationJob implements Queueable {

    private Set<Id> flightIds;

    public FlightNotificationJob(Set<Id> flightIds) {
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

            System.debug(
                'Sending notification for Flight: ' +
                flight.Flight_Number__c
            );

            // Example:
            // Send email
            // Send platform event
            // Notify airport staff
        }

        System.debug('Flight notifications completed.');
    }
}