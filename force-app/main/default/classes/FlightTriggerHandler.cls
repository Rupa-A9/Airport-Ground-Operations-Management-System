public class FlightTriggerHandler {

    public static void preventDuplicateGateAssignment(
        List<Flight__c> newFlights,
        Map<Id, Flight__c> oldMap
    ) {

        Set<Id> gateIds = new Set<Id>();

        for (Flight__c flight : newFlights) {
            if (flight.Gate__c != null) {
                gateIds.add(flight.Gate__c);
            }
        }

        if (gateIds.isEmpty()) {
            return;
        }

        List<Flight__c> existingFlights = [
            SELECT Id,
                   Gate__c,
                   Scheduled_Arrival__c,
                   Scheduled_Departure__c
            FROM Flight__c
            WHERE Gate__c IN :gateIds
        ];

        for (Flight__c newFlight : newFlights) {

            if (newFlight.Gate__c == null ||
                newFlight.Scheduled_Arrival__c == null ||
                newFlight.Scheduled_Departure__c == null) {
                continue;
            }

            for (Flight__c existing : existingFlights) {

                if (existing.Id == newFlight.Id) {
                    continue;
                }

                if (existing.Gate__c == newFlight.Gate__c &&
                    existing.Scheduled_Arrival__c != null &&
                    existing.Scheduled_Departure__c != null &&
                    newFlight.Scheduled_Arrival__c < existing.Scheduled_Departure__c &&
                    newFlight.Scheduled_Departure__c > existing.Scheduled_Arrival__c) {

                    newFlight.Gate__c.addError(
                        'This gate is already assigned to another flight during the selected schedule.'
                    );
                }
            }
        }
    }
}