@isTest
private class FlightSchedulerTest {

    @isTest
    static void testScheduler() {

        String cronExp = '0 0 6 * * ?';

        Test.startTest();

        System.schedule(
            'Flight Scheduler Test',
            cronExp,
            new FlightScheduler()
        );

        Test.stopTest();

        System.assertEquals(
            1,
            [SELECT Count()
             FROM CronTrigger
             WHERE CronJobDetail.Name = 'Flight Scheduler Test']
        );
    }
}