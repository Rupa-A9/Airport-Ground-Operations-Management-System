public with sharing class AirportService {

    // ============================
    // Get Flight Record
    // ============================
    public static Flight__c getFlight(Id flightId) {

        return [
            SELECT Id,
                   Name,
                   Flight_Number__c,
                   Airline__c,
                   Status__c,
                   Priority__c,
                   Passenger_Count__c,
                   Gate__c,
                   Aircraft__c
            FROM Flight__c
            WHERE Id = :flightId
            LIMIT 1
        ];
    }

    // ============================
    // Get Ground Crew Record
    // ============================
    public static Ground_Crew__c getGroundCrew(Id crewId) {

        return [
            SELECT Id,
                   Name,
                   Crew_Name__c,
                   Availability__c,
                   Department__c,
                   Shift__c
            FROM Ground_Crew__c
            WHERE Id = :crewId
            LIMIT 1
        ];
    }

    // ============================
    // Get Ground Service Task
    // ============================
    public static Ground_Service_Task__c getTask(Id taskId) {

        return [
            SELECT Id,
                   Name,
                   Task_Type__c,
                   Task_Status__c,
                   Priority__c,
                   Assigned_Crew__c,
                   Flight__c
            FROM Ground_Service_Task__c
            WHERE Id = :taskId
            LIMIT 1
        ];
    }

    // ============================
    // Check Crew Availability
    // ============================
    public static Boolean isCrewAvailable(Id crewId) {

        Ground_Crew__c crew = getGroundCrew(crewId);

        if (crew.Availability__c == 'Available') {
            return true;
        }

        return false;
    }

    // ============================
    // Validate Task Assignment
    // ============================
    public static Boolean validateTaskAssignment(
        Flight__c flight,
        Ground_Crew__c crew,
        Ground_Service_Task__c task
    ) {

        // Flight should not be completed or cancelled
        if (flight.Status__c == 'Completed' ||
            flight.Status__c == 'Cancelled') {

            return false;
        }

        // Crew should be available
        if (crew.Availability__c != 'Available') {

            return false;
        }

        // Task should be pending
        if (task.Task_Status__c != 'Pending') {

            return false;
        }

        return true;
    }

    // ============================
    // Assign Crew To Task
    // ============================
    public static void assignCrewToTask(Id taskId, Id crewId) {

        Ground_Service_Task__c task = getTask(taskId);

        task.Assigned_Crew__c = crewId;
        task.Task_Status__c = 'In Progress';

        update task;
    }

    
    // Update Flight Status
   



    
    public static void updateFlightStatus(Id flightId, String status) {

        Flight__c flight = getFlight(flightId);

        flight.Status__c = status;

        update flight;
    }
    
    @AuraEnabled(cacheable=true)
public static List<Flight__c> getAllFlights() {
    return [
        SELECT Id,
               Flight_Number__c,
               Airline__c,
               Status__c,
               Terminal__c,
               Passenger_Count__c
        FROM Flight__c
        ORDER BY Flight_Number__c
    ];
}

@AuraEnabled(cacheable=true)
public static List<Flight__c> searchFlights(String flightNumber) {

    return [
        SELECT Id,
               Flight_Number__c,
               Airline__c,
               Status__c,
               Terminal__c,
               Passenger_Count__c
        FROM Flight__c
        WHERE Flight_Number__c LIKE :('%' + flightNumber + '%')
        ORDER BY Flight_Number__c
    ];
}

}