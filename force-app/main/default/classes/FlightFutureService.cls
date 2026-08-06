public with sharing class FlightFutureService {

    @future
    public static void sendFlightNotification(Id flightId) {

        if (flightId == null) {
            return;
        }

        Flight__c flight = [
            SELECT Id,
                   Flight_Number__c,
                   Status__c
            FROM Flight__c
            WHERE Id = :flightId
            LIMIT 1
        ];

        System.debug('========== FUTURE METHOD EXECUTED ==========');
        System.debug('Flight Number: ' + flight.Flight_Number__c);
        System.debug('Flight Status: ' + flight.Status__c);

        // Future enhancement examples:
        // 1. Send email notification
        // 2. Call external airport system
        // 3. Create audit log
        // 4. Send SMS notification
        // 5. Publish platform event
    }
}