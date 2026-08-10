public with sharing class GroundServiceTaskService {

    // ============================================================
    // Called by Ground Service Task Trigger
    // ============================================================
    public static void afterUpdate(
        List<Ground_Service_Task__c> newTasks,
        Map<Id, Ground_Service_Task__c> oldMap
    ) {

        Set<Id> flightIds = new Set<Id>();

        for (Ground_Service_Task__c task : newTasks) {

            Ground_Service_Task__c oldTask = oldMap.get(task.Id);

            if (oldTask == null) {
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


    // ============================================================
    // Complete Ground Service Task
    // ============================================================
    public static void completeTask(Id taskId) {

    if (taskId == null) {
        throw new AuraHandledException(
            'Task Id is required.'
        );
    }

    Ground_Service_Task__c task = [
        SELECT Id,
               Task_Status__c,
               Completion_Notes__c
        FROM Ground_Service_Task__c
        WHERE Id = :taskId
        LIMIT 1
    ];

    // Prevent duplicate completion
    if (task.Task_Status__c == 'Completed') {
        throw new AuraHandledException(
            'This task is already completed.'
        );
    }

    // Complete the task
    task.Task_Status__c = 'Completed';

    // Required by Salesforce validation rule
    task.Completion_Notes__c =
        'Task completed successfully through Ground Operations Portal.';

    update task;
}
}