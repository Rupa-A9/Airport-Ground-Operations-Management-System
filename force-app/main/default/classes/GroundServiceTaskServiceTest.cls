@isTest
public class GroundServiceTaskServiceTest {

    @isTest
    static void testFlightReadyForDeparture() {

        // Create Flight
        Flight__c flight = new Flight__c(
            Flight_Number__c = 'AI101',
            Status__c = 'Scheduled'
        );
        insert flight;

        // Create Ground Service Task 1
        Ground_Service_Task__c task1 = new Ground_Service_Task__c(
            Flight__c = flight.Id,
            Task_Status__c = 'Pending',
            Task_Type__c = 'Cleaning'
        );

        // Create Ground Service Task 2
        Ground_Service_Task__c task2 = new Ground_Service_Task__c(
            Flight__c = flight.Id,
            Task_Status__c = 'Pending',
            Task_Type__c = 'Fueling'
        );

        insert new List<Ground_Service_Task__c>{task1, task2};

        Test.startTest();

        // Complete first task
        task1.Task_Status__c = 'Completed';
        update task1;

        // Flight should NOT be ready yet
        Flight__c f1 = [
            SELECT Status__c
            FROM Flight__c
            WHERE Id = :flight.Id
        ];

        System.assertEquals(
            'Scheduled',
            f1.Status__c
        );

        // Complete second task
        task2.Task_Status__c = 'Completed';
        update task2;

        Test.stopTest();

        // Flight SHOULD be Ready for Departure
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

}