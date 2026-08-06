public with sharing class FlightService {

    public static void checkFlightReadiness(Set<Id> flightIds) {

        if (flightIds == null || flightIds.isEmpty()) {
            return;
        }

        // Get all Ground Service Tasks for affected flights
        List<Ground_Service_Task__c> allTasks = [
            SELECT Id,
                   Flight__c,
                   Task_Status__c
            FROM Ground_Service_Task__c
            WHERE Flight__c IN :flightIds
        ];

        // Assume every flight is ready
        Map<Id, Boolean> flightReadyMap = new Map<Id, Boolean>();

        for (Id flightId : flightIds) {
            flightReadyMap.put(flightId, true);
        }

        // If any task is not completed, mark flight as not ready
        for (Ground_Service_Task__c task : allTasks) {

            if (task.Task_Status__c != 'Completed') {
                flightReadyMap.put(task.Flight__c, false);
            }

        }

        // Query existing flights
        Map<Id, Flight__c> flightMap = new Map<Id, Flight__c>([
            SELECT Id,
                   Status__c
            FROM Flight__c
            WHERE Id IN :flightIds
        ]);

        List<Flight__c> flightsToUpdate = new List<Flight__c>();

        for (Id flightId : flightReadyMap.keySet()) {

            if (flightReadyMap.get(flightId)) {

                Flight__c flight = flightMap.get(flightId);

                if (flight != null &&
                    flight.Status__c != 'Ready for Departure') {

                    flight.Status__c = 'Ready for Departure';
                    flightsToUpdate.add(flight);
                }
            }
        }

        if (!flightsToUpdate.isEmpty()) {

            // Update flights
            update flightsToUpdate;

            // Store ready flight IDs
            Set<Id> readyFlightIds = new Set<Id>();

            for (Flight__c flight : flightsToUpdate) {

                readyFlightIds.add(flight.Id);

                // Future Method
                FlightFutureService.sendFlightNotification(flight.Id);
            }

            // Queueable Job
            System.enqueueJob(
                new FlightPostProcessingJob(readyFlightIds)
            );
        }
    }
}