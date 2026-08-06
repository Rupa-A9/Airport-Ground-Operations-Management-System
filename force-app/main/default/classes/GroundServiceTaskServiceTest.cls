@isTest
public class GroundServiceTaskServiceTest {

    @isTest
    static void testFlightReadyForDeparture() {

        Flight__c flight = new Flight__c(
            Flight_Number__c = 'AI101',
            Status__c = 'Scheduled'
        );
        insert flight;

        Ground_Service_Task__c task1 = new Ground_Service_Task__c(
            Flight__c = flight.Id,
            Task_Status__c = 'Pending',
            Task_Type__c = 'Cleaning'
        );

        Ground_Service_Task__c task2 = new Ground_Service_Task__c(
            Flight__c = flight.Id,
            Task_Status__c = 'Pending',
            Task_Type__c = 'Refueling'
        );

        insert new List<Ground_Service_Task__c>{ task1, task2 };

        Test.startTest();

        task1.Task_Status__c = 'Completed';
        task1.Completion_Notes__c = 'Task completed successfully.';
        update task1;

        Flight__c f1 = [
            SELECT Status__c
            FROM Flight__c
            WHERE Id = :flight.Id
        ];

        System.assertEquals(
            'Scheduled',
            f1.Status__c
        );

        task2.Task_Status__c = 'Completed';
        task2.Completion_Notes__c = 'Task completed successfully.';
        update task2;

        Test.stopTest();

        Flight__c f2 = [
            SELECT Status__c
            FROM Flight__c
            WHERE Id = :flight.Id
        ];

        System.assertEquals(
            'Ready for Departure',
            f2.Status__c
        );
    }

    @isTest
    static void testBulkFlightReadiness() {

        List<Flight__c> flights = new List<Flight__c>();

        for (Integer i = 1; i <= 5; i++) {

            flights.add(new Flight__c(
                Flight_Number__c = 'AI10' + i,
                Status__c = 'Scheduled'
            ));
        }

        insert flights;

        List<Ground_Service_Task__c> tasks = new List<Ground_Service_Task__c>();

        for (Flight__c flight : flights) {

            tasks.add(new Ground_Service_Task__c(
                Flight__c = flight.Id,
                Task_Status__c = 'Pending',
                Task_Type__c = 'Cleaning'
            ));

            tasks.add(new Ground_Service_Task__c(
                Flight__c = flight.Id,
                Task_Status__c = 'Pending',
                Task_Type__c = 'Refueling'
            ));
        }

        insert tasks;

        for (Ground_Service_Task__c task : tasks) {
            task.Task_Status__c = 'Completed';
            task.Completion_Notes__c = 'Completed during testing.';
        }

        Test.startTest();

        update tasks;

        Test.stopTest();

        List<Flight__c> updatedFlights = [
            SELECT Status__c
            FROM Flight__c
            WHERE Id IN :flights
        ];

        for (Flight__c flight : updatedFlights) {

            System.assertEquals(
                'Ready for Departure',
                flight.Status__c
            );
        }
    }
}