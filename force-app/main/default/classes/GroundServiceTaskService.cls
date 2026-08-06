public with sharing class GroundServiceTaskService {

    public static void afterUpdate(
        List<Ground_Service_Task__c> newTasks,
        Map<Id, Ground_Service_Task__c> oldMap
    ) {

        Set<Id> flightIds = new Set<Id>();

        for (Ground_Service_Task__c task : newTasks) {

            Ground_Service_Task__c oldTask = oldMap.get(task.Id);
            if(oldTask == null){
                continue;
            }

            if (task.Task_Status__c == 'Completed'
                && oldTask.Task_Status__c != 'Completed'
                && task.Flight__c != null) {

                flightIds.add(task.Flight__c);
            }
        }

        if (!flightIds.isEmpty()) {
            FlightService.checkFlightReadiness(flightIds);
        }
    }

}