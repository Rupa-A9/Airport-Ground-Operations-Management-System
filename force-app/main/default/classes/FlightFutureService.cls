public with sharing class FlightFutureService {

    @future
    public static void sendFlightNotification(Set<Id> flightIds) {

        List<Flight__c> flights = [
            SELECT Id,
                   Flight_Number__c,
                   Status__c
            FROM Flight__c
            WHERE Id IN :flightIds
        ];

        for (Flight__c flight : flights) {

            System.debug('Future Method Executed');
            System.debug('Flight Number: ' + flight.Flight_Number__c);
            System.debug('Flight Status: ' + flight.Status__c);

            // Example:
            // Send email
            // Call external system
            // Update logs
        }
    }
}