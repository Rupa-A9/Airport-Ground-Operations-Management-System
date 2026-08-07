public with sharing class FlightScheduler implements Schedulable {

    public void execute(SchedulableContext sc) {

        Database.executeBatch(
            new FlightBatchJob(),
            5
        );
    }
}