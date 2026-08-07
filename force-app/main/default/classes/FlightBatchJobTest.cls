@isTest
private class FlightBatchJobTest {

    @isTest
    static void testFlightBatchJob() {

        List<Flight__c> flights = new List<Flight__c>();

        for (Integer i = 1; i <= 5; i++) {

            flights.add(new Flight__c(
                Flight_Number__c = 'AI20' + i,
                Status__c = 'Departed'
            ));
        }

        insert flights;

        Test.startTest();

        Database.executeBatch(new FlightBatchJob(), 5);

        Test.stopTest();

        System.assertEquals(
            5,
            [
                SELECT Count()
                FROM Flight__c
                WHERE Status__c = 'Departed'
            ]
        );
    }
}