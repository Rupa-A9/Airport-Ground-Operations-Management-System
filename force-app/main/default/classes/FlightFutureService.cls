public with sharing class FlightFutureService {

    @future
    public static void sendFlightNotification(Id flightId) {

        Flight__c flight = [
            SELECT Id,
                   Flight_Number__c,
                   Status__c
            FROM Flight__c
            WHERE Id = :flightId
            LIMIT 1
        ];

        System.debug('Future Method Executed');
        System.debug('Flight Number: ' + flight.Flight_Number__c);
        System.debug('Flight Status: ' + flight.Status__c);

        // Example:
        // Send email
        // Call external system
        // Update logs
    }
}