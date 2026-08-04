public with sharing class FlightService {

    public static void checkFlightReadiness(Set<Id> flightIds) {

        if (flightIds.isEmpty()) {
            return;
        }

        // Get all Ground Service Tasks for the affected flights
        List<Ground_Service_Task__c> allTasks = [
            SELECT Id, Flight__c, Task_Status__c
            FROM Ground_Service_Task__c
            WHERE Flight__c IN :flightIds
        ];

        // Assume every flight is ready initially
        Map<Id, Boolean> flightReadyMap = new Map<Id, Boolean>();

        for (Id flightId : flightIds) {
            flightReadyMap.put(flightId, true);
        }

        // If any task is not completed, mark that flight as not ready
        for (Ground_Service_Task__c task : allTasks) {
            if (task.Task_Status__c != 'Completed') {
                flightReadyMap.put(task.Flight__c, false);
            }
        }

        List<Flight__c> flightsToUpdate = new List<Flight__c>();

        for (Id flightId : flightReadyMap.keySet()) {
            if (flightReadyMap.get(flightId)) {
                flightsToUpdate.add(
                    new Flight__c(
                        Id = flightId,
                        Status__c = 'Ready for Departure'
                    )
                );
            }
        }

        if (!flightsToUpdate.isEmpty()) {
            update flightsToUpdate;
        }
    }
}